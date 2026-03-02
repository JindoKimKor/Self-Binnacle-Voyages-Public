# JS CI Pipeline Sequence Diagrams

> **Analysis Target**: `JsJenkins/Jenkinsfile` (JavaScript CI Pipeline)
>
> **Trigger**: Runs when PR is `OPEN`
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
| generalHelper | Web Server | `publishTestResultsHtmlToWebServer` | Unit Testing |
| generalHelper | SonarQube | `checkQualityGateStatus` | Static Analysis |
| generalHelper | Parsing | `parseJson` | Prepare WORKSPACE |
| generalHelper | Mixed (Bitbucket + Parsing) | `initializeEnvironment` | Prepare WORKSPACE |
| jsHelper | Node.js/npm | `checkNodeVersion`, `installNpmInTestingDirs`, `executeLintingInTestingDirs`, `runUnitTestsInTestingDirs` | Install Dependencies, Linting, Unit Testing |
| jsHelper | File System | `findTestingDirs`, `retrieveReportSummaryDirs` | Prepare WORKSPACE, Unit Testing |

### Jenkinsfile Direct Calls

| Domain | Direct Call | Used Stage |
|--------|-------------|------------|
| Jenkins Pipeline DSL | `pipeline`, `stages`, `post`, `script`, `dir`, `credentials`, `tool`, `withSonarQubeEnv`, `withCredentials` | All |
| File System | `mkdir -p` | Linting |
| SonarQube | `sonar-scanner` | Static Analysis |
| Bitbucket (Python) | `create_bitbucket_coverage_report.py` | Unit Testing |

### Domain Mapping by Stage

| Stage | Git | Bitbucket | Node.js | Web Server | SonarQube | Parsing | File System |
|-------|:---:|:---------:|:-------:|:----------:|:---------:|:-------:|:-----------:|
| Prepare WORKSPACE | ✓ | ✓ | | | | ✓ | ✓ |
| Install Dependencies | | | ✓ | | | | |
| Linting | | | ✓ | | | | ✓ |
| Unit Testing | | ✓ | ✓ | ✓ | | | ✓ |
| Static Analysis | | | | | ✓ | | |
| Post | ✓ | ✓ | | | | | |

---

## Overall Pipeline Overview
```mermaid
flowchart LR
    subgraph Stages
        S1[Prepare WORKSPACE]
        S2[Install Dependencies]
        S3[Linting]
        S4[Unit Testing]
        S5[Static Analysis]
    end

    S1 --> S2 --> S3 --> S4 --> S5

    S5 --> Post[Post<br/>always/success/failure/aborted]
```

---

## Stage 1: Prepare WORKSPACE
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant GH as generalHelper
    participant JSH as jsHelper
    participant Git as Git CLI
    participant Python as Python Scripts
    participant BB as Bitbucket API

    Note over JF: Stage: Prepare WORKSPACE

    JF->>JF: sh 'env' (print environment variables)
    JF->>GH: load("generalHelper.groovy")
    JF->>JSH: load("jsHelper.groovy")

    JF->>GH: parseJson()
    Note over GH: Domain: Parsing
    GH-->>JF: buildResults, stageResults

    JF->>GH: isBranchUpToDateWithRemote(PR_BRANCH)
    Note over GH: Domain: Git
    GH->>Git: git fetch origin
    GH->>Git: git rev-parse HEAD
    GH->>Git: git rev-parse origin/{branch}
    Git-->>GH: commit hashes
    GH-->>JF: true/false

    JF->>GH: getFullCommitHash(workspace, PR_COMMIT)
    Note over GH: Domain: Bitbucket
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
    Note over GH: Domain: Git
    GH->>Git: git clone / git fetch
    GH->>Git: git checkout
    GH->>Git: git reset --hard
    GH->>Git: git clean -fd
    Git-->>GH: OK
    GH-->>JF: OK

    JF->>GH: mergeBranchIfNeeded(prBranch)
    Note over GH: Domain: Git
    GH->>GH: getDefaultBranch()
    GH->>Git: git remote show origin
    Git-->>GH: default branch
    GH->>GH: isBranchUpToDateWithMain()
    GH->>Git: git merge-base --is-ancestor
    GH->>GH: tryMerge(defaultBranch)
    GH->>Git: git merge origin/{default}
    Git-->>GH: OK
    GH-->>JF: OK

    JF->>JSH: findTestingDirs(PROJECT_DIR)
    Note over JSH: Domain: File System
    JSH-->>JF: TEST_DIRECTORIES
```

---

## Stage 2: Install Dependencies
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant JSH as jsHelper
    participant NPM as npm CLI

    Note over JF: Stage: Install Dependencies

    JF->>JSH: checkNodeVersion()
    Note over JSH: Domain: Node.js/npm
    JSH->>NPM: node -v
    NPM-->>JSH: version
    JSH->>NPM: npm -v
    NPM-->>JSH: version

    JF->>JSH: installNpmInTestingDirs(TEST_DIRECTORIES)
    Note over JSH: Domain: Node.js/npm
    loop for each testDir
        JSH->>NPM: npm audit
        JSH->>NPM: npm install
        NPM-->>JSH: OK
    end
    JSH-->>JF: OK
```

---

