# devops-jenkins-windows

## Basic Info
- **Original**: `git@bitbucket.org:VARLab/pipelineforjenkins.git`
- **New Location**: https://github.com/JindoKimKor/devops-jenkins-windows
- **Total PRs**: 9
- **Total My Commits**: 77

### Merged PRs (7)
| PR | Branch | Date |
|----|--------|------|
| #28 | feature/CORE-725-Optimize-PR-Pipeline-Time | 2024-06-07 |
| #29 | feature/CORE-756-implement-one-single-project-files-for-all-branch | 2024-06-13 |
| #30 | feature/CORE-837-Reduce-CPU-Usage-On-CI-Pipeline | 2024-06-26 |
| #32 | feature/CORE-883-Use-a-local-IP-address-in-create-log-report | 2024-07-08 |
| #34 | feature/CORE-933-Add-Playmode-Fail-Logic-for-PR-pipeline | 2024-07-17 |
| #64 | feature/CORE-1315-sonarqube-report-link-connected-to-PR-build-result-link | 2024-11-15 |
| #70 | CORE-1341-add-dir-for-targeting-correct-project-directory | 2024-11-25 |

### Unmerged Branches (2)
| Branch | Commits | Date |
|--------|---------|------|
| feature/CORE-1278-single-view-pipeline-report | 13 | 2024-11-11 ~ 2024-11-12 |
| CORE-1402-Migrate-to-Linux-Jenkins | 4 | 2025-01-07 |

---

## All My Commits (77 total)

