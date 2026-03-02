# Pipeline Domain Mapping

> Summary of domains used across all 5 pipelines, derived from sequence diagram analysis.
>
> **Related**: [DLX CI](dlx-ci.md) | [DLX CD](dlx-cd.md) | [JS CI](js-ci.md) | [JS CD](js-cd.md) | [Jenkins CI](jenkins-ci.md)

---

## Why This Document?

> **Q: Why map domains across pipelines?**
>
> A: Jenkins Pipeline is **procedural code**. Unlike OOP where classes naturally define domain boundaries, procedural code mixes multiple domains within sequential execution flow. This document summarizes domain distribution across all pipelines to establish a **baseline for Software Smells analysis**.

> **Q: What is a "domain" in this context?**
>
> A: A domain represents a **functional boundary** - a distinct area of responsibility such as Git operations, Bitbucket API calls, or Unity CLI commands.

> **Q: How is this document used?**
>
> A: This document serves as the **domain reference** when analyzing Software Smells (e.g., Divergent Change, Shotgun Surgery). By defining which functions belong to which domains, we can objectively measure SRP violations and identify refactoring targets.

---

## 1. Domain by Pipeline

| Domain | DLX CI | DLX CD | JS CI | JS CD | Jenkins CI | Primary Location |
|--------|:------:|:------:|:-----:|:-----:|:----------:|------------------|
| Git | ✓ | ✓ | ✓ | ✓ | ✓ | generalHelper + Jenkinsfile |
| Bitbucket | ✓ | ✓ | ✓ | ✓ | ✓ | generalHelper + unityHelper + Python |
| Web Server (SSH/SCP) | ✓ | ✓ | ✓ | | ✓ | generalHelper + Jenkinsfile |
| SonarQube | | | ✓ | ✓ | ✓ | generalHelper + sonar-scanner |
| Parsing | ✓ | ✓ | ✓ | ✓ | ✓ | generalHelper |
| File System | ✓ | ✓ | ✓ | ✓ | ✓ | generalHelper + jsHelper + Jenkinsfile |
| Unity CLI | ✓ | ✓ | | | | unityHelper |
| Unity Installation | ✓ | ✓ | | | | unityHelper |
| Node.js (npm) | | | ✓ | ✓ | | jsHelper + Jenkinsfile |
| Utility | | | | ✓ | | jsHelper |
| Linting (Bash) | ✓ | ✓ | | | | Jenkinsfile direct |
| Docker | | | | ✓ | ✓ | Jenkinsfile direct |
| Azure | | | | ✓ | | Jenkinsfile direct |
| Gradle | | | | | ✓ | Jenkinsfile direct |
| Groovydoc | | | | | ✓ | Jenkinsfile direct |

---

## 2. Domain by Helper File

### 2.1 generalHelper.groovy (7 domains + 1 mixed, 21 functions)

| # | Domain | Functions | Count |
|---|--------|-----------|:-----:|
| 1 | Git | `cloneOrUpdateRepo`, `getDefaultBranch`, `checkoutBranch`, `mergeBranchIfNeeded`, `isBranchUpToDateWithRemote`, `isBranchUpToDateWithMain`, `tryMerge`, `getCurrentCommitHash` | 8 |
| 2 | Bitbucket | `getFullCommitHash`, `sendBuildStatus` | 2 |
| 3 | Web Server (SSH/SCP) | `publishTestResultsHtmlToWebServer`, `publishBuildResultsToWebServer`, `cleanMergedBranchFromWebServer`, `publishGroovyDocToWebServer` | 4 |
| 4 | SonarQube | `checkQualityGateStatus` | 1 |
| 5 | Parsing | `parseJson`, `parseTicketNumber` | 2 |
| 6 | File System | `cleanUpPRBranch` | 1 |
| 7 | Logging | `logMessage`, `closeLogfiles` | 2 |
| - | **Mixed (Bitbucket + Parsing)** | `initializeEnvironment` | 1 |

