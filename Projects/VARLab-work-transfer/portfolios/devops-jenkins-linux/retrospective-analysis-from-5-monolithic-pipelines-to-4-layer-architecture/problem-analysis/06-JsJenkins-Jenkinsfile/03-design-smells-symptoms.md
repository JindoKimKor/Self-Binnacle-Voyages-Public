[← SRP Analysis](01-srp-violation-analysis.md) | [Software Smells →](02-software-smells-analysis.md)

# JsJenkins/Jenkinsfile - Design Smells Symptoms Analysis

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
| Shotgun Surgery | Adding new report type → 6+ locations | High |
| Duplicated Code | Server/Client pattern change → 2 locations (40 lines each) | High |
| Primitive Obsession | Report types hardcoded (`'server'`, `'client'` 4x) | Medium |

---

## 2. Fragility

> **Definition**: Modifying one place breaks conceptually unrelated places

### Contributing Smells

| Smell | Evidence | Risk |
|-------|----------|------|
| Shotgun Surgery | Miss one of 6 report locations → incomplete report | High |
| Duplicated Code | Update Server pattern, forget Client → inconsistent behavior | High |
| Divergent Change | 4 change reasons mixed → unexpected side effects | Medium |

---

## 3. Immobility

> **Definition**: Difficult to extract useful parts for reuse in other systems/modules

### Contributing Smells

| Smell | Evidence | Impact |
|-------|----------|--------|
| Multifaceted Abstraction | 4 concerns mixed (test, web server, Bitbucket, SonarQube) | High |
| Insufficient Modularization | Unit Testing stage 112 lines, 7 responsibilities | High |
| Missing Abstraction | Report config scattered → can't reuse report logic | Medium |

---

## 4. Viscosity

> **Definition**: Doing the right thing (maintaining design) is harder than doing the wrong thing (hacking)

### Contributing Smells

| Smell | Evidence | Impact |
|-------|----------|--------|
| Missing Encapsulation | Server/Client pattern not encapsulated → copy-paste for new type easier | High |
| Duplicated Code | Server/Client 40 lines × 2 → duplication pattern established | High |
| Long Method | Unit Testing 112 lines → adding to existing easier than refactoring | Medium |

---

## 5. Needless Complexity

> **Definition**: Over-engineering for features not currently needed
>
> **Symptom**: "I might need this later" (YAGNI violation)

### Evidence (Code Review)

| Issue | Evidence | Impact |
|-------|----------|--------|
| Commented-out code | `// JENKINS_API_KEY = credentials('jenkins-api-key')` (line 52) | Low |
| Incorrect comment | `// Unity Setup` in JS project (lines 63-64) | Low |

---

## 6. Needless Repetition

> **Definition**: Code that could be unified through abstraction is duplicated in multiple places
>
> **Symptom**: "Same code in multiple places" (DRY violation)

### Contributing Smells

| Smell | Evidence | Impact |
|-------|----------|--------|
| Duplicated Code | Server/Client report handling pattern (40 lines × 2 = 80 lines) | High |
| Duplicated Code | `publishTestResultsHtmlToWebServer` calls (2x) | Medium |
| Duplicated Code | DEBUG_MODE branch (2x) | Medium |
| Missing Encapsulation | Same patterns repeated without extraction | High |

---

## 7. Opacity

> **Definition**: Code is difficult to understand and intent is unclear
>
> **Symptom**: "What does this code do?"

### Evidence (Code Review)

| Issue | Evidence | Impact |
|-------|----------|--------|
| Undefined variable | `destinationBranch` used but not defined (line 80), should be `DESTINATION_BRANCH` | High |
| Complex nesting | Unit Testing stage 3-level if nesting (lines 164-244) | Medium |
| Long Method | Unit Testing 112 lines with 7 responsibilities mixed | Medium |

---

[← SRP Analysis](01-srp-violation-analysis.md) | [Software Smells →](02-software-smells-analysis.md)