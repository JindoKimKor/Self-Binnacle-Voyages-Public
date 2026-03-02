# DRY Violation Analysis

## Table of Contents

- [DRY Principle Definition](#1-dry-principle-definition)
- [Analysis Results](#2-analysis-results)
  - [All Pipeline Common](#21-all-pipeline-common-5)
  - [CI vs CD Comparison](#22-ci-vs-cd-comparison)
  - [CI Pipeline Comparison](#23-ci-pipeline-comparison-dlx-ci-vs-js-ci-vs-jenkins-ci)
  - [CD Pipeline Comparison](#24-cd-pipeline-comparison-dlx-cd-vs-js-cd)
  - [JS CD Internal Duplication](#25-js-cd-internal-duplication-serverclient-deployment)
  - [Helper File Comparison](#26-helper-file-comparison)
- [Related Concepts](#related-concepts)

---

## 1. DRY Principle Definition

> **"Every piece of knowledge must have a single, unambiguous, authoritative representation within a system."**
> — Hunt & Thomas, *The Pragmatic Programmer* (1999)

### Analysis Method

Duplication patterns are identified using a top-down comparison approach.

| # | Comparison Scope | Analysis Purpose |
|---|----------|----------|
| 1 | All pipelines (5) | Patterns commonly used across all pipelines |
| 2 | CI vs CD | Distinguish CI-only / CD-only / common patterns |
| 3 | Between CI pipelines (DLX CI, JS CI, Jenkins CI) | Duplication between CI pipelines |
| 4 | Between CD pipelines (DLX CD, JS CD) | Duplication between CD pipelines |
| 5 | Within CD (JS CD) | Internal duplication within single pipeline |
| 6 | Between Helper files | Function/logic duplication between Helper files |

### DRY Violation Summary

| Type | Violation | Severity | Impact |
|------|----------|:------:|------|
| Inter-Helper duplication | `logMessage()` identical function copy | Medium | Logging changes require 2 modifications |
| Jenkinsfile duplication | `parameters` block 7 identical parameters | High | Parameter addition/changes require 5 modifications |
| Jenkinsfile duplication | `triggers.GenericTrigger` block | High | Trigger changes require 5 modifications |
| Jenkinsfile duplication | `environment` block structure | Medium | Environment variable pattern changes require 5 modifications |
| Jenkinsfile duplication | `post` block structure | High | Build status handling changes require 5 modifications |
| Jenkinsfile duplication | `buildResults`/`stageResults` extraction | Medium | Status value changes require 5 modifications |
| Inter-CI duplication | `Prepare WORKSPACE` stage logic | High | Initialization logic changes require 3 modifications |
| CI + CD duplication | Static Analysis (SonarQube) pattern | Medium | SonarQube setting changes require 3 modifications |
| Inter-CD duplication | `mainBranches` constant | Low | Branch policy changes require 2 modifications |
| JS CD internal duplication | Server/Client deployment logic | High | Deployment method changes require 2 modifications |

---

## 2. Analysis Results

### 2.1. All Pipeline Common (5)

| Duplication Pattern | Location | Separated |
|----------|------|:--------:|
| `parameters` block (7 identical parameters) | 5 Jenkinsfiles | ❌ |
| `triggers.GenericTrigger` block | 5 Jenkinsfiles | ❌ |
| `environment` block structure (`CI_PIPELINE`, `PROJECT_TYPE`, `PROJECT_DIR`, `REPORT_DIR`, etc.) | 5 Jenkinsfiles | ❌ |
| `post` block (always/success/failure/aborted) | 5 Jenkinsfiles | ❌ |
| `buildResults`/`stageResults` extraction pattern | 5 Jenkinsfiles | ❌ |
| `generalUtil` load pattern | 5 Jenkinsfiles | ❌ |
| `COMMIT_HASH` extraction logic | 5 Jenkinsfiles | ❌ |
| `currentBuild.description` setting | 5 Jenkinsfiles | ❌ |

### 2.2. CI vs CD Comparison

| Type | CI-only | CD-only | Common (Not Separated) |
|------|---------|---------|-----------------|
| Trigger | `regexpFilterExpression: 'OPEN'` | `regexpFilterExpression: 'MERGED'` | Rest of trigger structure identical |
| Environment Variables | `CI_PIPELINE = true` | `CI_PIPELINE = false` | Rest of environment variable pattern identical |
| Stage | Linting, Tests, Coverage, Static Analysis | Delete Branch, Deploy Build | Prepare Workspace, Build |
| Post | `sendBuildStatus(false)` pattern | `sendBuildStatus(true)` pattern | Overall structure identical |

### 2.3. CI Pipeline Comparison (DLX CI vs JS CI vs Jenkins CI)

| Duplication Pattern | DLX CI | JS CI | Jenkins CI | Separated |
|----------|:------:|:-----:|:----------:|:--------:|
| `Prepare WORKSPACE` stage structure | ✓ | ✓ | ✓ | ❌ |
| `isBranchUpToDateWithRemote` check | ✓ | ✓ | ✓ | ❌ |
| `initializeEnvironment` call | ✓ | ✓ | ✓ | ❌ |
| `cloneOrUpdateRepo` call | ✓ | ✓ | ✓ | ❌ |
| `mergeBranchIfNeeded` call | ✓ | ✓ | - | ❌ |
| Linting stage | ✓ | ✓ | ✓ (Groovy) | ❌ |
| Static Analysis (SonarQube) | - | ✓ | ✓ | ❌ |

**Differences**:
- DLX CI: Unity-specific (`unityUtil`), EditMode/PlayMode tests
- JS CI: Node.js-specific (`jsUtil`), npm dependency installation
- Jenkins CI: Groovy-specific, Groovydoc generation, Gradle tests

### 2.4. CD Pipeline Comparison (DLX CD vs JS CD)

| Duplication Pattern | DLX CD | JS CD | Separated |
|----------|:------:|:-----:|:--------:|
| `mainBranches = ['main', 'master']` | ✓ | ✓ | ❌ |
| `Delete Merged Branch` stage | ✓ | ✓ | ❌ |
| `cleanUpPRBranch` call | ✓ | ✓ | ✓ (Helper) |
| Static Analysis (SonarQube) pattern | - | ✓ | ❌ |

**Deployment Method Differences**:
- **DLX CD**: SSH/SCP-based WebDAV server deployment
- **JS CD**: Docker → Azure Container Registry → Container Apps deployment

### 2.5. JS CD Internal Duplication (Server/Client Deployment)

Server and Client deployment logic is repeated with almost identical patterns within the JS CD pipeline.

| Duplication Pattern | Server Build (line 242-317) | Client Build (line 319-392) | Separated |
|----------|:---------------------------:|:---------------------------:|:--------:|
| `az acr repository show-tags` call | ✓ | ✓ | ❌ |
| `jsUtil.getPackageJsonVersion()` call | line 268 | line 343 | ❌ |
| `jsUtil.versionCompare()` check | line 277 | line 352 | ❌ |
| `docker build` command | line 287-291 | line 362-366 | ❌ |
| `docker push` command | line 295-298 | line 370-373 | ❌ |
| `az containerapp update` command | line 302-307 | line 377-382 | ❌ |
| `docker rmi` cleanup | line 311 | line 386 | ❌ |

**Impact**: Deployment logic changes require modifications in both Server/Client locations

### 2.6. Helper File Comparison

**GeneralHelper vs JsHelper**

| Duplicated Function | GeneralHelper | JsHelper | Note |
|----------|:-------------:|:--------:|------|
| `logMessage()` | line 35-44 | line 7-16 | **Identical copy** |

**GeneralHelper vs UnityHelper**

| Duplication Pattern | GeneralHelper | UnityHelper | Note |
|----------|:-------------:|:-----------:|------|
| Direct duplication | - | - | No function duplication |
| Dependency | - | `generalUtil` load | UnityHelper depends on GeneralHelper |

---

## Related Concepts

| Concept | Source | Relationship |
|------|------|------|
| **Duplicated Code** | Fowler (1999) Code Smells | Code Smell expression of DRY violation |
| **Shotgun Surgery** | Fowler (1999) Code Smells | Result of DRY violation (1 change → N modifications) |
| **Needless Repetition** | Martin (2000) Design Symptoms | Design Symptom expression of DRY violation |
