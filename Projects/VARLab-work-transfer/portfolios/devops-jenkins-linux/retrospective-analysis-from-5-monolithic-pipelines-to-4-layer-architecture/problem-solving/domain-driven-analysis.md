# DDD Patterns in Jenkins Architecture

This document analyzes the refactored Jenkins architecture and identifies similarities with **DDD patterns**, referencing Eric Evans' *Domain-Driven Design Reference* (2015).

<!--
Source: Domain-Driven Design Reference, Eric Evans, 2015
https://www.domainlanguage.com/ddd/reference/
Licensed under Creative Commons Attribution 4.0 International License
-->

---

## Table of Contents

- [Background](#background)
- [Overview](#overview)
- [Building Blocks Identified](#building-blocks-identified)
  - [Layered Architecture](#1-layered-architecture-)
  - [Modules](#2-modules-)
  - [Infrastructure Layer (Facade Pattern)](#3-infrastructure-layer-facade-pattern)
  - [Intention-Revealing Interfaces (Analysis)](#4-intention-revealing-interfaces-analysis)
- [Why Tactical Patterns Were Not Applied](#why-tactical-patterns-were-not-applied)
- [Why Strategic Design Patterns Were Not Applied](#why-strategic-design-patterns-were-not-applied)
- [Before vs After Comparison](#before-vs-after-comparison)
- [Summary](#summary)
- [Interview Talking Point](#interview-talking-point)
- [References](#references)

---

## Background

While researching how to articulate the refactored structure, I discovered Domain-Driven Design. Analyzing my architecture, I found it aligns with several DDD organizational principles:

- **Layered Architecture**: My 4-layer separation matched DDD's isolation principle
- **Modules**: My domain-based libraries matched DDD's cohesive concept grouping

### What's Missing from Full DDD

DDD's tactical patterns (Entities, Aggregates, Repositories) require **stateful domain objects** with identity and lifecycle. Jenkins pipelines are stateless: each execution is independent, no objects persist across runs. These patterns simply don't apply.

**This is not a full DDD implementation.** It's a domain-oriented architecture that shares organizational principles with DDD.

---

## Overview

### DDD Pattern Categories

Domain-Driven Design (Eric Evans, 2003) organizes patterns into distinct categories:

<!--
Source: DDD Reference, Table of Contents (p.ii-iii)
- Part I: Putting the Model to Work (Bounded Context, Ubiquitous Language, etc.)
- Part II: Building Blocks of a Model-Driven Design (Layered Architecture, Entities, Services, Modules, etc.)
- Part III: Supple Design (Intention-Revealing Interfaces, etc.)
- Part IV: Context Mapping for Strategic Design
- Part V: Distillation for Strategic Design (Core Domain, Generic Subdomains)
- Part VI: Large-scale Structure for Strategic Design
-->

| Category | Patterns | Purpose |
|----------|----------|---------|
| **Building Blocks** | Layered Architecture, Modules, Services, Entities, Value Objects | Code-level organization |
| **Strategic Design** | Bounded Contexts, Context Mapping, Core Domain, Subdomains | System-level organization |
| **Supple Design** | Intention-Revealing Interfaces, Side-Effect-Free Functions | Design quality |

### Patterns Identified in This Architecture

| DDD Pattern | Category | Alignment | Notes |
|-------------|----------|-----------|-------|
| **Layered Architecture** | Building Blocks | ✓ Applied | 4-layer separation of concerns |
| **Modules** | Building Blocks | ✓ Applied | Git/Shell/SSH libraries as cohesive units |
| **Infrastructure Service** | Building Blocks | Partial | Concept exists, implemented as GoF Facade |
| **Intention-Revealing Interfaces** | Supple Design | ✗ No | Names expose implementation (git commands) |
| **Entities/Aggregates** | Building Blocks | ✗ No | Not applicable to stateless pipeline scripts |
| **Domain Services** | Building Blocks | ✗ No | No domain logic to coordinate |
| **Bounded Contexts** | Strategic Design | ✗ No | Single team, single codebase |

---

## Building Blocks Identified

### 1. Layered Architecture ✓

<!--
Source: DDD Reference, p.10 - Layered Architecture (Part II: Building Blocks)

"Isolate the expression of the domain model and the business logic, and eliminate any
dependency on infrastructure, user interface, or even application logic that is not business
logic. Partition a complex program into layers. Develop a design within each layer that is
cohesive and that depends only on the layers below."

"The key goal here is isolation."
-->

The architecture implements a **4-layer structure** that aligns with DDD's Layered Architecture pattern:

```
┌─────────────────────────────────────────────────────────────────────┐
│                      LAYER 1: Entry Point                          │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐  │
│  │   DLXJenkins     │  │    JsJenkins     │  │  PipelineFor     │  │
│  │  [Unity Entry]   │  │   [JS Entry]     │  │    Jenkins       │  │
│  └──────────────────┘  └──────────────────┘  └──────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────────┐
│                 LAYER 2: Orchestration (vars/)                     │
│  ┌─────────────────────────┐  ┌─────────────────────────┐          │
│  │   stageLintUnity        │  │  stageInitialization    │          │
│  │   stageUnityExecution   │  │  stageDeployBuild       │          │
│  └─────────────────────────┘  └─────────────────────────┘          │
└─────────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────────┐
│                 LAYER 3: Infrastructure                            │
│  Physical: src/service/         Physical: vars/ (CPS Constraint)   │
│  ┌─────────────────────────┐  ┌─────────────────────────┐          │
│  │   BitbucketApiService   │  │   shellScriptHelper     │          │
│  │  [HTTP Communication]   │  │  [Facade: Execution +   │          │
│  └─────────────────────────┘  │   Logging]              │          │
│                               └─────────────────────────┘          │
│                               ┌─────────────────────────┐          │
│                               │  bitbucketApiHelper     │          │
│                               │  [Facade: Credentials + │          │
│                               │   API orchestration]    │          │
│                               └─────────────────────────┘          │
└─────────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────────┐
│                 LAYER 4: Modules                                   │
│  Physical: src/utils/                                               │
│  ┌───────────────────┐ ┌───────────────────┐ ┌───────────────────┐ │
│  │    GitLibrary     │ │   ShellLibrary    │ │  SSHShellLibrary  │ │
│  │   23 operations   │ │   15 operations   │ │    8 operations   │ │
│  └───────────────────┘ └───────────────────┘ └───────────────────┘ │
│  Physical: vars/ (CPS Constraint)                                   │
│  ┌───────────────────────────────────────────────────────────────┐ │
│  │ bitbucketApiLibrary - API request metadata definitions        │ │
│  └───────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────┘
```

**Key isolation achieved:**
- Entry points depend only on Orchestration
- Orchestration depends only on Infrastructure
- Infrastructure depends only on Modules
- Modules have no upward dependencies

<details>
<summary><strong>Jenkins CPS Constraint (Click to expand)</strong></summary>

Jenkins Pipeline applies CPS (Continuation-Passing Style) transformation for fault tolerance. This creates two constraints:

| Constraint | Description |
|------------|-------------|
| **Serializable** | Class fields must be serializable for state persistence across restarts |
| **Pipeline Step Context** | `sh`, `echo`, `withCredentials` must be called from `vars/` (CPS context) |

**Pattern: Indirect call via vars/**

```groovy
// src/HttpApiService.groovy
logger.stepProcessing("msg")  // ✓ OK - vars/에서 echo 실행
jenkinsfile.sh("...")         // ❌ 안 됨 - 직접 호출
```

| Component | Location | Reason |
|-----------|----------|--------|
| **HttpApiService** | src/ | Pure Java (Apache HttpClient). logger는 vars/ 통해 간접 호출 |
| **shellScriptHelper** | vars/ | `sh()` 직접 호출 |
| **logger** | vars/ | `echo` 직접 호출 |

> 상세 설명: [CPS Serialization Diagram](cps-serialization-diagram.md)

</details>

---

### 2. Modules ✓

<!--
Source: DDD Reference, p.15 - Modules (Part II: Building Blocks)

"Choose modules that tell the story of the system and contain a cohesive set of concepts.
Give the modules names that become part of the ubiquitous language. Modules are part of
the model and their names should reflect insight into the domain."

"This often yields low coupling between modules, but if it doesn't look for a way to change
the model to disentangle the concepts, or an overlooked concept that might be the basis of
a module that would bring the elements together in a meaningful way. Seek low coupling
in the sense of concepts that can be understood and reasoned about independently."

Note: Modules are also known as "Packages" (p.15)
-->

Each utility library functions as a **Module** with characteristics that align with DDD's definition:

- **Cohesive concepts**: Related operations grouped together
- **Clear naming**: Names reflect domain insight (Git operations, Shell operations, API operations)
- **Low coupling**: Can be understood independently

| Module | Location | Operations | Cohesive Concept |
|--------|----------|------------|------------------|
| **GitLibrary** | src/utils/ | 23 | All version control operations |
| **ShellLibrary** | src/utils/ | 15 | Local system execution |
| **SSHShellLibrary** | src/utils/ | 8 | Remote server operations |
| **bitbucketApiLibrary** | vars/ (CPS) | 8 | Bitbucket API request definitions |

**Example: GitLibrary as a Module**

```groovy
class GitLibrary {
    // Cohesive set of version control operations
    static final Closure CheckoutBranch = { String branchName ->
        [
            script: "git checkout ${branchName}",
            label: "Checkout branch '${branchName}'",
            returnStdout: true
        ]
    }
    
    static final Closure MergeOriginBranch = { String branchToMerge ->
        [
            script: "git merge origin/${branchToMerge}",
            label: "Merge remote branch 'origin/${branchToMerge}' into current HEAD",
            returnStatus: true
        ]
    }
    
    // ... 23 operations total
}
```

**Module characteristics achieved:**
- **High cohesion**: Only git-related operations
- **Encapsulation**: Internal helpers prefixed with `_`
- **Domain vocabulary**: `checkout`, `branch`, `merge`, `tag`

---

### 3. Infrastructure Layer (Facade Pattern)

Layer 3 components are implemented using the **Facade pattern** from GoF design patterns, rather than DDD Services. This distinction is important:

**DDD Service definition** (from DDD Reference, p.14):
> "When a significant process or transformation in the domain is not a natural responsibility of an entity or value object, add an operation to the model as a standalone interface declared as a service."

Since this architecture has no Entities or Value Objects (stateless environment), the DDD Service pattern doesn't directly apply. Instead, these components serve as **technical facades** that simplify complex infrastructure operations:

| Component | Pattern | Responsibility |
|-----------|---------|----------------|
| **BitbucketApiService** | HTTP Client Wrapper | Encapsulates Apache HttpClient for API communication |
| **shellScriptHelper** | Facade | Combines Library closure execution + Logger integration |
| **bitbucketApiHelper** | Facade | Combines credentials management + API service orchestration |

**Example: shellScriptHelper as Facade**

```groovy
// Simplifies: Library closure + validation + execution + logging
def call(Closure shellScriptClosure, List args = []) {
    Map shMap = shellScriptClosure(*args)
    Map validatedShMap = validateShMap(shMap)
    logger.stepStart("${validatedShMap.label}")
    
    if (validatedShMap.returnStatus) {
        return executeReturnStatus(validatedShMap)
    } else if (validatedShMap.returnStdout) {
        return executeReturnStdout(validatedShMap)
    }
    // ...
}
```

**Example: bitbucketApiHelper as Facade**

```groovy
// Simplifies: credentials + API service + error handling
def call(Map bitbucketApiMap) {
    BitbucketApiService bitbucketApiService = new BitbucketApiService(this)
    
    withCredentials([string(credentialsId: 'bitbucket-access-token', variable: 'token')]) {
        if (bitbucketApiMap.method == 'POST') {
            return bitbucketApiService.post(bitbucketApiMap.apiUrlString, bitbucketApiMap.requestBody, token)
        }
        // ...
    }
}
```

---

### 4. Intention-Revealing Interfaces (Analysis)

<!--
Source: DDD Reference, p.20 - Intention-Revealing Interfaces (Part III: Supple Design)

"Name classes and operations to describe their effect and purpose, without reference to the
means by which they do what they promise. This relieves the client developer of the need
to understand the internals. These names should conform to the ubiquitous language so
that team members can quickly infer their meaning."
-->

**DDD Definition:** Names should describe effect and purpose, **without reference to the means** by which they do what they promise.

**Analysis of current naming:**

| Operation Name | What It Reveals | Issue |
|----------------|-----------------|-------|
| `GitLibrary.CheckoutBranch` | `git checkout` command | Exposes implementation |
| `GitLibrary.MergeOriginBranch` | `git merge origin/` command | Exposes implementation |
| `GitLibrary.ResetHardHead` | `git reset --hard` command | Exposes implementation |
| `ShellLibrary.PrintJenkinsEnv` | Prints environment | Descriptive, but technical |
| `SSHShellLibrary.CopyBuildToHostServer` | SCP operation | Exposes implementation |

**Why this doesn't meet DDD criteria:**

The current names directly expose the underlying git/shell commands rather than describing the business intent. True Intention-Revealing names would be:

| Current | Intention-Revealing Alternative |
|---------|--------------------------------|
| `CheckoutBranch` | `SwitchToBranch` or `ActivateBranch` |
| `MergeOriginBranch` | `IntegrateRemoteChanges` |
| `ResetHardHead` | `DiscardAllLocalChanges` |
| `CopyBuildToHostServer` | `DeployBuildArtifacts` |

**Conclusion:** The current naming is **descriptive** but not **intention-revealing** by DDD standards. Names follow git/shell command conventions rather than domain language.

---

## Why Tactical Patterns Were Not Applied

<!--
Source: DDD Reference, p.11 - Entities (Part II: Building Blocks)

"When an object is distinguished by its identity, rather than its attributes, make this primary
to its definition in the model. Keep the class definition simple and focused on life cycle
continuity and identity."

Source: DDD Reference, p.16 - Aggregates (Part II: Building Blocks)

"Cluster the entities and value objects into aggregates and define boundaries around each.
Choose one entity to be the root of each aggregate, and allow external objects to hold
references to the root only."
-->

| Pattern | Description | Why Not Applicable |
|---------|-------------|-------------------|
| **Entities** | Objects with identity and lifecycle | Pipeline scripts are stateless |
| **Value Objects** | Immutable objects defined by attributes | No complex domain objects needed |
| **Aggregates** | Clusters with consistency boundaries | No persistent object relationships |
| **Repositories** | Collection-like access to aggregates | No persistent storage of domain objects |

**Stateless vs Stateful:**

DDD tactical patterns assume **stateful** domain objects where:
- Objects have identity that persists across operations
- State changes are tracked and managed
- Previous state influences next behavior

Jenkins pipelines are **stateless**:
- Each execution is independent
- No objects persist across pipeline runs
- External systems (Bitbucket, Azure) manage state

```groovy
// Stateless: Each call is independent, no state tracking
bitbucketApiHelper(
    bitbucketApiLibrary.createBuildStatusForCommit(Status.COMMIT_STATUS.SUCCESSFUL, '✅ Success')
)

// Stateful would require:
class PullRequest {
    PRId id
    Status previousStatus
    
    void updateStatus(newStatus) {
        if (previousStatus == FAILED && newStatus == SUCCESS) {
            notifyRecovery()  // Behavior depends on previous state
        }
        previousStatus = newStatus
    }
}
```

---

## Why Strategic Design Patterns Were Not Applied

### Bounded Context

<!--
Source: DDD Reference, p.2 - Bounded Context (Part I: Putting the Model to Work)

"Multiple models are in play on any large project. They emerge for many reasons. Two
subsystems commonly serve very different user communities, with different jobs, where
different models may be useful. Teams working independently may solve the same problem
in different ways through lack of communication."

"Explicitly define the context within which a model applies. Explicitly set boundaries in
terms of team organization, usage within specific parts of the application, and physical
manifestations such as code bases and database schemas."
-->

**Bounded Context** applies when:
- Multiple teams with different models
- Separate applications or services
- Different codebases, databases

**Not applicable here:**
- Single team maintains all code
- Single codebase (Jenkins shared library)
- No need for model translation between contexts

**Note:** The utility libraries (Git, Shell, SSH) are **Modules**, not Bounded Contexts. They share the same team, codebase, and ubiquitous language.

---

## Before vs After Comparison

| Aspect | Before (74fc356) | After (ff74ac8) |
|--------|------------------|-----------------|
| **Structure** | Flat `groovy/` folder | 4-layer `sharedLibraries/` |
| **Git operations** | Mixed in generalHelper | Separated to GitLibrary (23 ops) |
| **Shell operations** | Mixed in generalHelper | Separated to ShellLibrary (15 ops) |
| **SSH operations** | Mixed in generalHelper | Separated to SSHShellLibrary (8 ops) |
| **Stage logic** | Directly in Jenkinsfile | Extracted to vars/stage*.groovy |
| **Logging** | Ad-hoc echo statements | Centralized logger.groovy |
| **API calls** | Python script dependency | Native Groovy BitbucketApiService |
| **Commits** | 89 | 308 |

---

## Summary

### Patterns Applied

| Pattern | Category | Implementation |
|---------|----------|----------------|
| **Layered Architecture** | DDD Building Blocks | 4-layer: Entry → Orchestration → Infrastructure → Module |
| **Modules** | DDD Building Blocks | GitLibrary, ShellLibrary, SSHShellLibrary, bitbucketApiLibrary |

### Patterns Partially Aligned

| Pattern | Category | Notes |
|---------|----------|-------|
| **Infrastructure Service** | DDD Building Blocks | Concept exists, implemented as GoF Facade pattern |

### Patterns Not Applied

| Pattern | Category | Reason |
|---------|----------|--------|
| **Intention-Revealing Interfaces** | DDD Supple Design | Names expose implementation (git commands) |
| **Entities, Aggregates** | DDD Building Blocks | Stateless pipeline environment |
| **Domain Services** | DDD Building Blocks | No domain logic requiring coordination between Entities/Value Objects |
| **Bounded Contexts** | DDD Strategic Design | Single team, single codebase |
| **Context Mapping** | DDD Strategic Design | No multiple contexts to integrate |

---

<!--
## Interview Talking Point

**Q: Why did you use "domain-driven" in your resume?**

> "The original purpose of DDD is to design complex domain logic with domain experts and developers communicating in the same language, centered around a domain model.
>
> In my case, it wasn't to that level. I used 'domain-driven' to mean that I separated the previously mixed code by functional domains: Git operations, Shell scripting, Bitbucket API, and Secure Shell operations.
>
> After the refactoring, I analyzed it against Eric Evans' DDD. I found similarities with some organizational principles like Layered Architecture and Modules, but I didn't apply DDD as a whole."

**Q: What is DDD's main purpose?**

> "DDD's core purpose is handling complex business domains by having developers and domain experts communicate using a Ubiquitous Language, with the domain model directly reflected in code.
>
> Jenkins pipelines don't really fit this - they're stateless, mostly external system calls, no complex domain logic. What I did was domain-based code organization, not full DDD implementation."

**Q: What about Intention-Revealing Interfaces?**

> "That's one I could have applied but didn't. I used implementation names like git commands instead of domain-intent names.
>
> If I had done this, it would have been closer to DDD's core concept of Ubiquitous Language - where the code reflects domain intent rather than implementation details."
-->

## References

- Evans, Eric. *Domain-Driven Design: Tackling Complexity in the Heart of Software*. Addison-Wesley, 2003.
- Evans, Eric. *Domain-Driven Design Reference*. Domain Language, Inc., 2015. (CC BY 4.0)
- Gamma, Erich, et al. *Design Patterns: Elements of Reusable Object-Oriented Software*. Addison-Wesley, 1994. (Facade pattern)
- [Martin Fowler - Bounded Context](https://martinfowler.com/bliki/BoundedContext.html)