### PR #28: feature/CORE-725-Optimize-PR-Pipeline-Time (12 commits)
| Date | Commit Message |
|------|----------------|
| 2024-06-05 | Disable Cleaning workspace Shell Script Line. |
| 2024-06-05 | Disable Build Project Stage to test faster. |
| 2024-06-05 | not deleting privous repository version |
| 2024-06-05 | adding -p option for making directory of coverage_results to avoid folder exist error |
| 2024-06-05 | updated code for delete index.lock file for every branch |
| 2024-06-05 | cleaning up the workspace for new Branch PullRequest |
| 2024-06-06 | Supplement the code at the decision point for diverging git cloning |
| 2024-06-06 | Supplemented by restructuring the If statement for diverging git cloning |
| 2024-06-06 | Modified the code to fix the issue at the decision point for diverging git cloning |
| 2024-06-06 | fix typo in jenkinsfile |
| 2024-06-07 | Merge branch 'main' into Jin-Test to resolve conflict manually |
| 2024-06-07 | Merged in feature/CORE-725-Optimize-PR-Pipeline-Time (pull request #28) |

### PR #29: feature/CORE-756-implement-one-single-project-files-for-all-branch (15 commits)
| Date | Commit Message |
|------|----------------|
| 2024-06-10 | Test-What-If-Copy-Whole-Project-Files |
| 2024-06-10 | added missing code '-quit' |
| 2024-06-10 | added slash for directory in copy process |
| 2024-06-11 | modified code for prepare workstage |
| 2024-06-11 | Implement using one project and its files for every branch pipeline |
| 2024-06-11 | Modified Code for Generating Directories |
| 2024-06-11 | modified code to generate report directory |
| 2024-06-11 | Fixed incorrect code for PlayMode Test |
| 2024-06-11 | Added missing argument for runUnityTests Method |
| 2024-06-11 | Added missing argument for buildProject method |
| 2024-06-12 | modified variable names to better reflect their roles. |
| 2024-06-12 | fixed incorrect comments in code |
| 2024-06-12 | fixed incorrect varilable names in postBuild method |
| 2024-06-13 | fixed incorrect directory variable in create_log_report |
| 2024-06-13 | Merged in feature/CORE-756-implement-one-single-project-files-for-all-branch (pull request #29) |

### PR #30: feature/CORE-837-Reduce-CPU-Usage-On-CI-Pipeline (22 commits)
| Date | Commit Message |
|------|----------------|
| 2024-06-17 | remote-branch initial commit |
| 2024-06-19 | More-RAM-less-CPU-memory-setting-code-added |
| 2024-06-19 | implemented memory setting for every stages |
| 2024-06-19 | commenting out EditMode Test, PlayMode Test, Generating Code Report stages for performance checking |
| 2024-06-20 | change back to default memory setting for test |
| 2024-06-24 | Test with more enhance setting for less CPU but more RAM |
| 2024-06-24 | added il2cpp.exe memery setting for CI pipeline |
| 2024-06-24 | il2cpp memery confiration added |
| 2024-06-24 | WebAssembly opmization configure added in Builder.cs |
| 2024-06-24 | another setting for WebGL.emscriptenArgs |
| 2024-06-24 | Convert to bytes from str |
| 2024-06-24 | More Memory for il2cpp.exe and wasm-opt.exe |
| 2024-06-24 | not 4294967296 then modified |
| 2024-06-25 | without emscriptenArgs memory setting |
| 2024-06-25 | original CPU Usage setting |
| 2024-06-25 | emscripten compiler optimization low setting |
| 2024-06-25 | Added CI_PIPELINE flag to distinguish CI and CD pipeline running |
| 2024-06-25 | Fixed incorrect flag in Deployment WebGL Build Stage |
| 2024-06-25 | Uncommenting EditMode, PlayMode Tests and Generating Code Stages |
| 2024-06-25 | modified incorrect flag in runUnityTest Method |
| 2024-06-26 | fixed runUnityTest flags value |
| 2024-06-26 | Merged in feature/CORE-837-Reduce-CPU-Usage-On-CI-Pipeline (pull request #30) |

### PR #32: feature/CORE-883-Use-a-local-IP-address-in-create-log-report (4 commits)
| Date | Commit Message |
|------|----------------|
| 2024-07-08 | added sh to print env configuration in log |
| 2024-07-08 | implemented urlparse module to get path of current build_url to use localhost ip address and port |
| 2024-07-08 | change the variable names to better match their roles |
| 2024-07-08 | Merged in feature/CORE-883-Use-a-local-IP-address-in-create-log-report (pull request #32) |

### PR #34: feature/CORE-933-Add-Playmode-Fail-Logic-for-PR-pipeline (3 commits)
| Date | Commit Message |
|------|----------------|
| 2024-07-15 | change pipeline exit condition in Test & Play Mode Test stage and added print log when It's failed |
| 2024-07-15 | Delete print log logic |
| 2024-07-17 | Merged in feature/CORE-933-Add-Playmode-Fail-Logic-for-PR-pipeline (pull request #34) |

### PR #64: feature/CORE-1315-sonarqube-report-link-connected-to-PR-build-result-link (2 commits)
| Date | Commit Message |
|------|----------------|
| 2024-11-15 | sonarqube-link-passing-to-PR-build-result-link |
| 2024-11-15 | Merged in feature/CORE-1315-sonarqube-report-link-connected-to-PR-build-result-link (pull request #64) |

### PR #70: CORE-1341-add-dir-for-targeting-correct-project-directory (2 commits)
| Date | Commit Message |
|------|----------------|
| 2024-11-25 | Added log for each method in prepare workspace and dir scripting for correcting project directory |
| 2024-11-25 | Merged in CORE-1341-add-dir-for-targeting-correct-project-directory (pull request #70) |

### Unmerged: feature/CORE-1278-single-view-pipeline-report (13 commits)
| Date | Commit Message |
|------|----------------|
| 2024-11-11 | redesign-report-link |
| 2024-11-11 | Fix Path Errors-Path-Delimiters-difference-between-Jenkins-and-Windows |
| 2024-11-11 | Replace sh command with bat command |
| 2024-11-11 | fix bat copy command |
| 2024-11-11 | fix copy path syntax error |
| 2024-11-11 | change manual path for copy |
| 2024-11-11 | add scripting to check report folder exist and create one if not |
| 2024-11-12 | fix-folder-name |
| 2024-11-12 | Add copying reports.html-center-html-report-file-to-WebServer |
| 2024-11-12 | Fix fucntion used mistake |
| 2024-11-12 | fix publishTestResult path |
| 2024-11-12 | fix VM folder path |
| 2024-11-12 | re-fix report path |

### Unmerged: CORE-1402-Migrate-to-Linux-Jenkins (4 commits)
| Date | Commit Message |
|------|----------------|
| 2025-01-07 | Add xvfb-run support for PlayMode tests in Unity CI script |
| 2025-01-07 | Add log Unity executable command for debugging |
| 2025-01-07 | Add divided lines for echos |
| 2025-01-07 | modified xvfb-run command with actual location path |
