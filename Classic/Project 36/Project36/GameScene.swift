//
//  GameScene.swift
//  Project36
//
//  Created by Joseph Van Alstyne on 11/21/22.
//

import SpriteKit
import GameplayKit

enum GameState {
    case showingLogo
    case playing
    case dead
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var logo: SKSpriteNode!
    var gameOver: SKSpriteNode!
    
    var gameState = GameState.showingLogo
    
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var backgroundMusic: SKAudioNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }
    
    let rockTexture = SKTexture(imageNamed: "rock")
    var rockPhysics: SKPhysicsBody!
    
    let explosion = SKEmitterNode(fileNamed: "PlayerExplosion")
    
    override func didMove(to view: SKView) {
        // Initialize physics body herer for improved performance
        rockPhysics = SKPhysicsBody(texture: rockTexture, size: rockTexture.size())
        
        createLogos()
        createPlayer()
        createSky()
        createBackground()
        createGround()
        createScore()
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        physicsWorld.contactDelegate = self
        
        if let musicURL = Bundle.main.url(forResource: "music", withExtension: "m4a") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
        case .showingLogo:
            gameState = .playing
            
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let remove = SKAction.removeFromParent()
            let wait = SKAction.wait(forDuration: 0.5)
            let activatePlayer = SKAction.run { [unowned self] in
                self.player.physicsBody?.isDynamic = true
                self.startRocks()
            }
            
            let sequence = SKAction.sequence([fadeOut, wait, activatePlayer, remove])
            logo.run(sequence)
            
        case .playing:
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
            
        case .dead:
            if let scene = GameScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFit
                let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 1)
                view?.presentScene(scene, transition: transition)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard player != nil else { return }
        
        let value = player.physicsBody!.velocity.dy * 0.001
        let rotate = SKAction.rotate(toAngle: value, duration: 0.1)
        
        player.run(rotate)
    }
    
    func createLogos() {
        logo = SKSpriteNode(imageNamed: "logo")
        logo.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(logo)
        
        gameOver = SKSpriteNode(imageNamed: "gameover")
        gameOver.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOver.alpha = 0
        addChild(gameOver)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "scoreZone" || contact.bodyB.node?.name == "scoreZone" {
            if contact.bodyA.node == player {
                contact.bodyB.node?.removeFromParent()
            } else {
                contact.bodyA.node?.removeFromParent()
            }
            
            let sound = SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false)
            run(sound)
            
            score += 1
            
            return
        }
        
        guard contact.bodyA.node != nil && contact.bodyB.node != nil else {
            return
        }
        
        if contact.bodyA.node == player || contact.bodyB.node == player {
            if let explosion = SKEmitterNode(fileNamed: "PlayerExplosion") {
                explosion.position = player.position
                addChild(explosion)
            }
            
            let sound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
            run(sound)
            
            gameOver.alpha = 1
            gameState = .dead
            backgroundMusic.run(SKAction.stop())
            
            player.removeFromParent()
            speed = 0
        }
    }
    
    func createPlayer() {
        let playerTexture = SKTexture(imageNamed: "player-1")
        player = SKSpriteNode(texture: playerTexture)
        player.zPosition = 10
        player.position = CGPoint(x: frame.width / 6, y: frame.height * 0.75)
        
        addChild(player)
        
        player.physicsBody = SKPhysicsBody(texture: playerTexture, size: playerTexture.size())
        player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
        player.physicsBody?.isDynamic = false
        player.physicsBody?.collisionBitMask = 0
        
        let frame2 = SKTexture(imageNamed: "player-2")
        let frame3 = SKTexture(imageNamed: "player-3")
        let animation = SKAction.animate(with: [playerTexture, frame2, frame3, frame2], timePerFrame: 0.01)
        let runForever = SKAction.repeatForever(animation)
        
        player.run(runForever)
    }
    
    func createSky() {
        let  topSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.14, brightness: 0.97, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.67))
        topSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        let bottomSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.16, brightness: 0.96, alpha: 1), size: CGSize(width: frame.width, height: frame.height*0.33))
        bottomSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        topSky.position = CGPoint(x: frame.midX, y: frame.height)
        bottomSky.position = CGPoint(x: frame.midX, y: bottomSky.frame.height)
        
        addChild(topSky)
        addChild(bottomSky)
        
        topSky.zPosition = -40
        bottomSky.zPosition = -40
    }
    
    func createBackground() {
        let backgroundTexture = SKTexture(imageNamed: "background")
        
        for i in 0...1 {
            let background = SKSpriteNode(texture: backgroundTexture)
            background.zPosition = -30
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: (backgroundTexture.size().width * CGFloat(i)) - CGFloat(1*i), y: 100)
            addChild(background)
            
            let moveLeft = SKAction.moveBy(x: -backgroundTexture.size().width, y: 0, duration: 20)
            let moveReset = SKAction.moveBy(x: backgroundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            background.run(moveForever)
        }
    }
    
    func createGround() {
        let groundTexture = SKTexture(imageNamed: "ground")
        
        for i in 0...1 {
            let ground = SKSpriteNode(texture: groundTexture)
            ground.zPosition = -10
            ground.position = CGPoint(x: (groundTexture.size().width / 2.0 + (groundTexture.size().width * CGFloat(i))), y: groundTexture.size().height / 2)
            
            ground.physicsBody = SKPhysicsBody(texture: ground.texture!, size: ground.texture!.size())
            ground.physicsBody?.isDynamic = false // Collisions occur but the ground won't move
            
            addChild(ground)
            
            let moveLeft = SKAction.moveBy(x: -groundTexture.size().width, y: 0, duration: 5)
            let moveReset = SKAction.moveBy(x: groundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            ground.run(moveForever)
        }
    }
    
    func createRocks() {
        // Create spikes on top and bottom
        let rockTexture = SKTexture(imageNamed: "rock")
        
        let topRock = SKSpriteNode(texture: rockTexture)
        topRock.physicsBody = rockPhysics.copy() as? SKPhysicsBody
        topRock.physicsBody?.isDynamic = false
        topRock.zRotation = .pi
        topRock.xScale = -1.0
        
        let bottomRock = SKSpriteNode(texture: rockTexture)
        bottomRock.physicsBody = rockPhysics.copy() as? SKPhysicsBody
        bottomRock.physicsBody?.isDynamic = false
        
        topRock.zPosition = -20
        bottomRock.zPosition = -20
        
        // Create score zone
        let scoreZone = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 32, height: frame.height))
        scoreZone.physicsBody = SKPhysicsBody(rectangleOf: scoreZone.size)
        scoreZone.physicsBody?.isDynamic = false
        scoreZone.name = "scoreZone"
        
        addChild(topRock)
        addChild(bottomRock)
        addChild(scoreZone)
        
        // Use RNG to determine gap placements
        let xPosition = frame.width + topRock.frame.width
        
        let max = CGFloat(frame.height / 3)
        let yPosition = CGFloat.random(in: -50...max)
        
        let rockDistance: CGFloat = 70 // Smaller = More Difficult
        
        // Animate rocks
        topRock.position = CGPoint(x: xPosition, y: yPosition + topRock.size.height + rockDistance)
        bottomRock.position = CGPoint(x: xPosition, y: yPosition - rockDistance)
        scoreZone.position = CGPoint(x: xPosition + (scoreZone.size.width * 2), y: frame.midY)
        
        let endPosition = frame.width + (topRock.frame.width * 2)
        
        let moveAction = SKAction.moveBy(x: -endPosition, y: 0, duration: 6.2)
        let moveSequence = SKAction.sequence([moveAction, SKAction.removeFromParent()])
        topRock.run(moveSequence)
        bottomRock.run(moveSequence)
        scoreZone.run(moveSequence)
    }
    
    func startRocks() {
        let create = SKAction.run { [unowned self] in
            self.createRocks()
        }
        
        let wait = SKAction.wait(forDuration: 3)
        let sequence = SKAction.sequence([create, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        
        run(repeatForever)
    }
    
    func createScore() {
        scoreLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        scoreLabel.fontSize = 24
        
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 60)
        scoreLabel.text = "SCORE: 0"
        scoreLabel.fontColor = UIColor.black
        
        addChild(scoreLabel)
    }
}
