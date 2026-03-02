# Retrospective Analysis: From 5 Monolithic Pipelines to 4-Layer Architecture

![Refactoring Before After](resources/refactoring-before-after.png)

| | |
|---|---|
| **What I did** | Transformed 5 monolithic pipelines (41% duplication) into 4-layer architecture with centralized libraries |
| **How it emerged** | Felt the pain - organized by domain naturally - patterns emerged |
| **Post-analysis** | Mapped my solution to industry concepts (Software Smells, DDD patterns, GoF Design Patterns) |
| **Documentation** | Problem analysis, pattern identification, architecture rationale |

> **Note on 37% vs 41%:** If you came from my resume, you may have seen "37% duplication." That figure was from an earlier baseline (`54479b2`, 2025-02-21). After detailed commit history analysis, `74fc356` (2025-03-20) was identified as the accurate "before refactoring" state, showing **41% duplication**. The increase itself demonstrates the architecture's High Viscosity problem.

---

## Purpose

This portfolio is a **post-refactoring analysis** of intuitive problem-solving done during VARLab Co-op.

| What I Did | What This Document Does |
|------------|------------------------|
| Refactored 5 monolithic pipelines into 4-Layer Architecture | Classify and define those intuitive fixes using industry conventions |
| Designed 3-Level Logger System | Analyze why the design worked and how it integrates with the architecture |

**Goal:** Transform experience-based understanding into systematic, reusable knowledge

- Learn how problems I "felt" are formally named (Software Smells, Anti-patterns)
- Validate solutions against established principles (SOLID, Design Patterns)
- Understand integration points that made the Logger System possible

---

## If I Had This Analysis Then...

### Before (During Refactoring)

When I proposed this refactoring to my supervisor, I could only say:

> "The code is messy. There's a lot of copy-paste. It's hard to maintain. I think we should restructure it."

I knew something was wrong. I felt the pain every time I had to modify multiple files for a single change. But I couldn't articulate **why** it was problematic or **how bad** it actually was.

### After (With This Analysis)

If I had this analysis back then, I could have presented:

> "We have **41% code duplication** across 5 pipelines. A single change to `sendBuildStatus` requires modifications in **18 locations across 6 files**. We're making **113 external calls** to 12 different systems with no abstraction layer, making the code untestable. In the past month alone, duplication increased from 37% to 41%, showing the architecture's **High Viscosity** is causing duplication to grow naturally."

Instead of "it feels messy," I could have shown concrete numbers. Instead of "it's hard to maintain," I could have explained **Shotgun Surgery** with specific examples. Instead of "we should fix it," I could have demonstrated the **ROI degradation** where 10-minute tasks were taking hours.

### The Difference

| Aspect | Before | After |
|--------|--------|-------|
| Problem Description | "Code is messy" | "41% duplication, 18-location Shotgun Surgery" |
| Justification | "I feel it's hard to maintain" | "Duplication increased 4% in 1 month (High Viscosity)" |
| Scope | "A lot of copy-paste" | "113 external calls, 12 types, untestable" |
| Urgency | "We should fix it sometime" | "10-20 min tasks - hours, ROI degradation" |

This analysis transforms intuition into evidence. It provides the vocabulary and metrics needed to communicate technical debt to stakeholders who may not see the code daily.

---

## What Would You Like to Know?

### 🔍 Problem Analysis

> **Q: Want to see how I analyzed a single file?**
>
> - [SRP Violation Analysis](problem-analysis/01-generalHelper/01-srp-violation-analysis.md)
> - [Software Smells Analysis](problem-analysis/01-generalHelper/02-software-smells-analysis.md)
> - [Design Smells Analysis](problem-analysis/01-generalHelper/03-design-smells-symptoms.md)
>
> Analysis flow: Define SRP criteria - Analyze responsibility per function/module - Identify Software Smells

> **Q: Want the overall problem analysis summary?**
>
> - [problem-analysis-overview.md](problem-analysis/problem-analysis-overview.md)

