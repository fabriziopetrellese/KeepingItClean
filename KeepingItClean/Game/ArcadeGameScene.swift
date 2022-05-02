//
//  ArcadeGameScene.swift
//  ArcadeGameTemplate
//

import SpriteKit
import SwiftUI

class ArcadeGameScene: SKScene {
    var player: SKSpriteNode!
    var playerPosition = CGPoint()
    var startTouch = CGPoint()
    var background = SKSpriteNode(imageNamed: "background")
    var endLine = SKShapeNode(rectOf: CGSize(width: 890, height: 10))
    let lostLifeSound = SKAction.playSoundFileNamed("lostLife2", waitForCompletion: false)
    let bottleCatched = SKAction.playSoundFileNamed("collision2", waitForCompletion: false)
    let powerup = SKAction.playSoundFileNamed("goldBottle2", waitForCompletion: false)
    
    var gameLogic: ArcadeGameLogic = ArcadeGameLogic.shared
    var lastUpdate: TimeInterval = 0
    var goldBottle: Bool = false
    var timer: Int = 0
    
    override func didMove(to view: SKView) {
        
        addPollution()
        self.setUpGame()
        self.setUpPhysicsWorld()
        background.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        background.zPosition = 1
        addChild(background)
        
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.myTimer()
        })
    }
    
    func addPollution() {
        
        if gameLogic.plasticTouches > 0 && gameLogic.plasticTouches < 2 {
            let pollution = SKSpriteNode(imageNamed: "Riga1")
            pollution.zPosition = 1
            pollution.position = CGPoint(x: self.frame.width/2, y: self.frame.height/12.2)
            addChild(pollution)
        }
        
        if gameLogic.plasticTouches > 1 && gameLogic.plasticTouches < 3 {
            let pollution = SKSpriteNode(imageNamed: "Riga2")
            pollution.zPosition = 1
            pollution.position = CGPoint(x: self.frame.width/1.997, y: self.frame.height/7.56)
            addChild(pollution)
        }
    }
    
    func myTimer() {
        
        run(.wait(forDuration: 1), completion: {
            
            self.timer += 1
            
            if (self.timer % 30) == 0{
                self.goldBottle = true
            }
            
            if (self.timer % 45) == 0 {
                self.physicsWorld.gravity = CGVector(dx: 0, dy: self.physicsWorld.gravity.dy - 0.35)
            }
            
            self.myTimer()
        })
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if self.isGameOver {
            self.finishGame()
        }
        
        if self.lastUpdate == 0 { self.lastUpdate = currentTime }
        
        let timeElapsedSinceLastUpdate = currentTime - self.lastUpdate
        self.gameLogic.increaseSessionTime(by: timeElapsedSinceLastUpdate)
        
        self.lastUpdate = currentTime
    }
}

extension ArcadeGameScene {
    
    private func setUpGame() {
        self.gameLogic.setUpGame()
        let playerInitialPosition = CGPoint(x: self.frame.width/2, y: self.frame.height/2.5)
        self.createPlayer(at: playerInitialPosition)
        
        self.startAsteroidsCycle()
        
        let endLineInitialPosition = CGPoint(x: self.frame.width/2, y: self.frame.height/3)
        self.createEndLine(at: endLineInitialPosition)
    }
    
    private func setUpPhysicsWorld() {
//        physicsWorld.gravity = CGVector(dx: 0, dy: -1.7)
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
        let waitAction = SKAction.wait(forDuration: 0.37)
        
        let createAndWaitAction = SKAction.sequence([createAsteroidAction, waitAction])
        let asteroidCycleAction = SKAction.repeatForever(createAndWaitAction)
        
        run(asteroidCycleAction)
    }
}

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
        if deltaX < 0 {
            player.xScale = 1
        } else if deltaX > 0 {
            player.xScale = -1
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
}

extension ArcadeGameScene {
    
    var isGameOver: Bool {
        
        return gameLogic.isGameOver
    }
    
    private func finishGame() {
        
        
        if gameLogic.currentScore > gameLogic.highScore {
            gameLogic.highScore = gameLogic.currentScore
        }
        
        gameLogic.isGameOver = true
    }
}

extension ArcadeGameScene {
    
    private func createAsteroid() {
        let asteroidPosition = self.randomAsteroidPosition()
        newAsteroid(at: asteroidPosition)
    }
    
    private func randomAsteroidPosition() -> CGPoint {
        
        let initialX: CGFloat = self.timer < 60 ? 115 : 25
        let finalX: CGFloat = self.timer < 60 ? self.frame.width - 115 : self.frame.width - 25
        
        let positionX = CGFloat.random(in: initialX...finalX)
        let positionY = frame.height - 100
        
        return CGPoint(x: positionX, y: positionY)
    }
    
    private func newAsteroid(at position: CGPoint) {
        let newAsteroid: SKSpriteNode
        
        if goldBottle {
            newAsteroid = SKSpriteNode(imageNamed: "goldBottle")
        } else {
            newAsteroid = SKSpriteNode(imageNamed: "plasticBottle")
        }
        
        newAsteroid.name = goldBottle ? "goldBottle" : "asteroid"
        
        if goldBottle {
            goldBottle = false
        }
        
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
                run(bottleCatched)
            }
            
            if(firstBody.node?.name != "player" && secondBody.node?.name == "asteroid") {
                gameLogic.loseHeart()
                run(lostLifeSound)
                gameLogic.bottleTouches()
                addPollution()
            }
        }
        
        if let node = secondBody.node, node.name == "goldBottle" {
            node.removeFromParent()
            
            if(firstBody.node?.name == "player" && secondBody.node?.name == "goldBottle") {
                gameLogic.score(points: 50)
                run(powerup)
            }
            
            if(firstBody.node?.name != "player" && secondBody.node?.name == "goldBottle") {
                gameLogic.loseHeart()
                run(lostLifeSound)
                gameLogic.bottleTouches()
                addPollution()
            }
        }
        
        if gameLogic.plasticTouches > 2 {
            finishGame()
        }
    }
}
