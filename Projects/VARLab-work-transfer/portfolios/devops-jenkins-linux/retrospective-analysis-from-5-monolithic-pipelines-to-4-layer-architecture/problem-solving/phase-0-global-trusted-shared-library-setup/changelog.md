# Phase 0: Global Trusted Shared Library Setup

## Basic Information

| Item | Value |
|------|-------|
| **Baseline** | `74fc356` (2025-03-20) |
| **Final** | `3c6422c` (2025-04-24) |
| **Total Commits** | 40 |
| **Duration** | 2025-03-21 ~ 2025-04-24 (approximately 1 month) |

---

## Table of Contents

1. [Goal](#1-goal)
2. [Commit List (by Phase)](#2-commit-list-by-phase)
3. [Phase-by-Phase Detailed Analysis](#3-phase-by-phase-detailed-analysis)
   - 3.1 [Phase 1: Shared Library Folder Structure Exploration](#31-phase-1-shared-library-folder-structure-exploration-core-1543)
   - 3.2 [Phase 2: Shared Library Call Test](#32-phase-2-shared-library-call-test-core-1526)
   - 3.3 [Phase 3: Service Layer Construction](#33-phase-3-service-layer-construction-core-1547)
   - 3.4 [Phase 4: Global Library Configuration Test](#34-phase-4-global-library-configuration-test)
   - 3.5 [Phase 5: Full Implementation](#35-phase-5-full-implementation-implement-global-trusted-shared-library)
4. [Before/After Comparison](#4-beforeafter-comparison)
5. [Design Decisions](#5-design-decisions)
6. [Next Steps](#6-next-steps)

---

## 1. Goal

Build Jenkins Global Trusted Shared Library foundation

---

## 2. Commit List (by Phase)

| Phase | Content | Commit Count |
|-------|---------|--------------|
| 1 | Shared Library Folder Structure Exploration (2025-03-21) | 4 |
| 2 | Shared Library Call Test (2025-03-27) | 6 |
| 3 | Service Layer Construction (2025-03-31 ~ 2025-04-01) | 8 |
| 4 | Global Library Configuration Test (2025-04-13) | 3 |
| 5 | Full Implementation (2025-04-21 ~ 2025-04-24) | 22 |

<details markdown>
<summary><strong>Phase 1: Shared Library Folder Structure Exploration (4 commits)</strong></summary>

| Date | Commit | Message |
|------|--------|---------|
| 2025-03-21 | `bfab15f` | Test Shared Library |
| 2025-03-21 | `62c03c2` | Fix shared library path |
| 2025-03-21 | `c509fa0` | Fixed shared library path |
| 2025-03-21 | `3be0817` | Final Try |

</details>

<details markdown>
<summary><strong>Phase 2: Shared Library Call Test (6 commits)</strong></summary>

| Date | Commit | Message |
|------|--------|---------|
| 2025-03-27 | `144fe00` | test |
| 2025-03-27 | `eacdcce` | test |
| 2025-03-27 | `7aa3ff4` | Fixed |
| 2025-03-27 | `04ea7e0` | test |
| 2025-03-27 | `8f14918` | ests |
| 2025-03-27 | `8d17c86` | asdf |

</details>

<details markdown>
<summary><strong>Phase 3: Service Layer Construction (8 commits)</strong></summary>

| Date | Commit | Message |
|------|--------|---------|
| 2025-03-31 | `e9d184b` | Add new package GitLFSHelper |
| 2025-03-31 | `29fb14d` | Add new package GitLFSHelper |
| 2025-04-01 | `76e5586` | Added GitLFSHelper to its test |
| 2025-04-01 | `1b7981c` | Use different mocking framework for unit testing |
| 2025-04-01 | `a6d6547` | Refactor CheckIfLightAndReflectionFilesExist to be a shared library |
| 2025-04-01 | `107ab3a` | Re-categorize GitLFSHelper and LightAndReflectionFileChecker |
| 2025-04-01 | `19a296f` | Modified Infrastructure of Shared Library |
| 2025-04-01 | `abbac32` | Modified BuildProjectService.groovy |

</details>

<details markdown>
<summary><strong>Phase 4: Global Library Configuration Test (3 commits)</strong></summary>

| Date | Commit | Message |
|------|--------|---------|
| 2025-04-13 | `18f9bbb` | Try to assign the shared library files to the correct location |
| 2025-04-13 | `d68c0c7` | test global library |
| 2025-04-13 | `e15ea80` | test |

</details>

<details markdown>
<summary><strong>Phase 5: Full Implementation (22 commits)</strong></summary>

| Date | Commit | Message |
|------|--------|---------|
| 2025-04-21 | `d0ed2e2` | Global Library Test |
| 2025-04-21 | `cdf4b36` | test |
| 2025-04-21 | `09adc72` | test |
| 2025-04-21 | `2324c2e` | teest |
| 2025-04-21 | `befd0f0` | test |
| 2025-04-21 | `cb42797` | test |
| 2025-04-21 | `eb45331` | test |
| 2025-04-21 | `7c15211` | Test |
| 2025-04-21 | `c47b663` | Delete Load Shared Library Stage after managing Global Trusted Library Configuration worked |
| 2025-04-21 | `c33334c` | Renamed my-simple-lib to global-trusted-shared-library |
| 2025-04-21 | `0af1ac2` | Refactoring DLX-PR pipeline implementing the Global Trusted Shared Library |
| 2025-04-21 | `323823c` | Try a different way to use 'new' operator |
| 2025-04-21 | `183feab` | Modifed other way to call new operator in PR-DLX pipeline |
| 2025-04-21 | `6df93e4` | Implement Global Trusted Shared Library for Deployment-DLX pipeline |
| 2025-04-21 | `5ccb037` | Implement Global Trusted Shared Library for JavaScript Deployment Pipeline |
| 2025-04-23 | `77c024a` | Delete Optional filter to test executing pipeline run by repo push trigger |
| 2025-04-24 | `99708f4` | vars test |
| 2025-04-24 | `9f2cc5d` | vars test |
| 2025-04-24 | `91cf049` | vars Test with Library branch change |
| 2025-04-24 | `fa0a5be` | Revert "Delete Optional filter to test executing pipeline run by repo push trigger" |
| 2025-04-24 | `ddb5bd0` | Revert "vars test" |
| 2025-04-24 | `3c6422c` | Revert "vars test" |

</details>

---

## 3. Phase-by-Phase Detailed Analysis

### 3.1 Phase 1: Shared Library Folder Structure Exploration (CORE-1543)

<details markdown>
<summary><strong>View Details</strong></summary>

**Duration**: 2025-03-21 (4 commits)

**Goal**: Establish folder structure for Jenkins Shared Library introduction

#### Problem Solving Process

| Commit | Attempt | Problem | Solution |
|--------|---------|---------|----------|
| `bfab15f` | Created `sharedLibraries/resource/StageResults.groovy` | Jenkins doesn't recognize class | - |
| `62c03c2` | Moved `sharedLibraries/resource/` → `src/resource/` | Still not recognized | Jenkins recognizes `src/` folder as classpath |
| `c509fa0` | Moved `src/resource/` → `sharedLibraries/src/resource/` | - | Need `sharedLibraries/src/` structure under repository |
| `3be0817` | Refactored `StageResults` → `ResultStatus` | - | Separated Stage status and Build status, specified `static final` type |

#### Code Changes

**Before** (`bfab15f`):
```groovy
// sharedLibraries/resource/StageResults.groovy
package resource

class StageResults {
    static def stageResults = [
        'SUCCESS': 'SUCCESS',
        'FAILURE': 'FAILURE',
        'ABORTED': 'ABORTED',
        'SKIPPED': 'SKIPPED'
    ]
}
```

**After** (`3be0817`):
```groovy
// sharedLibraries/src/resource/ResultStatus.groovy
package resource

class ResultStatus {
    static final Map<String, String> STAGE_STATUS = [
        'SUCCESS': 'SUCCESS',
        'FAILURE': 'FAILURE',
        'ABORTED': 'ABORTED',
        'SKIPPED': 'SKIPPED'
    ]

    static final Map<String, String> BUILD_STATUS = [
        'SUCCESS': 'SUCCESS',
        'UNSTABLE': 'UNSTABLE',
        'FAILURE': 'FAILURE',
        'ABORTED': 'ABORTED',
        'NOT_BUILT': 'NOT_BUILT'
    ]
}
```

</details>

---

### 3.2 Phase 2: Shared Library Call Test (CORE-1526)

<details markdown>
<summary><strong>View Details</strong></summary>

**Duration**: 2025-03-27 (6 commits)

**Goal**: Test how to call Shared Library classes from Jenkinsfile

#### Test Content

Added/modified various `call()` methods to `ResultStatus.groovy`:

```groovy
// Attempt 1: void method
void Call() {
    each "Here"
}

// Attempt 2: parameter + return
void call(String param) {
    return param
}

// Attempt 3: constructor + instance variable
private String test

ResultStatus(String test) {
    this.test = test
}

void call() {
    return this.test
}
```

**Learning Points**:
- Scripts in `vars/` folder can be called directly via `call()` method
- Classes in `src/` folder are used via `new ClassName()` or `import`

</details>

---

### 3.3 Phase 3: Service Layer Construction (CORE-1547)

<details markdown>
<summary><strong>View Details</strong></summary>

**Duration**: 2025-03-31 ~ 2025-04-01 (8 commits)

**Goal**: Build Service class for Git LFS problem resolution

#### Problem Situation

1. **Git LFS File Missing**: LFS-managed files (images, audio) not checked out during pipeline execution
2. **Unity Lighting File Missing**: WebGL build lighting breaks without `LightingData.asset`, `ReflectionProbe-0.exr` files

#### Solution Process

| Commit | Changes |
|--------|---------|
| `e9d184b` | Created `GitLFSHelper.groovy` - Auto pull logic for LFS files |
| `a6d6547` | Created `CheckIfLightAndReflectionFilesExist.groovy` - Lighting file verification |
| `107ab3a` | Folder structure reorganization: `service/general/prepareWorkspace/`, `service/unity/buildProject/` |
| `19a296f` | Integrated Helper → Service: `PrepareWorkspaceService`, `BuildProjectService` |

#### Code Changes

**GitLFSHelper Core Logic** (`e9d184b`):
```groovy
void checkAndPullUntrackedLFSFiles() {
    try {
        // Check files managed by LFS but not yet downloaded
        String missingFiles = script.sh(
            script: "git lfs ls-files | awk '\$2 == \"-\" {print \$3}'",
            returnStdout: true
        ).trim()

        if (missingFiles) {
            script.echo "Untracked large files detected: ${missingFiles}"
            script.sh 'git lfs pull'
        }
    } catch (Exception e) {
        script.echo "Failed to check for untracked LFS files: ${e.message}"
    }
}
```

**Folder Structure Evolution**:
```
Attempt 1: service/general/GitLFSHelper.groovy
Attempt 2: service/general/prepareWorkspace/GitLFSHelper.groovy
Attempt 3: service/unity/buildProject/LightAndReflectionFileChecker.groovy
Final:     service/general/PrepareWorkspaceService.groovy
           service/unity/BuildProjectService.groovy
```

**Learning Points**:
- Integrated Helper classes into Service classes for domain-based responsibility separation
- Inject `script` object via constructor to access Jenkins Pipeline context

</details>

---

### 3.4 Phase 4: Global Library Configuration Test

<details markdown>
<summary><strong>View Details</strong></summary>

**Duration**: 2025-04-13 (3 commits)

**Goal**: Test Jenkins Global Library Configuration settings

#### Test Content

| Commit | Change | Purpose |
|--------|--------|---------|
| `18f9bbb` | Deleted all files in sharedLibraries (-99 lines) | Test if file location affects Global Library recognition |
| `d68c0c7` | Restored files (+99 lines) | Verify recognition after restoration |
| `e15ea80` | Deleted again (-99 lines) | Test different configuration combinations |

**Learning Points**:
- Configuration needed in Jenkins > Manage Jenkins > Configure System > Global Pipeline Libraries
- Specify Library name, Git Repository URL, Default Version (branch)
- Learned that Library type and Version Control is possible through Library settings

</details>

---

### 3.5 Phase 5: Full Implementation (Implement-Global-Trusted-Shared-Library)

<details markdown>
<summary><strong>View Details</strong></summary>

**Duration**: 2025-04-21 ~ 2025-04-24 (22 commits)

**Goal**: Apply Global Trusted Shared Library to 5 pipelines

#### Implementation Steps

##### Step 1: vars/ Test (`d0ed2e2`)

```groovy
// sharedLibraries/vars/sayHello.groovy
def call(String name = 'World') {
    echo "Hello, ${name}! This message came from the global library."
}
```

Verified `@Library('my-simple-lib@main') _` works in Jenkins Global Configuration.

##### Step 2: Delete Load Shared Library Stage (`c47b663`)

**Before** (-63 lines):
```groovy
def sharedLib
def resultStatus

stage('Load Shared Library') {
    steps {
        script {
            def LIBRARY_PATH = 'sharedLibraries'
            sh """
                cd ${WORKSPACE}/${LIBRARY_PATH} && \
                (rm -rf .git || true) && \
                git init && \
                git add --all && \
                git commit -m 'init'
            """
            def repoPath = sh(returnStdout: true, script: 'pwd').trim() + "/${LIBRARY_PATH}"
            sharedLib = library identifier: 'local-lib@master',
                    retriever: modernSCM([$class: 'GitSCMSource', remote: "${repoPath}"]),
                    changelog: false
        }
    }
}

// Usage
resultStatus = sharedLib.resource.ResultStatus
currentBuild.result = resultStatus.BUILD_STATUS.ABORTED
```

**After** (+6 lines):
```groovy
@Library('my-simple-lib@main') _

import resource.ResultStatus

// Usage
currentBuild.result = ResultStatus.BUILD_STATUS.ABORTED
```

##### Step 3: new Operator Syntax Fix (`323823c`)

**Before** (Local Library approach):
```groovy
prepareWorkspaceService = sharedLib.service.general.PrepareWorkspaceService
prepareWorkspaceServiceClass = prepareWorkspaceService.new(this)
```

**After** (Global Library approach):
```groovy
import service.general.PrepareWorkspaceService

PrepareWorkspaceService prepareWorkspaceService = new PrepareWorkspaceService(this)
```

**Problem**: With Local Library, `sharedLib.xxx.ClassName` returns a wrapped form rather than a Class object, requiring `.new()` syntax. With Global Library, direct `import` allows standard Groovy syntax.

##### Step 4: Applied to 5 Pipelines

| Commit | Pipeline | Change Amount |
|--------|----------|---------------|
| `c47b663` | PipelineForJenkins/Jenkinsfile | -63 lines, +6 lines |
| `0af1ac2` | DLXJenkins/Jenkinsfile | -47 lines, +11 lines |
| `6df93e4` | DLXJenkins/JenkinsfileDeployment | -53 lines |
| `5ccb037` | JsJenkins/Jenkinsfile, JenkinsfileDeployment | -86 lines |

</details>

---

## 4. Before/After Comparison

### Code Change Amount

| Item | Before | After | Change |
|------|--------|-------|--------|
| Shared Library Loading | ~30 lines/pipeline | 1 line | -29 lines |
| Class Usage Syntax | `sharedLib.xxx.Class` | `import xxx.Class` | Standard Groovy |
| new Operator | `Class.new(this)` | `new Class(this)` | Standard Groovy |

### Folder Structure

```
Before                              After
──────                              ─────
(No Shared Library)                 sharedLibraries/
                                    ├── src/
                                    │   ├── resource/
                                    │   │   └── ResultStatus.groovy
                                    │   └── service/
                                    │       ├── general/
                                    │       │   └── PrepareWorkspaceService.groovy
                                    │       └── unity/
                                    │           └── BuildProjectService.groovy
                                    └── vars/
                                        └── sayHello.groovy
```

---

## 5. Design Decisions

### 5.1 Why Global Trusted Library?

| Approach | Advantages | Disadvantages |
|----------|------------|---------------|
| **Local Library** | No separate configuration needed | Requires git init/commit every execution, non-standard syntax |
| **Global Library** | Standard import syntax, version control possible | Requires Jenkins configuration |
| **Global Trusted** | No sandbox restrictions (`@NonCPS`, file I/O possible) | Security caution needed |

### 5.2 Why Trusted is Needed

Features to be implemented in subsequent Phases:
- `@NonCPS` annotation usage (CPS transformation bypass)
- File I/O operations
- Direct Apache HttpClient usage

These features are unavailable in regular Shared Library due to sandbox restrictions.

### 5.3 Version Control

```groovy
@Library('global-trusted-shared-library@main') _           // main branch
@Library('global-trusted-shared-library@Refactor-with-TDD') _  // development branch
@Library('global-trusted-shared-library@v1.0.0') _         // tag version
```

Branch/tag specification enables per-pipeline Library version management.

---

## 6. Next Steps

→ Phase 1: ShellScript Modularization & Initialization Stage
