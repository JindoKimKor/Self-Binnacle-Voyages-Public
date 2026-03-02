# Stabilized Crashed Unity Build Server

![Build Server Stabilization Infographic](build-server-stabilization-infographic.png)

> **Context:** Unity CI/CD server stability crisis at VARLab (June 2024)
>
> **Problem:** VM crashes when 2-3 pipelines run simultaneously due to Unity Editor's 100% CPU usage
>
> **Solution:** Trade-off approach - shared project files + optimization skip
>
> **Result:** Server stabilized, concurrent pipelines supported
>
> **Byproduct:** 80% faster builds, 90% CPU reduction

---

## The Crisis

**Symptom:** CI/CD VM becomes extremely slow or shuts down when 2-3 PR pipelines run simultaneously.

**Root Cause Analysis:**

| Process | CPU Impact | Build Time* |
|---------|------------|-------------|
| Unity Editor initial compile (30,000+ files import) | 100% | ~10 min |
| wasm-opt.exe (WebAssembly optimization) | 50-100% | 2-3 min |
| IL2CPP.exe (C# to Wasm conversion) | 70-90% | 1-2 sec |

*Build time varies by project size and machine resources. CPU always consumes all available resources.

**Key Insight:** Unity Editor provides no CPU throttling option. It consumes all available resources.

---

## Solution: Trade-off Approach

### 1. Single Project Files for All Branches

**Before:** Each branch creates new folder → git clone → Unity initial compile (10 min)

**After:** All branches share single project folder → skip initial compile

| Stage | Before (new branch) | After |
|-------|---------------------|-------|
| EditMode Test | ~10 min | < 1 min |
| Build Project | ~10 min | 1-5 min |

**Validation:** Tested with 7 branches (AMB383, AMB777, AMB635, AMB772, AMB452, AMB789, AMB784) - no errors switching between branches.

> See [JIRA Ticket (PDF)](JIRA-Ticket-Implement-single-project-files-for-all-branches.pdf) | Git: [`33b5daf`](https://github.com/JindoKimKor/devops-jenkins-windows/commit/33b5daf)

### 2. WebAssembly Optimization Level = 0

**Before:** wasm-opt.exe runs at 50-100% CPU for 2-3 minutes during CI builds

**After:** Set optimization level to 0 for CI pipeline (CD pipeline keeps optimization)

| Metric | Before | After |
|--------|--------|-------|
| Peak CPU (wasm-opt.exe) | 50-100% | 0% (skipped) |
| Sustained CPU | 70-90% | 10-20% |

**Rationale:** CI pipeline only needs to verify build success/failure, not produce optimized artifacts.

> See [Pull Request (PDF)](Pull-Request-Reduce-CPU-Usage-On-CI-Pipeline.pdf) | Git: [`909d0db`](https://github.com/JindoKimKor/devops-jenkins-windows/commit/909d0db)
>
> For PID-level profiling data demonstrating how optimization level adjustments impact build time, see [Build Time Reduction with Optimized Unity Settings (PDF)](Build-Time-Reduction-with-Optimized-Unity-Settings.pdf). This supplementary reference was created later but validates the approach.

---

## Results

| Metric | Improvement |
|--------|-------------|
| Build time | **80% faster** |
| CPU usage | **90% reduction** |
| Server stability | No more crashes |
| Concurrent pipelines | Safely supported |

**Byproduct:** Significant disk space savings by not creating duplicate project files.

---

## Trade-off Accepted

This solution violates CI/CD best practice of "clean builds from scratch":
- Project files and artifacts are retained between builds
- Builds are not fully isolated

**Why this was acceptable:**
- Unity Editor limitation - no workaround exists
- Modifying Unity Editor internals would violate software compliance
- The trade-off was later resolved with containerization and cloud architecture (see [94.88% Cost Reduction](../../devops-jenkins-linux/94.88-percent-cost-reduction/README.md))

---

## Timeline (Git Commits)

| Date | Commit | Description |
|------|--------|-------------|
| Jun 13, 2024 | [`33b5daf`](https://github.com/JindoKimKor/devops-jenkins-windows/commit/33b5daf) | Single project files for all branches |
| Jun 19, 2024 | [`daa5216`](https://github.com/JindoKimKor/devops-jenkins-windows/commit/daa5216) | More RAM, less CPU memory setting |
| Jun 24, 2024 | [`51d4d74`](https://github.com/JindoKimKor/devops-jenkins-windows/commit/51d4d74) | Test with enhanced setting (less CPU, more RAM) |
| Jun 24, 2024 | [`d4c9807`](https://github.com/JindoKimKor/devops-jenkins-windows/commit/d4c9807) | More memory for il2cpp.exe and wasm-opt.exe |
| Jun 25, 2024 | [`a35e944`](https://github.com/JindoKimKor/devops-jenkins-windows/commit/a35e944) | Original CPU usage setting |
| Jun 25, 2024 | [`f619a90`](https://github.com/JindoKimKor/devops-jenkins-windows/commit/f619a90) | emscripten compiler optimization low setting |
| Jun 26, 2024 | [`909d0db`](https://github.com/JindoKimKor/devops-jenkins-windows/commit/909d0db) | Reduce CPU Usage on CI Pipeline |
