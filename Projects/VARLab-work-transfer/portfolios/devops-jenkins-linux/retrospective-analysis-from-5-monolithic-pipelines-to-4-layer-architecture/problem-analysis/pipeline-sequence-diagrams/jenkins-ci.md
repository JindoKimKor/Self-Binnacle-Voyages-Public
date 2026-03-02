# Jenkins CI Pipeline Sequence Diagrams

> **Analysis Target**: `PipelineForJenkins/Jenkinsfile` (Jenkins Groovy CI Pipeline)
>
> **Trigger**: Runs when PR is `OPEN` or `MERGED` (differs from other pipelines)
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
| generalHelper | Git | `cloneOrUpdateRepo`, `isBranchUpToDateWithRemote`, `checkoutBranch` | Prepare WORKSPACE |
| generalHelper | Bitbucket | `getFullCommitHash`, `sendBuildStatus` | Prepare WORKSPACE, Post |
| generalHelper | Web Server | `publishGroovyDocToWebServer` | Generate Groovydoc (MERGED only) |
| generalHelper | SonarQube | `checkQualityGateStatus` | Static Analysis |
| generalHelper | Parsing | `parseJson` | Prepare WORKSPACE |
| generalHelper | Mixed (Bitbucket + Parsing) | `initializeEnvironment` | Prepare WORKSPACE |

### Jenkinsfile Direct Calls

| Domain | Direct Call | Used Stage |
|--------|-------------|------------|
| Jenkins Pipeline DSL | `pipeline`, `stages`, `post`, `script`, `dir`, `credentials`, `tool`, `withSonarQubeEnv`, `withCredentials`, `docker.image().inside()`, `junit` | All |
| Docker | `docker info`, `docker.image().inside()`, `npm-groovy-lint` | Lint Groovy Code |
| Gradle | `gradle test` | Run Unit Tests |
| Groovydoc | `groovydoc` | Generate Groovydoc |
| File System | `mkdir -p`, `find` | Generate Groovydoc |
| SonarQube | `sonar-scanner` | Static Analysis |
| Bitbucket (Python) | `Lint_groovy_report.py` | Lint Groovy Code |

### Domain Mapping by Stage

| Stage | Git | Bitbucket | Docker | Gradle | Groovydoc | Web Server | SonarQube | Parsing | File System |
|-------|:---:|:---------:|:------:|:------:|:---------:|:----------:|:---------:|:-------:|:-----------:|
| Prepare WORKSPACE | ✓ | ✓ | | | | | | ✓ | |
| Lint Groovy Code | | ✓ | ✓ | | | | | | |
| Generate Groovydoc | | | | | ✓ | ✓* | | | ✓ |
| Run Unit Tests | | | | ✓ | | | | | |
| Publish Test Results | | | | | | | | | |
| Static Analysis | | | | | | | ✓ | | |
| Post | | ✓ | | | | | | | |

> *Web Server: Groovydoc deployed only when `PR_STATE == 'MERGED'`

---

## Overall Pipeline Overview
```mermaid
flowchart LR
    subgraph Stages
        S1[Prepare WORKSPACE]
        S2[Lint Groovy Code]
        S3[Generate Groovydoc]
        S4[Run Unit Tests]
        S5[Publish Test Results]
        S6[Static Analysis]
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
    participant Git as Git CLI
    participant Python as Python Scripts
    participant BB as Bitbucket API

    Note over JF: Stage: Prepare WORKSPACE

    JF->>GH: load("generalHelper.groovy")

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

    JF->>GH: checkoutBranch(PROJECT_DIR, PR_BRANCH)
    Note over GH: Domain: Git
    GH->>Git: git reset --hard
    GH->>Git: git clean -fd
    GH->>Git: git checkout {branch}
    GH->>Git: git reset --hard origin/{branch}
    Git-->>GH: OK
    GH-->>JF: OK
```

> **Note**: Unlike other CI pipelines, Jenkins CI does **not** call `mergeBranchIfNeeded`

---

## Stage 2: Lint Groovy Code
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant Docker as Docker Container<br/>(npm-groovy-lint)
    participant Python as Python Scripts
    participant BB as Bitbucket API

    Note over JF: Stage: Lint Groovy Code

    JF->>JF: docker info
    Note over JF: Jenkinsfile Direct: Docker

    JF->>Docker: docker.image('nvuillam/npm-groovy-lint').inside()
    Note over Docker: Lint Groovy scripts
    Docker->>Docker: npm-groovy-lint --path groovy --output groovy-lint-report.json
    Docker-->>JF: exitCodeGroovy

    JF->>Docker: docker.image('nvuillam/npm-groovy-lint').inside()
    Note over Docker: Lint Jenkinsfiles
    Docker->>Docker: npm-groovy-lint --path DLXJenkins,JsJenkins,PipelineForJenkins
    Docker-->>JF: exitCodeJenkins

    alt exitCodeGroovy != 0 OR exitCodeJenkins != 0
        JF->>Python: Lint_groovy_report.py ... Fail
        Note over JF: Jenkinsfile Direct: Bitbucket (Python)
        Python->>BB: POST /reports
        BB-->>Python: OK
        Note over JF: catchError - stage FAILURE
    else all passed
        JF->>Python: Lint_groovy_report.py ... Pass
        Python->>BB: POST /reports
        BB-->>Python: OK
    end
