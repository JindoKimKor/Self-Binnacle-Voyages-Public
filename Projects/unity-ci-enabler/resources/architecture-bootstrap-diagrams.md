# Unity CI Bootstrap — Diagrams

## 0. Prerequisites

### Local Machine (User)

| Requirement | Purpose | Setup |
|-------------|---------|-------|
| **Azure CLI** (`az`) | Azure 리소스 관리, VM 제어 | `winget install Microsoft.AzureCLI` |
| **Terraform** | Infrastructure as Code | `winget install Hashicorp.Terraform` |
| **Go** (1.21+) | Downloader 빌드 (optional — Release에서 다운로드 가능) | `winget install GoLang.Go` |
| **Git Bash** or **WSL** | Bash 스크립트 실행 (capture.sh, sync-env.sh, build.sh) | Git for Windows 포함 |
| **GitHub CLI** (`gh`) | Release 생성 (optional — 개발자용) | `winget install GitHub.cli` |

### Accounts & Credentials

| Requirement | Purpose | 생성 방법 |
|-------------|---------|----------|
| **Azure Subscription** | 모든 클라우드 리소스 호스팅 | [portal.azure.com](https://portal.azure.com) |
| **Azure Login** (`az login`) | Terraform + az CLI 인증 | `az login` (브라우저 OAuth) |
| **GitHub PAT** (`GH_TOKEN`) | Webhook 등록 + Unity 버전 감지 | GitHub → Settings → Developer settings → Fine-grained tokens |
| **Unity Account** | Unity Hub 라이선스 활성화 | [id.unity.com](https://id.unity.com) |

### GitHub PAT 권한 (Fine-grained)

| Permission | Access | Purpose |
|------------|--------|---------|
| **Contents** | Read | `ProjectVersion.txt` 읽기 (Unity 버전 감지) |
| **Webhooks** | Read and Write | Webhook 등록/조회 |

> **Scope:** 대상 Unity 프로젝트 repo에만 접근 권한 부여 (all repositories 아님)

### Unity Project (대상 repo)

| Requirement | Description |
|-------------|-------------|
| `ProjectSettings/ProjectVersion.txt` | Unity 버전 자동 감지에 필요 (`m_EditorVersion: 2022.2.1f1` 형식) |
| game-ci 지원 버전 | [game.ci/docs/docker](https://game.ci/docs/docker) 에서 지원 버전 확인 |

---

## 1. Bootstrap Sequence (Full Workflow)

```mermaid
sequenceDiagram
    actor User
    participant TF_P as Terraform (persistent)
    participant Azure as Azure Cloud
    participant TF_E as Terraform (ephemeral)
    participant VM as Bootstrap VM
    participant GH as GitHub

    Note over User,Azure: Phase 1 — Persistent Infrastructure
    User->>TF_P: terraform apply
    TF_P->>Azure: Create Resource Group
    TF_P->>Azure: Create Key Vault
    TF_P->>Azure: Create Image Gallery + Definition (V2)
    TF_P->>Azure: Create Batch Account
    TF_P->>Azure: Create Function App (identity + app_settings, code empty)
    TF_P->>Azure: Create Storage Account
    TF_P->>Azure: Grant Function App identity → Key Vault Get
    TF_P->>Azure: Grant Function App identity → Batch Contributor
    TF_P->>Azure: Grant Function App identity → Gallery Reader
    TF_P-->>User: outputs (RG, KV, Gallery, Batch, Function URL)

    Note over User: Phase 2 — Environment Setup
    User->>User: Fill .env (ADMIN_PASSWORD, REPO_URL, PLATFORM, GITHUB_TOKEN)
    User->>User: Run scripts/sync-env.sh
    Note right of User: .env → terraform.tfvars

    Note over User,VM: Phase 3 — Ephemeral VM
    User->>TF_E: terraform apply
    TF_E->>Azure: Create VNet, Subnet, NSG, NIC, Public IP
    TF_E->>Azure: Create VM (cloud-init injected)
    Azure->>VM: Boot + cloud-init
    VM->>VM: Install Docker, Git, gh CLI, Unity Hub
    VM->>VM: Download downloader (GitHub Release)
    VM->>VM: Write .unity-ci-env (export vars)
    VM->>VM: Start noVNC (port 6080)
    VM-->>User: noVNC ready

    Note over User,VM: Phase 4 — Manual Setup (noVNC)
    User->>VM: Connect via browser
    VM->>VM: Auto-open terminal (run-bootstrap.sh)
    User->>VM: Open Unity Hub → activate license
    User->>VM: Press Enter in terminal
    VM->>GH: Fetch ProjectVersion.txt (gh api)
    GH-->>VM: Unity version (e.g. 2022.2.1f1)
    VM->>VM: docker pull game-ci image
    VM->>Azure: Upload license → Key Vault
    VM->>Azure: Upload webhook secret → Key Vault
    VM->>GH: Register webhook (Function App URL)
    VM->>VM: Delete Unity Hub + license file
    VM-->>User: "Bootstrap Complete"

    Note over User,Azure: Phase 5 — Capture (scripts/capture.sh)
    User->>Azure: az vm deallocate
    User->>Azure: az sig image-version create
    User->>Azure: az vm delete
    User->>Azure: az disk delete
    User->>TF_E: terraform destroy
    TF_E->>Azure: Destroy VNet, Subnet, NSG, NIC, Public IP
```

## 2. Infrastructure Component Diagram

```mermaid
graph TB
    subgraph Persistent["Persistent Infrastructure (terraform/persistent)"]
        RG[Resource Group]
        KV[Key Vault<br/>UNITY-LICENSE<br/>WEBHOOK-SECRET]
        Gallery[Image Gallery]
        ImgDef[Image Definition<br/>V2, Specialized]
        ImgVer[Image Version 1.0.0]
        Batch[Batch Account]
        FuncApp[Function App<br/>identity + app_settings<br/>code from unity-ci-function]
        Storage[Storage Account]

        RG --> KV
        RG --> Gallery
        Gallery --> ImgDef
        ImgDef --> ImgVer
        RG --> Batch
        RG --> FuncApp
        RG --> Storage
        Storage -.-> FuncApp
        KV -.->|"identity: Get"| FuncApp
        Batch -.->|"identity: Contributor"| FuncApp
        Gallery -.->|"identity: Reader"| FuncApp
    end

    subgraph Ephemeral["Ephemeral Infrastructure (terraform/ephemeral)"]
        VNet[VNet 10.0.0.0/16]
        Subnet[Subnet 10.0.1.0/24]
        NSG[NSG<br/>:6080 noVNC<br/>:22 SSH]
        NIC[Network Interface]
        PIP[Public IP]
        VM[Linux VM<br/>Standard_D4s_v3<br/>Premium_LRS 128GB]

        VNet --> Subnet
        Subnet --> NIC
        NSG --> NIC
        PIP --> NIC
        NIC --> VM
    end

    VM -->|"capture"| ImgVer
    VM -->|"upload license"| KV

    subgraph External
        GitHub[GitHub Repo]
        Webhook[Webhook<br/>push events]
    end

    GitHub -->|webhook| FuncApp
    Webhook -.-> FuncApp

    style Ephemeral fill:#d4a0a0,stroke:#8b0000,color:#1a1a1a
    style Persistent fill:#8fbc8f,stroke:#2e5a2e,color:#1a1a1a
    style External fill:#8fa8c8,stroke:#2b4570,color:#1a1a1a
```

## 3. Downloader Pipeline (VM 내부)

```mermaid
sequenceDiagram
    participant Terminal as Terminal<br/>(run-bootstrap.sh)
    participant DL as Downloader<br/>(Go binary)
    participant GH as GitHub API<br/>(via gh CLI)
    participant Docker as Docker Engine
    participant KV as Azure Key Vault<br/>(via az CLI)

    Terminal->>Terminal: source ~/.unity-ci-env
    Terminal->>Terminal: Wait for Enter (license activation)
    Terminal->>DL: Execute ~/Desktop/downloader

    Note over DL: Unity Version Detection
    DL->>GH: GET repos/{owner}/{repo}/contents/ProjectSettings/ProjectVersion.txt
    GH-->>DL: base64 content
    DL->>DL: Parse m_EditorVersion: 2022.2.1f1

    Note over DL: Docker Image Pull
    DL->>DL: Validate version + platform
    DL->>Docker: docker pull unityci/editor:ubuntu-{version}-{platform}
    Docker-->>DL: Pull complete

    Note over DL: License Upload
    DL->>DL: Find license file (~/.config/unity3d/Unity/...)
    DL->>KV: az keyvault secret set --name UNITY-LICENSE
    KV-->>DL: OK

    Note over DL: Webhook Setup
    DL->>DL: Generate 32-byte hex secret
    DL->>KV: az keyvault secret set --name WEBHOOK-SECRET
    KV-->>DL: OK
    DL->>GH: GET repos/{owner}/{repo}/hooks (check existing)
    GH-->>DL: [] (empty)
    DL->>GH: POST repos/{owner}/{repo}/hooks (create)
    GH-->>DL: {id: 123}

    Note over DL: Cleanup
    DL->>DL: Delete license files (os.Remove)
    DL->>DL: sudo apt-get purge -y unityhub
    DL-->>Terminal: "Bootstrap Complete"
```

## 4. capture.sh Flow

```mermaid
sequenceDiagram
    actor User
    participant Script as capture.sh
    participant Azure as Azure Cloud
    participant TF as Terraform

    User->>Script: bash scripts/capture.sh
    Script->>Script: Read .env (RG, GALLERY, IMAGE_DEF)
    Script->>Script: export MSYS_NO_PATHCONV=1

    rect rgb(255, 245, 230)
        Note over Script,Azure: Step 1/5: Deallocate
        Script->>Azure: az vm deallocate
        Azure-->>Script: VM deallocated (billing stops)
    end

    rect rgb(230, 255, 230)
        Note over Script,Azure: Step 2/5: Capture Image
        Script->>Azure: az vm show → get VM ID
        Script->>Azure: az sig image-version create (1.0.0)
        Azure-->>Script: Image captured to gallery
    end

    rect rgb(255, 230, 230)
        Note over Script,Azure: Step 3/5: Delete VM
        Script->>Azure: az vm show → get OS disk ID
        Script->>Azure: az vm delete --yes
        Azure-->>Script: VM deleted
    end

    rect rgb(255, 230, 230)
        Note over Script,Azure: Step 4/5: Delete OS Disk
        Script->>Azure: az disk delete --ids $OS_DISK --yes
        Azure-->>Script: Disk deleted
    end

    rect rgb(230, 230, 255)
        Note over Script,TF: Step 5/5: Destroy Ephemeral
        Script->>TF: terraform destroy -auto-approve
        TF->>Azure: Destroy VNet, Subnet, NSG, NIC, Public IP
        TF-->>Script: Destroyed
    end

    Script-->>User: "Capture complete — Image: gallery/def/1.0.0"
```

## 5. Bootstrap 완료 후 결과물

```mermaid
graph LR
    subgraph Outputs["Bootstrap Outputs"]
        direction TB
        Image["Specialized VM Image<br/>Gallery/Definition/1.0.0<br/>─────────────────<br/>Docker Engine ✓<br/>game-ci container ✓<br/>machine ID preserved ✓<br/>─────────────────<br/>Unity Hub ✗<br/>License file ✗<br/>User credentials ✗"]
        License["Key Vault Secrets<br/>─────────────────<br/>UNITY-LICENSE<br/>WEBHOOK-SECRET"]
        Webhook["GitHub Webhook<br/>─────────────────<br/>push events →<br/>Function App URL"]
        Infra["Persistent Infrastructure<br/>─────────────────<br/>Function App (identity + settings)<br/>Batch Account (empty)<br/>Image Gallery<br/>Storage Account"]
    end

    subgraph Destroyed["Destroyed (Ephemeral)"]
        direction TB
        D1[VM]
        D2[VNet / Subnet / NSG]
        D3[Public IP / NIC]
        D4[OS Disk]
    end

    subgraph Next["Next Step"]
        Function["unity-ci-function repo<br/>─────────────────<br/>Function App에<br/>webhook handler 배포<br/>→ CI 파이프라인 동작"]
    end

    Outputs --> Next
    Destroyed -.->|"deleted"| Destroyed

    style Outputs fill:#8fbc8f,stroke:#2e5a2e,color:#1a1a1a
    style Destroyed fill:#d4a0a0,stroke:#8b0000,color:#1a1a1a
    style Next fill:#8fa8c8,stroke:#2b4570,color:#1a1a1a
```

### 재실행 조건

| Trigger | Action |
|---------|--------|
| Unity 버전 변경 | Phase 3~5 재실행 (새 game-ci image pull → 새 image capture) |
| 플랫폼 변경 (e.g. WebGL → Android) | Phase 3~5 재실행 (다른 game-ci image) |
