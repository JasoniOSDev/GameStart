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

