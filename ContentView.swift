import SwiftUI
import SpriteKit
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

struct ContentView: View {
    @StateObject private var motionManager = MotionManager()
    @StateObject private var envState = EnvironmentState()
    
    // Store scene in State to prevent physics engine resets on UI updates
    @State private var scene = SimulationScene()
    @State private var reviewerActionStatus = "Reviewer shortcuts keep the simulation proof path ready for demo capture."
    
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

                HStack(spacing: 10) {
                    Label(motionManager.motionAvailable ? "Motion Ready" : "Motion Unavailable", systemImage: motionManager.motionAvailable ? "gyroscope" : "ipad")
                    Text("Severity: \(envState.severityLabel)")
                }
                .font(.caption.weight(.medium))
                .foregroundColor(.white.opacity(0.78))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .padding(.top, 12)

                VStack(spacing: 14) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        SignalCard(
                            title: "Thermal Phase",
                            value: envState.thermalPhase,
                            detail: "Ice integrity \(percentString(envState.iceIntegrity))"
                        )
                        SignalCard(
                            title: "Water Load",
                            value: "\(envState.waterDropCount) droplets",
                            detail: "Flood risk \(percentString(envState.floodRisk))"
                        )
                        SignalCard(
                            title: "Habitat",
                            value: envState.habitatStatus,
                            detail: envState.motionGuidance
                        )
                        SignalCard(
                            title: "Gravity",
                            value: String(format: "%.1f m/s²", envState.gravityMagnitude),
                            detail: "Scenario \(envState.severityLabel)"
                        )
                    }

                    HStack(alignment: .center, spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Next Action")
                                .font(.caption.weight(.semibold))
                                .foregroundColor(.white.opacity(0.68))
                                .textCase(.uppercase)
                            Text(envState.recommendedAction)
                                .font(.subheadline.weight(.medium))
                                .foregroundColor(.white)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        Spacer()

                        Button {
                            scene.resetScenario()
                        } label: {
                            Label("Reset Scenario", systemImage: "arrow.counterclockwise")
                                .font(.caption.weight(.semibold))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .background(Color.white.opacity(0.08))
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                        .foregroundColor(.white)
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 16)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

                    reviewPackCard
                }
                .padding(.horizontal, 30)
                .padding(.top, 18)
                
                Spacer()
                
                // Bottom Control Center
                VStack(spacing: 20) {
                    // Educational Prompt
                    HStack(alignment: .top, spacing: 16) {
                        Group {
                            if #available(iOS 17.0, *) {
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

    private var reviewPack: SimulationReviewPack {
        envState.buildReviewPack(motionAvailable: motionManager.motionAvailable)
    }

    private func percentString(_ value: Double) -> String {
        String(format: "%.0f%%", max(0.0, min(1.0, value)) * 100.0)
    }

    private var reviewPackCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Review Pack")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.white.opacity(0.65))
                        .textCase(.uppercase)
                    Text(reviewPack.headline)
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                Text(reviewPack.contract)
                    .font(.caption.monospaced())
                    .foregroundColor(.white.opacity(0.75))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.08))
                    .clipShape(Capsule())
            }

            HStack(spacing: 12) {
                SignalCard(
                    title: "Motion Mode",
                    value: reviewPack.motionMode,
                    detail: motionManager.motionAvailable ? "Live device tilt available" : "Simulator-safe fallback active"
                )
                SignalCard(
                    title: "Telemetry",
                    value: "\(reviewPack.telemetrySurfaceCount) surfaces",
                    detail: "Ice, water, habitat, gravity, next action"
                )
            }

            HStack(alignment: .top, spacing: 16) {
                ReviewList(title: "Review Flow", items: reviewPack.twoMinuteReview)
                ReviewList(title: "Review Sequence", items: reviewPack.reviewSequence)
                ReviewList(title: "Trust Boundary", items: reviewPack.trustBoundary)
            }

            HStack(alignment: .top, spacing: 16) {
                ReviewList(title: "Proof Assets", items: reviewPack.proofAssets)
                ReviewList(title: "Watchouts", items: reviewPack.watchouts)
            }

            HStack(spacing: 12) {
                Button {
                    copyReviewPack()
                } label: {
                    Label("Copy Review Pack", systemImage: "doc.on.doc")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.08))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .foregroundColor(.white)

                Button {
                    copyReviewRoutes()
                } label: {
                    Label("Copy Review Routes", systemImage: "point.topleft.down.curvedto.point.bottomright.up")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.08))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .foregroundColor(.white)

                Button {
                    copyCriticalSnapshot()
                } label: {
                    Label("Copy Critical Snapshot", systemImage: "waveform.path.ecg")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color.orange.opacity(0.16))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .foregroundColor(.white)

                Button {
                    copyMotionSnapshot()
                } label: {
                    Label("Copy Motion Snapshot", systemImage: "gyroscope")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color.cyan.opacity(0.16))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .foregroundColor(.white)

                Button {
                    copyReviewerBundle()
                } label: {
                    Label("Copy Reviewer Bundle", systemImage: "shippingbox.fill")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.12))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .foregroundColor(.white)

                Button {
                    copyScenarioDecisionBrief()
                } label: {
                    Label("Copy Scenario Brief", systemImage: "text.quote")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color.yellow.opacity(0.16))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .foregroundColor(.white)

                Button {
                    focusCriticalScenario()
                } label: {
                    Label("Jump to Critical", systemImage: "flame.fill")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color.red.opacity(0.18))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .foregroundColor(.white)
            }

            Text(reviewerActionStatus)
                .font(.caption)
                .foregroundColor(.white.opacity(0.72))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }

    private func copyReviewPack() {
        let payload = [
            "Contract: \(reviewPack.contract)",
            "Headline: \(reviewPack.headline)",
            "Motion Mode: \(reviewPack.motionMode)",
            "Focused Snapshot: \(reviewPack.focusedSnapshot)",
            "Review Routes:",
            reviewPack.reviewRoutes.joined(separator: "\n"),
            "Review Flow:",
            reviewPack.twoMinuteReview.joined(separator: "\n"),
            "Review Sequence:",
            reviewPack.reviewSequence.joined(separator: "\n"),
            "Proof Assets:",
            reviewPack.proofAssets.joined(separator: "\n")
        ].joined(separator: "\n")

        #if canImport(UIKit)
        UIPasteboard.general.string = payload
        reviewerActionStatus = "Copied simulation review pack."
        #elseif canImport(AppKit)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(payload, forType: .string)
        reviewerActionStatus = "Copied simulation review pack."
        #else
        reviewerActionStatus = "Clipboard copy is unavailable on this platform."
        #endif
    }

    private func copyReviewRoutes() {
        let payload = [
            "EcoTide review routes:",
            reviewPack.reviewRoutes.joined(separator: "\n")
        ].joined(separator: "\n")

        #if canImport(UIKit)
        UIPasteboard.general.string = payload
        reviewerActionStatus = "Copied simulation review routes."
        #elseif canImport(AppKit)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(payload, forType: .string)
        reviewerActionStatus = "Copied simulation review routes."
        #else
        reviewerActionStatus = "Clipboard copy is unavailable on this platform."
        #endif
    }

    private func copyCriticalSnapshot() {
        let payload = [
            "EcoTide critical snapshot",
            "Severity: \(envState.severityLabel)",
            "Habitat: \(envState.habitatStatus)",
            "Phase: \(envState.thermalPhase)",
            "Motion: \(reviewPack.motionMode)",
            "Focused Snapshot: \(reviewPack.focusedSnapshot)",
            "Focused Route: \(reviewPack.reviewRoutes.joined(separator: " -> "))"
        ].joined(separator: "\n")

        #if canImport(UIKit)
        UIPasteboard.general.string = payload
        reviewerActionStatus = "Copied critical reviewer snapshot."
        #elseif canImport(AppKit)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(payload, forType: .string)
        reviewerActionStatus = "Copied critical reviewer snapshot."
        #else
        reviewerActionStatus = "Clipboard copy is unavailable on this platform."
        #endif
    }

    private func copyMotionSnapshot() {
        let payload = [
            "EcoTide motion snapshot",
            "Motion Mode: \(reviewPack.motionMode)",
            "Gravity: \(String(format: "%.1f", envState.gravityMagnitude)) m/s²",
            "Guidance: \(envState.motionGuidance)",
            "Focused Snapshot: \(reviewPack.focusedSnapshot)",
            "Trust Boundary:",
            reviewPack.trustBoundary.joined(separator: "\n"),
            "Watchouts:",
            reviewPack.watchouts.joined(separator: "\n")
        ].joined(separator: "\n")

        #if canImport(UIKit)
        UIPasteboard.general.string = payload
        reviewerActionStatus = "Copied motion reviewer snapshot."
        #elseif canImport(AppKit)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(payload, forType: .string)
        reviewerActionStatus = "Copied motion reviewer snapshot."
        #else
        reviewerActionStatus = "Clipboard copy is unavailable on this platform."
        #endif
    }

    private func copyReviewerBundle() {
        let payload = [
            "EcoTide reviewer bundle",
            "Contract: \(reviewPack.contract)",
            "Headline: \(reviewPack.headline)",
            "Motion Mode: \(reviewPack.motionMode)",
            "Focused Snapshot: \(reviewPack.focusedSnapshot)",
            "",
            "Review Routes:",
            reviewPack.reviewRoutes.joined(separator: "\n"),
            "",
            "Trust Boundary:",
            reviewPack.trustBoundary.joined(separator: "\n"),
            "",
            "Proof Assets:",
            reviewPack.proofAssets.joined(separator: "\n"),
        ].joined(separator: "\n")

        #if canImport(UIKit)
        UIPasteboard.general.string = payload
        reviewerActionStatus = "Copied reviewer bundle."
        #elseif canImport(AppKit)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(payload, forType: .string)
        reviewerActionStatus = "Copied reviewer bundle."
        #else
        reviewerActionStatus = "Clipboard copy is unavailable on this platform."
        #endif
    }

    private func copyScenarioDecisionBrief() {
        let payload = [
            "EcoTide scenario decision brief",
            "Scenario: \(envState.severityLabel)",
            "Habitat: \(envState.habitatStatus)",
            "Phase: \(envState.thermalPhase)",
            "Motion Mode: \(reviewPack.motionMode)",
            "Gravity: \(String(format: "%.1f", envState.gravityMagnitude)) m/s²",
            "Next Action: \(envState.recommendedAction)",
            "Focused Snapshot: \(reviewPack.focusedSnapshot)",
            "",
            "Review Routes:",
            reviewPack.reviewRoutes.joined(separator: "\n"),
        ].joined(separator: "\n")

        #if canImport(UIKit)
        UIPasteboard.general.string = payload
        reviewerActionStatus = "Copied scenario decision brief."
        #elseif canImport(AppKit)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(payload, forType: .string)
        reviewerActionStatus = "Copied scenario decision brief."
        #else
        reviewerActionStatus = "Clipboard copy is unavailable on this platform."
        #endif
    }

    private func focusCriticalScenario() {
        scene.resetScenario()
        envState.temperature = 4.6
        reviewerActionStatus = "Jumped to the critical melt scenario for fast reviewer capture."
    }
}

private struct SignalCard: View {
    let title: String
    let value: String
    let detail: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundColor(.white.opacity(0.65))
                .textCase(.uppercase)
            Text(value)
                .font(.headline.weight(.semibold))
                .foregroundColor(.white)
            Text(detail)
                .font(.caption)
                .foregroundColor(.white.opacity(0.72))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}

private struct ReviewList: View {
    let title: String
    let items: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundColor(.white.opacity(0.68))
                .textCase(.uppercase)
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 8) {
                    Circle()
                        .fill(Color.white.opacity(0.7))
                        .frame(width: 5, height: 5)
                        .padding(.top, 6)
                    Text(item)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.82))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
