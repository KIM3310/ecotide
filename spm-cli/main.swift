import Foundation

let payload: [String: Any] = [
    "app": "EcoTideCLI",
    "status": "fallback-ready",
    "surface": "motion-driven climate simulator",
    "diagnostics": [
        "next_action": "Open the package in Xcode to run the full SwiftUI + SpriteKit experience.",
        "supports_motion_input": true,
        "telemetry_overlay": true,
    ],
]

let data = try JSONSerialization.data(withJSONObject: payload, options: [.prettyPrinted, .sortedKeys])
FileHandle.standardOutput.write(data)
FileHandle.standardOutput.write(Data([0x0A]))
