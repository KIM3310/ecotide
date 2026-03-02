import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject private var motionManager = MotionManager()
    @StateObject private var envState = EnvironmentState()
    
    // Store scene in State to prevent physics engine resets on UI updates
    @State private var scene = SimulationScene()
    
    var body: some View {
        ZStack {
            // Background is a deep, immersive oceanic gradient
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.02, green: 0.06, blue: 0.1), Color.black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // The SpriteKit Physics Sandbox
            GeometryReader { geometry in
                SpriteView(scene: configuredScene(for: geometry.size), options: [.allowsTransparency])
                    .ignoresSafeArea()
            }
            // Add an inner shadow for depth
            .overlay(
                Rectangle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    .ignoresSafeArea()
            )
            
            // Apple-Standard Glassmorphic Dashboard
            VStack {
                // Top Header Card
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("EcoTide")
                            .font(.system(size: 34, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .cyan.opacity(0.5), radius: 10, x: 0, y: 0)
                        
                        Text("Interactive Climate Physics Simulator")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                    
                    // Dynamic Status Indicator
                    HStack(spacing: 8) {
                        Image(systemName: envState.temperature > 3.0 ? "exclamationmark.triangle.fill" : "checkmark.seal.fill")
                            .foregroundColor(envState.temperature > 3.0 ? .red : .mint)
                            .font(.title2)
                        
                        Text(tempString)
                            .font(.system(.title3, design: .monospaced).bold())
                            .foregroundColor(envState.temperature > 3.0 ? .red : .white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                }
                .padding(.horizontal, 30)
                .padding(.top, 40)
                
                Spacer()
                
                // Bottom Control Center
                VStack(spacing: 20) {
                    // Educational Prompt
                    HStack(alignment: .top, spacing: 16) {
                        Group {
                            if #available(iOS 17.0, macOS 14.0, *) {
                                Image(systemName: iconForTemp)
                                    .symbolEffect(.bounce, value: envState.temperature)
                            } else {
                                Image(systemName: iconForTemp)
                            }
                        }
                        .font(.system(size: 32))
                        .foregroundColor(colorForTemp)
                        .frame(width: 40)
                        
                        Text(message)
                            .font(.system(size: 16, weight: .medium, design: .default))
                            .foregroundColor(.white.opacity(0.9))
                            .fixedSize(horizontal: false, vertical: true)
                            .animation(.easeInOut, value: message)
                        Spacer()
                    }
                    .padding(.bottom, 10)
                    
                    Divider().background(Color.white.opacity(0.2))
                    
                    // Hardware Interaction Prompt
                    HStack {
                        Image(systemName: "ipad.landscape")
                            .foregroundColor(.gray)
                        Text("Tilt your device to manipulate the gravity vector (CoreMotion)")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    
                    // Precision Slider
                    HStack(spacing: 15) {
                        Image(systemName: "thermometer.snowflake")
                            .foregroundColor(.cyan)
                        
                        Slider(value: $envState.temperature, in: 1.0...5.0, step: 0.05)
                            .tint(colorForTemp)
                            .animation(.interactiveSpring(), value: envState.temperature)
                            
                        Image(systemName: "thermometer.sun.fill")
                            .foregroundColor(.red)
                    }
                }
                .padding(25)
                .background(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
    }
    
    // MARK: - Computed Properties for Polish
    
    private var tempString: String {
        return "+\(String(format: "%.2f", envState.temperature))°C"
    }
    
    private var iconForTemp: String {
        if envState.temperature < 2.0 { return "drop.fill" }
        if envState.temperature < 4.0 { return "flame" }
        return "waveform.path.ecg"
    }
    
    private var colorForTemp: Color {
        if envState.temperature < 2.0 { return .cyan }
        if envState.temperature < 4.0 { return .orange }
        return .red
    }
    
    private var message: String {
        if envState.temperature < 2.0 {
            return "Ice shelves are perfectly stable. The global sea level is balanced natively by the physics engine."
        } else if envState.temperature < 4.0 {
            return "Thermal Expansion: The ice shelf melts quadratically as temperatures rise, creating thousands of fluid particles."
        } else {
            return "CRITICAL DISASTER: The massive volume of displaced physics bodies has submerged the coastal habitat."
        }
    }
    
    private func configuredScene(for size: CGSize) -> SKScene {
        scene.size = size
        scene.scaleMode = .resizeFill
        scene.motionManager = motionManager
        scene.envState = envState
        return scene
    }
}
