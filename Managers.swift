import CoreGraphics
import CoreMotion
import Foundation
import SwiftUI

struct SimulationReviewPack {
    let contract: String
    let headline: String
    let motionMode: String
    let telemetrySurfaceCount: Int
    let focusedSnapshot: String
    let reviewRoutes: [String]
    let twoMinuteReview: [String]
    let reviewSequence: [String]
    let trustBoundary: [String]
    let proofAssets: [String]
    let watchouts: [String]
}

struct ScenarioHistoryEntry: Identifiable {
    let id = UUID()
    let timestamp: Date
    let phase: String
    let habitatStatus: String
    let waterDropCount: Int
    let iceIntegrity: Double
    let floodRisk: Double
    let recommendedAction: String
}

struct ScenarioTrendBoard {
    let contract: String
    let latestPhase: String
    let attentionCount: Int
    let driftHeadline: String
    let entries: [ScenarioHistoryEntry]
}

struct GuidedScenario: Identifiable {
    let id: String
    let title: String
    let temperature: Double
    let headline: String
    let reviewerNote: String

    static let quickStarts: [GuidedScenario] = [
        GuidedScenario(
            id: "cold-baseline",
            title: "Cold Baseline",
            temperature: 1.2,
            headline: "Show the habitat before stress: stable shelf, low flood risk, calm gravity.",
            reviewerNote: "Use this first when you want an emotionally calm opening for reviewers."
        ),
        GuidedScenario(
            id: "coastline-watch",
            title: "Coastline Watch",
            temperature: 3.1,
            headline: "Move into the watch band where the village still feels recoverable but pressure is visible.",
            reviewerNote: "Best for explaining the moment where action still matters."
        ),
        GuidedScenario(
            id: "critical-drill",
            title: "Critical Drill",
            temperature: 4.6,
            headline: "Jump straight to the emotional failure case: rapid melt, high water load, and urgent next action.",
            reviewerNote: "Use after baseline so the risk jump feels earned, not theatrical."
        )
    ]
}

final class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0
    @Published var motionAvailable: Bool = false
    
    init() {
        startMotionUpdates()
    }
    
    func startMotionUpdates() {
        motionAvailable = motionManager.isDeviceMotionAvailable
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (data, error) in
                guard let data = data, error == nil else { return }
                self?.pitch = data.attitude.pitch
                self?.roll = data.attitude.roll
            }
        }
    }
    
    deinit {
        motionManager.stopDeviceMotionUpdates()
    }
}

final class EnvironmentState: ObservableObject {
    // 1.0 is stable, 5.0 is critical melting point
    @Published var temperature: Double = 1.0
    @Published private(set) var waterDropCount: Int = 300
    @Published private(set) var iceIntegrity: Double = 1.0
    @Published private(set) var floodRisk: Double = 0.0
    @Published private(set) var gravityMagnitude: Double = 9.8
    @Published private(set) var motionGuidance: String = "CoreMotion live tilt enabled."
    @Published private(set) var recommendedAction: String = "Hold a cold baseline and observe how the shelf stabilizes."
    @Published private(set) var scenarioHistory: [ScenarioHistoryEntry] = []

    init() {
        appendHistorySnapshot(force: true)
    }

    var severityLabel: String {
        if temperature < 2.0 { return "Stable" }
        if temperature < 4.0 { return "Escalating" }
        return "Critical"
    }

    var habitatStatus: String {
        if floodRisk < 0.25 { return "Habitat secure" }
        if floodRisk < 0.65 { return "Coastline stressed" }
        return "Village at risk"
    }

    var thermalPhase: String {
        if temperature < 2.0 { return "Cold shelf" }
        if temperature < 4.0 { return "Rapid melt" }
        return "Failure zone"
    }

