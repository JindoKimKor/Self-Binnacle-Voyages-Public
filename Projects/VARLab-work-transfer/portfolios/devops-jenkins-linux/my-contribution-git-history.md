# devops-jenkins-linux

## Basic Info
- **Original**: `git@bitbucket.org:VARLab/devops-linux-jenkins.git`
- **New Location**: https://github.com/JindoKimKor/devops-jenkins-linux
- **Total PRs**: 25
- **Total My Commits**: 612

### Merged PRs (23)
| PR | Branch | Date |
|----|--------|------|
| #2 | CORE-1423-Refactor-runUnityTests-Function-for-PlayMode-Testing-with-xvfb-run | 2025-01-09 |
| #5 | CORE-1424-Enabling-JavaScript-Project-PR-pipeline | 2025-01-14 |
| #7 | CORE-1438-Enabling-the-JavaScript-Deployment-Pipline-functional | 2025-01-15 |
| - | CORE-1449-can't-publish-test-result-to-web-server | 2025-01-16 |
| - | CORE-1449-Ensure-Code-Coverage-Setting-to-Generate-report | 2025-01-24 |
| #14 | CORE-1503-remove-testcategory-for-batchmode | 2025-02-05 |
| #18 | CORE-1511-New-Batch-Mode-Command | 2025-02-21 |
| #22 | CORE-1525-Update-the-existing-Build-Result-link-on-the-Bitbucket-PR-page | 2025-02-27 |
| #23 | CORE-1531-Fixed-Unit-Stage-execution-failed | 2025-02-28 |
| #28 | CORE-1545-Fix-WebGL-Lighting-Issue | 2025-03-11 |
| #30 | Hot-fix-TPI-PlayMode-failing | 2025-03-12 |
| #31 | Fix/update-batchmode-error-handling | 2025-03-12 |
| - | Hot-fix-update-pipeline-error-handling-logic | 2025-03-12 |
| #34 | CORE-1543-Integrate-SonarQube-into-PipelineForJenkins | 2025-03-24 |
| - | CORE-1526-Conditional-Retry-Logic-For-Batch-Mode-Failures-In-DLX-Pipeline | 2025-03-27 |
| - | CORE-1547-Asset-Not-Importing-Git-Large-File-Storage_Issue | 2025-03-31 |
| #36 | CORE-1444-LongCommitHash | 2025-04-02 |
| #41 | CORE-1547-Git-Large-File-Storage-Issue-To-Fix-Some-Asset-Not-Importing | 2025-04-03 |
| - | Bug/Correct-Sending-Linting-Result-Status | 2025-04-04 |
| #46 | CORE-1542-MethodSignatures | 2025-04-09 |
| - | CORE-1526-Add-Conditional-Retry-Logic-for-Batch-Mode-Failures-in-DLX-Pipeline | 2025-04-13 |
| - | Implement-Global-Trusted-Shared-Library | 2025-04-24 |
| #59 | Refactor-with-TDD | 2025-05-12 |

### Unmerged Branches (2)
| Branch | Commits | Date |
|--------|---------|------|
| AI_Integration | 8 | 2025-05-12 ~ 2025-05-28 |
| Temporary-Branch | 7 | 2025-05-20 ~ 2025-07-04 |

---

## All My Commits (612 total)

<details>
<summary><strong>PR #2: CORE-1423-Refactor-runUnityTests-Function-for-PlayMode-Testing-with-xvfb-run (8 commits)</strong></summary>

| Date | Commit Message |
|------|----------------|
| 2025-01-08 | refactor runUnityTests |
| 2025-01-08 | refactor runUnityTests again |
| 2025-01-08 | temporately comment out EditMode and Preparework Stage code to have fast test environment for PlayMode Testing |
| 2025-01-08 | uncomment EditMode test stage |
| 2025-01-08 | uncomment Linting and all Prepare stage code |
| 2025-01-08 | uncomment some of prepare workspace part |
| 2025-01-08 | uncomment some part of code |
| 2025-01-09 | Add comments for refactored runUnityTest Function |

</details>

<details>
<summary><strong>PR #5: CORE-1424-Enabling-JavaScript-Project-PR-pipeline (32 commits)</strong></summary>

| Date | Commit Message |
|------|----------------|
| 2025-01-09 | Add echo for debugging |
| 2025-01-09 | Add echo for debugging project directory |
| 2025-01-09 | Add logic for first time running pipeline for JavaScript Project |
| 2025-01-09 | change the way checking the exist of the directory |
| 2025-01-09 | Fix Project Directory path value for linux environment friendly |
| 2025-01-09 | modify checkoutBranch arguments |
| 2025-01-09 | modify project directory checking code |
| 2025-01-09 | modify Project Directory checking code again |
| 2025-01-09 | modify project directory exist checking code |
| 2025-01-09 | remove backslashes |
| 2025-01-09 | reset the test change |
| 2025-01-09 | test |
| 2025-01-10 | Add a echo for isGitRepo Exist debugging |
| 2025-01-10 | Change bat command to sh |
| 2025-01-10 | comment the Build Project stage code out |
| 2025-01-10 | Modified the bat command to sh |
| 2025-01-10 | Refactor executeLintingInTestingDirs Function with explicit data type |
| 2025-01-10 | Refactor the installNpmInTestingDirs function and fix escaped double quote for Linux |
| 2025-01-10 | Refactored runUnitTestsInTestingDirs function in jshelper Groovy file |
| 2025-01-10 | remove unnecessary escaped double quotes for runCommand Function in jsHelper Groovy |
| 2025-01-10 | Removed escaped double quote in runUnitTestsInTesingDirs function in jsHelper groovy file |
| 2025-01-10 | replace bat command with sh for Linux |
| 2025-01-10 | replace bat commands with 'sh's in checkNodeVersion and runCommand Functions in jsHelper Groovy files |
| 2025-01-10 | replace sonarqube token |
| 2025-01-10 | replace two backslashes with one slash in Static Anlysis Stage code in Jenkinsfile |
| 2025-01-10 | The Static Analysis Stage of Jenkinsfile code refactored |
| 2025-01-13 | Add try and catch for rm -rf Project Directory in cloneOrUpdateRepo Function |
| 2025-01-13 | modified Install Dependencies stage code for JavaScript Deployment pipline |
| 2025-01-13 | Modified withSonarQubeEnv function for Linux |
| 2025-01-13 | Update the variable type and stdout condition |
| 2025-01-14 | Fixed env.env.WORKSPACE |

