# Unity CI Bootstrap — Future Improvements

## 1. Resource Killer Script

Terraform destroy가 실패하거나 state가 꼬인 경우를 대비한 강제 삭제 스크립트. `az group delete`로 Resource Group 단위 전체 정리 + GitHub webhook 제거.

## 2. Capture Function

현재 capture.sh는 로컬에서 수동 실행. Downloader 완료 시 Function App을 호출해서 deallocate → capture → destroy를 자동으로 트리거하는 방식으로 개선 가능.

## 3. Multi-Platform

현재 1 image = 1 platform. 여러 플랫폼(WebGL + Android 등)이 필요한 경우 플랫폼별 이미지를 자동 생성하는 파이프라인.

## 4. Image Tagging

Gallery image에 Unity 버전/플랫폼 태그 부착. 현재는 Docker image명(`unityci/editor:ubuntu-{version}-{platform}`)으로 확인 가능하지만, Gallery 수준에서 빠르게 식별할 수 있도록 태그 방식 검토 필요.

## 5. cloud-init Integration Test

cloud-init 변경 시 자동 검증. 공식 integration test 프레임워크가 없어 VM을 띄워서 확인해야 함 (Multipass 또는 cloud). 현재는 Azure VM E2E로 수동 검증.

## 6. Parallel Build (Multi-Account)

현재 Unity 라이선스 정책상 한 계정당 동시 빌드 1개만 허용 → Batch pool fixed 1 node. 여러 Unity 계정을 사용하면 계정 수만큼 병렬 빌드 가능. 각 계정별 라이선스 + machine ID + image가 필요.

## 7. Multi-Webhook

이벤트별 webhook + Function endpoint 분리 (e.g. push→build, pull_request→test, release→deploy). 현재는 push→build 단일 흐름.

## 8. azurerm 4.x Migration

azurerm 4.x는 `delete_option = "Delete"` 지원 → VM 삭제 시 OS disk 자동 삭제. capture.sh에서 Step 4 (disk delete) 제거 가능.