import SpriteKit
import UIKit

class SimulationScene: SKScene {
    weak var motionManager: MotionManager?
    weak var envState: EnvironmentState?
    
    // Environmental Nodes
    private let iceNode = SKShapeNode(rectOf: CGSize(width: 300, height: 120), cornerRadius: 15)
    private let villagePlatform = SKShapeNode(rectOf: CGSize(width: 250, height: 35), cornerRadius: 8)
    private let villageHouse = SKShapeNode(rectOf: CGSize(width: 120, height: 45), cornerRadius: 4)
    
    // Particle Management
    private var waterDrops: Set<SKShapeNode> = []
    private let maxWaterDrops = 1000 // Performance cap to prevent 60fps drop
    
    private var lastTemp: Double = 1.0
    private var meltTimer: TimeInterval = 0
    private var spawnBatchSize: Int = 1
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear // Let SwiftUI's gradient show through
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.friction = 0.5
        self.physicsBody?.restitution = 0.1
        
        setupEnvironment()
        spawnInitialWater()
    }
    
    func setupEnvironment() {
        // Village Platform (Left side)
        villagePlatform.fillColor = UIColor(red: 0.15, green: 0.18, blue: 0.22, alpha: 1.0)
        villagePlatform.strokeColor = UIColor.white.withAlphaComponent(0.2)
        villagePlatform.position = CGPoint(x: self.frame.minX + 140, y: self.frame.minY + 200)
        villagePlatform.physicsBody = SKPhysicsBody(polygonFrom: villagePlatform.path!)
        villagePlatform.physicsBody?.isDynamic = false
        addChild(villagePlatform)
        
        // Village House
        villageHouse.fillColor = UIColor.systemTeal.withAlphaComponent(0.8)
        villageHouse.strokeColor = .clear
        villageHouse.position = CGPoint(x: villagePlatform.position.x, y: villagePlatform.position.y + 40)
        villageHouse.physicsBody = SKPhysicsBody(polygonFrom: villageHouse.path!)
        villageHouse.physicsBody?.isDynamic = false
        addChild(villageHouse)
        
        // Ice Shelf (Top Right)
        iceNode.fillColor = UIColor.white.withAlphaComponent(0.9)
        iceNode.strokeColor = UIColor.cyan.withAlphaComponent(0.5)
        iceNode.lineWidth = 2
        iceNode.position = CGPoint(x: self.frame.maxX - 160, y: self.frame.maxY - 150)
        iceNode.physicsBody = SKPhysicsBody(polygonFrom: iceNode.path!)
        iceNode.physicsBody?.isDynamic = false
        addChild(iceNode)
    }
    
    func spawnInitialWater() {
        for _ in 0..<300 {
            spawnWaterDrop(at: CGPoint(
                x: self.frame.midX + CGFloat.random(in: -150...150),
                y: self.frame.minY + CGFloat.random(in: 20...150)
            ))
        }
    }
    
    func spawnWaterDrop(at position: CGPoint) {
        guard waterDrops.count < maxWaterDrops else { return }
        
        // Apple-style glowing aesthetic
        let radius: CGFloat = CGFloat.random(in: 5...8)
        let drop = SKShapeNode(circleOfRadius: radius)
        drop.fillColor = UIColor.cyan.withAlphaComponent(0.7)
        drop.strokeColor = UIColor.white.withAlphaComponent(0.3)
        drop.blendMode = .add // Creates a luminous, glowing fluid effect when particles overlap
        drop.position = position
        
        // High-fidelity Physics
        drop.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        drop.physicsBody?.restitution = 0.3 // Bounciness
        drop.physicsBody?.friction = 0.05   // Low friction for fluid sliding
        drop.physicsBody?.linearDamping = 0.1 // Smooth out chaotic jitter
        drop.physicsBody?.mass = 0.02
        drop.physicsBody?.allowsRotation = true
        
        addChild(drop)
        waterDrops.insert(drop)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // 1. Butter-smooth Gravity vector mapping via CoreMotion
        if let pitch = motionManager?.pitch, let roll = motionManager?.roll {
            // Apply easing to prevent sudden accelerometer spikes
            let targetDx = roll * 25.0
            let targetDy = -pitch * 25.0 - 9.8
            let currentGravity = self.physicsWorld.gravity
            
            // LERP (Linear Interpolation) for fluid gravity transition
            let smoothedDx = currentGravity.dx + (targetDx - currentGravity.dx) * 0.1
            let smoothedDy = currentGravity.dy + (targetDy - currentGravity.dy) * 0.1
            self.physicsWorld.gravity = CGVector(dx: smoothedDx, dy: smoothedDy)
        }
        
        // 2. Complex Environmental Logic (Temperature)
        if let env = envState {
            if env.temperature != lastTemp {
                handleTemperatureChange(newValue: env.temperature)
                lastTemp = env.temperature
            }
            
            // Dynamic Melting Formula
            if env.temperature > 1.5 {
                meltTimer += 0.016 // Approximates 60fps
                
                // Exponential melting speed based on temp severity
                let severity = (env.temperature - 1.0) / 4.0 // 0.0 to 1.0
                let meltThreshold = max(0.005, 0.1 - (severity * 0.1)) // Drops faster
                spawnBatchSize = Int(1 + (severity * 5)) // Spawn multiple drops at once under high heat
                
                if meltTimer > meltThreshold {
                    meltTimer = 0
                    if iceNode.xScale > 0.05 { 
                        for _ in 0..<spawnBatchSize {
                            spawnWaterDrop(at: CGPoint(
                                x: iceNode.position.x + CGFloat.random(in: -100...100) * iceNode.xScale,
                                y: iceNode.position.y - 70
                            ))
                        }
                    }
                }
            }
        }
    }
    
    func handleTemperatureChange(newValue: Double) {
        let meltRatio = max(0.01, 1.0 - ((newValue - 1.0) / 4.0))
        
        // Change logic: Smooth interpolation of scale
        let scaleAction = SKAction.scaleX(to: meltRatio, duration: 0.3)
        let scaleYAction = SKAction.scaleY(to: max(0.4, meltRatio), duration: 0.3) // Don't flatten completely
        
        // Color transition: Ice looks dirtier/clearer as it melts
        let targetColor = UIColor.white.withAlphaComponent(CGFloat(max(0.3, meltRatio)))
        let colorAction = SKAction.run { [weak self] in
            self?.iceNode.fillColor = targetColor
        }
        
        let group = SKAction.group([scaleAction, scaleYAction, colorAction])
        iceNode.run(group)
    }
}
