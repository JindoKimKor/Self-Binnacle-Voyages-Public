---
title: "[Project] VARLab Work Transfer"
created: 2026-01-07
deadline: TBD
---

## Why
Transfer all VARLab work (code, documentation, PR records, presentations) to personal ownership with proper git history attribution, preserving professional achievements and learnings.

## What
- Transfer 4 repositories with git history (email changed to personal)
- Organize 8+ project achievements into legs/
- Collect all documentation, PR records, demo materials

### Repositories
| Repo | Description |
|------|-------------|
| devops-jenkins-linux | Linux pipeline, 4-layer architecture, Docker optimization |
| devops-jenkins-windows | Unity build server, Windows Docker, WebGL deploy |
| dlx-hosting-server-moodle | LTI integration (Moodle), CIS compliance |
| dlx-hosting-server-d2l | LTI integration (D2L), CIS compliance |

### Legs (Achievements)
| Leg | Related Repo | Key Achievement |
|-----|--------------|-----------------|
| devops-pipeline | devops-jenkins-linux | 4-layer architecture, 37% duplication resolved |
| devops-logging | devops-jenkins-linux | 3-level execution pattern, standardized logging |
| linux-migration | devops-jenkins-linux | 93% faster Docker, 73→3 vulnerabilities |
| unity-cloud-migration | devops-jenkins-linux | 94.88% cost reduction |
| unity-build-server | devops-jenkins-windows | 80% faster, 90% CPU reduction |
| unity-webgl-deploy | devops-jenkins-windows | 20-30 min saved per review |
| web-cicd | devops-jenkins-linux | 80% code coverage enabled |
| lti-integration | dlx-hosting-server-moodle/d2l | LMS integration, CIS compliance |
| azure-vm-docker | devops-jenkins-windows | Nested virtualization, Windows Docker |

## How
1. Change git author email (filter-branch)
2. Push to personal GitHub (private)
3. Organize documentation/PR/presentations into legs/
4. Write README.md for each leg (learnings, time spent, impact)

---

## Sailing Orders

### Plotted (Underway)

-

### Plotted Courses

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-02-07 | Draw network diagram showing Moodle and LTI Server connection process | Complete understanding of system architecture |
>
> <details>
> <summary>Details</summary>
>
> - Network flow between Moodle and LTI Server
> - Authentication/authorization steps
> - All connection processes and protocols
>
> </details>
<br>

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-01-15 | Add cloud service benchmarking section to 94.88% Cost Reduction portfolio | Portfolio completeness |
>
> <details>
> <summary>Details</summary>
>
> - ACI, ACA, AKS vs Azure Batch comparison
> - Why each was not selected (reasoning)
>
> </details>
<br>

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-01-15 | Research NotebookLM video generation best practices | Content creation workflow |
>
> <details>
> <summary>Details</summary>
>
> - Community prompts for customized output
> - Alternative AI tools for video generation
> - Multi-step workflows for better results
>
> </details>
<br>

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-01-18 | LinkedIn posting for Software Smells Analysis portfolio | Professional visibility |
>
> <details>
> <summary>Details</summary>
>
> - Core message: "Transform experience-based understanding into systematic, reusable knowledge"
> - Motivation: Like a doctor diagnosing - clear diagnosis for future/team
> - Process: Before commit → Analysis → After commit
> - Concepts: What frameworks/principles guided the analysis
> - Design patterns applied in refactored code
> - Attach: Flashcard / Slide Deck from NotebookLM
>
> </details>
<br>

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-01-15 | Generate Flashcard / Slide Deck from Portfolio docs using NotebookLM | Learning material creation |
<br>

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-01-15 | Link YouTube videos (README top / Dashboard / LinkedIn) | Content distribution |
<br>

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-01-15 | Interactive Portfolio Website: Git commit-based Timeline UI | Portfolio presentation |
>
> <details>
> <summary>Details</summary>
>
> - Calendar background + sailing ship + reef (obstacles) visualization
> - Phase/Step progress shown as voyage journey
> - Leverage achievement data from legs/ folder
>
> </details>
<br>

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-02-26 | Apply Northstar / Unleash UI design elements to portfolio | Portfolio visual upgrade |
>
> <details>
> <summary>Details</summary>
>
> - Northstar Shipping Platform: 깔끔한 테이블 UI, 색상 배합, 레이아웃
> - Unleash UI: 색상 스킴, 토글 디자인, 대시보드 구성
> - 현재 포트폴리오 (dark theme slate/indigo) 에 적용 가능한 요소 분석
> - 발견 계기: PROG3360 Assignment 2 작업 중
>
> </details>
<br>

### Plotted (Reached)

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-01-23 | Update Software Smells portfolio README layout & fix TOC | Better first impression |
>
> <details>
> <summary>Result</summary>
>
> - Fixed TOC format (bullet-only), updated mkdocs.yml navigation structure
> - Built mkdocs and deployed to docs/ for GitHub Pages
>
> </details>
<br>

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-01-25 | Restructure 4-layer architecture portfolio for visitor navigation | Better first impression & guided reading |
>
> <details>
> <summary>Result</summary>
>
> - Restructured folder from `legs/` → `problem-solving/` with Implementation Phases
> - Updated mkdocs.yml: Problem Analysis → Problem Solving structure
> - Added TOCs to all root-level documents
> - Renamed folders: `leg-{0-4}` → `phase-{0-4}`
>
> </details>
<br>

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-01-21 | Analyze Strategic DDD concepts in Jenkins architecture | DDD understanding & portfolio narrative |
>
> <details>
> <summary>Result</summary>
>
> - Created `domain-driven-analysis.md` explaining Strategic DDD (Bounded Contexts, Subdomains) application
> - Clarified: Tactical DDD (Entities, Aggregates) not applicable to Jenkins scripting environment
> - Updated terminology: "domain-driven" → "Strategic DDD concepts"
>
> </details>
<br>

---

## Progress Tracker
| Passage | Date | Topic | Note |
|---------|------|-------|------|
| [2026-01-08](logbook/2026-01-08/log.md) | 2026-01-08 | README verification | Fixed commit counts, identified squash-merged branches |
| [2026-01-11](logbook/2026-01-11/log.md) | 2026-01-11~17 | Portfolio documentation | 65.5h, 4-layer architecture portfolio complete |
| [2026-01-24](logbook/2026-01-24/log.md) | 2026-01-24~26 | Portfolio restructure | Folder rename, mkdocs navigation, DDD/GoF documentation |

---

## Resources
- repos/ - 4 git repositories (not tracked by Self-Binnacle)
- legs/ - Achievement documentation by domain
- portfolios/ - Portfolio documents for job applications

---

## Notes
- repos/ folder contains .git folders, Self-Binnacle ignores nested repos
- This project consolidates the existing Task: transfer-varlab-work-git-history

---

## Reflection
### Outcome
- actual:

### Learn
- actual:

### Harvest
- actual:



### Raw
-