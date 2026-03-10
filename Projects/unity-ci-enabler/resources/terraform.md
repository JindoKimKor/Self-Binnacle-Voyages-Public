# Terraform Infrastructure — Unity CI Enabler

## 개요

Terraform은 **IaC(Infrastructure as Code)** 도구야. "어떻게 만들어"가 아니라 **"이런 상태여야 해"**를 선언하면, Terraform이 현재 상태와 비교해서 필요한 작업만 자동으로 실행해줘.

```
네가 선언  →  Terraform이 계획  →  Azure에 적용
(원하는 상태)   (plan)              (apply)
```

---

## 파일 구조

```
terraform/
├── main.tf        # 리소스 선언 (무엇을 만들지)
├── variables.tf   # 변수 정의 (입력값)
├── outputs.tf     # 출력값 정의 (결과로 뭘 받을지)
└── .terraform.lock.hcl  # provider 버전 고정 (자동 생성)
```

---

## main.tf — 리소스 선언

### Provider 설정

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

- `azurerm` = Azure Resource Manager provider. Terraform이 Azure API를 호출할 수 있게 해주는 플러그인.
- `~> 3.0` = 3.x 버전 사용 (4.x로 자동 업그레이드 안 됨).
- `features {}` = 필수 블록 (내용 비워도 됨).

### 인증 방식

`provider "azurerm"` 블록에 credentials를 넣지 않았어. 대신 **Azure CLI 인증**을 자동으로 사용해:

```
az login → 로그인 정보 저장 → Terraform이 자동으로 읽음
```

로컬 개발에서는 이 방식이 가장 간단해.

---

### 리소스 생성 순서

Terraform이 의존성을 분석해서 자동으로 순서를 결정해:

```
Resource Group
    ↓
VNet ── Public IP ── NSG
    ↓
  Subnet
    ↓
   NIC ──────────────── NSG (association)
    ↓
   VM
    ↓
Key Vault (VM의 Managed Identity principal_id가 필요해서 VM 이후)
```

실제 로그에서도 이 순서대로 생성된 걸 볼 수 있어:
1. `azurerm_resource_group.main` (9s)
2. `azurerm_public_ip`, `azurerm_virtual_network`, `azurerm_network_security_group` (병렬)
3. `azurerm_subnet`
4. `azurerm_network_interface`
5. `azurerm_network_interface_security_group_association`, `azurerm_linux_virtual_machine` (병렬)
6. `azurerm_key_vault` (VM의 identity.principal_id를 알아야 access_policy 설정 가능)

### VM 설정

```hcl
resource "azurerm_linux_virtual_machine" "main" {
  size           = var.vm_size          # Standard_D4s_v3 (4 vCPU, 16GB RAM)
  admin_username = var.admin_username   # azureuser
  admin_password = var.admin_password   # 변수로 주입 (sensitive)

  disable_password_authentication = false  # 비밀번호 로그인 허용

  custom_data = filebase64("${path.module}/../cloud-init/cloud-init.yaml")
  # VM 첫 부팅 시 자동 실행할 스크립트 (base64로 인코딩해서 전달)

  identity {
    type = "SystemAssigned"  # Managed Identity 활성화
  }
}
```

**Managed Identity**: VM이 Azure 내부에서 실행될 때 자동으로 부여받는 identity. 별도 credentials 없이 Key Vault 등 Azure 서비스에 접근 가능.

### NSG (Network Security Group)

방화벽 역할. 어떤 포트를 열지 선언:

```hcl
security_rule {
  name                   = "allow-novnc"
  priority               = 100
  destination_port_range = "6080"   # noVNC 브라우저 접속
  access                 = "Allow"
}

security_rule {
  name                   = "allow-ssh"
  priority               = 110
  destination_port_range = "22"     # SSH 접속
  access                 = "Allow"
}
```

### Key Vault

Unity 라이선스를 저장하는 Azure Key Vault:

```hcl
resource "azurerm_key_vault" "main" {
  name      = var.key_vault_name  # 전 세계에서 유일해야 함
  tenant_id = data.azurerm_client_config.current.tenant_id

  access_policy {
    object_id = azurerm_linux_virtual_machine.main.identity[0].principal_id
    secret_permissions = ["Get", "Set", "List"]
  }
}
```

VM의 Managed Identity에게만 secret 읽기/쓰기 권한 부여.

---

## variables.tf — 변수 정의

