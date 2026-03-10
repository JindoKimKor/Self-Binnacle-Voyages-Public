---
title: "[Project] Unity CI Enabler"
created: 2025-05-01
deadline: TBD
---

## Why
- Package VARLab's CI/CD infrastructure as open-source plug-and-play solution
- Enable Unity developers to use serverless build/test without DevOps expertise

## What
Open-source tool for Unity developers. Democratizing VARLab's serverless build/test environment (94.88% cost reduction) by packaging it as plug-and-play cloud architecture requiring no DevOps or cloud knowledge.

## How

### Workflow (per session)
1. Check GitHub project → AI ready → Open docs for notes → Open project

### Cloud Testing Protocol
Always save logs when testing/debugging cloud resources via CLI.

1. **Use `run.sh` script** — `logbook/{date}/resources/run.sh`
   ```bash
   bash logbook/YYYY-MM-DD/resources/run.sh <step-name> <command...>
   ```
2. **`--debug` flag required** — Always add `--debug` to Azure CLI commands for detailed logs
3. **Log file naming** — `step{N}-{description}.log` (e.g. `step3a-settings.log`, `step7-terraform-apply.log`)
4. **Link from log.md** — Each step description links to `→ [step-name.log](resources/step-name.log)`
5. **Git Bash caveat** — Commands containing `/subscriptions/...` paths require `MSYS_NO_PATHCONV=1` prefix

