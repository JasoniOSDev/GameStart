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
    var drawBarriers: Array<SKSpriteNode> = Array<SKSpriteNode>()
    var staticBarriers: Array<SKShapeNode> = Array<SKShapeNode>()
    var drawDatas: Array<DrawBarrier> = Array<DrawBarrier>()
    
    var curDrawBarrierData: DrawBarrier?
    var curDrawBarrierNode: SKShapeNode!
    
    var invalidDrawNode: SKShapeNode!
    var needUpdateCurDrawBarrierNode: Bool = false
    
    weak open var gameDelegate: MainGameSceneDelegate?
    
    init(size: CGSize, data:GameData) {
        super.init(size: size)
        self.backgroundColor = .white
        self.data = data
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = borderCategory
        self.physicsBody?.collisionBitMask = 0xFFFFFFFF
        self.physicsWorld.contactDelegate = self
        self.invalidDrawNode = self.createInvalidDrawNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.updateComonent(with: self.data)
    }
    
    func updateComonent(with data: GameData) {
        self.staticBarriers.forEach { node in
            node.removeFromParent()
        }
        self.staticBarriers.removeAll()
        self.balls.forEach { node in
            node.removeFromParent()
        }
        self.balls.removeAll()
        self.drawDatas.removeAll()
        self.drawBarriers.forEach { node in
            node.removeFromParent()
        }
        self.drawBarriers.removeAll()
        
        for barrier in data.barriers {
            if let barrierNode = self.createNode(with: barrier) {
                self.addChild(barrierNode)
                self.staticBarriers.append(barrierNode)
            }
        }
        
        for ball in data.balls {
            if let ballNode = self.createNode(with: ball) {
                self.addChild(ballNode)
                self.balls.append(ballNode)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if self.needUpdateCurDrawBarrierNode {
            self.needUpdateCurDrawBarrierNode = false
            if let path = self.curDrawBarrierData?.path {
                self.curDrawBarrierNode.path = path
            }
        }
    }
    
    func releaseForce() {
        for ball in self.balls {
            ball.physicsBody?.affectedByGravity = true
        }
        
        if let drawData = self.curDrawBarrierData, let _ = self.curDrawBarrierNode.path{
            if let texture = self.view?.texture(from: self.curDrawBarrierNode) {
                self.drawDatas.append(drawData)
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
                self.drawBarriers.append(drawBarrierNode)
            }
        }
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
        shapeNode.lineWidth = 20
        shapeNode.strokeTexture = SKTexture(imageNamed: "strokeTexture")
        shapeNode.lineCap = .round
        return shapeNode
    }
    
    func createInvalidDrawNode() -> SKShapeNode {
        let shapeNode = SKShapeNode()
        shapeNode.fillColor = .clear
        shapeNode.lineWidth = 20
        shapeNode.strokeTexture = SKTexture(imageNamed: "strokeTexture")
        shapeNode.lineCap = .round
        shapeNode.alpha = 0.5
        return shapeNode
    }
}

extension MainGameScene {
    //draw game scene
    
    fileprivate func createNode(with object: GameSceneObject) -> SKShapeNode? {
        
        var nodeWidth = object.sizeWidth * self.size.width
        var nodeHeight = object.sizeHeight * self.size.height
        let offsetX = object.positionXOffset * self.size.width
        let offsetY = object.positionYOffset * self.size.height
        let centerX = self.frame.midX + offsetX
        let centerY = self.frame.midY - offsetY
        var positionX = centerX - nodeWidth / 2
        var positionY = centerY - nodeHeight / 2
        let color = UIColor(colorHex: object.colorHex)
        switch object.objectClass() {
        case .barrier:
            if let barrier = object as? BarrierObject {
                var path:CGPath!
                switch barrier.barrierType {
                case BarrierType.rectangle.rawValue:
                    path = UIBezierPath(rect: CGRect(x: positionX, y: positionY, width: nodeWidth, height: nodeHeight)).cgPath
                case BarrierType.square.rawValue:
                    nodeWidth = CGFloat.minimum(nodeWidth, nodeHeight)
                    nodeHeight = nodeWidth
                    positionX = centerX - nodeWidth / 2
                    positionY = centerY - nodeHeight / 2
                    path = UIBezierPath(rect: CGRect(x: positionX, y: positionY, width: nodeWidth, height: nodeHeight)).cgPath
                case BarrierType.triangle.rawValue:
                    nodeWidth = CGFloat.minimum(nodeWidth, nodeHeight)
                    nodeHeight = nodeWidth
                    positionX = centerX - nodeWidth / 2
                    positionY = centerY - nodeHeight / 2
                    let tmpPath = UIBezierPath()
                    var x = -nodeWidth / 2 + positionX
                    var y = nodeHeight / 2 + positionY
                    tmpPath.move(to: CGPoint(x: x, y: y))
                    x += nodeWidth
                    tmpPath.addLine(to: CGPoint(x: x, y: y))
                    x = centerX
                    y = y - sqrt(3) / 2 * nodeWidth
                    tmpPath.addLine(to: CGPoint(x: x, y: y))
                    x = -nodeWidth / 2 + positionX
                    y = nodeHeight / 2 + positionY
                    tmpPath.addLine(to: CGPoint(x: x, y: y))
                    tmpPath.close()
                    path = tmpPath.cgPath
                default:
                    break
                }
                let shapeNode = SKShapeNode(path: path)
                shapeNode.fillColor = color
                shapeNode.strokeColor = .clear
                shapeNode.physicsBody = SKPhysicsBody(edgeLoopFrom: path)
                shapeNode.physicsBody?.categoryBitMask = staticBarrierCategory
                return shapeNode
            } else {
                return nil
            }
        case .ball:
            if let _ = object as? BallObject {
                nodeWidth = CGFloat.minimum(nodeWidth, nodeHeight)
                nodeHeight = nodeWidth
                positionX = centerX - nodeWidth / 2
                positionY = centerY - nodeHeight / 2
                let rect = CGRect(x: positionX, y: positionY, width: nodeWidth, height: nodeHeight)
                let path = UIBezierPath(roundedRect: rect, cornerRadius: nodeWidth / 2).cgPath
                let shapeNode = SKShapeNode(path: path)
                shapeNode.fillColor = color
                shapeNode.strokeColor = .clear
                shapeNode.physicsBody = SKPhysicsBody(circleOfRadius: nodeWidth / 2, center: CGPoint(x: rect.midX, y: rect.midY))
                shapeNode.physicsBody?.affectedByGravity = false
                shapeNode.physicsBody?.categoryBitMask = ballCategory
                shapeNode.physicsBody?.contactTestBitMask = ballCategory
                shapeNode.physicsBody?.collisionBitMask = 0xFFFFFFFF
                
                return shapeNode
            }
        }
        
        return nil
    }
}

extension MainGameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.curDrawBarrierData = nil
        if let touch = touches.first, touches.count == 1{
            let location = touch.location(in: self)
            
            if self.checkValidLocation(location: location) {
                var drawData = DrawBarrier()
                self.curDrawBarrierNode = self.createDrawBarrierWith(drawBarrier: curDrawBarrierData)
                self.addChild(self.curDrawBarrierNode)
                drawData.points.append(location)
                self.curDrawBarrierData = drawData
            }
        }
    }
    
    func checkValidLocation(location: CGPoint) -> Bool {
        
        return true
        
        for ball in self.balls {
            if ball.contains(location) {
                return false
            }
        }
        
        for barrier in self.staticBarriers {
            if barrier.contains(location) {
                return false
            }
        }
        
        guard let data = self.curDrawBarrierData,let lastPoint = data.points.last else {
            return true
        }
        
        for drawData in self.drawDatas {
            if let path = drawData.path {
                if path.crossingByLine(lastPoint, pointTwo: location) {
                    return false
                }
            }
        }
        
        for barrier in self.staticBarriers {
            if let path = barrier.path {
                if path.crossingByLine(lastPoint, pointTwo: location) {
                    return false
                }
            }
        }
        
        for ball in self.balls {
            if self.cross(point1: lastPoint, point2: location, circle: ball.position, radius: ball.frame.width){
                return false
            }
        }
        return true
    }
    
    func cross(point1: CGPoint, point2: CGPoint, circle center: CGPoint, radius: CGFloat) -> Bool{
        let k = (point2.y - point1.y) / (point2.x - point1.y)
        let b = point1.y - k * point1.x
        let a = center.x
        let c = center.y
        let r = radius
        let c2 = a * a + (b - c) * (b - c) - r * r
        let a2 = k * k + 1
        let b2 = 2 * (k * b - k * c - a)
        let dis = (b2 * b2 - 4 * a2 * c2)
        
        if dis < 0 {
            return false
        }
        
        let x1 = -b + sqrt(dis) / (2 * a2)
        let x2 = -b - sqrt(dis) / (2 * a2)
        
        if dis == 0 {
            //相切,判断点是否在直线内即可
            let minX = CGFloat.minimum(point1.x, point2.x)
            let maxX = CGFloat.maximum(point1.x, point2.x)
            return x1 >= minX && x2 <= maxX
        } else {
            let minX = CGFloat.minimum(x1, x2)
            let maxX = CGFloat.maximum(x1, x2)
            
            let minPointX = CGFloat.minimum(point1.x, point2.x)
            let maxPointX = CGFloat.maximum(point1.x, point2.x)
            
            return maxPointX >= minX || minPointX <= maxX
        }
    }
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first,var _ = self.curDrawBarrierData, touches.count == 1{
            let location = touch.location(in: self)
            if self.checkValidLocation(location: location) {
                self.curDrawBarrierData!.addNewDrawPoint(newLocation: location)
                self.needUpdateCurDrawBarrierNode = true
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.releaseForce()
    }
}

extension MainGameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        if (bodyA.categoryBitMask == ballCategory && bodyB.categoryBitMask == ballCategory) {
            self.isPaused = true
            if let delegate = self.gameDelegate {
                delegate.gameFinish(sceneData: self.data, balls: self.balls, barriers: self.staticBarriers, drawNode: self.drawBarriers)
            }
        }
    }
}