| 변수 | 기본값 | 설명 |
|------|--------|------|
| `location` | `canadacentral` | Azure 리전 |
| `resource_group_name` | `unity-ci-enabler-rg` | 리소스 그룹 이름 |
| `vm_size` | `Standard_D4s_v3` | VM 사양 (4 vCPU, 16GB RAM) |
| `admin_username` | `azureuser` | VM 관리자 계정 |
| `admin_password` | *(필수 입력)* | VM 비밀번호 (`sensitive = true`) |
| `key_vault_name` | *(필수 입력)* | Key Vault 이름 (전역 유일) |

`sensitive = true`로 표시된 변수는 로그/출력에 값이 표시되지 않아.

---

## outputs.tf — 출력값

```hcl
output "public_ip_address" { ... }  # VM 공인 IP
output "vm_id"             { ... }  # VM 리소스 ID
output "novnc_url"         { ... }  # http://<ip>:6080
```

`terraform apply` 완료 후 출력되고, Terratest에서 `terraform.Output(t, opts, "novnc_url")`로 읽어.

---

## Terraform 명령어

```bash
# 초기화 (provider 플러그인 다운로드)
terraform init

# 변경 사항 미리 보기 (실제 적용 안 함)
terraform plan

# 실제 적용
terraform apply

# 전체 삭제
terraform destroy

# 현재 상태 확인
terraform show
```

### init vs plan vs apply

```
init   →  plan    →  apply
설치      미리보기    실행
```

| 명령어 | 하는 일 | 실제 변경? | 언제 실행? |
|--------|---------|-----------|-----------|
| `init` | provider 플러그인 다운로드 + 백엔드 초기화 | X | 처음 한 번, provider 추가/변경 시 |
| `plan` | 현재 상태 vs 코드 비교 → 만들/바꿀/지울 리소스 미리보기 (dry run) | X | apply 전에 확인용 |
| `apply` | plan 결과를 실제로 실행 → Azure에 리소스 생성/변경/삭제 | **O** | 실제 배포 시 |

`plan` 출력 기호:
- `+` = 새로 만들기
- `~` = 변경
- `-` = 삭제

---

## 로컬 개발 vs 실제 운영 인증 비교

| 상황 | 인증 방법 |
|------|-----------|
| 로컬에서 `terraform apply` / Terratest | `az login` (Azure CLI) |
| Azure VM이 Key Vault 접근 | Managed Identity (자동, credentials 불필요) |
| GitHub Actions에서 `terraform apply` | Service Principal (환경변수 주입) |

---

## Terraform이 클라우드 개발을 쉽게 만드는 이유

실제 개발 중 경험한 사례:

### 1. 권한 누락 → 코드 한 줄로 해결

Function App이 Batch API를 호출했더니 403 PermissionDenied 발생. 원인: Managed Identity에 Batch Account 권한이 없었음.

```hcl
# main.tf에 추가
resource "azurerm_role_assignment" "function_batch_contributor" {
  scope                = azurerm_batch_account.main.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_linux_function_app.main.identity[0].principal_id
}
```

`terraform apply` 한 번이면 끝. Azure Portal에서 RBAC 메뉴 찾아 돌아다닐 필요 없음.

### 2. 환경 재현이 완벽함

리소스를 전부 삭제하고 `terraform apply`하면 동일한 환경이 재현됨. 수동 설정이면 "그때 그 권한 뭐였더라..." 하고 찾아다녀야 함.

### 3. 인프라 변경이 코드로 추적됨

git diff로 "이번에 뭐가 바뀌었는지" 정확히 보임:
- Key Vault access policy 추가
- Batch Account role assignment 추가
- Function App app_settings 변경

수동으로 했으면 Azure Activity Log를 뒤져야 함.

---

## Terratest (TDD)

Terraform 인프라를 Go 코드로 테스트:

```
Red   → go test 실행 → az 미로그인으로 실패
Green → az login → go test → 실제 VM 생성 → noVNC 응답 확인 → terraform destroy
```

테스트 파일: `test/terraform_test.go`

```go
opts := &terraform.Options{
    TerraformDir:    "../terraform",
    TerraformBinary: `C:\...\terraform.exe`,  // terraform 경로 (winget 설치 시 PATH 미등록)
    Vars: map[string]interface{}{
        "admin_password": "TestP@ssw0rd123!",
        "key_vault_name": "unity-ci-test-kv",
    },
}
defer terraform.Destroy(t, opts)  // 테스트 후 자동 삭제
terraform.InitAndApply(t, opts)
```