    func buildReviewPack(motionAvailable: Bool) -> SimulationReviewPack {
        SimulationReviewPack(
            contract: "ecotide-review-pack-v1",
            headline: "Reviewer pack for a motion-driven climate simulator with telemetry overlay and simulator-safe gravity fallback.",
            motionMode: motionAvailable ? "coremotion-live" : "stable-gravity-fallback",
            telemetrySurfaceCount: 5,
            focusedSnapshot: "\(severityLabel) / \(habitatStatus) / \(recommendedAction)",
            reviewRoutes: [
                "Review Pack card",
                "Telemetry deck",
                "Jump to Critical",
                "Reset Scenario control",
                "EcoTideCLI fallback contract"
            ],
            twoMinuteReview: [
                "Confirm whether motion is live or fallback before interpreting the gravity vector.",
                "Read the telemetry deck together: ice integrity, water load, habitat risk, gravity, and next action.",
                "Use reset after a critical flood scenario so reviewers can reproduce the same observation path.",
                "Treat the CLI review pack as a contract fallback, not as proof of the full SpriteKit rendering path."
            ],
            reviewSequence: [
                "Confirm motion availability before interpreting gravity changes as live device input.",
                "Read telemetry overlay values together: ice integrity, water load, habitat risk, gravity, and next action.",
                "Use the reset scenario control after critical flood conditions so the simulation remains reproducible."
            ],
            trustBoundary: [
                "Physics and telemetry are computed locally inside the simulation scene rather than from remote services.",
                "When motion input is unavailable, gravity intentionally falls back to a stable baseline for simulator consistency.",
                "The telemetry deck is a reviewer surface, not a scientific forecast or external climate model."
            ],
            proofAssets: [
                "Telemetry Deck (in-app): ice integrity, water load, habitat risk, gravity, and next action",
                "Motion Mode Badge: live CoreMotion versus stable gravity fallback",
                "Reset Scenario Control: restores a reproducible observation state",
                "EcoTideCLI: emits ecotide-review-pack-v1 for non-iOS review environments"
            ],
            watchouts: [
                "High particle counts increase visual drama but do not represent real-world hydrodynamic precision.",
                "Device tilt can change the perceived severity quickly; reviewers should separate motion input from thermal input.",
                "The fallback CLI verifies contract posture, not the full SpriteKit rendering path."
            ]
        )
    }

    func updateTelemetry(
        waterDropCount: Int,
        iceIntegrity: Double,
        floodRisk: Double,
        gravity: CGVector,
        motionAvailable: Bool
    ) {
        let clampedIce = max(0.0, min(1.0, iceIntegrity))
        let clampedFlood = max(0.0, min(1.0, floodRisk))

        self.waterDropCount = waterDropCount
        self.iceIntegrity = clampedIce
        self.floodRisk = clampedFlood
        gravityMagnitude = sqrt((gravity.dx * gravity.dx) + (gravity.dy * gravity.dy))
        motionGuidance = motionAvailable
            ? "Device tilt is actively steering the gravity vector."
            : "Motion input unavailable. Falling back to stable gravity for simulator consistency."

        if clampedFlood >= 0.7 || clampedIce <= 0.25 {
            recommendedAction = "Reduce temperature immediately and reset the scenario after the next observation pass."
        } else if clampedFlood >= 0.35 || clampedIce <= 0.6 {
            recommendedAction = "Tilt gently to contain water drift and keep the shelf below the rapid-melt band."
        } else {
            recommendedAction = "Hold a cold baseline and observe how the shelf stabilizes."
        }

        appendHistorySnapshot()
    }

    func resetTelemetry() {
        waterDropCount = 300
        iceIntegrity = 1.0
        floodRisk = 0.0
        gravityMagnitude = 9.8
        motionGuidance = "CoreMotion live tilt enabled."
        recommendedAction = "Hold a cold baseline and observe how the shelf stabilizes."
        appendHistorySnapshot(force: true)
    }

    func applyQuickStart(_ scenario: GuidedScenario) {
        temperature = scenario.temperature
        recommendedAction = scenario.headline
    }

    func buildTrendBoard() -> ScenarioTrendBoard {
        let entries = scenarioHistory.suffix(5)
        let attentionCount = entries.filter { $0.floodRisk >= 0.35 || $0.iceIntegrity <= 0.6 }.count
        let latestPhase = entries.last?.phase ?? thermalPhase
        let driftHeadline: String
        if attentionCount >= 2 {
            driftHeadline = "Scenario drift is stacking up. Compare the recent phases before trusting the current scene."
        } else if attentionCount == 1 {
            driftHeadline = "One recent run crossed the watch threshold. Compare it with the latest recovery state."
        } else {
            driftHeadline = "Recent runs stayed stable enough for reviewer comparison."
        }
        return ScenarioTrendBoard(
            contract: "ecotide-trend-board-v1",
            latestPhase: latestPhase,
            attentionCount: attentionCount,
            driftHeadline: driftHeadline,
            entries: Array(entries)
        )
    }

    private func appendHistorySnapshot(force: Bool = false) {
        let snapshot = ScenarioHistoryEntry(
            timestamp: Date(),
            phase: thermalPhase,
            habitatStatus: habitatStatus,
            waterDropCount: waterDropCount,
            iceIntegrity: iceIntegrity,
            floodRisk: floodRisk,
            recommendedAction: recommendedAction
        )

        if !force, let previous = scenarioHistory.last {
            let significantShift =
                previous.phase != snapshot.phase
                || abs(previous.floodRisk - snapshot.floodRisk) >= 0.12
                || abs(previous.iceIntegrity - snapshot.iceIntegrity) >= 0.12
            guard significantShift else { return }
        }

        scenarioHistory.append(snapshot)
        if scenarioHistory.count > 8 {
            scenarioHistory.removeFirst(scenarioHistory.count - 8)
        }
    }
}
