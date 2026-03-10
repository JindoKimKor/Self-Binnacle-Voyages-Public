---
date: 2026-03-08
---

## Log (Monitoring)

### What did I actually do?

**Persistent Terraform Infrastructure 배포**
- 6개 새 리소스 추가 및 `terraform apply` 완료:
  - `azurerm_storage_account.function` — Function App용 스토리지
  - `azurerm_service_plan.function` — Consumption Plan (Y1)
  - `azurerm_linux_function_app.main` — Go Custom Handler가 올라갈 Function App
  - `azurerm_shared_image_gallery.main` — VM 이미지 저장용 갤러리
  - `azurerm_shared_image.main` — specialized 이미지 정의 (machine ID 보존)
  - `azurerm_batch_account.main` — 빌드 작업 실행용 Batch Account
- `terraform plan` → 6 to add, 0 to change, 0 to destroy 확인 후 apply
- Batch Account에 `storage_account_authentication_mode = "StorageKeys"` 누락 에러 → 수정 후 성공
- `terraform output` 확인: `function_app_url = "https://unity-ci-func.azurewebsites.net"` 등 8개 output 정상

**환경 변수 관리 체계 구축**
- `.env.example` 생성 — skeleton (커밋 대상), 수동 입력 값과 auto-fill 값 구분
  - Manual: `ADMIN_PASSWORD`, `REPO_URL`
  - Auto-filled: `RESOURCE_GROUP_NAME`, `KEY_VAULT_NAME`, `FUNCTION_APP_URL`, `BATCH_ACCOUNT_NAME`, `IMAGE_GALLERY_NAME`, `IMAGE_DEFINITION_NAME`, `FUNCTION_APP_NAME`
- `scripts/sync-env.sh` 생성:
  - `terraform output -raw` → `.env` 자동 기입
  - `.env`에서 `terraform/ephemeral/terraform.tfvars` 자동 생성 (ephemeral apply 시 변수 입력 불필요)
  - 빈 값 있으면 warning 출력 후 tfvars 생성 skip
- `.gitignore`에 `*.tfvars` 추가 (비밀번호 포함이므로)

**GitHub 인증 방식 결정**
- GitHub App (Setup URL) → 별도 웹 서버 호스팅 필요 → **거부**
- OAuth App + Device Flow → OAuth App 등록 필요, Client ID 관리 → **거부**
- `gh` CLI (`gh auth login`) → VM에 설치만 하면 됨, 자체 OAuth 처리, 추가 설정 불필요 → **채택**
- gbl-square 프로젝트의 Authorization Code Flow 참고했으나, 웹 서버 필요해서 CLI 환경에 부적합 확인

**cloud-init 업데이트**
- GitHub CLI 설치 추가 (Docker 다음, Unity Hub 전):
  ```
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/...
  apt-get install -y gh
  ```
- `.env.example`에서 `GITHUB_CLIENT_ID` 제거 (`gh` CLI 채택으로 불필요)

**TDD — `internal/github/` 패키지**
- Red: `github_test.go` — `ParseUnityVersion`, `ParseRepoOwnerName`, `FetchUnityVersion` 테스트 작성
- Green: `github.go` 구현
  - `ParseUnityVersion(content)` — `ProjectVersion.txt`에서 `m_EditorVersion: 2022.2.1f1` 파싱
  - `ParseRepoOwnerName(url)` — `https://github.com/owner/repo.git` → `(owner, repo)` 분리
  - `GHCLI` interface — `gh` CLI 호출 추상화 (테스트에서 `fakeGHCLI` mock 사용)
  - `Client.FetchUnityVersion(owner, repo)` — `gh api repos/{owner}/{repo}/contents/ProjectSettings/ProjectVersion.txt` → base64 decode → `ParseUnityVersion`
- `go test ./internal/github/` → PASS

**Downloader 업데이트 (`cmd/downloader/main.go`)**
- `--version` 플래그를 optional로 변경
- `--repo` 플래그 추가 (기본값: `REPO_URL` 환경변수)
- version 미입력 시: `ParseRepoOwnerName` → `FetchUnityVersion` → 자동 감지
- 사용법 변경:
  - 이전: `./downloader --version 2022.2.1f1 --platform WebGL` (version 필수)
  - 이후: `./downloader --platform WebGL` (version 자동 감지, `gh auth login` 선행 필요)
- `go build ./cmd/downloader/` → 성공

### Blockers
- GitHub API에서 OAuth App 생성 불가 (`POST /user/apps` → 404) — 웹 UI에서만 가능
  - `gh` CLI 채택으로 OAuth App 자체가 불필요해져서 blocker 해소