```

---

## Stage 3: Generate Groovydoc
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant FS as File System
    participant Groovy as Groovydoc CLI
    participant GH as generalHelper
    participant WS as Web Server<br/>(SSH/SCP)

    Note over JF: Stage: Generate Groovydoc

    JF->>FS: find ${PROJECT_DIR}/groovy -type f -name '*.groovy'
    Note over JF: Jenkinsfile Direct: File System
    FS-->>JF: fileList

    JF->>FS: mkdir -p ${REPORT_DIR}

    JF->>Groovy: groovydoc -d ${REPORT_DIR} ${fileList}
    Note over JF: Jenkinsfile Direct: Groovydoc
    Groovy-->>JF: build/docs/groovydoc/

    alt PR_STATE == 'MERGED'
        JF->>GH: publishGroovyDocToWebServer(REPORT_DIR)
        Note over GH: Domain: Web Server
        GH->>WS: ssh mkdir -p /var/www/html/Jenkins/GroovyDoc
        GH->>WS: ssh rm -rf (clean old)
        GH->>WS: scp -r groovydoc/*
        GH->>WS: ssh find ... chmod 755/644
        WS-->>GH: OK
        GH-->>JF: OK
    end
```

---

## Stage 4: Run Unit Tests
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant Gradle as Gradle CLI

    Note over JF: Stage: Run Unit Tests

    JF->>Gradle: gradle test
    Note over JF: Jenkinsfile Direct: Gradle
    Gradle->>Gradle: Spock Framework test execution
    Gradle-->>JF: build/test-results/test/*.xml
    Gradle-->>JF: build/reports/tests/test/index.html
    Gradle-->>JF: exitCode

    alt exitCode != 0
        Note over JF: catchError - stage FAILURE
    end
```

---

## Stage 5: Publish Test Results
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant Jenkins as Jenkins JUnit Plugin

    Note over JF: Stage: Publish Test Results

    JF->>Jenkins: junit 'build/test-results/test/*.xml'
    Note over JF: Jenkins Pipeline DSL
    Jenkins-->>JF: Test results published
```

> **Note**: Unlike other pipelines, Jenkins CI does **not** send test/coverage reports to Bitbucket via Python scripts

---

## Stage 6: Static Analysis
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
    participant Python as Python Scripts
    participant BB as Bitbucket API

    Note over JF: Post: always/success/failure/aborted

    Note over JF: always block
    JF->>JF: currentBuild.description = PR_BRANCH
    Note over JF: No checkoutBranch call (differs from other pipelines)

    Note over JF,GH: success/failure/aborted
    alt success
        JF->>GH: sendBuildStatus(workspace, 'SUCCESSFUL', commitHash)
    else failure
        JF->>GH: sendBuildStatus(workspace, 'FAILED', commitHash)
    else aborted
        JF->>GH: sendBuildStatus(workspace, 'STOPPED', commitHash)
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
| Jenkinsfile → generalHelper → External | `sendBuildStatus` → Python → Bitbucket API | 4 |
| Jenkinsfile → Docker direct | `docker.image().inside()` → npm-groovy-lint | 2 |
| Jenkinsfile → Gradle direct | `gradle test` | 1 |
| Jenkinsfile → Groovydoc direct | `groovydoc` | 1 |
| Jenkinsfile → SonarQube direct | `sonar-scanner` | 1 |
| Jenkinsfile → Python direct | `Lint_groovy_report.py` | 1 |

### CI Pipeline Comparison (DLX CI vs JS CI vs Jenkins CI)

| Item | DLX CI | JS CI | Jenkins CI |
|------|--------|-------|------------|
| Tool | Unity CLI | Node.js (npm) | Gradle + Docker |
| Helper | unityHelper | jsHelper | **(none)** |
| Trigger | OPEN | OPEN | **OPEN + MERGED** |
| `initializeEnvironment` | ✓ | ✓ | ✓ |
| `mergeBranchIfNeeded` | ✓ | ✓ | **✗** |
| `checkoutBranch` in Post | ✓ | ✓ | **✗** |
| Linting | Bash Script (C#) | jsHelper (ESLint) | Docker (npm-groovy-lint) |
| Test Type | EditMode/PlayMode | Jest | Spock (Gradle) |
| Code Coverage | Unity Code Coverage | lcov-report | JaCoCo |
| Static Analysis | No | SonarQube | SonarQube |
| Build Project | WebGL | No | No |
| Documentation | No | No | **Groovydoc** |
| Test Report to Bitbucket | ✓ (Python) | ✓ (Python) | **✗** |

### Inconsistencies

| Issue | Description |
|-------|-------------|
| Mixed domain function | `initializeEnvironment` combines Bitbucket + Parsing (SRP violation) |
| No `mergeBranchIfNeeded` | Unlike other CI pipelines, does not merge default branch before build |
| No `checkoutBranch` in Post | Unlike other pipelines, does not return to destination branch after build |
| No test report to Bitbucket | Unlike DLX CI and JS CI, does not send test/coverage reports via Python |
| No dedicated Helper | Unlike DLX (unityHelper) and JS (jsHelper), no project-specific helper |

---

[← JS CD](js-cd.md) | [Domain Mapping Summary →](domain-mapping.md)