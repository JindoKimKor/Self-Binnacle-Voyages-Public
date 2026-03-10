# Go 바이너리 빌드와 GitHub Releases

## 핵심 개념

### Go는 컴파일 언어다

Python, JavaScript는 인터프리터가 소스 코드를 실행한다.
Go는 소스 코드를 **기계어로 컴파일**해서 하나의 실행 파일(바이너리)을 만든다.

```
소스 코드 (main.go)  →  go build  →  실행 파일 (downloader)
```

이 실행 파일은 Go가 설치되지 않은 컴퓨터에서도 실행된다. 의존성 없이 단독 실행 가능.

### 크로스 컴파일 (Cross-Compilation)

Windows에서 Linux용 실행 파일을 만들 수 있다.

```bash
# Windows에서 실행하지만, Linux용 바이너리가 만들어짐
GOOS=linux GOARCH=amd64 go build -o downloader-linux-amd64 ./cmd/downloader/
```

| 환경변수 | 의미 | 예시 |
|---------|------|------|
| `GOOS` | 대상 운영체제 | linux, windows, darwin (macOS) |
| `GOARCH` | 대상 CPU 아키텍처 | amd64 (Intel/AMD 64bit), arm64 (Apple Silicon) |

결과물: `downloader-linux-amd64` — Windows에서 만들었지만 Linux에서만 실행 가능.

---

## GitHub Releases

### 왜 존재하는가?

소스 코드는 개발자용이다. 일반 사용자(또는 서버, VM)는 코드를 빌드할 환경이 없다.
**빌드된 실행 파일을 배포할 장소**가 필요하다 → GitHub Releases.

### 구조

```
GitHub Repository
  └── Releases
       └── v0.1.0 (Git tag에 연결)
            ├── 릴리스 노트 (변경 사항 설명)
            ├── downloader-linux-amd64    ← 첨부 파일 (Asset)
            ├── downloader-windows.exe    ← 여러 OS용 가능
            └── Source code (자동 생성)
```

### 사용 방법

```bash
# 1. 바이너리 빌드
GOOS=linux GOARCH=amd64 go build -o downloader-linux-amd64 ./cmd/downloader/

# 2. Release 생성 + 바이너리 첨부
gh release create v0.1.0 downloader-linux-amd64 --title "v0.1.0" --notes "Initial release"
```

### 다운로드

Release에 올리면 고정 URL이 생긴다:

```
https://github.com/{owner}/{repo}/releases/download/{tag}/{filename}
```

어디서든 `wget`이나 `curl`로 받을 수 있다 (public repo인 경우).

---

## 우리 프로젝트에서의 활용

```
[로컬 Windows]
  go build → downloader-linux-amd64 생성
  gh release create → GitHub에 업로드
      ↓
[Azure VM 부팅 시 — cloud-init]
  wget → downloader 바이너리 다운로드
  chmod +x → 실행 권한 부여
  사용자가 실행 → Unity 버전 감지, Docker pull, 라이선스 업로드 등
```

VM에는 Go가 설치되어 있지 않지만, 이미 컴파일된 바이너리이므로 실행 가능.

---

## 추가 학습 포인트

- [ ] Go 빌드 시스템 (`go build`, `go install`)
- [ ] GitHub Actions로 Release 자동화 (태그 push → 자동 빌드 + Release 생성)
- [ ] Semantic Versioning (v1.0.0 — major.minor.patch)
