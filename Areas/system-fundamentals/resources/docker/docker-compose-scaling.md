# Docker Compose — Service Scaling

> **Context**: Learned while designing Step 5 Spark + Claude CLI evaluation cluster (gilJOBi)
> **Date**: 2026-02-17

---

## Core Concept: Service vs Container

| | Service | Container |
|---|---|---|
| **What it is** | Configuration template | Running instance of a service |
| **Defined in** | `docker-compose.yml` | Created at runtime |
| **Analogy** | Class definition | Object instance |

```yaml
# This is ONE service definition (template)
spark-worker:
  image: apache/spark:latest
  environment:
    - SPARK_WORKER_CORES=1
```

```bash
# This creates 8 containers from that one template
docker compose up --scale spark-worker=8
```

---

## Why Not Write Workers One by One?

```yaml
# BAD — 8 separate service definitions
spark-worker-1:
  environment:
    - SPARK_WORKER_CORES=1
    - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}

spark-worker-2:        # exact same config...
  environment:
    - SPARK_WORKER_CORES=1
    - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
# ... repeated 8 times
```

Problems:
- If config changes, you have to update 8 places
- Adding/removing workers means editing the file every time

```yaml
# GOOD — one template, scale at runtime
spark-worker:
  environment:
    - SPARK_WORKER_CORES=1
    - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
```

```bash
docker compose up --scale spark-worker=8   # 8 workers
docker compose up --scale spark-worker=4   # scale down
docker compose up --scale spark-worker=10  # scale up
```

---

## Port Binding and Scaling

Fixed port mapping **breaks** when scaling:

```yaml
# This FAILS with --scale spark-worker=2 or more
spark-worker:
  ports:
    - "8081:8081"   # All containers fight over host port 8081 → conflict
```

Solutions:

```yaml
# Option A — Remove host port entirely (Docker assigns random ports)
spark-worker:
  # no ports section

# Option B — Let Docker pick the host port dynamically
spark-worker:
  ports:
    - "8081"        # container port only → host port auto-assigned
```

> **Rule**: Fixed `host:container` port mapping = max 1 container per service.
> For scaled services, either drop ports or let Docker auto-assign.

---

## Scaling Command Reference

```bash
# Build image + start cluster with 8 workers
docker compose -f docker-compose.spark-eval.yml up --build --scale spark-worker=8

# Start without rebuilding
docker compose -f docker-compose.spark-eval.yml up --scale spark-worker=8

# Stop and remove containers
docker compose -f docker-compose.spark-eval.yml down

# Use a specific compose file (not default docker-compose.yml)
docker compose -f <filename>.yml <command>
```

---

## Real Example — Spark Eval Cluster

From `gilJOBi/docker-compose.spark-eval.yml`:

```yaml
services:
  spark-master:
    container_name: spark-master-eval   # fixed — only 1 master
    ports:
      - "8080:8080"                     # fixed port OK for single container
      - "7077:7077"
      - "4040:4040"

  spark-worker:
    # no container_name — Docker auto-names: project-spark-worker-1, -2, ...
    # no ports — worker UI visible via Master UI at :8080
    environment:
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
      - SPARK_WORKER_CORES=1
      - SPARK_WORKER_MEMORY=2g
```

```bash
docker compose -f docker-compose.spark-eval.yml up --build --scale spark-worker=8
# → 1 master + 8 workers, all from the same worker template
```
