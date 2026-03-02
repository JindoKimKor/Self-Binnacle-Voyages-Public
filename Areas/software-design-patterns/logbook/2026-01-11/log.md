---
date: 2026-01-11
end-date: 2026-01-17
---

## Log (Monitoring)

> Source: [VARLab-work-transfer Jenkins Pipeline Refactoring Portfolio](../../../Projects/VARLab-work-transfer/portfolios/devops-jenkins-linux/4-layer-architecture-and-logger-system-integration/)

---

### 1. Problem Analysis Perspective

Analyzed problems in Jenkins Pipeline codebase (2,975 lines, 8 files) using Software Smells classification systems.

#### 1.1 Analysis Framework Used

| Level | Framework | Source |
|-------|-----------|--------|
| Function | Code Smells | Fowler/Beck (1999) |
| Module | Design Smells - Symptoms | Martin (2000) |
| Module | Design Smells - Principles | Suryanarayana et al. (2014) |
| System | Architecture Smells | Garcia et al., Sharma |
| System | DRY Violation | Hunt & Thomas (1999) |

#### 1.2 SRP Violations Identified

**Module Level:**
| File | Violation | Evidence |
|------|-----------|----------|
| generalHelper.groovy | Kitchen Sink | 8 domains, 19% cohesion (4/21 functions reused) |
| jsHelper.groovy | CI/CD Mixed | 50% functions are CI-only or CD-only |
| unityHelper.groovy | CI-specific Mixed | 4 Coverage functions are CI-only |
| Jenkinsfiles (5) | Logic in Orchestration | 5-7 domains exist where only orchestration should |

**Function Level:**
| Function | Change Reasons |
|----------|----------------|
| `checkQualityGateStatus()` | 5 (SonarQube API, Retry, HTTP, JSON, Logging) |
| `runUnityBatchMode()` | 7 (Log paths, Test platform, Coverage, Unity CLI, Graphics, xvfb-run, Stage addition) |
| `installNpmInTestingDirs()` | 3 (npm audit, Python interface, npm install) |

#### 1.3 Code Smells (Fowler/Beck)

| Category | Smell | Severity | Evidence |
|----------|-------|----------|----------|
| Change Preventers | Divergent Change | High | generalHelper: 8 change reasons |
| Change Preventers | Shotgun Surgery | High | Path change → 10-40 modifications |
| Dispensables | Duplicated Code | High | 569 lines (18.1%), logMessage() copy |
| Bloaters | Long Method | High | runUnityBatchMode() 126 lines |
| Couplers | Feature Envy | High | JS CI Unit Testing stage |

#### 1.4 Design Smells (Suryanarayana)

| Category | Smell | Evidence |
|----------|-------|----------|
| Abstraction | Multifaceted | 8 domains in single file |
| Abstraction | Missing | Magic strings: `/var/www/html`, `localhost:9000/sonarqube` |
| Encapsulation | Missing | SSH/SCP patterns repeated 4x |
| Modularization | Insufficient | 656 lines, 21 functions in generalHelper |
| Modularization | Hub-like | 5 pipelines depend on single file |

#### 1.5 Martin's 7 Symptoms

| Symptom | Severity | Manifestation |
|---------|----------|---------------|
| Rigidity | High | 7 change triggers → 10-40 modifications |
| Fragility | High | 8 domains mixed, no boundaries |
| Immobility | High | Cannot extract GitHelper without 8 domains |
| Viscosity | Medium | Copying easier than correct extraction |
| Opacity | High | Counter-intuitive names, 3-level nesting |
| Repetition | High | 18.1% duplication |
| Complexity | Low | Only 2 dead code functions |

#### 1.6 Key Insight: Root Cause Chain

```
Lack of Helper Design
  → Kitchen Sink (multi-purpose file)
    → Divergent Change
      → Rigidity

Common Patterns Not Extracted
  → Duplicated Code (5 places)
    → DRY Violation
      → Synchronization issues

Environment Settings Hardcoded
  → Missing Encapsulation
    → Viscosity
      → Copy-paste culture
```

