---
title: "[Area] System Fundamentals"
created: 2026-01-23
---

## Why
- Systematic learning of computer science fundamentals
- Central hub for CS knowledge not covered by other specialized Areas

## What
**Everything except Software Design, Data Structures & Algorithms, and Programming Languages** - all other computer science topics are studied and organized in this Voyage.

**Topics (examples):**
- Networking (TCP/IP, Socket, HTTP)
- Runtimes (JVM, CLR, PVM, V8)
- Operating Systems (Memory, System Call, Process)
- Cloud Computing
- Containerization (Docker, Kubernetes)
- Security
- etc.

## How
- Organize by topic in `resources/` after learning
- Split into separate Area when a topic grows large enough

---

## Sailing Orders

### Plotted (Underway)

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-01-23 | Consolidate CS materials + Tech interview prep | Knowledge transfer & interview readiness |
>
> <details>
> <summary>Details</summary>
>
> - Sources: Miro, Discord, Confluence, Google Docs, OneDrive
> - Search and organize CS fundamentals from each platform
> - Categorize into `resources/` folders by topic
> - While consolidating, prepare tech interview Q&A per topic with AI
> - Practice answering verbally (speak out loud)
> - Record key answers as keyword notes in resources
> - **OpenText SRA alignment**: Prioritize topics that map to JD (Linux, Ansible, Networking, Monitoring, K8s)
>
> </details>
<br>

### Plotted Courses

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-02-07 | Docker Foundations Professional Certificate (3h 42m) | Foundation + certification |
>
> <details>
> <summary>Details</summary>
>
> - Provider: Docker and LinkedIn
> - Instructor: Shelley Benhoff
> - Skills: Containerization, Docker Products
>
> </details>
<br>

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-02-07 | Docker for Developers: Create and Manage Docker Containers (2h 10m) | Compose, Swarm, K8s, CI/CD extension |
>
> <details>
> <summary>Details</summary>
>
> - Provider: LinkedIn
> - Instructor: Shelley Benhoff
> - Coverage: Docker Compose, Swarm, Kubernetes, CI/CD workflow
>
> </details>
<br>

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-02-07 | Docker: Build and Optimize Docker Images (1h 38m) | Image optimization, multi-stage build deep dive |
>
> <details>
> <summary>Details</summary>
>
> - Provider: LinkedIn
> - Instructor: Shelley Benhoff
> - Focus: Image optimization techniques, multi-stage builds
>
> </details>
<br>

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-02-23 | What happens when you type google.com — full-stack breakdown | Understand every layer from keystroke to rendered page |
>
> <details>
> <summary>Details</summary>
>
> - Layers to cover: Browser UI → OS/DNS resolver → Network (TCP/TLS/HTTP) → Server-side → Response (HTML/CSS/JS) → Browser engine (parsing, DOM, CSSOM, render tree, paint) → GPU compositing
> - Already covered: Network fundamentals (TCP, HTTP)
> - Remaining: Hardware/input, OS-level input handling, URL parsing, browser internals, DOM/JS execution, rendering pipeline, caching
> - Reference: https://github.com/alex/what-happens-when (42.7k stars)
>
> </details>
<br>

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-03-02 | Linux Fundamentals & System Administration | Required skill + core daily responsibility (OpenText SRA) |
>
> <details>
> <summary>Details</summary>
>
> - **Priority 1** — Only required skill with no existing resource
> - File system hierarchy (FHS), permissions (chmod/chown/umask), users/groups
> - Bash scripting: variables, conditionals, loops, functions, exit codes
> - Process management: ps, top, htop, kill, systemd/systemctl
> - Package management: apt (Ubuntu) vs dnf/yum (RHEL)
> - Logs & debugging: journalctl, /var/log/, dmesg
> - Networking tools: ip, ss, netstat, curl, dig, nslookup
> - File operations: find, grep, awk, sed, xargs
> - Resources: roadmap.sh/linux, OverTheWire Bandit, RHEL docs
>
> </details>
<br>

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-03-02 | Ansible Basics — Playbooks & Configuration Management | First listed JD responsibility: "Assist in writing and maintaining Ansible playbooks" |
>
> <details>
> <summary>Details</summary>
>
> - **Priority 2** — ❌ Gap in skills checklist, but literally first responsibility in JD
> - YAML syntax, inventory files, playbook structure
> - Modules: apt/yum, copy, template, service, file
> - Variables, facts, handlers, roles
> - Idempotency concept
> - Practice: simple provisioning playbook (install packages, configure services, manage users)
> - Resources: Ansible official getting-started, Jeff Geerling "Ansible for DevOps"
>
> </details>
<br>

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-03-02 | Networking Fundamentals (IPs, DNS, HTTP, VPC) | "Bridge the gap between software development and network operations" |
>
> <details>
> <summary>Details</summary>
>
> - **Priority 3** — Preferred but essential for the role's core mission
> - OSI/TCP-IP model overview
> - IP addressing, subnets, CIDR notation
> - DNS resolution flow
> - HTTP/HTTPS, TLS handshake
> - Ports, firewalls, NAT
> - VPC, subnets, security groups (cloud networking)
> - Overlaps with: "What happens when you type google.com" order, "Attack on Titan is a VPC Network" video
> - Existing: cloud-security-features.md (WAF, DDoS, Virtual Firewall)
>
> </details>
<br>

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-03-02 | Monitoring & Observability (Prometheus, Grafana) | SRE industry standard — ❌ Gap in skills checklist |
>
> <details>
> <summary>Details</summary>
>
> - **Priority 4** — Preferred qualification, ❌ Gap
> - Three pillars of observability: Monitoring vs Logging vs Tracing
> - Prometheus: pull model, metrics types (counter, gauge, histogram), PromQL basics
> - Grafana: dashboards, alerting, data sources
> - Log aggregation concepts (ELK stack / Splunk)
>
> </details>
<br>

