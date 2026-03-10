---
date: 2026-03-06
---

## Log (Monitoring)

### What did I actually do?

**Architecture Redesign Decision**
- Reviewed existing Node.js + Azure-only codebase and decided to redesign from scratch
- Chose **Go** as orchestration language: single codebase targets all three serverless runtimes (Azure Functions custom handler, AWS Lambda, GCP Cloud Functions) natively
- Chose **Terraform (HCL)** as IaC: same syntax across all cloud providers, replaces imperative Azure SDK calls in vmManager.js
- Defined multi-cloud scope: Azure (primary), AWS and GCP (planned)
- Clarified project's true purpose — not just running builds, but preparing the licensed VM infrastructure that enables builds ("enabler" role)

**Architecture Documentation (`resources/architecture.md`)**
- Documented Step 1 flow: Serverless trigger → Terraform VM provisioning → User connects via noVNC → License activation (manual) → game-ci downloader → License dual storage (GitHub Secrets + Cloud Secret Manager) → VM image capture → Cleanup
- Documented Step 2 flow: GitHub push → GitHub Actions → Serverless orchestrator → Build node from Image Gallery → License injection → git clone → docker run (Unity build) → Artifact upload → Teardown
- Documented Cloud Provider Matrix (Azure/AWS/GCP comparison)
- Key design decisions captured: dual license storage, GitHub Actions yaml over GitHub App, docker volume mount for license file

**Repo Rename**
- Renamed GitHub repo `unity-ci-license-activator-azure` → `unity-ci-enabler` to reflect multi-cloud scope
- Updated git remote URL and local folder name accordingly
- Updated voyage-plan.md References section

**Sailing Orders Update**
- Archived old orders (Terraform IaC, vmManager.js refactoring) → moved to Plotted (Reached) with explanation
- Added 3 new orders aligned to new architecture: VM Provisioning (Terraform), game-ci Downloader (Go), VM Image Capture & Cleanup

**GitHub Project Setup**
- Installed `gh` CLI via winget, authenticated with `JindoKimKor` account (HTTPS, scopes: repo/workflow/read:org)
- Closed Issue #9 with comment explaining architectural shift to Go + Terraform + multi-cloud
- Created Milestone: `Phase 1 - Unity Build/Test Ready Infrastructure & License Activation`
- Created 22 issues total: Epic #34, Stories #29–33, Tasks #13–28, Test Tasks #35–39
- Set Issue Types via GitHub GraphQL API (Epic / User Story / Task)
- Linked all parent-child sub-issue relationships via REST API
- Structured following GBL-Square pattern: Epic → Story → Task hierarchy with Milestone

**Profile Update**
- Updated GitHub profile README (`JindoKimKor/JindoKimKor`) tech stack: Node.js → Go, added cloud-init

### Blockers
-

### Reflection
-

### Next Steps
-

### References
-

### Notes
-

### Raw (AI: organize into sections above)
-
