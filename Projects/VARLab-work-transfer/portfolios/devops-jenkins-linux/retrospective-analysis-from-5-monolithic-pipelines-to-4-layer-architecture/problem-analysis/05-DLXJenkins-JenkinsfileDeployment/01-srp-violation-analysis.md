[← Overview](../detailed-analysis.md) | [Software Smells →](02-software-smells-analysis.md)

# DLXJenkins/JenkinsfileDeployment - SRP Violation Analysis

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
| Delete Merged Branch | mainBranches check + folder name extraction | 2 |
| Prepare WORKSPACE | Git commands (4x) + stageName/errorMsg | 5 |
| Linting | File System (`mkdir`, `cp`) + Bash script + exitCode branch | 4 |
| EditMode Tests | File System (`mkdir`) + stageName/errorMsg | 2 |
| PlayMode Tests | stageName/errorMsg | 1 |
| Build Project | File System (`mkdir`, `mv`) + stageName/errorMsg | 3 |
| Deploy Build | SSH/SCP commands (6x: LTI 3 + eConestoga 3) | 6 |

---

## 3. Inline Code Details by Stage

<details markdown>
<summary><code>Delete Merged Branch</code> stage (2 inline codes)</summary>
```groovy
script {
    if (!mainBranches.contains(DESTINATION_BRANCH)) {  // Inline 1: mainBranches check
        env.FAILURE_REASON = 'Not merging to the main branch. Exiting the pipeline...'
        currentBuild.result = buildResults.ABORTED
        error(env.FAILURE_REASON)
    }

    env.FOLDER_NAME = "${JOB_NAME}".split('/').first()  // Inline 2: folder name extraction
}
```

</details>

<details markdown>
<summary><code>Prepare WORKSPACE</code> stage (5 inline codes)</summary>
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

dir("${PROJECT_DIR}") {
    script {
        String stageName = 'Rider'  // Inline 5: stageName/errorMsg hardcoded
        String errorMassage = 'Synchronizing Unity and Rider IDE solution files failed'
        unityUtil.runUnityStage(stageName, errorMassage)
    }
}
```

</details>

<details markdown>
<summary><code>Linting</code> stage (4 inline codes)</summary>
```groovy
dir("${REPORT_DIR}") {
    sh 'mkdir -p linting_results'  // Inline 1: File System
}

script {
    sh "cp -f '${env.WORKSPACE}/Bash/.editorconfig' '${PROJECT_DIR}' 2>/dev/null"  // Inline 2: File System

    def exitCode = sh script: """sh '${env.WORKSPACE}/Bash/Linting.bash' \\
        '${PROJECT_DIR}' '${REPORT_DIR}/linting_results'""", returnStatus: true  // Inline 3: Bash script

    if (exitCode != 0) {  // Inline 4: exitCode branch
        catchError(buildResult: buildResults.SUCCESS, stageResult: stageResults.FAILURE) {
            error("Linting failed with exit code: ${exitCode}")
        }
    }
}
```

</details>

<details markdown>
<summary><code>EditMode Tests</code> stage (2 inline codes)</summary>
```groovy
dir("${REPORT_DIR}") {
    sh 'mkdir -p test_results'  // Inline 1: File System
}

script {
    String stageName = 'EditMode'  // Inline 2: stageName/errorMsg hardcoded
    String errorMassage = 'EditMode tests failed'
    unityUtil.runUnityStage(stageName, errorMassage)
}
```

</details>

<details markdown>
<summary><code>PlayMode Tests</code> stage (1 inline code)</summary>
```groovy
script {
    String stageName = 'PlayMode'  // Inline: stageName/errorMsg hardcoded
    String errorMassage = 'PlayMode tests failed'
    unityUtil.runUnityStage(stageName, errorMassage)
}
```

</details>

<details markdown>
<summary><code>Build Project</code> stage (3 inline codes)</summary>
```groovy
sh "mkdir -p \"${PROJECT_DIR}/Assets/Editor/\""  // Inline 1: File System
sh "mv Builder.cs \"${PROJECT_DIR}/Assets/Editor/\""  // Inline 2: File System

script {
    String stageName = 'Webgl'  // Inline 3: stageName/errorMsg hardcoded
    String errorMassage = 'WebGL Build failed'
    unityUtil.runUnityStage(stageName, errorMassage)
}
```

</details>

<details markdown>
<summary><code>Deploy Build</code> stage (6 inline codes) - Most Severe</summary>
```groovy
// LTI Server (3 inline codes)
script {
    sh "ssh -i ${env.SSH_KEY} ${env.DLX_WEB_HOST_URL} \"sudo mkdir -p /var/www/html/${FOLDER_NAME} \
    && sudo chown vconadmin:vconadmin /var/www/html/${FOLDER_NAME}\""  // Inline 1: SSH mkdir/chown

    sh "scp -i ${env.SSH_KEY} -rp ${PROJECT_DIR}/Builds/* \"${env.DLX_WEB_HOST_URL}:/var/www/html/${FOLDER_NAME}\""  // Inline 2: SCP copy

    sh "ssh -i ${env.SSH_KEY} ${env.DLX_WEB_HOST_URL} 'bash ~/ShellScripts/UpdateBuildURL.sh /var/www/html/${FOLDER_NAME}'"  // Inline 3: SSH script
}

// eConestoga Server (3 inline codes - duplicated pattern)
script {
    if (DLX_PROJECT_LIST.contains(PR_REPO_NAME)) {
        sh script: """
            ssh -i ${env.SSH_KEY} ${env.DLX_ECONESTOGA_URL} \\
            "sudo mkdir -p /var/www/html/${FOLDER_NAME} && sudo chown vconadmin:vconadmin /var/www/html/${FOLDER_NAME}"
        """  // Inline 4: SSH mkdir/chown (duplicate)

        sh script: """
            scp -i ${env.SSH_KEY} -rp ${PROJECT_DIR}/Builds/* \\
            ${env.DLX_ECONESTOGA_URL}:/var/www/html/${FOLDER_NAME}
        """  // Inline 5: SCP copy (duplicate)

        sh script: """
            ssh -i ${env.SSH_KEY} ${env.DLX_ECONESTOGA_URL} \\
            'bash ~/ShellScripts/UpdateBuildURL.sh /var/www/html/${FOLDER_NAME}'
        """  // Inline 6: SSH script (duplicate)
    }
}
```

</details>

---

## 4. Inline Code Summary

| Type | Count | Stages |
|------|:-----:|--------|
| stageName/errorMsg hardcoded | 4 | Prepare, EditMode, PlayMode, Build |
| Git commands (`clone`, `checkout`, `reset`, `pull`) | 4 | Prepare WORKSPACE |
| File System (`mkdir`, `cp`, `mv`) | 5 | Linting, EditMode, Build |
| Bash script direct call | 1 | Linting |
| SSH/SCP commands | 6 | Deploy Build (LTI 3 + eConestoga 3) |
| Branch logic | 2 | Delete Merged Branch, Linting |

---

## Conclusion

> **SRP Violation**:
> - **Total 23 inline codes** across 7 stages (DLX CI: 16)
> - **Deploy Build Stage**: Most severe (6 inline codes, LTI/eConestoga same pattern duplicated)
> - **Prepare WORKSPACE Stage**: Git commands directly in Jenkinsfile (unlike DLX CI which delegates to Helper)
> - **Common pattern with DLX CI**: stageName/errorMsg hardcoded (4x), File System operations inline
> - **Recommendation**: Extract Git commands, SSH/SCP commands to Helper functions

---

[← Overview](../detailed-analysis.md) | [Software Smells →](02-software-smells-analysis.md)