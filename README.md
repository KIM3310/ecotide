# EcoTide

EcoTide is an iOS SwiftUI simulation app (Swift Package based) with motion-driven gravity interaction, a live telemetry overlay, and a reviewer-facing simulation review pack.

## Tech Stack
- Swift 5.6+
- SwiftUI
- Swift Package Manager

## Project Structure
- `Package.swift`: app/package definition and iOS target metadata
- `MyApp.swift`: app entry point
- `ContentView.swift`: main UI and interaction flow
- `SimulationScene.swift`: simulation rendering/logic
- `Managers.swift`: shared managers/utilities
- `spm-cli/main.swift`: CLI fallback status surface for non-iOS environments

## Run
1. Open the project in Xcode (iOS 16+).
2. Build and run the `EcoTide` app target on simulator/device.

## Notes
- Keep generated/runtime artifacts out of git (`.build/`, `.swiftpm/`, `DerivedData/`).
- The in-app telemetry deck now reports ice integrity, water load, habitat risk, gravity strength, a recommended next action, and a simulation review pack.
- Simulator and non-motion devices fall back to stable gravity so the scene keeps behaving predictably.
- The CLI fallback emits `ecotide-review-pack-v1` so reviewers can inspect posture even without the iOS rendering path.

## Review Flow
- Confirm whether motion is live or fallback before interpreting gravity changes.
- Read the telemetry deck together: ice integrity, water load, habitat risk, gravity, and next action.
- Use reset after a critical flood scenario so reviewers can reproduce the same path.
- Treat `EcoTideCLI` as a contract fallback, not as proof of the full SpriteKit rendering path.

## Proof Assets
- `Telemetry Deck` -> in-app ice/water/habitat/gravity/next action surface
- `Motion Mode Badge` -> live CoreMotion versus simulator-safe fallback
- `Reset Scenario Control` -> reproducible observation path
- `EcoTideCLI` -> `ecotide-review-pack-v1` fallback contract for non-iOS environments

## Local Verification
```bash
swift --version
test -f Package.swift
swift run EcoTideCLI
# Full Xcode installation may be required for iOS app package plugins
```

## Repository Hygiene
- Keep runtime artifacts out of commits (`.codex_runs/`, cache folders, temporary venvs).
- Prefer running verification commands above before opening a PR.
