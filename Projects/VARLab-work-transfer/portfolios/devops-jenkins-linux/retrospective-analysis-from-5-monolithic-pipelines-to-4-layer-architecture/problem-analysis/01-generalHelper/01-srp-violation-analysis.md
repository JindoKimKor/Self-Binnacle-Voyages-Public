<!--
Analysis Log:

[Why SRP for Jenkins Pipeline?]
- SRP is an OOP principle (SOLID), but the core concept "one reason to change" 
  applies to any code organization, not just classes
- Decided to apply SRP at two levels: Module (file) and Function

[Starting Point]
- generalHelper's original design intent: "common functions for all pipelines"
- If this intent is valid, all functions should be used across all pipelines
- Hypothesis: Analyze per-function to measure actual cohesion vs design intent

[Analysis Approach]
- Per function: Count which pipelines use it (cohesion)
- Per function: Identify how many "reasons to change" exist (SRP)

[Discoveries During Analysis]
- Initial: Classified checkQualityGateStatus as 5 change reasons
  (API URL, retry policy, HTTP client, JSON structure, logging)
- Review: Over-granular. Consolidated to 2 reasons (SonarQube API, polling/retry strategy)

- Initial: Used call counts as primary metric
- Review: High call counts ≠ high cohesion. 
  May indicate caller-side abstraction issues instead.
- Final: Pipeline coverage (how many pipelines) is the correct cohesion metric

[Cross-validation]
- Found inconsistency between design-smells-symptoms.md and software-smells-analysis.md
- Rigidity section listed 5 change triggers, but source had 7
- Corrected after verification
-->

[← Overview](../detailed-analysis.md) | [Software Smells →](02-software-smells-analysis.md)

# groovy/generalHelper.groovy - SRP Violation Analysis

> **"Kitchen Sink" File** - Actual cohesion only 19% compared to design intent (common function collection) (656 lines)

---

## 1. SRP Violation Analysis Criteria

- **generalHelper Design Intent**: Since Unity Helper and JS Helper exist separately, generalHelper is designed to "collect only functions commonly used across all pipelines"
- **Cohesion Analysis Criteria**: "Is it actually used in all pipelines?" = Cohesion aligned with design intent

### 1.1. Why This Criteria?

SRP asks "who requests changes to this code?" For a shared helper file, 
the answer should be "everyone equally." If only specific pipelines use 
a function, it belongs in that pipeline's dedicated helper, not here.

Call counts (how many times) don't matter for this judgment - 
only pipeline coverage (how many pipelines) does.

### 1.2. SOLID Principles References

#### Sources

