# Unity CI Enabler — Architecture

## Vision

Plug-and-play Unity CI/CD infrastructure that works on any cloud provider. No DevOps or cloud expertise required.

Based on VARLab's serverless approach (94.88% cost reduction), democratized for the Unity developer community.

---

## Tech Stack

| Layer | Technology | Reason |
|-------|-----------|--------|
| Entry point | GitHub App | Plug-and-play trigger — no DevOps knowledge required |
| Orchestration language | Go | Single codebase compiles for all cloud serverless runtimes |
| Infrastructure as Code | Terraform (HCL) | Same syntax across all cloud providers, just swap provider |
| Serverless runtime | Azure Functions / AWS Lambda / GCF | Platform-native orchestration per cloud |
| VM infrastructure | Azure VM / EC2 / GCE | Unity build execution environment |

---

## Architecture Layers

### Step 1: VM Setup (One-time per Unity project/version)

> Goal: Prepare a VM with game-ci image loaded and Unity license activated, then store the license in the cloud secret manager.

```
[GitHub App — Installation webhook]
  User installs Unity CI Enabler GitHub App on their repo
    ↓
[Serverless Function — Setup Orchestrator]
  Azure Functions | AWS Lambda | GCF
    ↓
[Terraform — VM Provisioning]
  Ubuntu Desktop VM (Azure VM / EC2 / GCE)
  + noVNC installed (browser-based desktop access)
  + Docker Engine installed
  + Git installed
  + Unity Hub installer pre-downloaded to Desktop folder
  + game-ci downloader program pre-placed on Desktop
    ↓
[User connects via browser → noVNC desktop]
    ↓
[User manually — Part 1: License Activation]
  - Clicks Unity Hub installer on Desktop → installs
  - Logs in with their Unity account
  - Activates license
  → License file generated + bound to VM machine ID
    ↓
[User manually — Part 2: game-ci Setup]
  - Double-clicks game-ci downloader on Desktop
  - Selects Unity version (e.g. 2022.3.10f1)
  - Selects target platform (e.g. Android, iOS, WebGL...)
  → Pulls matching game-ci container image via Docker
    ↓
[License file → Cloud Secret Manager]
  - Azure → Azure Key Vault
  - AWS   → AWS Secrets Manager
  - GCP   → GCP Secret Manager
  (Note: license is NOT stored in GitHub Secrets — only cloud credentials and CI_FUNCTION_URL go there)
    ↓
[VM captured as image → Image Gallery]
  Azure → Shared Image Gallery
  AWS   → AMI (Amazon Machine Image)
  GCP   → Custom Image
    ↓
[Cleanup on VM]
  - Unity Hub deleted
  - License file deleted from VM
    ↓
[Output]
  - Image stored in Gallery (game-ci pre-loaded)
  - License stored in Cloud Secret Manager (Azure Key Vault / AWS Secrets Manager / GCP Secret Manager)
  - Original VM can be deleted
```

**Notes:**
- This step runs once per Unity version or platform change
- The user must interact manually during the license activation phase (TBD: can this be automated?)
- After cleanup, the VM has no credentials — only the game-ci image remains

---

### Step 2: Build Execution (Per CI trigger)

> Goal: On every GitHub push/PR, spin up a build node from the stored image, run Unity build, deliver artifacts, then tear down.

```
[GitHub push / PR trigger]
    ↓
[GitHub App — Webhook receiver]
  Receives push/PR events automatically
  No GitHub Actions workflow required
    ↓
[Serverless Function — Build Orchestrator]
  Azure Functions | AWS Lambda | GCF
    ↓
[Build node provisioned from Image Gallery]
  Azure → Shared Image Gallery → Azure Batch node
  AWS   → AMI → EC2 instance
  GCP   → Custom Image → GCE instance
  (game-ci already pre-loaded in image)
    ↓
[License written to build node from Cloud Secret Manager]
  Azure Key Vault: UNITY-LICENSE → written to /tmp/Unity_lic.ulf
    ↓
[Source code cloned into build node]
  git clone {user's repo} /project
    ↓
[game-ci container runs Unity build]
  docker run --rm -i \
    -v /project/Builds:/project/Builds \
    -v /tmp/Unity_lic.ulf:/root/.local/share/unity3d/Unity/Unity_lic.ulf \
    {game-ci-image} /bin/bash -s

  Inside container:
    xvfb-run -a /opt/unity/Editor/Unity \
      -projectPath /project \
      -batchmode \
      -buildTarget {platform} \
      -executeMethod Builder.Build{Platform} \
      -quit
    ↓
[Artifacts uploaded to Cloud Object Storage]
  Azure → Blob Storage
  AWS   → S3
  GCP   → GCS (Google Cloud Storage)
    ↓
[Build node teardown]
  - Node deleted → cost control
    ↓
[Build result reported back to GitHub]
  - Success / Failure status
  - Artifact location
```

