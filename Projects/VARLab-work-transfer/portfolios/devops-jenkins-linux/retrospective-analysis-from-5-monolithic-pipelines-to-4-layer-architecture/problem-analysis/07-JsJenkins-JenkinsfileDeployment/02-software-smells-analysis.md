[← SRP Analysis](01-srp-violation-analysis.md)

# JsJenkins/JenkinsfileDeployment - Software Smells Analysis

> Classification based on industry-standard taxonomy: Code Smells (Fowler) → Design Smells (Suryanarayana)
>
> **Inline Code Analysis**: 29 inline codes across 9 stages. See [SRP Violation Analysis](01-srp-violation-analysis.md)

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
> **Divergent Change Cases in JenkinsfileDeployment**:
>
> | Change Reason | Affected Stages | Count |
> |---------------|-----------------|:-----:|
> | Git workflow change | Prepare WORKSPACE | 1 |
> | Docker config change | Check Condition, Server Deploy, Client Deploy | 3 |
> | Azure config change | Check Condition, Server Deploy, Client Deploy | 3 |
> | SonarQube config change | Static Analysis | 1 |
> | npm/Node config change | Install Dependencies, Linting, Unit Testing | 3 |
>
> **Severity Evidence**:
> - **Impact Scope**: High (Docker/Azure affects 3 stages)
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
> **Shotgun Surgery: Server/Client deploy pattern change**:
>
> | Target | Pattern |
> |--------|---------|
> | Server | `az acr show-tags` → `docker build` → `docker push` → `az containerapp update` → `docker rmi` |
> | Client | Same 5-step pattern (duplicated) |
>
> **Shotgun Surgery: Adding new deployment target (e.g., 'admin')**:
>
> | Location | Change Required |
> |----------|-----------------|
> | Parameters | Add `params.ADMIN_*` (3 params) |
> | Check Condition | Add admin version check (20+ lines) |
> | New Stage | Copy 75 lines for Admin Deploy |
> | Environment variables | Add `env.ADMIN_SKIP_BUILD` |
>
> **Severity Evidence**:
> - **Impact Scope**: High (entire Deploy section)
> - **Modification Cost**: High (4+ locations, 75+ lines copy for new target)
>
> </details>

### 1.2 Other Code Smells (Evidence Only)

#### Bloaters

| Smell | Evidence |
|-------|----------|
| Long Method | Server Deploy (75 lines, 5 responsibilities), Client Deploy (73 lines, same) |
| Primitive Obsession | Deployment config scattered (`params.SERVER_*`, `params.CLIENT_*`), SonarQube URL hardcoded, directory names hardcoded |

#### Dispensables

| Smell | Evidence |
|-------|----------|
| Duplicated Code | Server/Client Deploy pattern (75 lines × 2 = 150 lines) |
| Duplicated Code | Server/Client version check pattern (20 lines × 2) |

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
> - Single Jenkinsfile handles 5 different concerns:
>   - Git commands (`clone`, `checkout`, `reset`, `pull`)
>   - npm/Node (version check, install, linting, testing)
>   - Docker (build, push, rmi)
>   - Azure (az login, az acr, az containerapp)
>   - SonarQube (scanner config, Quality Gate)
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
> | Deployment target config | `params.SERVER_*`, `params.CLIENT_*` scattered | 6+ |
> | Azure registry config | `env.AZ_CONTAINER_REGISTRY_NAME` scattered | 4 |
> | Docker command options | hardcoded in `sh` calls | 8 |
> | SonarQube URL | `'http://localhost:9000/sonarqube'` hardcoded | 1 |
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
> **Evidence: Server/Client deploy pattern not encapsulated**:
>
> | Target | Pattern (75 lines each) |
> |--------|-------------------------|
> | Server | `az acr show-tags` → `getPackageJsonVersion` → `versionCompare` → `docker build` → `docker push` → `az containerapp update` → `docker rmi` |
> | Client | Same 7-step pattern |
>
> **Impact**: Adding new deployment target requires copy-paste of 75+ lines
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
> **Evidence: Server/Client Deploy stages**:
>
> | Metric | Value | Threshold |
> |--------|-------|-----------|
> | Lines (each) | 75 | ~30 |
> | Responsibilities | 5 | 1-2 |
> | Duplication | 150 lines total | 0 |
>
> **5 Responsibilities (duplicated)**:
> 1. Version lookup from ACR
> 2. Version comparison
> 3. Docker build
> 4. Docker push + Azure update
> 5. Docker cleanup
>
> </details>

---

## Conclusion

> **Software Smells Summary**:
> - **Code Level**: Divergent Change (5 change reasons), Shotgun Surgery (4+ locations for new target), Duplicated Code (Server/Client 150 lines), Long Method (75 lines × 2)
> - **Design Level**: 5 concerns mixed, deployment config not abstracted, Server/Client pattern not encapsulated, Deploy stages insufficiently modularized

---

[← SRP Analysis](01-srp-violation-analysis.md)