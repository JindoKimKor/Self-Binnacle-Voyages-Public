# DLX CI Pipeline Sequence Diagrams

> **Analysis Target**: `DLXJenkins/Jenkinsfile` (DLX Unity CI Pipeline)
>
> **Related**: [Domain Mapping Summary](domain-mapping.md)

---

## Why Sequence Diagrams?

> **Q: Why use Sequence Diagrams for Jenkins Pipeline analysis?**
>
> A: Jenkins Pipeline is **procedural code**. Unlike OOP where classes naturally define domain boundaries, procedural code mixes multiple domains within sequential execution flow. Sequence Diagrams visualize the **call flow** between components, making it easier to identify which domains are involved at each stage.

> **Q: What is the goal of this analysis?**
>
> A: To **identify domains by function**. By tracing "who calls what", I can classify each function into its domain (Git, Bitbucket, Unity, etc.) and detect where domain boundaries are violated (e.g., one function mixing multiple domains).


---

## Domain Summary

### Helper Domains Used

| Helper | Domain | Functions Called | Used Stage |
|--------|--------|------------------|------------|
| generalHelper | Git | `cloneOrUpdateRepo`, `mergeBranchIfNeeded`, `isBranchUpToDateWithRemote`, `checkoutBranch` | Prepare WORKSPACE, Post |
| generalHelper | Bitbucket | `getFullCommitHash`, `sendBuildStatus` | Prepare WORKSPACE, Post |
| generalHelper | Web Server | `publishTestResultsHtmlToWebServer`, `publishBuildResultsToWebServer` | Code Coverage, Build Project |
| generalHelper | Parsing | `parseJson` | Prepare WORKSPACE |
| generalHelper | Mixed (Bitbucket + Parsing) | `initializeEnvironment` | Prepare WORKSPACE |
| unityHelper | Unity CLI | `runUnityStage` | Prepare WORKSPACE, EditMode, PlayMode, Code Coverage, Build Project |
| unityHelper | Unity Installation | `getUnityExecutable` | Prepare WORKSPACE |
| unityHelper | Bitbucket | `sendTestReport` | Code Coverage |

### Jenkinsfile Direct Calls

| Domain | Direct Call | Used Stage |
|--------|-------------|------------|
| Jenkins Pipeline DSL | `pipeline`, `stages`, `post`, `script`, `dir`, `credentials` | All |
| File System | `mkdir -p`, `cp` | Linting, EditMode, Build Project |
| Linting (Bash) | `sh Linting.bash` | Linting |
| Bitbucket (Python) | `linting_error_report.py`, `create_bitbucket_webgl_build_report.py` | Linting, Build Project |

### Domain Mapping by Stage

| Stage | Git | Bitbucket | Unity CLI | Unity Install | Web Server | Parsing | File System | Linting |
|-------|:---:|:---------:|:---------:|:-------------:|:----------:|:-------:|:-----------:|:-------:|
| Prepare WORKSPACE | ✓ | ✓ | ✓ | ✓ | | ✓ | | |
| Linting | | ✓ | | | | | ✓ | ✓ |
| EditMode Tests | | | ✓ | | | | ✓ | |
| PlayMode Tests | | | ✓ | | | | | |
| Code Coverage | | ✓ | ✓ | | ✓ | | | |
| Build Project | | ✓ | ✓ | | ✓ | | ✓ | |
| Post | ✓ | ✓ | | | | | | |

---

## Overall Pipeline Overview
```mermaid
flowchart LR
    subgraph Stages
        S1[Prepare WORKSPACE]
        S2[Linting]
        S3[EditMode Tests]
        S4[PlayMode Tests]
        S5[Code Coverage<br/>Send Reports]
        S6[Build Project]
    end

    S1 --> S2 --> S3 --> S4 --> S5 --> S6

    S6 --> Post[Post<br/>always/success/failure/aborted]
```

---

