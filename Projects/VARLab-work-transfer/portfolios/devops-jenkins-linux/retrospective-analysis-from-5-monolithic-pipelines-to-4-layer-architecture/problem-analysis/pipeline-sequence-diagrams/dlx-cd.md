# DLX CD Pipeline Sequence Diagrams

> **Analysis Target**: `DLXJenkins/JenkinsfileDeployment` (DLX Unity CD Pipeline)
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
| generalHelper | Git | `checkoutBranch` | Post |
| generalHelper | Bitbucket | `getFullCommitHash`, `sendBuildStatus` | Delete Merged Branch, Prepare WORKSPACE, Post |
| generalHelper | Web Server | `cleanMergedBranchFromWebServer` | Delete Merged Branch |
| generalHelper | Parsing | `parseJson`, `parseTicketNumber` | Delete Merged Branch |
| generalHelper | File System | `cleanUpPRBranch` | Delete Merged Branch |
| unityHelper | Unity CLI | `runUnityStage` | Prepare WORKSPACE, EditMode, PlayMode, Build Project |
| unityHelper | Unity Installation | `getUnityExecutable` | Prepare WORKSPACE |

### Jenkinsfile Direct Calls

| Domain | Direct Call | Used Stage |
|--------|-------------|------------|
| Jenkins Pipeline DSL | `pipeline`, `stages`, `post`, `script`, `dir`, `credentials` | All |
| Git | `git clone`, `git checkout`, `git reset`, `git pull` | Prepare WORKSPACE |
| File System | `mkdir -p`, `cp`, `mv` | Linting, EditMode, Build Project |
| Linting (Bash) | `sh Linting.bash` | Linting |
| Web Server (SSH/SCP) | `ssh mkdir`, `ssh chown`, `scp`, `ssh bash UpdateBuildURL.sh` | Deploy Build |

### Domain Mapping by Stage

| Stage | Git | Bitbucket | Unity CLI | Unity Install | Web Server | Parsing | File System | Linting |
|-------|:---:|:---------:|:---------:|:-------------:|:----------:|:-------:|:-----------:|:-------:|
| Delete Merged Branch | | ✓ | | | ✓ | ✓ | ✓ | |
| Prepare WORKSPACE | ✓ | ✓ | ✓ | ✓ | | | | |
| Linting | | | | | | | ✓ | ✓ |
| EditMode Tests | | | ✓ | | | | ✓ | |
| PlayMode Tests | | | ✓ | | | | | |
| Build Project | | | ✓ | | | | ✓ | |
| Deploy Build | | | | | ✓ | | | |
| Post | ✓ | ✓ | | | | | | |

---

## Overall Pipeline Overview
```mermaid
flowchart LR
    subgraph Stages
        S1[Delete Merged Branch]
        S2[Prepare WORKSPACE]
        S3[Linting]
        S4[EditMode Tests]
        S5[PlayMode Tests]
        S6[Build Project]
        S7[Deploy Build]
    end

    S1 --> S2 --> S3 --> S4 --> S5 --> S6 --> S7

    S7 --> Post[Post<br/>always/success/failure/aborted]
```

---

## Stage 1: Delete Merged Branch
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant GH as generalHelper
    participant Python as Python Scripts
    participant BB as Bitbucket API
    participant WS as Web Server<br/>(SSH/SCP)

    Note over JF: Stage: Delete Merged Branch

    JF->>GH: load("generalHelper.groovy")
    JF->>GH: load("unityHelper.groovy")

    JF->>GH: parseJson()
    Note over GH: Domain: Parsing
    GH-->>JF: buildResults, stageResults

    JF->>JF: mainBranches.contains(DESTINATION_BRANCH)
    Note over JF: Abort if not merging to main

    JF->>GH: getFullCommitHash(workspace, PR_COMMIT)
    Note over GH: Domain: Bitbucket
    GH->>Python: get_bitbucket_commit_hash.py
    Python->>BB: GET /commits
    BB-->>Python: commit hash
    Python-->>GH: full commit hash
    GH-->>JF: COMMIT_HASH

    JF->>GH: cleanUpPRBranch(PR_BRANCH)
    Note over GH: Domain: File System
    GH-->>JF: find & rm -rf PR directories

    JF->>GH: parseTicketNumber(PR_BRANCH)
    Note over GH: Domain: Parsing
    GH-->>JF: ticketNumber

    JF->>GH: cleanMergedBranchFromWebServer(FOLDER_NAME, ticketNumber)
    Note over GH: Domain: Web Server
    GH->>WS: ssh rm -rf /var/www/html/{folder}/PR-Builds/{ticket}
    WS-->>GH: OK
    GH-->>JF: OK
