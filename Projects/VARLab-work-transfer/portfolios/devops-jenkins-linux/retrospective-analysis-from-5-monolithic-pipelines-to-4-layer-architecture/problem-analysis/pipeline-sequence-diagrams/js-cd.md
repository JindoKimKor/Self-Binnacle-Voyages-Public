# JS CD Pipeline Sequence Diagrams

> **Analysis Target**: `JsJenkins/JenkinsfileDeployment` (JavaScript CD Pipeline)
>
> **Trigger**: Runs when PR is `MERGED`
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
| generalHelper | Bitbucket | `getFullCommitHash`, `sendBuildStatus` | Prepare WORKSPACE, Post |
| generalHelper | SonarQube | `checkQualityGateStatus` | Static Analysis |
| generalHelper | Parsing | `parseJson` | Delete Merged Branch |
| jsHelper | Node.js/npm | `installNpmInTestingDirs`, `executeLintingInTestingDirs`, `runUnitTestsInTestingDirs`, `getPackageJsonVersion` | Install Dependencies, Linting, Unit Testing, Server/Client Deploy |
| jsHelper | File System | `findTestingDirs` | Prepare WORKSPACE |
| jsHelper | Utility | `versionCompare` | Server/Client Deploy |

### Jenkinsfile Direct Calls

| Domain | Direct Call | Used Stage |
|--------|-------------|------------|
| Jenkins Pipeline DSL | `pipeline`, `stages`, `post`, `script`, `dir`, `credentials`, `tool`, `withSonarQubeEnv`, `withCredentials`, `when` | All |
| Git | `git clone`, `git checkout`, `git reset`, `git pull` | Prepare WORKSPACE |
| File System | `find`, `rm -rf`, `mkdir -p` | Delete Merged Branch, Linting |
| Node.js | `node -v`, `npm -v`, `npm config ls` | Install Dependencies |
| SonarQube | `sonar-scanner` | Static Analysis |
| Docker | `docker info`, `docker build`, `docker push`, `docker rmi` | Check Condition, Server/Client Deploy |
| Azure | `az login`, `az acr login`, `az acr repository show-tags`, `az containerapp update` | Check Condition, Server/Client Deploy |

### Domain Mapping by Stage

| Stage | Git | Bitbucket | Node.js | SonarQube | Docker | Azure | Parsing | File System | Utility |
|-------|:---:|:---------:|:-------:|:---------:|:------:|:-----:|:-------:|:-----------:|:-------:|
| Delete Merged Branch | | | | | | | ✓ | ✓ | |
| Prepare WORKSPACE | ✓ | ✓ | | | | | | ✓ | |
| Install Dependencies | | | ✓ | | | | | | |
| Linting | | | ✓ | | | | | ✓ | |
| Unit Testing | | | ✓ | | | | | | |
| Static Analysis | | | | ✓ | | | | | |
| Check Build Condition | | | | | ✓ | ✓ | | | |
| Server Build & Deploy | | | ✓ | | ✓ | ✓ | | | ✓ |
| Client Build & Deploy | | | ✓ | | ✓ | ✓ | | | ✓ |
| Post | ✓ | ✓ | | | | | | | |

---

## Overall Pipeline Overview
```mermaid
flowchart LR
    subgraph Stages
        S1[Delete Merged Branch]
        S2[Prepare WORKSPACE]
        S3[Install Dependencies]
        S4[Linting]
        S5[Unit Testing]
        S6[Static Analysis]
        S7[Check Build Condition]
        S8[Server Build & Deploy]
        S9[Client Build & Deploy]
    end

    S1 --> S2 --> S3 --> S4 --> S5 --> S6 --> S7 --> S8 --> S9

    S9 --> Post[Post<br/>always/success/failure/aborted/unstable]
```

---

## Stage 1: Delete Merged Branch
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant GH as generalHelper
    participant JSH as jsHelper
    participant FS as File System

    Note over JF: Stage: Delete Merged Branch

    JF->>JF: mainBranches.contains(DESTINATION_BRANCH)
    Note over JF: Abort if not merging to main

    JF->>GH: load("generalHelper.groovy")
    JF->>JSH: load("jsHelper.groovy")

    JF->>GH: parseJson()
    Note over GH: Domain: Parsing
    GH-->>JF: buildResults, stageResults

    JF->>FS: find ../ -type d -name "{PR_BRANCH}"
    Note over JF: Jenkinsfile Direct: File System
    FS-->>JF: branch_path

    alt branch_path exists
        JF->>FS: rm -rf {branch_path}
        JF->>FS: rm -rf {branch_path}@tmp
    end

    JF->>JF: FOLDER_NAME = JOB_NAME.split('/').first()
