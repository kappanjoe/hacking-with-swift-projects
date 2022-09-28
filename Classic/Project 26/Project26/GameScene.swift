//
//  GameScene.swift
//  Project26
//
//  Created by Joseph Van Alstyne on 9/28/22.
//

import CoreMotion
import SpriteKit
import GameplayKit

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case teleport = 32
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    var motionManager: CMMotionManager!
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var levelLabel: SKLabelNode!
    var level = 1 {
        didSet {
            levelLabel.text = "Level \(level)"
        }
    }
    
    var isGameOver = false
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        background.name = "bg"
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        scoreLabel.name = "score"
        addChild(scoreLabel)
        
        levelLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelLabel.text = "Level 1"
        levelLabel.horizontalAlignmentMode = .right
        levelLabel.position = CGPoint(x: 1008, y: 16)
        levelLabel.zPosition = 2
        levelLabel.name = "level"
        addChild(levelLabel)
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        loadLevel(1)
        createPlayer(at: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard !isGameOver else { return }
        
        #if targetEnvironment(simulator)
            if let currentTouch = lastTouchPosition {
                let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
                physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
            }
        #else
            if let accelerometerData = motionManager.accelerometerData {
                physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -40, dy: accelerometerData.acceleration.x * 40)
            }
        #endif
    }
    
    func createPlayer(at position: CGPoint?) {
        guard isGameOver else { return }
        
        player = SKSpriteNode(imageNamed: "player")
        if position != nil {
            player.position = position!
        } else {
            player.position = CGPoint(x: 96, y: 672)
        }
        player.zPosition = 1
        player.name = "player"
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        
        addChild(player)
    }
    
    func createSprite(type: String, collectable: Bool, position: CGPoint) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: type)
        node.position = position
        node.name = type
        
        if collectable { // Masks for player contact, has no collision
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2.5)
            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
            node.physicsBody?.collisionBitMask = 0
        } else { // Default collision mask, no contact mask
            node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        }
        
        node.physicsBody?.isDynamic = false
        
        return node
    }
    
    func parseLevelMapKey(key: Character, position: CGPoint) {
        switch key {
        case "x": // Wall
            let node = createSprite(type: "wall", collectable: false, position: position)
            node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
            addChild(node)
        case "v": // Vortex (spins)
            let node = createSprite(type: "vortex", collectable: true, position: position)
            node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
            node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
            addChild(node)
        case "s": // Star
            let node = createSprite(type: "star", collectable: true, position: position)
            node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
            addChild(node)
        case "f": // Finish
            let node = createSprite(type: "finish", collectable: true, position: position)
            node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
            addChild(node)
        case "t": // Teleport (spins inverted)
            let node = createSprite(type: "teleport", collectable: true, position: position)
            node.run(SKAction.repeatForever(SKAction.rotate(byAngle: (0 - .pi), duration: 1)))
            node.physicsBody?.categoryBitMask = CollisionTypes.teleport.rawValue
            addChild(node)
        case " ":
            return
        default:
            fatalError("Unknown level map key: \(key)")
        }
    }
    
    func loadLevel(_ level: Int) {
        // Reset all nodes in view
        removeChildren(in: children.filter({ node in
            return node.name != "bg" && node.name != "score" && node.name != "level" && node.name != "player"
        }))
        
        // Guard against corrupt level files
        guard let levelURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") else {
            fatalError("Could not find level\(level).txt in the app bundle.")
        }
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Could not load level\(level).txt from the app bundle.")
        }
        
        let lines = levelString.components(separatedBy: "\n")
        
        // Parse map key for each square in level map
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                parseLevelMapKey(key: letter, position: position)
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        // If player makes contact with another node, trigger collision method
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func resetPlayer(_ node: SKNode, at position: CGPoint?, nextLevel: Bool) {
        player.physicsBody?.isDynamic = false
        let move = SKAction.move(to: node.position, duration: 0.25)
        let scale = SKAction.scale(to: 0.0001, duration: 0.25)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([move, scale, remove])
        
        if nextLevel {
            // Reset player in new level
            player.run(sequence) { [weak self] in
                self?.loadLevel(self!.level)
                self?.createPlayer(at: position)
                self?.isGameOver = false
            }
        } else {
            // Reset player in current level
            // (player is not respawned if isGameOver already has false value)
            player.run(sequence) { [weak self] in
                self?.createPlayer(at: position)
                self?.isGameOver = false
            }
        }
    }
    
    func playerCollided(with node: SKNode) {
        switch node.name {
        case "vortex":
            // Player dies in vortex
            isGameOver = true
            score -= 1
            resetPlayer(node, at: nil, nextLevel: false)
        case "star":
            // Player collects star
            node.removeFromParent()
            score += 1
        case "finish":
            // Player finishes level
            score += 10
            level += 1
            guard level <= 2 else {
                // No more levels - wrap up game
                levelLabel.text = "Finished!"
                resetPlayer(node, at: nil, nextLevel: false)
                node.removeFromParent()
                motionManager.stopAccelerometerUpdates()
                return
            }
            // Move to next level; set isGameOver to true to allow character respawn
            isGameOver = true
            resetPlayer(player, at: nil, nextLevel: true)
        case "teleport":
            // Player enters teleport; remove from possible exits by renaming
            node.name = "usedTeleport"
            
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([scale, remove])
            
            guard let exit = childNode(withName: "teleport") else {
                // Remove if no exit exists
                node.run(sequence)
                return
            }
            
            // Teleport player; set isGameOver to true to allow character respawn
            isGameOver = true
            resetPlayer(node, at: exit.position, nextLevel: false)
            
            // Remove teleports after use
            node.run(sequence)
            exit.run(sequence)
        default:
            return
        }
    }
    
}
