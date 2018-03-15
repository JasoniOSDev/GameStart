//
//  GameSceneVIew.swift
//  BrainDot
//
//  Created by chenjiesheng on 2018/3/10.
//  Copyright © 2018年 陈杰生. All rights reserved.
//

import UIKit

class GameSceneView: UIButton {

    var sceneLayer: GameSceneLayer?
    var sceneData: GameSceneObject!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(sceneData: GameSceneObject) {
        super.init(frame: .zero)
        self.refreshData(with: sceneData)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let layer = self.sceneLayer else {
            return
        }
        layer.bounds = CGRect(x: 0, y: 0, width: self.width * layer.sceneObject.sizeWidth, height: self.height * layer.sceneObject.sizeHeight)
        layer.position = CGPoint(x: self.width / 2, y: self.height / 2)
        layer.setNeedsLayout()
    }
    
    func refreshData(with data: GameSceneObject) {
        self.sceneData = data
        if let layer = self.sceneLayer {
            layer.removeFromSuperlayer()
            self.sceneLayer = nil
        }
        let layer = GameSceneLayer.layer(with: data)
        self.layer.addSublayer(layer)
        self.sceneLayer = layer
        self.setNeedsLayout()
    }
    
}