</details>

<details>
<summary><strong>PR #7: CORE-1438-Enabling-the-JavaScript-Deployment-Pipline-functional (7 commits)</strong></summary>

| Date | Commit Message |
|------|----------------|
| 2025-01-14 | Fixed Build Project Code |
| 2025-01-14 | Fixed static analysis code |
| 2025-01-14 | Fixed-not-matched-parameters-variable-names-for-checkoutBranch-function |
| 2025-01-14 | Modified Code for Static Analysis |
| 2025-01-14 | Modified Deploy Build |
| 2025-01-14 | Moved/Modified code for Build Project Stage on Deployment Pipeline |
| 2025-01-14 | Replace the 'bat' command with the 'sh' command for Linux Environment |

</details>

<details>
<summary><strong>CORE-1449-can't-publish-test-result-to-web-server (3 commits)</strong></summary>

| Date | Commit Message |
|------|----------------|
| 2025-01-16 | refactored destinationDir variable with the explicit data type and increased readability |
| 2025-01-16 | refactored the code for creating directories and set permission on the remote server |
| 2025-01-16 | refactored the code for transfering the report directory to the remote server |

</details>

<details>
<summary><strong>CORE-1449-Ensure-Code-Coverage-Setting-to-Generate-report (7 commits)</strong></summary>

| Date | Commit Message |
|------|----------------|
| 2025-01-21 | Added AutoGenerationReport flag for batch mode script for test purpose |
| 2025-01-21 | Deleted AutoGenereationReport flag cuz not working |
| 2025-01-23 | Added generateHtmlReport flag for coverageOptions |
| 2025-01-24 | Added virtual frame buffer arguments for EditMode test |
| 2025-01-24 | Fix coverageOptions arguments |
| 2025-01-24 | fix batchmode command |
| 2025-01-24 | Added /usr/bin/xvfb-run on Send reports stage |

</details>

<details>
<summary><strong>PR #14: CORE-1503-remove-testcategory-for-batchmode (3 commits)</strong></summary>

| Date | Commit Message |
|------|----------------|
| 2025-02-05 | Remove testCategory property for batchmode command |
| 2025-02-05 | restore git pull after testing |
| 2025-02-05 | To test temporary commented-out git pull |

</details>

<details>
<summary><strong>PR #18: CORE-1511-New-Batch-Mode-Command (65 commits)</strong></summary>

| Date | Commit Message |
|------|----------------|
| 2025-02-11 | println and echo differenciate test |
| 2025-02-11 | refactor(pipeline): replace env.UNITY_EXECUTABLE with UNITY_EXECUTABLE |
| 2025-02-12 | Added Initial runUnityBatchMode Funtion |
| 2025-02-12 | revert the way to declare Unity_EXECUTABLE |
| 2025-02-14 | Added try/catch for loading groovys |
| 2025-02-14 | Commented-out stages not related to function test temporary |
| 2025-02-14 | Fixed fetCoverageOptionsKeyAndValue function by adding parentesis |
| 2025-02-15 | Add logfile hosting by using Jenkins Artifact Storage |
| 2025-02-15 | Added double-quotation marks for coverageOptions Value |
| 2025-02-15 | Added FilePath import |
| 2025-02-15 | Added try/catch for runUnityBatchMode Funtion |
| 2025-02-15 | fix(coverage): Replace {ProjectPath}/ with '-' in pathsToExcludeOptionValue for proper coverageOptions formatting |
| 2025-02-15 | fix(stage): Change the first letter of stage to capital |
| 2025-02-15 | fixed argument name |
| 2025-02-15 | Fixed fetAsmdefFileName function to get fileName in Scripts Folder, not recursive |
| 2025-02-15 | Fixed file search logic which Jenkins Pipeline allows |
| 2025-02-15 | Fixed log file link url |
| 2025-02-15 | Fixed missingPropertyException |
| 2025-02-15 | Fixed typo |
| 2025-02-15 | move rawPathsToExclude println outside of if statement for test |
| 2025-02-15 | respective path try |
| 2025-02-15 | runUnityBatchMode Function Test |
| 2025-02-15 | runUnityBatchMode Function Test-01 |
| 2025-02-15 | runUnityBatchMode Function Test-02 |
| 2025-02-15 | runUnityBatchMode Function Test-03 |
| 2025-02-16 | fix artifacts url |
| 2025-02-16 | Fixed artifacts links |
| 2025-02-16 | logfileURL fixed and no nore artifacts using |
| 2025-02-18 | Added batchmode ternary operator |
| 2025-02-18 | Added BatchModeFailException |
| 2025-02-18 | Added Coverage Stage combining finalCommand |
| 2025-02-18 | Added exit sh script |
| 2025-02-18 | Added -quit argument condition statement |
| 2025-02-18 | change sh exit logic |
| 2025-02-18 | Code Coverage Stage Uncommented |
| 2025-02-18 | Fix duplicate error handling in EditMode tests |
| 2025-02-18 | Fix unintended class interpretation by explicitly defining stage name as a string |
| 2025-02-18 | Fix variable name: capitalize first letter |
| 2025-02-18 | Fixed AbortException logic |
| 2025-02-18 | Fixed the code to call setLogFilePathAndUrl function and test link |
| 2025-02-18 | modified batchmode result logic |
| 2025-02-18 | move success editmode log message to right place |
| 2025-02-18 | Refactor log file path and ulr assignment logic |
| 2025-02-18 | Try AbortException, not Customized Exception |
| 2025-02-18 | Uncommented PlayMode Stage |
| 2025-02-18 | Uncommented WebGL and Added WebGL logic for runUnityBatchMode function |
| 2025-02-19 | Added Build Description for deployment pipeline |
| 2025-02-19 | Added description for each function and refactor fetCoverageOptionsKeyAndValue into three functions |
| 2025-02-19 | Added script for groovy function in jenkinsfile |
| 2025-02-19 | Additional Refactor for runUnityBatchMode function |
| 2025-02-19 | Deleted old function for running unity batchmode |
| 2025-02-19 | Fixed a typo |
| 2025-02-19 | fixed argument for runUnityStage function |
| 2025-02-19 | Fixed how to call runUnityStage Function |
| 2025-02-19 | Fixed incorrect variable name |
| 2025-02-19 | Fixed the logic to call runUnityBatchMode |
| 2025-02-19 | Fixed variables regarding to not using Map Data Structure from returning runUnityBatchMode function |
| 2025-02-19 | Implement refactored function for deployment pipeline |
| 2025-02-19 | Merge branch 'main' of bitbucket.org:VARLab/devops-linux-jenkins into CORE-1511-New-Batch-Mode-Command |
| 2025-02-19 | Refactor run Unity BatchMode and error handling and exitCode handling into one function called runUnityStage |
| 2025-02-19 | Refactor setLogFilePathAndUrl Closure |
| 2025-02-19 | Try to refactoring code more |
| 2025-02-19 | Uncommneted Linting and Rider batchmode and modified logic to run Rider Batchmode |
| 2025-02-20 | get generalUtil.publishTestResultsHtmlToWebServer function back |
| 2025-02-20 | quick Fixed delete UNITY_EXECUTABLE in environment |

