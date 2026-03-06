import CoreGraphics
import CoreMotion
import Foundation
import SwiftUI

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
    }

    func resetTelemetry() {
        waterDropCount = 300
        iceIntegrity = 1.0
        floodRisk = 0.0
        gravityMagnitude = 9.8
        motionGuidance = "CoreMotion live tilt enabled."
        recommendedAction = "Hold a cold baseline and observe how the shelf stabilizes."
    }
}
