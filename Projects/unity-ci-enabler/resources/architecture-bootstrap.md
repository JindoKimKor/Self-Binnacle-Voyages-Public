# Unity CI Bootstrap — Architecture

## Scope

One-time 인프라 구축 + VM 이미지 준비. `unity-ci-bootstrap` repo에 해당하며, `unity-ci-function` repo가 동작할 기반을 만듦.

---

## Vision

One-time setup that:
1. Provisions all persistent cloud infrastructure (Function App, Batch, Key Vault, Image Gallery)
2. Prepares a specialized VM image with game-ci pre-loaded and Unity license activated
3. Registers GitHub webhook → Function App URL connection

완료 후 `unity-ci-function` repo가 Function App에 코드를 배포하면 CI 파이프라인이 동작함.

---

## Tech Stack

| Layer | Technology | Reason |
|-------|-----------|--------|
| Infrastructure as Code | Terraform (HCL) | Persistent + ephemeral infra split |
| VM provisioning | cloud-init | Declarative VM setup on first boot |
| Downloader CLI | Go | Unity version detection, Docker pull, license upload |
| GitHub auth | `gh` CLI + PAT (`GH_TOKEN`) | `GH_TOKEN` 환경변수로 자동 인증, OAuth 불필요 |
| Secret manager | Azure Key Vault | Unity license storage |
| Image gallery | Azure Shared Image Gallery | Specialized VM image storage |

---

## Architecture Flow

```
[User] az login + terraform apply (persistent)
  → Resource Group, Key Vault
  → Shared Image Gallery + Image Definition
  → Azure Batch Account
  → Function App (빈 상태 — unity-ci-function repo가 코드 배포)
  → GitHub Webhook → Function App URL 등록
  → Storage Account
    ↓
[User] fills .env (ADMIN_PASSWORD, REPO_URL, PLATFORM)
[User] runs scripts/sync-env.sh → generates terraform.tfvars
    ↓
[User] terraform apply (ephemeral)
  → VM spins up (cloud-init injects FUNCTION_URL, REPO_URL, PLATFORM)
    ↓
[cloud-init provisions VM]
  Ubuntu Desktop VM
  + noVNC (browser-based desktop access, port 6080)
  + Docker Engine
  + Git
  + GitHub CLI (gh)
  + Unity Hub (apt repo)
  + Environment variables (.unity-ci-env)
    ↓
[User connects via browser → noVNC desktop]
    ↓
[User manually — Part 1: License Activation]
  - Opens Unity Hub → logs in → activates license
  → License file generated + bound to VM machine ID
    ↓
[User manually — Part 2: game-ci Setup via downloader]
  - Runs downloader CLI on Desktop
  - GH_TOKEN env var → gh CLI auto-authenticated (REPO_URL from .unity-ci-env)
    → ProjectSettings/ProjectVersion.txt read
    → Unity version auto-detected
  - PLATFORM from .unity-ci-env (e.g. WebGL)
  → Pulls matching game-ci Docker image
  → License file → Azure Key Vault upload
  → Webhook secret 생성 → Key Vault 저장
  → GitHub Webhook 등록 (Function App URL)
    ↓
[Cleanup on VM — downloader가 자동 수행]
  - Unity Hub deleted (apt purge)
  - License file deleted from VM
    ↓
[User runs scripts/capture.sh from local machine]
  1. az vm deallocate (과금 중지)
  2. az sig image-version create (Shared Image Gallery에 캡처)
  3. az vm delete (VM 제거 — Terraform destroy 409 방지)
  4. terraform destroy -auto-approve (ephemeral infra 제거)
    ↓
[Output]
  - Specialized image stored in Gallery (machine ID preserved)
  - License stored in Key Vault
  - Webhook registered (GitHub → Function App)
  - Ephemeral resources destroyed
```

---

## Output (Deliverables)

Bootstrap가 완료되면 아래 전체가 준비된 상태. `unity-ci-function` repo가 이 위에서 동작함.