1. **97 Things Every Programmer Should Know** (O'Reilly, 2010)
   - Chapter 76: "The Single Responsibility Principle" by Uncle Bob

2. **Agile Principles, Patterns, and Practices in C#** by Robert C. Martin (2006)
   - Chapter 8: "The Single-Responsibility Principle (SRP)"

---

## 2. Cohesion and Change Reasons per Function

| # | Function Name | DLX CI | DLX CD | JS CI | JS CD | Pipeline | Internal | Change Reason |
|---|--------|:------:|:------:|:-----:|:-----:|:--------:|:--------:|----------|
| 1 | `parseJson` | 2 | 2 | 2 | 2 | 2 | | When Jenkins build/stage result constants are added/changed |
| 2 | `logMessage` | | | | | | 16 | When logging output format/style changes (internal use) |
| 3 | `cloneOrUpdateRepo` | 1 | | 1 | | 1 | 1 | When Git CLI commands, repository cleanup policies change |
| 4 | `getDefaultBranch` | | | | | | 1 | When Git remote command output format changes (internal use) |
| 5 | `initializeEnvironment` | 1 | | 1 | | 1 | | **2 reasons**:<br>When Bitbucket status API changes<br>When environment variable setup method changes |
| 6 | `checkoutBranch` | 1 | 1 | 1 | 1 | 1 | 1 | When Git checkout/reset/clean workflow changes |
| 7 | `mergeBranchIfNeeded` | 1 | | 1 | | | | When Git merge strategy/workflow changes |
| 8 | `isBranchUpToDateWithRemote` | 1 | | 1 | | 1 | | When Git fetch/rev-parse commands change |
| 9 | `isBranchUpToDateWithMain` | | | | | | 1 | When Git merge-base command changes (internal use) |
| 10 | `tryMerge` | | | | | | 1 | When Git merge command/options change (internal use) |
| 11 | `getFullCommitHash` | 1 | 1 | 1 | 1 | 1 | | When Bitbucket API (Python script) interface changes |
| 12 | `getCurrentCommitHash` | | | | | | | When Git rev-parse command changes (**Dead Code**) |
| 13 | `sendBuildStatus` | 3 | 4 | 3 | 5 | 3 | 1 | When Bitbucket build status API spec changes |
| 14 | `parseTicketNumber` | | 1 | | | | 1 | When branch naming convention (ticket pattern) changes |
| 15 | `publishTestResultsHtmlToWebServer` | 1 | | 2 | | | | When web server path/permission policy, SSH settings change |
| 16 | `publishBuildResultsToWebServer` | 1 | | | | | | When web server deployment path structure changes |
| 17 | `cleanMergedBranchFromWebServer` | | 1 | | | | | When web server cleanup path policy changes |
| 18 | `cleanUpPRBranch` | | 1 | | | | | **2 reasons**:<br>When Linux package management method changes<br>When directory cleanup policy changes |
| 19 | `closeLogfiles` | | | | | | | When lsof output format, process termination method changes (**Dead Code**) |
| 20 | `checkQualityGateStatus` | | | 1 | 1 | 1 | | **2 reasons**:<br>When SonarQube API changes<br>When polling/retry strategy changes |
| 21 | `publishGroovyDocToWebServer` | | | | | 1 | | When GroovyDoc deployment path/permission policy changes |

> **Note on Call Counts**: 
> The numbers indicate how many times each function is called per pipeline. 
> High call counts (e.g., `sendBuildStatus`: 4 times in DLX CD) may suggest 
> insufficient abstraction in the **calling side** (pipeline files), 
> not in the helper itself. This is analyzed in the pipeline file analysis (04-08).

---

## 3. Module Level SRP Violation Analysis - Cohesion Analysis Results

- **100% Usage (4)**: `parseJson`, `checkoutBranch`, `getFullCommitHash`, `sendBuildStatus`
- **60% Usage (4)**: `cloneOrUpdateRepo`, `initializeEnvironment`, `isBranchUpToDateWithRemote`, `checkQualityGateStatus`
- **40% Usage (2)**: `mergeBranchIfNeeded`, `publishTestResultsHtmlToWebServer`
- **20% Usage (5)**: `publishBuildResultsToWebServer`, `cleanMergedBranchFromWebServer`, `cleanUpPRBranch`, `publishGroovyDocToWebServer`, `parseTicketNumber`
- **Dead Code (2)**: `getCurrentCommitHash`, `closeLogfiles`
- **Internal Use Only (4)**: `logMessage`, `getDefaultBranch`, `isBranchUpToDateWithMain`, `tryMerge`

> **SRP Violation**: Contrary to the design intent of "common function collection", only **4 out of 21 functions (19%) are 100% reused**. The remaining 81% are used only in specific pipelines.

---

## 4. Function Level SRP Violation Analysis - Functions with Multiple Change Reasons

<details markdown>
<summary>Multi-responsibility Function: <code>initializeEnvironment()</code> (2 change reasons)</summary>

```groovy
void initializeEnvironment(String workspace, String commitHash, String prBranch) {
    echo "Sending 'In Progress' status to Bitbucket..."
    sendBuildStatus(workspace, 'INPROGRESS', commitHash)  // Change reason 1: Bitbucket status API
    env.TICKET_NUMBER = parseTicketNumber(prBranch)       // Change reason 2: Environment variable setup
    env.FOLDER_NAME = "${JOB_NAME}".split('/').first()
}
```

**Change Reason Analysis:**
1. **When Bitbucket status API changes** (line 137): `sendBuildStatus()` call method
2. **When environment variable setup method changes** (lines 138-139): `TICKET_NUMBER`, `FOLDER_NAME` setup

</details>

<details markdown>
<summary>Multi-responsibility Function: <code>cleanUpPRBranch()</code> (2 change reasons)</summary>

```groovy
void cleanUpPRBranch(String prBranch) {
    // Change reason 1: find tool installation (Linux package management)
    def findPath = sh(script: 'command -v find', returnStdout: true).trim()
    if (!findPath) {
        echo "'find' directory searching tool is not found..."
        echo "Installing 'find' directory searching tool..."
        int installStatus = sh(script: 'sudo apt-get update && sudo apt-get install -y findutils', returnStatus: true)
        if (installStatus == 0 ) {
            echo "The 'findutils' package was installed successfully."
        } else {
            echo "Failed to install 'findutils'. Exit code: ${installStatus}"
            error "Installation failed with exit code: ${installStatus}"
        }
    }

    // Change reason 2: Directory cleanup policy
    def branchPaths = sh(script: "${findPath} ../ -type d -name \"${prBranch}\"", returnStdout: true).trim()
    if (!branchPaths.isEmpty()) {
        def paths = branchPaths.split('\n')
        paths.each { branchPath ->
            echo "Deleting Branch Path: ${branchPath}"
            sh(script: "rm -r -f \"${branchPath}\"", returnStatus: true)
            // ...
        }
    }
}
```

**Change Reason Analysis:**
1. **When Linux package management method changes** (lines 403-414): `apt-get` -> other package manager
2. **When directory cleanup policy changes** (lines 417-442): Search path, deletion conditions

</details>

<details markdown>
<summary>Multi-responsibility Function: <code>checkQualityGateStatus()</code> (2 change reasons)</summary>

```groovy
Map checkQualityGateStatus(String projectKey, String adminToken) {
    // Change reason 1: SonarQube API (URL, auth, response structure)
    String buildStatusURL = "http://localhost:9000/sonarqube/api/ce/component?component=${projectKey}"
    String qualityGateResultURL = "http://localhost:9000/sonarqube/api/qualitygates/project_status?projectKey=${projectKey}"

    // Change reason 2: Polling/retry strategy
    int maxRetries = 5

    for (int retryCount = 1; retryCount <= maxRetries; retryCount++) {
        def process = buildStatusAPIcall.execute()
        process.waitFor()

        def buildStatus = new JsonSlurperClassic().parseText(buildStatusResponse)
        if (buildStatus?.queue?.size() > 0) {
            sleep(10)  // Change reason 2: Wait time
            continue
        }
        // ...
    }
}
```

**Change Reason Analysis:**
1. **When SonarQube API changes**: URL, auth method, response structure
2. **When polling/retry strategy changes**: Retry count, wait time, timeout

**Additional Code Smell**: Long Method (94 lines)

</details>

---

## Conclusion

> **SRP Violation**:
> - **Module Level**: Only 19% of functions are 100% reused compared to "common function collection" design intent
> - **Function Level**: 3 functions have multiple change reasons (`initializeEnvironment`(2), `cleanUpPRBranch`(2), `checkQualityGateStatus`(2))
> - 2 Dead Code functions found
> - **"Kitchen Sink" Anti-pattern**

### Next: Why Software Smells Analysis?

SRP analysis identified **what** violates design intent. The next document classifies these violations using industry-standard taxonomy (Fowler, Martin, Suryanarayana) to provide **shared vocabulary** for discussing the problems.

---

[← Overview](../detailed-analysis.md) | [Software Smells →](02-software-smells-analysis.md)
