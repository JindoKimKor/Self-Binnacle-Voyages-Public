# Phase 3: Bitbucket API & Shell Library Integration

## Basic Information

| Item | Value |
|------|-------|
| **Start** | `9c245c1` (2025-04-27, Phase 2 ended) |
| **Final** | `48f4295` (2025-05-05) |
| **Total Commits** | 84 |
| **Duration** | 2025-05-01 ~ 2025-05-05 (5 days) |

---

## Table of Contents

1. [Goal](#1-goal)
2. [Commit List (by Phase)](#2-commit-list-by-phase)
3. [Phase-by-Phase Detailed Analysis](#3-phase-by-phase-detailed-analysis)
   - 3.1 [Phase 1: Jenkins Environment Test and Bitbucket API Initial Implementation](#31-phase-1-jenkins-environment-test-and-bitbucket-api-initial-implementation)
   - 3.2 [Phase 2: Bitbucket API HTTP Communication Implementation and Debugging](#32-phase-2-bitbucket-api-http-communication-implementation-and-debugging)
   - 3.3 [Phase 3: ShellScript Helper Refactoring](#33-phase-3-shellscript-helper-refactoring)
   - 3.4 [Phase 4: Git Shell Scripts Implementation and stageProjectPrepare](#34-phase-4-git-shell-scripts-implementation-and-stageprojectprepare)
   - 3.5 [Phase 5: GitLibrary/ShellLibrary Separation and BitbucketApiService](#35-phase-5-gitlibraryshellibrary-separation-and-bitbucketapiservice)
   - 3.6 [Phase 6: Shell Library Cleanup and Completion](#36-phase-6-shell-library-cleanup-and-completion)
4. [New Files](#4-new-files)
5. [4-Layer Architecture Established](#5-4-layer-architecture-established)
6. [Core Patterns](#6-core-patterns)
7. [Bitbucket API Integration](#7-bitbucket-api-integration)
8. [Benefits](#8-benefits)
9. [Next Steps](#9-next-steps)

---

## 1. Goal

1. Bitbucket Cloud API integration for automatic build status reporting
2. Abstract Git/Shell commands into reusable libraries
3. Establish src/service/, src/utils/ layer architecture

---

## 2. Commit List (by Phase)

| Phase | Content | Commit Count |
|-------|---------|--------------|
| 1 | Jenkins Environment Test and Bitbucket API Initial Implementation (2025-05-01) | 7 |
| 2 | Bitbucket API HTTP Communication Implementation and Debugging (2025-05-02 first half) | 21 |
| 3 | ShellScript Helper Refactoring (2025-05-02 second half) | 8 |
| 4 | Git Shell Scripts Implementation and stageProjectPrepare (2025-05-03) | 26 |
| 5 | GitLibrary/ShellLibrary Separation and BitbucketApiService (2025-05-04) | 16 |
| 6 | Shell Library Cleanup and Completion (2025-05-05) | 6 |

<details markdown>
<summary><strong>Phase 1: Jenkins Environment Test and Bitbucket API Initial Implementation (7 commits)</strong></summary>

| Date | Commit | Message |
|------|--------|---------|
| 2025-05-01 | `dd02d58` | Add print jenkins environment |
| 2025-05-01 | `ea2d6bc` | repo:push test |
| 2025-05-01 | `612b8e9` | repo:push test |
| 2025-05-01 | `4fce553` | Replace PR_BRANCH with GIT_BRANCH |
| 2025-05-01 | `ab3b6a6` | Corrected PR_BRANCH to GIT_BRANCH |
| 2025-05-01 | `8b062fc` | Delete necessary function to get full commit hash because full commit hash can be grabed as same value in Jenkins Initial Environment named 'GIT_COMMIT: Jenkins Log-763 |
| 2025-05-01 | `12dcf8d` | Implemented sendBuildStatusForCommit method to send build status to Bitbucket Cloud API. - Implemented it in low level to handle the details of the API request. - Implemented try-catch-finally block to handle exceptions. - Implemented withCredentials block to handle authentication. - Implemented try-with-resources block to handle resources. - Implemented logger to log the status of the build. - Implemented logger to log the response from the API. - Implemented logger to log the error message from the API. |

</details>

<details markdown>
<summary><strong>Phase 2: Bitbucket API HTTP Communication Implementation and Debugging (21 commits)</strong></summary>

| Date | Commit | Message |
|------|--------|---------|
| 2025-05-02 | `e62b93f` | Added package imports to apiHelper.groovy |
| 2025-05-02 | `43a73e0` | Fixed Compail error |
| 2025-05-02 | `d17333e` | Try to fix Compile Error |
| 2025-05-02 | `6e519c7` | Add print StackTrace Error message code |
| 2025-05-02 | `d60a705` | Try to print stacktrace error message |
| 2025-05-02 | `ef6406c` | Add more logging for HTTP Request |
| 2025-05-02 | `a3011db` | Added error type for HTTP request |
| 2025-05-02 | `ea71fb8` | Try a new way to implement bitbucket api |
| 2025-05-02 | `97fe87b` | Use StringBuilder not steam Collectors |
| 2025-05-02 | `dc76f45` | Refactor SendBuildStatusForCommit Bitbucket API with HttpClient Class |
| 2025-05-02 | `72beb1f` | Improve error logging |
| 2025-05-02 | `a761924` | Fixed Compiler Error |
| 2025-05-02 | `aeae874` | slightly touch StackTrace logging output |
| 2025-05-02 | `39725c6` | Refactor Bitbucket API call |
| 2025-05-02 | `cd080f8` | Added missing package importing in bitbucketApi groovy |
| 2025-05-02 | `a4bcc06` | Added missing package in BitbucketApiClient groovy |
| 2025-05-02 | `4a9fe5b` | Try to fix closing chuck expected error during Bitbucket API Communication |
| 2025-05-02 | `d0af7e3` | Try to fix closing chunk expected second attempt |
| 2025-05-02 | `34e90c3` | Missing variable declaralation |
| 2025-05-02 | `37980ea` | slightly touch up logging message |
| 2025-05-02 | `cff33c3` | Polishing Logging |

</details>

<details markdown>
<summary><strong>Phase 3: ShellScript Helper Refactoring (8 commits)</strong></summary>

| Date | Commit | Message |
|------|--------|---------|
| 2025-05-02 | `9eaf277` | Refactor try-out for ShellScript |
| 2025-05-02 | `7d4222a` | Refactor ShellScriptHelper and Create ShellScripts as list of shellscript, delete ShellParams groovy |
| 2025-05-02 | `3678a3f` | Try to fix Compaile Error |
| 2025-05-02 | `5a27ee0` | Try to fix Compaile Error |
| 2025-05-02 | `555a11b` | Try to fix Compaile Error |
| 2025-05-02 | `668d621` | Fixed shellScriptHelper Implementation |
| 2025-05-02 | `3fc2917` | Modified Data Type check and Empty Condition logic in validateShMap function, for GString |
| 2025-05-02 | `ee64f56` | Mark unnecessary Jenkins Environment and Create a new Stage |

</details>

<details markdown>
<summary><strong>Phase 4: Git Shell Scripts Implementation and stageProjectPrepare (26 commits)</strong></summary>

| Date | Commit | Message |
|------|--------|---------|
| 2025-05-03 | `ff92c62` | Test isDirectory function |
| 2025-05-03 | `c862433` | Test fileExists function instead of isDirectory |
| 2025-05-03 | `220bb9e` | Fixed incorrect rutern data type for fileExists function |
| 2025-05-03 | `5585b83` | new stageCheckoutSourceCode groovy Checkpoint |
| 2025-05-03 | `9c44606` | Fixed GIT_SHOW_CUREENT_BRANCH Closure |
| 2025-05-03 | `cf092a4` | Fixed ShellScripts.groovy to return the current branch name |
| 2025-05-03 | `aba6b68` | Fixed GIT_SHOW_CURRENT_BRANCH Closure to return the current branch name |
| 2025-05-03 | `6dbf4e0` | Fixed GIT_SHOW_CURRENT_BRANCH |
| 2025-05-03 | `7551ee8` | Git test with pwd property |
| 2025-05-03 | `c479cb6` | Fixed incorrect implementation for sh step and correct javadoc for ShellScripts groovy |
| 2025-05-03 | `8dda64b` | Fixing GIT_SHOW_CURRENT_BRANCH Closure |
| 2025-05-03 | `1858dcf` | Upgrade Shell Script Label |
| 2025-05-03 | `ca2cbb1` | sh returnstdout test |
| 2025-05-03 | `da273ac` | Improved logging |
| 2025-05-03 | `55a0fbe` | Refactor a part of cloneOrUpdateRepo and test |
| 2025-05-03 | `9bf0779` | Commented out the error log for the returnStdout option in shellScriptHelper.groovy, due to the better error handling in the sh step. |
| 2025-05-03 | `3e84f96` | Implement Git source code checkout and synchronization logic - Created GIT_CHECK_ORIGIN_BRANCH_EXISTS to check if a branch exists on the 'origin' remote repository. - Created GIT_GET_ORIGIN_DEFAULT_BRANCH to get the default branch name for the 'origin' remote repository. - Changed the way to handle the error in shellScriptHelper.groovy, due to the better error handling in the sh step. - Implemented the Git Clone and Checkout logic in stageCheckoutSourceCode.groovy. - Implemented a part of the Synchronize with Default Branch logic in stageCheckoutSourceCode.groovy. |
| 2025-05-03 | `9b13c46` | New shell scripts and updated existing shell scripts: - Created GIT_CHECK_ORIGIN_BRANCH_EXISTS to check if a branch exists on the 'origin' remote repository. - Fixed to use single quotes instead of triple quotes for shell scripts for GIT_GET_ORIGIN_DEFAULT_BRANCH. - Implemented GIT_CHECK_BRANCH_EXISTS to check if a branch exists locally or on the 'origin' remote. |
| 2025-05-03 | `ae9c014` | Pipeline stage name change, Git sync check addition, and success logic modification - Rename stageCheckoutSourceCode to stageProjectPrepare - Created GIT_CHECK_UP_TO_DATE_WITH_REMOTE to check if the local branch is up to date with the remote branch - Rename stage names in Jenkinsfile - Modified how to handle successful logic in executeReturnStatus |
| 2025-05-03 | `ecf3e97` | Add unstaged changes to previous commit |
| 2025-05-03 | `2bf21e7` | Improved shell script helper function - Delete unused shell script helper function - Simplify ShellScriptHelper logging messages |
| 2025-05-03 | `89c1cca` | Created / Implemented GIT_CHECK_IS_REMOTE_BRANCH_ANCESTOR shell script helper function |
| 2025-05-03 | `c995312` | Implemented new shell script helper functions in stageProjectPrepare - Created GIT_CHECK_IS_REMOTE_BRANCH_ANCESTOR shell script helper function - Created GIT_MERGE_ORIGIN_BRANCH shell script helper function - Created GIT_LFS_FETCH_AND_CHECKOUT shell script helper function |
| 2025-05-03 | `432a130` | Improved shell script logging |
| 2025-05-03 | `8eb0779` | Commented out Prepare Workspace refacted into Jenkins Initialization and Project Preparation stages |
| 2025-05-03 | `7439856` | Replace COMMIT_HASH with GIT_COMMIT |

</details>

<details markdown>
<summary><strong>Phase 5: GitLibrary/ShellLibrary Separation and BitbucketApiService (16 commits)</strong></summary>

| Date | Commit | Message |
|------|--------|---------|
| 2025-05-04 | `8d6a236` | Refactored Stages Implemented and Deleted Previous |
| 2025-05-04 | `aeeef99` | Refactoring: ShellScripts into Libraries and Integration: - ShellScripts was refactored into GitLibrary and ShellLibrary - Implemented the refactored Libraries in stageProjectPrepare and stageInitialization |
| 2025-05-04 | `9702e3f` | quick fixed incorrect class name usage |
| 2025-05-04 | `c637009` | Implementation of Bitbucket API and Refactored related functions - Created BitbucketApiService and BitbucketApiLibrary - Created bitbucketApiHelper - Refactored stageInitialization |
| 2025-05-04 | `504cbdd` | Add missing Class declaration |
| 2025-05-04 | `551c40d` | Implmented not using BitbucketApiLibrary |
| 2025-05-04 | `3b38c6b` | Add missing pakcage import |
| 2025-05-04 | `9454891` | Try to fix |
| 2025-05-04 | `91ef0c6` | Delete not use package import |
| 2025-05-04 | `f1c0a8e` | Try to fix bitbucket API function |
| 2025-05-04 | `c8cd439` | try to use function |
| 2025-05-04 | `97dd803` | createBuildStatusForCommit |
| 2025-05-04 | `2dda24f` | Try to fix api function variables |
| 2025-05-04 | `94ba7ec` | Fixed calling incorrec method name |
| 2025-05-04 | `b6d8f82` | Fixed Method Exception |
| 2025-05-04 | `efa5c44` | Improved Http request logic and logging |

</details>

<details markdown>
<summary><strong>Phase 6: Shell Library Cleanup and Completion (6 commits)</strong></summary>

| Date | Commit | Message |
|------|--------|---------|
| 2025-05-05 | `3278c38` | Rename all Shell Library Clsoure for name convention |
| 2025-05-05 | `341252c` | Implement dockerInfo shellscript into shellLibrary |
| 2025-05-05 | `26c2199` | Add missing package import in PipelineForJenkins jenkinsfile |
| 2025-05-05 | `2c5eb16` | Implement GroovyLint ShellScript into ShellLibrary |
| 2025-05-05 | `99387da` | Added Missing Property for GroovyLint |
| 2025-05-05 | `48f4295` | Take unnecessary log message in ShellLibrary GroovyLint script property |

</details>

---

## 3. Phase-by-Phase Detailed Analysis

### 3.1 Phase 1: Jenkins Environment Test and Bitbucket API Initial Implementation

<details markdown>
<summary><strong>View Details</strong></summary>

**Duration**: 2025-05-01 (7 commits)

**Goal**: Understand Jenkins environment variables and initial Bitbucket Cloud API implementation

#### Step 1: Jenkins Environment Variable Test (`dd02d58` ~ `ab3b6a6`)

| Commit | Work |
|--------|------|
| `dd02d58` | Jenkins environment variable output test |
| `ea2d6bc` ~ `612b8e9` | repo:push event test |
| `4fce553` ~ `ab3b6a6` | Replace PR_BRANCH with GIT_BRANCH |

#### Step 2: Bitbucket API Initial Implementation (`8b062fc` ~ `12dcf8d`)

| Commit | Work |
|--------|------|
| `8b062fc` | Delete full commit hash function (use GIT_COMMIT environment variable) |
| `12dcf8d` | Implement `sendBuildStatusForCommit` method: try-catch-finally, withCredentials, logger integration |

**Learning Points**:
- Jenkins provides full commit hash via `GIT_COMMIT` environment variable
- Access commit info via environment variable without separate shell command

</details>

---

### 3.2 Phase 2: Bitbucket API HTTP Communication Implementation and Debugging

<details markdown>
<summary><strong>View Details</strong></summary>

**Duration**: 2025-05-02 first half (21 commits)

**Goal**: Implement and debug Bitbucket Cloud REST API HTTP communication

#### Problem Solving Process

| Commit | Attempt | Problem | Solution |
|--------|---------|---------|----------|
| `e62b93f` | Added package import | - | Added import to apiHelper.groovy |
| `43a73e0` ~ `d17333e` | Initial implementation | Compile Error | Fixed syntax errors |
| `6e519c7` ~ `d60a705` | Error logging | StackTrace not visible | Added print StackTrace code |
| `ef6406c` ~ `a3011db` | HTTP logging | Need request/response verification | Added error type logging |
| `ea71fb8` ~ `97fe87b` | HttpClient implementation | Stream Collectors issue | Changed to StringBuilder |
| `dc76f45` | Refactoring | - | Organized into HttpClient Class |
| `72beb1f` ~ `aeae874` | Error logging improvement | Compiler Error | Fixed and improved StackTrace output |
| `39725c6` ~ `a4bcc06` | API call refactoring | Missing package | Added import |
| `4a9fe5b` ~ `d0af7e3` | HTTP communication | "closing chunk expected" | Fixed chunk transfer method |
| `34e90c3` ~ `cff33c3` | Finalization | Missing variable declaration | Cleaned up logging |

**Learning Points**:
- Java 11+ HttpClient is usable in Jenkins Pipeline
- StringBuilder is more stable than Stream Collectors in Jenkins CPS

</details>

---

### 3.3 Phase 3: ShellScript Helper Refactoring

<details markdown>
<summary><strong>View Details</strong></summary>

**Duration**: 2025-05-02 second half (8 commits)

**Goal**: Refactor ShellScript execution helper and remove ShellParams

#### Problem Solving Process

| Commit | Work | Problem | Solution |
|--------|------|---------|----------|
| `9eaf277` | ShellScript refactoring attempt | - | Started structure change |
| `7d4222a` | Convert ShellScripts to list, delete ShellParams | - | Switched to Map-based |
| `3678a3f` ~ `555a11b` | Fix Compile Error | Syntax error | Fixed after 3 attempts |
| `668d621` | shellScriptHelper implementation complete | - | Final implementation |
| `3fc2917` | Fix validateShMap function | GString type handling | Improved type check logic |
| `ee64f56` | Clean up unnecessary env vars, create new Stage | - | Added stageCheckoutSourceCode |

**Code Change**:
```groovy
// Before: ShellParams class
ShellParams params = new ShellParams(script: 'git fetch', label: 'Fetch')

// After: Using Map
shellScriptHelper.execute([script: 'git fetch', label: 'Fetch'])
```

**Learning Points**:
- Groovy GString and String are handled as different types
- Simple Map is more flexible than classes in Jenkins Pipeline

</details>

---

### 3.4 Phase 4: Git Shell Scripts Implementation and stageProjectPrepare

<details markdown>
<summary><strong>View Details</strong></summary>

**Duration**: 2025-05-03 (26 commits)

**Goal**: Abstract Git commands as Closures and implement stageProjectPrepare Stage

#### Step 1: File Existence Check Function Test (`ff92c62` ~ `220bb9e`)

| Commit | Attempt | Problem | Solution |
|--------|---------|---------|----------|
| `ff92c62` | isDirectory function test | - | Test |
| `c862433` | Changed to fileExists function | - | Alternative attempt |
| `220bb9e` | Fixed return type | Wrong return type | Fixed |

#### Step 2: stageCheckoutSourceCode and Git Closure (`5585b83` ~ `7439856`)

| Commit | Work |
|--------|------|
| `5585b83` | stageCheckoutSourceCode.groovy checkpoint |
| `9c44606` ~ `6dbf4e0` | Fixed GIT_SHOW_CURRENT_BRANCH Closure (4 attempts) |
| `7551ee8` ~ `c479cb6` | pwd test, fixed sh step implementation |
| `8dda64b` ~ `1858dcf` | Final GIT_SHOW_CURRENT_BRANCH fix, Shell Script Label improvement |
| `ca2cbb1` ~ `da273ac` | returnStdout test, logging improvement |
| `55a0fbe` | Partial cloneOrUpdateRepo refactoring |
| `9bf0779` | Commented out returnStdout error log |
| `3e84f96` | Implemented Git checkout/sync logic: GIT_CHECK_ORIGIN_BRANCH_EXISTS, GIT_GET_ORIGIN_DEFAULT_BRANCH |
| `9b13c46` | Additional shell scripts: single quotes usage, GIT_CHECK_BRANCH_EXISTS |
| `ae9c014` | Renamed stageCheckoutSourceCode → stageProjectPrepare, added GIT_CHECK_UP_TO_DATE_WITH_REMOTE |
| `ecf3e97` ~ `2bf21e7` | Added unstaged changes, deleted unnecessary functions |
| `89c1cca` ~ `c995312` | Implemented GIT_CHECK_IS_REMOTE_BRANCH_ANCESTOR, GIT_MERGE_ORIGIN_BRANCH, GIT_LFS_FETCH_AND_CHECKOUT |
| `432a130` ~ `7439856` | Logging improvement, replaced COMMIT_HASH with GIT_COMMIT |

**Learning Points**:
- Closure for Shell command definition enables parameterized reuse
- Need to trim results when using `returnStdout: true`

</details>

---

### 3.5 Phase 5: GitLibrary/ShellLibrary Separation and BitbucketApiService

<details markdown>
<summary><strong>View Details</strong></summary>

**Duration**: 2025-05-04 (16 commits)

**Goal**: Separate Shell Scripts into GitLibrary/ShellLibrary and implement BitbucketApiService

#### Step 1: Library Separation (`8d6a236` ~ `9702e3f`)

| Commit | Work |
|--------|------|
| `8d6a236` | Deleted previous Stage and refactored |
| `aeeef99` | Separated ShellScripts → GitLibrary + ShellLibrary, applied to stageProjectPrepare/stageInitialization |
| `9702e3f` | Fixed incorrect class name |

#### Step 2: BitbucketApiService Implementation (`c637009` ~ `efa5c44`)

| Commit | Attempt | Problem | Solution |
|--------|---------|---------|----------|
| `c637009` | Created BitbucketApiService, bitbucketApiHelper | - | Initial implementation |
| `504cbdd` | Missing Class declaration | Compile Error | Added |
| `551c40d` | Implemented without BitbucketApiLibrary | - | Simplified |
| `3b38c6b` ~ `91ef0c6` | Package import issue | Compile Error | Fixed/deleted import |
| `f1c0a8e` ~ `c8cd439` | Fixed API function | Not working | Attempted |
| `97dd803` | createBuildStatusForCommit | - | Function implementation |
| `2dda24f` | Fixed variables | - | Attempted |
| `94ba7ec` | Fixed method name | Wrong method call | Fixed |
| `b6d8f82` | Fixed Method Exception | Exception occurred | Fixed |
| `efa5c44` | Improved HTTP request logic and logging | - | Final cleanup |

**Architecture Change**:
```
Before:  src/utils/ShellScripts.groovy (all Shell commands)
After:   src/utils/GitLibrary.groovy
         src/utils/ShellLibrary.groovy
         src/service/general/BitbucketApiService.groovy
```

**Learning Points**:
- Domain-based Library separation improves management/testing
- Encapsulate business logic (API calls) in Service layer

</details>

---

### 3.6 Phase 6: Shell Library Cleanup and Completion

<details markdown>
<summary><strong>View Details</strong></summary>

**Duration**: 2025-05-05 (6 commits)

**Goal**: Unify Shell Library naming convention and implement additional scripts

#### Work by Commit

| Commit | Work |
|--------|------|
| `3278c38` | Unified all Shell Library Closure naming convention |
| `341252c` | Added DOCKER_INFO shellscript |
| `26c2199` | Added package import to PipelineForJenkins Jenkinsfile |
| `2c5eb16` | Implemented GROOVY_LINT ShellScript |
| `99387da` | Added missing GroovyLint Property |
| `48f4295` | Removed unnecessary log message |

**Learning Points**:
- Consistent naming convention (`VERB_NOUN`) improves code readability
- When adding Closure to Library, manage related properties together

</details>

---

## 4. New Files

### 4.1 Layer 3: Service (Business Logic)

#### `sharedLibraries/src/service/general/BitbucketApiService.groovy` (155 lines)
Bitbucket Cloud REST API client
```groovy
class BitbucketApiService {
    def pipeline

    BitbucketApiService(pipeline) {
        this.pipeline = pipeline
    }

    void sendBuildStatusForCommit(String commitHash, String state, String key, String url, String description) {
        // HTTP POST to Bitbucket Cloud API
        // /2.0/repositories/{workspace}/{repo}/commit/{commit}/statuses/build
    }
}
```

### 4.2 Layer 4: Utils (Libraries)

#### `sharedLibraries/src/utils/GitLibrary.groovy` (258 lines)
Git command library
```groovy
class GitLibrary {
    // Check branch existence
    static Closure GIT_CHECK_ORIGIN_BRANCH_EXISTS = { branchName ->
        "git ls-remote --heads origin ${branchName} | grep -q ${branchName}"
    }

    // Get default branch
    static Closure GIT_GET_ORIGIN_DEFAULT_BRANCH = {
        "git remote show origin | grep 'HEAD branch' | cut -d' ' -f5"
    }

    // Check if remote branch is ancestor
    static Closure GIT_CHECK_IS_REMOTE_BRANCH_ANCESTOR = { baseBranch, targetBranch ->
        "git merge-base --is-ancestor origin/${baseBranch} origin/${targetBranch}"
    }

    // Merge remote branch
    static Closure GIT_MERGE_ORIGIN_BRANCH = { branchName ->
        "git merge origin/${branchName} --no-edit"
    }

    // Git LFS fetch and checkout
    static Closure GIT_LFS_FETCH_AND_CHECKOUT = {
        "git lfs fetch --all && git lfs checkout"
    }

    // Check if local branch is synced with remote
    static Closure GIT_CHECK_UP_TO_DATE_WITH_REMOTE = { branchName ->
        '''
        LOCAL=$(git rev-parse HEAD)
        REMOTE=$(git rev-parse origin/${branchName})
        [ "$LOCAL" = "$REMOTE" ]
        '''
    }
}
```

#### `sharedLibraries/src/utils/ShellLibrary.groovy` (210 lines)
General Shell command library
```groovy
class ShellLibrary {
    // Get Docker info
    static Closure DOCKER_INFO = {
        "docker info"
    }

    // Execute Groovy Lint
    static Closure GROOVY_LINT = { targetPath, configPath ->
        "npm-groovy-lint --path ${targetPath} --config ${configPath}"
    }

    // Copy file
    static Closure COPY_FILE = { source, destination ->
        "cp ${source} ${destination}"
    }

    // Check directory existence
    static Closure CHECK_DIR_EXISTS = { path ->
        "[ -d ${path} ]"
    }
}
```

### 4.3 Layer 2: vars/ (Entry Points)

#### `sharedLibraries/vars/bitbucketApiHelper.groovy` (33 lines)
```groovy
def sendBuildStatus(String state, String description) {
    BitbucketApiService service = new BitbucketApiService(this)
    service.sendBuildStatusForCommit(
        env.GIT_COMMIT,
        state,
        env.BUILD_TAG,
        env.BUILD_URL,
        description
    )
}
```

#### `sharedLibraries/vars/stageProjectPrepare.groovy` (84 lines)
Git checkout and project preparation Stage
```groovy
def call(Map config = [:]) {
    logger.stageStart(env.STAGE_NAME)

    logger.stepsGroupStart('Git Repository Setup')
    // Use GitLibrary functions
    shellScriptHelper.execute(GitLibrary.GIT_CHECK_ORIGIN_BRANCH_EXISTS(env.PR_BRANCH))
    // ...

    logger.stepsGroupEnd('Git Repository Setup')
    logger.stageEnd(env.STAGE_NAME)
}
```

## 5. 4-Layer Architecture Established

```
devops-jenkins-linux/
├── */Jenkinsfile                      # Layer 1: Entry Point
│   ├── DLXJenkins/Jenkinsfile
│   ├── DLXJenkins/JenkinsfileDeployment
│   ├── JsJenkins/Jenkinsfile
│   ├── JsJenkins/JenkinsfileDeployment
│   └── PipelineForJenkins/Jenkinsfile
│
└── sharedLibraries/
    ├── vars/                          # Layer 2: Orchestration
    │   ├── stageInitialization.groovy
    │   ├── stageProjectPrepare.groovy
    │   ├── shellScriptHelper.groovy
    │   ├── bitbucketApiHelper.groovy
    │   └── logger.groovy (Cross-Cutting)
    │
    └── src/
        ├── service/                   # Layer 3: Services
        │   └── general/
        │       └── BitbucketApiService.groovy
        │
        ├── utils/                     # Layer 4: Utilities
        │   ├── GitLibrary.groovy
        │   └── ShellLibrary.groovy
        │
        └── resource/                  # Layer 4: Utilities (Constants)
            └── Status.groovy
```

## 6. Core Patterns

### 6.1 Shell Command Abstraction Using Closure
```groovy
// Definition (GitLibrary.groovy)
static Closure GIT_FETCH_ORIGIN = { branchName ->
    "git fetch origin ${branchName}"
}

// Usage (stageProjectPrepare.groovy)
shellScriptHelper.execute([
    script: GitLibrary.GIT_FETCH_ORIGIN(env.PR_BRANCH),
    label: 'Fetch PR branch from origin'
])
```

### 6.2 Advantages

1. **Type Safety**: Clearly define parameters with Closure
2. **Reusability**: Use same Git commands in multiple Stages
3. **Testability**: Test Shell command string generation logic independently
4. **Documentation**: Can add descriptions for each command

---

## 7. Bitbucket API Integration

### 7.1 Build Status Reporting Flow
```
Pipeline Start
    ↓
bitbucketApiHelper.sendBuildStatus('INPROGRESS', 'Build started')
    ↓
... (build execution) ...
    ↓
bitbucketApiHelper.sendBuildStatus('SUCCESSFUL', 'Build completed')
    or
bitbucketApiHelper.sendBuildStatus('FAILED', 'Build failed')
```

### 7.2 Verification in Bitbucket PR

- Build status badge displayed on PR page
- Per-commit build result verification possible

---

## 8. Benefits

1. **Centralization**: Git/Shell commands managed in one place
2. **Consistency**: All pipelines use same commands
3. **Visibility**: Real-time build status verification in Bitbucket
4. **Maintainability**: Only modify library when changing commands

---

## 9. Next Steps

→ Phase 4: Full Pipeline Refactoring and Stage Modularization
