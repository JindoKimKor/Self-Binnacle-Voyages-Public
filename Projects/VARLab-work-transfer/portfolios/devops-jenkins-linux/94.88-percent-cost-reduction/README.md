# 94.88% CI/CD Infrastructure Cost Reduction

![Cloud-Native Unity CI/CD Infographic](cloud-native-cicd-infographic.png)

> **Context:** Unity CI/CD build environment isolation at VARLab
>
> **Problem:** Unity Editor 100% CPU usage → server crashes on concurrent builds
>
> **Solution:** Azure Batch + Spot VMs for on-demand execution
>
> **Result:** 94.88% infrastructure cost reduction ($618 → $32 for 56 days)
>
> **Keywords:** Azure Batch, Spot VMs, Docker, Unity, Cost Optimization

---

## Key Achievements

| Metric | Before | After |
|--------|--------|-------|
| Build environment | Shared CI/CD server | Isolated cloud containers |
| Concurrent builds | Server crash risk | Parallel execution safe |
| Cost model | 24/7 VM running | Pay-per-use |
| Cost reduction | - | **94.88%** |

---

## Problem Evolution & Solutions

### Phase 1: The Initial Crisis (June 2024)

**Problem:** Unity Editor provides no CPU usage control during builds. When 2+ projects build simultaneously, the CI/CD server crashes.

**Root Cause Analysis:**
- Git clone → Unity Editor project open: **8-9 minutes** (initial compile)
- Unit testing: ~1 minute
- Build optimization phase: **2-3+ minutes**
- All phases consume 100% available CPU

**Solution:** Trade-off approach
- Maintain project files & artifacts (skip "from scratch" builds)
- Set optimization level to 0 (skip optimization phase)
- **Result:** Reduced initial compile time from 10 min → 1 min, prevented server crashes

**Trade-off Cost:** Violated CI/CD best practice of "clean builds from scratch"

> See [Stabilized Crashed Build Server](../../devops-jenkins-windows/stabilized-crashed-build-server/README.md) for detailed documentation of Phase 1.

---

### Phase 2: Containerization + Build Optimization (May 2025)

**Goal:** Eliminate the trade-off from Phase 1 - enable clean builds without sacrificing speed

**Solution 1:** Docker containerization with CPU allocation
- Successfully containerized Unity Editor builds
- Applied CPU limits per container
- Enabled concurrent builds without crashes

**Solution 2:** PID-level profiling + Unity settings optimization
- Analyzed CPU usage at 5-second intervals for all processes during build
- Identified bottleneck: WebGL build (13-14 min on 8-core container)
- Tuned Unity project settings: `emscriptenArgs`, `Il2CppCodeGeneration`, `managedStrippingLevel`, etc.

**Result:**
| Metric | Before | After |
|--------|--------|-------|
| Clean build time | 13-14 min | 7.4 min (**47% faster**) |
| Build size | 146 MB | 95.2 MB (**35% smaller**) |

> See [PID-Level Profiling & Build Optimization (PDF)](Build-Optimization-PID-Level-Profiling.pdf) for detailed analysis.

**Limitation:** Still running on the same CI/CD server

---

### Phase 3: Cloud-Native Architecture (June 2025)

**Proactive Initiative:** Docker containerization in Phase 2 proved builds could run in isolated environments. This raised a question: if containers can run independently, why not leverage cloud infrastructure for parallel, on-demand execution?

**Solution:** Azure Batch + Spot VMs
- Completely separated Unity build/test environment from CI/CD server
- On-demand ephemeral containers
- Pay only for actual compute time

**Result:**

| Strategy | Cost (56 days) | vs Always-On |
|----------|----------------|--------------|
| Always-On VM (24/7) | $618.24 | baseline |
| Deallocated VM (job-triggered) | $144.60 | -76.6% |
| **Azure Batch + Spot VMs** | **$31.64** | **-94.88%** |

> See [Cloud-Native Architecture & Cost Benchmarking (PDF)](Cloud-Native-Architecture-Cost-Benchmarking.pdf) for detailed analysis.
>
> Analysis Period: May 5 - June 29, 2025 (56 days, 37 active days) | Projects: 2 Unity VR projects (855 CI jobs, 166 CD jobs)

---

## Architecture Comparison

### Before: Coupled Architecture
```
┌─────────────────────────────────────┐
│         CI/CD Server (VM)           │
│  ┌─────────────┐ ┌─────────────┐   │
│  │   Jenkins   │ │Unity Editor │   │
│  │ (Orchestr.) │ │  (Build)    │   │
│  └─────────────┘ └─────────────┘   │
│         CPU: 100% during builds     │
└─────────────────────────────────────┘
```

### After: Decoupled Architecture
```
┌─────────────────┐     ┌─────────────────────────┐
│  CI/CD Server   │     │    Azure Batch Pool     │
│  ┌───────────┐  │     │  ┌─────┐ ┌─────┐       │
│  │  Jenkins  │──┼────▶│  │Spot │ │Spot │ ...   │
│  │(Orchestr.)│  │     │  │ VM  │ │ VM  │       │
│  └───────────┘  │     │  └─────┘ └─────┘       │
│   (lightweight) │     │   (on-demand, isolated) │
└─────────────────┘     └─────────────────────────┘
```

---

## Additional Benefits

- **Isolated Build Environments:** Each job runs in clean, separate container
- **Reliable Results:** Consistent conditions every time
- **Stronger Security:** Jenkins no longer needs direct access to project files
- **Parallel Execution:** Tests and builds can run simultaneously

