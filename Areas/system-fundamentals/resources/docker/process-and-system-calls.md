# Processes, System Calls, and Linux vs Windows

> **Context**: Understanding why Step 4 (Windows) and Step 5 (Linux/Docker) use different subprocess approaches
> **Date**: 2026-02-17

---

## 1. User Space vs Kernel Space

Programs can't directly touch hardware (disk, network, other processes' memory).
They have to **ask the OS kernel** via system calls.

```
┌─────────────────────────────────────────────┐
│               User Space                     │
│                                              │
│   Your Python script                         │
│   Claude CLI binary                          │
│   Any application you run                    │
│                                              │
├──────────── System Call Interface ───────────┤
│               Kernel Space                   │
│                                              │
│   Process management  (create, kill, wait)   │
│   File I/O            (open, read, write)    │
│   Memory management   (allocate, free)       │
│   Network             (socket, connect)      │
│   IPC                 (pipe, signal)         │
│                                              │
└──────────────────────────────────────────────┘
```

A **system call** = a user space program knocking on this boundary and saying
"Kernel, please do this for me."

`subprocess.run` is NOT a system call — it's a Python library function that
**orchestrates multiple system calls** on your behalf.

---

## 2. How Linux Creates a Process — fork + exec

Linux uses a two-step model inherited from Unix:

```mermaid
sequenceDiagram
    participant P as Python Process
    participant K as Linux Kernel
    participant C as claude Process

    P->>K: pipe() — "create a pipe for me"
    K-->>P: (read_fd, write_fd)

    P->>K: fork() — "make an exact copy of me"
    K-->>P: child PID (parent continues here)
    K-->>C: child starts here (copy of Python)

    C->>K: exec("claude") — "replace my image with claude binary"
    K-->>C: Claude binary loaded, execution begins

    P->>K: write(write_fd, prompt) — "put prompt into pipe"
    C->>K: read(read_fd) — "read from stdin (= pipe)"
    K-->>C: prompt arrives at claude stdin

    C->>K: write(stdout, result) — "write result"
    P->>K: read(stdout) — "capture claude's output"
    K-->>P: result

    P->>K: wait() — "wait for child to finish"
```

Key point: `fork()` **duplicates** the current process first, then `exec()` **replaces** it.
The child starts as a copy of Python, then becomes `claude`.

---

## 3. How Windows Creates a Process — CreateProcess

Windows has no concept of `fork()`. It creates processes differently:

```mermaid
sequenceDiagram
    participant P as Python Process
    participant K as Windows Kernel
    participant C as claude Process

    P->>K: CreatePipe() — "create a pipe (HANDLE pair)"
    K-->>P: (hReadPipe, hWritePipe)

    P->>K: CreateProcess("claude.exe", STARTUPINFO with pipe handles)
    Note over K: Windows loads claude.exe directly
    Note over K: No fork — process created fresh
    K-->>C: claude.exe starts with pipe connected to stdin

    P->>K: WriteFile(hWritePipe, prompt)
    C->>K: ReadFile(hReadPipe) — reads from stdin
    K-->>C: prompt

    C->>K: WriteFile(stdout, result)
    P->>K: ReadFile(stdout pipe)
    K-->>P: result

    P->>K: WaitForSingleObject() — wait for claude to finish
```

Key point: Windows goes directly to `CreateProcess()`.
No copying, no replacing — fresh process from the start.

---

## 4. Why `type` Only Works on Windows

```
Windows CMD:    type file.txt | claude -
Linux bash:     cat file.txt  | claude -
```

| | Windows `type` | Linux `cat` |
|---|---|---|
| What it is | CMD.exe **built-in** command | A separate executable (`/bin/cat`) |
| Exists as file | No — only inside cmd.exe | Yes — `/usr/bin/cat` |
| Works in subprocess without shell=True | No | Yes |

`type` is not a program — it lives inside `cmd.exe`.
To use it from Python, you must use `shell=True`, which launches `cmd.exe /c "type file..."`.

```python
# Windows only — type is a CMD built-in, needs shell=True
subprocess.run('type temp.txt | claude ...', shell=True)

# Linux — cat is a real executable, shell=True not required
subprocess.run('cat temp.txt | claude ...', shell=True)

# Both platforms — stdin=PIPE, no shell, no file needed
subprocess.run(['claude', ...], input=prompt, capture_output=True, text=True)
```

---

## 5. Why subprocess.run(input=) is Better Than Files

```mermaid
flowchart TB
    subgraph Windows["Step 4 — Windows (file-based)"]
        direction LR
        W1[Python writes prompt] --> F["temp_eval_prompt.txt (disk)"]
        F --> W2[CMD reads file]
        W2 --> W3[pipe to claude]
        F --> RISK["⚠️ Race condition if parallel"]
    end

    Windows ~~~ Linux

    subgraph Linux["Step 5 — Linux (stdin pipe)"]
        direction LR
        L1[Python holds prompt in memory]
        L1 -->|fork + exec| L2["OS pipe (memory)"]
        L2 -->|stdin fd=0| L3[claude reads directly]
        L2 --> SAFE["✓ Isolated per process, no disk I/O"]
    end
```

| | Windows file-based | Linux stdin pipe |
|---|---|---|
| Disk I/O | Yes (write + read) | None |
| Parallel safe | No (shared file path) | Yes (each pipe is isolated) |
| Shell required | Yes (`shell=True` for `type`) | No |
| Works in Docker | No (`type` not available in Linux) | Yes |

---

## 6. Summary — The Chain from Python to OS

```
subprocess.run(['claude', '-'], input=prompt)
        │
        ├── pipe()         → Kernel creates in-memory pipe
        ├── fork()         → Kernel duplicates Python process    [Linux only]
        ├── exec('claude') → Kernel loads claude binary into child
        ├── write(pipe)    → Kernel writes prompt bytes to pipe buffer
        ├── read(pipe)     → claude reads prompt from its stdin
        ├── write(stdout)  → claude writes result
        ├── read(stdout)   → Python reads claude's output
        └── wait()         → Python waits for claude to exit
```

`subprocess.run` is the friendly Python wrapper.
Every step underneath it is a **system call** — a request to the kernel.