</details>

<details>
<summary><strong>PR #22: CORE-1525-Update-the-existing-Build-Result-link-on-the-Bitbucket-PR-page (11 commits)</strong></summary>

| Date | Commit Message |
|------|----------------|
| 2025-02-21 | Fix environment variable reference in Jenkinsfile |
| 2025-02-21 | Remove redundant branch up-to-date check in Jenkinsfile |
| 2025-02-25 | Enhance Bitbucket build status description generation |
| 2025-02-25 | Modify Unity stage error handling to log instead of throwing error |
| 2025-02-25 | Refactor Bitbucket build status sending logic |
| 2025-02-25 | Update Bitbucket build status sending logic |
| 2025-02-26 | Refactor Jenkinsfile COMMIT_HASH variable handling |
| 2025-02-26 | Update Bitbucket build status URL to pipeline-graph |
| 2025-02-26 | Update the comment for sendBuildStatus function |
| 2025-02-27 | Add Hudson FilePath import to unityHelper.groovy |
| 2025-02-27 | Remove unused imports from unityHelper.groovy |

</details>

<details>
<summary><strong>PR #23: CORE-1531-Fixed-Unit-Stage-execution-failed (7 commits)</strong></summary>

| Date | Commit Message |
|------|----------------|
| 2025-02-27 | Add Jenkins Core dependency to build configuration |
| 2025-02-27 | Add Jenkins repository to build configuration |
| 2025-02-27 | Pin Jenkins Core dependency to version 2.414 |
| 2025-02-27 | Update Bitbucket build status and PR branch description in Jenkins pipelines |
| 2025-02-27 | Upgrade Jenkins Core dependency to version 2.498 |
| 2025-02-28 | Remove trailing 'SUCCESSFUL' text from Jenkinsfile |
| 2025-02-28 | Update Jenkinsfile to handle unstable build status |

</details>

<details>
<summary><strong>PR #28: CORE-1545-Fix-WebGL-Lighting-Issue (1 commit)</strong></summary>

| Date | Commit Message |
|------|----------------|
| 2025-03-07 | [Update] Modify graphic options for Playmode and WebGL environments |

</details>

<details>
<summary><strong>PR #30: Hot-fix-TPI-PlayMode-failing (3 commits)</strong></summary>

| Date | Commit Message |
|------|----------------|
| 2025-03-12 | Add catchError to show Stage fail message for the stage |
| 2025-03-12 | Mofity to use xvfb for PlayMode |
| 2025-03-12 | Re-modify-to-use-xvfb-for-PlayMode |

</details>

<details>
<summary><strong>PR #31: Fix/update-batchmode-error-handling (1 commit)</strong></summary>

| Date | Commit Message |
|------|----------------|
| 2025-03-12 | [update] Instead of handling error in one way, having two separate ways for CI and CD pipeline |

</details>

<details>
<summary><strong>Hot-fix-update-pipeline-error-handling-logic (3 commits)</strong></summary>

| Date | Commit Message |
|------|----------------|
| 2025-03-12 | Mofity to use xvfb for PlayMode |
| 2025-03-12 | Add catchError to show Stage fail message for the stage |
| 2025-03-12 | Re-modify-to-use-xvfb-for-PlayMode |

</details>

<details>
<summary><strong>PR #34: CORE-1543-Integrate-SonarQube-into-PipelineForJenkins (97 commits)</strong></summary>

