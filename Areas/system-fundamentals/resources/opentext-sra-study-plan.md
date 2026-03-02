# OpenText SRA — System Fundamentals Study Plan

> **Position:** Site Reliability Administrator (Junior DevOps Engineer) — Richmond Hill, ON
> **Created:** 2026-03-02
> **Source:** [opentext-sra-jd.pdf](../../../Projects/job-search/resources/applications/enterprise-opentext/opentext-sra-jd.pdf)

---

## Gap Analysis

| JD Requirement | Type | Current Level | Coverage | Action |
|---|---|---|---|---|
| Linux (Bash, fs, permissions) | **Required** | ✅ Used | ❌ No resource | **P1** |
| Linux Admin (RHEL/Ubuntu) | **Responsibility** | ✅ Used | ❌ No resource | **P1** |
| Ansible playbooks | **Responsibility** | ❌ Gap | ❌ No resource | **P2** |
| Networking (IPs, HTTP, DNS) | Preferred | Partial | ❌ No core resource | **P3** |
| Monitoring (Prometheus/Grafana) | Preferred | ❌ Gap | ❌ No resource | **P4** |
| Kubernetes basics | Preferred | ❌ Gap | ❌ No resource | **P5** |
| Docker | Preferred | ✅ Strong | ✅ 3 resources | Deepen (courses planned) |
| CI/CD | **Responsibility** | ✅ Strong | — | No action (VARLab) |
| Python/Java | **Required** | ✅ Used | ✅ | No action |
| Git | **Required** | ✅ Strong | ✅ 2 resources | No action |
| RCA/Incident Response | **Responsibility** | ✅ Strong | — | Optional |

---

## Study Priorities

### P1: Linux Fundamentals & System Administration
**Why first:** Only **required** skill with no existing resource. Also the core of daily work (RHEL/Ubuntu troubleshooting).

| Topic | Key Commands / Concepts |
|-------|------------------------|
| File system hierarchy | FHS, /, /etc, /var, /home, /usr, /tmp |
| Permissions | chmod, chown, umask, users/groups, sudo |
| Bash scripting | Variables, conditionals, loops, functions, exit codes |
| Process management | ps, top, htop, kill, systemd/systemctl |
| Package management | apt (Ubuntu) vs dnf/yum (RHEL) |
| Logs & debugging | journalctl, /var/log/, dmesg |
| Networking tools | ip, ss, netstat, curl, dig, nslookup |
| File operations | find, grep, awk, sed, xargs |

**Resources:**
- https://roadmap.sh/linux
- OverTheWire Bandit (hands-on practice)
- RHEL documentation

---

### P2: Ansible Basics
**Why second:** Literally the first responsibility listed in JD ("Assist in writing and maintaining Ansible playbooks"). ❌ Gap in skills checklist.

| Topic | Key Concepts |
|-------|-------------|
| Playbook structure | YAML syntax, plays, tasks, handlers |
| Inventory | Static inventory, groups, host variables |
| Modules | apt/yum, copy, template, service, file |
| Variables & facts | vars, facts, registered variables, Jinja2 |
| Roles | Role directory structure, reusability |
| Idempotency | Why Ansible runs are safe to repeat |

**Resources:**
- Ansible official getting-started docs
- Jeff Geerling "Ansible for DevOps" (free chapters)
- Practice: provisioning playbook (install packages, configure services, manage users)

---

### P3: Networking Fundamentals
**Why third:** JD says "bridge the gap between software development and **network operations**."

| Topic | Key Concepts |
|-------|-------------|
| OSI / TCP-IP model | 7 layers vs 4 layers, where each protocol lives |
| IP addressing | IPv4, subnets, CIDR notation, private vs public |
| DNS | Resolution flow, A/AAAA/CNAME/MX records, TTL |
| HTTP/HTTPS | Methods, status codes, headers, TLS handshake |
| Ports & firewalls | Well-known ports, iptables/ufw, NAT |
| Cloud networking | VPC, subnets, security groups, route tables |

**Already available:**
- "Attack on Titan is a VPC Network" video (VPC concepts)
- "What happens when you type google.com" order (full-stack breakdown)
- cloud-security-features.md (WAF, DDoS, Virtual Firewall)

---

### P4: Monitoring & Observability
**Why fourth:** Prometheus/Grafana are SRE industry standard. ❌ Gap in skills checklist.

| Topic | Key Concepts |
|-------|-------------|
| Three pillars | Monitoring vs Logging vs Tracing |
| Prometheus | Pull model, metrics types (counter/gauge/histogram), PromQL |
| Grafana | Dashboards, alerting, data sources |
| Log aggregation | ELK stack (Elasticsearch, Logstash, Kibana) / Splunk |

---

### P5: Kubernetes Basics
**Why fifth:** Preferred, not a daily responsibility but good foundation. ❌ Gap.

| Topic | Key Concepts |
|-------|-------------|
| Core objects | Pod, Service, Deployment, ReplicaSet |
| kubectl | get, describe, apply, logs, exec |
| Docker → K8s | Container runtime vs orchestrator |
| YAML manifests | apiVersion, kind, metadata, spec |
| Local practice | Minikube / kind |

---

## Already Strong (No Study Needed)

| Skill | Level | Evidence |
|-------|-------|---------|
| Python | ✅ Used | Automation scripting, Django |
| Java | ✅ Used | Spring Boot |
| Git | ✅ Strong | Daily use, git-internals resource |
| Docker | ✅ Strong | VARLab experience, 3 resources |
| CI/CD (Jenkins) | ✅ Strong | VARLab pipelines, 94.88% cost reduction |
| Server troubleshooting | ✅ Strong | VARLab build server stabilization |
