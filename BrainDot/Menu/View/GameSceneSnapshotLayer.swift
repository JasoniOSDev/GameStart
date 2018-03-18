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
    var selected: Bool = false {
        didSet {
            self.setNeedsLayout()
        }
    }
    var move: Bool = false {
        didSet{
            if oldValue != self.move {
                self.setNeedsLayout()
            }
        }
    }
    var selectedShapeLayer: CAShapeLayer?
    init(with object: GameSceneObject) {
        super.init()
        self.sceneObject = object
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    class func layer(with object: GameSceneObject) -> GameSceneLayer{
        switch object.objectClass() {
        case .barrier:
            return GameSceneBarrierShapeLayer(with: object)
        case .ball:
            return GameSceneBallLayer(with: object)
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
    
    override init(layer: Any) {
        super.init(layer: layer)
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
        if self.selected {
            if self.selectedShapeLayer != nil {
                self.selectedShapeLayer?.lineWidth = self.move ? 6 : 4
                return
            }
            let layer = CAShapeLayer()
            layer.path = self.path
            layer.fillColor = nil
            layer.strokeColor = UIColor(colorHex: "82B2EA").cgColor
            layer.lineWidth = self.move ? 6 : 4
            self.selectedShapeLayer = layer
            self.addSublayer(layer)
        } else {
            if let shapeLayer = self.selectedShapeLayer {
                shapeLayer.removeFromSuperlayer()
                self.selectedShapeLayer = nil
            }
        }
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
    
    override init(layer: Any) {
        super.init(layer: layer)
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
        case BarrierType.circle.rawValue:
            let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.width / 2)
            self.path = path.cgPath
        case BarrierType.trapezoid.rawValue:
            let path = UIBezierPath()
            let topWidth = self.bounds.width * CGFloat((self.barrier?.topWidth)!)
            var point = CGPoint(x: 0, y: self.bounds.height)
            path.move(to: point)
            point.x = self.bounds.width
            path.addLine(to: point)
            point.y = 0
            point.x = self.bounds.width / 2 + topWidth / 2
            path.addLine(to: point)
            point.x = (self.bounds.width - topWidth) / 2
            path.addLine(to: point)
            path.close()
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
            path.addLine(to: CGPoint(x: self.bounds.width / 2, y:  self.bounds.height - sqrt(3) / 2 * size))
            path.addLine(to: CGPoint(x: (self.bounds.width - size) / 2, y: self.bounds.height))
            path.close()
            self.path = path.cgPath
        default:
            self.path = nil
        }
        self.fillColor = UIColor(colorHex: barrier.colorHex).cgColor
        
        if self.selected {
            if self.selectedShapeLayer != nil {
                self.selectedShapeLayer?.lineWidth = self.move ? 6 : 4
                return
            }
            let layer = CAShapeLayer()
            layer.path = self.path
            layer.fillColor = nil
            layer.strokeColor = UIColor(colorHex: "82B2EA").cgColor
            layer.lineWidth = self.move ? 6 : 4
            self.selectedShapeLayer = layer
            self.addSublayer(layer)
        } else {
            if let shapeLayer = self.selectedShapeLayer {
                shapeLayer.removeFromSuperlayer()
                self.selectedShapeLayer = nil
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