**Notes:**
- Build node is ephemeral — spun up per build, torn down after
- License machine ID binding: TBD (needs verification with game-ci container behavior)
- Artifact storage: Azure Blob Storage / AWS S3 / GCP GCS
- GitHub Secrets required: cloud credentials only (NOT the Unity license — that lives in Cloud Secret Manager)

---

### Layer 3: Multi-Cloud Abstraction (TBD)
> How does the user select and configure their cloud provider?

- [ ] Option A: Single config file (`config.yaml`) — `provider: azure | aws | gcp`
- [ ] Option B: Cloud-specific deployment packages
- [ ] Option C: Other

---

## Cloud Provider Matrix

| Capability | Azure | AWS | GCP |
|------------|-------|-----|-----|
| Serverless runtime | Azure Functions (Custom Handler) | Lambda | Cloud Functions |
| VM compute | Azure VM | EC2 | Compute Engine |
| Terraform provider | `azurerm` | `aws` | `google` |
| Go support | Custom Handler | Native | Native |
| Status | In progress | TBD | TBD |

---

## Testing Strategy

### Overview

| Layer | Tool | Scope | Speed | Cost |
|-------|------|-------|-------|------|
| Go code | `go test` (unit) | Business logic, API calls, CLI | Seconds | None |
| Terraform | Terratest | Real Azure infra provisioning | 10–20 min | Azure cost |
| cloud-init | Multipass | Local Ubuntu VM boot validation | 5–10 min | None |
| License Activation | Manual checklist | Human-interactive step | — | — |
| VM Image Capture | Terratest (end-to-end) | Included in Terraform test flow | 20–30 min | Azure cost |

### Go Unit Tests (`go test`)

Test-first for all Go business logic. Cloud boundaries mocked.

- HTTP trigger handler (fire-and-forget pattern)
- Terraform invocation logic
- CLI input validation (Unity version format, platform selection)
- GitHub Secrets API call
- Azure Key Vault API call

### Terratest (Infrastructure)

Provisions real Azure resources, validates, then destroys.

```go
func TestTerraformAzureVM(t *testing.T) {
    opts := &terraform.Options{TerraformDir: "./terraform"}
    defer terraform.Destroy(t, opts)
    terraform.InitAndApply(t, opts)

    ip := terraform.Output(t, opts, "public_ip_address")
    assert.NotEmpty(t, ip)
    // Validate noVNC accessible on port 6080
    // Validate SSH reachable on port 22
}
```

- Runs in CI (GitHub Actions) on PR to main
- Azure cost incurred per test run

### Multipass (cloud-init)

Spins up local Ubuntu VM with the cloud-init script. Faster feedback than Azure.

```bash
multipass launch --cloud-init cloud-init.yaml --name test-vm
multipass exec test-vm -- docker --version
multipass exec test-vm -- systemctl is-active novnc
multipass exec test-vm -- git --version
multipass exec test-vm -- ls ~/Desktop
multipass delete test-vm --purge
```

- Not 100% identical to Azure environment but catches most issues
- No cloud cost

### Manual Verification Checklist

Steps that cannot be automated:

- [ ] noVNC browser access opens correctly
- [ ] Unity Hub installer launches on Desktop double-click
- [ ] Unity license activates successfully
- [ ] game-ci downloader CLI runs and prompts correctly
- [ ] VM image captured and visible in Azure Shared Image Gallery

---

## Open Questions

- [x] **Entry point**: GitHub App webhook → Serverless Function (plug-and-play, no DevOps knowledge required)
- [x] **Unity License**: Stored in Cloud Secret Manager (Azure Key Vault); written to build node at runtime
- [x] **Artifact storage**: Azure Blob Storage / AWS S3 / GCP GCS
- [ ] **Multi-cloud config**: Single config file approach vs. per-provider packages?
- [ ] **Terraform state**: Where is state stored? (local vs. remote backend)
- [ ] **Auth/Credentials**: How does the user provide cloud credentials?

---

## Current State (as of 2026-03-08)

**Completed:**
- Terraform infrastructure: persistent (RG + Key Vault) + ephemeral (VNet, NSG, Subnet, NIC, Public IP, VM)
- cloud-init provisioning: Docker, noVNC, Git, Unity Hub installer, game-ci downloader — all verified on live Azure VM
- Go downloader CLI (`cmd/downloader`): Unity license path resolution (Unity 6+ and pre-Unity 6), Key Vault upload
- Go unit tests (`cmd/downloader/main_test.go`): license path tests for Linux, Windows, Darwin
- Terratest infrastructure tests (`test/terraform_test.go`): VM provisioning, IP, noVNC port
- Node.js vmManager.js — replaced entirely by Go + Terraform

**Architecture decisions made:**
- Entry point: GitHub App webhook (not GitHub Actions `workflow_dispatch`) — plug-and-play
- Terraform split: persistent vs. ephemeral (persistent resources survive between builds)

**Next:**
- GitHub App webhook handler (Go HTTP trigger for Azure Functions) — Issues #29, #13, #14
- AWS and GCP support: not started