---

### 2. Post-Refactoring Perspective

Design Patterns and SOLID principles applied after refactoring to 4-Layer Architecture.

#### 2.1 4-Layer Architecture

```
Layer 1: Entry Point (Jenkinsfiles)
  ↓
Layer 2: Orchestration (vars/ - Stage modules, Helpers)
  ↓
Layer 3: Services (src/service/ - Business logic)
  ↓
Layer 4: Utilities (src/utils/ - Libraries, Constants)
```

#### 2.2 Design Patterns Applied

| Pattern | Where | Implementation |
|---------|-------|----------------|
| **Command** | GitLibrary, ShellLibrary (54 closures) | Closure encapsulates command definition |
| **Facade** | logger, bitbucketApiHelper | Simplifies complex subsystem interactions |
| **Service Layer** | HttpApiService, BuildProjectService | Encapsulates business logic, DI support |
| **Builder** | bitbucketApiLibrary | Builds complex API requests step-by-step |
| **Strategy** | stageUnityExecution | Runtime selection (EditMode, PlayMode, Coverage) |

#### 2.3 SOLID Principles Applied

| Principle | Application |
|-----------|-------------|
| **S**ingle Responsibility | Each file has one concern (Git ops, Shell commands, API) |
| **O**pen/Closed | Extensible through Closures without modifying existing code |
| **D**ependency Inversion | Services depend on abstractions (closure-based commands) |

#### 2.4 Metadata-Driven Design

```groovy
// Library: Define command with embedded metadata
static Closure GIT_FETCH = { branchName ->
    [
        script: "git fetch origin ${branchName}",
        label: "Fetch branch"  // ← Metadata for auto-logging
    ]
}

// Helper: Execute with automatic logging
shellScriptHelper.execute(GitLibrary.GIT_FETCH('main'))
```

**Benefits:**
- Label metadata → automatic logging
- Eliminates repetitive logging code
- Single source of truth for command definition

#### 2.5 Before/After Comparison

| Aspect | Before | After |
|--------|--------|-------|
| Code Duplication | 18.1% (569 lines) | Centralized library |
| Logging | Multiple implementations | 1 logger.groovy |
| Testability | Difficult (Jenkins coupled) | Service layer + mocks |
| Jenkinsfile Size | 250+ lines | ~15 lines |

#### 2.6 CPS Compatibility Learnings

Design decisions due to Jenkins Pipeline CPS constraints:

| Issue | Solution |
|-------|----------|
| `@Canonical` annotation not supported | Manual constructor/getter |
| Private static fields not accessible | Direct string usage in methods |
| Class in src/ has CPS constraints | logger, bitbucketApiLibrary → vars/ |

---

### 3. Key Takeaways

#### 3.1 Analysis Methodology
- Analyze Software Smells by level: Function / Module / System
- Judge SRP violation based on "change reason" criterion

#### 3.2 Applying SOLID to Jenkins/Procedural Code
- SRP: Applicable even without OOP (universal principle)
- OCP: Achieve extensibility through Closures
- DIP: Dependency inversion via Service layer

#### 3.3 Refactoring Direction

| Problem | Solution |
|---------|----------|
| Hub-like Dependency | Domain-based file separation |
| DRY Violation | Shared Library extraction |
| Missing Encapsulation | Constantize paths, create helper functions |
| Long Method | Stage modularization |

---

### References

- Fowler, M. & Beck, K. (1999). *Refactoring: Improving the Design of Existing Code*
- Martin, R. C. (2000). *Design Principles and Design Patterns*
- Martin, R. C. (2006, 2010). *Clean Code*, *Agile Software Development*
- Suryanarayana, G. et al. (2014). *Refactoring for Software Design Smells*
- Hunt, A. & Thomas, D. (1999). *The Pragmatic Programmer*
