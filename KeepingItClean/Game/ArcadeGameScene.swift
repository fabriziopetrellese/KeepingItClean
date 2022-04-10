//
//  ArcadeGameScene.swift
//  ArcadeGameTemplate
//

import SpriteKit
import SwiftUI

class ArcadeGameScene: SKScene {
    var playerPosition = CGPoint()
    var startTouch = CGPoint()
    var background = SKSpriteNode(imageNamed: "background")
    var endLine = SKShapeNode(rectOf: CGSize(width: 890, height: 10))
    let lostLifeSound = SKAction.playSoundFileNamed("lostLife4", waitForCompletion: false)
    
    /**
     * # The Game Logic
     *     The game logic keeps track of the game variables
     *   you can use it to display information on the SwiftUI view,
     *   for example, and comunicate with the Game Scene.
     **/
    var gameLogic: ArcadeGameLogic = ArcadeGameLogic.shared
    
    // Keeps track of when the last update happend.
    // Used to calculate how much time has passed between updates.
    var lastUpdate: TimeInterval = 0
    
    var player: SKSpriteNode!
    
//    var isMovingToTheRight: Bool = false
//    var isMovingToTheLeft: Bool = false
    
    override func didMove(to view: SKView) {
        self.setUpGame()
        self.setUpPhysicsWorld()
        background.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        background.zPosition = 1
        addChild(background)
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // ...
//        if isMovingToTheRight {
//            self.moveRight()
//        }
//
//        if isMovingToTheLeft {
//            self.moveLeft()
//        }
        // If the game over condition is met, the game will finish
        if self.isGameOver {
            self.finishGame()
        }
        
        // The first time the update function is called we must initialize the
        // lastUpdate variable
        if self.lastUpdate == 0 { self.lastUpdate = currentTime }
        
        // Calculates how much time has passed since the last update
        let timeElapsedSinceLastUpdate = currentTime - self.lastUpdate
        // Increments the length of the game session at the game logic
        self.gameLogic.increaseSessionTime(by: timeElapsedSinceLastUpdate)
        
        self.lastUpdate = currentTime
    }
}

// MARK: - Game Scene Set Up
extension ArcadeGameScene {
    
    private func setUpGame() {
        self.gameLogic.setUpGame()
//        self.backgroundColor = SKColor.systemCyan
//        if gameLogic.plasticTouches < 3 {
        let playerInitialPosition = CGPoint(x: self.frame.width/2, y: self.frame.height/2.5)
        self.createPlayer(at: playerInitialPosition)
        
        self.startAsteroidsCycle()
//        }
        
        let endLineInitialPosition = CGPoint(x: self.frame.width/2, y: self.frame.height/3)
        self.createEndLine(at: endLineInitialPosition)
    }
    
    private func setUpPhysicsWorld() {
        // TODO: Customize!
//        physicsWorld.gravity = CGVector(dx: 0, dy: -1.7) [BUILD NUMERO 3]
        physicsWorld.gravity = CGVector(dx: 0, dy: -1.45)
        physicsWorld.contactDelegate = self
    }
    
    private func restartGame() {
        self.gameLogic.restartGame()
    }
    private func createPlayer(at position: CGPoint) {
        self.player = SKSpriteNode(imageNamed: "Boat")
        self.player.name = "player"
        
        player.size = CGSize(width: 96, height: 96)
        player.xScale = CGFloat(1)
        player.yScale = CGFloat(1)
        player.position = position
        player.zPosition = 3
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: 30.0)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = false
        
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        
        player.physicsBody?.contactTestBitMask = PhysicsCategory.asteroid
        player.physicsBody?.collisionBitMask = PhysicsCategory.asteroid
        
        let xRange = SKRange(lowerLimit: 0, upperLimit: frame.width)
        let xConstraint = SKConstraint.positionX(xRange)
        self.player.constraints = [xConstraint]
        
        addChild(self.player)
    }
    
    private func createEndLine(at position: CGPoint) {
        endLine.name = "endLine"
        endLine.position = CGPoint(x: self.frame.width/2, y: self.frame.height/3.3)
        endLine.fillColor = .clear
        endLine.strokeColor = .clear
        endLine.zPosition = 2
        
        endLine.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        endLine.physicsBody?.affectedByGravity = false
        endLine.physicsBody?.isDynamic = false
        endLine.physicsBody?.categoryBitMask = PhysicsCategory.endLine
        endLine.physicsBody?.contactTestBitMask = PhysicsCategory.asteroid
        
        addChild(endLine)
    }
    
    func startAsteroidsCycle() {
        let createAsteroidAction = SKAction.run(createAsteroid)
//        let waitAction = SKAction.wait(forDuration: 0.25)
        let waitAction = SKAction.wait(forDuration: 0.32)
        
        let createAndWaitAction = SKAction.sequence([createAsteroidAction, waitAction])
        let asteroidCycleAction = SKAction.repeatForever(createAndWaitAction)
        
        run(asteroidCycleAction)
    }
}