```

---

## Stage 2: Prepare WORKSPACE
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

    JF->>GH: getFullCommitHash(workspace, PR_COMMIT)
    Note over GH: Domain: Bitbucket
    GH->>Python: get_bitbucket_commit_hash.py
    Python->>BB: GET /commits
    BB-->>Python: commit hash
    Python-->>GH: full commit hash
    GH-->>JF: COMMIT_HASH

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

    JF->>JSH: findTestingDirs(PROJECT_DIR)
    Note over JSH: Domain: File System
    JSH-->>JF: TEST_DIRECTORIES
```

---

## Stage 3: Install Dependencies
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant JSH as jsHelper
    participant NPM as npm CLI

    Note over JF: Stage: Install Dependencies

    JF->>NPM: node -v
    Note over JF: Jenkinsfile Direct: Node.js
    JF->>NPM: npm -v
    JF->>NPM: npm config ls

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

## Stage 4: Linting
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant FS as File System
    participant JSH as jsHelper
    participant NPM as npm CLI

    Note over JF: Stage: Linting

    JF->>FS: mkdir -p linting_results
    Note over JF: Jenkinsfile Direct: File System

    JF->>JSH: executeLintingInTestingDirs(TEST_DIRECTORIES, false)
    Note over JSH: Domain: Node.js/npm
    loop for each testDir
        JSH->>NPM: npm run lint
        NPM-->>JSH: exitCode
    end
    JSH-->>JF: OK/FAIL
```

---

## Stage 5: Unit Testing
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant JSH as jsHelper
    participant NPM as npm CLI

    Note over JF: Stage: Unit Testing

    JF->>JSH: runUnitTestsInTestingDirs(TEST_DIRECTORIES, false)
    Note over JSH: Domain: Node.js/npm
    loop for each testDir
        JSH->>NPM: npm test
        NPM-->>JSH: exitCode
    end
    JSH-->>JF: OK/FAIL
```

> **Note**: In JS CD, Coverage Report is **not** sent to Bitbucket (differs from CI)

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

## Stage 7: Check Build and Deploy Condition
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant Docker as Docker CLI
    participant AZ as Azure CLI

    Note over JF: Stage: Check Build and Deploy Condition
    Note over JF: Jenkinsfile Direct: Docker + Azure

    JF->>Docker: sudo docker info
    Docker-->>JF: OK/FAIL
    Note over JF: Error if Docker not running

    JF->>AZ: sudo az login --identity
    AZ-->>JF: OK

    JF->>AZ: sudo az acr login --name webbuilds
    AZ-->>JF: OK/FAIL
    Note over JF: Error if ACR login failed
```

---

## Stage 8: Server Build and Deploy
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant JSH as jsHelper
    participant AZ as Azure CLI
    participant Docker as Docker CLI
    participant ACR as Azure Container Registry

    Note over JF: Stage: Server Build and Deploy
    Note over JF: when: params.SERVER_SOURCE_FOLDER exists

    JF->>AZ: sudo az acr repository show-tags --name webbuilds --repository {SERVER_CONTAINER_NAME}
    Note over JF: Jenkinsfile Direct: Azure
    AZ-->>JF: server_latest_version

    JF->>JSH: getPackageJsonVersion()
    Note over JSH: Domain: Node.js/npm
    JSH-->>JF: project_server_version

    JF->>JSH: versionCompare(server_latest_version, project_server_version)
    Note over JSH: Domain: Utility
    JSH-->>JF: true/false

    alt version is newer
        JF->>Docker: sudo docker build -t {ACR}/{SERVER_CONTAINER_NAME}:{version}
        Note over JF: Jenkinsfile Direct: Docker
        Docker-->>JF: image built

        JF->>Docker: sudo docker push {ACR}/{SERVER_CONTAINER_NAME}:{version}
        Docker->>ACR: push image
        ACR-->>Docker: OK

        JF->>AZ: sudo az containerapp update --name {SERVER_CONTAINER_NAME} --image {version}
        Note over JF: Jenkinsfile Direct: Azure
        AZ-->>JF: OK

        JF->>Docker: sudo docker rmi {image}
        Docker-->>JF: image removed
    else version not newer
        Note over JF: UNSTABLE - Skip deployment
    end
```

