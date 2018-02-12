//
//  GameData.swift
//  BrainDot
//
//  Created by chenjiesheng on 2018/1/19.
//  Copyright © 2018年 陈杰生. All rights reserved.
//

import SpriteKit

struct Ball {
    var color: UIColor! = .black
    var radius: CGFloat = 10
    var position: CGPoint = CGPoint.zero
}

struct Barrier {
    var path: CGPath?
    var position: CGPoint! = CGPoint.zero
    var fillColor: UIColor! = .gray
    var stokeColor: UIColor! = .black
    var lineWidth: CGFloat = 2
    
}

struct DrawPan {
    var textureName: String!
    var texture: SKTexture{
        get {
            return SKTexture(imageNamed: self.textureName)
        }
    }
    var panName: String!
    var displayTextureName: String!
    var displayTexture: SKTexture {
        get {
            return SKTexture(imageNamed: self.displayTextureName)
        }
    }
}

struct DrawBarrier {
    var path: CGPath? {
        get {
            if self.points.count > 1 {
                let path = CGMutablePath()
                if let firstPoint = self.points.first {
                    path.move(to: firstPoint)
                    for i in 1 ..< self.points.count {
                        let point = self.points[i]
                        path.addLine(to: point)
                    }
                    return path
                }
                
            }
            return nil
        }
    }
    var points: Array<CGPoint> = Array<CGPoint>()
    var solidPointListOne: Array<CGPoint> = Array<CGPoint>()
    var solidPointListTwo: Array<CGPoint> = Array<CGPoint>()
    var solidPath:CGPath? {
        get {
            if self.points.count > 1 {
                let path = CGMutablePath()
                if let firstPoint = self.solidPointListOne.first {
                    path.move(to: firstPoint)
                    for i in 1 ..< self.solidPointListOne.count {
                        let point = self.solidPointListOne[i]
                        path.addLine(to: point)
                    }
                    for i in (0 ... (self.solidPointListTwo.count - 1)).reversed()  {
                        let point = self.solidPointListTwo[i]
                        path.addLine(to: point)
                    }
                    path.addLine(to: firstPoint)
                }
                return path
            }
            return nil;
        }
    }
    
    mutating func addNewDrawPoint(newLocation: CGPoint) {
        if let lastLocation = self.points.last,self.points.count == 1 {
            let k = (newLocation.y - lastLocation.y) / (newLocation.x - lastLocation.x)
            let angel = atan(k)
            let lineWidth:CGFloat = 10;
            let offsetY = fabs(lineWidth * cos(angel))
            let offsetX = fabs(lineWidth * sin(angel))
            let point1 = CGPoint(x: lastLocation.x + offsetX, y: lastLocation.y + offsetY)
            let point2 = CGPoint(x: newLocation.x + offsetX, y: newLocation.y + offsetY)
            let point3 = CGPoint(x: newLocation.x - offsetX, y: newLocation.y - offsetY)
            let point4 = CGPoint(x: lastLocation.x - offsetX, y: lastLocation.y - offsetY)
            self.solidPointListOne.append(point1)
            self.solidPointListOne.append(point2)
            self.solidPointListTwo.append(point3)
            self.solidPointListTwo.append(point4)
        } else if let lastLocation = self.points.last,
            self.points.count > 1{
            let k = (newLocation.y - lastLocation.y) / (newLocation.x - lastLocation.x)
            let angel = atan(k)
            let lineWidth:CGFloat = 10;
            let offsetY = fabs(lineWidth * cos(angel))
            let offsetX = fabs(lineWidth * sin(angel))
            let point2 = CGPoint(x: newLocation.x + offsetX, y: newLocation.y + offsetY)
            let point3 = CGPoint(x: newLocation.x - offsetX, y: newLocation.y - offsetY)
            self.solidPointListOne.append(point2)
            self.solidPointListTwo.append(point3)
        }
        self.points.append(newLocation)
    }
}

struct GameData {
    var balls: Array<Ball>! = Array<Ball>()
    var barriers: Array<Barrier>! = Array<Barrier>()
}
