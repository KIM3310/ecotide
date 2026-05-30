# EcoTide

> **Curated supporting repo**
> This repository is kept as optional proof, but it no longer leads the portfolio.
> Current front door: **twincity-ui and fab-ops-yield-control-tower**.
> Reason: Mobile simulation work is interesting but less commercially sharp than enterprise operations, security, and data systems.

EcoTide is an iOS SwiftUI simulation app (Swift Package based) with motion-driven gravity interaction, a live telemetry overlay, and a reviewer-facing simulation review pack.

## Product and Review Surface

A SwiftUI simulation app that shows native craft through telemetry, simulation loops, and polished mobile interactions.

| Lens | Definition |
|---|---|
| Buyer or user | Mobile product reviewers, simulation-tool teams, education creators, and SwiftUI-focused engineering teams. |
| Commercial route | Use as a paid simulation app prototype, school/workshop demo, or native UX case study. |
| Review signal | SwiftUI surface, motion telemetry, CLI handoff fallback, product-style simulation, and native app structure. |
| Safety boundary | Motion and telemetry should stay privacy-aware and opt-in for production distribution. |
| Fast proof | Build the app or run CLI fallback checks, then inspect simulation outputs and telemetry handling. |

## Reviewer Fast Path

- **First minute:** Start with the motion/fallback badge and telemetry deck, then replay a reset scenario.
- **Local demo:** Open the Swift package in Xcode for the native scene; use `swift run EcoTideCLI` when iOS rendering is unavailable.
- **Verification:** Run `bash scripts/smoke_cli_review_pack.sh` and `swift run EcoTideCLI`.
- **Commercial read:** Position it as a native simulation case study for education, workshops, or mobile product craft.

## Commercialization Playbook

- [Monetization and GTM playbook](docs/monetization-playbook.md) maps the repository to buyer segments, offer ladder, pricing hypotheses, proof gates, and risk boundaries.

## Review Notes

- [Review guide](docs/reviewer-evidence-map.md) summarizes the project angle, first files to inspect, verification commands, and known boundaries.
- [Quality notes](docs/quality-gate.md) lists the local checks, CI surface, and release expectations for this repository.
- [Revenue growth model](docs/revenue-growth-model.md) maps the project to an ethical revenue path, activation loop, pricing logic, and growth experiments.
- [Enterprise readiness notes](docs/enterprise-readiness.md) outlines security, data, operations, integration, and handoff expectations.
- [Conversion UX model](docs/conversion-ux-model.md) maps the buyer path, behavioral design, UI/UX direction, pricing frame, and ethical conversion guardrails.
- [Commercial offer](docs/commercial-offer.md) packages the repository into a buyer-ready offer ladder, proof gate, outreach angle, and close path.
- [Portfolio fit](docs/portfolio-fit.md) explains why this repository is archived/supporting and where the current portfolio front door lives.

## One concrete review story
A reviewer can start in a stable scenario, tilt the device until flood risk rises, then hit reset and watch the telemetry settle again. If motion is unavailable, the CLI review pack becomes the clean handoff instead of a confusing dead end.

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
- The CLI fallback emits `ecotide-review-pack-v1` plus a reviewer handoff contract so reviewers can inspect posture even without the iOS rendering path.

## Review Flow
- Confirm whether motion is live or fallback before interpreting gravity changes.
- Read the telemetry deck together: ice integrity, water load, habitat risk, gravity, and next action.
- Use reset after a critical flood scenario so reviewers can reproduce the same path.
- Run `EcoTideCLI` and inspect the reviewer handoff contract when motion or SwiftUI rendering is unavailable.
- Treat `EcoTideCLI` as a contract fallback, not as proof of the full SpriteKit rendering path.

## Proof Assets
- `Telemetry Deck` -> in-app ice/water/habitat/gravity/next action surface
- `Motion Mode Badge` -> live CoreMotion versus simulator-safe fallback
- `Reset Scenario Control` -> reproducible observation path
- `EcoTideCLI` -> `ecotide-review-pack-v1` fallback contract for non-iOS environments
- `Reviewer Handoff Contract` -> `EcoTideCLI` summary for scenario focus, drift, and next operator move
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

## Cloud + AI Architecture

This repository includes a neutral cloud and AI engineering blueprint that maps the current proof surface to runtime boundaries, data contracts, model-risk controls, deployment posture, and validation hooks.

- [Cloud + AI architecture blueprint](docs/cloud-ai-architecture.md)
- [Machine-readable architecture manifest](docs/architecture/blueprint.json)
- Validation command: `python3 scripts/validate_architecture_blueprint.py`