| Date | Commit Message |
|------|----------------|
| 2025-03-17 | - Fix indentation |
| 2025-03-17 | Add Bash to SonarQube exclusions. |
| 2025-03-17 | Add configuration files Jenkinsfile and JenkinsfileDeployment to SonarQube scanner command. |
| 2025-03-17 | Add groovy file suffixes to SonarQube scanner command. |
| 2025-03-17 | Add SonarQube scanner command to add more details to the analysis logs by activating the DEBUG mode for the scanner. |
| 2025-03-17 | Add static code analysis stage, running SonarQube scanner. |
| 2025-03-17 | Add try-catch block for sonarqube stage. |
| 2025-03-17 | Add try-catch block in Prepare Workspace stage |
| 2025-03-17 | Added logMessage helper method |
| 2025-03-17 | Deleted logErrors.txt and removed parseLogsForError function from unityHelper.groovy. |
| 2025-03-17 | Exclude C#, Bash, Gradle files from SonarQube scanner. |
| 2025-03-17 | Fixed groovy imports |
| 2025-03-17 | Fixed the bracket matching issue |
| 2025-03-17 | Modified SonarQube URL |
| 2025-03-17 | Modify SonarQube scanner command to add groovy file suffixes. |
| 2025-03-17 | Modify SonarQube stage error handling. |
| 2025-03-17 | Moved checkQualityGateStatus function from jsHelper to generalHelper |
| 2025-03-17 | Moved groovy imports to the top of the file |
| 2025-03-17 | Re-modified sonarqube host url |
| 2025-03-17 | Update SonarQube scanner command - Add log level DEBUG |
| 2025-03-18 | Add currentBuild.description |
| 2025-03-18 | Fixed linting issue |
| 2025-03-18 | Fixed Linting issues |
| 2025-03-18 | Fixed Lintings |
| 2025-03-18 | Fixed sonarqube command |
| 2025-03-18 | Merge branch 'main' into CORE-1543 |
| 2025-03-19 | Add enum for build and stage results |
| 2025-03-19 | Add import for FileItem |
| 2025-03-19 | Added buildResult and stageResult variables loaded. |
| 2025-03-19 | Added filter for NglParseError |
| 2025-03-19 | Apply Json instead of enum |
| 2025-03-19 | Catcherror Linting Test |
| 2025-03-19 | Delete groovylint-disable NglParseError |
| 2025-03-19 | Delete groovy-lint-report.json |
| 2025-03-19 | Final commit |
| 2025-03-19 | Fixed catchError in jsHelper.groovy |
| 2025-03-19 | Fixed Lintings |
| 2025-03-19 | Fixed one of catchError options |
| 2025-03-19 | Fixed the way buildResults and stageResults are used in the Jenkinsfile |
| 2025-03-19 | Linting test for using json for buildResults and stageResults |
| 2025-03-19 | re test without FilePath |
| 2025-03-19 | Rebase |
| 2025-03-19 | Remove whitespace from catchError |
| 2025-03-19 | Revert "Add import for FileItem" and using FilePath instead |
| 2025-03-19 | Test enum functionality |
| 2025-03-19 | Test enum without loading |
| 2025-03-19 | Test Groovy Lint |
| 2025-03-19 | Test linting |
| 2025-03-19 | Test not using hudson FilePath |
| 2025-03-19 | Test without FilePath |
| 2025-03-19 | Use Json for buildResults and stageResults |
| 2025-03-19 | Use JsonSlurperClassic instead of JsonSlurper |
| 2025-03-20 | Revert "Added filter for NglParseError" |
| 2025-03-21 | Added Load Shared Library stage for PipelineForJenkins |
| 2025-03-21 | Difference way to implement shared library for jenkins pipeline |
| 2025-03-21 | Final Try |
| 2025-03-21 | Fix shared library path |
| 2025-03-21 | Fixed Library tag validation function |
| 2025-03-21 | fixed shared library loading path |
| 2025-03-21 | Fixed shared library path |
| 2025-03-21 | Implement shared library for PipelineForJenkins |
| 2025-03-21 | Load Shared Library stage |
| 2025-03-21 | Next try |
| 2025-03-21 | node test |
| 2025-03-21 | Retry |
| 2025-03-21 | Retry absolute path |
| 2025-03-21 | retry with node master |
| 2025-03-21 | Temporarily removed Load Shared Library stage |
| 2025-03-21 | Test Shared Library |
| 2025-03-21 | Try absolute path |
| 2025-03-21 | Try without @CompileStatic |
| 2025-03-21 | using node block outside of stage block |
| 2025-03-23 | Added package importing for jsHelper.groovy |
| 2025-03-23 | Added sharedLibraries directory to build.gradle |
| 2025-03-23 | Added test case for ResultStatus package |
| 2025-03-23 | Apply shared library for DLX Deployment pipeline |
| 2025-03-23 | Deleted unused function |
| 2025-03-23 | Fixed CI_PIPELINE variable operation |
| 2025-03-23 | Fixed Linting |
| 2025-03-23 | Fixed Linting again |
| 2025-03-23 | Fixed linting and Applied shared library for JS pipeline |
| 2025-03-23 | Fixed linting errors |
| 2025-03-23 | Fixed Linting errors |
| 2025-03-23 | Fixed loading shared library |
| 2025-03-23 | Fixed missing double quotes in echo statements |
| 2025-03-23 | Replace sh 'pwd' with pwd() |
| 2025-03-23 | Test Unity Pipeline without Load Shared Library stage |
| 2025-03-23 | Test UnityHelper Importing package without Load Shared Library |
| 2025-03-23 | Try to run work prepare workspace stage with try catch surrounded |
| 2025-03-23 | Try without L |
| 2025-03-24 | Groovy Lint disable test |
| 2025-03-24 | No parse argument for lint |

</details>

<details>
<summary><strong>CORE-1526-Conditional-Retry-Logic-For-Batch-Mode-Failures-In-DLX-Pipeline (11 commits)</strong></summary>

| Date | Commit Message |
|------|----------------|
| 2025-03-27 | test |
| 2025-03-27 | test |
| 2025-03-27 | test |
| 2025-03-27 | setse |
| 2025-03-27 | test |
| 2025-03-27 | test |
| 2025-03-27 | test |
| 2025-03-27 | Fixed |
| 2025-03-27 | test |
| 2025-03-27 | ests |
| 2025-03-27 | asdf |

</details>

<details>
<summary><strong>CORE-1547-Asset-Not-Importing-Git-Large-File-Storage_Issue (8 commits)</strong></summary>

| Date | Commit Message |
|------|----------------|
| 2025-03-31 | Fixed incorrect package call |
| 2025-03-31 | Merged main into CORE-1444-LongCommitHash |
| 2025-03-31 | Delete Test Cases for UnityHelper.groovy due to ensureFileExistOrWarn function no longer exists |
| 2025-03-31 | Check if any large files are untracked |
| 2025-03-31 | Added check for untracked large files and pull them |
| 2025-03-31 | Add new package GitLFSHelper |
| 2025-03-31 | Fixed a way of using shared library |
| 2025-03-31 | Fixed how to construct GitLFSHelper Class |

</details>

<details>
<summary><strong>PR #41: CORE-1547-Git-Large-File-Storage-Issue-To-Fix-Some-Asset-Not-Importing (41 commits)</strong></summary>

