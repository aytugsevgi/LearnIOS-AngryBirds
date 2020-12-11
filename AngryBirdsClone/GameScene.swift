//
//  GameScene.swift
//  AngryBirdsClone
//
//  Created by aytug on 11.12.2020.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    var box1 = SKSpriteNode()
    var box2 = SKSpriteNode()
    var box3 = SKSpriteNode()
    var box4 = SKSpriteNode()
    var box5 = SKSpriteNode()
    var box6 = SKSpriteNode()
    
    var gameStarted = false
    var originalPosition : CGPoint?
    
    var score = 0
    var scoreLabel = SKLabelNode()
    enum ColliderType: UInt32 {
        case Bird = 1
        case Box = 2
    }
    override func didMove(to view: SKView) {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -frame.size.width/2, y: -frame.size.height/2 + frame.size.height*0.02, width: frame.size.width, height: frame.size.height*0.98))
        self.physicsWorld.contactDelegate = self
        /*
        let texture = SKTexture(imageNamed: "bird")
        bird2 = SKSpriteNode(texture: texture)
        bird2.position = CGPoint(x: 0, y: 0)
        bird2.size = CGSize(width: self.frame.width*0.05, height: self.frame.height*0.1)
        bird2.zPosition = 2
        self.addChild(bird2)
       */
        
        bird = childNode(withName: "bird") as! SKSpriteNode
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height/2)
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.mass = 0.15
        bird.physicsBody?.angularDamping = CGFloat(1)
        originalPosition = bird.position
        bird.physicsBody?.contactTestBitMask = ColliderType.Bird.rawValue
        bird.physicsBody?.categoryBitMask = ColliderType.Bird.rawValue
        bird.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
        
        box1 = childNode(withName: "box1") as! SKSpriteNode
        box2 = childNode(withName: "box2") as! SKSpriteNode
        box3 = childNode(withName: "box3") as! SKSpriteNode
        box4 = childNode(withName: "box4") as! SKSpriteNode
        box5 = childNode(withName: "box5") as! SKSpriteNode
        box6 = childNode(withName: "box6") as! SKSpriteNode
        let boxArray : [SKSpriteNode] = [box1,box2,box3,box4,box5,box6]
        for box in boxArray {
            initBoxPhysic(box: box)
        }
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 40
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: 0, y: self.frame.height*0.2)
        scoreLabel.zPosition = 3
        self.addChild(scoreLabel)

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.collisionBitMask == ColliderType.Bird.rawValue && contact.bodyB.collisionBitMask == ColliderType.Bird.rawValue {
            score += 1
            scoreLabel.text = String(score)
        }
    }
    
    
    func initBoxPhysic(box : SKSpriteNode){
        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: box1.size.width, height: box1.size.height))
        box.physicsBody?.affectedByGravity = true
        box.physicsBody?.isDynamic = true
        box.physicsBody?.mass = 0.1
        box.physicsBody?.allowsRotation = true
        box.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
    }
    
    func touchUp(atPoint pos : CGPoint) {
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        
        if !gameStarted {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchNodes = nodes(at: touchLocation)
                if touchNodes.isEmpty == false {
                    for node in touchNodes{
                        
                        if let sprite = node as? SKSpriteNode {
                            if sprite == bird {
                                bird.position = touchLocation
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameStarted {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchNodes = nodes(at: touchLocation)
                if touchNodes.isEmpty == false {
                    for node in touchNodes{
                        
                        if let sprite = node as? SKSpriteNode {
                            if sprite == bird {
                                bird.position = touchLocation
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameStarted {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchNodes = nodes(at: touchLocation)
                if touchNodes.isEmpty == false {
                    for node in touchNodes{
                        
                        if let sprite = node as? SKSpriteNode {
                            if sprite == bird {
                                let dx = -(touchLocation.x - originalPosition!.x)
                                let dy = -(touchLocation.y - originalPosition!.y)
                                
                                let impulse = CGVector(dx: 1.5*dx, dy: 1.5*dy)
                                bird.physicsBody?.applyImpulse(impulse)
                                bird.physicsBody?.affectedByGravity = true
                                gameStarted = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if let birdPhysic = bird.physicsBody{
            let velocityX = birdPhysic.velocity.dx
            let velocityY = birdPhysic.velocity.dy
            let angularVelocity = birdPhysic.angularVelocity
            
            if velocityX < 0.1 && velocityY < 0.1 && angularVelocity < 0.1 && gameStarted{
                
                restart()
                
            }
        }
        
        
        
        
    }
    @objc func restart(){
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.velocity = CGVector(dx:0,dy:0)
        bird.physicsBody?.angularVelocity = 0
        bird.zPosition = 2
        bird.position = originalPosition!
        gameStarted = false
        score = 0
        scoreLabel.text = String(score)
    }
}
