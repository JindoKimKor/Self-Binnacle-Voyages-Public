# Phase 1: ShellScript Modularization & Initialization Stage

## Basic Information

| Item | Value |
|------|-------|
| **Start** | `3c6422c` (2025-04-24, Phase 0 ended) |
| **Final** | `d699fac` (2025-04-26) |
| **Total Commits** | 12 |
| **Duration** | 2025-04-25 (1 day) |

---

## Table of Contents

1. [Goal](#1-goal)
2. [Commit List](#2-commit-list)
3. [Step-by-Step Detailed Analysis](#3-step-by-step-detailed-analysis)
   - 3.1 [Step 1: Initialization Stage Initial Implementation](#31-step-1-initialization-stage-initial-implementation)
   - 3.2 [Step 2: ShellScript Modularization](#32-step-2-shellscript-modularization)
   - 3.3 [Step 3: Package Structure and Annotation Modifications](#33-step-3-package-structure-and-annotation-modifications)
   - 3.4 [Step 4: Naming Convention Establishment and Logging Improvement](#34-step-4-naming-convention-establishment-and-logging-improvement)
4. [New Files](#4-new-files)
5. [Architecture Significance](#5-architecture-significance)
6. [Core Patterns](#6-core-patterns)
7. [Benefits](#7-benefits)
8. [Next Steps](#8-next-steps)

---

## 1. Goal

Separate Shell script execution logic from pipeline code and modularize common initialization logic into Stage

---

## 2. Commit List

| Date | Commit | Message |
|------|--------|---------|
| 2025-04-25 | `fe1a82a` | Initialization initial test |
| 2025-04-25 | `5f079ff` | Added PRBRANCH git origin fetch in Initialization stage |
| 2025-04-25 | `44c4d06` | Added git origin fetch and get shell latest commit commands in Intialization groovy with error handling |
| 2025-04-25 | `8be55ee` | ShellScripting Modulized |
| 2025-04-25 | `d492539` | initialization.groovy has been updated to Initialization.groovy with the initial letter capitalized |
| 2025-04-25 | `8ef6fef` | Shell Script Data Class and Improve ShellScriptHelper |
| 2025-04-25 | `58a41e0` | Move import ShellParams Package in Jenkinsfile |
| 2025-04-25 | `0b9e4a8` | Fixed the way to do Package and use it |
| 2025-04-25 | `40bf3c4` | Removed Canonical annotation |
| 2025-04-25 | `d12ef93` | Added logic for TICKET NUMBER and FOLDER NAME and test initial lowercase Stage class name |
| 2025-04-25 | `d501f2d` | Try initial lowercase groovy file name in vars folder |
| 2025-04-25 | `d3613c8` | Improved log in Initialization stage and ShellScript Helper |

---

## 3. Step-by-Step Detailed Analysis

### 3.1 Step 1: Initialization Stage Initial Implementation

<details markdown>
<summary><strong>View Details</strong></summary>

**Commits**: `fe1a82a` ~ `44c4d06` (3 commits)

**Goal**: Create first Stage module in vars/ folder and implement Git initialization logic

#### Work by Commit

| Commit | Work | File Changes |
|--------|------|--------------|
| `fe1a82a` | Created Initialization.groovy, tested calling from Jenkinsfile | +`vars/Initialization.groovy` |
| `5f079ff` | Added git origin fetch for PR_BRANCH | Modified `vars/Initialization.groovy` |
| `44c4d06` | Added git fetch origin, shell latest commit commands, implemented error handling | `vars/Initialization.groovy` +41 lines |

**Result**:
- Created `vars/Initialization.groovy` file
- Includes basic git fetch and error handling

</details>

---

### 3.2 Step 2: ShellScript Modularization

<details markdown>
<summary><strong>View Details</strong></summary>

**Commits**: `8be55ee` ~ `8ef6fef` (3 commits)

**Goal**: Separate Shell execution logic into separate Helper and create data class

#### Work by Commit

| Commit | Work | File Changes |
|--------|------|--------------|
| `8be55ee` | Separated shell logic from Initialization, created shellUtils.groovy | +`vars/shellUtils.groovy` (52 lines) |
| `d492539` | Tested file name capitalization (initialization → Initialization) | Modified Jenkinsfile |
| `8ef6fef` | Created ShellParams data class, refactored to ShellScriptHelper | +`src/utils/ShellParams.groovy`, +`vars/ShellScriptHelper.groovy`, -`vars/shellUtils.groovy` |

**Architecture Change**:
```
Before: vars/Initialization.groovy (includes shell logic)
After:  vars/Initialization.groovy
        vars/ShellScriptHelper.groovy (handles shell execution)
        src/utils/ShellParams.groovy (parameter data class)
```

**Learning Points**:
- Files in vars/ folder can be called directly from Jenkins
- Classes in src/ folder are used via import

</details>

---

### 3.3 Step 3: Package Structure and Annotation Modifications

<details markdown>
<summary><strong>View Details</strong></summary>

**Commits**: `58a41e0` ~ `40bf3c4` (3 commits)

**Goal**: Resolve Groovy package import issues and Jenkins CPS compatibility

#### Problem Solving Process

| Commit | Attempt | Problem | Solution |
|--------|---------|---------|----------|
| `58a41e0` | Moved ShellParams import location | Import issue in vars | Moved to Jenkinsfile |
| `0b9e4a8` | Fixed package path | Wrong package declaration | Fixed to `utils.ShellParams` |
| `40bf3c4` | Removed @Canonical annotation | Jenkins CPS compatibility issue | Implemented manual constructor/getter |

**Code Change**:
```groovy
// Before: Groovy @Canonical annotation
@Canonical
class ShellParams {
    String script
    String label
}

// After: Manual implementation (Jenkins CPS compatible)
class ShellParams {
    String script
    String label

    ShellParams(String script, String label) {
        this.script = script
        this.label = label
    }
}
```

**Learning Points**:
- Jenkins Pipeline's CPS transformation is incompatible with some Groovy annotations
- `@Canonical`, `@Immutable`, etc. need to be replaced with manual implementation

</details>

---

### 3.4 Step 4: Naming Convention Establishment and Logging Improvement

<details markdown>
<summary><strong>View Details</strong></summary>

**Commits**: `d12ef93` ~ `d3613c8` (3 commits)

**Goal**: Establish vars/ file naming conventions and improve logging

#### Work by Commit

| Commit | Work | File Changes |
|--------|------|--------------|
| `d12ef93` | Added TICKET_NUMBER/FOLDER_NAME logic, renamed Initialization → stageInitialization | `vars/Initialization.groovy` → `vars/stageInitialization.groovy` |
| `d501f2d` | Renamed ShellScriptHelper → helperShellScript | `vars/ShellScriptHelper.groovy` → `vars/helperShellScript.groovy` |
| `d3613c8` | Improved logging messages, organized output format | Modified both files |

**Naming Convention Established**:
```
vars/ File Naming Convention:
- Stage modules: stage{StageName}.groovy (e.g., stageInitialization.groovy)
- Helpers: helper{HelperName}.groovy (e.g., helperShellScript.groovy)
```

**Result**:
- `stageInitialization.groovy`: Stage module
- `helperShellScript.groovy`: Shell execution helper

</details>

---

## 4. New Files

### 4.1 `sharedLibraries/src/utils/ShellParams.groovy` (43 lines)
Parameter data class for Shell command execution
```groovy
class ShellParams {
    String script
    String label
    boolean returnStdout = false
    boolean returnStatus = false
}
```

### 4.2 `sharedLibraries/vars/helperShellScript.groovy` (100 lines)
Shell script execution helper - Executes sh commands in a standardized way
```groovy
def execute(Map params) {
    // params: script, label, returnStdout, returnStatus
    // Integrated logging, error handling
}
```

### 4.3 `sharedLibraries/vars/stageInitialization.groovy` (41 lines)
Pipeline initialization Stage - Environment variable setup, Git information collection
```groovy
def call() {
    echo "▶️ Stage '${env.STAGE_NAME}' Starting"
    // Initialize environment variables like TICKET_NUMBER, FOLDER_NAME
    // Git origin fetch
}
```

## 5. Architecture Significance

### 5.1 Layer 2 & 4 Established
```
sharedLibraries/
├── vars/                    # Layer 2: Orchestration
│   ├── helperShellScript.groovy      # Helper
│   └── stageInitialization.groovy    # Stage Module
└── src/
    └── utils/               # Layer 4: Utilities
        └── ShellParams.groovy
```

### 5.2 Separation of Concerns Begins
- **Before**: sh commands written directly in Jenkinsfile
- **After**: sh execution abstracted in vars/, integrated logging/error handling

## 6. Core Patterns

### 6.1 Shell Execution Standardization
```groovy
// Before (inside Jenkinsfile)
sh 'git fetch origin'

// After (using vars/helperShellScript.groovy)
helperShellScript.execute([
    script: 'git fetch origin',
    label: 'Fetch origin branches'
])
```

### 6.2 Stage Modularization
```groovy
// Before (logic written inside Jenkinsfile)
stage('Initialization') {
    steps {
        script {
            // 10-20 lines of initialization code
        }
    }
}

// After (calling vars/stageInitialization.groovy)
stage('Initialization') {
    steps {
        stageInitialization()
    }
}
```

## 7. Benefits

1. **Code Reuse**: All pipelines use the same Shell execution logic
2. **Consistent Logging**: Automatically outputs label during Shell execution
3. **Integrated Error Handling**: Same error handling for all Shell executions
4. **Testability**: Separated modules can be unit tested

---

## 8. Next Steps

→ Phase 2: 3-Level Logger System Implementation