| Date | Commit Message |
|------|----------------|
| 2025-03-31 | Add new package GitLFSHelper |
| 2025-03-31 | Added check for untracked large files and pull them |
| 2025-03-31 | Check if any large files are untracked |
| 2025-03-31 | Fixed a way of using shared library |
| 2025-03-31 | Fixed how to construct GitLFSHelper Class |
| 2025-04-01 | Added dependencies for Spock Mocking framework and Modified GitLFSHelperSpec.groovy |
| 2025-04-01 | Added GitLFSHelper to its test |
| 2025-04-01 | Added missing import |
| 2025-04-01 | Added UnityHelperSpec and GitLFSHelperSpec |
| 2025-04-01 | Change Jenkinsfile to use shared library |
| 2025-04-01 | Final Test |
| 2025-04-01 | Fixed GitLFSHelperSpec |
| 2025-04-01 | Fixed import statement |
| 2025-04-01 | Fixed Jenkinsfile |
| 2025-04-01 | Fixed missing target |
| 2025-04-01 | Fixed PrepareWorkspaceService checkAndPullUntrackedLFSFiles method call |
| 2025-04-01 | Fixed test Class name |
| 2025-04-01 | Fixed Test Script ResultStatusSpec |
| 2025-04-01 | Fixed the path of importing GitLFSHelper package |
| 2025-04-01 | Implemented PrepareWorkspaceService and BuildProjectService in JenkinsfileDeployment |
| 2025-04-01 | Integrate Mocking in GitLFSHelperSpec with Spock framework |
| 2025-04-01 | Integrate Mocking in GitLFSHelperSpec with Spock framework (Fixed Missing Method Exception) |
| 2025-04-01 | Modified BuildProjectService.groovy |
| 2025-04-01 | Modified Infrastructure of Shared Library |
| 2025-04-01 | Modified Jenkinsfile to use new LightAndReflectionFileChecker |
| 2025-04-01 | Modified the version of jenkins-spock |
| 2025-04-01 | Modify GitLFSHelper to use shared library |
| 2025-04-01 | Re-categorize GitLFSHelper and LightAndReflectionFileChecker |
| 2025-04-01 | Refactor CheckIfLightAndReflectionFilesExist to be a shared library |
| 2025-04-01 | Replace checkAndPullUntrackedLFSFiles method call |
| 2025-04-01 | Test GitLFSHelper differently, not using JenkinsPipelineSpecification and PipelineTestHelper |
| 2025-04-01 | Test GitLFSHelperSpec |
| 2025-04-01 | Tried to fix Interaction is missing a target |
| 2025-04-01 | Tried to mock the Jenkinsfile but failed |
| 2025-04-01 | Try to fix the GitLFSHelperSpec test |
| 2025-04-01 | Use different mocking framework for unit testing |
| 2025-04-02 | Fixed linting issue in Jenkinsfile |
| 2025-04-02 | Merge remote-tracking branch 'origin' into CORE-1547 |
| 2025-04-02 | Removed Korean comments |

</details>

<details>
<summary><strong>PR #36: CORE-1444-LongCommitHash (3 commits)</strong></summary>

| Date | Commit Message |
|------|----------------|
| 2025-03-31 | Fixed incorrect package call |
| 2025-03-31 | Merged main into CORE-1444-LongCommitHash |
| 2025-03-31 | Delete Test Cases for UnityHelper.groovy due to ensureFileExistOrWarn function no longer exists |

</details>

<details>
<summary><strong>Bug/Correct-Sending-Linting-Result-Status (1 commit)</strong></summary>

| Date | Commit Message |
|------|----------------|
| 2025-04-04 | Adjust linting failon level from error to info to send precise Linting Result Status |

</details>

<details>
<summary><strong>PR #46: CORE-1542-MethodSignatures (8 commits)</strong></summary>

| Date | Commit Message |
|------|----------------|
| 2025-04-08 | Organize build.gradle dependencies with comments and groupings |
| 2025-04-09 | Merge branch 'CORE-1542-MethodSignatures' of bitbucket.org:VARLab/devops-linux-jenkins into CORE-1542-MethodSignatures |
| 2025-04-09 | Deleted unnecessary pipelineHelper method |
| 2025-04-09 | Deleted not necessary test case |
| 2025-04-09 | Removed not necessary function |
| 2025-04-09 | Change to handle build status in PR pipeline |
| 2025-04-09 | Modified how to handle build result status in stages |
| 2025-04-09 | Modified |

</details>

<details>
<summary><strong>CORE-1526-Add-Conditional-Retry-Logic-for-Batch-Mode-Failures-in-DLX-Pipeline (4 commits)</strong></summary>

| Date | Commit Message |
|------|----------------|
| 2025-04-08 | Base 139 error handling Code |
| 2025-04-09 | Merge remote-tracking branch 'origin/main' into CORE-1526-Add-Conditional-Retry-Logic-for-Batch-Mode-Failures-in-DLX-Pipeline |
| 2025-04-09 | ShellScripting Label Testing |
| 2025-04-13 | Save temporary changes |

</details>

<details>
<summary><strong>Implement-Global-Trusted-Shared-Library (22 commits)</strong></summary>

| Date | Commit Message |
|------|----------------|
| 2025-04-21 | Global Library Test |
| 2025-04-21 | test |
| 2025-04-21 | test |
| 2025-04-21 | test |
| 2025-04-21 | test |
| 2025-04-21 | teest |
| 2025-04-21 | test |
| 2025-04-21 | Test |
| 2025-04-21 | Delete Load Shared Library Stage after managing Global Trusted Library Configuration worked |
| 2025-04-21 | Renamed my-simple-lib to global-trusted-shared-library |
| 2025-04-21 | Refactoring DLX-PR pipeline implementing the Global Trusted Shared Library |
| 2025-04-21 | Try a different way to use 'new' operator |
| 2025-04-21 | Modifed other way to call new operator in PR-DLX pipeline |
| 2025-04-21 | Implement Global Trusted Shared Library for Deployment-DLX pipeline |
| 2025-04-21 | Implement Global Trusted Shared Library for JavaScript Deployment Pipeline |
| 2025-04-23 | Delete Optional filter to test executing pipeline run by repo push trigger |
| 2025-04-24 | vars test |
| 2025-04-24 | vars test |
| 2025-04-24 | vars Test with Library branch change |
| 2025-04-24 | Revert "Delete Optional filter to test executing pipeline run by repo push trigger" |
| 2025-04-24 | Revert "vars test" |
| 2025-04-24 | Revert "vars test" |

</details>

<details>
<summary><strong>PR #59: Refactor-with-TDD (262 commits)</strong></summary>