---

## Stage 9: Client Build and Deploy
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant JSH as jsHelper
    participant AZ as Azure CLI
    participant Docker as Docker CLI
    participant ACR as Azure Container Registry

    Note over JF: Stage: Client Build and Deploy
    Note over JF: when: params.CLIENT_SOURCE_FOLDER exists

    JF->>AZ: sudo az acr repository show-tags --name webbuilds --repository {CLIENT_CONTAINER_NAME}
    Note over JF: Jenkinsfile Direct: Azure
    AZ-->>JF: client_latest_version

    JF->>JSH: getPackageJsonVersion()
    Note over JSH: Domain: Node.js/npm
    JSH-->>JF: project_client_version

    JF->>JSH: versionCompare(client_latest_version, project_client_version)
    Note over JSH: Domain: Utility
    JSH-->>JF: true/false

    alt version is newer
        JF->>Docker: sudo docker build -t {ACR}/{CLIENT_CONTAINER_NAME}:{version}
        Note over JF: Jenkinsfile Direct: Docker
        Docker-->>JF: image built

        JF->>Docker: sudo docker push {ACR}/{CLIENT_CONTAINER_NAME}:{version}
        Docker->>ACR: push image
        ACR-->>Docker: OK

        JF->>AZ: sudo az containerapp update --name {CLIENT_CONTAINER_NAME} --image {version}
        Note over JF: Jenkinsfile Direct: Azure
        AZ-->>JF: OK

        JF->>Docker: sudo docker rmi {image}
        Docker-->>JF: image removed
    else version not newer
        Note over JF: UNSTABLE - Skip deployment
    end
```

---

## Post: always/success/failure/aborted/unstable
```mermaid
sequenceDiagram
    autonumber

    participant JF as Jenkinsfile<br/>(Orchestrator)
    participant GH as generalHelper
    participant Git as Git CLI
    participant Python as Python Scripts
    participant BB as Bitbucket API

    Note over JF: Post: always/success/failure/aborted/unstable

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

    Note over JF,GH: success/failure/aborted/unstable
    alt success
        JF->>GH: sendBuildStatus(workspace, 'SUCCESSFUL', commitHash, true)
    else failure
        JF->>GH: sendBuildStatus(workspace, 'FAILED', commitHash, true)
    else aborted
        JF->>GH: sendBuildStatus(workspace, 'STOPPED', commitHash, true)
    else unstable
        JF->>GH: sendBuildStatus(workspace, 'SUCCESSFUL', commitHash, true)
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
| Jenkinsfile → jsHelper → External | `installNpmInTestingDirs` → npm CLI | 4 |
| Jenkinsfile → jsHelper (Utility) | `versionCompare` | 2 |
| Jenkinsfile → Git direct | `git clone`, `git checkout`, `git pull` | 4 |
| Jenkinsfile → Docker direct | `docker build`, `docker push`, `docker rmi` | 8 |
| Jenkinsfile → Azure direct | `az login`, `az acr`, `az containerapp` | 8 |
| Jenkinsfile → SonarQube direct | `sonar-scanner` | 1 |
| Jenkinsfile → File System direct | `find`, `rm -rf`, `mkdir` | 4 |

### JS CI vs JS CD Comparison

| Item | JS CI | JS CD |
|------|-------|-------|
| Trigger | `OPEN` (PR created) | `MERGED` (PR merged) |
| `CI_PIPELINE` | `true` | `false` |
| `initializeEnvironment` | ✓ | ✗ (직접 호출) |
| Coverage Report Send | Yes | No |
| Web Server Deploy | Yes (lcov-report) | No |
| Docker Build | No | Yes |
| Azure Deploy | No | Yes (Container App) |
| Delete Merged Branch | No | Yes |

### Inconsistencies

| Issue | Description |
|-------|-------------|
| No `initializeEnvironment` | CD calls `sendBuildStatus` directly instead of using mixed function |
| Mixed Git delegation | Post uses `checkoutBranch`, but Prepare WORKSPACE uses direct Git commands |
| Heavy Jenkinsfile direct calls | Docker (8), Azure (8), File System (4) - no Helper abstraction |
| No Web Server Helper usage | Unlike DLX CD, no deployment to web server via generalHelper |

---

[← JS CI](js-ci.md) | [Domain Mapping Summary →](domain-mapping.md)