### 1. Build Artifacts

| Deliverable | Location | Description |
|-------------|----------|-------------|
| **Specialized VM Image** | Azure Shared Image Gallery (`latest`) | game-ci Docker image pre-loaded, machine ID preserved. 모든 Batch node가 이 이미지에서 스핀업 → 동일 machine ID → 라이선스 유효. 버전은 항상 `latest`로 publish |
| **Unity License** | Azure Key Vault (`UNITY-LICENSE`) | Unity Hub에서 활성화된 라이선스 파일. Build node가 런타임에 Key Vault에서 읽어서 컨테이너에 마운트 |

### 2. Persistent Infrastructure (unity-ci-function이 사용할 인프라)

| Resource | Purpose | unity-ci-function에서의 역할 |
|----------|---------|---------------------------|
| **Azure Function App** | Managed Identity + app_settings 포함, 코드는 빈 상태 | unity-ci-function repo가 webhook handler 코드를 배포하는 대상 |
| **Azure Batch Account** | 빈 상태로 생성됨 | Build job을 submit하는 대상 |
| **Shared Image Gallery** | VM image 저장 | Batch node가 이 image로 스핀업 |
| **Key Vault** | License + Webhook secret 저장 | Batch node가 license를, Function이 webhook secret을 읽음 |
| **Storage Account** | Function App 연결 | Function App 런타임 스토리지 |
| **Resource Group** | 전체 리소스 컨테이너 | 모든 리소스의 소속 |

### 3. Connections (Bootstrap이 설정하는 연결)

| Connection | Description |
|------------|-------------|
| **GitHub Webhook** | GitHub repo → Function App URL로 push event 전달 |
| **Function App Settings** | KEY_VAULT_NAME, BATCH_ACCOUNT_URL, IMAGE_RESOURCE_ID 환경변수 주입 |
| **Managed Identity → Key Vault** | Function App의 SystemAssigned identity에 Key Vault secret Get 권한 부여 (`azurerm_key_vault_access_policy`) |
| **Managed Identity → Batch Account** | Contributor role (`azurerm_role_assignment`) — Batch Job/Pool 생성 권한 |
| **Managed Identity → Image Gallery** | Reader role (`azurerm_role_assignment`) — autoPool이 Gallery image 참조 시 필요 |

### 4. Image 내용물

| Included | NOT Included |
|----------|-------------|
| Docker Engine | Unity Hub |
| game-ci container image | Unity license file |
| noVNC + desktop environment | User credentials |
| Git, GitHub CLI (gh) | .env, terraform state |

### 재실행 조건

| Trigger | Action |
|---------|--------|
| Unity 버전 변경 | Step 1 재실행 (새 game-ci image pull) |
| 플랫폼 변경 | Step 1 재실행 (다른 game-ci image) |

---

## Environment Variable System

```
.env.example (skeleton, committed)
    ↓ cp
.env (user fills ADMIN_PASSWORD, REPO_URL, PLATFORM)
    ↓ scripts/sync-env.sh
.env (auto-filled with terraform persistent outputs)
    ↓ scripts/sync-env.sh
terraform/ephemeral/terraform.tfvars (auto-generated)
```

### Variables

| Variable | Source | Description |
|----------|--------|-------------|
| ADMIN_PASSWORD | Manual | VM login password |
| REPO_URL | Manual | Unity project GitHub URL |
| PLATFORM | Manual | WebGL, Android, iOS, StandaloneLinux64, StandaloneWindows64 |
| GITHUB_TOKEN | Manual | GitHub PAT (`Contents: Read`, `Webhooks: Read and Write`) |
| RESOURCE_GROUP_NAME | Auto (terraform) | Azure resource group |
| KEY_VAULT_NAME | Auto (terraform) | Azure Key Vault name |
| FUNCTION_APP_URL | Auto (terraform) | Azure Function URL |
| FUNCTION_APP_NAME | Auto (terraform) | Azure Function name |
| BATCH_ACCOUNT_NAME | Auto (terraform) | Azure Batch account |
| IMAGE_GALLERY_NAME | Auto (terraform) | Shared Image Gallery |
| IMAGE_DEFINITION_NAME | Auto (terraform) | Image definition name |

