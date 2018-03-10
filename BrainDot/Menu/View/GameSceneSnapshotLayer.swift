//
//  GameSceneSnapshotLayer.swift
//  BrainDot
//
//  Created by Jane Ren on 2018/2/24.
//  Copyright © 2018年 Jane Ren. All rights reserved.
//

import UIKit

class GameSceneLayer: CAShapeLayer {
    
    var sceneObject: GameSceneObject!
    
    init(with object: GameSceneObject) {
        super.init()
        self.sceneObject = object
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func layer(with object: GameSceneObject) -> GameSceneLayer{
        switch object.objectClass() {
        case .barrier:
            return GameSceneBarrierShapeLayer(with: object)
        case .ball:
            return GameSceneBallLayer(with: object)
        default:
            return GameSceneLayer(with: object)
        }
    }
}

class GameSceneBallLayer: GameSceneLayer {
    
    var ball: BallObject?
    
    override init(with object: GameSceneObject) {
        super.init(with: object)
        if let ball = object as? BallObject {
            self.ball = ball
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        guard let ball = self.ball else {
            self.path = nil
            return
        }
        let size = CGFloat.minimum(self.bounds.width, self.bounds.height)
        let rect = CGRect(x: (self.bounds.width - size) / 2, y: (self.bounds.height - size) / 2, width: size, height: size)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: self.bounds.width / 2)
        self.path = path.cgPath
        self.fillColor = UIColor(colorHex: ball.colorHex).cgColor
        self.strokeColor = nil
    }
}

class GameSceneBarrierShapeLayer: GameSceneLayer {
    
    var barrier: BarrierObject?
    override init(with object: GameSceneObject) {
        super.init(with: object)
        if let barrier = object as? BarrierObject {
            self.barrier = barrier
        }
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        guard let barrier = self.barrier else {
            self.path = nil
            return
        }
        switch barrier.barrierType {
        case BarrierType.rectangle.rawValue:
            let path = UIBezierPath(rect: self.bounds)
            self.path = path.cgPath
        case BarrierType.square.rawValue:
            let size = CGFloat.minimum(self.bounds.width, self.bounds.height)
            let path = UIBezierPath(rect: CGRect(x: (self.bounds.width - size) / 2, y: (self.bounds.height - size), width: size, height: size))
            self.path = path.cgPath
        case BarrierType.triangle.rawValue:
            let size = CGFloat.minimum(self.bounds.width, self.bounds.height)
            let path = UIBezierPath()
            path.move(to: CGPoint(x: (self.bounds.width - size) / 2, y: self.bounds.height))
            path.addLine(to: CGPoint(x: (self.bounds.width + size) / 2, y: self.bounds.height))
            path.addLine(to: CGPoint(x: self.bounds.width / 2, y: (1 - sqrt(3)) / 2 * self.bounds.height))
            path.addLine(to: CGPoint(x: (self.bounds.width - size) / 2, y: self.bounds.height))
            path.close()
            self.path = path.cgPath
        default:
            self.path = nil
        }
        self.fillColor = UIColor(colorHex: barrier.colorHex).cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
