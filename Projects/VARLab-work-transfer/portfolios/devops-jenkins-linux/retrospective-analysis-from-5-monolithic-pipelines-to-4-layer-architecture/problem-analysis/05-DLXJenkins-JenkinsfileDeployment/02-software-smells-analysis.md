[← SRP Analysis](01-srp-violation-analysis.md)

# DLXJenkins/JenkinsfileDeployment - Software Smells Analysis

> Classification based on industry-standard taxonomy: Code Smells (Fowler) → Design Smells (Suryanarayana)
>
> **Inline Code Analysis**: 23 inline codes across 7 stages. See [SRP Violation Analysis](01-srp-violation-analysis.md)

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
> **Divergent Change Cases in JenkinsfileDeployment**:
>
> | Change Reason | Affected Stages | Count |
> |---------------|-----------------|:-----:|
> | Unity Stage settings change | Prepare, EditMode, PlayMode, Build | 4 |
> | Git workflow change | Prepare WORKSPACE | 1 |
> | File System structure change | Linting, EditMode, Build | 3 |
> | SSH/SCP deployment change | Deploy Build | 1 |
> | Linting policy change | Linting | 1 |
>
> **Severity Evidence**:
> - **Impact Scope**: High (4 stages affected by Unity Stage changes)
> - **Modification Cost**: High (5 different change reasons in single file)
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
> | Prepare WORKSPACE | 120-122 | `'Rider'` | `'Synchronizing Unity and Rider IDE solution files failed'` |
> | EditMode Tests | 164-166 | `'EditMode'` | `'EditMode tests failed'` |
> | PlayMode Tests | 178-180 | `'PlayMode'` | `'PlayMode tests failed'` |
> | Build Project | 193-195 | `'Webgl'` | `'WebGL Build failed'` |
>
> **Shotgun Surgery: SSH/SCP pattern change**:
>
> | Server | Lines | Pattern |
> |--------|-------|---------|
> | LTI | 205-209 | `ssh mkdir` + `scp` + `ssh UpdateBuildURL.sh` |
> | eConestoga | 218-233 | Same pattern (duplicated) |
>
> **Severity Evidence**:
> - **Impact Scope**: High (4 stages for Unity, 2 servers for Deploy)
> - **Modification Cost**: Medium (4 locations for Unity, 6 locations for SSH/SCP)
>
> </details>

### 1.2 Other Code Smells (Evidence Only)

#### Bloaters

| Smell | Evidence |
|-------|----------|
| Primitive Obsession | stageName hardcoded (4x), server paths hardcoded (`/var/www/html/${FOLDER_NAME}` 4x), directory names hardcoded |

#### Dispensables

| Smell | Evidence |
|-------|----------|
| Duplicated Code | stageName/errorMsg pattern (4x) |
| Duplicated Code | SSH/SCP deployment pattern (LTI + eConestoga = 2x, 6 commands each) |

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
> - Single Jenkinsfile handles 5 different concerns:
>   - Unity Stage execution (4 stages)
>   - Git commands (`clone`, `checkout`, `reset`, `pull`)
>   - File System operations (`mkdir`, `cp`, `mv`)
>   - SSH/SCP deployment (2 servers)
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
> | Unity Stage config | `stageName`, `errorMsg` hardcoded separately | 4 |
> | Server config | `env.DLX_WEB_HOST_URL`, `env.DLX_ECONESTOGA_URL` scattered | 6 |
> | Server path | `'/var/www/html/${FOLDER_NAME}'` repeated | 4 |
> | Directory names | `'linting_results'`, `'test_results'` strings | 2 |
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
> **Evidence: Deployment pattern not encapsulated**:
>
> | Server | Pattern |
> |--------|---------|
> | LTI | `ssh mkdir/chown` → `scp copy` → `ssh UpdateBuildURL.sh` |
> | eConestoga | Same 3-step pattern (duplicated) |
>
> **Evidence: Unity Stage execution pattern not encapsulated**:
>
> | Stage | Pattern |
> |-------|---------|
> | Prepare WORKSPACE | `String stageName = 'Rider'; String errorMassage = '...'; unityUtil.runUnityStage(...)` |
> | EditMode Tests | `String stageName = 'EditMode'; ...` |
> | PlayMode Tests | `String stageName = 'PlayMode'; ...` |
> | Build Project | `String stageName = 'Webgl'; ...` |
>
> **Impact**: Adding new server requires copy-paste of 3 SSH/SCP commands
>
> </details>

---

## Conclusion

> **Software Smells Summary**:
> - **Code Level**: Divergent Change (5 change reasons), Shotgun Surgery (stageName 4 locations + SSH/SCP 6 locations), Duplicated Code (Unity pattern 4x + Deploy pattern 2x)
> - **Design Level**: 5 concerns mixed in single file, server config not abstracted, deployment pattern not encapsulated

---

[← SRP Analysis](01-srp-violation-analysis.md)