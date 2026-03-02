[← Overview](../detailed-analysis.md) | [Software Smells →](02-software-smells-analysis.md)

# JsJenkins/JenkinsfileDeployment - SRP Violation Analysis

> **Pipeline Role**: Orchestration only (sequence/flow control)
>
> **SRP Violation**: If inline code exists in Jenkinsfile, it violates orchestration-only principle

---

## 1. SRP Violation Analysis Criteria

- **Jenkinsfile Role**: Orchestration (pipeline sequence/flow control)
- **SRP Violation Condition**: If actual logic exists in Jenkinsfile (not Helper calls)
- **Analysis Method**: Stage-by-Stage inline code detection

---

## 2. Inline Code Analysis by Stage

| Stage | Inline Code Type | Count |
|-------|------------------|:-----:|
| Delete Merged Branch | mainBranches check + `find`/`rm` commands + folder name extraction | 4 |
| Prepare WORKSPACE | Git commands (4x) | 4 |
| Install Dependencies | Node/npm version checks (3x) + `cd` | 4 |
| Linting | File System (`mkdir`) | 1 |
| Unit Testing | `cd` command | 1 |
| Static Analysis | SonarQube scanner config + Quality Gate logic | 2 |
| Check Build and Deploy Condition | Docker info + az login (2x) | 3 |
| Server Build and Deploy | az acr + docker build/push + az containerapp + docker rmi | 5 |
| Client Build and Deploy | Same pattern (duplicated) | 5 |

---

## 3. Inline Code Details by Stage

<details markdown>
<summary><code>Delete Merged Branch</code> stage (4 inline codes)</summary>

```groovy
script {
    if (!mainBranches.contains(DESTINATION_BRANCH)) {  // Inline 1: mainBranches check
        env.FAILURE_REASON = 'Not merging to the main branch. Exiting the pipeline...'
        currentBuild.result = 'ABORTED'
        error(env.FAILURE_REASON)
    }

    def branch_path = sh(script: "/usr/bin/find ../ -type d -name \"${PR_BRANCH}\"", returnStdout: true)  // Inline 2: find command
    branch_path = branch_path.trim()
    if (!branch_path.isEmpty()) {
        sh "rm -r -f \"${branch_path}\""  // Inline 3: rm command
        sh "rm -r -f \"${branch_path}@tmp\""
    }

    env.FOLDER_NAME = "${JOB_NAME}".split('/').first()  // Inline 4: folder name extraction
}
```

</details>

<details markdown>
<summary><code>Prepare WORKSPACE</code> stage (4 inline codes)</summary>

```groovy
script {
    if (!fileExists("${PROJECT_DIR}")) {
        sh "git clone ${REPO_SSH} \"${PROJECT_DIR}\""  // Inline 1: Git clone
    }
}

dir("${PROJECT_DIR}") {
    sh "git checkout ${DESTINATION_BRANCH}"  // Inline 2: Git checkout
    sh 'git reset --hard HEAD'  // Inline 3: Git reset
    sh 'git pull'  // Inline 4: Git pull
}
```

</details>

<details markdown>
<summary><code>Install Dependencies</code> stage (4 inline codes)</summary>

```groovy
script {
    sh 'node -v'  // Inline 1: Node version check
    sh 'npm -v'  // Inline 2: npm version check
    sh 'npm config ls'  // Inline 3: npm config check

    jsUtil.installNpmInTestingDirs(env.TEST_DIRECTORIES)

    sh(script: 'cd "' + env.WORKSPACE + '"')  // Inline 4: cd command
}
```

</details>

<details markdown>
<summary><code>Static Analysis</code> stage (2 inline codes)</summary>

```groovy
// SonarQube scanner config (Inline 1)
script {
    String scannerHome = tool SONARQUBE_SCANNER
    withSonarQubeEnv(SONARQUBE_SERVER) {
        String sonarCommand = "\"${scannerHome}/bin/sonar-scanner\" " +
                            "\"-Dsonar.projectKey=${env.SONAR_PROJECT_KEY}\" " +
                            '\"-Dsonar.host.url=http://localhost:9000/sonarqube\" ' +
                            '\"-Dsonar.sources=.\" ' +
                            '\"-Dsonar.python.version=3.10\"'
        sh sonarCommand
    }
}

// Quality Gate check logic (Inline 2)
script {
    Map status = generalUtil.checkQualityGateStatus(SONAR_PROJECT_KEY, env.SONAR_QUBE_AUTH_TOKEN)
    if ((status.entireCodeStatus != 'OK') || (status.newCodeStatus != 'OK')) {
        error('Quality gate failed!')
    }
}
```

