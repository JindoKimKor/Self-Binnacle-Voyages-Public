# Phase 2: 3-Level Logger System Implementation

## Basic Information

| Item | Value |
|------|-------|
| **Start** | `d699fac` (2025-04-26, Phase 1 ended) |
| **Final** | `9c245c1` (2025-04-27) |
| **Total Commits** | 11 |
| **Duration** | 2025-04-26 (1 day) |

---

## Table of Contents

1. [Goal](#1-goal)
2. [Commit List](#2-commit-list)
3. [Step-by-Step Detailed Analysis](#3-step-by-step-detailed-analysis)
   - 3.1 [Step 1: vars Call Method Test](#31-step-1-vars-call-method-test)
   - 3.2 [Step 2: Logger Initial Implementation and CPS Issue Resolution](#32-step-2-logger-initial-implementation-and-cps-issue-resolution)
   - 3.3 [Step 3: Logger Completion and Integration](#33-step-3-logger-completion-and-integration)
4. [3-Level Logging Pattern](#4-3-level-logging-pattern)
5. [New File](#5-new-file)
6. [Usage Examples](#6-usage-examples)
7. [Error Handling](#7-error-handling)
8. [Architecture Significance](#8-architecture-significance)
9. [Benefits](#9-benefits)
10. [Next Steps](#10-next-steps)

---

## 1. Goal

Design and implement a 3-level logger system for consistent logging output during pipeline execution

---

## 2. Commit List

| Date | Commit | Message |
|------|--------|---------|
| 2025-04-26 | `aa7c86e` | Improved logging and test vars |
| 2025-04-26 | `5ca3a49` | Re-test vars |
| 2025-04-26 | `63abf6b` | re-test vars no call method |
| 2025-04-26 | `238838a` | Logger test |
| 2025-04-26 | `45d7588` | Delete private access limiter in logger groovy regarding Jenkins pipeline access field member variables, CPS |
| 2025-04-26 | `0f782a5` | Try to fix logger field variables scope issue |
| 2025-04-26 | `cdb1984` | Second try to fix logger field variables scope issue, CPS |
| 2025-04-26 | `2267005` | Try logging without the field variables |
| 2025-04-26 | `a4eb7ee` | initial logger implemented |
| 2025-04-26 | `44ffef5` | Fixed using incorrect shellScriptHelper name |
| 2025-04-26 | `d699fac` | Fixed throw error handling |

---

## 3. Step-by-Step Detailed Analysis

### 3.1 Step 1: vars Call Method Test

<details markdown>
<summary><strong>View Details</strong></summary>

**Commits**: `aa7c86e` ~ `63abf6b` (3 commits)

**Goal**: Test how scripts in vars/ folder are called

#### Work by Commit

| Commit | Work | File Changes |
|--------|------|--------------|
| `aa7c86e` | Improved logging, created varsTest.groovy to test vars calling | +`vars/varsTest.groovy`, modified `vars/stageInitialization.groovy` |
| `5ca3a49` | Re-tested vars | Modified `vars/stageInitialization.groovy` |
| `63abf6b` | Tested vars without call() method | Modified `vars/stageInitialization.groovy` |

**Test Purpose**:
- Verify how Groovy files in vars/ folder are called by Jenkins
- Understand behavior differences with/without `call()` method

</details>

---

### 3.2 Step 2: Logger Initial Implementation and CPS Issue Resolution

<details markdown>
<summary><strong>View Details</strong></summary>

**Commits**: `238838a` ~ `2267005` (5 commits)

**Goal**: Create logger.groovy and resolve Jenkins CPS compatibility issues

#### Problem Solving Process

| Commit | Attempt | Problem | Solution |
|--------|---------|---------|----------|
| `238838a` | Created logger.groovy, used private static final fields | - | Initial implementation |
| `45d7588` | Removed private access modifier | CPS cannot access private fields | Deleted private keyword |
| `0f782a5` | Field variable scope modification attempt 1 | Still inaccessible | Tried different approach |
| `cdb1984` | Field variable scope modification attempt 2 | CPS transformation issue persists | Tried structure change |
| `2267005` | Completely removed field variables | - | Resolved by using strings directly |

**Code Change**:
```groovy
// Before: Using field variables (CPS issue occurred)
private static final String STAGE_MARKER = '===== STAGE'
void stageStart(String stageName) {
    echo "${STAGE_MARKER} Starting: [${stageName}] ${STAGE_MARKER}"
}

// After: Removed field variables (CPS compatible)
void stageStart(String stageName) {
    echo "===== STAGE Starting: [${stageName}] ====="
}
```

**Learning Points**:
- Jenkins Pipeline CPS has compatibility issues with `private`, `static final` fields
- In vars/ files, using strings directly in methods is more stable than field variables

</details>

---

### 3.3 Step 3: Logger Completion and Integration

<details markdown>
<summary><strong>View Details</strong></summary>

**Commits**: `a4eb7ee` ~ `d699fac` (3 commits)

**Goal**: Final logger implementation and integration with existing code

#### Work by Commit

| Commit | Work | File Changes |
|--------|------|--------------|
| `a4eb7ee` | Final logger.groovy implementation, renamed helperShellScript → shellScriptHelper, integrated logger in stageInitialization | `vars/logger.groovy` +29 lines, `vars/helperShellScript.groovy` → `vars/shellScriptHelper.groovy` |
| `44ffef5` | Fixed shellScriptHelper call name | Modified `vars/stageInitialization.groovy` |
| `d699fac` | Fixed throw error handling, improved stepError method | Modified `vars/logger.groovy`, `vars/shellScriptHelper.groovy`, `vars/stageInitialization.groovy` |

**Final Logger API**:
```groovy
// Stage Level
void stageStart(String stageName)
void stageEnd(String stageName)

// Steps Group Level
void stepsGroupStart(String groupName)
void stepsGroupEnd(String groupName)

// Step Level
void stepStart(String description)
void stepSuccess(String description)
void stepFailed(String description)
void stepError(String description)
```

**Final Naming Convention Established**:
```
vars/ File Naming Convention (Final):
- Stage modules: stage{StageName}.groovy
- Helpers: {helperName}Helper.groovy → starts with lowercase
- Logger: logger.groovy
```

</details>

---

## 4. 3-Level Logging Pattern

### 4.1 Level 1: Stage (Highest)
```
===== STAGE Starting: [ StageName ] =====
===== STAGE Completed: [ StageName ] =====
```

### 4.2 Level 2: Steps Group (Middle)
```
--- STEPS Starting Group: [ GroupName ] ---
--- STEPS Completed Group: [ GroupName ] ---
```

### 4.3 Level 3: Step (Lowest)
```
➡️ Step Starting: [ description ]...
💬 Step Info: [ description ]
🏃 Step Processing: [ description ]
💡 Step Shell Executed Result: [ result ]
✅ Step Completed: [ description ]
⚠️ Step Warning: [ description ]
❌ Step Failed: [ description ]
🔥 Step Error: [ description ]
```

## 5. New File: `sharedLibraries/vars/logger.groovy` (63 lines)

```groovy
// Stage Level
void stageStart(String stageName)
void stageEnd(String stageName)

// Steps Group Level
void stepsGroupStart(String groupName)
void stepsGroupEnd(String groupName)

// Step Level
void stepStart(String description)
void stepInfo(String description)
void stepProcessing(String description)
void stepShellExecutedResult(String description)
void stepSuccess(String description)
void stepWarning(String description)
void stepFailed(String description)
void stepError(String description, Throwable err)
void stepError(String description)  // Overload: without Throwable
```

## 6. Usage Examples

### 6.1 Usage Within Stage
```groovy
def call() {
    logger.stageStart(env.STAGE_NAME)

    logger.stepsGroupStart('Git Repository Setup')

    logger.stepStart('Fetching origin branches')
    sh 'git fetch origin'
    logger.stepSuccess('Origin branches fetched')

    logger.stepsGroupEnd('Git Repository Setup')

    logger.stageEnd(env.STAGE_NAME)
}
```

### 6.2 Console Output Example
```
===== STAGE Starting: [ Initialization ] =====
--- STEPS Starting Group: [ Git Repository Setup ] ---
➡️ Step Starting: [ Fetching origin branches ]...
✅ Step Completed: [ Origin branches fetched ]
--- STEPS Completed Group: [ Git Repository Setup ] ---
===== STAGE Completed: [ Initialization ] =====
```

## 7. Error Handling

### 7.1 stepError with Throwable
```groovy
void stepError(String description, Throwable err) {
    StringWriter sw = new StringWriter()
    PrintWriter pw = new PrintWriter(sw)
    err.printStackTrace(pw)
    String stackTrace = sw.toString()
    println "🔥🔥🔥 Full Stack Trace for Error \n[${description}]\n${stackTrace}"
    error("🔥 Step Error: \n[ ${description} ] - Error: ${err.getMessage()}")
}
```

### 7.2 Usage Example

```groovy
try {
    // Dangerous operation
} catch (Exception e) {
    logger.stepError('Failed to execute critical operation', e)
}
```

## 8. Architecture Significance

### 8.1 Standard Interface Established
Using the same logging pattern across all Stages and Steps → Consistent CI/CD log output

### 8.2 Ease of Debugging

- Automatic Stack trace output
- Clear indication of start/completion for each step
- Status differentiation with emojis (✅ Success, ⚠️ Warning, ❌ Failed, 🔥 Error)

### 8.3 Jenkins Blue Ocean Compatible

Step-by-step logging makes progress tracking easier in Blue Ocean UI

## 9. Benefits

1. **Consistency**: Same log format across all pipelines
2. **Readability**: Visual distinction with emojis and separators
3. **Debugging**: Detailed stack trace on error occurrence
4. **Maintainability**: Only one place to modify when changing log format

---

## 10. Next Steps

→ Phase 3: Bitbucket API & Shell Library Integration

---

## Reference

- [logger-system-design-integration.md](../logger-system-design-integration.md) - Logger System design document (Problem analysis → Solution → Implementation)
