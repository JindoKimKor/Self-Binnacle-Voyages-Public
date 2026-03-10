# Unity CI Function — Architecture

## Scope

GitHub webhook을 수신하고 Azure Batch에 빌드 job을 제출하는 serverless microservice. Bootstrap이 생성한 인프라 위에서 독립적으로 동작함.

---

## Why Azure Functions (Not GitHub Actions)

### 역할 비교

이 시스템에서 Azure Function은 Jenkins의 역할을 대체함:

| Jenkins | 이 시스템 |
|---------|----------|
| Webhook 수신 | Azure Function |
| 빌드 설정/파이프라인 | Function config |
| Worker node 관리 | Azure Batch |
| 빌드 실행 | Batch node (game-ci container) |
| 결과 보고 | GitHub commit status |

### 대안 검토: GitHub Actions

| | Azure Function | GitHub Actions |
|---|---|---|
| **Trigger** | Webhook (push → Function 직접 호출) | Push event (GitHub 내장) |
| **실행 시간** | ~5초 (validate + Batch submit) | Workflow 전체 대기 시 분수 소모 |
| **비용 (public repo)** | Consumption Plan 월 100만 실행 무료 | 무료 (무제한) |
| **비용 (private repo)** | 동일 (사실상 무료) | 월 2,000분 무료 → 이후 과금 |
| **Orchestration** | 코드 내부에서 처리 | YAML workflow로 stage/step 관리 |

### 결정: Azure Function

- **비용**: Unity 프로젝트는 대부분 private repo → GitHub Actions는 분수 소모. Unity 빌드는 20-30분 이상 소요되므로 Actions에서 대기하면 분수 낭비가 심함. Function은 fire-and-forget으로 5초 안에 끝나므로 사실상 무료
- **단순성**: push → validate → Batch submit 단일 흐름이라 Actions의 multi-stage orchestration이 불필요
- **독립성**: GitHub에 종속되지 않는 webhook 기반 → 다른 Git 호스팅에서도 동작 가능

> **Note:** GitHub Actions는 이 제품의 CI가 아님. `unity-ci-function` repo 자체의 배포 파이프라인 (deploy.yml)에서만 사용.

---

## Prerequisites (Bootstrap이 제공)

| Resource | Description |
|----------|-------------|
| Azure Function App | Managed Identity + app_settings 포함, 코드는 빈 상태 — 이 repo의 코드가 여기에 배포됨 |
| Azure Batch Account | 빌드 job을 submit할 대상 |
| Shared Image Gallery | Batch node가 사용할 specialized VM image |
| Key Vault | Unity license (`UNITY-LICENSE`) + webhook secret (`WEBHOOK-SECRET`) |
| Webhook 등록 완료 | GitHub repo → Function App URL로 push 이벤트 전달 |

---

## Architecture Flow

```
[GitHub push]
    ↓ POST (X-Hub-Signature-256)
[Azure Function — webhook handler]
  1. Signature 검증 (WEBHOOK-SECRET from Key Vault)
  2. Push event payload 파싱 (repo, branch, commit)
  3. Non-push event → 204 무시
    ↓
  4. Azure Batch API → Job 생성 (autoPoolSpecification 포함)
     - autoPool: Shared Image Gallery의 specialized image 사용
     - Pool은 Job 완료 시 자동 삭제
  5. Task 제출 → build parameters 전달
  6. 202 반환 → Function 종료 (~3-4초)
    ↓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Function은 여기서 끝. 이하는 Batch node 독립 실행.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ↓
[autoPool 생성 — Azure가 자동으로 VM 프로비저닝 (5-15분)]
    ↓
[Batch node — from specialized image]
  game-ci Docker image already loaded
  Same machine ID → Unity license valid
    ↓
  1. Key Vault에서 license 읽기 → /tmp/Unity_lic.ulf
  2. git clone {repo} -b {branch} /project
  3. docker run game-ci container
     - Mount: /project, license file
     - Unity batchmode build
    ↓
  4. Artifacts → Azure Blob Storage 업로드 (artifacts/{commit}/build.zip)
  5. Build status → Azure Blob Storage 업로드 (artifacts/{commit}/status.json)
  6. Build 결과 → GitHub commit status 보고
  7. Job 완료 → autoPool 자동 삭제
```

---

## Tech Stack

| Layer | Technology | Reason |
|-------|-----------|--------|
| Language | Go | Azure Functions Custom Handler |
| Runtime | Azure Functions (Consumption Plan) | Pay-per-execution, 자동 스케일링 |
| Build compute | Azure Batch | 독립적 장시간 실행 (20-30분) |
| Artifact storage | Azure Blob Storage | 빌드 결과물 저장 |