> **Note:** cloud-init에서 `.unity-ci-env`에 변수를 쓸 때 반드시 `export` prefix 필요. 없으면 child process (downloader 바이너리)가 읽지 못함.

---

## Terraform Split

| Layer | Directory | Lifecycle | Resources |
|-------|-----------|-----------|-----------|
| Persistent | `terraform/persistent/` | Long-lived | RG, Key Vault, Image Gallery, Batch Account, Function App, Storage |
| Ephemeral | `terraform/ephemeral/` | Create → use → destroy | VNet, Subnet, NSG, NIC, Public IP, VM |

---

## Testing Strategy

| Layer | Tool | Scope | Speed | Cost |
|-------|------|-------|-------|------|
| Go code | `go test ./...` | Business logic, validation, GitHub API | Seconds | None |
| Terraform | `terraform test` (.tftest.hcl) | Variable validation, output structure | Seconds | None |
| cloud-init | Multipass (local) | VM boot validation | 5-10 min | None |
| License activation | Manual checklist | Human-interactive step | — | — |

---

## Key Design Decisions

- **Specialized image** (not generalized): preserves machine ID → Unity license remains valid across all Batch nodes
- **PAT (`GH_TOKEN`)** for GitHub auth: `gh auth login` 브라우저 플로우가 noVNC에서 복잡 → PAT 환경변수 방식으로 전환. `gh` CLI가 `GH_TOKEN` 자동 인식
- **Webhook registration in downloader**: downloader가 bootstrap 마지막 단계에서 webhook 등록 (secret 생성 → Key Vault 저장 → GitHub webhook 등록)
- **`lifecycle { ignore_changes = [access_policy] }`**: Key Vault inline `access_policy`와 별도 `azurerm_key_vault_access_policy` 리소스 충돌 방지. inline 블록이 complete list로 취급되어 별도 리소스가 추가한 policy를 매 apply마다 삭제하는 문제 해결
- **Function App code is NOT in bootstrap**: 빈 상태로 생성만 함. 코드는 `unity-ci-function` repo에서 독립 배포
- **Terraform persistent/ephemeral split**: persistent infra stays, ephemeral VM created and destroyed per setup
- **.env system**: skeleton (.env.example) + auto-fill (sync-env.sh) + tfvars generation
- **capture.sh로 후처리 자동화**: deallocate → capture → `az vm delete` → `terraform destroy`. `az vm delete`를 먼저 해야 terraform destroy 시 409 Conflict 방지 (azurerm provider가 deallocated VM power-off 시도 → 실패)
- **Downloader 배포**: Go 크로스 컴파일 (`GOOS=linux GOARCH=amd64`) → GitHub Release에 바이너리 업로드 → cloud-init에서 wget으로 자동 다운로드
- **OS 디스크 Premium_LRS**: Batch pool에서 이미지 사용 시 소스 디스크 타입 호환 필요

---

## Notes

- This step runs once per Unity version or platform change
- License activation requires manual user interaction (Unity Hub login)
- After cleanup, VM has no credentials — only game-ci image remains
- Re-activation: if license expires, re-run Step 1 with same image → same machine ID → Unity recognizes it
- Image Definition의 `hyper_v_generation`은 immutable — VM (V2)과 반드시 일치해야 함. 불일치 시 image-version 삭제 → definition 재생성 필요
- Git Bash (MINGW64)에서 Azure resource ID 사용 시 `MSYS_NO_PATHCONV=1` prefix 필요 (`/subscriptions/...`가 Windows 경로로 변환되는 것 방지)
- `az vm stop` vs `az vm deallocate`: stop은 하드웨어 유지(과금 계속), deallocate는 반납(과금 중지). Image 캡처는 둘 다 가능
