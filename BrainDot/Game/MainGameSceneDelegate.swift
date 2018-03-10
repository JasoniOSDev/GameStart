//
//  MainGameSceneDelegate.swift
//  BrainDot
//
//  Created by Jane Ren on 2018/2/26.
//  Copyright © 2018年 Jane Ren. All rights reserved.
//

import SpriteKit

protocol MainGameSceneDelegate: class {
    
    func gameFinish(sceneData: GameData, balls: Array<SKShapeNode>, barriers: Array<SKShapeNode>, drawNode: Array<SKSpriteNode>)
}
