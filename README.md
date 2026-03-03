# EcoTide

EcoTide is an iOS SwiftUI simulation app (Swift Package based) with motion-driven gravity interaction.

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

## Run
1. Open the project in Xcode (iOS 16+).
2. Build and run the `EcoTide` app target on simulator/device.

## Notes
- Keep generated/runtime artifacts out of git (`.build/`, `.swiftpm/`, `DerivedData/`).
