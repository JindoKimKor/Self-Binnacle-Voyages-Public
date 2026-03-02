[← SRP Analysis](01-srp-violation-analysis.md) | [Software Smells →](02-software-smells-analysis.md)

# JsJenkins/JenkinsfileDeployment - Design Smells Symptoms Analysis

> **Source**: Martin, R.C. (2000). *Design Principles and Design Patterns*
>
> This document analyzes Martin's 7 Design Symptoms using evidence from:
> - [SRP Violation Analysis](01-srp-violation-analysis.md): Inline code detection per stage
> - [Software Smells Analysis](02-software-smells-analysis.md): Code Smells (Fowler), Design Smells (Suryanarayana)
> - Direct code review: Readability, naming, complexity issues

---

## 1. Rigidity

> **Definition**: Changing one place requires cascading changes to other places

### Contributing Smells

| Smell | Evidence | Impact |
|-------|----------|--------|
| Shotgun Surgery | Adding new deployment target → 4+ locations (params, Check Condition, new Stage, env var) | High |
| Duplicated Code | Server/Client deploy pattern change → 2 locations | High |
| Primitive Obsession | Deployment config scattered (`params.SERVER_*`, `params.CLIENT_*`) | Medium |

---

## 2. Fragility

> **Definition**: Modifying one place breaks conceptually unrelated places

### Contributing Smells

| Smell | Evidence | Risk |
|-------|----------|------|
| Shotgun Surgery | Change Docker option in Server only, forget Client → inconsistent deployment | High |
| Duplicated Code | Update az containerapp in Server, forget Client → partial deployment | High |
| Divergent Change | 5 change reasons mixed → unexpected side effects | Medium |

---

## 3. Immobility

> **Definition**: Difficult to extract useful parts for reuse in other systems/modules

### Contributing Smells

| Smell | Evidence | Impact |
|-------|----------|--------|
| Multifaceted Abstraction | 5 concerns mixed (Git, npm, Docker, Azure, SonarQube) | High |
| Insufficient Modularization | Server/Client Deploy stages with 5 responsibilities each | High |
| Missing Abstraction | Deployment config scattered → can't reuse deploy logic | High |

---

## 4. Viscosity

> **Definition**: Doing the right thing (maintaining design) is harder than doing the wrong thing (hacking)

### Contributing Smells

| Smell | Evidence | Impact |
|-------|----------|--------|
| Missing Encapsulation | Server/Client pattern not encapsulated → copy-paste for new target easier | High |
| Duplicated Code | Server/Client same pattern → duplication pattern established | High |
| Long Method | Deploy stages with 5 responsibilities → adding to existing easier than refactoring | Medium |

---

## 5. Needless Complexity

> **Definition**: Over-engineering for features not currently needed
>
> **Symptom**: "I might need this later" (YAGNI violation)

### Evidence

No clear evidence of over-engineering found in JenkinsfileDeployment.

---

## 6. Needless Repetition

> **Definition**: Code that could be unified through abstraction is duplicated in multiple places
>
> **Symptom**: "Same code in multiple places" (DRY violation)

### Contributing Smells

| Smell | Evidence | Impact |
|-------|----------|--------|
| Duplicated Code | Server/Client Deploy pattern (5 steps × 2) | High |
| Duplicated Code | Server/Client version check pattern | Medium |
| Missing Encapsulation | Same 5-step deploy pattern repeated without extraction | High |

---

## 7. Opacity

> **Definition**: Code is difficult to understand and intent is unclear
>
> **Symptom**: "What does this code do?"

### Evidence (Code Review)

| Issue | Evidence | Impact |
|-------|----------|--------|
| Duplicate nested script | `script { script { COMMIT_HASH = ... } }` (lines 96-100) | Medium |
| Complex nesting | Server/Client Deploy stages with `catchError` + `warnError` + `return` | Medium |
| Inline shell commands | `sh` calls scattered across 9 stages (29 total) | Medium |

---

[← SRP Analysis](01-srp-violation-analysis.md) | [Software Smells →](02-software-smells-analysis.md)