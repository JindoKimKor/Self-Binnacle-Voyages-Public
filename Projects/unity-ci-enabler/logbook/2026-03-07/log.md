---
date: 2026-03-07
---

## Log (Monitoring)

### What did I actually do?

**Testing Strategy + TDD Adoption**
- Decided to apply TDD across all possible components, not just Go code
- Added Testing Strategy section to `resources/architecture.md`:
  - Go unit tests (`go test`) for all business logic — seconds, no cost
  - Terratest for Terraform infrastructure — real Azure resources, 10–20 min, Azure cost
  - Multipass for cloud-init validation — local Ubuntu VM, 5–10 min, no cost
  - Manual verification checklist for license activation and VM image capture
- Added test Tasks (#35–39) to each Story as sub-issues

**Go Project Setup**
- Installed Go 1.26.1 via winget
- Configured Go PATH in VS Code terminal settings (`terminal.integrated.env.windows`)
- Initialized Go module: `github.com/game-ci-automation/unity-ci-enabler`
- Created project structure: `cmd/downloader`, `internal/validator`, `internal/docker`, `internal/github`, `internal/azure`, `terraform`, `cloud-init`, `test`
- Moved old Node.js code to `legacy/` folder, committed as rename

**TDD Cycle 1 — `internal/validator`**
- Red: wrote `validator_test.go` testing `ValidateUnityVersion()` and `ValidatePlatform()`
  - Valid: `2022.3.50f1`, `6000.0.0f1` / Invalid: empty, `2022.3.50b1`, `2022.3`
  - Valid platforms: WebGL, Android, iOS, StandaloneLinux64, StandaloneWindows64
- Green: implemented `validator.go` using regex + map lookup
- Result: `go test ./internal/validator/...` → PASS

**TDD Cycle 2 — `internal/docker`**
- Red: wrote `docker_test.go` testing `ResolveImageTag(version, platform)`
  - Expected: `"unityci/editor:ubuntu-2022.3.50f1-webgl-3"` for WebGL
  - Verified actual Docker Hub tag format: `{os}-{version}-{platform}-{image-version}`
- Green: implemented `docker.go` with platform tag mapping
  - WebGL→webgl, Android→android, iOS→ios, StandaloneLinux64→linux-il2cpp, StandaloneWindows64→windows-mono
- Result: `go test ./...` → both packages PASS

**TDD Cycle 3 — `internal/github` (후에 제거)**
- interface + mock 패턴으로 `UploadLicense` 구현 및 테스트
- 아키텍처 결정: 라이선스는 GitHub Secrets에 저장 안 함 → 패키지 전체 삭제

**TDD Cycle 4 — `internal/azure`**
- Red: `azure_test.go` — `mockKeyVaultClient` + `TestUploadLicense` 3종
- Green: `azure.go` — `KeyVaultClient` interface + `Service` + `UploadLicense`
- `client.go` — 실제 Azure SDK (`azidentity` + `azsecrets`) 클라이언트
- Result: `go test ./...` → PASS

**cmd/downloader — CLI 구현 (Story #32)**
- `-version`, `-platform` flags로 입력 받음
- validator → docker tag resolve → docker pull → 라이선스 파일 읽기 → Azure Key Vault 업로드
- 라이선스 파일 자동 감지: Unity 2022↓ `.ulf`, Unity 6+ `.xml`
- `go run ./cmd/downloader/... -version 2022.3.50f1 -platform WebGL` 로컬 실행 확인
  - docker pull `unityci/editor:ubuntu-2022.3.50f1-webgl-3` 성공
  - 라이선스 파일 없음 → 예상된 에러 (VM에서만 동작)

**아키텍처 결정**
- Unity 라이선스는 Azure Key Vault에만 저장 (GitHub Secrets 제거)
- GitHub Secrets는 `CI_FUNCTION_URL`, 클라우드 자격증명에만 사용
- Unity 6 (6000.x) + Hub 3.11.1+: `.ulf` → `.xml` 포맷 변경 확인

**이슈 정리**
- #23, #24, #32 close (game-ci Downloader CLI Story 완료)
- #25 close (아키텍처 결정으로 불필요)
- #26 close (Azure Key Vault 구현 완료)
- Go 코드 첫 commit: `feat: Implement game-ci Downloader CLI (Story #32)`

**보유 Unity 프로젝트 확인**
- `respiratory-therapy`: Unity 6000.0.12f1
- `public-health-inspection`: Unity 2023.2.10f1

**Terraform Infrastructure (Story #30)**
- Persistent tier: Resource Group + Key Vault (`terraform/persistent/`)
- Ephemeral tier: VNet, NSG, Subnet, NIC, Public IP, Linux VM (`terraform/ephemeral/`)
  - NSG: port 6080 (noVNC), port 22 (SSH)
  - VM: `Standard_D4s_v3`, SystemAssigned Managed Identity, cloud-init via `custom_data`
  - Key Vault access policy: VM Managed Identity에 Get/Set/List 권한
- Outputs: `public_ip_address`, `vm_id`, `novnc_url` (`resize=scale&clip=true&autoconnect=true`)
- `null_resource.wait_for_novnc` 제거 — Windows에서 bash 없어서 실패, VM 생성 자체는 정상

**cloud-init (Story #31)**
- Ubuntu VM 최초 부팅 시 자동 설치: Docker Engine, noVNC, websockify, Git
- Unity Hub installer + game-ci downloader → Desktop에 복사
- noVNC systemd service로 자동 시작

**Terratest (`test/terraform_test.go`)**
- 실제 Azure VM 프로비저닝 → IP 확인 → noVNC port 응답 확인 → `terraform destroy`
- TDD Red: `az login` 미완료 상태에서 실패 확인 / Green: VM 생성 성공 확인

**TDD Cycle 5 — 라이선스 경로 수정 (cmd/downloader)**
- Unity 6+ (6000.x): `~/.config/unity3d/Unity/licenses/UnityEntitlementLicense.xml`
- pre-Unity 6: `~/.local/share/unity3d/Unity/Unity_lic.ulf`
- `licensePathsForOS(goos, homeDir string)` 추출 → `main_test.go`로 테스트
- Linux, Windows, Darwin 모두 테스트 커버

**Azure VM 직접 검증**
- `terraform apply`로 VM 프로비저닝 → noVNC URL로 브라우저 접속
- Docker 29.3.0, Git 2.43.0 동작 확인
- noVNC `resize=scale` + `clip=true` 정상 작동 확인

**이슈 정리 및 종료**
- #15 (VNet/NSG/Subnet), #16 (VM), #17 (NSG rules), #18 (cloud-init), #19 (noVNC), #20 (Docker+Git), #21 (noVNC 검증) close
- #30 (Terraform Story), #36 (GitHub Actions CI AC 제거) close
- #29, #13, #14 (Serverless Trigger) — 미완료, 다음 작업

**아키텍처 결정**
- Entry point: GitHub App webhook → Serverless Function (not GitHub Actions `workflow_dispatch`)
- `workflow_dispatch`는 plug-and-play 철학에 위배 — 사용자가 DevOps 지식 없이도 설치만 하면 작동해야 함

**Git commit + push**
- `feat: Add Terraform, cloud-init, Terratest, and fix license paths` (7e4f4ce)
- remote main에 push 완료

### Blockers
- `null_resource.wait_for_novnc` — Windows에서 bash 경로 없음. 제거로 해결.

### Reflection
- GitHub Secrets에 라이선스 저장하는 설계가 처음부터 불필요했음 — 아키텍처 문서를 더 꼼꼼히 검토했다면 TDD Cycle 3 자체를 안 했을 것
- TDD 덕분에 나중에 제거하더라도 깔끔하게 제거 가능했음
- Issue AC를 꼼꼼히 교차검증하지 않고 넘어가려는 경향 → 코드와 대조해서 하나씩 확인하는 습관 필요

### Next Steps
- GitHub App webhook handler (Go HTTP trigger for Azure Functions) — Issues #29, #13, #14
- `terraform destroy`로 현재 VM 종료 (비용 절감)

### References
- game-ci activation docs: Unity 6+ 라이선스 포맷 변경 확인 (issue #469)
- Azure Key Vault 요금: $0.03 / 10,000 operations — 무시 가능

### Notes
-

### Raw (AI: organize into sections above)
-
