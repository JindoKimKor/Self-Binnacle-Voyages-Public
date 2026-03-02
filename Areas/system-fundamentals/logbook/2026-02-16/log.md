---
date: 2026-02-16
---

## Log (Monitoring)

> **Time**: 12:12 AM ~ 12:25 AM (late night session)

### What did I actually do?
- (00:12) Created docker-compose-scaling.md: Service (template) vs Container (instance) concept, `--scale` usage, fixed port binding conflict when scaling and how to solve it
- (00:18) Created unix-pipes-and-stdin.md: stdin/stdout/stderr standard streams, pipe (`|`) mechanics (in-memory buffer), file-based vs pipe-based parallel safety comparison
- (00:25) Created process-and-system-calls.md: User Space vs Kernel Space, Linux fork()+exec() vs Windows CreateProcess(), why `type` only works on Windows, subprocess.run(input=) internal system call chain
- All three documents learned from gilJOBi project Step 4 (Windows) → Step 5 (Linux/Docker) transition

### Blockers
-

### Reflection
-

### Next Steps
-

### References
- [docker-compose-scaling.md](../../resources/docker/docker-compose-scaling.md)
- [unix-pipes-and-stdin.md](../../resources/docker/unix-pipes-and-stdin.md)
- [process-and-system-calls.md](../../resources/docker/process-and-system-calls.md)

### Notes
- gilJOBi Step 4's Windows file-based approach (temp_eval_prompt.txt) caused race conditions with parallel workers → Step 5 solved this with Linux stdin pipes (each worker gets an isolated OS pipe)
- `subprocess.run` is not a system call — internally it orchestrates multiple system calls: pipe()→fork()→exec()→write()→read()→wait()
- Docker Compose fixed `host:container` port mapping = max 1 container. To scale, either drop ports or let Docker auto-assign

### Raw (AI: organize into sections above)
-
