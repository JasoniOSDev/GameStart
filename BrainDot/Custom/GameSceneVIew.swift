//
//  GameSceneVIew.swift
//  BrainDot
//
//  Created by chenjiesheng on 2018/3/10.
//  Copyright © 2018年 陈杰生. All rights reserved.
//

import UIKit

class GameSceneView: UIView {

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
        layer.frame = self.bounds
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