### Reflection
- GitHub 인증 방식 결정에 시간 소모 — GitHub App → Device Flow → gh CLI로 3번 바뀜
- 처음부터 "VM 터미널에서 CLI로 실행" 제약조건을 명확히 했으면 gh CLI로 바로 갔을 것
- `.env` 관리 체계를 초기에 안 만들어서 terraform output 값을 계속 수동으로 전달했음 → 자동화 필요성을 체감

### Next Steps
- Webhook registration 구현 (downloader에서 `gh api` → repo에 webhook 등록, function_app_url 연결)
- Azure Function webhook handler (Step 2 — Go HTTP trigger → Azure Batch API) — Issues #29, #13, #14
- Commit 및 push (unity-ci-enabler repo)
- architecture.md 업데이트 (gh CLI 결정, .env 체계)

### References
- GitHub Device Flow: https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/authorizing-oauth-apps#device-flow
- GitHub CLI install: https://github.com/cli/cli/blob/trunk/docs/install_linux.md
- Azure Batch Account Terraform: `storage_account_authentication_mode` 필수 속성

### Notes
- Unity 테스트 프로젝트: `UnityGame3D-TeamTopChicken` (Unity 2022.2.1f1, WebGL 빌드 확인됨)
- Function App, Batch Account, Image Gallery 모두 idle 상태에서는 비용 $0

---

## Session 2 (2026-03-08 ~ 03-09 새벽)

### What did I actually do?

**코드 정리 및 확장**
- `go.mod` — terratest/testify 제거, indirect deps 68 → 12로 감소
- `internal/github/webhook.go` — `RegisterWebhook()` 구현 (기존 webhook 중복 체크 + 생성)
- `internal/azure/azure.go` — `UploadWebhookSecret()` 추가
- `cmd/downloader/main.go` — 전체 파이프라인 완성:
  - Unity 버전 자동 감지 → Docker pull → License upload → Webhook secret 생성/업로드 → Webhook 등록 → Cleanup (Unity Hub 삭제, 라이선스 파일 삭제) → Image capture 명령어 출력
- `AZURE_VAULT_NAME` → `KEY_VAULT_NAME`으로 통일
- 테스트: 5개 패키지 20개 테스트 전체 통과

**GitHub 인증 방식 변경: `gh auth login` → PAT (`GH_TOKEN`)**
- noVNC에서 `gh auth login` 브라우저 플로우가 너무 복잡
- `GH_TOKEN` 환경변수 방식으로 전환 — `gh` CLI가 자동 인식
- PAT 이름: `unity-ci-bootstrap-vm`
- 권한: `Contents: Read`, `Webhooks: Read and Write`

**GitHub Release 생성 (v0.1.0)**
- Go 크로스 컴파일: `GOOS=linux GOARCH=amd64 go build -o downloader-linux-amd64`
- `gh release create v0.1.0` — 바이너리 asset으로 업로드
- cloud-init에서 VM 부팅 시 wget으로 자동 다운로드

**cloud-init 업데이트**
- `.unity-ci-env`에 `export` 추가 (없으면 `gh` CLI가 환경변수를 못 읽음)
- `GH_TOKEN`, `IMAGE_GALLERY_NAME`, `IMAGE_DEFINITION_NAME` 변수 추가
- downloader 자동 다운로드 (GitHub Release에서 wget)

**Terraform 업데이트**
- `persistent/main.tf` — Function App `app_settings` 추가 (KEY_VAULT_NAME, BATCH_ACCOUNT_NAME 등)
- `persistent/main.tf` — Image Definition에 `hyper_v_generation = "V2"` 추가
- `ephemeral/main.tf` — templatefile에 `github_token` 포함 7개 변수 전달
- `ephemeral/main.tf` — `os_disk.delete_option = "Delete"` 추가 (VM 삭제 시 디스크 자동 삭제)
- `ephemeral/variables.tf` — `github_token` (sensitive), `image_gallery_name`, `image_definition_name` 추가

**Repo 공개 전환**
- Elastic License 2.0 (ELv2) 추가 — hosted/managed service 제공 금지
- README.md 뼈대 작성 (문서는 추후 작성)
- Private → Public 전환 (Release asset wget 다운로드 가능하게)

**End-to-End 테스트 성공**
- Ephemeral VM 생성 → noVNC 접속 → Unity Hub 라이선스 활성화 → downloader 실행 → 전체 파이프라인 성공
- VM Image → Shared Image Gallery 캡처 성공 (v1.0.0)
- Ephemeral VM 삭제 완료

### Blockers

