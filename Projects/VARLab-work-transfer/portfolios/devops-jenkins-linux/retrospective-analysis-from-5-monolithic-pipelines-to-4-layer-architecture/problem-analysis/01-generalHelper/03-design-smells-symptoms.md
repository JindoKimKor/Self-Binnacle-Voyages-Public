[← SRP Analysis](01-srp-violation-analysis.md) | [Software Smells →](02-software-smells-analysis.md)

# groovy/generalHelper.groovy - Design Smells Symptoms Analysis

> **Source**: Martin, R.C. (2000). *Design Principles and Design Patterns*
>
> This document analyzes Martin's 7 Design Symptoms using evidence from:
> - [SRP Violation Analysis](01-srp-violation-analysis.md): Cohesion metrics, multi-responsibility functions
> - [Software Smells Analysis](02-software-smells-analysis.md): Code Smells (Fowler), Design Smells (Suryanarayana)
> - [DRY Violation Analysis](../DRY-violation-analysis.md): Duplicated patterns across files
> - Direct code review: Readability, naming, complexity issues

---

## 1. Rigidity

> **Definition**: Changing one place requires cascading changes to other places

### Contributing Smells

| Smell | Evidence | Impact |
|-------|----------|--------|
| Shotgun Surgery | `sendBuildStatus` change → 18 locations across 5 pipelines | High |
| Primitive Obsession | `"/var/www/html"` change → 11 locations | High |
| Missing Encapsulation | SSH pattern change → 6 locations | Medium |

---

## 2. Fragility

> **Definition**: Modifying one place breaks conceptually unrelated places

### Contributing Smells

| Smell | Evidence | Risk |
|-------|----------|------|
| Shotgun Surgery | Miss one of 18 locations → build breaks | High |
| Missing Encapsulation | Update SSH pattern in 3 places, forget 3 others → runtime failure | Medium |
| Primitive Obsession | Update path in 8 places, forget 3 others → deployment failure | Medium |

---

## 3. Immobility

> **Definition**: Difficult to extract useful parts for reuse in other systems/modules

### Contributing Smells

| Smell | Evidence | Impact |
|-------|----------|--------|
| Hub-like Modularization | 5 pipelines depend + 43 outgoing calls (Git 18, Linux 11, SSH 6, SCP 4, Python 2, curl 2) | High |
| Insufficient Modularization | 656 lines, 21 functions, 7 domains in single file | High |
| Multifaceted Abstraction | 7 responsibilities mixed → extracting one brings others | High |

---

## 4. Viscosity

> **Definition**: Doing the right thing (maintaining design) is harder than doing the wrong thing (hacking)
>
> **Symptom**: "It's faster to just copy-paste than to do it properly"

### Contributing Smells

| Smell | Evidence | Impact |
|-------|----------|--------|
| Missing Encapsulation | SSH/SCP/Git patterns not encapsulated → copy-paste easier than creating helper | Medium |
| Primitive Obsession | `"/var/www/html"` hardcoded 11x → copy existing easier than creating constant | Medium |
| Duplicated Code | SSH (6x), SCP (4x), git fetch (3x) → duplication pattern already established | Medium |

---

## 5. Needless Complexity

> **Definition**: Over-engineering for features not currently needed
>
> **Symptom**: "I might need this later" (YAGNI violation)

### Evidence

No clear evidence of over-engineering found in generalHelper.groovy.

> **Note**: Dead Code (`getCurrentCommitHash`, `closeLogfiles`) exists but appears to be legacy code rather than over-engineering.

---

## 6. Needless Repetition

> **Definition**: Code that could be unified through abstraction is duplicated in multiple places
>
> **Symptom**: "Same code in multiple places" (DRY violation)

### Contributing Smells

| Smell | Evidence | Impact |
|-------|----------|--------|
| Duplicated Code | SSH command pattern (6x), SCP pattern (4x), chmod/chown pattern (4x), `git fetch origin` (3x) | High |
| Missing Encapsulation | Same patterns repeated without helper function extraction | High |

---

## 7. Opacity

> **Definition**: Code is difficult to understand and intent is unclear
>
> **Symptom**: "What does this code do?"

### Evidence (Code Review)

| Issue | Evidence | Impact |
|-------|----------|--------|
| Counter-intuitive variable name | `projectExists = sh(..., returnStatus: true)` - 0 = exists | Medium |
| Function name mismatch | `parseJson()` returns fixed data, `isBranchUpToDateWithMain(destinationBranch)` | Medium |
| Complex nesting | 3-level `if-else` nesting (lines 70-107) | Medium |
| Complex retry loop | `for` loop + `break`/`continue` in `checkQualityGateStatus` (94 lines) | High |
| Magic string | `/[A-Za-z]+-[0-9]+/` regex undocumented | Low |
| Complex pipe command | `git remote show \| grep \| awk` | Low |

---

[← SRP Analysis](01-srp-violation-analysis.md) | [Software Smells →](02-software-smells-analysis.md)