| Date | Commit Message |
|------|----------------|
| 2025-04-21 | Delete Load Shared Library Stage after managing Global Trusted Library Configuration worked |
| 2025-04-21 | Global Library Test |
| 2025-04-21 | Implement Global Trusted Shared Library for Deployment-DLX pipeline |
| 2025-04-21 | Implement Global Trusted Shared Library for JavaScript Deployment Pipeline |
| 2025-04-21 | Modifed other way to call new operator in PR-DLX pipeline |
| 2025-04-21 | Refactoring DLX-PR pipeline implementing the Global Trusted Shared Library |
| 2025-04-21 | Renamed my-simple-lib to global-trusted-shared-library |
| 2025-04-21 | test |
| 2025-04-21 | Try a different way to use 'new' operator |
| 2025-04-23 | Delete Optional filter to test executing pipeline run by repo push trigger |
| 2025-04-24 | Revert "Delete Optional filter to test executing pipeline run by repo push trigger" |
| 2025-04-24 | Revert "vars test" |
| 2025-04-24 | vars test |
| 2025-04-24 | vars Test with Library branch change |
| 2025-04-25 | Added git origin fetch and get shell latest commit commands in Intialization groovy with error handling |
| 2025-04-25 | Added logic for TICKET NUMBER and FOLDER NAME and test initial lowercase Stage class name |
| 2025-04-25 | Added PRBRANCH git origin fetch in Initialization stage |
| 2025-04-25 | Fixed the way to do Package and use it |
| 2025-04-25 | Improved log in Initialization stage and ShellScript Helper |
| 2025-04-25 | Initialization initial test |
| 2025-04-25 | initialization.groovy has been updated to Initialization.groovy with the initial letter capitalized |
| 2025-04-25 | Move import ShellParams Package in Jenkinsfile |
| 2025-04-25 | Removed Canonical annotation |
| 2025-04-25 | Shell Script Data Class and Improve ShellScriptHelper |
| 2025-04-25 | ShellScripting Modulized |
| 2025-04-25 | Try initial lowercase groovy file name in vars folder |
| 2025-04-26 | Delete private access limiter in logger groovy regarding Jenkins pipeline access field member variables, CPS |
| 2025-04-26 | Fixed throw error handling |
| 2025-04-26 | Fixed using incorrect shellScriptHelper name |
| 2025-04-26 | Improved logging and test vars |
| 2025-04-26 | initial logger implemented |
| 2025-04-26 | Logger test |
| 2025-04-26 | Re-test vars |
| 2025-04-26 | re-test vars no call method |
| 2025-04-26 | Second try to fix logger field variables scope issue, CPS |
| 2025-04-26 | Try logging without the field variables |
| 2025-04-26 | Try to fix logger field variables scope issue |
| 2025-04-27 | Implement new sendBuildStatusForCommit API function, refactored send_bitbucket_build_status function |
| 2025-04-27 | Import the 'JsonOutPut' package in apiHelper.groovy |
| 2025-04-27 | Refactor status handling and prepare new API helper |
| 2025-04-27 | slightly touch up logging messages in logger.groovy |
| 2025-04-27 | Update StatusSpec Unit tests |
| 2025-05-01 | Add print jenkins environment |
| 2025-05-01 | Corrected PR_BRANCH to GIT_BRANCH |
| 2025-05-01 | Delete necessary function to get full commit hash |
| 2025-05-01 | Implemented sendBuildStatusForCommit method to send build status to Bitbucket Cloud API |
| 2025-05-01 | Replace PR_BRANCH with GIT_BRANCH |
| 2025-05-01 | repo:push test |
| 2025-05-02 | Add more logging for HTTP Request |
| 2025-05-02 | Add print StackTrace Error message code |
| 2025-05-02 | Added error type for HTTP request |
| 2025-05-02 | Added missing package importing in bitbucketApi groovy |
| 2025-05-02 | Added missing package in BitbucketApiClient groovy |
| 2025-05-02 | Added package imports to apiHelper.groovy |
| 2025-05-02 | Fixed Compail error |
| 2025-05-02 | Fixed Compiler Error |
| 2025-05-02 | Fixed shellScriptHelper Implementation |
| 2025-05-02 | Improve error logging |
| 2025-05-02 | Mark unnecessary Jenkins Environment and Create a new Stage |
| 2025-05-02 | Missing variable declaralation |
| 2025-05-02 | Modified Data Type check and Empty Condition logic in validateShMap function |
| 2025-05-02 | Polishing Logging |
| 2025-05-02 | Refactor Bitbucket API call |
| 2025-05-02 | Refactor SendBuildStatusForCommit Bitbucket API with HttpClient Class |
| 2025-05-02 | Refactor ShellScriptHelper and Create ShellScripts as list of shellscript |
| 2025-05-02 | Refactor try-out for ShellScript |
| 2025-05-02 | slightly touch StackTrace logging output |
| 2025-05-02 | slightly touch up logging message |
| 2025-05-02 | Try a new way to implement bitbucket api |
| 2025-05-02 | Try to fix closing chuck expected error during Bitbucket API Communication |
| 2025-05-02 | Try to fix closing chunk expected second attempt |
| 2025-05-02 | Try to fix Compile Error |
| 2025-05-02 | Try to print stacktrace error message |
| 2025-05-02 | Use StringBuilder not steam Collectors |
| 2025-05-03 | Add unstaged changes to previous commit |
| 2025-05-03 | Commented out Prepare Workspace refacted into Jenkins Initialization and Project Preparation stages |
| 2025-05-03 | Commented out the error log for the returnStdout option in shellScriptHelper.groovy |
| 2025-05-03 | Created / Implemented GIT_CHECK_IS_REMOTE_BRANCH_ANCESTOR shell script helper function |
| 2025-05-03 | Fixed GIT_SHOW_CUREENT_BRANCH Closure |
| 2025-05-03 | Fixed GIT_SHOW_CURRENT_BRANCH |
| 2025-05-03 | Fixed GIT_SHOW_CURRENT_BRANCH Closure to return the current branch name |
| 2025-05-03 | Fixed incorrect implementation for sh step and correct javadoc for ShellScripts groovy |
| 2025-05-03 | Fixed incorrect rutern data type for fileExists function |
| 2025-05-03 | Fixed ShellScripts.groovy to return the current branch name |
| 2025-05-03 | Fixing GIT_SHOW_CURRENT_BRANCH Closure |
| 2025-05-03 | Git test with pwd property |
| 2025-05-03 | Implement Git source code checkout and synchronization logic |
| 2025-05-03 | Implemented new shell script helper functions in stageProjectPrepare |
| 2025-05-03 | Improved logging |
| 2025-05-03 | Improved shell script helper function |
| 2025-05-03 | Improved shell script logging |
| 2025-05-03 | New shell scripts and updated existing shell scripts |
| 2025-05-03 | new stageCheckoutSourceCode groovy Checkpoint |
| 2025-05-03 | Pipeline stage name change, Git sync check addition, and success logic modification |
| 2025-05-03 | Refactor a part of cloneOrUpdateRepo and test |
| 2025-05-03 | Replace COMMIT_HASH with GIT_COMMIT |
| 2025-05-03 | sh returnstdout test |
| 2025-05-03 | Test fileExists function instead of isDirectory |
| 2025-05-03 | Test isDirectory function |
| 2025-05-03 | Upgrade Shell Script Label |
| 2025-05-04 | Add missing Class declaration |
| 2025-05-04 | Add missing pakcage import |
| 2025-05-04 | createBuildStatusForCommit |
| 2025-05-04 | Delete not use package import |
| 2025-05-04 | Fixed calling incorrec method name |
| 2025-05-04 | Fixed Method Exception |
| 2025-05-04 | Implementation of Bitbucket API and Refactored related functions |
| 2025-05-04 | Implmented not using BitbucketApiLibrary |
| 2025-05-04 | Improved Http request logic and logging |
| 2025-05-04 | quick fixed incorrect class name usage |
| 2025-05-04 | Refactored Stages Implemented and Deleted Previous |
| 2025-05-04 | Refactoring: ShellScripts into Libraries and Integration |
| 2025-05-04 | Try to fix api function variables |
| 2025-05-04 | Try to fix bitbucket API function |
| 2025-05-04 | try to use function |
| 2025-05-05 | Add missing package import in PipelineForJenkins jenkinsfile |
| 2025-05-05 | Added Missing Property for GroovyLint |
| 2025-05-05 | Implement dockerInfo shellscript into shellLibrary |
| 2025-05-05 | Implement GroovyLint ShellScript into ShellLibrary |
| 2025-05-05 | Improved shellScriptHelper logging |
| 2025-05-05 | Rename all Shell Library Clsoure for name convention |
| 2025-05-05 | Take unnecessary log message in ShellLibrary GroovyLint script property |
| 2025-05-06 | == Start DLX Pipeline Refactoring == : Refactored Prepare Workspace Stage |
| 2025-05-06 | Add missing package importing |
| 2025-05-06 | Added getting BITBUCKET_EVENT_KEY |
| 2025-05-06 | Added logging in stageLintGroovyJenkinsfile |
| 2025-05-06 | Added missing package importing |
| 2025-05-06 | Added Missing the variable for importing package |
| 2025-05-06 | Added More Missing Packge Importing |
| 2025-05-06 | Added More step to secure returning value from shellscript |
| 2025-05-06 | Added regexpFilter for HTTP Header |
| 2025-05-06 | Added Request Body and Header trigger |
| 2025-05-06 | Assigned all necessary Jenkins environment for repo push Bitbucket WebTrigger |
| 2025-05-06 | Commented out regexpFilter for DLX Pipeline |
| 2025-05-06 | DLX-PR-Pipeline-Linting Stage |
| 2025-05-06 | Fixed Destination Branch Environment Assignment logic |
| 2025-05-06 | Fixed empty value for REPORT_DIR |
| 2025-05-06 | Fixed how to import Http Header variables |
| 2025-05-06 | getting full request header |
| 2025-05-06 | Implement DESTINATION_BRANCH environment value assignment in different way for every pipelines |
| 2025-05-06 | Incorrect environment variable using for PR_BRANCH |
| 2025-05-06 | modified logging for getting http request body and header |
| 2025-05-06 | Modulized Static Analysis Stage |
| 2025-05-06 | One more time webhoob trigger for implmenting GenericTrigger configuration fully |
| 2025-05-06 | Print env first |
| 2025-05-06 | Print Json Request body Jons |
| 2025-05-06 | Push to check accessing x-event-key header |
| 2025-05-06 | quick teset |
| 2025-05-06 | Refactored LintGrovyJenkinsfile Stage |
| 2025-05-06 | Refactored SonarQube test |
| 2025-05-06 | Replace the un-modularized bitbucket api function with the modularized one for post steps |
| 2025-05-06 | Same Implement repo push event trigger for DLX PR pipeline |
| 2025-05-06 | Switch better symbol for info log |
| 2025-05-06 | Take loading groovy in environment braket off |
| 2025-05-06 | Test getting http request header |
| 2025-05-06 | Test Http body Json retrieving |
| 2025-05-06 | Test loading groovy file in Envrionment |
| 2025-05-06 | Test Modulized Static Analysis Stage |
| 2025-05-06 | Try new way to retrieve http header |
| 2025-05-06 | Try one more time |
| 2025-05-06 | Try to get Branch name |
| 2025-05-06 | try to get full request body |
| 2025-05-06 | Try to not to use expression of JsonPath for Http header |
| 2025-05-06 | Try to retrieve lowcase and underscore for generic Header Variables |
| 2025-05-06 | Try to retrieve x event key only |
| 2025-05-06 | Try to use HTTP BODY JSON |
| 2025-05-06 | Try to use x_event_key |
| 2025-05-06 | X-Event-Key |
| 2025-05-07 | Add dir function to get full commit hash |
| 2025-05-07 | Add getting http x-event-key header value for DLX-Deployment pipeline |
| 2025-05-07 | Add sh inside shellScript |
| 2025-05-07 | Added Connection check ssh |
| 2025-05-07 | Added getting PR_COMMIT for pullrequest event webhook |
| 2025-05-07 | Added Missing Reference |
| 2025-05-07 | Added one more logging for shellscript result |
| 2025-05-07 | Change logic for checking lighting and reflection Probe files |
| 2025-05-07 | Changed shellscript type for ssh |
| 2025-05-07 | Complete DLX-PR-Pipeline Refactor |
| 2025-05-07 | Correct unnecessary argument for CopyLintConfig ShellScripting |
| 2025-05-07 | Debugging fileExist function |
| 2025-05-07 | Delete no need paranthesis in checkLightingAndReflectionFiles |
| 2025-05-07 | Delete Unnecessary function |
| 2025-05-07 | Deleted unnecessary try and catch |
| 2025-05-07 | EditMode modulurized test |
| 2025-05-07 | EditMode stage test |
| 2025-05-07 | Fixed how to use goorvy file in vars |
| 2025-05-07 | Fixed incorrect argument to execute webgl build unity headless mode |
| 2025-05-07 | Fixed incorrect python calling |
| 2025-05-07 | Fixed incorrect return value for FindPRJobDirectory |
| 2025-05-07 | Fixed not use trim |
| 2025-05-07 | Fixed the delete PR artifacts file logic for CD pipeline |
| 2025-05-07 | Fixed wrong import package |
| 2025-05-07 | git add . |
| 2025-05-07 | Implement Cleanup PR Branch Artifacts |
| 2025-05-07 | Implement stripIndent function |
| 2025-05-07 | Improve logging and detatched stripIndent functions for error issue |
| 2025-05-07 | Improved catchError function |
| 2025-05-07 | Improved Linting logic for Unity |
| 2025-05-07 | Improved logger |
| 2025-05-07 | Initial Refactor completed |
| 2025-05-07 | Initial Refactored jenkinsflies for DLX-PR, Deployment, and Pipeline Code |
| 2025-05-07 | Modified ShellScripting Logging Message |
| 2025-05-07 | Modulurized ssh shell scripting for Deploying WebGL to dlx-web hosting server |
| 2025-05-07 | Modulurized the stage |
| 2025-05-07 | Moved logger inside script bracket |
| 2025-05-07 | Pointing Refactor-with-TDD global Trusted Shared Library Branch |
| 2025-05-07 | Polish ShellLibrary.groovy to improve readability |
| 2025-05-07 | Refacted PlayMode and Coverage Stage |
| 2025-05-07 | refactor again |
| 2025-05-07 | Refactor Delete Merged Branch Stage |
| 2025-05-07 | Refactor Linting Stage |
| 2025-05-07 | Refactor stageProjectPrepare groovy for unify PR and Deployment Pipeline together |
| 2025-05-07 | Refactored Build Project Stage for DLX PR pipeline |
| 2025-05-07 | Refactored CopyWebGLBuilder file |
| 2025-05-07 | Refactored Prepare Workspace into Project Preparation |
| 2025-05-07 | Refactored sendTestReport function in UnityHelper into ShellLibrary |
| 2025-05-07 | Refactored Unity Linting STage |
| 2025-05-07 | Refactoring Cleanup PR Branch Artifacts |
| 2025-05-07 | stiripIndent function test |
| 2025-05-07 | stripIndent function test |
| 2025-05-07 | Temparory test |
| 2025-05-07 | Test Refactor Unity Execution in Deployment |
| 2025-05-07 | test webhook trigger filter for jenkins pipeline |
| 2025-05-07 | Try to added regexpFilterExpression for not merged trigger for PR branch |
| 2025-05-07 | try to fix copy lint config file for unity linting |
| 2025-05-07 | Try to fix directory finding |
| 2025-05-07 | Try to fix shellscript |
| 2025-05-07 | Try to improve new logging style |
| 2025-05-07 | Try to use wildcard |
| 2025-05-07 | Updated logging in stageInitialization |
| 2025-05-07 | Updated stageInitialization groovy more readable |
| 2025-05-07 | Use different configuration property to find PR path |
| 2025-05-08 | Added ConnectionAttempts for CheckSSHConnectivity |
| 2025-05-08 | Added Network Connection Check |
| 2025-05-08 | Added stripIdent() and trim() for every shellscript |
| 2025-05-08 | Added stripIndent for every ssh shellscript |
| 2025-05-08 | Added stripIndent for ssh |
| 2025-05-08 | Check SSH Connectivity Modulurized |
| 2025-05-08 | EconestogaDLX connection check |
| 2025-05-08 | Fixed one git library |
| 2025-05-08 | Fixed typo |
| 2025-05-08 | Improved logging |
| 2025-05-08 | logging improved |
| 2025-05-08 | Try to fix ssh command |
| 2025-05-09 | Added Error handling for bitbucket api communication |
| 2025-05-09 | Added missing package in Gladle test configuration |
| 2025-05-09 | Delete artifact(dump file) of running test locally |
| 2025-05-12 | Revert "Temparory test" |