```

---

## Stage 2: Prepare WORKSPACE
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant GH as generalHelper
    participant UH as unityHelper
    participant Git as Git CLI
    participant Python as Python Scripts
    participant BB as Bitbucket API
    participant Unity as Unity CLI

    Note over JF: Stage: Prepare WORKSPACE

    Note over JF,Git: Jenkinsfile Direct Git Calls
    alt !fileExists(PROJECT_DIR)
        JF->>Git: git clone {REPO_SSH} {PROJECT_DIR}
    end

    JF->>Git: git checkout {DESTINATION_BRANCH}
    JF->>Git: git reset --hard HEAD
    JF->>Git: git pull

    JF->>GH: sendBuildStatus(workspace, 'INPROGRESS', commitHash, true)
    Note over GH: Domain: Bitbucket
    GH->>Python: send_bitbucket_build_status.py -d
    Python->>BB: POST /statuses/build
    BB-->>Python: OK

    JF->>UH: getUnityExecutable(workspace, projectDir)
    Note over UH: Domain: Unity Installation
    UH->>Python: get_unity_version.py (executable-path)
    Python-->>UH: unity path
    UH-->>JF: UNITY_EXECUTABLE

    JF->>UH: runUnityStage('Rider', errorMsg)
    Note over UH: Domain: Unity CLI
    UH->>UH: runUnityBatchMode('Rider')
    UH->>Unity: unity -batchmode -executeMethod Rider.SyncSolution
    Unity-->>UH: exit code
    UH-->>JF: OK
```

---

## Stage 3: Linting
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant FS as File System
    participant Bash as Bash Scripts

    Note over JF: Stage: Linting

    JF->>FS: mkdir -p linting_results
    JF->>FS: cp .editorconfig
    JF->>Bash: sh Linting.bash
    Bash-->>JF: exitCode

    alt exitCode != 0
        Note over JF: catchError - stage FAILURE
    end
```

> **Note**: In DLX CD, linting results are **not** reported to Bitbucket (differs from CI)

---

## Stage 4: EditMode Tests
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant FS as File System
    participant UH as unityHelper
    participant Unity as Unity CLI

    Note over JF: Stage: EditMode Tests

    JF->>FS: mkdir -p test_results

    JF->>UH: runUnityStage('EditMode', errorMsg)
    UH->>UH: runUnityBatchMode('EditMode')
    UH->>Unity: unity -batchmode -nographics -testPlatform EditMode -runTests
    Unity-->>UH: exit code + test_results/*.xml
    UH-->>JF: OK/FAIL
```

> **Note**: In DLX CD, Code Coverage is **not** generated (CI_PIPELINE=false)

---

