<!--
Analysis Log:

[Why SRP for jsHelper?]
- SRP is an OOP principle (SOLID), but the core concept "one reason to change"
  applies to any code organization, not just classes
- Applied SRP at two levels: Module (file) and Function

[Starting Point]
- jsHelper's original design intent: "JS pipeline dedicated functions"
- If this intent is valid, all functions should be used in both JS CI and JS CD
- Hypothesis: Analyze per-function to measure actual cohesion vs design intent

[Analysis Approach]
- Per function: Count which pipelines use it (JS CI, JS CD)
- Per function: Identify how many "reasons to change" exist (SRP)

[Discoveries During Analysis]
- 50% of functions are used in only one pipeline (CI-only or CD-only)
- `logMessage` is an exact copy from generalHelper (DRY violation, not SRP)
- `installNpmInTestingDirs` has 3 distinct responsibilities mixed
-->

[← Overview](../detailed-analysis.md) | [Software Smells →](02-software-smells-analysis.md)

# groovy/jsHelper.groovy - SRP Violation Analysis

> **JS Pipeline Dedicated File** - CI/CD dedicated functions mixed (50% cohesion) (356 lines)

---

## 1. SRP Violation Analysis Criteria

- **jsHelper Design Intent**: A file that collects functions dedicated to JS pipelines (CI/CD)
- **Cohesion Analysis Criteria**: "Is it used in both JS CI and JS CD?" = Cohesion aligned with design intent

### 1.1. Why This Criteria?

SRP asks "who requests changes to this code?" For a JS-dedicated helper file,
the answer should be "both JS CI and JS CD equally." If only one pipeline uses
a function, it should be in that pipeline's code or a CI/CD-specific helper.

### 1.2. SOLID Principles References

#### Sources

1. **97 Things Every Programmer Should Know** (O'Reilly, 2010)
   - Chapter 76: "The Single Responsibility Principle" by Uncle Bob

2. **Agile Principles, Patterns, and Practices in C#** by Robert C. Martin (2006)
   - Chapter 8: "The Single-Responsibility Principle (SRP)"

---

## 2. Cohesion and Change Reasons per Function

| # | Function Name | JS CI | JS CD | Internal | Change Reason |
|---|---------------|:-----:|:-----:|:--------:|---------------|
| 1 | `logMessage` | | | 9 | When logging output format/style changes |
| 2 | `findTestingDirs` | 1 | 1 | | When directory scanning logic changes |
| 3 | `getPackageJsonVersion` | | 2 | | When package.json version extraction changes |
| 4 | `installNpmInTestingDirs` | 1 | 1 | | **3 reasons**:<br>When npm audit policy changes<br>When Python script interface changes<br>When npm install policy changes |
| 5 | `runUnitTestsInTestingDirs` | 1 | 1 | | When test execution process changes |
| 6 | `checkNodeVersion` | 1 | | | When Node.js version check logic changes |
| 7 | `runCommandReturnStatus` | | | 4 | When OS-specific command execution changes |
| 8 | `executeLintingInTestingDirs` | 1 | 1 | | When linting process changes |
| 9 | `versionCompare` | | 2 | 1 | When version comparison logic changes |
| 10 | `retrieveReportSummaryDirs` | 2 | | | When report file search logic changes |

> **Note on Call Counts**:
> Unlike generalHelper where we count cross-pipeline usage, jsHelper serves only 2 pipelines.
> The key metric is whether a function is used in both CI and CD.

---

## 3. Module Level SRP Violation Analysis - Cohesion Analysis Results

- **100% Usage (4)**: `findTestingDirs`, `installNpmInTestingDirs`, `runUnitTestsInTestingDirs`, `executeLintingInTestingDirs`
- **CD-only (2)**: `getPackageJsonVersion`, `versionCompare`
- **CI-only (2)**: `checkNodeVersion`, `retrieveReportSummaryDirs`
- **Internal Use (2)**: `logMessage`, `runCommandReturnStatus`

> **SRP Violation**: Meets design intent of JS-dedicated file, but **50% of external functions** are CI-only or CD-only (4 out of 8 external functions).

---

## 4. Function Level SRP Violation Analysis - Functions with Multiple Change Reasons

<details markdown>
<summary>Multi-responsibility Function: <code>installNpmInTestingDirs()</code> (3 change reasons)</summary>

```groovy
void installNpmInTestingDirs(String testingDirs) {
    if (testingDirs == null || testingDirs.isEmpty()) {
        echo "Testing directories don't exist."
        return
    }
    List<String> testDirs = testingDirs.split(',') as List<String>
    for (String dirPath : testDirs) {
        File dir = new File(dirPath)
        if (!dir.exists() || !dir.isDirectory()) {
            echo "Directory does not exist: ${dirPath}. Skipping..."
            continue
        }

        // Change reason 1: npm audit policy
        String npmAuditCommand = "cd '${dirPath}' && npm audit --json > audit-report.json"
        echo "Running command: ${npmAuditCommand}"
        int exitCode = runCommandReturnStatus(npmAuditCommand)
        if (exitCode != 0) {
            echo "npm audit failed in directory: ${dirPath} with exit code: ${exitCode}. Proceeding with caution."
        }

        // Change reason 2: Python script interface
        File reportFile = new File("${dirPath}/audit-report.json")
        if (reportFile.exists()) {
            String pythonCommand = """python '${WORKSPACE}/python/npm_audit.py'
            '${COMMIT_HASH}' '${dirPath}/audit-report.json'
            """
            exitCode = sh(script: pythonCommand, returnStatus: true)
            // ...
        }

        // Change reason 3: npm install command
        String npmCommand = "cd '${dirPath}' && npm install"
        exitCode = runCommandReturnStatus(npmCommand)
        // ...
    }
}
```

**Change Reason Analysis:**
1. **When npm audit policy changes**: audit command, options, report format
2. **When Python script interface changes**: `npm_audit.py` argument format
3. **When npm install command changes**: install options, error handling

</details>

---

## Conclusion

> **SRP Violation**:
> - **Module Level**: JS-dedicated but CI/CD-specific functions mixed (50% cohesion for external functions)
> - **Function Level**: 1 function has multiple change reasons (`installNpmInTestingDirs`(3))
> - `logMessage()` is an **exact copy** of generalHelper (DRY violation)

### Next: Why Software Smells Analysis?

SRP analysis identified **what** violates design intent. The next document classifies these violations using industry-standard taxonomy (Fowler, Suryanarayana) to provide **shared vocabulary** for discussing the problems.

---

[← Overview](../detailed-analysis.md) | [Software Smells →](02-software-smells-analysis.md)