> | Deadline | Created | Order | Purpose |
> |----------|---------|-------|---------|
> | - | 2026-03-02 | Kubernetes Basics — Pods, Services, Deployments | "Basic understanding of orchestration" (Preferred) |
>
> <details>
> <summary>Details</summary>
>
> - **Priority 5** — Preferred, not a daily responsibility but good foundation
> - Core concepts: Pod, Service, Deployment, ReplicaSet
> - kubectl basics
> - Relationship to Docker (container runtime vs orchestrator)
> - YAML manifests
> - Minikube for local practice
>
> </details>
<br>

### Plotted (Reached)

---

## Progress Tracker
| Passage | Date | Topic | Note |
|---------|------|-------|------|
| [2026-02-11](logbook/2026-02-11/log.md) | 2026-02-11 | Interface/Contract | Tech interview Q&A practice (Discord source) |
| [2026-02-14](logbook/2026-02-14/log.md) | 2026-02-14 | Runtimes | Enhanced runtime comparison, created Python vs Node.js infrastructure |
| [2026-02-16](logbook/2026-02-16/log.md) | 2026-02-16 | Docker/OS | Docker Compose scaling, Unix pipes, Process/System calls (gilJOBi) |
| [2026-02-19](logbook/2026-02-19/log.md) | 2026-02-19 | Data Stores | In-memory state → Redis scale-up pattern (PROG3176 Lab 5) |

---

## Resources
- networking/ - TCP, Socket, Two-Tier Architecture
- runtimes/ - JVM, CLR, interpreter comparison
- operating-systems/ - Windows APIs, media subsystems

### Learning Roadmaps
- https://roadmap.sh/

### Technical Talks & Interview Prep
- https://www.youtube.com/watch?v=RP_f5dMoHFc - Naver Day1, 2-2. Is That REST API Really RESTful?
- https://www.youtube.com/watch?v=-GsrYvZoAdA - Why Is This Equation Wrong? (Dev Interview) 1 + 1.1 == 1.2 False
- https://youtu.be/LbGS7s67Rh0?si=XmuxdFVzNRW1aw0H - Attack on Titan is a VPC Network (Network architecture explained via Attack on Titan concept)
- https://www.youtube.com/watch?v=8B8jXKaKBrw - [10분 테코톡] 포라의 Docker 빌드 속도 최적화
- https://www.youtube.com/watch?v=EhkYZ2HnwIM - 빅테크가 경제학 박사를 싹쓸이하고 있습니다 - 김현철 원장(연세대 인구와 인재연구원)

### Open Source Projects
**Python:**
- TensorFlow: https://www.tensorflow.org/
- Django: https://www.djangoproject.com/
- Flask: https://flask.palletsprojects.com/en/2.1.x/
- OpenCV: https://opencv.org/
- Ansible: https://www.ansible.com/

**C++:**
- Microsoft Cognitive Toolkit: https://www.microsoft.com/en-us/research/project/cognitive-toolkit/
- IncludeOS: https://includeos.org/
- Kodi: https://kodi.tv/
- SerenityOS: https://serenityos.org/
- Monero: https://www.getmonero.org/

**Java:**
- Jenkins: https://www.jenkins.io/
- Spring Framework: https://spring.io/projects/spring-framework
- Elasticsearch: https://www.elastic.co/
- Bazel: https://bazel.build/
- Apache Tomcat: https://tomcat.apache.org/

**Contributing:**
- GitHub: https://github.com/
- First Timers Only: https://www.firsttimersonly.com/
- First Contributions: https://firstcontributions.github.io/
- Open Source Friday: https://opensourcefriday.com/

---

## Notes
-

---

## Reflection
### Outcome
- actual:

### Learn
- actual:

### Harvest
- actual: