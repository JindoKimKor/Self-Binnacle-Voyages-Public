[← SRP Analysis](01-srp-violation-analysis.md)

# PipelineForJenkins/Jenkinsfile - Software Smells Analysis

> Classification based on industry-standard taxonomy: Code Smells (Fowler) → Design Smells (Suryanarayana)
>
> **Inline Code Analysis**: 14 inline codes across 6 stages. See [SRP Violation Analysis](01-srp-violation-analysis.md)

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
> **Divergent Change Cases in PipelineForJenkins/Jenkinsfile**:
>
> | Change Reason | Affected Stages | Count |
> |---------------|-----------------|:-----:|
> | Groovy/Jenkinsfile lint config change | Lint Groovy Code | 1 |
> | Groovydoc config change | Generate Groovydoc | 1 |
> | Gradle config change | Run Unit Tests | 1 |
> | SonarQube config change | Static Analysis | 1 |
>
> **Severity Evidence**:
> - **Impact Scope**: Medium (4 different concerns)
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
> **Shotgun Surgery: Groovy/Jenkinsfile lint pattern change**:
>
> | Type | Pattern |
> |------|---------|
> | Groovy | `docker.image().inside()` → `npm-groovy-lint` → `if (exitCode != 0)` → Python report |
> | Jenkinsfile | Same pattern (duplicated) |
>
> **Shotgun Surgery: Adding new lint type (e.g., 'Python')**:
>
> | Location | Change Required |
> |----------|-----------------|
> | Docker image variable | Add new image if needed |
> | Lint execution block | Add 15+ lines |
> | Result handling block | Add 15+ lines |
> | Final condition | Add `|| exitCodePython != 0` |
>
> **Severity Evidence**:
> - **Impact Scope**: Medium (Lint Groovy Code stage)
> - **Modification Cost**: Medium (4 locations, 30+ lines for new type)
>
> </details>

### 1.2 Other Code Smells (Evidence Only)

#### Bloaters

| Smell | Evidence |
|-------|----------|
| Primitive Obsession | Docker image hardcoded (`'nvuillam/npm-groovy-lint'`), lint config files hardcoded, SonarQube URL hardcoded, lint target folders hardcoded |

#### Dispensables

| Smell | Evidence |
|-------|----------|
| Duplicated Code | Groovy/Jenkinsfile lint execution pattern (15 lines × 2) |
| Duplicated Code | Groovy/Jenkinsfile lint result handling pattern (15 lines × 2) |

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
>   - Docker-based linting (Groovy + Jenkinsfile)
>   - Groovydoc generation
>   - Gradle unit tests
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
> | Lint config | config file, targets, report file hardcoded separately | 2 |
> | Docker image | `'nvuillam/npm-groovy-lint'` hardcoded | 1 |
> | SonarQube URL | `'http://localhost:9000/sonarqube'` hardcoded | 1 |
> | Lint target folders | `'DLXJenkins'`, `'JsJenkins'`, `'PipelineForJenkins'` hardcoded | 1 |
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
> **Evidence: Groovy/Jenkinsfile lint pattern not encapsulated**:
>
> | Type | Pattern (30 lines each) |
> |------|-------------------------|
> | Groovy | `docker.image().inside()` → `npm-groovy-lint --config .groovylintrc.groovy.json` → Python report |
> | Jenkinsfile | Same pattern with `.groovylintrc.jenkins.json` |
>
> **Impact**: Adding new lint type requires copy-paste of 30+ lines
>
> </details>

---

## 3. Implementation Issues (Code Review)

> #### catchError Parameter Typo
>
> <details markdown>
> <summary>Click to see details</summary>
>
> **Evidence**:
>
> | Line | Current (Typo) | Correct |
> |------|----------------|---------|
> | 247 | `catchError(buildResults: ..., stageResults: ...)` | `catchError(buildResult: ..., stageResult: ...)` |
> | 271 | Same typo | Same fix |
>
> **Impact**: Jenkins Pipeline DSL may ignore incorrect parameter names, causing unexpected behavior
>
> </details>

---

## Conclusion

> **Software Smells Summary**:
> - **Code Level**: Divergent Change (4 change reasons), Shotgun Surgery (4 locations for new lint type), Duplicated Code (Groovy/Jenkinsfile lint 30 lines × 2)
> - **Design Level**: 4 concerns mixed, lint config not abstracted, lint pattern not encapsulated
> - **Implementation Issue**: `catchError` parameter typo (lines 247, 271)

---

[← SRP Analysis](01-srp-violation-analysis.md)