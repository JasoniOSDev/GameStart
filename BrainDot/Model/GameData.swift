//
//  GameData.swift
//  BrainDot
//
//  Created by Jane Ren on 2018/1/19.
//  Copyright © 2018年 Jane Ren. All rights reserved.
//

import SpriteKit
import RealmSwift

struct GameMenu {
    var iconImageName: String!
    var menuName: String!
    var menuID: Int!
}

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
    //用户绘制的图形主要是路径
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
    //每个路径由多个点组成的
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

enum BarrierType: Int {
    case rectangle = 0
    case square = 1
    case triangle = 2
    case circle
    case trapezoid
}

enum SceneBorder: Int {
    case top = 1
    case bottom = 2
    case left = 4
    case right = 8
}

enum GameSceneObjectClass: Int {
    case barrier
    case ball
}

class GameSceneObject: Object {
    @objc dynamic var sizeWidth: CGFloat = 0.06
    @objc dynamic var sizeHeight: CGFloat = 0.06
    @objc dynamic var positionXOffset: CGFloat = 0.0
    @objc dynamic var positionYOffset: CGFloat = 0.0
    @objc dynamic var colorHex = "000000"
    
    func toJson() -> [String : Any] {
        var Json = [String : Any]()
        Json["sizeWidth"] = sizeWidth
        Json["sizeHeight"] = sizeHeight
        Json["positionXOffset"] = positionXOffset
        Json["positionYOffset"] = positionYOffset
        Json["colorHex"] = colorHex
        return Json
    }
    
    override func copy() -> Any {
        let object = GameSceneObject()
        object.sizeWidth = self.sizeWidth
        object.sizeHeight = self.sizeHeight
        object.positionXOffset = self.positionXOffset
        object.positionYOffset = self.positionYOffset
        object.colorHex = self.colorHex
        return object
    }
    
    func objectClass() -> GameSceneObjectClass {
        return .barrier
    }
    
    func fullSize() {
        self.sizeWidth = 1
        self.sizeHeight = 1
    }
    
    func setSize(newSize: CGSize) {
        let screenSize = UIScreen.main.bounds.size
        self.sizeWidth = newSize.width / screenSize.width
        self.sizeHeight = newSize.height / screenSize.height
    }
    
    func setPercentSize(width: CGFloat, height: CGFloat) {
        self.sizeWidth = width
        self.sizeHeight = height
    }
    
    func setPercentSize(newPercentSize: CGSize) {
        self.sizeWidth = newPercentSize.width
        self.sizeHeight = newPercentSize.height
    }
    
    func setPercentPosition(newPercenterPosition: CGPoint) {
        self.positionXOffset = newPercenterPosition.x
        self.positionYOffset = newPercenterPosition.y
    }
    
    func setPercentPosition(x: CGFloat, y: CGFloat) {
        self.positionXOffset = x
        self.positionYOffset = y
    }
    
    func updatePosition(newPoint: CGPoint) {
        let screenCenter = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        let screenSize = UIScreen.main.bounds.size
        self.positionXOffset = (newPoint.x - screenCenter.x) / screenSize.width
        self.positionYOffset = (newPoint.y - screenCenter.y) / screenSize.height
    }
    
    func position(rect: CGRect) -> CGPoint {
        let size = rect.size
        var position = CGPoint(x: size.width / 2, y: size.height / 2)
        position.x += size.width * self.positionXOffset;
        position.y += size.height * self.positionYOffset;
        return position;
    }
    
    func updatePositionWith(diff point: CGPoint) {
        var originPosition = self.position(rect: UIScreen.main.bounds)
        originPosition.x += point.x
        originPosition.y += point.y
        self.updatePosition(newPoint: originPosition)
    }
}

class BarrierObject: GameSceneObject {
    @objc dynamic var barrierType = 0
    @objc dynamic var topWidth = 0.5 //顶部的宽度是整体宽度的百分比
    override func copy() -> Any {
        let object = BarrierObject()
        object.sizeWidth = self.sizeWidth
        object.sizeHeight = self.sizeHeight
        object.positionXOffset = self.positionXOffset
        object.positionYOffset = self.positionYOffset
        object.colorHex = self.colorHex
        object.barrierType = self.barrierType
        return object
    }
    
    override func toJson() -> [String : Any] {
        var json = super.toJson()
        json["barrierType"] = barrierType
        json["topWidth"] = topWidth
        return json
    }
}

class BallObject: GameSceneObject {
    
    override func objectClass() -> GameSceneObjectClass {
        return .ball
    }
    
    override func copy() -> Any {
        let object = BallObject()
        object.sizeWidth = self.sizeWidth
        object.sizeHeight = self.sizeHeight
        object.positionXOffset = self.positionXOffset
        object.positionYOffset = self.positionYOffset
        object.colorHex = self.colorHex
        return object
    }
}

class UserDrawObject: Object {
    @objc dynamic var imageData: NSData?
    @objc dynamic var positionXOffset = 0.0
    @objc dynamic var positionYOffset = 0.0
}

class SceneDataGroup: Object {
    let sceneDatas = List<GameData>()
    @objc dynamic var lock = true
    @objc dynamic var groupIndex = 0
}

class GameData: Object {
    var balls = List<BallObject>()
    var barriers = List<BarrierObject>()
    @objc dynamic var userCustom = false //是否是用户自定义
    @objc dynamic var userFavorite = false //用户是否收藏
    @objc dynamic var userConquer = false //是否已经通过
    @objc dynamic var index = 0
    @objc dynamic var lock = true
    
    func toJson() -> [String : Any] {
        var json = [String : Any]()
        if balls.count > 0 {
            var balls = [[String : Any]]()
            self.balls.forEach { object in
                balls.append(object.toJson())
            }
            json["balls"] = balls
        }
        if self.barriers.count > 0 {
            var barriers = [[String : Any]]()
            self.barriers.forEach { object in
                barriers.append(object.toJson())
            }
            json["barriers"] = barriers
        }
        json["userCustom"] = self.userCustom
        json["userFavorite"] = self.userFavorite
        json["userConquer"] = self.userConquer
        json["index"] = self.index
        json["lock"] = self.lock
        return json
    }
    
    func toJsonStr() -> String? {
        let json = self.toJson()
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        let str = String(data: jsonData, encoding: .utf8)
        return str
    }
}

