import Foundation
import CoreMotion

class MotionManager: ObservableObject {
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

class EnvironmentState: ObservableObject {
    // 1.0 is stable, 5.0 is critical melting point
    @Published var temperature: Double = 1.0

    var severityLabel: String {
        if temperature < 2.0 { return "Stable" }
        if temperature < 4.0 { return "Escalating" }
        return "Critical"
    }
}