### Development Cycle
1. Check Issue
2. Create Branch (feature/issue-#-description)
3. Work + Commit (multiple commits per working unit)
4. Create PR + "Closes #N"
5. PR Merge → Issue auto-close
6. All Issues in Milestone done → Close Milestone
7. Write dev session notes
8. Create new Milestone/Issues → Repeat

### Issue Checklist
- Clear scope
- Tasks checklist
- Acceptance Criteria
- Technical Notes
- Dependencies (other Issues needed?)
- Milestone link
- Labels (enhancement, bug, testing, etc.)
- Estimate/Priority/Size (optional)

---

## Sailing Orders

### Plotted (Underway)

### Plotted Courses

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-03-09 | Batch node actual build execution | build.sh + PLATFORM implementation → E2E Unity build verification |
>
> <details>
> <summary>Details</summary>
>
> - [ ] Write `scripts/build.sh` (git clone → docker run game-ci → Unity batchmode build)
> - [ ] Read PLATFORM env var in handler and pass to JobParams
> - [ ] Switch to Spot/low-priority nodes (cost optimization)
> - [ ] Upload build artifacts → Azure Blob Storage
> - [ ] Report build result → GitHub commit status
>
> </details>
<br>

### Plotted (Reached)

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-03-07 | Step 1: VM Provisioning (Azure) | Provision Ubuntu Desktop VM via Terraform |
>
> <details>
> <summary>Result</summary>
>
> - [x] Terraform: Ubuntu Desktop VM (Azure) — `terraform/ephemeral/main.tf`
> - [x] cloud-init: noVNC, Docker Engine, Git installation
> - [x] cloud-init: Unity Hub (apt repo) installed on Desktop
> - [x] cloud-init: game-ci downloader placed on Desktop (GitHub Release wget)
> - [x] Terraform: VNet, NSG (6080/22), Subnet networking
> - [x] cloud-init: .unity-ci-env env var injection + run-bootstrap.sh auto-launch
>
> </details>
<br>

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-03-07 | Step 1: VM Image Capture & Cleanup | VM → Azure Shared Image Gallery, then cleanup |
>
> <details>
> <summary>Result</summary>
>
> - [x] Remove Unity Hub from VM — downloader cleanup (apt purge)
> - [x] Remove license file from VM — downloader cleanup (os.Remove)
> - [x] Capture VM → Azure Shared Image Gallery — `scripts/capture.sh`
> - [x] Delete source VM + OS disk — capture.sh Step 3-4
> - [x] Destroy ephemeral infra — capture.sh Step 5 (terraform destroy)
>
> </details>
<br>

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-03-08 | Function App — Webhook → Batch Pipeline | E2E verification: GitHub push → Function App → Azure Batch Job |
>
> <details>
> <summary>Result</summary>
>
> - [x] Go Custom Handler: webhook signature validation (HMAC-SHA256)
> - [x] Batch Job creation (autoPoolSpecification, Dedicated 1 node)
> - [x] Terraform: Managed Identity RBAC x3 (Key Vault Get, Batch Contributor, Gallery Reader)
> - [x] Terraform: lifecycle ignore_changes to resolve Key Vault access_policy conflict
> - [x] deploy.sh: Go build + zip + config-zip deployment + VM_SIZE injection
> - [x] E2E success: push → 202 build_submitted (8.67s)
> - Story #23 closed (2026-03-09)
>
> </details>
<br>

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-03-07 | Step 1: game-ci Downloader (Go) | User selects Unity version/platform → game-ci image pull → Azure Key Vault upload |
>
> <details>
> <summary>Result</summary>
>
> - [x] Go CLI: `-version`, `-platform` flags for input
> - [x] game-ci Docker image pull (local verification)
> - [x] License upload to Azure Key Vault (Azure SDK for Go)
> - Architecture decision: license stored in Azure Key Vault only, not GitHub Secrets
> - Story #32 closed (2026-03-07)
>
> </details>
<br>

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-01-29 | Terraform Infrastructure Setup (legacy) | Merged into Step 1 after architecture redesign |
>
> <details>
> <summary>Result</summary>
>
> Merged into Step 1 VM Provisioning Order (2026-03-07)
>
> </details>
<br>

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-01-29 | vmManager.js Refactoring (legacy) | Replaced by Go + multi-cloud architecture |
>
> <details>
> <summary>Result</summary>
>
> Replaced by Node.js → Go migration and multi-cloud architecture (2026-03-07)
>
> </details>
<br>

---

## Progress Tracker
| Passage | Date | Topic | Note |
|---------|------|-------|------|
| 1 | 2025-11-10 | Phase 1 Review & Project Setup | Azure Functions architecture review, GitHub Issue/Milestone structure |
| 2 | 2025-11-11 | Azure Auth Setup | Azure CLI, local.settings.json, DefaultAzureCredential, Issue #2 closed |
| 3 | 2025-11-14 | Phase 2 Complete | VM creation, E2E testing, PR #7/#8 merged, Phase 3 planning |
| 4 | 2025-11-18 | Refactoring | SRP - createVirtualNetwork, createPublicIP, createNetworkInterface |
| 5 | 2025-11-24 | cloud-init & NSG | TigerVNC + noVNC setup, NSG creation, config.js modularization |
| 6 | 2026-03-06 | Architecture Redesign | Node.js → Go + multi-cloud, Terraform IaC, repo rename |
| 7 | 2026-03-07 | TDD & Go Project Setup | Go module init, TDD cycle 1 (version/platform validators) |
| 8 | 2026-03-08 | Terraform Persistent Deploy | 6 Azure resources, .env/sync-env.sh environment system |
| 9 | 2026-03-09 | E2E Pipeline Verification | Function App deploy (CLI→Terraform), Webhook→Batch Job 202 success, 3-stage RBAC resolution |

---

## Resources
-

---

---

## References
- GitHub: https://github.com/game-ci-automation/unity-ci-enabler

---

## Notes

### Why Terraform over Cloud SDK? (2026-01-29)

**Summary**: Proactive IaC adoption for multi-cloud expansion and increasing infrastructure complexity

| Reason | SDK Limitation | Terraform Solution |
|--------|----------------|-------------------|
| **Multi-cloud** | Need to learn/maintain SDK per cloud | Same HCL syntax, just swap providers |
| **State Management** | No resource tracking | State file tracks current infrastructure |
| **Cleanup** | Manual deletion required | `terraform destroy` auto-cleanup |
| **Scalability** | Complexity spikes with Batch, SIG, Storage | Modular management |
| **Collaboration** | Hard to understand infra from code alone | Code = Infrastructure documentation |

**Decision Context**:
- Current: 1 VM + network resources
- Planned: Azure Batch, SIG, Blob Storage, Static Website, Multi-cloud

**Hybrid Approach Rationale**:
- Static infrastructure (VNet, NSG, Storage): Terraform - create once, maintain long-term
- Dynamic resources (VM): Keep SDK - fast response needed in Serverless

---

## Reflection
### Outcome
- actual:

### Learn
- actual:

### Harvest
- actual:
