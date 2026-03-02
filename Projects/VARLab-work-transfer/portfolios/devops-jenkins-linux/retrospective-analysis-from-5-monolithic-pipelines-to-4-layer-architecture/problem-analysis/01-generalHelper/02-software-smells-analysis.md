<!--
Analysis Log:

[Why Software Smells for Jenkins Pipeline?]
- Software Smells provide industry-standard vocabulary (Fowler, Suryanarayana) 
  to classify problems identified in SRP analysis
- Applied at multiple levels: Code Smells → Design Smells → Architecture Smells

[Relationship to SRP Analysis]
- SRP identified: 8 domains mixed, 19% cohesion, 3 multi-responsibility functions
- This document classifies those findings using established taxonomy

[Discoveries During Analysis]
- Initial: Classified "Git CLI change → 8 functions" as Shotgun Surgery
- Review: This is within single file, not cross-file
- Correction: Shotgun Surgery applies to helper function changes affecting 5 pipeline files
- Evidence: SRP Analysis table shows sendBuildStatus called 18 times across 5 pipelines

[Cross-validation with SRP Analysis]
- Used pipeline call counts from SRP Analysis Section 2 as Shotgun Surgery evidence
- Divergent Change aligns with "8 domains" finding from SRP Analysis
-->

[← SRP Analysis](01-srp-violation-analysis.md)

# groovy/generalHelper.groovy - Software Smells Analysis

