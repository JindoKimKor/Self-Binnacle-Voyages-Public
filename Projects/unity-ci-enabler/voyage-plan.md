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
> | - | 2026-01-29 | Terraform Infrastructure Setup | IaC for static infrastructure (VNet, NSG, Subnet) |
>
> <details>
> <summary>Details</summary>
>
> - [ ] `terraform/azure/main.tf` - Static infrastructure (VNet, Subnet, NSG)
> - [ ] `terraform/azure/variables.tf` - Variable definitions
> - [ ] `terraform/azure/outputs.tf` - Outputs for NIC connection
> - [ ] `.gitignore` update (*.tfstate, *.tfvars)
> - [ ] `terraform plan/apply` test
> - [ ] README documentation (user runs once)
>
> </details>
<br>

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-01-29 | vmManager.js Refactoring | Modify to reference Terraform infrastructure |
>
> <details>
> <summary>Details</summary>
>
> - [ ] Remove existing VNet/NSG creation code
> - [ ] Reference Terraform outputs (subnet_id, nsg_id)
> - [ ] Simplify to only handle dynamic VM creation
> - [ ] Move hardcoded passwords to environment variables
>
> </details>
<br>

### Plotted (Reached)

---

## Progress Tracker
| Passage | Date | Topic | Note |
|---------|------|-------|------|
| 1 | 2025-11-10 | Phase 1 Review & Project Setup | Azure Functions architecture review, GitHub Issue/Milestone structure |
| 2 | 2025-11-11 | Azure Auth Setup | Azure CLI, local.settings.json, DefaultAzureCredential, Issue #2 closed |
| 3 | 2025-11-14 | Phase 2 Complete | VM creation, E2E testing, PR #7/#8 merged, Phase 3 planning |
| 4 | 2025-11-18 | Refactoring | SRP - createVirtualNetwork, createPublicIP, createNetworkInterface |
| 5 | 2025-11-24 | cloud-init & NSG | TigerVNC + noVNC setup, NSG creation, config.js modularization |

---

## Resources
- 

---

---

## References
- GitHub: https://github.com/game-ci-automation/unity-ci-license-activator-azure

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
