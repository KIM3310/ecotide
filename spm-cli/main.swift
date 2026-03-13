import EcoTideShared
import Foundation

enum ReviewScenario: String {
    case stable
    case escalating
    case critical

    var focusedSnapshot: String {
        switch self {
        case .stable:
            return "Stable / Habitat secure / Hold a cold baseline and observe how the shelf stabilizes."
        case .escalating:
            return "Escalating / Coastline stressed / Tilt gently to contain water drift and keep the shelf below the rapid-melt band."
        case .critical:
            return "Critical / Village at risk / Open the package in Xcode to run the full SwiftUI + SpriteKit experience."
        }
    }

    var nextAction: String {
        switch self {
        case .stable:
            return "Keep the temperature low and use reset after each review pass to preserve a reproducible baseline."
        case .escalating:
            return "Run the simulator with moderate tilt to inspect how melt acceleration affects habitat risk before the critical threshold."
        case .critical:
            return "Open the package in Xcode to run the full SwiftUI + SpriteKit experience."
        }
    }
}

enum MotionMode: String {
    case live
    case fallback

    var label: String {
        switch self {
        case .live:
            return "coremotion-live"
        case .fallback:
            return "stable-gravity-fallback"
        }
    }
}

func parseValue(flag: String, args: [String]) -> String? {
    guard let index = args.firstIndex(of: flag), args.indices.contains(index + 1) else {
        return nil
    }
    return args[index + 1]
}

let args = Array(CommandLine.arguments.dropFirst())
let scenario = ReviewScenario(rawValue: (parseValue(flag: "--scenario", args: args) ?? "critical").lowercased()) ?? .critical
let motion = MotionMode(rawValue: (parseValue(flag: "--motion", args: args) ?? "fallback").lowercased()) ?? .fallback

let sharedQuickStarts = ScenarioDefinition.quickStarts.map(\.focusCard.actionLabel)

let reviewRoutes = [
    "Review Pack card",
    "Telemetry deck",
    "Stable / Escalating / Critical quick preset",
    "Reset Scenario control",
    "EcoTideCLI fallback contract"
]

let payload: [String: Any] = [
    "app": "EcoTideCLI",
    "service": "ecotide",
    "status": "fallback-ready",
    "surface": "motion-driven climate simulator",
    "readiness_contract": "ecotide-review-pack-v1",
    "headline": "CLI fallback surface for EcoTide review posture and telemetry contract.",
    "focused_snapshot": scenario.focusedSnapshot,
    "selected_scenario": scenario.rawValue,
    "proof_bundle": [
        "supports_motion_input": true,
        "telemetry_overlay": true,
        "motion_mode": motion.label,
        "telemetry_surface_count": 5,
        "review_routes": reviewRoutes,
        "quick_start_actions": sharedQuickStarts,
    ],
    "two_minute_review": [
        "Confirm that this CLI output is a fallback contract rather than the full rendering path.",
        "Choose the scenario preset that matches the reviewer conversation before interpreting the telemetry snapshot.",
        "Open the app target in Xcode to validate live CoreMotion versus stable fallback behavior.",
        "Use reset and repeated runs to keep the simulation review path reproducible.",
    ],
    "review_sequence": [
        "Select a stable, escalating, or critical scenario preset before collecting screenshots for review.",
        "Use the in-app telemetry deck to review ice integrity, water load, habitat risk, gravity, and next action.",
        "Treat this CLI output as a fallback contract, not a replacement for the rendered simulation.",
    ],
    "trust_boundary": [
        "CLI fallback verifies posture and contract shape without requiring AppleProductTypes or iOS rendering.",
        "Full motion and SpriteKit review still belongs in the app target.",
    ],
    "proof_assets": [
        "Telemetry Deck (in-app)",
        "Motion Mode Badge",
        "Stable / Escalating / Critical preset controls",
        "Reset Scenario Control",
        "EcoTideCLI fallback contract",
    ],
    "diagnostics": [
        "next_action": scenario.nextAction,
        "supports_motion_input": true,
        "telemetry_overlay": true,
        "share_hint": "Use --scenario stable|escalating|critical and --motion live|fallback to reproduce the reviewer state in CLI.",
    ],
]

let data = try JSONSerialization.data(withJSONObject: payload, options: [.prettyPrinted, .sortedKeys])
FileHandle.standardOutput.write(data)
FileHandle.standardOutput.write(Data([0x0A]))
