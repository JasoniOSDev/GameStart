//
//  MainGameScene.swift
//  BrainDot
//
//  Created by chenjiesheng on 2018/1/19.
//  Copyright © 2018年 陈杰生. All rights reserved.
//

import SpriteKit
import GameplayKit

let ballCategory: UInt32  = 0x1 << 0;  // 00000000000000000000000000000001
let borderCategory: UInt32 = 0x1 << 1; // 00000000000000000000000000000010
let staticBarrierCategory: UInt32 = 0x1 << 2;  // 00000000000000000000000000000100
let drawBarrierCategory: UInt32 = 0x1 << 3; // 00000000000000000000000000001000

class MainGameScene: SKScene {

    var data: GameData!
    var balls: Array<SKShapeNode> = Array<SKShapeNode>()
    var drawBarrier: Array<SKShapeNode> = Array<SKShapeNode>()
    
    var curDrawBarrierData: DrawBarrier!
    var curDrawBarrierNode: SKShapeNode!
    var needUpdateCurDrawBarrierNode: Bool = false
    init(size: CGSize, data:GameData) {
        super.init(size: size)
        self.data = data
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = borderCategory
        self.physicsBody?.collisionBitMask = 0xFFFFFFFF
        self.createComponent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if self.needUpdateCurDrawBarrierNode {
            self.needUpdateCurDrawBarrierNode = false
            if let path = self.curDrawBarrierData.path {
                self.curDrawBarrierNode.path = path
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let shapeNode = self.curDrawBarrierNode {
            self.drawBarrier.append(shapeNode)
        }

        if let touch = touches.first, touches.count == 1{
            self.curDrawBarrierData = DrawBarrier()
            self.curDrawBarrierNode = self.createDrawBarrierWith(drawBarrier: curDrawBarrierData)
            self.addChild(self.curDrawBarrierNode)
            let location = touch.location(in: self)
            self.curDrawBarrierData.points.append(location)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first, touches.count == 1 {
            let location = touch.location(in: self)
            self.curDrawBarrierData.addNewDrawPoint(newLocation: location)
            self.needUpdateCurDrawBarrierNode = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.releaseForce()
    }
    
    func releaseForce() {
        for ball in self.balls {
            ball.physicsBody?.affectedByGravity = true
        }
        
//        if let path = self.curDrawBarrierData.solidPath {
//            let borderShapeNode = SKShapeNode(path: path)
//            borderShapeNode.fillColor = .clear
//            borderShapeNode.strokeColor = .yellow
//            borderShapeNode.lineWidth = 1
//            self.addChild(borderShapeNode)
//        }
        if let _ = self.curDrawBarrierNode.path {
            if let texture = self.view?.texture(from: self.curDrawBarrierNode) {
                let drawBarrierNode = SKSpriteNode(texture: texture)
                drawBarrierNode.size = self.curDrawBarrierNode.frame.size
                drawBarrierNode.position = CGPoint(x: self.curDrawBarrierNode.frame.midX, y: self.curDrawBarrierNode.frame.midY)
                self.addChild(drawBarrierNode)
                self.curDrawBarrierNode.removeFromParent()
                drawBarrierNode.physicsBody = SKPhysicsBody(texture: texture, size: self.curDrawBarrierNode.frame.size)
                drawBarrierNode.physicsBody?.categoryBitMask = drawBarrierCategory
                drawBarrierNode.physicsBody?.collisionBitMask = 0xFFFFFFFF
                drawBarrierNode.physicsBody?.allowsRotation = true
                drawBarrierNode.physicsBody?.usesPreciseCollisionDetection = true
                drawBarrierNode.physicsBody?.affectedByGravity = true
            }
        }
    }
    
    func createComponent(){
        //创建球
        if let balls = self.data.balls {
            for ball in balls {
                let shapeNode = self.createBallWith(ball: ball)
                self.addChild(shapeNode)
                self.balls.append(shapeNode)
            }
        }
        
        //创建障碍物
        if let barriers = self.data.barriers {
            for barrier in barriers {
                if let shapeNode = self.createBarrierWith(barrier: barrier) {
                    self.addChild(shapeNode)
                }
            }
        }
        
        //创建测试node
//        let textNode = SKSpriteNode(texture: SKTexture(imageNamed: "texture"))
//        self.addChild(textNode)
//        textNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
//        textNode.physicsBody = SKPhysicsBody(texture: textNode.texture!, size: textNode.texture!.size())
    }
    
    func createBallWith(ball: Ball!) -> SKShapeNode {
        let shapeNode = SKShapeNode(circleOfRadius: ball.radius)
        shapeNode.fillColor = ball.color
        shapeNode.strokeColor = .clear
        shapeNode.position = ball.position
        shapeNode.physicsBody = SKPhysicsBody(circleOfRadius: ball.radius)
        shapeNode.physicsBody?.affectedByGravity = false
        shapeNode.physicsBody?.categoryBitMask = ballCategory
        shapeNode.physicsBody?.collisionBitMask = 0xFFFFFFFF
        return shapeNode
    }
    
    func createBarrierWith(barrier: Barrier!) -> SKShapeNode? {
        if let path = barrier.path {
            let shapeNode = SKShapeNode(path: path)
            shapeNode.position = barrier.position
            shapeNode.fillColor = barrier.fillColor
            shapeNode.strokeColor = barrier.stokeColor
            shapeNode.lineWidth = barrier.lineWidth
            shapeNode.physicsBody = SKPhysicsBody(polygonFrom: path)
            shapeNode.physicsBody?.isDynamic = false
            shapeNode.physicsBody?.categoryBitMask = staticBarrierCategory
            shapeNode.physicsBody?.collisionBitMask = 0xFFFFFFFF
            return shapeNode
        }
        return nil
    }
    
    func createDrawBarrierWith(drawBarrier: DrawBarrier!) -> SKShapeNode {
        let shapeNode = SKShapeNode()
        shapeNode.fillColor = .clear
//        shapeNode.strokeColor = .blue
        shapeNode.lineWidth = 20
        shapeNode.strokeTexture = SKTexture(imageNamed: "strokeTexture")
        shapeNode.lineCap = .round
        return shapeNode
    }
}


















