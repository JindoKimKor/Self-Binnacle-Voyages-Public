[← SRP Analysis](01-srp-violation-analysis.md)

# JsJenkins/Jenkinsfile - Software Smells Analysis

> Classification based on industry-standard taxonomy: Code Smells (Fowler) → Design Smells (Suryanarayana)
>
> **Inline Code Analysis**: 9 inline codes across 3 stages. See [SRP Violation Analysis](01-srp-violation-analysis.md)

---

## 1. Code Smells

> **Source**: Fowler, M. (1999). *Refactoring: Improving the Design of Existing Code*
>
> **Applicable Categories**: Since Jenkinsfile is an **orchestration script**, only the following categories are applicable:
>
> | Category | Applicable | Applied Smells |
> |----------|:----------:|----------------|
> | Bloaters | ✓ | Long Method, Primitive Obsession |
> | Object-Orientation Abusers | ✗ | (not applicable - no OOP) |
> | Change Preventers | ✓ | Divergent Change, Shotgun Surgery |
> | Dispensables | ✓ | Duplicated Code |
> | Couplers | ✗ | (not applicable - no class relationships) |

### 1.1 Change Preventers (with Severity Criteria)

#### Severity Criteria

| Metric | Low | Medium | High |
|--------|-----|--------|------|
| Impact Scope | 1-2 stages | 3-4 stages | 5+ stages |
| Modification Cost | 1-2 locations | 3-5 locations | 6+ locations |

> #### Divergent Change (Scope: File Level)
>
> <details markdown>
> <summary>Click to see details</summary>
>
> **Definition**: "A single class/file is frequently changed for several different reasons"
>
> **Divergent Change Cases in JsJenkins/Jenkinsfile**:
>
> | Change Reason | Affected Stages | Count |
> |---------------|-----------------|:-----:|
> | Server/Client report change | Unit Testing | 1 |
> | Python script interface change | Unit Testing | 1 |
> | SonarQube config change | Static Analysis | 1 |
> | File System structure change | Linting | 1 |
>
> **Severity Evidence**:
> - **Impact Scope**: Medium (Unit Testing most affected)
> - **Modification Cost**: Medium (4 different change reasons in single file)
>
> </details>

> #### Shotgun Surgery (Scope: Within-file)
>
> <details markdown>
> <summary>Click to see details</summary>
>
> **Definition**: "A single change requires modifications to multiple locations"
>
> **Shotgun Surgery: Server/Client pattern change**:
>
> | Type | Pattern |
> |------|---------|
> | Server | `params check` → `retrieveReportSummaryDirs` → `DEBUG_MODE check` → `Python call --server` |
> | Client | Same pattern with `--client` (duplicated) |
>
> **Shotgun Surgery: Adding new report type (e.g., 'admin')**:
>
> | Location | Change Required |
> |----------|-----------------|
> | `publishTestResultsHtmlToWebServer` | Add new call with `'admin'` |
> | `params.ADMIN_SOURCE_FOLDER` check | Add new condition block |
> | `retrieveReportSummaryDirs` call | Add new path |
> | Python script call | Add `--admin` flag |
>
> **Severity Evidence**:
> - **Impact Scope**: High (Unit Testing stage 112 lines)
> - **Modification Cost**: High (6+ locations for new report type)
>
> </details>

### 1.2 Other Code Smells (Evidence Only)

#### Bloaters

| Smell | Evidence |
|-------|----------|
| Long Method | Unit Testing stage (112 lines, 7 responsibilities) |
| Primitive Obsession | Report types hardcoded (`'server'`, `'client'` 4x), SonarQube URL hardcoded, directory names hardcoded |

#### Dispensables

| Smell | Evidence |
|-------|----------|
| Duplicated Code | Server/Client report handling pattern (40+ lines × 2) |
| Duplicated Code | `publishTestResultsHtmlToWebServer` calls (2x) |
| Duplicated Code | DEBUG_MODE branch (2x) |

---

## 2. Design Smells (Principle-Based)

> **Source**: Suryanarayana, G. et al. (2014). *Refactoring for Software Design Smells*
>
> **Applicable Categories**: Since Jenkinsfile is an **orchestration script**, the following categories are applicable:
>
> | Category | Applicable | Applied Smells |
> |----------|:----------:|----------------|
> | Abstraction | ✓ | Multifaceted Abstraction, Missing Abstraction |
> | Encapsulation | ✓ | Missing Encapsulation |
> | Modularization | ✓ | Insufficient Modularization |
> | Hierarchy | ✗ | (no conditional branch patterns) |

### 2.1 Abstraction Smells

> #### Multifaceted Abstraction
>
> <details markdown>
> <summary>Click to see details</summary>
>
> **Definition**: "An abstraction has multiple responsibilities assigned to it"
>
> **Evidence**:
> - Single Jenkinsfile handles 4 different concerns:
>   - Test execution and coverage
>   - Web server deployment (server + client)
>   - Python Bitbucket reports (server + client)
>   - SonarQube analysis + Quality Gate
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
> | Missing Abstraction | Current State | Occurrences |
> |---------------------|---------------|:-----------:|
> | Report type config | `'server'`, `'client'` hardcoded separately | 4 |
> | Filename constants | `'coverage-summary.json'`, `'test-results.json'` inside stage | 2 |
> | SonarQube URL | `'http://localhost:9000/sonarqube'` hardcoded | 1 |
> | Quality Gate status | `'OK'` hardcoded | 1 |
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
> **Evidence: Server/Client report handling not encapsulated**:
>
> | Type | Pattern (40+ lines each) |
> |------|--------------------------|
> | Server | `params.SERVER_SOURCE_FOLDER` check → `retrieveReportSummaryDirs` → `DEBUG_MODE` → `python --server` |
> | Client | Same pattern with `CLIENT_SOURCE_FOLDER` and `--client` |
>
> **Impact**: Adding new report type requires copy-paste of 40+ lines
>
> </details>

### 2.3 Modularization Smells

> #### Insufficient Modularization
>
> <details markdown>
> <summary>Click to see details</summary>
>
> **Definition**: "An abstraction has not been completely decomposed, and remains too large"
>
> **Evidence: Unit Testing stage**:
>
> | Metric | Value | Threshold |
> |--------|-------|-----------|
> | Lines | 112 | ~30 |
> | Responsibilities | 7 | 1-2 |
> | Nesting depth | 3 levels | 2 levels |
>
> **7 Responsibilities**:
> 1. Test execution
> 2. Web server deployment (server)
> 3. Web server deployment (client)
> 4. Server report path lookup
> 5. Server report sending
> 6. Client report path lookup
> 7. Client report sending
>
> </details>

---

## Conclusion

> **Software Smells Summary**:
> - **Code Level**: Divergent Change (4 change reasons), Shotgun Surgery (6+ locations for new report type), Duplicated Code (server/client pattern 40+ lines × 2), Long Method (112 lines)
> - **Design Level**: 4 concerns mixed, report types not abstracted, server/client pattern not encapsulated, Unit Testing stage insufficiently modularized

---

[← SRP Analysis](01-srp-violation-analysis.md)