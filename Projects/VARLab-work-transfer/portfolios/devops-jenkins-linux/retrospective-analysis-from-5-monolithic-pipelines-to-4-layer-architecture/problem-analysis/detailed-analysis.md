# Detailed Analysis

> Cross-category patterns and system-wide analysis derived from individual component analyses.

---

## Table of Contents

- [Analysis Methodology](#analysis-methodology)
- [Chapter 1: Common Symptoms by Category](#chapter-1-common-symptoms-by-category)
  - [Helper Common Symptoms](#11-helper-common-symptoms)
  - [Jenkinsfile Common Symptoms](#12-jenkinsfile-common-symptoms)
- [Chapter 2: Cross-Category Patterns](#chapter-2-cross-category-patterns)
  - [Abstraction Inconsistency](#21-abstraction-inconsistency)
  - [Shotgun Surgery Locations](#22-shotgun-surgery-locations)
- [Chapter 3: System-wide Patterns](#chapter-3-system-wide-patterns)
  - [Pipeline Duplication Analysis](#31-pipeline-duplication-analysis)
- [Chapter 4: Why Untestable?](#chapter-4-why-untestable)
- [References](#references)

---

## Analysis Methodology

![Analysis Methodology](../resources/analysis-methodology.png)

### Applied Concepts & Principles

| Analysis Phase | Concepts/Principles |
|----------------|---------------------|
| Data Collection | Domain mapping from sequence diagrams, SRP analysis, Call frequency analysis |
| Individual File | Fowler's Code Smells, Suryanarayana's Design Smells (OOP-only excluded) |
| Design Symptoms | Martin's 7 Design Symptoms |
| System-Level | Architecture Smells, Cross-pipeline comparison |

---

## Chapter 1: Common Symptoms by Category

### 1.1 Helper Common Symptoms

**Data Sources:**

| Component | Source |
|-----------|--------|
| generalHelper | 01-generalHelper/03-design-smells-symptoms.md |
| jsHelper | 02-jsHelper/03-design-smells-symptoms.md |
| unityHelper | 03-unityHelper/03-design-smells-symptoms.md |

**Summary:**

| Symptom | generalHelper | jsHelper | unityHelper |
|---------|:-------------:|:--------:|:-----------:|
| Rigidity | High | Low | High |
| Fragility | High | Low | High |
| Immobility | High | Medium | Medium |
| Viscosity | Medium | Medium | High |
| Needless Complexity | - | - | - |
| Needless Repetition | High | Medium | High |
| Opacity | Medium | Medium | Medium |

**Common Patterns:**
- All 3 Helpers exhibit Rigidity and Needless Repetition
- No Needless Complexity found (no over-engineering)
- generalHelper most severe: 7 domains, highest Immobility
- unityHelper highest Viscosity: Stage conditionals make proper design harder than copy-paste
- jsHelper least severe overall

---

### 1.2 Jenkinsfile Common Symptoms

**Data Sources:**

| Component | Source |
|-----------|--------|
| DLX CI | 04-DLXJenkins-Jenkinsfile/03-design-smells-symptoms.md |
| DLX CD | 05-DLXJenkins-JenkinsfileDeployment/03-design-smells-symptoms.md |
| JS CI | 06-JsJenkins-Jenkinsfile/03-design-smells-symptoms.md |
| JS CD | 07-JsJenkins-JenkinsfileDeployment/03-design-smells-symptoms.md |
| Jenkins CI | 08-PipelineForJenkins-Jenkinsfile/03-design-smells-symptoms.md |

**Summary:**

| Symptom | DLX CI | DLX CD | JS CI | JS CD | Jenkins CI |
|---------|:------:|:------:|:-----:|:-----:|:----------:|
| Rigidity | High | High | High | High | Medium |
| Fragility | High | High | High | High | High |
| Immobility | High | High | High | High | High |
| Needless Complexity | - | - | Low | - | - |
| Viscosity | Medium | High | High | High | Medium |
| Needless Repetition | High | High | High | High | High |
| Opacity | Medium | Medium | High | Medium | High |

**Common Patterns:**
- All 5 Jenkinsfiles exhibit Immobility and Needless Repetition (High)
- Needless Complexity nearly absent (only JS CI has commented-out code)
- CD pipelines (DLX CD, JS CD) have higher Viscosity due to deployment pattern duplication
- JS CI has highest Opacity due to undefined variable and 112-line Long Method
- Jenkins CI has Opacity issue due to `catchError` parameter typo (potential bug)

---

## Chapter 2: Cross-Category Patterns

### 2.1 Abstraction Inconsistency

**Data Sources:**

| Source | Extracted Data |
|--------|----------------|
| Pipeline Sequence Diagrams | Pipeline Comparison tables |

**Evidence:**

| Function | Helper Usage | Direct Call | Pipelines |
|----------|-------------|-------------|-----------|
| Git operations | `cloneOrUpdateRepo` | `git clone/checkout/reset/pull` | CI vs CD |
| Build status init | `initializeEnvironment` | `sendBuildStatus` direct | CI vs CD |
| Web Server | `cleanMergedBranchFromWebServer` | SSH/SCP direct | DLX CD (same file) |

**Analysis:**
- Same functionality implemented differently between CI and CD pipelines
- Even within same file (DLX CD), Web Server operations use both Helper and direct calls

---

### 2.2 Shotgun Surgery Locations

**Data Sources:**

| Source | Extracted Data |
|--------|----------------|
| 01-generalHelper/02-software-smells-analysis.md | Cross-file Shotgun Surgery |
| 03-unityHelper/02-software-smells-analysis.md | Cross-file + Within-file Shotgun Surgery |
| 04-08 Jenkinsfile analyses | Within-file Shotgun Surgery |

**Cross-file (Helper signature change):**

| Change Trigger | Affected Files | Total Locations |
|----------------|----------------|:---------------:|
| `sendBuildStatus` | generalHelper + 5 Jenkinsfiles | 18 |
| `runUnityStage` | unityHelper + 2 Jenkinsfiles | 9 |
| `parseJson` | generalHelper + 5 Jenkinsfiles | 10 |

**Within-file (Pattern duplication):**

| Change Trigger | File | Locations |
|----------------|------|:---------:|
| stageName/errorMsg | DLX CI, DLX CD | 9 |
| Adding new Unity Stage | unityHelper | 7 |
| Server/Client report pattern | JS CI | 6 |
| Server/Client deploy pattern | JS CD | 4 |
| Groovy/Jenkinsfile lint pattern | Jenkins CI | 4 |

**Analysis:**
- `sendBuildStatus` change requires 18 modifications across 6 files
- Pattern duplication within Jenkinsfiles creates additional Shotgun Surgery risk

---

## Chapter 3: System-wide Patterns

### 3.1 Pipeline Duplication Analysis

**Data Sources:**

| Source | Extracted Data |
|--------|----------------|
| Jenkinsfile source code | DLX CI, DLX CD, JS CI, JS CD, Jenkins CI |

**Lines by Section:**

| Section | DLX CI | DLX CD | JS CI | JS CD | Jenkins CI | Total |
|---------|:------:|:------:|:-----:|:-----:|:----------:|:-----:|
| **Boilerplate** |
| Variables | 6 | 5 | 4 | 5 | 3 | 23 |
| Tools | 3 | 0 | 3 | 1 | 5 | 12 |
| Parameters | 11 | 9 | 10 | 8 | 10 | 48 |
| Triggers | 18 | 17 | 17 | 16 | 16 | 84 |
| Environment | 13 | 10 | 16 | 13 | 17 | 69 |
| Post | 22 | 22 | 22 | 26 | 22 | 114 |
| **Boilerplate Subtotal** | **73** | **63** | **72** | **69** | **73** | **350** |
| **Stages** |
| Delete Merged Branch | - | 28 | - | 26 | - | 54 |
| Prepare WORKSPACE | 53 | 36 | 35 | 30 | 33 | 187 |
| Install Dependencies | - | - | 16 | 16 | - | 32 |
| Linting | 43 | 24 | 12 | 12 | 67 | 158 |
| EditMode Tests | 18 | 17 | - | - | - | 35 |
| PlayMode Tests | 14 | 13 | - | - | - | 27 |
| Unit Testing | - | - | 82 | 14 | - | 96 |
| Run Unit Tests | - | - | - | - | 5 | 5 |
| Publish Test Results | - | - | - | - | 5 | 5 |
| Code Coverage | 24 | - | - | - | - | 24 |
| Build Project | 30 | 14 | - | - | - | 44 |
| Static Analysis | - | - | 35 | 33 | 42 | 110 |
| Check Build Condition | - | - | - | 24 | - | 24 |
| Deploy Build | - | 32 | - | - | - | 32 |
| Server Build and Deploy | - | - | - | 56 | - | 56 |
| Client Build and Deploy | - | - | - | 56 | - | 56 |
| Generate Groovydoc | - | - | - | - | 28 | 28 |
| **Stages Subtotal** | **182** | **164** | **180** | **267** | **180** | **973** |
| **Total** | **255** | **227** | **252** | **336** | **253** | **1,323** |

**Duplication Analysis:**

| Comparison | Common Lines | Total Lines | Duplication % |
|------------|:------------:|:-----------:|:-------------:|
| All 5 Pipelines (Boilerplate + Prepare WORKSPACE) | 537 | 1,323 | 41% |
| DLX CI vs DLX CD | 398 | 482 | 83% |
| JS CI vs JS CD | 426 | 588 | 72% |

**Note:**
- Includes Stages and Boilerplate that exist across pipelines.
- Includes sections that can be abstracted into one, even if not completely identical.

**Code Duplication Trend:**

| Baseline | Commit | Date | Duplication % |
|----------|--------|------|:-------------:|
| Earlier analysis | `54479b2` | 2025-02-21 | 37% |
| Current analysis | `74fc356` | 2025-03-20 | 41% |

- Duplication increased from 37% to 41% within approximately 1 month
- Structural issues cause duplication to naturally increase when adding code
- In the current architecture, copy-paste is the easiest approach for adding new features (High Viscosity)

---

## Chapter 4: Why Untestable?

**Data Sources:**

| Source | Extracted Data |
|--------|----------------|
| architecture-smells-analysis.md Section 2.1 | Hub-like Dependency Diagram |
| architecture-smells-analysis.md Section 2.3 | External calls (113), Environment variables (10) |

**Evidence:**

| Factor | Count | Impact |
|--------|:-----:|--------|
| External calls via `sh` | 113 | Cannot mock in unit tests |
| Hidden environment variables | 10 | Runtime-only values |
| Hub-like dependencies | 5 pipelines → generalHelper | No isolation possible |
| Direct external calls from pipelines | 50 | Bypasses any abstraction |

**Analysis:**
- All Helpers and Pipelines directly call external systems via `sh`
- Tight coupling to external systems without Dependency Injection
- Testing requires actual Jenkins + Git + Bitbucket + Unity + Docker environment

---

## References

- Individual analyses: 01-08 files
- [DRY-violation-analysis.md](./DRY-violation-analysis.md)
- [pipeline-sequence-diagrams/domain-mapping.md](./pipeline-sequence-diagrams/domain-mapping.md)