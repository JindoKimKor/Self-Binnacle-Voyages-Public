[← Overview](../detailed-analysis.md) | [Software Smells →](02-software-smells-analysis.md)

# DLXJenkins/Jenkinsfile - SRP Violation Analysis

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
| Prepare WORKSPACE | stageName/errorMsg hardcoded | 1 |
| Linting | File System (`mkdir`, `cp`) + Bash script + exitCode branch + Python script | 5 |
| EditMode Tests | File System (`mkdir` 2x) + stageName/errorMsg | 3 |
| PlayMode Tests | stageName/errorMsg | 1 |
| Code Coverage | stageName/errorMsg | 1 |
| Build Project | File System (`mkdir`, `cp`) + stageName/errorMsg + DEBUG_MODE + Python script | 5 |

---

## 3. Inline Code Details by Stage

<details markdown>
<summary><code>Prepare WORKSPACE</code> stage (1 inline code)</summary>

```groovy
script {
    String stageName = 'Rider'  // Inline: stageName hardcoded
    String errorMassage = 'Synchronizing Unity and Rider IDE solution files failed'
    unityUtil.runUnityStage(stageName, errorMassage)
}
```

</details>

<details markdown>
<summary><code>Linting</code> stage (5 inline codes) - Most Severe</summary>

```groovy
dir("${REPORT_DIR}") {
    sh 'mkdir -p linting_results'  // Inline 1: File System
}

script {
    sh "cp -f '${env.WORKSPACE}/Bash/.editorconfig' '${PROJECT_DIR}' 2>/dev/null"  // Inline 2: File System

    def exitCode = sh script: """ sh '${env.WORKSPACE}/Bash/Linting.bash' \\
        '${PROJECT_DIR}' '${REPORT_DIR}/linting_results'""", returnStatus: true  // Inline 3: Bash script call

    if (exitCode != 0) {  // Inline 4: exitCode branch logic
        if (exitCode == 2) {
            sh script: """python '${env.WORKSPACE}/python/linting_error_report.py' \\
                '${REPORT_DIR}/linting_results/format-report.json' \\
                ${COMMIT_HASH} ${fail} '${PROJECT_DIR}'"""  // Inline 5: Python script call
        }
        // ...
    }
}
```

</details>

<details markdown>
<summary><code>EditMode Tests</code> stage (3 inline codes)</summary>

```groovy
dir("${REPORT_DIR}") {
    sh 'mkdir -p test_results'      // Inline 1: File System
    sh 'mkdir -p coverage_results'  // Inline 2: File System
}

script {
    String stageName = 'EditMode'  // Inline 3: stageName hardcoded
    String errorMassage = 'EditMode tests failed'
    unityUtil.runUnityStage(stageName, errorMassage)
}
```

</details>

<details markdown>
<summary><code>PlayMode Tests</code> stage (1 inline code)</summary>

```groovy
script {
    String stageName = 'PlayMode'  // Inline: stageName hardcoded
    String errorMassage = 'PlayMode tests failed'
    unityUtil.runUnityStage(stageName, errorMassage)
}
```

</details>

<details markdown>
<summary><code>Code Coverage</code> stage (1 inline code)</summary>

```groovy
script {
    String stageName = 'Coverage'  // Inline: stageName hardcoded
    String errorMassage = 'Code Coverage generation failed'
    unityUtil.runUnityStage(stageName, errorMassage)
}
```

</details>

<details markdown>
<summary><code>Build Project</code> stage (5 inline codes)</summary>

```groovy
script {
    sh "mkdir -p \"${PROJECT_DIR}/Assets/Editor/\""  // Inline 1: File System
    sh "cp Builder.cs \"${PROJECT_DIR}/Assets/Editor/\""  // Inline 2: File System

    String stageName = 'Webgl'  // Inline 3: stageName hardcoded
    String errorMassage = 'WebGL Build failed'
    unityUtil.runUnityStage(stageName, errorMassage)

    if ((params.DEBUG_MODE ?: '').toUpperCase() == 'Y') {  // Inline 4: DEBUG_MODE branch
        pythonArgs += ' --debug'
    }

    sh " python ${env.WORKSPACE}/python/create_bitbucket_webgl_build_report.py ${pythonArgs}"  // Inline 5: Python script call
}
```

</details>

---

## 4. Inline Code Summary

| Type | Count | Stages |
|------|:-----:|--------|
| stageName/errorMsg hardcoded | 5 | Prepare WORKSPACE, EditMode, PlayMode, Coverage, Build |
| File System (`mkdir`, `cp`) | 6 | Linting, EditMode, Build |
| Bash/Python script direct call | 3 | Linting (2), Build (1) |
| Branch logic (exitCode, DEBUG_MODE) | 2 | Linting, Build |

---

## Conclusion

> **SRP Violation**:
> - **Total 16 inline codes** across 6 stages
> - **Linting Stage**: Most severe (5 inline codes including exitCode branch logic)
> - **Build Project Stage**: Second most severe (5 inline codes)
> - **Common pattern**: stageName/errorMsg hardcoded in 5 stages (should be constant or config)
> - **Recommendation**: Extract File System operations, Bash/Python script calls, and branch logic to Helper functions

---

[← Overview](../detailed-analysis.md) | [Software Smells →](02-software-smells-analysis.md)