## Stage 5: PlayMode Tests
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant UH as unityHelper
    participant Unity as Unity CLI

    Note over JF: Stage: PlayMode Tests

    JF->>UH: runUnityStage('PlayMode', errorMsg)
    UH->>UH: runUnityBatchMode('PlayMode')
    UH->>Unity: xvfb-run unity -batchmode -testPlatform PlayMode -runTests
    Unity-->>UH: exit code + test_results/*.xml
    UH-->>JF: OK/FAIL
```

---

## Stage 6: Build Project
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant FS as File System
    participant UH as unityHelper
    participant Unity as Unity CLI

    Note over JF: Stage: Build Project

    JF->>FS: mkdir -p Assets/Editor
    JF->>FS: mv Builder.cs Assets/Editor/

    JF->>UH: runUnityStage('Webgl', errorMsg)
    UH->>UH: runUnityBatchMode('Webgl')
    UH->>Unity: xvfb-run unity -batchmode -buildTarget WebGL -executeMethod Builder.BuildWebGL
    Unity-->>UH: Builds/*
    UH-->>JF: OK/FAIL
```

> **Note**: In DLX CD, Build Report is **not** sent to Bitbucket (differs from CI)

---

## Stage 7: Deploy Build
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant WS1 as LTI Web Server
    participant WS2 as eConestoga DLX Server

    Note over JF: Stage: Deploy Build
    Note over JF: Jenkinsfile Direct Web Server Calls

    Note over JF,WS1: Deploy to LTI Web Server
    JF->>WS1: ssh mkdir -p /var/www/html/{FOLDER_NAME}
    JF->>WS1: ssh chown vconadmin:vconadmin
    JF->>WS1: scp -rp Builds/*
    JF->>WS1: ssh bash UpdateBuildURL.sh
    WS1-->>JF: OK

    alt DLX_PROJECT_LIST.contains(PR_REPO_NAME)
        Note over JF,WS2: Deploy to eConestoga DLX Server
        JF->>WS2: ssh mkdir -p /var/www/html/{FOLDER_NAME}
        JF->>WS2: ssh chown vconadmin:vconadmin
        JF->>WS2: scp -rp Builds/*
        JF->>WS2: ssh bash UpdateBuildURL.sh
        WS2-->>JF: OK
    end
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
    JF->>JF: currentBuild.description = PR_BRANCH
    JF->>GH: checkoutBranch(PROJECT_DIR, DESTINATION_BRANCH)
    Note over GH: Domain: Git
    GH->>Git: git reset --hard
    GH->>Git: git clean -fd
    GH->>Git: git checkout {destination}
    GH->>Git: git reset --hard origin/{destination}
    Git-->>GH: OK
    GH-->>JF: OK

    Note over JF,GH: success/failure/aborted
    alt success
        JF->>GH: sendBuildStatus(workspace, 'SUCCESSFUL', commitHash, true)
    else failure
        JF->>GH: sendBuildStatus(workspace, 'FAILED', commitHash, true)
    else aborted
        JF->>GH: sendBuildStatus(workspace, 'STOPPED', commitHash, true)
    end
    Note over GH: Domain: Bitbucket
    GH->>Python: send_bitbucket_build_status.py -d
    Python->>BB: POST /statuses/build
    BB-->>Python: OK
    GH-->>JF: OK
```

---

## Observations

### Delegation Pattern

| Pattern | Example | Count |
|---------|---------|:-----:|
| Jenkinsfile → generalHelper → External | `sendBuildStatus` → Python → Bitbucket API | 3 |
| Jenkinsfile → unityHelper → External | `runUnityStage` → Unity CLI | 4 |
| Jenkinsfile → Git direct | `git clone`, `git checkout`, `git pull` | 4 |
| Jenkinsfile → Web Server direct | `ssh`, `scp` in Deploy Build | 8 |
| Jenkinsfile → Bash direct | `Linting.bash` | 1 |

### CI vs CD Differences

| Item | DLX CI | DLX CD |
|------|--------|--------|
| Linting report to Bitbucket | ✓ | ✗ |
| Code Coverage generation | ✓ | ✗ |
| Build report to Bitbucket | ✓ | ✗ |
| Test report to Bitbucket | ✓ | ✗ |
| Web Server deployment | PR-Builds (reports) | Production (builds) |
| Git operations | Via generalHelper | Mixed (direct + helper) |

### Inconsistencies

| Issue | Description |
|-------|-------------|
| Mixed Git delegation | CI uses `cloneOrUpdateRepo`, CD uses direct Git commands in Prepare WORKSPACE |
| Mixed Web Server delegation | Delete Merged Branch uses helper, Deploy Build uses direct calls |
| No `initializeEnvironment` | CD calls `sendBuildStatus` directly instead of using mixed function |

---

[← Domain Mapping Summary](domain-mapping.md) | [DLX CI →](dlx-ci.md)