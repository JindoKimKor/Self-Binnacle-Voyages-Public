[← SRP Analysis](01-srp-violation-analysis.md) | [Software Smells →](02-software-smells-analysis.md)

# PipelineForJenkins/Jenkinsfile - Design Smells Symptoms Analysis

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
| Shotgun Surgery | Adding new lint type → 4 locations | Medium |
| Duplicated Code | Groovy/Jenkinsfile lint pattern change → 2 locations (30 lines each) | Medium |
| Primitive Obsession | Lint config hardcoded (config file, targets, report file separately) | Low |

---

## 2. Fragility

> **Definition**: Modifying one place breaks conceptually unrelated places

### Contributing Smells

| Smell | Evidence | Risk |
|-------|----------|------|
| Shotgun Surgery | Miss one of 4 lint locations → incomplete lint | Medium |
| Duplicated Code | Update Groovy lint pattern, forget Jenkinsfile → inconsistent behavior | High |
| Divergent Change | 4 change reasons mixed → unexpected side effects | Medium |

---

## 3. Immobility

> **Definition**: Difficult to extract useful parts for reuse in other systems/modules

### Contributing Smells

| Smell | Evidence | Impact |
|-------|----------|--------|
| Multifaceted Abstraction | 4 concerns mixed (lint, groovydoc, gradle, SonarQube) | High |
| Missing Abstraction | Lint config scattered → can't reuse lint logic | Medium |

---

## 4. Viscosity

> **Definition**: Doing the right thing (maintaining design) is harder than doing the wrong thing (hacking)

### Contributing Smells

| Smell | Evidence | Impact |
|-------|----------|--------|
| Missing Encapsulation | Groovy/Jenkinsfile lint pattern not encapsulated → copy-paste for new type easier | Medium |
| Duplicated Code | Groovy/Jenkinsfile 30 lines × 2 → duplication pattern established | Medium |

---

## 5. Needless Complexity

> **Definition**: Over-engineering for features not currently needed
>
> **Symptom**: "I might need this later" (YAGNI violation)

### Evidence

No clear evidence of over-engineering found in PipelineForJenkins/Jenkinsfile.

---

## 6. Needless Repetition

> **Definition**: Code that could be unified through abstraction is duplicated in multiple places
>
> **Symptom**: "Same code in multiple places" (DRY violation)

### Contributing Smells

| Smell | Evidence | Impact |
|-------|----------|--------|
| Duplicated Code | Groovy/Jenkinsfile lint execution pattern (15 lines × 2) | High |
| Duplicated Code | Groovy/Jenkinsfile lint result handling pattern (15 lines × 2) | High |
| Missing Encapsulation | Same patterns repeated without extraction | Medium |

---

## 7. Opacity

> **Definition**: Code is difficult to understand and intent is unclear
>
> **Symptom**: "What does this code do?"

### Evidence (Code Review)

| Issue | Evidence | Impact |
|-------|----------|--------|
| catchError parameter typo | `buildResults:` → `buildResult:`, `stageResults:` → `stageResult:` (lines 247, 271) | High (potential bug) |

---

[← SRP Analysis](01-srp-violation-analysis.md) | [Software Smells →](02-software-smells-analysis.md)