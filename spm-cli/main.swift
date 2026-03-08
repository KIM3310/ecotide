import Foundation

let payload: [String: Any] = [
    "app": "EcoTideCLI",
    "service": "ecotide",
    "status": "fallback-ready",
    "surface": "motion-driven climate simulator",
    "readiness_contract": "ecotide-review-pack-v1",
    "headline": "CLI fallback surface for EcoTide review posture and telemetry contract.",
    "proof_bundle": [
        "supports_motion_input": true,
        "telemetry_overlay": true,
        "motion_mode": "stable-gravity-fallback",
        "telemetry_surface_count": 5,
        "review_routes": [
            "Review Pack card",
            "Telemetry deck",
            "Jump to Critical",
            "Reset Scenario control",
            "EcoTideCLI fallback contract"
        ]
    ],
    "two_minute_review": [
        "Confirm that this CLI output is a fallback contract rather than the full rendering path.",
        "Read the telemetry surfaces together: ice integrity, water load, habitat risk, gravity, and next action.",
        "Open the app target in Xcode to validate live CoreMotion versus stable fallback behavior.",
        "Use reset and repeated runs to keep the simulation review path reproducible."
    ],
    "review_sequence": [
        "Open the package in Xcode to run the full SwiftUI + SpriteKit experience.",
        "Use the in-app telemetry deck to review ice integrity, water load, habitat risk, gravity, and next action.",
        "Treat this CLI output as a fallback contract, not a replacement for the rendered simulation."
    ],
    "trust_boundary": [
        "CLI fallback verifies posture and contract shape without requiring AppleProductTypes or iOS rendering.",
        "Full motion and SpriteKit review still belongs in the app target."
    ],
    "proof_assets": [
        "Telemetry Deck (in-app)",
        "Motion Mode Badge",
        "Reset Scenario Control",
        "EcoTideCLI fallback contract"
    ],
    "diagnostics": [
        "next_action": "Open the package in Xcode to run the full SwiftUI + SpriteKit experience.",
        "supports_motion_input": true,
        "telemetry_overlay": true,
    ],
]

let data = try JSONSerialization.data(withJSONObject: payload, options: [.prettyPrinted, .sortedKeys])
FileHandle.standardOutput.write(data)
FileHandle.standardOutput.write(Data([0x0A]))
