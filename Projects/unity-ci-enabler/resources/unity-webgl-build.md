# Unity WebGL Build Configuration

## Project Info

- **Unity Version:** 2022.2.1f1
- **Render Pipeline:** URP (Universal Render Pipeline)
- **Target Repo:** `resources/repos/UnityGame3D-TeamTopChicken`

## Build Scripts

Located at `Assets/Editor/` in the target repo:
- `Builder.cs` — CLI-driven WebGL build with configurable options
- `BuildSettingsInspector.cs` — Dumps all build settings to log

Source: `resources/repos/UnityDockerRunningTest/` (adapted for 2022.2.1f1)

### 2022.2.1f1 Incompatible APIs (removed)

- `PlayerSettings.WebGL.wasm2023`
- `PlayerSettings.WebGL.webAssemblyTable`
- `PlayerSettings.WebGL.webAssemblyBigInt`
- `WasmCodeOptimization` / `UserBuildSettings.codeOptimization`
- `PlayerSettings.GetStaticBatchingForPlatform` / `GetDynamicBatchingForPlatform`

## Working Build Command (Fast, for CI testing)

```bash
"/c/Program Files/Unity/Hub/Editor/2022.2.1f1/Editor/Unity.exe" \
  -batchmode \
  -projectPath "<PROJECT_PATH>" \
  -buildTarget WebGL \
  -executeMethod Builder.BuildWebGL \
  -compressionFormat Disabled \
  -managedStrippingLevel Low \
  -stripEngineCode false \
  -stripUnusedMeshComponents false \
  -strictShaderVariantMatching false \
  -webGLExceptionSupport FullWithStacktrace \
  -gcIncremental false \
  -il2cppCompilerConfiguration Debug \
  -webGLBuildSubtarget Generic \
  -development true \
  -connectProfiler false \
  -allowDebugging false \
  -buildOptions CleanBuildCache \
  -logFile "<PROJECT_PATH>/build.log" \
  -quit
```

## Serving WebGL Build Locally

```bash
cd <PROJECT_PATH>/Builds && python -m http.server 8080
# Open http://localhost:8080
```

## Notes

- `-nographics` was NOT used — removing it did not fix the pink shader issue but is generally safer for shader compilation
- Pink/magenta materials: This is a pre-existing URP material issue in the project, not a build config problem. The URP pipeline asset exists but materials render incorrectly in WebGL. Does not affect build success validation.
- `-managedStrippingLevel Disabled` causes `DirectoryNotFoundException` for VisualScripting DLLs in Library cache — use `Low` instead
- Original dockerRun.sh reference: `resources/repos/UnityDockerRunningTest/dockerRun.sh`