> Classification based on industry-standard taxonomy: Code Smells (Fowler) → Design Smells (Suryanarayana)
>
> **Domain Classification**: 7 domains, 21 functions. See [Domain Mapping](../pipeline-sequence-diagrams/domain-mapping.md#21-generalhelpergroovy-7-domains--1-mixed-21-functions)

---

## 1. Code Smells

> **Source**: Fowler, M. (1999). *Refactoring: Improving the Design of Existing Code*
>
> **Applicable Categories**: Fowler defines 5 categories of Code Smells: Bloaters, Object-Orientation Abusers, Change Preventers, Dispensables, and Couplers. Since Jenkins Pipeline Helper files are **procedural scripts** (not OOP classes), only the following categories are applicable:
>
> | Category | Applicable | Applied Smells |
> |----------|:----------:|----------------|
> | Bloaters | ✓ | Long Method, Large File, Primitive Obsession, Data Clumps |
> | Change Preventers | ✓ | Divergent Change, Shotgun Surgery |
> | Dispensables | ✓ | Dead Code, Duplicated Code |
> | Object-Orientation Abusers | ✗ | (not applicable - no inheritance/polymorphism) |
> | Couplers | ✗ | (not applicable - no class relationships) |

### 1.1 Change Preventers (with Severity Criteria)

#### Severity Criteria

| Metric | Low | Medium | High |
|--------|-----|--------|------|
| Impact Scope | 1-2 pipelines | 3-4 pipelines | 5 pipelines |
| Modification Cost | 1-5 locations | 6-10 locations | 11+ locations |

> #### Divergent Change (Scope: File Level)
>
> <details markdown>
> <summary>Click to see details</summary>
>
> **Definition**: A single class/file is frequently changed for several different reasons
>
> **Scope**: File Level
>
> **Divergent Change Cases in generalHelper.groovy**:
>
> | Change Reason | Affected Functions | Count |
> |---------------|-------------------|:-----:|
> | Git policy change | `cloneOrUpdateRepo`, `getDefaultBranch`, `checkoutBranch`, `mergeBranchIfNeeded`, `isBranchUpToDateWithRemote`, `isBranchUpToDateWithMain`, `tryMerge`, `getCurrentCommitHash` | 8 |
> | Bitbucket API change | `getFullCommitHash`, `sendBuildStatus` | 2 |
> | Web Server structure change | `publishTestResultsHtmlToWebServer`, `publishBuildResultsToWebServer`, `cleanMergedBranchFromWebServer`, `publishGroovyDocToWebServer` | 4 |
> | SonarQube settings change | `checkQualityGateStatus` | 1 |
> | Parsing rule change | `parseJson`, `parseTicketNumber` | 2 |
> | File System policy change | `cleanUpPRBranch` | 1 |
> | Logging policy change | `logMessage`, `closeLogfiles` | 2 |
>
> **Severity Evidence**:
> - **Impact Scope**: High (5 pipelines depend on this file)
> - **Modification Cost**: High (7 different change reasons in single file)
>
> **Related**: Domain mapping identified 7 domains in this file. See [Domain Mapping](../pipeline-sequence-diagrams/domain-mapping.md)
>
> </details>

> #### Shotgun Surgery (Scope: Cross-file/System Level)
>
> <details markdown>
> <summary>Click to see details</summary>
>
> **Definition**: A single change requires modifications to multiple files
>
> **Scope**: Cross-file/System Level
>
> **Shotgun Surgery Cases in generalHelper.groovy**:
>
> | Function | DLX CI | DLX CD | JS CI | JS CD | Jenkins CI | Total Locations |
> |----------|:------:|:------:|:-----:|:-----:|:----------:|:---------------:|
> | `sendBuildStatus` | 3 | 4 | 3 | 5 | 3 | 18 |
> | `parseJson` | 2 | 2 | 2 | 2 | 2 | 10 |
> | `checkoutBranch` | 1 | 1 | 1 | 1 | 1 | 5 + 1 internal |
> | `getFullCommitHash` | 1 | 1 | 1 | 1 | 1 | 5 |
>
> **Severity Evidence**:
> - **Impact Scope**: High (5 pipeline files depend on this helper)
> - **Modification Cost**: High (18 locations for `sendBuildStatus`)
>
> **Related**: Data from SRP Analysis Section 2 (Cohesion Table)
>
> </details>

### 1.2 Other Code Smells (Evidence Only)

#### Bloaters

| Smell | Evidence |
|-------|----------|
| Long Method | `checkQualityGateStatus` (94 lines), `closeLogfiles` (45 lines), `cloneOrUpdateRepo` (42 lines), `cleanUpPRBranch` (40 lines) |
| Large File | 656 lines, 21 functions, 7 domains |
| Primitive Obsession | `"/var/www/html"` (11x), `env.SSH_KEY` (10x), `env.DLX_WEB_HOST_URL` (10x), `"vconadmin:vconadmin"` (3x) |
| Data Clumps | `remoteProjectFolderName` (14x), `ticketNumber` (12x), `workspace` (11x), `commitHash` (8x) |

#### Dispensables

| Smell | Evidence |
|-------|----------|
| Dead Code | `getCurrentCommitHash`, `closeLogfiles` (2 functions, 53 lines total) |
| Duplicated Code | SSH command pattern (6x), SCP pattern (4x), chmod/chown pattern (4x), `git fetch origin` (3x) |

---

## 2. Design Smells (Principle-Based)

> **Source**: Suryanarayana, G. et al. (2014). *Refactoring for Software Design Smells*
>
> **Applicable Categories**: Suryanarayana defines 4 categories based on OO design principles: Abstraction, Encapsulation, Modularization, and Hierarchy. Since Jenkins Pipeline Helper files are **procedural scripts** (not OOP classes), only the following categories are applicable:
>
> | Category | Applicable | Applied Smells |
> |----------|:----------:|----------------|
> | Abstraction | ✓ | Multifaceted Abstraction, Missing Abstraction, Unutilized Abstraction |
> | Encapsulation | △ | Missing Encapsulation |
> | Modularization | ✓ | Insufficient Modularization, Hub-like Modularization |
> | Hierarchy | ✗ | (not applicable - no inheritance) |
>
> **Note**: Incomplete Abstraction is not applied because determining "expected operations" requires design specification that does not exist.

### 2.1 Abstraction Smells

> #### Multifaceted Abstraction
>
> <details markdown>
> <summary>Click to see details</summary>
>
> **Definition**: "An abstraction has multiple responsibilities assigned to it"
>
> **Evidence**:
> - 7 responsibilities in single file: Git, Bitbucket, Web Server, SonarQube, Parsing, File System, Logging
> - 21 functions across 7 different responsibilities
>
> </details>

> #### Missing Abstraction
>
> <details markdown>
> <summary>Click to see details</summary>
>
> **Definition**: "Clumps of data or encoded strings are used instead of creating a class or an interface"
>
> **Evidence**:
>
> | Concept | Current State | Occurrences |
> |---------|---------------|:-----------:|
> | Web server path | `"/var/www/html"` hardcoded | 11 |
> | SSH key | `env.SSH_KEY` scattered | 10 |
> | Web host URL | `env.DLX_WEB_HOST_URL` scattered | 10 |
> | User account | `"vconadmin:vconadmin"` hardcoded | 3 |
> | SonarQube URL | `"http://localhost:9000/sonarqube"` hardcoded | 2 |
>
> </details>

> #### Unutilized Abstraction
>
> <details markdown>
> <summary>Click to see details</summary>
>
> **Definition**: "An abstraction is left unused (either not directly used or not reachable)"
>
> **Evidence**:
>
> | Function | Lines | Status |
> |----------|:-----:|--------|
> | `getCurrentCommitHash` | 8 | Declared but never called by any pipeline |
> | `closeLogfiles` | 45 | Declared but never called by any pipeline |
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
> | SSH command execution | 6 | 4 Web Server functions |
> | SCP file transfer | 4 | 4 Web Server functions |
> | chmod/chown permission | 4 | 4 Web Server functions |
> | `git fetch origin` | 3 | `cloneOrUpdateRepo`, `mergeBranchIfNeeded`, `isBranchUpToDateWithRemote` |
>
> </details>

### 2.3 Modularization Smells

> #### Insufficient Modularization
>
> <details markdown>
> <summary>Click to see details</summary>
>
> **Definition**: "An abstraction that has not been completely decomposed, and a further decomposition could reduce its size, implementation complexity, or both."
>
> **Evidence**:
>
> | Metric | Value |
> |--------|:-----:|
> | File size | 656 lines |
> | Function count | 21 |
> | Domain count | 7 |
>
> </details>

> #### Hub-like Modularization
>
> <details markdown>
> <summary>Click to see details</summary>
>
> **Definition**: "An abstraction has dependencies (incoming and outgoing) with a large number of other abstractions."
>
> **Evidence**:
>
> | Direction | Dependency | Count |
> |-----------|------------|:-----:|
> | Incoming | Pipeline files that `load()` this helper | 5 |
> | Outgoing | Git CLI calls | 18 |
> | Outgoing | Linux command calls | 11 |
> | Outgoing | SSH calls | 6 |
> | Outgoing | SCP calls | 4 |
> | Outgoing | Python script calls | 2 |
> | Outgoing | SonarQube API calls (curl) | 2 |
>
> </details>

---

## Conclusion

> **Software Smells Summary**:
> - **Code Level**: Divergent Change (7 change reasons), Shotgun Surgery (18+ locations across 5 files)
> - **Design Level**: 7 domains not modularized, primitive strings instead of abstractions, 2 unutilized functions

---

[← SRP Analysis](01-srp-violation-analysis.md)