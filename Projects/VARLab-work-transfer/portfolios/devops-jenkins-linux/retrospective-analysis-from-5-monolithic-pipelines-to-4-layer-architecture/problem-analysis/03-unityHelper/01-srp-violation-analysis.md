<!--
Analysis Log:

[Why SRP for unityHelper?]
- SRP is an OOP principle (SOLID), but the core concept "one reason to change"
  applies to any code organization, not just classes
- Applied SRP at two levels: Module (file) and Function

[Starting Point]
- unityHelper's original design intent: "DLX (Unity) pipeline dedicated functions"
- If this intent is valid, all functions should be used in both DLX CI and DLX CD
- Hypothesis: Analyze per-function to measure actual cohesion vs design intent

[Analysis Approach]
- Per function: Count which pipelines use it (DLX CI, DLX CD)
- Per function: Identify how many "reasons to change" exist (SRP)

[Discoveries During Analysis]
- 4 Code Coverage functions are CI-only (not needed in CD)
- `runUnityBatchMode` has 7+ change reasons (Long Method + Shotgun Surgery)
- Stage-specific conditional branches create high modification cost
-->

[← Overview](../detailed-analysis.md) | [Software Smells →](02-software-smells-analysis.md)

# groovy/unityHelper.groovy - SRP Violation Analysis

> **DLX Pipeline Dedicated File** - CI-only functions mixed (50% cohesion) (357 lines)

---

## 1. SRP Violation Analysis Criteria

- **unityHelper Design Intent**: A file that collects functions dedicated to DLX (Unity) pipelines (CI/CD)
- **Cohesion Analysis Criteria**: "Is it used in both DLX CI and DLX CD?" = Cohesion aligned with design intent

### 1.1. Why This Criteria?

SRP asks "who requests changes to this code?" For a DLX-dedicated helper file,
the answer should be "both DLX CI and DLX CD equally." If only one pipeline uses
a function (like Code Coverage), it should be in CI-specific code.

### 1.2. SOLID Principles References

#### Sources

1. **97 Things Every Programmer Should Know** (O'Reilly, 2010)
   - Chapter 76: "The Single Responsibility Principle" by Uncle Bob

2. **Agile Principles, Patterns, and Practices in C#** by Robert C. Martin (2006)
   - Chapter 8: "The Single-Responsibility Principle (SRP)"

---

## 2. Cohesion and Change Reasons per Function

| # | Function Name | DLX CI | DLX CD | Internal | Change Reason |
|---|---------------|:------:|:------:|:--------:|---------------|
| 1 | `sendTestReport` | 1 | | | When Bitbucket test report Python script interface changes |
| 2 | `getUnityExecutable` | 2 | 1 | | **2 reasons**:<br>When Unity version Python script changes<br>When Unity Hub CLI installation changes |
| 3 | `runUnityStage` | 5 | 4 | | When Unity batch mode error handling policy changes |
| 4 | `runUnityBatchMode` | | | 2 | **7+ reasons**:<br>When log path rules change<br>When test platform options change<br>When coverage options change<br>When Stage-specific args change<br>When Unity CLI options change<br>When xvfb-run settings change<br>When new Stage added |
| 5 | `getCodeCoverageArguments` | | | 2 | When Unity Code Coverage package options change |
| 6 | `fetCoverageOptionsKeyAndValue` | | | 2 | When Stage-specific coverage option rules change |
| 7 | `loadPathsToExclude` | | | 2 | When Unity Code Coverage Settings.json structure changes |
| 8 | `buildCoverageOptions` | | | 2 | When coverage options string format changes |

> **Note on Call Counts**:
> Unlike generalHelper where we count cross-pipeline usage, unityHelper serves only 2 pipelines (DLX CI, DLX CD).
> The key metric is whether a function is used in both CI and CD.

---

## 3. Module Level SRP Violation Analysis - Cohesion Analysis Results

- **100% Usage (2)**: `getUnityExecutable`, `runUnityStage`
- **CI-only (1)**: `sendTestReport`
- **Internal Use (5)**: `runUnityBatchMode`, `getCodeCoverageArguments`, `fetCoverageOptionsKeyAndValue`, `loadPathsToExclude`, `buildCoverageOptions`

> **SRP Violation**: DLX-dedicated but only **2 out of 8 functions (25%)** are used in both pipelines. 5 functions are internal-only, 1 is CI-only.

---

## 4. Function Level SRP Violation Analysis - Functions with Multiple Change Reasons

<details markdown>
<summary>Multi-responsibility Function: <code>getUnityExecutable()</code> (2 change reasons)</summary>

```groovy
String getUnityExecutable(workspace, projectDir) {
    try {
        // Change reason 1: Unity version Python script
        def unityExecutable = sh(script: "python '${workspace}/python/get_unity_version.py' '${projectDir}' executable-path",
        returnStdout: true).trim()

        if (!fileExists(unityExecutable)) {
            def version = sh(script: "python '${workspace}/python/get_unity_version.py' '${projectDir}' version",
             returnStdout: true).trim()
            def revision = sh(script: "python '${workspace}/python/get_unity_version.py' '${projectDir}' revision",
             returnStdout: true).trim()

            // Change reason 2: Unity Hub CLI installation command
            echo "Unity Editor version ${version} not found. Attempting installation..."
            def installCommand = """\"C:\\Program Files\\Unity Hub\\Unity Hub.exe\" \\
            -- --headless install \\
            --version ${version} \\
            --changeset ${revision}"""
            def exitCode = sh(script: installCommand, returnStatus: true)
            // ...
        }
        return unityExecutable
    } catch (Exception e) {
        error("An error occurred while retrieving or installing Unity executable: ${e.getMessage()}")
    }
}
```

**Change Reason Analysis:**
1. **When Unity version Python script changes**: `get_unity_version.py` arguments/output format
2. **When Unity Hub CLI installation command changes**: Unity Hub path, CLI options, module installation

</details>

<details markdown>
<summary>Multi-responsibility Function: <code>runUnityBatchMode()</code> (7+ change reasons)</summary>

This function has 126 lines with 7 distinct responsibilities:

| # | Responsibility | Location | Change Trigger |
|---|----------------|----------|----------------|
| 1 | Log path setup | `setLogFilePathAndUrl` closure | Stage-specific log path rules |
| 2 | Test arguments | `getTestRunArgs` closure | Test platform options |
| 3 | Additional arguments | `getAdditionalArgs` closure | WebGL/Rider specific args |
| 4 | Base command | Lines 203-206 | Unity CLI options |
| 5 | Coverage arguments | Lines 209-213 | Code Coverage package |
| 6 | Graphics options | Lines 229-231 | xvfb-run settings |
| 7 | New Stage support | All conditionals | Every new Stage type |

**Shotgun Surgery Risk**: Adding new Stage "Android" requires modifying **7 locations** simultaneously.

</details>

---

## Conclusion

> **SRP Violation**:
> - **Module Level**: DLX-dedicated but only 25% cohesion (2 out of 8 functions used in both pipelines). 5 functions are internal-only, 1 is CI-only.
> - **Function Level**: 2 functions have multiple change reasons (`getUnityExecutable`(2), `runUnityBatchMode`(7+))
> - `runUnityBatchMode` is a **Long Method** (126 lines) with **Shotgun Surgery** risk (7 locations when adding Stage)

### Next: Why Software Smells Analysis?

SRP analysis identified **what** violates design intent. The next document classifies these violations using industry-standard taxonomy (Fowler, Suryanarayana) to provide **shared vocabulary** for discussing the problems.

---

[← Overview](../detailed-analysis.md) | [Software Smells →](02-software-smells-analysis.md)