---

## Repo Structure

```
unity-ci-function/
├── cmd/
│   └── handler/            ← Azure Function Custom Handler (HTTP server)
│       └── main.go
├── internal/
│   ├── handler/            ← HTTP handler (route + response logic)
│   ├── webhook/            ← webhook signature 검증 + payload 파싱
│   ├── batch/              ← Azure Batch API job 제출
│   └── keyvault/           ← Azure Key Vault secret 읽기
├── scripts/
│   └── deploy.sh           ← Go 빌드 + zip 배포 스크립트
├── spec/                   ← API contract, batch job, error handling 문서
├── github-webhook/         ← Azure Function trigger 디렉토리
│   └── function.json       ← HTTP trigger 바인딩 (route: github-webhook)
├── host.json               ← Azure Functions Custom Handler 설정
├── go.mod
└── .github/
    └── workflows/
        └── deploy.yml      ← push → Azure Function 자동 배포
```

> **Note:** `github-webhook/function.json`의 디렉토리명이 곧 Function 이름. Azure가 `/api/` prefix를 자동 추가하므로 최종 URL은 `POST /api/github-webhook`이 됨.

---

## Deployment

### CI/CD (자동)

```
[push to unity-ci-function repo]
    ↓ GitHub Actions
[go build → binary]
    ↓
[az functionapp deployment → Azure Function App]
```

- `main` branch push → 자동 배포
- Bootstrap이 만든 Function App에 코드만 업데이트

### 수동

```bash
# .env에 RESOURCE_GROUP_NAME, FUNCTION_APP_NAME 설정 후:
bash scripts/deploy.sh
```

deploy.sh 동작:
1. `GOOS=linux GOARCH=amd64 go build` → handler 바이너리 생성
2. Python `zipfile`로 deploy.zip 생성 (handler + host.json + github-webhook/function.json)
3. `az functionapp deployment source config-zip`으로 배포

> **Note:** zip 생성에 Python `zipfile`을 사용하는 이유: PowerShell `Compress-Archive`는 backslash 경로를 생성하여 Linux Function App에서 인식 불가.

---

## API Contract

### Input: GitHub Webhook POST

```
POST /api/github-webhook
Headers:
  X-Hub-Signature-256: sha256=<hmac>
  X-GitHub-Event: push
Body: GitHub push event payload
```

### Responses

| Status | Condition |
|--------|-----------|
| 202 Accepted | Valid push → Batch job submitted |
| 204 No Content | Non-push event (ignored) |
| 400 Bad Request | Invalid JSON payload |
| 401 Unauthorized | Invalid webhook signature |
| 500 Internal Server Error | Batch API call failed |

---

## Configuration (Environment Variables)

Function App이 필요로 하는 값들. Bootstrap의 Terraform이 Function App settings에 주입.

| Variable | Source | Description |
|----------|--------|-------------|
| KEY_VAULT_NAME | Bootstrap terraform | Webhook secret + license 저장소 |
| BATCH_ACCOUNT_URL | Bootstrap terraform | `https://{account}.{region}.batch.azure.com` |
| IMAGE_RESOURCE_ID | Bootstrap terraform | Full Azure resource ID for VM image |
| VM_SIZE | deploy.sh (from .env) | VM size (e.g. `Standard_D8ads_V5`). Terraform에 포함되지 않음 — deploy.sh가 `az functionapp config appsettings set`으로 주입 |
| PLATFORM | (미구현) | 빌드 타겟 플랫폼. `batch.JobParams.Platform` 필드 존재하나 handler가 아직 채우지 않음 |

---

## Open Questions

- [x] ~~Batch node의 빌드 스크립트는 어디에 위치?~~ → `scripts/build.sh`에 위치, Function App과 함께 배포. Batch task command로 전달
- [x] ~~Artifact storage 구조~~ → `{branch}/{commit}/` 단위. commit SHA 기준으로 저장 — commit status 보고에 필요
- [x] ~~GitHub commit status API 호출 방법~~ → PAT (`GH_TOKEN`). Bootstrap에서 이미 사용 중, Key Vault에 저장 → Batch node가 읽어서 commit status 보고
- [x] ~~Batch pool 설정~~ → Fixed 1 node. Unity 라이선스 정책상 동시 빌드 불가 — 순차 실행만 허용
- [x] ~~Multi-webhook 확장~~ → Future Improvement로 이동. 현재는 push→build 단일 흐름
