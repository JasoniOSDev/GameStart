//
//  BubbleView.swift
//  BrainDot
//
//  Created by Jane Ren on 2018/2/20.
//  Copyright © 2018年 Jane Ren. All rights reserved.
//

import UIKit

class BubbleView: UIView {

    var color: UIColor!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(color: UIColor) {
        self.init(frame:CGRect.zero)
        self.color = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func draw(_ rect: CGRect) {
        if let colorComponents = self.color.cgColor.components {
            let context = UIGraphicsGetCurrentContext()
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let location: Array<CGFloat> = [0.0,1.0]
            var firstColorComponents = colorComponents
            firstColorComponents[3] = 0;
            var colors: Array<CGFloat> = []
            colors.append(contentsOf: firstColorComponents)
            colors.append(contentsOf: colorComponents)
            
            let grandient = CGGradient.init(colorSpace: colorSpace, colorComponents: colors, locations: location, count: 2)
            let selfSize = CGFloat.minimum(self.frame.width, self.frame.height)
            context?.clip(to: self.bounds)
            context?.drawRadialGradient(grandient!, startCenter: CGPoint(x: selfSize / 2 * 0.75, y: selfSize / 2 * 0.75), startRadius: 0, endCenter: CGPoint(x: selfSize / 2, y: selfSize / 2), endRadius: selfSize / 2, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
        }
    }
}
