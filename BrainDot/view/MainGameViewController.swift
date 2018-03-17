//
//  MainGameViewController.swift
//  BrainDot
//
//  Created by chenjiesheng on 2018/3/17.
//  Copyright © 2018年 陈杰生. All rights reserved.
//

import UIKit
import SpriteKit
class MainGameViewController: UIViewController {

    var gameView: GameView!
    var gameScene: MainGameScene?
    var gameData: GameData!
    init(gameData: GameData) {
        super.init(nibName: nil, bundle: nil)
        self.gameData = gameData
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creaComponent()
    }
    
    func creaComponent() {
        self.createGameView()
    }
    
    func createGameView(){
        let view = GameView(frame: self.view.bounds)
        view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.backgroundColor = .clear
        view.gameViewDelegate = self
        self.view.addSubview(view)
        self.gameView = view
        
        let gameScene = MainGameScene(size: self.view.frame.size, data: self.gameData)
        gameScene.gameDelegate = self;
        view.presentScene(gameScene)
    }
}

extension MainGameViewController: GameViewDelegate,MainGameSceneDelegate {
    func gameFinish(sceneData: GameData, balls: Array<SKShapeNode>, barriers: Array<SKShapeNode>, drawNode: Array<SKSpriteNode>) {
        
    }
    
    func gameViewBackButtonClicked(view: GameView) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func gameViewRetryButtonClicked(view: GameView) {
        if let gameScene = view.scene as? MainGameScene,let data = gameScene.data {
            let newScene = MainGameScene(size: gameScene.size, data: data)
            newScene.gameDelegate = self
            view.presentScene(newScene)
        }
    }
    
    func gameViewNextButtonClicked(view: GameView) {
        
    }
    
}