## Stage 3: Linting
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant FS as File System
    participant JSH as jsHelper
    participant NPM as npm CLI

    Note over JF: Stage: Linting

    JF->>FS: mkdir -p linting_results

    JF->>JSH: executeLintingInTestingDirs(TEST_DIRECTORIES, false)
    Note over JSH: Domain: Node.js/npm
    loop for each testDir
        JSH->>NPM: npm run lint
        NPM-->>JSH: exitCode
    end
    JSH-->>JF: OK/FAIL
```

---

## Stage 4: Unit Testing
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant GH as generalHelper
    participant JSH as jsHelper
    participant NPM as npm CLI
    participant Python as Python Scripts
    participant BB as Bitbucket API
    participant WS as Web Server<br/>(SSH/SCP)

    Note over JF: Stage: Unit Testing

    JF->>JSH: runUnitTestsInTestingDirs(TEST_DIRECTORIES, false)
    Note over JSH: Domain: Node.js/npm
    loop for each testDir
        JSH->>NPM: npm test
        NPM-->>JSH: coverage-summary.json, test-results.json
    end
    JSH-->>JF: OK/FAIL

    Note over JF,WS: Publish coverage HTML to Web Server
    JF->>GH: publishTestResultsHtmlToWebServer(FOLDER_NAME, TICKET_NUMBER, lcov-report, 'server')
    Note over GH: Domain: Web Server
    GH->>WS: ssh mkdir -p /var/www/html/{folder}/{ticket}/server
    GH->>WS: scp -r lcov-report/*
    WS-->>GH: OK

    JF->>GH: publishTestResultsHtmlToWebServer(FOLDER_NAME, TICKET_NUMBER, lcov-report, 'client')
    GH->>WS: ssh mkdir -p /var/www/html/{folder}/{ticket}/client
    GH->>WS: scp -r lcov-report/*
    WS-->>GH: OK

    Note over JF,BB: Send coverage reports to Bitbucket
    alt params.SERVER_SOURCE_FOLDER exists
        JF->>JSH: retrieveReportSummaryDirs(serverDir)
        Note over JSH: Domain: File System
        JSH-->>JF: coverageSummaryDir, testSummaryDir
        JF->>Python: create_bitbucket_coverage_report.py --server
        Note over JF: Jenkinsfile Direct: Bitbucket (Python)
        Python->>BB: POST /reports
        BB-->>Python: OK
    end

    alt params.CLIENT_SOURCE_FOLDER exists
        JF->>JSH: retrieveReportSummaryDirs(clientDir)
        JSH-->>JF: coverageSummaryDir, testSummaryDir
        JF->>Python: create_bitbucket_coverage_report.py --client
        Python->>BB: POST /reports
        BB-->>Python: OK
    end
```

---

## Stage 5: Static Analysis
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant GH as generalHelper
    participant SQ as SonarQube

    Note over JF: Stage: Static Analysis

    JF->>SQ: sonar-scanner -Dsonar.projectKey={key} -Dsonar.sources=.
    Note over JF: Jenkinsfile Direct: SonarQube
    SQ-->>JF: analysis queued

    JF->>GH: checkQualityGateStatus(SONAR_PROJECT_KEY, token)
    Note over GH: Domain: SonarQube
    loop retry (max 5)
        GH->>SQ: GET /api/ce/component
        SQ-->>GH: queue status
        alt queue not empty
            GH->>GH: sleep(10)
        else queue empty
            GH->>SQ: GET /api/qualitygates/project_status
            SQ-->>GH: entireCodeStatus, newCodeStatus
        end
    end
    GH-->>JF: PASSED/FAILED

    alt status != OK
        Note over JF: catchError - stage FAILURE
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
        JF->>GH: sendBuildStatus(workspace, 'SUCCESSFUL', commitHash, false)
    else failure
        JF->>GH: sendBuildStatus(workspace, 'FAILED', commitHash, false)
    else aborted
        JF->>GH: sendBuildStatus(workspace, 'STOPPED', commitHash, false)
    end
    Note over GH: Domain: Bitbucket
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
| Jenkinsfile → generalHelper → External | `sendBuildStatus` → Python → Bitbucket API | 6 |
| Jenkinsfile → jsHelper → External | `installNpmInTestingDirs` → npm CLI | 4 |
| Jenkinsfile → Python direct | `create_bitbucket_coverage_report.py` | 2 |
| Jenkinsfile → SonarQube direct | `sonar-scanner` | 1 |

### DLX CI vs JS CI Comparison

| Item | DLX CI | JS CI |
|------|--------|-------|
| Build Tool | Unity CLI | Node.js (npm) |
| Helper | unityHelper | jsHelper |
| Install Dependencies | No | Yes (`installNpmInTestingDirs`) |
| Linting | Bash Script (C#) | jsHelper (`executeLintingInTestingDirs`) |
| Test Type | EditMode/PlayMode | Jest (`runUnitTestsInTestingDirs`) |
| Code Coverage | Unity Code Coverage | lcov-report |
| Static Analysis | No | SonarQube |
| Build Project | WebGL | No |
| `initializeEnvironment` | ✓ | ✓ |

### Inconsistencies

| Issue | Description |
|-------|-------------|
| Mixed domain function | `initializeEnvironment` combines Bitbucket + Parsing (SRP violation) |
| Direct Python calls | `create_bitbucket_coverage_report.py` bypasses Helper |
| Direct SonarQube call | `sonar-scanner` called directly, but `checkQualityGateStatus` via generalHelper |

---

[← Domain Mapping Summary](domain-mapping.md) | [JS CD →](js-cd.md)