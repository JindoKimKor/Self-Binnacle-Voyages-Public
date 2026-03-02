[← Overview](../detailed-analysis.md) | [Software Smells →](02-software-smells-analysis.md)

# JsJenkins/Jenkinsfile - SRP Violation Analysis

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
| Prepare WORKSPACE | (none significant) | 0 |
| Install Dependencies | (none significant) | 0 |
| Linting | File System (`mkdir`) | 1 |
| Unit Testing | Python script (2x) + DEBUG_MODE branch (2x) + server/client branch (2x) | 6 |
| Static Analysis | SonarQube scanner config + Quality Gate logic | 2 |

---

## 3. Inline Code Details by Stage

<details markdown>
<summary><code>Linting</code> stage (1 inline code)</summary>
```groovy
dir("${REPORT_DIR}") {
    sh 'mkdir -p linting_results'  // Inline: File System
}
```

</details>

<details markdown>
<summary><code>Unit Testing</code> stage (6 inline codes) - Most Severe</summary>
```groovy
// Server-side report (3 inline codes)
if (params.SERVER_SOURCE_FOLDER?.trim()) {  // Inline 1: server branching logic
    Map serverTestSummaryDirs = jsUtil.retrieveReportSummaryDirs(...)

    if (!serverTestSummaryDirs.isEmpty()) {
        String cmdArgs = " ${COMMIT_HASH} ${serverTestSummaryDirs['coverageSummaryDir']} ... --server"

        if ((params.DEBUG_MODE ?: '').toUpperCase() == 'Y') {  // Inline 2: DEBUG_MODE branch
            cmdArgs += ' --debug'
        }

        sh " python python/create_bitbucket_coverage_report.py ${cmdArgs}"  // Inline 3: Python script
    }
}

// Client-side report (3 inline codes - duplicated pattern)
if (params.CLIENT_SOURCE_FOLDER?.trim()) {  // Inline 4: client branching logic (duplicate)
    Map clientTestSummaryDirs = jsUtil.retrieveReportSummaryDirs(...)

    if (!clientTestSummaryDirs.isEmpty()) {
        String cmdArgs = " ${COMMIT_HASH} ${clientTestSummaryDirs['coverageSummaryDir']} ... --client"

        if ((params.DEBUG_MODE ?: '').toUpperCase() == 'Y') {  // Inline 5: DEBUG_MODE branch (duplicate)
            cmdArgs += ' --debug'
        }

        sh " python python/create_bitbucket_coverage_report.py ${cmdArgs}"  // Inline 6: Python script (duplicate)
    }
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
                            '\"-Dsonar.sources=.\" '  +
                            '\"-Dsonar.python.version=3.10\"'
        sh sonarCommand
    }
}

// Quality Gate check logic (Inline 2)
script {
    Map status = generalUtil.checkQualityGateStatus(SONAR_PROJECT_KEY, env.SONAR_QUBE_AUTH_TOKEN)

    catchError(buildResult: buildResults.SUCCESS, stageResult: stageResults.FAILURE) {
        final String STATUS_OK = 'OK'

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
| File System (`mkdir`) | 1 | Linting |
| Python script direct call | 2 | Unit Testing (server + client) |
| DEBUG_MODE branch | 2 | Unit Testing (server + client) |
| Server/Client branching logic | 2 | Unit Testing |
| SonarQube scanner config | 1 | Static Analysis |
| Quality Gate logic | 1 | Static Analysis |

---

## Conclusion

> **SRP Violation**:
> - **Total 9 inline codes** across 3 stages (DLX CI: 16, DLX CD: 23)
> - **Unit Testing Stage**: Most severe (6 inline codes, server/client same pattern duplicated)
> - **Static Analysis Stage**: SonarQube scanner config directly in Jenkinsfile
> - **Key difference from DLX**: No stageName/errorMsg hardcoding, but has server/client code duplication
> - **Recommendation**: Extract server/client report logic to Helper function, extract SonarQube config

---

[← Overview](../detailed-analysis.md) | [Software Smells →](02-software-smells-analysis.md)