</details>

<details markdown>
<summary><code>Check Build and Deploy Condition</code> stage (3 inline codes)</summary>

```groovy
script {
    int isDockerRunning = sh(script: 'sudo docker info > /dev/null 2>&1', returnStatus: true)  // Inline 1: Docker info
    if (isDockerRunning != 0) {
        error('Docker is not available. Please start Docker and try again.')
    }
}

script {
    sh 'sudo az login --identity --username 0ca5eb7b-0dfc-4449-8c1e-c9dae95c7a97'  // Inline 2: az login

    try {
        sh 'sudo az acr login --name webbuilds'  // Inline 3: az acr login
    } catch (Exception e) {
        error('Pipeline terminated: Azure Container Registry login failed.')
    }
}
```

</details>

<details markdown>
<summary><code>Server Build and Deploy</code> stage (5 inline codes) - Most Severe</summary>

```groovy
script {
    def server_latest_version = sh(
        script: """
            sudo az acr repository show-tags --name webbuilds \\
            --repository ${params.SERVER_CONTAINER_NAME} \\
            --output tsv | grep -v "latest" | sort -V | tail -n 1
        """,
        returnStdout: true
    ).trim()  // Inline 1: az acr show-tags

    // Docker build
    sh """
        sudo docker build -t \\
        ${env.AZ_CONTAINER_REGISTRY_NAME}/${params.SERVER_CONTAINER_NAME}:${project_server_version} \\
        ${projectDir}/${params.SERVER_SOURCE_FOLDER}/.
    """  // Inline 2: docker build

    // Docker push
    sh """
        sudo docker push \\
        ${env.AZ_CONTAINER_REGISTRY_NAME}/${params.SERVER_CONTAINER_NAME}:${project_server_version}
    """  // Inline 3: docker push

    // Azure Container Apps update
    sh """
        sudo az containerapp update \\
        --name ${params.SERVER_CONTAINER_NAME} \\
        --resource-group ${params.AZ_RESOURCE_GROUP} \\
        --image ${env.AZ_CONTAINER_REGISTRY_NAME}/${params.SERVER_CONTAINER_NAME}:${project_server_version}
    """  // Inline 4: az containerapp update

    // Docker image cleanup
    sh "sudo docker rmi ${env.AZ_CONTAINER_REGISTRY_NAME}/${params.SERVER_CONTAINER_NAME}:${project_server_version}"  // Inline 5: docker rmi
}
```

</details>

<details markdown>
<summary><code>Client Build and Deploy</code> stage (5 inline codes) - Duplicated Pattern</summary>

```groovy
// Same 5-step pattern as Server Build and Deploy:
// 1. az acr repository show-tags
// 2. docker build
// 3. docker push
// 4. az containerapp update
// 5. docker rmi

// Only variable names differ: SERVER_CONTAINER_NAME → CLIENT_CONTAINER_NAME
```

</details>

---

## 4. Inline Code Summary

| Type | Count | Stages |
|------|:-----:|--------|
| Git commands (`clone`, `checkout`, `reset`, `pull`) | 4 | Prepare WORKSPACE |
| File System (`find`, `rm`, `mkdir`, `cd`) | 6 | Delete Merged Branch, Linting, Install, Unit Testing |
| Node/npm version checks | 3 | Install Dependencies |
| Docker commands (`info`, `build`, `push`, `rmi`) | 7 | Check Condition, Server Deploy, Client Deploy |
| Azure commands (`az login`, `az acr`, `az containerapp`) | 6 | Check Condition, Server Deploy, Client Deploy |
| SonarQube config + Quality Gate | 2 | Static Analysis |
| Branch logic | 1 | Delete Merged Branch |

---

## Conclusion

> **SRP Violation**:
> - **Total 29 inline codes** across 9 stages (DLX CI: 16, DLX CD: 23, JS CI: 9)
> - **Server/Client Build and Deploy**: Most severe (5 inline codes each, same pattern duplicated = 75+ lines)
> - **Prepare WORKSPACE**: Git commands directly in Jenkinsfile
> - **Key difference from JS CI**: Docker/Azure commands inline, Server/Client deploy code duplicated
> - **Recommendation**: Extract Docker/Azure commands to Helper functions, abstract Server/Client pattern

---

[← Overview](../detailed-analysis.md) | [Software Smells →](02-software-smells-analysis.md)