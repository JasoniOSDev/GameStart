//
//  GameSceneSnapShotView.swift
//  BrainDot
//
//  Created by Jane Ren on 2018/2/24.
//  Copyright © 2018年 Jane Ren. All rights reserved.
//

import UIKit
import RealmSwift

class GameSceneSnapShotView: UIView {

    var sceneData: GameData?
    var barrierLayers: Array<GameSceneLayer> = Array()
    var ballLayers: Array<GameSceneLayer> = Array()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for layer in self.barrierLayers {
            self.refreshFrame(with: layer, offsetXPercent: layer.sceneObject.positionXOffset, offsetYPercent: layer.sceneObject.positionYOffset, layerWidthPercent: layer.sceneObject.sizeWidth, layerHeightPercent: layer.sceneObject.sizeHeight)
        }
        
        for layer in self.ballLayers {
            self.refreshFrame(with: layer, offsetXPercent: layer.sceneObject.positionXOffset, offsetYPercent: layer.sceneObject.positionYOffset, layerWidthPercent: layer.sceneObject.sizeWidth, layerHeightPercent: layer.sceneObject.sizeHeight)
        }
    }
    
    private func refreshFrame(with layer: CALayer, offsetXPercent: CGFloat, offsetYPercent: CGFloat, layerWidthPercent: CGFloat, layerHeightPercent: CGFloat) {
        let width = self.width
        let height = self.height
        let layerWidth = width * layerWidthPercent
        let layerHeight = height * layerHeightPercent
        let offsetX = width * offsetXPercent
        let offsetY = height * offsetYPercent
        let positionX = width / 2 + offsetX
        let positionY = height / 2 + offsetY
        
        layer.position = CGPoint(x: positionX, y: positionY)
        layer.bounds = CGRect(x: 0, y: 0, width: layerWidth, height: layerHeight)
        
    }
    
    func setupContentWithSceneData(sceneData: GameData) {
        defer {
            self.setNeedsLayout()
        }
        
        self.setupBarrierContent(with: sceneData.barriers)
        self.setupBallContent(with: sceneData.balls)
    }
    
    private func setupBarrierContent(with barriers: List<BarrierObject>) {
        
        for layer in barrierLayers {
            layer.removeFromSuperlayer()
        }
        
        for barrier in barriers {
            let layer = GameSceneLayer.layer(with: barrier)
            self.layer.addSublayer(layer)
            barrierLayers.append(layer)
        }
    }
    
    private func setupBallContent(with balls: List<BallObject>) {
        
        for layer in ballLayers {
            layer.removeFromSuperlayer()
        }
        
        for ball in balls {
            let layer = GameSceneLayer.layer(with: ball)
            self.layer.addSublayer(layer)
            ballLayers.append(layer)
        }
    }
}
