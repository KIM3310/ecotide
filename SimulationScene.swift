import SpriteKit

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
    private var lastUpdateTime: TimeInterval?
    private var hasInitializedScene = false
    private var cleanupTimer: TimeInterval = 0
    
    private let cleanupInterval: TimeInterval = 0.25
    private let cleanupMargin: CGFloat = 250
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear // Let SwiftUI's gradient show through
        configureBoundsPhysics()
        
        if !hasInitializedScene {
            setupEnvironment()
            spawnInitialWater()
            hasInitializedScene = true
        }
        
        layoutEnvironment()
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        configureBoundsPhysics()
        layoutEnvironment()
    }
    
    private func configureBoundsPhysics() {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.friction = 0.5
        self.physicsBody?.restitution = 0.1
    }
    
    func setupEnvironment() {
        // Village Platform (Left side)
        villagePlatform.fillColor = SKColor(red: 0.15, green: 0.18, blue: 0.22, alpha: 1.0)
        villagePlatform.strokeColor = SKColor.white.withAlphaComponent(0.2)
        if let platformPath = villagePlatform.path {
            villagePlatform.physicsBody = SKPhysicsBody(polygonFrom: platformPath)
            villagePlatform.physicsBody?.isDynamic = false
        }
        if villagePlatform.parent == nil {
            addChild(villagePlatform)
        }
        
        // Village House
        villageHouse.fillColor = SKColor(red: 0.18, green: 0.7, blue: 0.72, alpha: 0.8)
        villageHouse.strokeColor = .clear
        if let housePath = villageHouse.path {
            villageHouse.physicsBody = SKPhysicsBody(polygonFrom: housePath)
            villageHouse.physicsBody?.isDynamic = false
        }
        if villageHouse.parent == nil {
            addChild(villageHouse)
        }
        
        // Ice Shelf (Top Right)
        iceNode.fillColor = SKColor.white.withAlphaComponent(0.9)
        iceNode.strokeColor = SKColor.cyan.withAlphaComponent(0.5)
        iceNode.lineWidth = 2
        if let icePath = iceNode.path {
            iceNode.physicsBody = SKPhysicsBody(polygonFrom: icePath)
            iceNode.physicsBody?.isDynamic = false
        }
        if iceNode.parent == nil {
            addChild(iceNode)
        }
        
        layoutEnvironment()
    }
    
    private func layoutEnvironment() {
        villagePlatform.position = CGPoint(x: self.frame.minX + 140, y: self.frame.minY + 200)
        villageHouse.position = CGPoint(x: villagePlatform.position.x, y: villagePlatform.position.y + 40)
        iceNode.position = CGPoint(x: self.frame.maxX - 160, y: self.frame.maxY - 150)
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
        drop.fillColor = SKColor.cyan.withAlphaComponent(0.7)
        drop.strokeColor = SKColor.white.withAlphaComponent(0.3)
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
        let deltaTime = frameDeltaTime(for: currentTime)
        
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
                meltTimer += deltaTime
                
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
        
        cleanupTimer += deltaTime
        if cleanupTimer >= cleanupInterval {
            cleanupTimer = 0
            pruneWaterDropsOutsideBounds()
        }
    }
    
    private func frameDeltaTime(for currentTime: TimeInterval) -> TimeInterval {
        defer { lastUpdateTime = currentTime }
        
        guard let lastUpdateTime else {
            return 1.0 / 60.0
        }
        
        // Avoid giant simulation jumps when the scene resumes after a pause.
        return min(max(0, currentTime - lastUpdateTime), 0.1)
    }
    
    private func pruneWaterDropsOutsideBounds() {
        let minX = self.frame.minX - cleanupMargin
        let maxX = self.frame.maxX + cleanupMargin
        let minY = self.frame.minY - cleanupMargin
        
        let dropsToRemove = waterDrops.filter { drop in
            guard drop.parent != nil else { return true }
            return drop.position.x < minX || drop.position.x > maxX || drop.position.y < minY
        }
        
        for drop in dropsToRemove {
            drop.removeFromParent()
            waterDrops.remove(drop)
        }
    }
    
    func handleTemperatureChange(newValue: Double) {
        let meltRatio = max(0.01, 1.0 - ((newValue - 1.0) / 4.0))
        
        // Change logic: Smooth interpolation of scale
        let scaleAction = SKAction.scaleX(to: meltRatio, duration: 0.3)
        let scaleYAction = SKAction.scaleY(to: max(0.4, meltRatio), duration: 0.3) // Don't flatten completely
        
        // Color transition: Ice looks dirtier/clearer as it melts
        let targetColor = SKColor.white.withAlphaComponent(CGFloat(max(0.3, meltRatio)))
        let colorAction = SKAction.run { [weak self] in
            self?.iceNode.fillColor = targetColor
        }
        
        let group = SKAction.group([scaleAction, scaleYAction, colorAction])
        iceNode.run(group)
    }
}
