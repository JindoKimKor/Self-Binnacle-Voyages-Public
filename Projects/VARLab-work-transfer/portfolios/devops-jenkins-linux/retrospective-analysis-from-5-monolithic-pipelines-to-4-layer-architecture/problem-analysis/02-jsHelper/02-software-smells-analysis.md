<!--
Analysis Log:

[Why Software Smells for unityHelper?]
- Software Smells provide industry-standard vocabulary (Fowler, Suryanarayana)
  to classify problems identified in SRP analysis
- Applied at multiple levels: Code Smells → Design Smells

[Relationship to SRP Analysis]
- SRP identified: 50% cohesion, 2 multi-responsibility functions, Shotgun Surgery risk
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

# groovy/jsHelper.groovy - Software Smells Analysis

> Classification based on industry-standard taxonomy: Code Smells (Fowler) → Design Smells (Suryanarayana)
>
> **Domain Classification**: 4 domains, 10 functions. See [Domain Mapping](../pipeline-sequence-diagrams/domain-mapping.md#22-jshelpergroovy-4-domains-10-functions)

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


> #### Shotgun Surgery (Scope: Cross-file)
>
> <details markdown>
> <summary>Click to see details</summary>
>
> **Definition**: "A single change requires modifications to multiple files"
>
> **Shotgun Surgery Cases in jsHelper.groovy**:
>
> | Function | JS CI | JS CD | Total Locations |
> |----------|:-----:|:-----:|:---------------:|
> | `findTestingDirs` | 1 | 1 | 2 |
> | `installNpmInTestingDirs` | 1 | 1 | 2 |
> | `runUnitTestsInTestingDirs` | 1 | 1 | 2 |
> | `executeLintingInTestingDirs` | 1 | 1 | 2 |
>
> **Severity Evidence**:
> - **Impact Scope**: Medium (2 pipelines depend on this helper)
> - **Modification Cost**: Low (maximum 2 locations per function)
>
> </details>

### 1.2 Other Code Smells (Evidence Only)

#### Bloaters

| Smell | Evidence |
|-------|----------|
| Long Method | `installNpmInTestingDirs` (52 lines, 3 responsibilities), `versionCompare` (45 lines) |
| Primitive Obsession | `"Testing directories don't exist."` (3x), `"Directory does not exist: ${dirPath}. Skipping..."` (2x) |
| Data Clumps | `(String testingDirs, boolean deploymentBuild)` parameter pair in 2 functions |

#### Dispensables

| Smell | Evidence |
|-------|----------|
| Duplicated Code | `logMessage` exact copy from generalHelper |
| Duplicated Code | `testingDirs.split(',') as List<String>` pattern (3x) |
| Duplicated Code | Directory existence validation pattern (2x) |

---

## 2. Design Smells (Principle-Based)

> **Source**: Suryanarayana, G. et al. (2014). *Refactoring for Software Design Smells*
>
> **Applicable Categories**: Since Jenkins Pipeline Helper files are **procedural scripts**, only the following categories are applicable:
>
> | Category | Applicable | Applied Smells |
> |----------|:----------:|----------------|
> | Abstraction | ✓ | Multifaceted Abstraction |
> | Encapsulation | ✓ | Missing Encapsulation |
> | Modularization | ✗ | (file size 356 lines is acceptable) |
> | Hierarchy | ✗ | (no conditional branch patterns like unityHelper) |

### 2.1 Abstraction Smells

> #### Multifaceted Abstraction
>
> <details markdown>
> <summary>Click to see details</summary>
>
> **Definition**: "An abstraction has multiple responsibilities assigned to it"
>
> **Evidence**:
> - 4 domains in single file: Node.js/npm, File System, Utility, Logging
> - 10 functions across 4 different domains
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
> **Evidence**:
>
> | Pattern | Occurrences | Affected Functions |
> |---------|:-----------:|-------------------|
> | `testingDirs.split(',') as List<String>` | 3 | `installNpmInTestingDirs`, `runUnitTestsInTestingDirs`, `executeLintingInTestingDirs` |
> | Directory existence validation | 2 | `installNpmInTestingDirs`, `runUnitTestsInTestingDirs` |
>
> </details>

---

## Conclusion

> **Software Smells Summary**:
> - **Code Level**: Shotgun Surgery (Low - max 2 locations), Long Method (2 functions), Duplicated Code (`logMessage` copy, validation patterns)
> - **Design Level**: 4 domains mixed, repeated patterns not encapsulated

---

[← SRP Analysis](01-srp-violation-analysis.md)