> **Note**: `initializeEnvironment` combines Bitbucket notification and parsing logic in single function - this is an SRP violation.

### 2.2 jsHelper.groovy (4 domains, 10 functions)

| # | Domain | Functions | Count |
|---|--------|-----------|:-----:|
| 1 | Node.js/npm | `installNpmInTestingDirs`, `runUnitTestsInTestingDirs`, `executeLintingInTestingDirs`, `checkNodeVersion`, `getPackageJsonVersion` | 5 |
| 2 | File System | `findTestingDirs`, `retrieveReportSummaryDirs` | 2 |
| 3 | Utility | `versionCompare`, `runCommandReturnStatus` | 2 |
| 4 | Logging | `logMessage` | 1 |

### 2.3 unityHelper.groovy (3 domains, 8 functions)

| # | Domain | Functions | Count |
|---|--------|-----------|:-----:|
| 1 | Unity CLI | `runUnityStage`, `runUnityBatchMode`, `getCodeCoverageArguments`, `fetCoverageOptionsKeyAndValue`, `loadPathsToExclude`, `buildCoverageOptions` | 6 |
| 2 | Unity Installation | `getUnityExecutable` | 1 |
| 3 | Bitbucket | `sendTestReport` | 1 |

---

## 3. Pipeline Comparison

### 3.1 CI Pipelines

| Item | DLX CI | JS CI | Jenkins CI |
|------|--------|-------|------------|
| Build Tool | Unity CLI | Node.js (npm) | Gradle + Docker |
| Helper | unityHelper | jsHelper | (none) |
| Trigger | OPEN | OPEN | **OPEN + MERGED** |
| `initializeEnvironment` | ✓ | ✓ | ✓ |
| `mergeBranchIfNeeded` | ✓ | ✓ | **✗** |
| `checkoutBranch` in Post | ✓ | ✓ | **✗** |
| Linting | Bash Script (C#) | jsHelper (ESLint) | Docker (npm-groovy-lint) |
| Test Type | EditMode/PlayMode | Jest | Spock |
| Code Coverage | Unity Code Coverage | lcov-report | JaCoCo |
| Static Analysis | No | SonarQube | SonarQube |
| Test Report to Bitbucket | ✓ (Python) | ✓ (Python) | **✗** |
| Build Output | WebGL | No | No |
| Documentation | No | No | Groovydoc |

### 3.2 CD Pipelines

| Item | DLX CD | JS CD |
|------|--------|-------|
| Trigger | MERGED | MERGED |
| `initializeEnvironment` | **✗** (direct call) | **✗** (direct call) |
| Git in Prepare WORKSPACE | **Direct** | **Direct** |
| `checkoutBranch` in Post | ✓ (helper) | ✓ (helper) |
| Deploy Target | LTI Web Server, eConestoga | Azure Container App |
| Build Tool | Unity (WebGL) | Docker |
| Deploy Method | SSH/SCP (direct + helper) | Docker push + az containerapp (direct) |
| Version Management | None | package.json version compare |
| Conditional Deploy | DLX_PROJECT_LIST | Version compare result |
| Coverage Report to Bitbucket | ✗ | ✗ |

### 3.3 CI vs CD Pattern

| Item | CI Pipelines | CD Pipelines |
|------|--------------|--------------|
| `initializeEnvironment` | ✓ Used | ✗ Direct `sendBuildStatus` call |
| Git operations | Via generalHelper | **Mixed** (direct + helper) |
| Test/Coverage reports | Sent to Bitbucket | Not sent |
| Delete Merged Branch | No | Yes |

---

## 4. Source Documents

- [DLX CI Sequence Diagram](dlx-ci.md)
- [DLX CD Sequence Diagram](dlx-cd.md)
- [JS CI Sequence Diagram](js-ci.md)
- [JS CD Sequence Diagram](js-cd.md)
- [Jenkins CI Sequence Diagram](jenkins-ci.md)