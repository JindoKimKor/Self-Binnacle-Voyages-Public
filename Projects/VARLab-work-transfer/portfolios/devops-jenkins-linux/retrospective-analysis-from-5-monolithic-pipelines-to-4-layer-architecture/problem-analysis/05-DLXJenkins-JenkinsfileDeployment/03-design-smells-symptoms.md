[← SRP Analysis](01-srp-violation-analysis.md) | [Software Smells →](02-software-smells-analysis.md)

# DLXJenkins/JenkinsfileDeployment - Design Smells Symptoms Analysis

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
| Shotgun Surgery | stageName/errorMsg change → 4 locations | High |
| Shotgun Surgery | SSH/SCP pattern change → 6 locations (2 servers × 3 commands) | High |
| Primitive Obsession | Server path hardcoded (`/var/www/html/${FOLDER_NAME}` 4x) | Medium |

---

## 2. Fragility

> **Definition**: Modifying one place breaks conceptually unrelated places

### Contributing Smells

| Smell | Evidence | Risk |
|-------|----------|------|
| Shotgun Surgery | Miss one of 4 stageName locations → Stage failure | High |
| Shotgun Surgery | Update SSH option in LTI only, forget eConestoga → inconsistent deployment | High |
| Divergent Change | 5 change reasons mixed → unexpected side effects | Medium |

---

## 3. Immobility

> **Definition**: Difficult to extract useful parts for reuse in other systems/modules

### Contributing Smells

| Smell | Evidence | Impact |
|-------|----------|--------|
| Multifaceted Abstraction | 5 concerns mixed (Unity Stage, Git, File System, SSH/SCP, Linting) | High |
| Missing Abstraction | Server config scattered → can't reuse deployment logic | High |

---

## 4. Viscosity

> **Definition**: Doing the right thing (maintaining design) is harder than doing the wrong thing (hacking)

### Contributing Smells

| Smell | Evidence | Impact |
|-------|----------|--------|
| Missing Encapsulation | Deployment pattern not encapsulated → copy-paste for new server easier | High |
| Missing Encapsulation | Unity Stage pattern not encapsulated → copy-paste easier | Medium |
| Duplicated Code | SSH/SCP pattern 2x, stageName 4x → duplication pattern established | High |

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
| Duplicated Code | SSH/SCP deployment pattern (LTI + eConestoga = 2x, 3 commands each) | High |
| Duplicated Code | stageName/errorMsg pattern (4x) | Medium |
| Missing Encapsulation | Same patterns repeated without extraction | High |

---

## 7. Opacity

> **Definition**: Code is difficult to understand and intent is unclear
>
> **Symptom**: "What does this code do?"

### Evidence (Code Review)

| Issue | Evidence | Impact |
|-------|----------|--------|
| Undocumented environment variables | `env.SSH_KEY`, `env.DLX_WEB_HOST_URL`, `env.DLX_ECONESTOGA_URL` used without documentation | Medium |
| Inline Git commands | `git clone`, `checkout`, `reset`, `pull` sequence without explanation | Low |
| Inline shell commands | `sh` calls scattered across 7 stages (16 total) | Medium |

---

[← SRP Analysis](01-srp-violation-analysis.md) | [Software Smells →](02-software-smells-analysis.md)