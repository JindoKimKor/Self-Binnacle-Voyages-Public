[← SRP Analysis](01-srp-violation-analysis.md)

# DLXJenkins/Jenkinsfile - Software Smells Analysis

> Classification based on industry-standard taxonomy: Code Smells (Fowler) → Design Smells (Suryanarayana)
>
> **Inline Code Analysis**: 16 inline codes across 6 stages. See [SRP Violation Analysis](01-srp-violation-analysis.md)

---

## 1. Code Smells

> **Source**: Fowler, M. (1999). *Refactoring: Improving the Design of Existing Code*
>
> **Applicable Categories**: Since Jenkinsfile is an **orchestration script**, only the following categories are applicable:
>
> | Category | Applicable | Applied Smells |
> |----------|:----------:|----------------|
> | Bloaters | ✓ | Primitive Obsession |
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
> **Divergent Change Cases in DLXJenkins/Jenkinsfile**:
>
> | Change Reason | Affected Stages | Count |
> |---------------|-----------------|:-----:|
> | Unity Stage settings change | Prepare, EditMode, PlayMode, Coverage, Build | 5 |
> | File System structure change | Linting, EditMode, Build | 3 |
> | Python script interface change | Linting, Build | 2 |
> | Linting policy change | Linting | 1 |
>
> **Severity Evidence**:
> - **Impact Scope**: High (5 stages affected by Unity Stage changes)
> - **Modification Cost**: High (4 different change reasons in single file)
>
> </details>

> #### Shotgun Surgery (Scope: Within-file)
>
> <details markdown>
> <summary>Click to see details</summary>
>
> **Definition**: "A single change requires modifications to multiple locations"
>
> **Shotgun Surgery: stageName/errorMsg change**:
>
> | Stage | Lines | stageName | errorMsg |
> |-------|-------|-----------|----------|
> | Prepare WORKSPACE | 112-114 | `'Rider'` | `'Synchronizing Unity and Rider IDE solution files failed'` |
> | EditMode Tests | 181-183 | `'EditMode'` | `'EditMode tests failed'` |
> | PlayMode Tests | 195-197 | `'PlayMode'` | `'PlayMode tests failed'` |
> | Code Coverage | 209-211 | `'Coverage'` | `'Code Coverage generation failed'` |
> | Build Project | 237-239 | `'Webgl'` | `'WebGL Build failed'` |
>
> **Severity Evidence**:
> - **Impact Scope**: High (5 stages)
> - **Modification Cost**: Medium (5 locations for single change)
>
> </details>

### 1.2 Other Code Smells (Evidence Only)

#### Bloaters

| Smell | Evidence |
|-------|----------|
| Primitive Obsession | stageName hardcoded (5x), directory names hardcoded (`linting_results`, `test_results`, `coverage_results`) |

#### Dispensables

| Smell | Evidence |
|-------|----------|
| Duplicated Code | `String stageName = '...'; String errorMassage = '...'; unityUtil.runUnityStage(...)` pattern (5x) |

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
> | Modularization | ✗ | (single file) |
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
>   - Unity Stage execution (5 stages)
>   - File System operations (`mkdir`, `cp`)
>   - Python script calls (Linting report, WebGL report)
>   - Linting logic (Bash script + exitCode branch)
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
> | Unity Stage config | `stageName`, `errorMsg` hardcoded separately | 5 |
> | Directory names | `'linting_results'`, `'test_results'`, `'coverage_results'` strings | 3 |
> | Python script paths | `'${env.WORKSPACE}/python/...'` hardcoded | 3 |
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
> **Evidence: Unity Stage execution pattern not encapsulated**:
>
> | Stage | Pattern |
> |-------|---------|
> | Prepare WORKSPACE | `String stageName = 'Rider'; String errorMassage = '...'; unityUtil.runUnityStage(...)` |
> | EditMode Tests | `String stageName = 'EditMode'; String errorMassage = '...'; unityUtil.runUnityStage(...)` |
> | PlayMode Tests | `String stageName = 'PlayMode'; String errorMassage = '...'; unityUtil.runUnityStage(...)` |
> | Code Coverage | `String stageName = 'Coverage'; String errorMassage = '...'; unityUtil.runUnityStage(...)` |
> | Build Project | `String stageName = 'Webgl'; String errorMassage = '...'; unityUtil.runUnityStage(...)` |
>
> **Impact**: Changing error message format requires modifying all 5 locations
>
> </details>

---

## Conclusion

> **Software Smells Summary**:
> - **Code Level**: Divergent Change (4 change reasons), Shotgun Surgery (stageName/errorMsg 5 locations), Duplicated Code (Unity Stage pattern 5x)
> - **Design Level**: 4 concerns mixed in single file, stageName/errorMsg not abstracted, Unity Stage pattern not encapsulated

---

[← SRP Analysis](01-srp-violation-analysis.md)