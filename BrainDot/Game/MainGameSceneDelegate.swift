//
//  MainGameSceneDelegate.swift
//  BrainDot
//
//  Created by chenjiesheng on 2018/2/26.
//  Copyright © 2018年 陈杰生. All rights reserved.
//

import SpriteKit

protocol MainGameSceneDelegate: class {
    
    func gameFinish(sceneData: GameData, balls: Array<SKShapeNode>, barriers: Array<SKShapeNode>, drawNode: Array<SKSpriteNode>)
}
