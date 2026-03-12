# EcoTide

EcoTide is an iOS SwiftUI simulation app (Swift Package based) with motion-driven gravity interaction, a live telemetry overlay, and a reviewer-facing simulation review pack.

## Portfolio posture
- Read this repo like a simulation product, not like a docs page with a token app attached.
- The real proof is the moving scene, the telemetry it generates, and the scenario controls that change both.

## Role signals
- **AI / systems engineer:** simulation telemetry, fallback posture, and reviewer CLI surfaces are all kept explicit.
- **Solution / cloud architect:** the repo makes clear what belongs to the native scene and what belongs to the review contract.
- **Field / solutions engineer:** scenario presets make the review path easy to replay in a live walkthrough.


## Portfolio context
- **Portfolio family:** human-centered intelligent products
- **This repo's role:** native simulation / telemetry product that broadens the portfolio beyond workflow tools.
- **Related repos:** `SteadyTap`, `the-savior`

## Start here
- Primary product surface: the iOS SwiftUI package at the repo root (`Package.swift`, `MyApp.swift`, `ContentView.swift`, `SimulationScene.swift`)
- Review/deploy surface: `site/` contains the static Pages wrapper, not the main app runtime
- Non-iOS fallback: `spm-cli/` mirrors the reviewer-facing status contract when SwiftUI rendering is unavailable

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
- `site/index.html`: static review/deploy wrapper for the public Pages surface
- `docs/deployment/CLOUDFLARE_PAGES.md`: deploy notes for the static review wrapper

## Docs Map
- `README.md`: product overview, run steps, and review flow
- `docs/deployment/CLOUDFLARE_PAGES.md`: Cloudflare Pages deployment notes for `site/`
- `site/index.html`: public review wrapper

## Run
1. Open the project in Xcode (iOS 16+).
2. Build and run the `EcoTide` app target on simulator/device.
3. For a CLI sanity check, run `bash scripts/smoke_cli_review_pack.sh`.

## Notes
- Keep generated/runtime artifacts out of git (`.build/`, `.swiftpm/`, `DerivedData/`).
- The in-app telemetry deck now reports ice integrity, water load, habitat risk, gravity strength, a recommended next action, and a simulation review pack.
- The reviewer flow now includes a scenario history trend board so recent melt, flood, and recovery drift stay visible instead of only the current frame.
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
- `site/review-pack.svg` -> reviewer-facing summary card for the public landing page

## Local Verification
```bash
swift --version
test -f Package.swift
swift run EcoTideCLI
bash scripts/smoke_cli_review_pack.sh
# Full Xcode installation may be required for iOS app package plugins
```

## Repository Hygiene
- Keep runtime artifacts out of commits (`.codex_runs/`, cache folders, temporary venvs).
- Prefer running verification commands above before opening a PR.
