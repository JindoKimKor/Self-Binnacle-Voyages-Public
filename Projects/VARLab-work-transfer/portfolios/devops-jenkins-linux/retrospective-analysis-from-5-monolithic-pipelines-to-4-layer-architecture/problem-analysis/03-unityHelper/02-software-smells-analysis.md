<!--
Analysis Log:

[Why Software Smells for unityHelper?]
- Software Smells provide industry-standard vocabulary (Fowler, Suryanarayana)
  to classify problems identified in SRP analysis
- Applied at multiple levels: Code Smells → Design Smells

[Relationship to SRP Analysis]
- SRP identified: 25% cohesion, 2 multi-responsibility functions, Shotgun Surgery risk
- This document classifies those findings using established taxonomy

[Discoveries During Analysis]
- Stage-specific conditional branches = Missing Hierarchy (Strategy pattern needed)
- 7 locations need modification when adding Stage = High Shotgun Surgery
- runUnityBatchMode 126 lines = Long Method with 7 responsibilities

[Procedural Code Considerations]
- Jenkins Pipeline Helper is procedural (not OOP)
- However, Missing Hierarchy is applicable here because Stage-specific logic
  could benefit from Strategy pattern even in procedural code
-->

[← SRP Analysis](01-srp-violation-analysis.md)

# groovy/unityHelper.groovy - Software Smells Analysis

