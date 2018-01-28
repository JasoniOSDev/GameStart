//
//  GameViewController.swift
//  BrainDot
//
//  Created by chenjiesheng on 2018/1/19.
//  Copyright © 2018年 陈杰生. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let gameData = self.createGameData()
        let scene = MainGameScene(size: self.view.frame.size, data: gameData)
        if let view = self.view as? SKView {
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func createGameData() -> GameData {
        var gameData = GameData()
        gameData.balls.append(self.randomBall())
        gameData.balls.append(self.randomBall())
        gameData.barriers.append(self.randomBarrier())
        gameData.barriers.append(self.randomBarrier())
        return gameData
    }
    
    func randomBall() -> Ball {
        var ball = Ball()
        ball.color = .red
        ball.position = CGPoint(x: CGFloat(arc4random() % UInt32(self.view.frame.width)), y: CGFloat(arc4random() % UInt32(self.view.frame.height)))
        return ball
    }
    
    func randomBarrier() -> Barrier {
        var barrier = Barrier()
        barrier.fillColor = .green
        barrier.path = UIBezierPath(rect: CGRect(origin: CGPoint(x: CGFloat(arc4random() % UInt32(self.view.frame.width)), y: CGFloat(arc4random() % UInt32(self.view.frame.height))),
                                                  size: CGSize(width: 100, height: 100))).cgPath
        return barrier
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
