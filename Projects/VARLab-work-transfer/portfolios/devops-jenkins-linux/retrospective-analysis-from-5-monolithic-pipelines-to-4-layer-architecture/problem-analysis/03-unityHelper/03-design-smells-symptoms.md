<!--
Analysis Log:

[Why Design Smells Symptoms for unityHelper?]
- Martin's 7 Symptoms show practical impact of Code/Design Smells
- Connects technical problems to maintainability consequences

[Relationship to Previous Analysis]
- SRP Analysis: 50% cohesion, runUnityBatchMode has 7+ responsibilities
- Software Smells: Shotgun Surgery (7 locations), Long Method (126 lines), Missing Hierarchy
- This document synthesizes those findings into observable symptoms

[Key Finding]
- Rigidity and Viscosity are HIGH due to Stage-specific conditional branches
- "Adding new Stage requires 7 modifications" = High Rigidity
- "Copying conditionals is easier than Strategy pattern" = High Viscosity
-->

[← SRP Analysis](01-srp-violation-analysis.md) | [Software Smells →](02-software-smells-analysis.md)

# groovy/unityHelper.groovy - Design Smells Symptoms Analysis

> **Source**: Martin, R.C. (2000). *Design Principles and Design Patterns*
>
> This document analyzes Martin's 7 Design Symptoms using evidence from:
> - [SRP Violation Analysis](01-srp-violation-analysis.md): Cohesion metrics, multi-responsibility functions
> - [Software Smells Analysis](02-software-smells-analysis.md): Code Smells (Fowler), Design Smells (Suryanarayana)
> - Direct code review: Readability, naming, complexity issues

---

## 1. Rigidity

> **Definition**: Changing one place requires cascading changes to other places

### Contributing Smells

| Smell | Evidence | Impact |
|-------|----------|--------|
| Shotgun Surgery (Cross-file) | `runUnityStage` change → 9 locations across 2 pipelines | High |
| Shotgun Surgery (Within-file) | Adding new Stage → 7 locations | High |
| Switch Statements | Stage-specific conditionals in 9 locations | High |

---

## 2. Fragility

> **Definition**: Modifying one place breaks conceptually unrelated places

### Contributing Smells

| Smell | Evidence | Risk |
|-------|----------|------|
| Shotgun Surgery | Miss one of 7 Stage locations → inconsistent behavior | High |
| Missing Encapsulation | Update Stage logic in 6 places, forget 1 → runtime failure | Medium |
| Switch Statements | Change one conditional pattern, forget others → silent failure | Medium |

---

## 3. Immobility

> **Definition**: Difficult to extract useful parts for reuse in other systems/modules

### Contributing Smells

| Smell | Evidence | Impact |
|-------|----------|--------|
| Multifaceted Abstraction | 3 domains mixed (Unity CLI 6, Unity Installation 1, Bitbucket 1) | Medium |
| Missing Hierarchy | Stage conditionals tightly coupled → extracting one brings all | Medium |

---

## 4. Viscosity

> **Definition**: Doing the right thing (maintaining design) is harder than doing the wrong thing (hacking)

### Contributing Smells

| Smell | Evidence | Impact |
|-------|----------|--------|
| Missing Encapsulation | Stage conditionals not encapsulated → copy-paste easier | High |
| Missing Hierarchy | Strategy pattern proper but complex → copying conditionals faster | High |
| Switch Statements | 9 locations already duplicated → pattern established | High |

---

## 5. Needless Complexity

> **Definition**: Over-engineering for features not currently needed
>
> **Symptom**: "I might need this later" (YAGNI violation)

### Evidence

No clear evidence of over-engineering found in unityHelper.groovy.

---

## 6. Needless Repetition

> **Definition**: Code that could be unified through abstraction is duplicated in multiple places
>
> **Symptom**: "Same code in multiple places" (DRY violation)

### Contributing Smells

| Smell | Evidence | Impact |
|-------|----------|--------|
| Switch Statements | `[EDIT_MODE, PLAY_MODE].contains(stageName)` (3x), `stageName == COVERAGE` (2x), `[WEBGL, RIDER].contains(stageName)` (2x) | High |
| Missing Hierarchy | Same Stage logic repeated instead of encapsulated in Stage objects | High |

---

## 7. Opacity

> **Definition**: Code is difficult to understand and intent is unclear
>
> **Symptom**: "What does this code do?"

### Evidence (Code Review)

| Issue | Evidence | Impact |
|-------|----------|--------|
| Complex nested condition | `if (exitCode == 0) ... else if (CI_PIPELINE) ...` 3-level nesting (lines 98-105) | Medium |
| Complex Map structure | `logConfig` Map with Stage-specific settings (lines 139-160) | Medium |
| Complex JSON parsing | `m_Dictionary.m_DictionaryValues` path in Settings.json (lines 320-340) | Medium |

---

[← SRP Analysis](01-srp-violation-analysis.md) | [Software Smells →](02-software-smells-analysis.md)