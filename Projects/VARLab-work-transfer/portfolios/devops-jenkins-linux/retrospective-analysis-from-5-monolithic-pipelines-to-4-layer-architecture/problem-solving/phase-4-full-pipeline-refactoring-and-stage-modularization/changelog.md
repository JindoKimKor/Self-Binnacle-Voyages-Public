# Phase 4: Full Pipeline Refactoring & Stage Modularization

## Basic Information

| Item | Value |
|------|-------|
| **Start** | `48f4295` (2025-05-05, Phase 3 ended) |
| **Final** | `ff74ac8` (2025-05-12) |
| **Total Commits** | 128 |
| **Duration** | 2025-05-06 ~ 2025-05-12 (7 days) |

---

## Table of Contents

1. [Goal](#1-goal)
2. [Commit List (by Phase)](#2-commit-list-by-phase)
3. [Phase-by-Phase Detailed Analysis](#3-phase-by-phase-detailed-analysis)
   - 3.1 [Phase 1: PipelineForJenkins Stage Modularization](#31-phase-1-pipelineforjenkins-stage-modularization)
   - 3.2 [Phase 2: DLX Pipeline Webhook Trigger Configuration](#32-phase-2-dlx-pipeline-webhook-trigger-configuration)
   - 3.3 [Phase 3: DLX-PR-Pipeline Stage Modularization](#33-phase-3-dlx-pr-pipeline-stage-modularization)
   - 3.4 [Phase 4: DLX-Deployment Pipeline Refactoring](#34-phase-4-dlx-deployment-pipeline-refactoring)
   - 3.5 [Phase 5: Full Jenkinsfile Cleanup and Integration](#35-phase-5-full-jenkinsfile-cleanup-and-integration)
   - 3.6 [Phase 6: SSH Library and Deployment Feature Completion](#36-phase-6-ssh-library-and-deployment-feature-completion)
   - 3.7 [Phase 7: Finalization and Bug Fixes](#37-phase-7-finalization-and-bug-fixes)
4. [New Stage Files](#4-new-stage-files-vars)
5. [New Libraries](#5-new-libraries)
6. [Jenkinsfile Transformation Example](#6-jenkinsfile-transformation-example)
7. [Webhook Configuration Improvements](#7-webhook-configuration-improvements)
8. [Final Architecture](#8-final-architecture)
9. [Benefits](#9-benefits)
10. [Conclusion](#10-conclusion)

---

## 1. Goal

Modularize all Stages of 5 pipelines so Jenkinsfiles consist only of Stage calls

---

## 2. Commit List (by Phase)

| Phase | Content | Commit Count |
|-------|---------|--------------|
| 1 | PipelineForJenkins Stage Modularization (2025-05-05 ~ 2025-05-06 early) | 8 |
| 2 | DLX Pipeline Webhook Trigger Configuration (2025-05-06) | 40 |
| 3 | DLX-PR-Pipeline Stage Modularization (2025-05-07 first half) | 24 |
| 4 | DLX-Deployment Pipeline Refactoring (2025-05-07 middle) | 22 |
| 5 | Full Jenkinsfile Cleanup and Integration (2025-05-07 second half) | 18 |
| 6 | SSH Library and Deployment Feature Completion (2025-05-08) | 12 |
| 7 | Finalization and Bug Fixes (2025-05-09 ~ 2025-05-12) | 4 |

<details markdown>
<summary><strong>Phase 1: PipelineForJenkins Stage Modularization (8 commits)</strong></summary>

| Date | Commit | Message |
|------|--------|---------|
| 2025-05-05 | `8e96fb9` | Improved shellScriptHelper logging |
| 2025-05-06 | `3ef978a` | Refactored LintGrovyJenkinsfile Stage |
| 2025-05-06 | `9dcc23b` | Added logging in stageLintGroovyJenkinsfile |
| 2025-05-06 | `6f4cf84` | Modulized Static Analysis Stage |
| 2025-05-06 | `0e66b11` | Test Modulized Static Analysis Stage |
| 2025-05-06 | `87e8a89` | Replace the un-modularized bitbucket api function with the modularized one for post steps |
| 2025-05-06 | `2c2d821` | Refactored SonarQube test |
| 2025-05-06 | `063955e` | Added Missing the variable for importing package |

</details>

<details markdown>
<summary><strong>Phase 2: DLX Pipeline Webhook Trigger Configuration (40 commits)</strong></summary>

| Date | Commit | Message |
|------|--------|---------|
| 2025-05-06 | `4c8509e` | == Start DLX Pipeline Refactoring == : Refactored Prepare Workspace Stage |
| 2025-05-06 | `f25f136` | Commented out regexpFilter for DLX Pipeline |
| 2025-05-06 | `c26d434` | try to get full request body |
| 2025-05-06 | `19c71e9` | Added getting BITBUCKET_EVENT_KEY |
| 2025-05-06 | `3ac83a5` | Fixed how to import Http Header variables |
| 2025-05-06 | `163cff2` | getting full request header |
| 2025-05-06 | `e2fe075` | Test getting http request header |
| 2025-05-06 | `f09fcc9` | quick teset |
| 2025-05-06 | `1fff356` | modified logging for getting http request body and header |
| 2025-05-06 | `d5eab38` | Added Request Body and Header trigger |
| 2025-05-06 | `79f6155` | One more time webhoob trigger for implmenting GenericTrigger configuration fully |
| 2025-05-06 | `0c004ac` | Try to retrieve x event key only |
| 2025-05-06 | `cbb805f` | Try to not to use expression of JsonPath for Http header |
| 2025-05-06 | `b6f2c58` | Try new way to retrieve http header |
| 2025-05-06 | `85b81c3` | Try new way to retrieve http header |
| 2025-05-06 | `f948ddd` | Try to retrieve lowcase and underscore for generic Header Variables |
| 2025-05-06 | `b558e24` | Try one more time |
| 2025-05-06 | `58edeec` | X-Event-Key |
| 2025-05-06 | `1811e1c` | Added regexpFilter for HTTP Header |
| 2025-05-06 | `7e07e96` | Print env first |
| 2025-05-06 | `943c40c` | Try to use x_event_key |
| 2025-05-06 | `50ea98a` | Push to check accessing x-event-key header |
| 2025-05-06 | `cb5a64a` | Try to get Branch name |
| 2025-05-06 | `fcb920f` | Test Http body Json retrieving |
| 2025-05-06 | `ac3bb52` | Print Json Request body Jons |
| 2025-05-06 | `b1456e6` | Try to use HTTP BODY JSON |
| 2025-05-06 | `374e775` | Assigned all necessary Jenkins environment for repo push Bitbucket WebTrigger |
| 2025-05-06 | `76296e7` | Same Implement repo push event trigger for DLX PR pipeline |
| 2025-05-06 | `ee741e8` | Incorrect environment variable using for PR_BRANCH |
| 2025-05-06 | `c9220f4` | Added missing package importing |
| 2025-05-06 | `f87e726` | Switch better symbol for info log |
| 2025-05-06 | `9b173c0` | DLX-PR-Pipeline-Linting Stage |
| 2025-05-06 | `a08e8e9` | Test loading groovy file in Envrionment |
| 2025-05-06 | `39f37c1` | Take loading groovy in environment braket off |
| 2025-05-06 | `c183faa` | Fixed empty value for REPORT_DIR |
| 2025-05-06 | `6876f0b` | Fixed Destination Branch Environment Assignment logic |
| 2025-05-06 | `d09288f` | Add missing package importing |
| 2025-05-06 | `d9ed92e` | Added More Missing Packge Importing |
| 2025-05-06 | `fc77459` | Added More step to secure returning value from shellscript |
| 2025-05-06 | `27dcc7c` | Implement DESTINATION_BRANCH environment value assignment in different way for every pipelines |

</details>

<details markdown>
<summary><strong>Phase 3: DLX-PR-Pipeline Stage Modularization (24 commits)</strong></summary>

| Date | Commit | Message |
|------|--------|---------|
| 2025-05-07 | `d8aab9b` | Refactored Unity Linting STage |
| 2025-05-07 | `27dd597` | try to fix copy lint config file for unity linting |
| 2025-05-07 | `ebfd6fb` | Correct unnecessary argument for CopyLintConfig ShellScripting |
| 2025-05-07 | `88f815b` | Try to fix shellscript |
| 2025-05-07 | `ce58b16` | Add sh inside shellScript |
| 2025-05-07 | `ed7f993` | EditMode modulurized test |
| 2025-05-07 | `c01107f` | EditMode stage test |
| 2025-05-07 | `59009e0` | Fixed how to use goorvy file in vars |
| 2025-05-07 | `319d413` | Refacted PlayMode and Coverage Stage |
| 2025-05-07 | `5b43e05` | Refactored CopyWebGLBuilder file |
| 2025-05-07 | `173e352` | Fixed wrong import package |
| 2025-05-07 | `6bd044f` | Added Missing Reference |
| 2025-05-07 | `e9b7c70` | Change logic for checking lighting and reflection Probe files |
| 2025-05-07 | `07f2646` | Try to improve new logging style |
| 2025-05-07 | `e2f47d3` | Refactored Build Project Stage for DLX PR pipeline |
| 2025-05-07 | `f2828b3` | Improve logging and detatched stripIndent functions for error issue |
| 2025-05-07 | `65878e3` | Delete no need paranthesis in checkLightingAndReflectionFiles |
| 2025-05-07 | `4e0b1ff` | Improved logger |
| 2025-05-07 | `e36d730` | stiripIndent function test |
| 2025-05-07 | `591b815` | stripIndent function test |
| 2025-05-07 | `703d90f` | Implement stripIndent function |
| 2025-05-07 | `bb271db` | Fixed incorrect argument to execute webgl build unity headless mode |
| 2025-05-07 | `85fea53` | Complete DLX-PR-Pipeline Refactor |
| 2025-05-07 | `69357f0` | Pointing Refactor-with-TDD global Trusted Shared Library Branch |

</details>

<details markdown>
<summary><strong>Phase 4: DLX-Deployment Pipeline Refactoring (22 commits)</strong></summary>

| Date | Commit | Message |
|------|--------|---------|
| 2025-05-07 | `500ca0e` | Delete Unnecessary function |
| 2025-05-07 | `d54d03e` | Try to added regexpFilterExpression for not merged trigger for PR branch |
| 2025-05-07 | `83e8eaf` | test webhook trigger filter for jenkins pipeline |
| 2025-05-07 | `8d0608a` | Add getting http x-event-key header value for DLX-Deployment pipeline |
| 2025-05-07 | `4bf13d8` | Deleted unnecessary try and catch |
| 2025-05-07 | `25187d9` | Refactor Delete Merged Branch Stage |
| 2025-05-07 | `5e6acfc` | Moved logger inside script bracket |
| 2025-05-07 | `0857b38` | Debugging fileExist function |
| 2025-05-07 | `201d711` | Refactoring Cleanup PR Branch Artifacts |
| 2025-05-07 | `c8ce9b3` | refactor again |
| 2025-05-07 | `a8d7bcd` | Try to fix directory finding |
| 2025-05-07 | `3e038c8` | Use different configuration property to find PR path |
| 2025-05-07 | `9b2f802` | Try to use wildcard |
| 2025-05-07 | `e1e312b` | Implement Cleanup PR Branch Artifacts |
| 2025-05-07 | `970293e` | Fixed not use trim |
| 2025-05-07 | `3234206` | Fixed incorrect return value for FindPRJobDirectory |
| 2025-05-07 | `18dbce2` | Modulurized the stage |
| 2025-05-07 | `7e5773d` | Refactor stageProjectPrepare groovy for unify PR and Deployment Pipeline together |
| 2025-05-07 | `c209fc0` | Refactored Prepare Workspace into Project Preparation |
| 2025-05-07 | `790c946` | Fixed the delete PR artifacts file logic for CD pipeline |
| 2025-05-07 | `9878a06` | Refactor Linting Stage |
| 2025-05-07 | `c31dd95` | Test Refactor Unity Execution in Deployment |

</details>

<details markdown>
<summary><strong>Phase 5: Full Jenkinsfile Cleanup and Integration (18 commits)</strong></summary>

| Date | Commit | Message |
|------|--------|---------|
| 2025-05-07 | `eef487b` | Temparory test |
| 2025-05-07 | `c432015` | Modulurized ssh shell scripting for Deploying WebGL to dlx-web hosting server |
| 2025-05-07 | `68626bb` | Initial Refactor completed |
| 2025-05-07 | `5aa21ce` | Initial Refactored jenkinsflies for DLX-PR, Deployment, and Pipeline Code |
| 2025-05-07 | `c5f85e8` | Improved Linting logic for Unity |
| 2025-05-07 | `ec9a895` | Polish ShellLibrary.groovy to improve readability |
| 2025-05-07 | `7a7f017` | Fixed incorrect python calling |
| 2025-05-07 | `00c271e` | git add . |
| 2025-05-07 | `7ae76ab` | Improved catchError function |
| 2025-05-07 | `f469267` | Refactored sendTestReport function in UnityHelper into ShellLibrary |
| 2025-05-07 | `3154ca8` | Added getting PR_COMMIT for pullrequest event webhook |
| 2025-05-07 | `92ee76a` | Updated stageInitialization groovy more readable |
| 2025-05-07 | `5e743b4` | Modified ShellScripting Logging Message |
| 2025-05-07 | `922b4b2` | Add dir function to get full commit hash |
| 2025-05-07 | `ce227c9` | Added one more logging for shellscript result |
| 2025-05-07 | `432064f` | Updated logging in stageInitialization |
| 2025-05-07 | `818100a` | Changed shellscript type for ssh |
| 2025-05-07 | `02311c4` | Added Connection check ssh |

</details>

<details markdown>
<summary><strong>Phase 6: SSH Library and Deployment Feature Completion (12 commits)</strong></summary>

| Date | Commit | Message |
|------|--------|---------|
| 2025-05-08 | `7deca3e` | Try to fix ssh command |
| 2025-05-08 | `02f76b7` | Check SSH Connectivity Modulurized |
| 2025-05-08 | `b42f4b8` | Added Network Connection Check |
| 2025-05-08 | `8ff97bc` | EconestogaDLX connection check |
| 2025-05-08 | `c4c8da5` | Added ConnectionAttempts for CheckSSHConnectivity |
| 2025-05-08 | `31950bd` | Added stripIndent for ssh |
| 2025-05-08 | `7ce9794` | Added stripIndent for every ssh shellscript |
| 2025-05-08 | `1e8e9dc` | Improved logging |
| 2025-05-08 | `1e94b39` | logging improved |
| 2025-05-08 | `7de89c2` | Added stripIdent() and trim() for every shellscript |
| 2025-05-08 | `a0e53db` | Fixed one git library |
| 2025-05-08 | `a381824` | Fixed typo |

</details>

<details markdown>
<summary><strong>Phase 7: Finalization and Bug Fixes (4 commits)</strong></summary>

| Date | Commit | Message |
|------|--------|---------|
| 2025-05-09 | `4db95fe` | Added missing package in Gladle test configuration |
| 2025-05-09 | `c54feff` | Delete artifact(dump file) of running test locally |
| 2025-05-09 | `10bec90` | Added Error handling for bitbucket api communication |
| 2025-05-12 | `ff74ac8` | Revert "Temparory test" |

</details>

---

## 3. Phase-by-Phase Detailed Analysis

### 3.1 Phase 1: PipelineForJenkins Stage Modularization

<details markdown>
<summary><strong>View Details</strong></summary>

**Duration**: 2025-05-05 ~ 2025-05-06 early (8 commits)

**Goal**: Stage modularization of first pipeline (PipelineForJenkins)

#### Work by Commit

| Commit | Work |
|--------|------|
| `8e96fb9` | Improved shellScriptHelper logging |
| `3ef978a` | Refactored LintGroovyJenkinsfile Stage |
| `9dcc23b` | Added logging to stageLintGroovyJenkinsfile |
| `6f4cf84` | Modularized Static Analysis Stage |
| `0e66b11` | Tested Static Analysis Stage |
| `87e8a89` | Replaced with modularized bitbucket api function in post steps |
| `2c2d821` | SonarQube refactoring test |
| `063955e` | Added missing package import variable |

**Learning Points**:
- Start refactoring with the simplest pipeline
- Separate each Stage into independent files in vars/ folder

</details>

---

### 3.2 Phase 2: DLX Pipeline Webhook Trigger Configuration

<details markdown>
<summary><strong>View Details</strong></summary>

**Duration**: 2025-05-06 (40 commits)

**Goal**: Implement GenericTrigger-based Webhook for DLX pipeline

#### Step 1: Webhook Trigger Initial Configuration (`4c8509e` ~ `79f6155`)

| Commit | Work |
|--------|------|
| `4c8509e` | Started DLX Pipeline refactoring, refactored Prepare Workspace Stage |
| `f25f136` | Commented out DLX Pipeline regexpFilter |
| `c26d434` ~ `163cff2` | Attempted to get HTTP request body/header |
| `e2fe075` ~ `1fff356` | HTTP request header test and logging modification |
| `d5eab38` ~ `79f6155` | Added Request Body/Header trigger, GenericTrigger configuration |

#### Step 2: HTTP Header Processing Issue Resolution (`0c004ac` ~ `50ea98a`)

| Commit | Attempt | Problem | Solution |
|--------|---------|---------|----------|
| `0c004ac` ~ `cbb805f` | Get x-event-key | JsonPath expression issue | Tried removing expression |
| `b6f2c58` ~ `b558e24` | Changed header access method | Tried lowercase/underscore | Tested various methods |
| `58edeec` | X-Event-Key | - | Used exact header name |
| `1811e1c` ~ `50ea98a` | Added regexpFilter | Environment variable access | Tried x_event_key |

#### Step 3: Webhook Completion and Environment Variable Setup (`cb5a64a` ~ `27dcc7c`)

| Commit | Work |
|--------|------|
| `cb5a64a` ~ `b1456e6` | Tested getting Branch name, HTTP body JSON |
| `374e775` | Completed Jenkins environment variable assignment for repo:push event |
| `76296e7` ~ `ee741e8` | Applied same implementation to DLX PR pipeline, fixed PR_BRANCH environment variable |
| `c9220f4` ~ `d9ed92e` | Fixed missing package import |
| `fc77459` ~ `27dcc7c` | Handled shellscript return value, separated DESTINATION_BRANCH assignment logic |

**Learning Points**:
- GenericTrigger plugin handles Bitbucket Webhook
- Access HTTP header variables with lowercase+underscore (x_event_key)
- Separate PR events and Push events with regexpFilter

</details>

---

### 3.3 Phase 3: DLX-PR-Pipeline Stage Modularization

<details markdown>
<summary><strong>View Details</strong></summary>

**Duration**: 2025-05-07 first half (24 commits)

**Goal**: Modularize Unity-related Stages for DLX PR pipeline

#### Step 1: Unity Linting Stage (`d8aab9b` ~ `ce58b16`)

| Commit | Attempt | Problem | Solution |
|--------|---------|---------|----------|
| `d8aab9b` | Refactored Unity Linting Stage | - | Started |
| `27dd597` ~ `88f815b` | Copy lint config file | shellscript issue | Attempted fix |
| `ce58b16` | Added sh | - | Added sh inside shellscript |

#### Step 2: Unity Test Stage (`ed7f993` ~ `319d413`)

| Commit | Work |
|--------|------|
| `ed7f993` ~ `c01107f` | Modularized EditMode Stage test |
| `59009e0` | Fixed how to use groovy file in vars |
| `319d413` | Refactored PlayMode, Coverage Stage |

#### Step 3: Build Stage and Finalization (`5b43e05` ~ `69357f0`)

| Commit | Work |
|--------|------|
| `5b43e05` ~ `6bd044f` | Refactored CopyWebGLBuilder, fixed package |
| `e9b7c70` | Changed Lighting/ReflectionProbe file check logic |
| `07f2646` ~ `4e0b1ff` | Improved logging style |
| `e2f47d3` | Refactored Build Project Stage |
| `f2828b3` ~ `703d90f` | Implemented stripIndent function (3 attempts) |
| `bb271db` | Fixed Unity headless mode argument |
| `85fea53` | Completed DLX-PR-Pipeline refactoring |
| `69357f0` | Pointed Library to Refactor-with-TDD branch |

**Learning Points**:
- Parameterize Unity-related Stages for reuse (testType: 'EditMode'/'PlayMode')
- stripIndent() function improves multiline script readability

</details>

---

### 3.4 Phase 4: DLX-Deployment Pipeline Refactoring

<details markdown>
<summary><strong>View Details</strong></summary>

**Duration**: 2025-05-07 middle (22 commits)

**Goal**: Refactor DLX Deployment(CD) pipeline

#### Step 1: Webhook and Basic Stage (`500ca0e` ~ `4bf13d8`)

| Commit | Work |
|--------|------|
| `500ca0e` | Deleted unnecessary function |
| `d54d03e` ~ `83e8eaf` | Tested filter for unmerged PR branch trigger |
| `8d0608a` | Added x-event-key header value for DLX-Deployment pipeline |
| `4bf13d8` | Deleted unnecessary try-catch |

#### Step 2: Cleanup PR Branch Artifacts Stage (`25187d9` ~ `790c946`)

| Commit | Attempt | Problem | Solution |
|--------|---------|---------|----------|
| `25187d9` | Refactored Delete Merged Branch Stage | - | Started |
| `5e6acfc` ~ `0857b38` | Moved logger location, debugged fileExists | - | Test |
| `201d711` ~ `a8d7bcd` | Refactored Cleanup PR Branch Artifacts | Directory finding issue | Attempted |
| `3e038c8` ~ `9b2f802` | Used different config property, tried wildcard | - | Test |
| `e1e312b` | Implementation complete | - | Final |
| `970293e` ~ `3234206` | Fixed unused trim, fixed FindPRJobDirectory return value | - | Bug fix |
| `18dbce2` | Stage modularization complete | - | Final |
| `7e5773d` ~ `c209fc0` | Integrated stageProjectPrepare (PR + Deployment) | - | Integration |
| `790c946` | Fixed PR artifacts delete logic for CD pipeline | - | Fix |

#### Step 3: Remaining Stage Refactoring (`9878a06` ~ `c31dd95`)

| Commit | Work |
|--------|------|
| `9878a06` | Refactored Linting Stage |
| `c31dd95` | Tested Deployment Unity Execution refactoring |

**Learning Points**:
- Share stageProjectPrepare between PR and Deployment pipelines
- PR artifact cleanup logic needs Jenkins workspace path handling

</details>

---

### 3.5 Phase 5: Full Jenkinsfile Cleanup and Integration

<details markdown>
<summary><strong>View Details</strong></summary>

**Duration**: 2025-05-07 second half (18 commits)

**Goal**: Clean up all Jenkinsfiles and implement SSH deployment

#### Step 1: SSH Deployment and Initial Cleanup (`eef487b` ~ `5aa21ce`)

| Commit | Work |
|--------|------|
| `eef487b` | Temporary test |
| `c432015` | Modularized WebGL deployment SSH shell scripting |
| `68626bb` | Initial refactoring complete |
| `5aa21ce` | Initial refactored Jenkinsfiles for DLX-PR, Deployment, and Pipeline Code |

#### Step 2: Detailed Improvements (`c5f85e8` ~ `432064f`)

| Commit | Work |
|--------|------|
| `c5f85e8` | Improved Unity Linting logic |
| `ec9a895` | Improved ShellLibrary.groovy readability |
| `7a7f017` | Fixed Python call |
| `00c271e` | git add |
| `7ae76ab` | Improved catchError function |
| `f469267` | Moved UnityHelper sendTestReport to ShellLibrary |
| `3154ca8` | Added PR_COMMIT for pullrequest event |
| `92ee76a` | Improved stageInitialization readability |
| `5e743b4` ~ `ce227c9` | Modified ShellScripting logging message |
| `432064f` | Updated stageInitialization logging |

#### Step 3: SSH Finalization (`818100a` ~ `02311c4`)

| Commit | Work |
|--------|------|
| `818100a` | Changed SSH shellscript type |
| `02311c4` | Added SSH connection check |

**Learning Points**:
- All pipelines use same Stage modules
- Abstract SSH commands into Library

</details>

---

### 3.6 Phase 6: SSH Library and Deployment Feature Completion

<details markdown>
<summary><strong>View Details</strong></summary>

**Duration**: 2025-05-08 (12 commits)

**Goal**: Complete SSHShellLibrary and stabilize deployment feature

#### Problem Solving Process

| Commit | Attempt | Problem | Solution |
|--------|---------|---------|----------|
| `7deca3e` | Fixed SSH command | Not working | Attempted |
| `02f76b7` | Modularized SSH Connectivity check | - | Implemented |
| `b42f4b8` ~ `8ff97bc` | Network connection check, EconestogaDLX connection | - | Added |
| `c4c8da5` | Added ConnectionAttempts | Connection failure | Retry logic |
| `31950bd` ~ `7ce9794` | Added stripIndent for SSH | Multiline issue | Applied to all SSH scripts |
| `1e8e9dc` ~ `1e94b39` | Improved logging | - | Improvement |
| `7de89c2` | Added stripIndent()/trim() to all shellscripts | Whitespace issue | Batch applied |
| `a0e53db` ~ `a381824` | Fixed Git library, fixed typo | Bug | Fixed |

**Learning Points**:
- stripIndent()/trim() required for SSH commands
- Handle retry with ConnectionAttempts for remote server connection

</details>

---

### 3.7 Phase 7: Finalization and Bug Fixes

<details markdown>
<summary><strong>View Details</strong></summary>

**Duration**: 2025-05-09 ~ 2025-05-12 (4 commits)

**Goal**: Final bug fixes and cleanup

#### Work by Commit

| Commit | Work |
|--------|------|
| `4db95fe` | Added missing package to Gradle test configuration |
| `c54feff` | Deleted local test run artifact (dump file) |
| `10bec90` | Added Bitbucket API communication error handling |
| `ff74ac8` | Reverted "Temporary test" |

**Learning Points**:
- Test artifacts need to be added to .gitignore
- API communication should always include error handling

</details>

---

## 4. New Stage Files (vars/)

| File | Lines | Purpose |
|------|-------|---------|
| stageInitialization.groovy | 102 | Jenkins environment initialization, environment variable setup |
| stageProjectPrepare.groovy | 115 | Git clone/checkout, branch synchronization, LFS |
| stageLintGroovyJenkinsfile.groovy | 96 | Groovy/Jenkinsfile static analysis (npm-groovy-lint) |
| stageLintUnity.groovy | 67 | Unity C# linting (Rider batch mode) |
| stageStaticAnalysis.groovy | 44 | SonarQube static code analysis |
| stageUnityExecution.groovy | 98 | Unity EditMode/PlayMode/Coverage tests |
| stageDeployBuild.groovy | 72 | WebGL build and deployment |
| stageCleanupPRBranchArtifacts.groovy | 55 | PR artifact cleanup after merge |
| stageSendBuildResults.groovy | 31 | Send Bitbucket build status |

## 5. New Libraries

### 5.1 `sharedLibraries/src/utils/SSHShellLibrary.groovy` (99 lines)
SSH command library (for WebGL deployment)
```groovy
class SSHShellLibrary {
    // SSH connection check
    static Closure CHECK_SSH_CONNECTIVITY = { host, user, keyPath ->
        "ssh -o BatchMode=yes -o ConnectTimeout=5 -i ${keyPath} ${user}@${host} 'echo ok'"
    }

    // Create remote directory
    static Closure SSH_CREATE_REMOTE_DIR = { host, user, keyPath, remotePath ->
        "ssh -i ${keyPath} ${user}@${host} 'mkdir -p ${remotePath}'"
    }

    // SCP file transfer
    static Closure SCP_COPY_TO_REMOTE = { localPath, host, user, keyPath, remotePath ->
        "scp -r -i ${keyPath} ${localPath} ${user}@${host}:${remotePath}"
    }

    // Delete remote directory
    static Closure SSH_REMOVE_REMOTE_DIR = { host, user, keyPath, remotePath ->
        "ssh -i ${keyPath} ${user}@${host} 'rm -rf ${remotePath}'"
    }
}
```

## 6. Jenkinsfile Transformation Example

### 6.1 Before (DLXJenkins/Jenkinsfile)
```groovy
pipeline {
    stages {
        stage('Prepare WORKSPACE') {
            steps {
                script {
                    // 50 lines of Git checkout logic
                    // 20 lines of environment variable setup
                    // 30 lines of error handling
                }
            }
        }
        stage('Linting') {
            steps {
                script {
                    // 40 lines of linting logic
                }
            }
        }
        // ... more stages
    }
}
```

### 6.2 After (DLXJenkins/Jenkinsfile)
```groovy
@Library('global-trusted-shared-library@main') _

pipeline {
    stages {
        stage('Initialization') {
            steps {
                stageInitialization()
            }
        }
        stage('Project Preparation') {
            steps {
                stageProjectPrepare()
            }
        }
        stage('Linting') {
            steps {
                stageLintUnity()
            }
        }
        stage('EditMode Tests') {
            steps {
                stageUnityExecution(testType: 'EditMode')
            }
        }
        stage('PlayMode Tests') {
            steps {
                stageUnityExecution(testType: 'PlayMode')
            }
        }
        stage('Build WebGL') {
            steps {
                stageDeployBuild(buildType: 'WebGL')
            }
        }
    }
    post {
        always {
            stageSendBuildResults()
        }
    }
}
```

## 7. Webhook Configuration Improvements

### 7.1 PullRequest vs Repo:Push Event Separation
```groovy
triggers {
    GenericTrigger(
        genericVariables: [
            [key: 'BITBUCKET_EVENT_KEY', value: '$.headers.x-event-key']
        ],
        regexpFilterExpression: '^pullrequest:.*',
        regexpFilterText: '$BITBUCKET_EVENT_KEY'
    )
}
```

### 7.2 Dynamic Environment Variable Assignment
```groovy
// PR event
if (env.BITBUCKET_EVENT_KEY.startsWith('pullrequest:')) {
    env.PR_BRANCH = env.BITBUCKET_SOURCE_BRANCH
    env.DESTINATION_BRANCH = env.BITBUCKET_DESTINATION_BRANCH
}
// Push event
else if (env.BITBUCKET_EVENT_KEY == 'repo:push') {
    env.PR_BRANCH = env.GIT_BRANCH.replaceFirst('origin/', '')
    env.DESTINATION_BRANCH = 'main'
}
```

## 8. Final Architecture

```
devops-jenkins-linux/
├── */Jenkinsfile                          # Layer 1: Entry Point
│   ├── DLXJenkins/Jenkinsfile
│   ├── DLXJenkins/JenkinsfileDeployment
│   ├── JsJenkins/Jenkinsfile
│   ├── JsJenkins/JenkinsfileDeployment
│   └── PipelineForJenkins/Jenkinsfile
│
└── sharedLibraries/
    ├── vars/                              # Layer 2: Orchestration
    │   ├── stageInitialization.groovy     # Stage Modules
    │   ├── stageProjectPrepare.groovy
    │   ├── stageLintGroovyJenkinsfile.groovy
    │   ├── stageLintUnity.groovy
    │   ├── stageStaticAnalysis.groovy
    │   ├── stageUnityExecution.groovy
    │   ├── stageDeployBuild.groovy
    │   ├── stageCleanupPRBranchArtifacts.groovy
    │   ├── stageSendBuildResults.groovy
    │   ├── shellScriptHelper.groovy       # Helpers
    │   ├── bitbucketApiHelper.groovy
    │   └── logger.groovy                  # Cross-Cutting
    │
    └── src/
        ├── service/                       # Layer 3: Services
        │   └── general/
        │       └── BitbucketApiService.groovy
        │
        ├── utils/                         # Layer 4: Utilities
        │   ├── GitLibrary.groovy
        │   ├── ShellLibrary.groovy
        │   └── SSHShellLibrary.groovy
        │
        └── resource/                      # Layer 4: Utilities (Constants)
            └── Status.groovy
```

## 9. Benefits

### 9.1 Code Reuse
- 5 pipelines use same Stage files
- Duplicate code removed

### 9.2 Easy Maintenance
- Modify only one file when changing Stage logic
- Jenkinsfile only defines pipeline structure

### 9.3 Improved Readability
- Jenkinsfile reads like a table of contents
- Clear role for each Stage

### 9.4 Testability
- Each Stage file can be tested independently
- Library functions can be unit tested

### 9.5 Consistent Logging
- All Stages use logger
- Standardized output format

## 10. Conclusion

**5 monolithic pipelines** → **4-Layer Architecture + Centralized Library**

- Jenkinsfile code volume reduced by approximately **70-78%**
- **12 reusable Stage modules** created
- **3 Shell libraries** (Git, Shell, SSH)
- **1 API service** (Bitbucket)
- **3-Level Logger** standard interface
