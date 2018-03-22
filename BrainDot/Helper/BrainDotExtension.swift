//
//  UIColor+BrainDot.swift
//  BrainDot
//
//  Created by Jane Ren on 2018/2/21.
//  Copyright © 2018年 Jane Ren. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(colorHex: String) {
        let newColorHex = colorHex.replacingOccurrences(of: "#", with: "")
        var rgb: Array<CGFloat> = Array()
        var startIndex = newColorHex.startIndex
        while !newColorHex.isEmpty {
            if let endIndex = newColorHex.index(startIndex, offsetBy: 2, limitedBy: newColorHex.endIndex) {
                let color = newColorHex[startIndex ..< endIndex]
                if let colorValue = Int(String(color),radix:16) {
                    let value = CGFloat(colorValue) / 255.0
                    rgb.append(value)
                }
                startIndex = endIndex
            } else {
                break
            }
        }
        if rgb.count < 4 {
            rgb.append(1)
        }
        self.init(red: rgb[0], green: rgb[1], blue: rgb[2], alpha: rgb[3])
    }
}

extension UIView {
    var left: CGFloat {
        set {
            self.frame.origin = CGPoint(x: newValue, y: self.frame.minY)
        }
        get {
            return self.frame.minX
        }
    }
    
    var top: CGFloat {
        set {
            self.frame.origin = CGPoint(x: self.left, y: newValue)
        }
        get {
            return self.frame.minY
        }
    }
    var bottom: CGFloat {
        set {
            self.top = newValue - self.frame.height
        }
        get {
            return self.top + self.frame.height
        }
    }
    
    var right: CGFloat {
        set {
            self.left = newValue - self.frame.width
        }
        get {
            return self.left + self.frame.width
        }
    }
    
    var midY: CGFloat {
        set {
            self.top = newValue - self.frame.height / 2
        }
        get {
            return self.frame.midY
        }
    }
    
    var midX: CGFloat {
        set {
            self.left = newValue - self.frame.height / 2
        }
        get {
            return self.frame.midX
        }
    }
    
    var height: CGFloat {
        set {
            self.frame.size = CGSize(width: self.frame.width, height: newValue)
        }
        get {
            return self.frame.height
        }
    }
    
    var width: CGFloat {
        set {
            self.frame.size = CGSize(width: newValue, height: self.frame.height)
        }
        get {
            return self.frame.width
        }
    }
}

extension CGPath {
    func crossing(by path: CGPath) -> Bool {
        var lastPoint: CGPoint = CGPoint.zero
        var stop = false
        
        self.forEach { element in
            if stop {
                return
            }
            switch element.type {
            case .moveToPoint:
                lastPoint = element.points[0]
            case .addLineToPoint:
                let curPoint = element.points[0]
                if path.crossingByLine(lastPoint, pointTwo: curPoint) {
                    stop = true
                }
                lastPoint = curPoint
            case .addQuadCurveToPoint:
                break
            case .addCurveToPoint:
                break
            case .closeSubpath:
                break
            }
        }
        return stop
    }
    
    func crossingByLine(_ pointOne: CGPoint, pointTwo: CGPoint) -> Bool {
        var lastPoint: CGPoint = CGPoint.zero
        var stop = false
        
        self.forEach { element in
            if stop {
                return
            }
            switch element.type {
            case .moveToPoint:
                lastPoint = element.points[0]
            case .addLineToPoint:
                let curPoint = element.points[0]
                if CGPath.lineCross(with: pointOne, line1End: pointTwo, line2Start: lastPoint, line2End: curPoint) {
                    stop = true
                }
                lastPoint = curPoint
            case .addQuadCurveToPoint:
                break
            case .addCurveToPoint:
                break
            case .closeSubpath:
                break
            }
        }
        
        return stop
    }
    
    class func lineCross(with line1Start: CGPoint, line1End: CGPoint, line2Start: CGPoint, line2End: CGPoint) -> Bool {
        let d1 = CGPath.chaji(with: line1Start, line1End: line1End, point3: line2Start)
        let d2 = CGPath.chaji(with: line1Start, line1End: line1End, point3: line2End)
        let d3 = CGPath.chaji(with: line2Start, line1End: line2End, point3: line1Start)
        let d4 = CGPath.chaji(with: line2Start, line1End: line2End, point3: line1End)
        
        return d1 * d2 < 0 && d3 * d4 < 0
    }
    
    class func chaji(with line1Start: CGPoint, line1End: CGPoint, line2Start: CGPoint, line2End: CGPoint) -> CGFloat {
        let point1 = CGPoint(x: line1End.x - line1Start.x, y: line1End.y - line1Start.y)
        let point2 = CGPoint(x: line2End.x - line2Start.x, y: line2End.y - line2Start.y)
        return point1.x * point2.y - point1.y * point2.x
    }
    
    class func chaji(with line1Start: CGPoint, line1End: CGPoint, point3:CGPoint) -> CGFloat {
        return CGPath.chaji(with: line1Start, line1End: line1End, line2Start: line1Start, line2End: point3)
    }
    
    func forEach(_ body: @escaping (CGPathElement) -> Void) {
        var info = body
        self.apply(info: &info) { (infoPtr, elementPtr) in
            let opaquePtr = OpaquePointer(infoPtr!)
            let body = UnsafeMutablePointer<(CGPathElement) -> Void>(opaquePtr).pointee
            body(elementPtr.pointee)
        }
    }
    
    func getPathElementsPoints() -> [CGPoint] {
        var arrayPoints : [CGPoint]! = [CGPoint]()
        self.forEach { element in
            switch (element.type) {
            case .moveToPoint:
                arrayPoints.append(element.points[0])
            case .addLineToPoint:
                arrayPoints.append(element.points[0])
            case .addQuadCurveToPoint:
                arrayPoints.append(element.points[0])
                arrayPoints.append(element.points[1])
            case .addCurveToPoint:
                arrayPoints.append(element.points[0])
                arrayPoints.append(element.points[1])
                arrayPoints.append(element.points[2])
            default: break
            }
        }
        return arrayPoints
    }
}

