[← SRP Analysis](01-srp-violation-analysis.md) | [Software Smells →](02-software-smells-analysis.md)

# DLXJenkins/Jenkinsfile - Design Smells Symptoms Analysis

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
| Shotgun Surgery | stageName/errorMsg change → 5 locations | High |
| Primitive Obsession | Directory names hardcoded (3x), Python script paths hardcoded (3x) | Medium |

---

## 2. Fragility

> **Definition**: Modifying one place breaks conceptually unrelated places

### Contributing Smells

| Smell | Evidence | Risk |
|-------|----------|------|
| Shotgun Surgery | Miss one of 5 stageName locations → Stage failure | High |
| Divergent Change | 4 change reasons mixed → unexpected side effects | Medium |

---

## 3. Immobility

> **Definition**: Difficult to extract useful parts for reuse in other systems/modules

### Contributing Smells

| Smell | Evidence | Impact |
|-------|----------|--------|
| Multifaceted Abstraction | 4 concerns mixed (Unity Stage, File System, Python scripts, Linting logic) | High |
| Missing Abstraction | stageName/errorMsg not extracted → can't reuse Stage config | Medium |

---

## 4. Viscosity

> **Definition**: Doing the right thing (maintaining design) is harder than doing the wrong thing (hacking)

### Contributing Smells

| Smell | Evidence | Impact |
|-------|----------|--------|
| Missing Encapsulation | Unity Stage pattern not encapsulated → copy-paste easier | Medium |
| Duplicated Code | stageName/errorMsg pattern 5x → duplication pattern established | Medium |

---

## 5. Needless Complexity

> **Definition**: Over-engineering for features not currently needed
>
> **Symptom**: "I might need this later" (YAGNI violation)

### Evidence

No clear evidence of over-engineering found in DLXJenkins/Jenkinsfile.

---

## 6. Needless Repetition

> **Definition**: Code that could be unified through abstraction is duplicated in multiple places
>
> **Symptom**: "Same code in multiple places" (DRY violation)

### Contributing Smells

| Smell | Evidence | Impact |
|-------|----------|--------|
| Duplicated Code | stageName/errorMsg pattern (5x) | High |
| Duplicated Code | `sh 'mkdir -p ...'` pattern (4x) | Medium |
| Missing Encapsulation | Same patterns repeated without extraction | High |

---

## 7. Opacity

> **Definition**: Code is difficult to understand and intent is unclear
>
> **Symptom**: "What does this code do?"

### Evidence (Code Review)

| Issue | Evidence | Impact |
|-------|----------|--------|
| Undefined variable usage | `FOLDER_NAME`, `TICKET_NUMBER` used but definition unclear (set in `generalUtil.initializeEnvironment`) | Medium |
| Complex nesting | Linting Stage 4-level if-else nesting (lines 129-166) | Medium |

---

[← SRP Analysis](01-srp-violation-analysis.md) | [Software Smells →](02-software-smells-analysis.md)