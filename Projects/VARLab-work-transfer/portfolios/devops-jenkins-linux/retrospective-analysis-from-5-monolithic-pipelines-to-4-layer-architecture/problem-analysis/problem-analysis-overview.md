---
analysis_target: "Commit 74fc356 (2025-03-20)"
github_url: "https://github.com/JindoKimKor/devops-jenkins-linux/tree/74fc3563713df593f070f1c418ef9ee68f2682ed"
---

# Problem Analysis Overview

![Architecture Decay Overview](../resources/architecture-decay-overview.png)

## Table of Contents

- [Background](#1-background)
- [Analysis Target](#2-analysis-target)
- [Baseline Statistics](#3-baseline-statistics)
- [Key Findings](#4-key-findings)
  - [Quantitative Summary](#41-quantitative-summary)
  - [Shotgun Surgery](#42-shotgun-surgery)
  - [Duplication Trend](#43-duplication-trend)
  - [Design Symptoms Summary](#44-design-symptoms-summary)
- [Why This Analysis Matters](#5-why-this-analysis-matters)
- [Document Structure](#6-document-structure)
- [Analysis Document Links](#7-analysis-document-links)

---

## 1. Background

> This document is the problem analysis document for the pre-refactoring Baseline codebase.
>
> During the VARLab Co-op period, 5 monolithic pipelines (41% duplication, untestable) with 14 months of accumulated Technical Debt were refactored into a 4-Layer Architecture.

### 1.1. Analysis Purpose

At the time of refactoring, it was done intuitively without clear criteria. To lead from experience-based understanding to systematic theory acquisition, classification and definition using Industry Convention criteria:

1. Learn how the problems I felt are classified and named in practice
2. Check if there are any missed problems
3. Understand the analysis methodology itself

### 1.2. Applied Industry Convention Criteria

| Level | Framework | Source |
|-------|-----------|--------|
| Function/Method | Single Responsibility Principle | Martin (2006) *Agile Principles, Patterns, and Practices in C#* Ch.8 |
| Function/Method | Code Smells | Fowler (1999) *Refactoring* |
| Module/File | Design Smells | Suryanarayana et al. (2014) *Refactoring for Software Design Smells* |
| Module/File | 7 Design Symptoms | Martin (2002) *Agile Software Development* |
| System | Architecture Smells | Garcia et al. (2009), Sharma |

---

## 2. Analysis Target

**Baseline Commit**: `74fc356` (2025-03-20)

This is the final state before Global Shared Library introduction. Selected after re-analyzing the entire commit history for precise baseline identification.

**Note on Resume's 37% Figure**: The "37% duplication" mentioned in resume was based on earlier baseline `54479b2` (2025-02-21). After detailed commit history analysis, `74fc356` was identified as the accurate "before refactoring" state. Current analysis shows **41% duplication**.

---

## 3. Baseline Statistics

| Category | Files | Purpose |
|----------|-------|---------|
| Jenkinsfiles | 5 | Pipeline orchestration |
| Groovy Helpers | 3 | Shared functions |
| Python Scripts | 16 | Reporting & API integration |
| Bash/Config | 3 | Linting & editor settings |

**Analysis Target: Jenkinsfiles + Groovy Helpers (8 files)**

| Type | File |
|------|------|
| Jenkinsfile | DLXJenkins/Jenkinsfile |
| Jenkinsfile | DLXJenkins/JenkinsfileDeployment |
| Jenkinsfile | JsJenkins/Jenkinsfile |
| Jenkinsfile | JsJenkins/JenkinsfileDeployment |
| Jenkinsfile | PipelineForJenkins/Jenkinsfile |
| Helper | generalHelper.groovy |
| Helper | jsHelper.groovy |
| Helper | unityHelper.groovy |

### 3.1 File Structure

```
74fc356/
├── .gitignore
├── build.gradle
├── Builder.cs
│
├── DLXJenkins/                           # Unity Project Pipeline
│   ├── Jenkinsfile                       # CI Pipeline (255 lines)
│   └── JenkinsfileDeployment             # CD Pipeline (227 lines)
│
├── JsJenkins/                            # JavaScript Project Pipeline
│   ├── Jenkinsfile                       # CI Pipeline (252 lines)
│   └── JenkinsfileDeployment             # CD Pipeline (336 lines)
│
├── PipelineForJenkins/                   # Jenkins Self Pipeline
│   ├── Jenkinsfile                       # CI Pipeline (253 lines)
│   ├── .groovylintrc.groovy.json
│   └── .groovylintrc.jenkins.json
│
├── groovy/                               # Helper Scripts
│   ├── generalHelper.groovy              # 656 lines, 7 domains
│   ├── unityHelper.groovy                # 357 lines, 3 domains
│   └── jsHelper.groovy                   # 356 lines, 4 domains
│
├── Bash/
│   ├── .editorconfig
│   └── Linting.bash
│
├── python/
│   ├── JsReporting/
│   │   ├── extract_coverage_rates.py
│   │   └── extract_test_result.py
│   ├── log-template/
│   │   └── logs.html
│   ├── create_bitbucket_coverage_report.py
│   ├── create_bitbucket_test_report.py
│   ├── create_bitbucket_webgl_build_report.py
│   ├── create_log_report.py
│   ├── extract_build_error_log_messages.py
│   ├── get_bitbucket_commit_hash.py
│   ├── get_unity_failure.py
│   ├── get_unity_version.py
│   ├── Lint_groovy_report.py
│   ├── linting_error_report.py
│   ├── npm_audit.py
│   └── send_bitbucket_build_status.py
│
└── tests/
    ├── GeneralHelperSpec.groovy
    └── JsHelperSpec.groovy
```

---

## 4. Key Findings

### 4.1 Quantitative Summary

| Metric | Value |
|--------|-------|
| Total Lines Analyzed | 1,323 (5 Jenkinsfiles) + 1,369 (3 Helpers) |
| Code Duplication | 41% across all pipelines |
| DLX CI/CD Duplication | 83% |
| JS CI/CD Duplication | 72% |
| External Calls | 113 calls to 12 external types |
| Shotgun Surgery | Cross-file: 37 locations, Within-file: 30 locations |

### 4.2 Shotgun Surgery

- **Cross-file (Helper signature change)**: Changing a Helper function requires modifications across multiple Jenkinsfiles. e.g., `sendBuildStatus` change requires 18 modifications across generalHelper + 5 Jenkinsfiles.
- **Within-file (Pattern duplication)**: Same pattern repeated within a single file. e.g., stageName/errorMsg pattern duplicated 9 times in DLX CI/CD.

### 4.3 Duplication Trend

| Commit | Date | Duplication |
|--------|------|:-----------:|
| `54479b2` | 2025-02-21 | 37% |
| `74fc356` | 2025-03-20 | 41% |

Duplication increased 4% in approximately 1 month. The architecture's High Viscosity makes copy-paste easier than proper abstraction.

### 4.4 Design Symptoms Summary

**Helpers:**

| Symptom | generalHelper | jsHelper | unityHelper |
|---------|:-------------:|:--------:|:-----------:|
| Rigidity | High | Low | High |
| Fragility | High | Low | High |
| Immobility | High | Medium | Medium |
| Viscosity | Medium | Medium | High |
| Needless Repetition | High | Medium | High |

**Jenkinsfiles:** All 5 exhibit High Immobility and High Needless Repetition.

---

## 5. Why This Analysis Matters

### Core Problem

The issue is not that Helpers exist (Helpers are intentional reuse). The problem is:

1. **Inline logic in Jenkinsfiles**: Orchestration layer should be thin, but pipelines contain 9-29 inline code blocks each
2. **5 pipelines with same inline code**: Change one, must change all 5 (Shotgun Surgery)
3. **This caused 14-month technical debt**: "Fear of touching code" → copy-paste → more duplication

### Evidence Chain

```
Inline Code in Jenkinsfiles
    ↓
Same pattern duplicated across 5 pipelines
    ↓
Shotgun Surgery (1 change → 18 locations)
    ↓
High Viscosity (copy-paste easier than fixing)
    ↓
Duplication naturally increases (37% → 41% in 1 month)
    ↓
14-month Technical Debt accumulation
```

### Real-World Experience

**Human Error Prone Structure**
- Modified INLINE code in CI Jenkinsfile, tested only CI pipeline
- Forgot about identical INLINE code in CD Jenkinsfile, deployed → CD pipeline not applied
- Modified Helper function + CI Jenkinsfile, missed CD Jenkinsfile update → CD pipeline broken

**Risk of Needing to Consider Everything for One Feature**
- When changing common functionality like "Add Warning status to build results": Must find and modify all 5 pipelines individually
- Context switching when interrupted by other ticket work
- Need to notify team members before every change

**Workflow and Teamwork Threatened by Strong Coupling**
- Multiple responsibilities concentrated in single file + strong coupling
- One person's code changes affect other team members' work
- Psychologically reluctant to modify/add features → Teamwork degradation

**ROI Degradation**
- Even simple modifications can't focus on just that feature
- Must consider 5 pipelines + Jenkins UI settings + Webhook/Third-party APIs
- 10-20 minute tasks extend to hours or days

---

## 6. Document Structure

```
problem-analysis-overview.md (this file)
    │
    ├── Main Analysis
    │   └── detailed-analysis.md ← Synthesized findings (★ Start here)
    │
    ├── Supporting Analysis
    │   ├── architecture-smells-analysis.md ← System-level (Hub-like, Scattered)
    │   └── DRY-violation-analysis.md ← Cross-file duplication patterns
    │
    ├── Per-File Analysis (01-08/)
    │   ├── 01-generalHelper/
    │   │   ├── 01-srp-violation-analysis.md
    │   │   ├── 02-software-smells-analysis.md
    │   │   └── 03-design-smells-symptoms.md
    │   ├── 02-jsHelper/
    │   ├── 03-unityHelper/
    │   ├── 04-DLXJenkins-Jenkinsfile/
    │   ├── 05-DLXJenkins-JenkinsfileDeployment/
    │   ├── 06-JsJenkins-Jenkinsfile/
    │   ├── 07-JsJenkins-JenkinsfileDeployment/
    │   └── 08-PipelineForJenkins-Jenkinsfile/
    │
    └── Pipeline Flow Analysis
        └── pipeline-sequence-diagrams/ ← Domain mapping, call flow diagrams
```

---

## 7. Analysis Document Links

### Main Analysis

| Document | Description |
|----------|-------------|
| [detailed-analysis.md](./detailed-analysis.md) | Synthesized findings from all individual analyses |

### Supporting Analysis

| Document | Description |
|----------|-------------|
| [architecture-smells-analysis.md](./architecture-smells-analysis.md) | System-level analysis (Hub-like Dependency, Scattered Functionality) |
| [DRY-violation-analysis.md](./DRY-violation-analysis.md) | Cross-file duplication patterns |

### Pipeline Flow Analysis

| Document | Description |
|----------|-------------|
| [pipeline-sequence-diagrams/domain-mapping.md](./pipeline-sequence-diagrams/domain-mapping.md) | Domain summary across all pipelines |
| [pipeline-sequence-diagrams/dlx-ci.md](./pipeline-sequence-diagrams/dlx-ci.md) | DLX CI pipeline call flow |
| [pipeline-sequence-diagrams/dlx-cd.md](./pipeline-sequence-diagrams/dlx-cd.md) | DLX CD pipeline call flow |
| [pipeline-sequence-diagrams/js-ci.md](./pipeline-sequence-diagrams/js-ci.md) | JS CI pipeline call flow |
| [pipeline-sequence-diagrams/js-cd.md](./pipeline-sequence-diagrams/js-cd.md) | JS CD pipeline call flow |
| [pipeline-sequence-diagrams/jenkins-ci.md](./pipeline-sequence-diagrams/jenkins-ci.md) | Jenkins CI pipeline call flow |

### Per-File Analysis

| File | SRP Analysis | Software Smells | Design Symptoms |
|------|--------------|-----------------|-----------------|
| generalHelper.groovy | [01-srp](./01-generalHelper/01-srp-violation-analysis.md) | [02-smells](./01-generalHelper/02-software-smells-analysis.md) | [03-symptoms](./01-generalHelper/03-design-smells-symptoms.md) |
| jsHelper.groovy | [01-srp](./02-jsHelper/01-srp-violation-analysis.md) | [02-smells](./02-jsHelper/02-software-smells-analysis.md) | [03-symptoms](./02-jsHelper/03-design-smells-symptoms.md) |
| unityHelper.groovy | [01-srp](./03-unityHelper/01-srp-violation-analysis.md) | [02-smells](./03-unityHelper/02-software-smells-analysis.md) | [03-symptoms](./03-unityHelper/03-design-smells-symptoms.md) |
| DLXJenkins/Jenkinsfile | [01-srp](./04-DLXJenkins-Jenkinsfile/01-srp-violation-analysis.md) | [02-smells](./04-DLXJenkins-Jenkinsfile/02-software-smells-analysis.md) | [03-symptoms](./04-DLXJenkins-Jenkinsfile/03-design-smells-symptoms.md) |
| DLXJenkins/JenkinsfileDeployment | [01-srp](./05-DLXJenkins-JenkinsfileDeployment/01-srp-violation-analysis.md) | [02-smells](./05-DLXJenkins-JenkinsfileDeployment/02-software-smells-analysis.md) | [03-symptoms](./05-DLXJenkins-JenkinsfileDeployment/03-design-smells-symptoms.md) |
| JsJenkins/Jenkinsfile | [01-srp](./06-JsJenkins-Jenkinsfile/01-srp-violation-analysis.md) | [02-smells](./06-JsJenkins-Jenkinsfile/02-software-smells-analysis.md) | [03-symptoms](./06-JsJenkins-Jenkinsfile/03-design-smells-symptoms.md) |
| JsJenkins/JenkinsfileDeployment | [01-srp](./07-JsJenkins-JenkinsfileDeployment/01-srp-violation-analysis.md) | [02-smells](./07-JsJenkins-JenkinsfileDeployment/02-software-smells-analysis.md) | [03-symptoms](./07-JsJenkins-JenkinsfileDeployment/03-design-smells-symptoms.md) |
| PipelineForJenkins/Jenkinsfile | [01-srp](./08-PipelineForJenkins-Jenkinsfile/01-srp-violation-analysis.md) | [02-smells](./08-PipelineForJenkins-Jenkinsfile/02-software-smells-analysis.md) | [03-symptoms](./08-PipelineForJenkins-Jenkinsfile/03-design-smells-symptoms.md) |