</details>

<details>
<summary><strong>Unmerged: AI_Integration (8 commits)</strong></summary>

| Date | Commit Message |
|------|----------------|
| 2025-05-12 | Change The target branch of Global Library |
| 2025-05-12 | Fixed missing data type declaration |
| 2025-05-12 | Fixed wrong Project Directory |
| 2025-05-12 | Implement AI Code Analysis and Created AIJenkins pipline |
| 2025-05-12 | Merge remote-tracking branch 'origin/main' into AI_Integration |
| 2025-05-12 | reverted jsjenkinsfile |
| 2025-05-21 | Fixed using Status value with incorrect ClassName |
| 2025-05-28 | Added a flag for test case analysis by Sonarqube |

</details>

<details>
<summary><strong>Unmerged: Temporary-Branch (7 commits)</strong></summary>

| Date | Commit Message |
|------|----------------|
| 2025-05-20 | ♻️ Capture and expose HTTP API responses; rename BitbucketApiService → HttpApiService |
| 2025-05-20 | ♻️ Enhance shellScriptHelper logging; apply structured step groups to PR cleanup logic |
| 2025-05-20 | ♻️ Improve visual structure of step / stage logs in Jenkins |
| 2025-05-20 | ♻️ Refactor GitLibrary & ProjectPrepare stage for structured grouping and execution feedback |
| 2025-05-20 | ♻️ Refactor SonarQube analysis logic into modular scanner function |
| 2025-05-20 | 🐛 Fix incorrect commit reference (GIT_COMMIT → PR_COMMIT) in linting and build status reporting |
| 2025-07-04 | Fixing webgl build and hosting, listing unchecked git lfs |

</details>