// MARK: - Player Movement
//extension ArcadeGameScene {
//    private func moveLeft() {
//        self.player.physicsBody?
//            .applyForce(CGVector(dx: 5, dy: 0))
//        print("Moving Left: \(player.physicsBody!.velocity)")
//    }
//    private func moveRight() {
//        self.player.physicsBody?
//            .applyForce(CGVector(dx: -5, dy: 0))
//        print("Moving Right: \(player.physicsBody!.velocity)")
//    }
//}
// MARK: - Handle Player Inputs
extension ArcadeGameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self){
            player.run(SKAction.move(to: CGPoint(x:  playerPosition.x + location.x - startTouch.x, y: self.frame.height/2.5), duration: 0.1))
        }
        //grab current and previous locations
        let touchLoc = touch!.location(in: self)
        let prevTouchLoc = touch!.previousLocation(in: self)
        
        //get deltas and update node position
        let deltaX = touchLoc.x - prevTouchLoc.x
        player.position.x += deltaX
        
        //set x flip based on delta
//        player.xScale = deltaX < 0 ? 1 : -1
        if deltaX < 0 {
            player.xScale = 1
        } else if deltaX > 0 {
            player.xScale = -1
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
}


// MARK: - Game Over Condition
extension ArcadeGameScene {
    
    /**
     * Implement the Game Over condition.
     * Remember that an arcade game always ends! How will the player eventually lose?
     *
     * Some examples of game over conditions are:
     * - The time is over!
     * - The player health is depleated!
     * - The enemies have completed their goal!
     * - The screen is full!
     **/
    
    var isGameOver: Bool {
        // TODO: Customize!
        
        // Did you reach the time limit?
        // Are the health points depleted?
        // Did an enemy cross a position it should not have crossed?
        
        return gameLogic.isGameOver
    }
    
    private func finishGame() {
        
        // TODO: Customize!
        
        gameLogic.isGameOver = true
    }
    
}

// MARK: - Register Score
extension ArcadeGameScene {
    
    private func registerScore() {
        
        // TODO: Customize!
    }
    
}

// MARK: - Asteroids
extension ArcadeGameScene {
    
    private func createAsteroid() {
        let asteroidPosition = self.randomAsteroidPosition()
        newAsteroid(at: asteroidPosition)
    }
    
    private func randomAsteroidPosition() -> CGPoint {
//        let initialX: CGFloat = 25
//        let finalX: CGFloat = self.frame.width - 25
        
        let initialX: CGFloat = gameLogic.currentScore < 100 ? 115 : 25
        let finalX: CGFloat = gameLogic.currentScore < 100 ? self.frame.width - 115 : self.frame.width - 25
        
        let positionX = CGFloat.random(in: initialX...finalX)
        let positionY = frame.height - 100
        
        return CGPoint(x: positionX, y: positionY)
    }
    
    private func newAsteroid(at position: CGPoint) {
        let newAsteroid = SKSpriteNode(imageNamed: "plasticBottle")
        newAsteroid.name = "asteroid"
        
        newAsteroid.size = CGSize(width: 55, height: 55)
        newAsteroid.xScale = CGFloat(1)
        newAsteroid.yScale = CGFloat(1)
        newAsteroid.position = position
        newAsteroid.zPosition = 3
        
        newAsteroid.physicsBody = SKPhysicsBody(circleOfRadius: 10.0)
        newAsteroid.physicsBody?.affectedByGravity = true
        
        newAsteroid.physicsBody?.categoryBitMask = PhysicsCategory.asteroid
        
        newAsteroid.physicsBody?.contactTestBitMask = PhysicsCategory.player
        newAsteroid.physicsBody?.collisionBitMask = PhysicsCategory.player
        
        addChild(newAsteroid)
        
        newAsteroid.run(SKAction.sequence([
            SKAction.wait(forDuration: 3.8),
            SKAction.removeFromParent()
        ]))
    }
    
}


struct PhysicsCategory {
    static let none     : UInt32 = 0
    static let all      : UInt32 = UInt32.max
    static let player   : UInt32 = 0b1
    static let asteroid : UInt32 = 0b10
    static let endLine  : UInt32 = 0b101
}

// MARK: - Contacts and Collisions
extension ArcadeGameScene: SKPhysicsContactDelegate {
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody = contact.bodyA
        let secondBody: SKPhysicsBody = contact.bodyB
        
        if let node = firstBody.node, node.name == "player" {
            
        }
        
        if let node = secondBody.node, node.name == "asteroid" {
            node.removeFromParent()
            
            if(firstBody.node?.name == "player" && secondBody.node?.name == "asteroid") {
                gameLogic.score(points: 1)
//                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                let impactFeedback = UIImpactFeedbackGenerator(style: .soft)
                    impactFeedback.impactOccurred()
            }
            if(firstBody.node?.name != "player" && secondBody.node?.name == "asteroid") {
                gameLogic.loseHeart()
                run(lostLifeSound)
                gameLogic.bottleTouches()
            }
            if gameLogic.plasticTouches > 2 {
                finishGame()
            }
        }
    }
}
