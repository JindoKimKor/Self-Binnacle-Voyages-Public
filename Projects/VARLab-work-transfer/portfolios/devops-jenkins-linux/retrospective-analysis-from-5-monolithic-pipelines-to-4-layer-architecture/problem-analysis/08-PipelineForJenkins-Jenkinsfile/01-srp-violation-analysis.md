[← Overview](../detailed-analysis.md) | [Software Smells →](02-software-smells-analysis.md)

# PipelineForJenkins/Jenkinsfile - SRP Violation Analysis

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
| Prepare Workspace | try-catch error handling | 1 |
| Lint Groovy Code | docker info + Groovy lint + Python script + Jenkinsfile lint + Python script (2x) | 6 |
| Generate Groovydoc | `find` command + `mkdir` + `groovydoc` | 3 |
| Run Unit Tests | `gradle test` | 1 |
| Publish Test Results | `junit` | 1 |
| Static Analysis | SonarQube scanner config + Quality Gate logic | 2 |

---

## 3. Inline Code Details by Stage

<details markdown>
<summary><code>Prepare Workspace</code> stage (1 inline code)</summary>

```groovy
script {
    dir("${PROJECT_DIR}") {
        try {
            // Helper calls...
        } catch (Exception e) {  // Inline: try-catch error handling
            echo "Error in Prepare Workspace stage: ${e.getMessage()}"
            currentBuild.result = buildResults.FAILURE
            error("Workspace preparation failed: ${e.getMessage()}")
        }
    }
}
```

</details>

<details markdown>
<summary><code>Lint Groovy Code</code> stage (6 inline codes) - Most Severe</summary>

```groovy
script {
    sh 'docker info'  // Inline 1: Docker info

    def imageStr = 'nvuillam/npm-groovy-lint'
    def entrypointStr = '--entrypoint=""'

    // Groovy lint (Inline 2)
    def exitCodeGroovy = docker.image(imageStr).inside(entrypointStr) {
        return sh(
            returnStatus: true,
            script: """
                npm-groovy-lint \\
                    --failon error \\
                    --output groovy-lint-report.json \\
                    --config ${PROJECT_DIR}/.groovylintrc.groovy.json \\
                    ${PROJECT_DIR}/groovy
            """
        )
    }

    if (exitCodeGroovy != 0) {
        // Inline 3: Python script call
        sh script: """\
            python '${env.WORKSPACE}/python/Lint_groovy_report.py' ...
        """.stripIndent()
    }

    // Jenkinsfile lint (Inline 4) - Same pattern as Groovy
    def exitCodeJenkins = docker.image(imageStr).inside(entrypointStr) {
        return sh(
            returnStatus: true,
            script: """
                npm-groovy-lint \\
                    --failon error \\
                    --output jenkins-lint-report.json \\
                    --config ${PROJECT_DIR}/.groovylintrc.jenkins.json \\
                    ${PROJECT_DIR}/DLXJenkins \\
                    ${PROJECT_DIR}/JsJenkins \\
                    ${PROJECT_DIR}/PipelineForJenkins
            """
        )
    }

    if (exitCodeJenkins != 0 || exitCodeGroovy != 0) {
        // Inline 5: Python script call (Fail)
        sh script: """...""".stripIndent()
    } else {
        // Inline 6: Python script call (Pass)
        sh script: """...""".stripIndent()
    }
}
```

</details>

<details markdown>
<summary><code>Generate Groovydoc</code> stage (3 inline codes)</summary>

```groovy
script {
    dir(PROJECT_DIR) {
        def fileList = sh(
            script: "find ${PROJECT_DIR}/groovy -type f -name '*.groovy'",  // Inline 1: find command
            returnStdout: true).trim()

        sh """
        mkdir -p ${REPORT_DIR}  // Inline 2: mkdir
        groovydoc -verbose -d ${REPORT_DIR} ${fileList.replaceAll('\\s+', ' ')}  // Inline 3: groovydoc
        """
    }
}
```

</details>

<details markdown>
<summary><code>Run Unit Tests</code> stage (1 inline code)</summary>

```groovy
script {
    sh 'gradle test'  // Inline: gradle test
}
```

</details>

<details markdown>
<summary><code>Publish Test Results</code> stage (1 inline code)</summary>

```groovy
script {
    junit 'build/test-results/test/*.xml'  // Inline: junit
}
```

</details>

<details markdown>
<summary><code>Static Analysis</code> stage (2 inline codes)</summary>

```groovy
// SonarQube scanner config (Inline 1)
script {
    catchError(buildResults: buildResults.SUCCESS, stageResults: stageResults.FAILURE) {  // Note: typo in parameter names
        String scannerHome = tool SONARQUBE_SCANNER
        withSonarQubeEnv(SONARQUBE_SERVER) {
            String sonarCommand = "\"${scannerHome}/bin/sonar-scanner\" " +
                "\"-Dsonar.projectKey=${env.SONAR_PROJECT_KEY}\" " +
                '\"-Dsonar.host.url=http://localhost:9000/sonarqube\" ' +
                // ... more options
            sh sonarCommand
        }
    }
}

// Quality Gate check logic (Inline 2)
script {
    catchError(buildResults: buildResults.SUCCESS, stageResults: stageResults.FAILURE) {
        Map status = generalUtil.checkQualityGateStatus(SONAR_PROJECT_KEY, env.SONAR_QUBE_AUTH_TOKEN)
        if ((status.entireCodeStatus != STATUS_OK) || (status.newCodeStatus != STATUS_OK)) {
            error('Quality gate failed!')
        }
    }
}
```

</details>

---

## 4. Inline Code Summary

| Type | Count | Stages |
|------|:-----:|--------|
| Docker container execution | 2 | Lint Groovy Code (Groovy + Jenkinsfile) |
| Python script direct call | 3 | Lint Groovy Code |
| File System (`find`, `mkdir`) | 2 | Generate Groovydoc |
| Gradle command | 1 | Run Unit Tests |
| Groovydoc command | 1 | Generate Groovydoc |
| SonarQube config + Quality Gate | 2 | Static Analysis |
| try-catch error handling | 1 | Prepare Workspace |

---

## Conclusion

> **SRP Violation**:
> - **Total 14 inline codes** across 6 stages
> - **Lint Groovy Code Stage**: Most severe (6 inline codes, Groovy/Jenkinsfile same pattern duplicated)
> - **Static Analysis Stage**: SonarQube scanner config directly in Jenkinsfile
> - **Key difference from other pipelines**: Docker container for linting, Gradle/Groovydoc commands
> - **Bug**: `catchError` parameter typo (`buildResults` → `buildResult`, `stageResults` → `stageResult`)
> - **Recommendation**: Extract lint logic to Helper function, fix catchError typo

---

[← Overview](../detailed-analysis.md) | [Software Smells →](02-software-smells-analysis.md)