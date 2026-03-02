---
date: 2026-02-14
---

## Log (Monitoring)

> **Time**: 10:25 AM ~ 11:33 AM

### What did I actually do?
- (10:25) Updated voyage-plan.md: Reorganized Sailing Orders (Consolidate CS materials + Tech interview prep), added 3 Docker courses to Plotted Courses, added Resources section
- (11:21) Enhanced runtime-comparison.md: Added Korean explanation section ("What even is a runtime?"), added Python/Node.js execution pipeline diagrams (Lexer→Parser→Compiler→PVM vs V8 JIT)
- (11:33) Created python-vs-nodejs-infrastructure.md: pip vs npm install location differences, how venv works (PATH swapping), full ecosystem comparison

### Blockers
-

### Reflection
-

### Next Steps
-

### References
- [runtime-comparison.md](../../resources/runtimes/runtime-comparison.md)
- [python-vs-nodejs-infrastructure.md](../../resources/runtimes/python-vs-nodejs-infrastructure.md)

### Notes
- "All code eventually becomes system calls" — regardless of language/runtime, all operations interacting with hardware go through OS system calls
- pip (2008) global install vs npm (2010) local install: not a runtime difference but a **generational difference** in package manager design philosophy
- venv is not like VM/Docker — it just swaps the PATH env variable to point to a separate site-packages. Python with venv ends up doing what npm does by default

### Raw (AI: organize into sections above)
-