## Stage 1: Prepare WORKSPACE
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant GH as generalHelper
    participant UH as unityHelper
    participant Git as Git CLI
    participant BB as Bitbucket API
    participant Unity as Unity CLI
    participant Python as Python Scripts

    Note over JF: Stage: Prepare WORKSPACE

    JF->>JF: sh 'env' (print environment variables)
    JF->>GH: load("generalHelper.groovy")
    JF->>UH: load("unityHelper.groovy")

    JF->>GH: parseJson()
    GH-->>JF: buildResults, stageResults

    JF->>GH: isBranchUpToDateWithRemote(PR_BRANCH)
    GH->>Git: git fetch origin
    GH->>Git: git rev-parse HEAD
    GH->>Git: git rev-parse origin/{branch}
    Git-->>GH: commit hashes
    GH-->>JF: true/false

    JF->>GH: getFullCommitHash(PR_BRANCH)
    GH->>Python: get_bitbucket_commit_hash.py
    Python->>BB: GET /commits
    BB-->>Python: commit hash
    Python-->>GH: full commit hash
    GH-->>JF: COMMIT_HASH

    JF->>GH: initializeEnvironment(workspace, commitHash, prBranch)
    Note over GH: Mixed: Bitbucket + Parsing
    GH->>GH: sendBuildStatus('INPROGRESS')
    GH->>Python: send_bitbucket_build_status.py
    Python->>BB: POST /statuses/build
    GH->>GH: parseTicketNumber(prBranch)
    GH-->>JF: TICKET_NUMBER, FOLDER_NAME

    JF->>GH: cloneOrUpdateRepo(workspace, projectDir, prBranch)
    GH->>Git: git clone / git fetch
    GH->>Git: git checkout
    GH->>Git: git reset --hard
    GH->>Git: git clean -fd
    Git-->>GH: OK
    GH-->>JF: OK

    JF->>GH: mergeBranchIfNeeded(prBranch)
    GH->>GH: getDefaultBranch()
    GH->>Git: git remote show origin
    Git-->>GH: default branch
    GH->>GH: isBranchUpToDateWithMain()
    GH->>Git: git merge-base --is-ancestor
    GH->>GH: tryMerge(defaultBranch)
    GH->>Git: git merge origin/{default}
    Git-->>GH: OK
    GH-->>JF: OK

    JF->>UH: getUnityExecutable(workspace, projectDir)
    UH->>Python: get_unity_version.py (executable-path)
    Python-->>UH: unity path
    UH-->>JF: UNITY_EXECUTABLE

    JF->>UH: runUnityStage('Rider', errorMsg)
    UH->>UH: runUnityBatchMode('Rider')
    UH->>Unity: unity -batchmode -executeMethod Rider.SyncSolution
    Unity-->>UH: exit code
    UH-->>JF: OK
```

---

## Stage 2: Linting
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant FS as File System
    participant Bash as Bash Scripts
    participant Python as Python Scripts
    participant BB as Bitbucket API

    Note over JF: Stage: Linting

    JF->>FS: mkdir -p linting_results
    JF->>FS: cp .editorconfig
    JF->>Bash: sh Linting.bash
    Bash-->>JF: exitCode

    alt exitCode == 2 (lint errors)
        JF->>Python: linting_error_report.py (fail)
        Python->>BB: POST /reports
    else exitCode == 0
        JF->>Python: linting_error_report.py (pass)
        Python->>BB: POST /reports
    end
```

---

