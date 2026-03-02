<!--
Analysis Log:

[Why Design Smells Symptoms for jsHelper?]
- Martin's 7 Symptoms show practical impact of Code/Design Smells
- Connects technical problems to maintainability consequences

[Relationship to Previous Analysis]
- SRP Analysis: 50% cohesion, 3-responsibility function
- Software Smells: Shotgun Surgery (3 locations), Missing Encapsulation
- This document synthesizes those findings into observable symptoms

[Inference Approach]
- Each symptom is inferred from Code Smells + Design Smells evidence
- Direct code review for Opacity (can't be inferred from smells alone)
-->

[← SRP Analysis](01-srp-violation-analysis.md) | [Software Smells →](02-software-smells-analysis.md)

# groovy/jsHelper.groovy - Design Smells Symptoms Analysis

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
| Shotgun Surgery | `testingDirs` format change → 3 functions | Low |
| Primitive Obsession | `"Testing directories don't exist."` (3x) | Low |
| Missing Encapsulation | `testingDirs.split(',')` pattern (3x) | Low |

---

## 2. Fragility

> **Definition**: Modifying one place breaks conceptually unrelated places

### Contributing Smells

| Smell | Evidence | Risk |
|-------|----------|------|
| Shotgun Surgery | Miss one of 3 `testingDirs.split()` locations → inconsistent behavior | Low |
| Missing Encapsulation | Update validation in 2 places, forget 1 → silent failure | Low |

---

## 3. Immobility

> **Definition**: Difficult to extract useful parts for reuse in other systems/modules

### Contributing Smells

| Smell | Evidence | Impact |
|-------|----------|--------|
| Multifaceted Abstraction | 4 domains mixed (Node.js/npm, File System, Utility, Logging) | Medium |
| Duplicated Code | `logMessage` copy from generalHelper → can't share | Low |

---

## 4. Viscosity

> **Definition**: Doing the right thing (maintaining design) is harder than doing the wrong thing (hacking)

### Contributing Smells

| Smell | Evidence | Impact |
|-------|----------|--------|
| Missing Encapsulation | `testingDirs.split(',')` not encapsulated → copy-paste easier | Medium |
| Primitive Obsession | Hardcoded strings → copy existing easier than creating constant | Low |
| Duplicated Code | Validation pattern (3x) → duplication pattern already established | Medium |

---

## 5. Needless Complexity

> **Definition**: Over-engineering for features not currently needed
>
> **Symptom**: "I might need this later" (YAGNI violation)

### Evidence

No clear evidence of over-engineering found in jsHelper.groovy.

---

## 6. Needless Repetition

> **Definition**: Code that could be unified through abstraction is duplicated in multiple places
>
> **Symptom**: "Same code in multiple places" (DRY violation)

### Contributing Smells

| Smell | Evidence | Impact |
|-------|----------|--------|
| Duplicated Code | `logMessage` exact copy from generalHelper | Medium |
| Duplicated Code | `testingDirs.split(',') as List<String>` pattern (3x) | Medium |
| Duplicated Code | Directory existence validation pattern (2x) | Low |

---

## 7. Opacity

> **Definition**: Code is difficult to understand and intent is unclear
>
> **Symptom**: "What does this code do?"

### Evidence (Code Review)

| Issue | Evidence | Impact |
|-------|----------|--------|
| Hidden data structure | `testingDirs: String` hides that it's a comma-separated list | Medium |
| Counter-intuitive flow | npm audit failure continues silently (warning only) | Medium |
| Name-message mismatch | Message says "jest" but calls `npm run test` | Low |
| Incomplete implementation | Windows `bat()` ignores `workingDir` parameter | Medium |
| Counter-intuitive name | `versionCompare` return meaning unclear | Low |

---

[← SRP Analysis](01-srp-violation-analysis.md) | [Software Smells →](02-software-smells-analysis.md)