> **Q: Want the detailed analysis?**
>
> - [detailed-analysis.md](problem-analysis/detailed-analysis.md) - Synthesized findings (Symptoms, Patterns, Duplication)
> - [architecture-smells-analysis.md](problem-analysis/architecture-smells-analysis.md) - System-level analysis
> - [DRY-violation-analysis.md](problem-analysis/DRY-violation-analysis.md) - Cross-file duplication patterns

### 🛠️ Solution

> **Q: Want to see the final architecture and solution overview?**
>
> - [solution-overview.md](problem-solving/solution-overview.md)

> **Q: Want to know which design principles were applied?**
>
> - [solution-by-layer.md](problem-solving/solution-by-layer.md) - 4-Layer Architecture analysis
> - [solution-by-feature.md](problem-solving/solution-by-feature.md) - Logger System, Shell Libraries analysis

> **Q: Want the step-by-step implementation process?**
>
> - [solution-overview.md](problem-solving/solution-overview.md) - Phase 0~4 overview with links

### 📄 Supplement

> **Q: Want the DDD perspective analysis?**
>
> - [domain-driven-analysis.md](problem-solving/domain-driven-analysis.md)

> **Q: Want to see the Pull Request documentation?**
>
> - [pull-request-documentation.pdf](problem-solving/pull-request-documentation/pull-request-documentation.pdf)

---

## Project Overview

### Background

- 14 months of accumulated Technical Debt
- 5 monolithic pipelines (41% duplication, untestable)
- Discovered Jenkins Global Trusted Shared Library feature at month 13
- Performed refactoring over 54 days (Library setup 35 days, Core refactoring ~2 weeks)

### Timeline

| Milestone | Date | Commit | Repository |
|-----------|------|--------|------------|
| Initial commit (Windows) | 2023-12-17 | `e9d8028` | devops-jenkins-windows |
| Migration to Linux | 2025-01-07 | `5a59d45` | devops-jenkins-linux |
| Baseline (Before refactoring) | 2025-03-20 | `74fc356` | devops-jenkins-linux |
| **Technical Debt Period** | **~14 months** | | |
| Refactoring complete | 2025-05-12 | `ff74ac8` | devops-jenkins-linux |

> Repository started in Windows environment and migrated to Linux.
> Initial commit (2023-12-17) - Baseline (2025-03-20) = ~14 months of accumulated Technical Debt

---

## Document Structure

```
retrospective-analysis-from-5-monolithic-pipelines-to-4-layer-architecture/
│
├── README.md                           # ← This document (entry point)
│
├── problem-analysis/                   # Problem Analysis
│   ├── problem-analysis-overview.md    # Problem summary (★ Start here)
│   ├── detailed-analysis.md            # Synthesized findings
│   ├── architecture-smells-analysis.md # System-level analysis
│   ├── DRY-violation-analysis.md       # Cross-file duplication
│   │
│   ├── 01-generalHelper/               # Per-file analysis
│   │   ├── 01-srp-violation-analysis.md
│   │   ├── 02-software-smells-analysis.md
│   │   └── 03-design-smells-symptoms.md
│   ├── 02-jsHelper/
│   ├── 03-unityHelper/
│   ├── 04~08-Jenkinsfiles/
│   │
│   └── pipeline-sequence-diagrams/     # Pipeline flow analysis
│       ├── domain-mapping.md
│       └── dlx-ci.md, dlx-cd.md, js-ci.md, js-cd.md, jenkins-ci.md
│
├── problem-solving/                    # Solution
│   ├── solution-overview.md            # Entry point for solution docs
│   ├── solution-by-layer.md            # 4-Layer Architecture analysis
│   ├── solution-by-feature.md          # Logger System, Shell Libraries
│   ├── logger-system-design-integration.md  # Logger design document
│   ├── domain-driven-analysis.md       # DDD analysis (supplement)
│   ├── pull-request-documentation.pdf  # PR attachment
│   └── phase-0~4/                      # Step-by-step changelogs
│
└── resources/                          # Images
    └── architecture-overview.png, stage-logger-*.png
```

---

## Reference

- [Jenkins Shared Libraries Documentation](https://www.jenkins.io/doc/book/pipeline/shared-libraries/)