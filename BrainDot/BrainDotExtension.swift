//
//  UIColor+BrainDot.swift
//  BrainDot
//
//  Created by chenjiesheng on 2018/2/21.
//  Copyright © 2018年 陈杰生. All rights reserved.
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
            self.frame.origin = CGPoint(x: left, y: self.frame.minY)
        }
        get {
            return self.frame.minX
        }
    }
    
    var top: CGFloat {
        set {
            self.frame.origin = CGPoint(x: self.left, y: top)
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

//func adjust(with value: CGFloat) -> CGFloat {
//    if UIScreen.main.bounds.width < 375 {
//        return value * .9
//    }
//    return value
//}

