//
//  GameThirdMenuCollectionViewCell.swift
//  BrainDot
//
//  Created by chenjiesheng on 2018/2/24.
//  Copyright © 2018年 陈杰生. All rights reserved.
//

import UIKit

class GameThirdMenuCollectionViewCell: UICollectionViewCell {
    
    var sceneView: GameMenuSceneView!
    var sceneData: GameData? {
        didSet{
            sceneView.sceneData = self.sceneData
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSceneView()
    }
    
    private func createSceneView() {
        let sceneView = GameMenuSceneView(frame: self.bounds)
        sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(sceneView)
        self.sceneView = sceneView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