> Classification based on industry-standard taxonomy: Code Smells (Fowler) → Design Smells (Suryanarayana)
>
> **Domain Classification**: 3 domains, 8 functions. See [Domain Mapping](../pipeline-sequence-diagrams/domain-mapping.md#23-unityhelpergroovy-3-domains-8-functions)

---

## 1. Code Smells

> **Source**: Fowler, M. (1999). *Refactoring: Improving the Design of Existing Code*
>
> **Applicable Categories**: Since Jenkins Pipeline Helper files are **procedural scripts**, only the following categories are applicable:
>
> | Category | Applicable | Applied Smells |
> |----------|:----------:|----------------|
> | Bloaters | ✓ | Long Method, Switch Statements |
> | Change Preventers | ✓ | Divergent Change, Shotgun Surgery |
> | Dispensables | ✗ | (no Dead Code or Duplicated Code found) |
> | Object-Orientation Abusers | ✗ | (not applicable - no inheritance/polymorphism) |
> | Couplers | ✗ | (not applicable - no class relationships) |

### 1.1 Change Preventers (with Severity Criteria)

#### Severity Criteria

| Metric | Low | Medium | High |
|--------|-----|--------|------|
| Impact Scope | 1 pipeline | 2 pipelines | - |
| Modification Cost | 1-2 locations | 3-5 locations | 6+ locations |

> **Note**: unityHelper serves only 2 pipelines (DLX CI, DLX CD), so Impact Scope is capped at Medium.

> #### Divergent Change (Scope: File Level)
>
> <details markdown>
> <summary>Click to see details</summary>
>
> **Definition**: "A single class/file is frequently changed for several different reasons"
>
> **Divergent Change Cases in unityHelper.groovy**:
>
> | Change Reason | Affected Functions | Count |
> |---------------|-------------------|:-----:|
> | Unity batch mode CLI change | `runUnityBatchMode`, `getCodeCoverageArguments`, `fetCoverageOptionsKeyAndValue`, `buildCoverageOptions` | 4 |
> | Python script interface change | `sendTestReport`, `getUnityExecutable` | 2 |
> | Bitbucket report format change | `sendTestReport` | 1 |
> | Unity Code Coverage settings change | `loadPathsToExclude`, `getCodeCoverageArguments` | 2 |
>
> **Severity Evidence**:
> - **Impact Scope**: Medium (2 pipelines depend on this file)
> - **Modification Cost**: Medium (4 different change reasons in single file)
>
> </details>

> #### Shotgun Surgery
>
> <details markdown>
> <summary>Click to see details</summary>
>
> **Definition**: "A single change requires modifications to multiple locations"
>
> **Cross-file (helper function signature change)**:
>
> | Function | DLX CI | DLX CD | Total Locations |
> |----------|:------:|:------:|:---------------:|
> | `runUnityStage` | 5 | 4 | 9 |
> | `getUnityExecutable` | 2 | 1 | 3 |
>
> **Within-file (adding new Stage)**:
>
> | # | Location | Change Required |
> |---|----------|-----------------|
> | 1 | Stage constant definition | Add `this.ANDROID = 'Android'` |
> | 2 | `setLogFilePathAndUrl` mapping | Add `(ANDROID): [path: ..., url: ...]` |
> | 3 | `getTestRunArgs` condition | Decide whether to include Android |
> | 4 | `getCodeCoverageArguments` condition | Decide whether to include Android |
> | 5 | `getAdditionalArgs` mapping | Add `Android: '...'` |
> | 6 | Command assembly branch | Add else if |
> | 7 | Graphics/quit options | Add Android condition |
>
> **Severity Evidence**:
> - **Impact Scope**: Medium (2 pipelines)
> - **Modification Cost**: High (9 cross-file + 7 within-file)
>
> </details>

### 1.2 Other Code Smells (Evidence Only)

#### Bloaters

| Smell | Evidence |
|-------|----------|
| Long Method | `runUnityBatchMode` (126 lines, 7 responsibilities) |
| Switch Statements | Stage-specific conditionals repeated in 9 locations |

> <details markdown>
> <summary>Switch Statements 9 locations</summary>
>
> | # | Location | Code | Line |
> |---|----------|------|:----:|
> | 1 | Test arguments | `[EDIT_MODE, PLAY_MODE].contains(stageName)` | 209 |
> | 2 | Coverage arguments | `[EDIT_MODE, PLAY_MODE, COVERAGE].contains(stageName)` | 212 |
> | 3 | Additional arguments | `[WEBGL, RIDER].contains(stageName)` | 216 |
> | 4 | Command assembly (EditMode/PlayMode) | `if ([EDIT_MODE, PLAY_MODE].contains(stageName))` | 220 |
> | 5 | Command assembly (Coverage) | `else if (stageName == COVERAGE)` | 222 |
> | 6 | Command assembly (WebGL/Rider) | `else if ([WEBGL, RIDER].contains(stageName))` | 224 |
> | 7 | Graphics options | `(stageName != WEBGL && stageName != PLAY_MODE)` | 229 |
> | 8 | Quit options | `(stageName != PLAY_MODE && stageName != EDIT_MODE)` | 233 |
> | 9 | Coverage options | `if ([EDIT_MODE, PLAY_MODE].contains(stageName))` | 303 |
>
> </details>

---

## 2. Design Smells (Principle-Based)

> **Source**: Suryanarayana, G. et al. (2014). *Refactoring for Software Design Smells*
>
> **Applicable Categories**: Since Jenkins Pipeline Helper files are **procedural scripts**, the following categories are applicable:
>
> | Category | Applicable | Applied Smells |
> |----------|:----------:|----------------|
> | Abstraction | ✓ | Multifaceted Abstraction |
> | Encapsulation | ✓ | Missing Encapsulation |
> | Modularization | ✗ | (file size 357 lines is acceptable) |
> | Hierarchy | ✓ | Missing Hierarchy (Strategy pattern applicable) |

### 2.1 Abstraction Smells

> #### Multifaceted Abstraction
>
> <details markdown>
> <summary>Click to see details</summary>
>
> **Definition**: "An abstraction has multiple responsibilities assigned to it"
>
> **Evidence**:
> - 3 domains in single file: Unity CLI (6), Unity Installation (1), Bitbucket (1)
> - 8 functions across 3 different domains
>
> </details>

### 2.2 Encapsulation Smells

> #### Missing Encapsulation
>
> <details markdown>
> <summary>Click to see details</summary>
>
> **Definition**: "The encapsulation of implementation variations in a type is missing"
>
> **Evidence: Stage-specific conditional branches scattered**:
>
> | Location | Stage Logic | Lines |
> |----------|-------------|-------|
> | Log path mapping | `Map logConfig = [(EDIT_MODE): [...], ...]` | 139-160 |
> | Test arguments | `[EDIT_MODE, PLAY_MODE].contains(stageName)` | 209 |
> | Coverage arguments | `[EDIT_MODE, PLAY_MODE, COVERAGE].contains(stageName)` | 212 |
> | Additional arguments | `[WEBGL, RIDER].contains(stageName)` | 216 |
> | Command assembly | `if ([EDIT_MODE, PLAY_MODE].contains(stageName)) {...}` | 220-226 |
> | Graphics options | `(stageName != WEBGL && stageName != PLAY_MODE)` | 229-233 |
> | Coverage options | `if ([EDIT_MODE, PLAY_MODE].contains(stageName)) {...}` | 303-310 |
>
> **Impact**: Adding new Stage "Android" requires modifying all 7 locations
>
> </details>

### 2.3 Hierarchy Smells

> #### Missing Hierarchy
>
> <details markdown>
> <summary>Click to see details</summary>
>
> **Definition**: "Conditional logic is used instead of subclasses or delegation"
>
> **Evidence**: Stage-specific branches can be replaced with Strategy pattern:
>
> | Current Branch Pattern | Strategy Replacement |
> |------------------------|----------------------|
> | `[EDIT_MODE, PLAY_MODE].contains(stageName)` | `stage.requiresTestRun()` |
> | `[EDIT_MODE, PLAY_MODE, COVERAGE].contains(stageName)` | `stage.requiresCoverage()` |
> | `[WEBGL, RIDER].contains(stageName)` | `stage.getAdditionalArgs()` |
> | `stageName != WEBGL && stageName != PLAY_MODE` | `stage.requiresNographics()` |
> | `stageName != PLAY_MODE && stageName != EDIT_MODE` | `stage.requiresQuit()` |
>
> </details>

---

## Conclusion

> **Software Smells Summary**:
> - **Code Level**: Divergent Change (4 change reasons), Shotgun Surgery (9 cross-file + 7 within-file), Long Method (126 lines, 7 responsibilities), Switch Statements (9 locations)
> - **Design Level**: 3 domains mixed, Stage-specific logic not encapsulated, Missing Hierarchy (Strategy pattern applicable)

---

[← SRP Analysis](01-srp-violation-analysis.md)