**Private repo에서 Release asset 다운로드 불가**
- cloud-init wget이 404 반환 — private repo Release는 인증 필요
- 해결: repo를 public으로 전환

**`.unity-ci-env`에 `export` 누락**
- `source ~/.unity-ci-env` 후에도 `gh` CLI가 `GH_TOKEN`을 못 읽음
- `echo $GH_TOKEN`은 값이 있지만 child process에 전달 안 됨
- 해결: 모든 변수에 `export` prefix 추가

**Webhook 등록 실패 — `gh api` 인자 형식 오류**
- `--input -`과 `--raw-field` 혼용으로 에러
- 해결: `-f config[url]=...`, `-f events[]=push`, `-F active=true` 형식으로 변경

**Image Definition Hyper-V Generation 불일치**
- VM은 V2인데 Image Definition이 V1 (기본값)으로 생성됨
- `hyper_v_generation`은 immutable이라 image-version 삭제 → definition 재생성 필요
- 해결: `hyper_v_generation = "V2"` 추가 후 terraform apply

**Terraform destroy와 deallocated VM 충돌**
- azurerm provider가 VM 삭제 전 항상 power off 시도 → 이미 deallocated면 409 Conflict
- Provider 레벨 제약 (deallocated 상태 감지 로직 미구현)
- 해결: `az vm delete`로 수동 삭제 후 `terraform destroy`

**Git Bash (MINGW64) 경로 자동 변환**
- `/subscriptions/...` → `C:/Program Files/Git/subscriptions/...`로 변환됨
- 해결: `MSYS_NO_PATHCONV=1` prefix 사용

### Reflection
- E2E 테스트에서 발견된 문제가 많음 — unit test만으로는 잡을 수 없는 환경 문제들
- `export` 누락, Hyper-V generation, private repo wget 등 모두 실제 환경에서만 발견 가능
- Terraform destroy + deallocate 충돌은 문서화해두어야 다음에 같은 실수 안 함

**코드 정리 및 배포**
- E2E fix 코드 commit + push (`cb324e8`)
  - `cloud-init.yaml`: `export` 추가
  - `webhook.go`: `gh api` 인자 형식 수정 (`-f`/`-F` 플래그)
  - `persistent/main.tf`: `hyper_v_generation = "V2"`
  - `ephemeral/main.tf`: `delete_option = "Delete"`
  - `cmd/downloader/main.go`: 출력 간소화 (`capture.sh` 참조)
  - `scripts/capture.sh`: 신규 — deallocate → capture → delete VM → terraform destroy 자동화
- Release v0.1.1 생성 — webhook fix + 출력 변경 반영된 바이너리
- Repo 정리 commit + push (`a059a4d`)
  - `.github/ISSUE_TEMPLATE/` 삭제 (미사용 템플릿)
  - `terraform/` 루트 잔여물 삭제 (`.terraform.lock.hcl`, `.terraform/`, `terraform.tfstate*` — persistent/ephemeral 분리 전 찌꺼기)
  - `scripts/build.sh` 추가 — 크로스 컴파일 출력을 `build/` 폴더로

### Next Steps
- [x] 코드 변경사항 commit + push (webhook fix, cloud-init export, capture.sh, delete_option, hyper_v_generation)
- [x] Release v0.1.1 생성 (downloader 출력 메시지 변경 + webhook fix 반영)
- [x] `architecture-bootstrap.md` 업데이트 (PAT 방식, deallocate flow, capture.sh)
- [x] 변경된 코드로 E2E 재검증 (새 VM 생성 → downloader → capture.sh 전체 flow)
- [ ] `unity-ci-function` repo 시작 (Step 2: webhook handler + Batch job 제출)

### References
- GitHub Releases: 빌드된 바이너리 배포용 — `logbook/2026-03-08/resources/go-binary-and-github-releases.md`
- Elastic License 2.0: hosted/managed service 제공만 금지, 나머지 자유
- `MSYS_NO_PATHCONV=1`: Git Bash에서 Azure resource ID 경로 변환 방지
- Terraform `delete_option = "Delete"`: VM 삭제 시 OS 디스크 자동 삭제

### Notes
- `az vm stop` vs `az vm deallocate`: stop은 하드웨어 유지(과금 계속), deallocate는 반납(과금 중지)
- Image 캡처는 둘 다 가능하지만 deallocate 후 terraform destroy 충돌 발생
- 다음부터 flow: deallocate → capture → az vm delete → terraform destroy
- VM OS 디스크 `Premium_LRS` 유지 — Batch pool에서 이미지 사용 시 소스 디스크 타입 호환성 필요

### Raw (AI: organize into sections above)
-