## Stage 3: EditMode Tests
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant FS as File System
    participant UH as unityHelper
    participant Unity as Unity CLI

    Note over JF: Stage: EditMode Tests

    JF->>FS: mkdir -p test_results
    JF->>FS: mkdir -p coverage_results

    JF->>UH: runUnityStage('EditMode', errorMsg)
    UH->>UH: runUnityBatchMode('EditMode')
    UH->>UH: setLogFilePathAndUrl()
    UH->>UH: getTestRunArgs()
    UH->>UH: getCodeCoverageArguments()
    UH->>Unity: unity -batchmode -nographics -testPlatform EditMode -runTests -enableCodeCoverage
    Unity-->>UH: exit code + test_results/*.xml
    UH-->>JF: OK/FAIL
```

---

## Stage 4: PlayMode Tests
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant UH as unityHelper
    participant Unity as Unity CLI

    Note over JF: Stage: PlayMode Tests

    JF->>UH: runUnityStage('PlayMode', errorMsg)
    UH->>UH: runUnityBatchMode('PlayMode')
    UH->>Unity: xvfb-run unity -batchmode -testPlatform PlayMode -runTests -enableCodeCoverage
    Unity-->>UH: exit code + test_results/*.xml
    UH-->>JF: OK/FAIL
```

---

## Stage 5: Code Coverage & Send Reports
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant GH as generalHelper
    participant UH as unityHelper
    participant Unity as Unity CLI
    participant Python as Python Scripts
    participant BB as Bitbucket API
    participant WS as Web Server<br/>(SSH/SCP)

    Note over JF: Stage: Code Coverage & Send Reports

    JF->>UH: runUnityStage('Coverage', errorMsg)
    UH->>UH: runUnityBatchMode('Coverage')
    UH->>UH: loadPathsToExclude()
    Note over UH: Read Settings.json
    UH->>UH: fetCoverageOptionsKeyAndValue()
    UH->>UH: buildCoverageOptions()
    UH->>Unity: unity -batchmode -nographics -enableCodeCoverage -coverageOptions
    Unity-->>UH: coverage_results/Report
    UH-->>JF: OK/FAIL

    JF->>GH: publishTestResultsHtmlToWebServer(folderName, ticketNum, reportPath, 'CodeCoverage')
    GH->>WS: ssh mkdir -p /var/www/html/{folder}/{ticket}/CodeCoverage
    GH->>WS: scp -r coverage_results/Report/*
    GH->>WS: ssh chmod 755 & chown
    WS-->>GH: OK
    GH-->>JF: OK

    JF->>UH: sendTestReport(workspace, reportDir, commitHash)
    UH->>Python: create_bitbucket_test_report.py
    Python->>BB: POST /reports
    BB-->>Python: OK
    UH-->>JF: OK
```

---

## Stage 6: Build Project
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant FS as File System
    participant GH as generalHelper
    participant UH as unityHelper
    participant Unity as Unity CLI
    participant Python as Python Scripts
    participant BB as Bitbucket API
    participant WS as Web Server<br/>(SSH/SCP)

    Note over JF: Stage: Build Project

    JF->>FS: mkdir -p Assets/Editor
    JF->>FS: cp Builder.cs Assets/Editor/

    JF->>UH: runUnityStage('Webgl', errorMsg)
    UH->>UH: runUnityBatchMode('Webgl')
    UH->>Unity: xvfb-run unity -batchmode -buildTarget WebGL -executeMethod Builder.BuildWebGL
    Unity-->>UH: Builds/* + build_project_results/*.log
    UH-->>JF: OK/FAIL

    JF->>Python: create_bitbucket_webgl_build_report.py (commitHash, logPath)
    Python->>BB: POST /reports
    BB-->>Python: OK

    JF->>GH: publishBuildResultsToWebServer(folderName, ticketNum, buildsPath, resultsPath)
    GH->>WS: ssh mkdir -p /var/www/html/{folder}/{ticket}/build
    GH->>WS: scp -r Builds/*
    GH->>WS: scp -r build_project_results/*
    GH->>WS: ssh chmod 755 & chown
    WS-->>GH: OK
    GH-->>JF: OK
```

---

## Post: always/success/failure/aborted
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant GH as generalHelper
    participant Git as Git CLI
    participant Python as Python Scripts
    participant BB as Bitbucket API

    Note over JF: Post: always/success/failure/aborted

    Note over JF,GH: always block
    JF->>GH: checkoutBranch(PROJECT_DIR, DESTINATION_BRANCH)
    GH->>Git: git reset --hard
    GH->>Git: git clean -fd
    GH->>Git: git checkout {destination}
    GH->>Git: git reset --hard origin/{destination}
    Git-->>GH: OK
    GH-->>JF: OK
    JF->>JF: currentBuild.description = PR_BRANCH

    Note over JF,GH: success/failure/aborted
    alt success
        JF->>GH: sendBuildStatus(workspace, 'SUCCESSFUL', commitHash)
    else failure
        JF->>GH: sendBuildStatus(workspace, 'FAILED', commitHash)
    else aborted
        JF->>GH: sendBuildStatus(workspace, 'STOPPED', commitHash)
    end
    GH->>Python: send_bitbucket_build_status.py
    Python->>BB: POST /statuses/build
    BB-->>Python: OK
    GH-->>JF: OK
```

---

## Observations

### Delegation Pattern

| Pattern | Example | Count |
|---------|---------|:-----:|
| Jenkinsfile → generalHelper → External | `sendBuildStatus` → Python → Bitbucket API | 5 |
| Jenkinsfile → unityHelper → External | `runUnityStage` → Unity CLI | 5 |
| Jenkinsfile → Python direct | `linting_error_report.py` | 2 |
| Jenkinsfile → Bash direct | `Linting.bash` | 1 |

### Inconsistencies

| Issue | Description |
|-------|-------------|
| Direct Python calls | `linting_error_report.py`, `create_bitbucket_webgl_build_report.py` bypass Helper |
| Mixed domain function | `initializeEnvironment` combines Bitbucket + Parsing (SRP violation) |
| Inconsistent Bitbucket reporting | `sendTestReport` in unityHelper, but linting/build reports called directly |

---

[← Domain Mapping Summary](domain-mapping.md)