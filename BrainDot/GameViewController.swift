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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    var bubbleViewContainerView: UIView!
    var effectView: UIVisualEffectView!
    var animator: UIDynamicAnimator!
    var bubbleViewStopAttachments: Array<UIAttachmentBehavior>! = Array()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createCompoent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for behavior in self.bubbleViewStopAttachments {
            self.animator.addBehavior(behavior)
        }
    }
    
    func createCompoent() {
        self.createEffectView()
        self.createBubbleViews()
        self.createDynamic()
        
        CATransaction.begin()
        UIView.setAnimationRepeatCount(MAXFLOAT)
        UIView.animateKeyframes(withDuration: 5, delay: 0, options: [.calculationModeCubic,.repeat], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.tipLabel.alpha = 0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.tipLabel.alpha = 1
            })
        }, completion: nil)
        CATransaction.commit()
        
        for subView in self.view.subviews {
            subView.isUserInteractionEnabled = false
        }
    }
    
    func createEffectView() {
        let effect = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: effect)
        self.view.addSubview(effectView)
        self.view.sendSubview(toBack: effectView)
        effectView.frame = self.view.bounds
        effectView.alpha = 0.7
        effectView.backgroundColor = .clear
        self.effectView = effectView
    }
    
    func createBubbleViews() {
        let containerView = UIView(frame: self.view.bounds)
        containerView.backgroundColor = .white
        self.view.insertSubview(containerView, belowSubview: self.effectView)
        self.bubbleViewContainerView = containerView
        
        let bubbleViewConfig: Array = [
            ["size":CGSize(width: 100, height: 100),
             "color": "99FFB6",
             "centerOffset": CGPoint(x: -56.5, y: 76.5)],
            ["size":CGSize(width: 125, height: 125),
             "color": "FCFF99",
             "centerOffset": CGPoint(x: 56, y: -61)],
            ["size":CGSize(width: 160, height: 160),
             "color": "FF99B0",
             "centerOffset": CGPoint(x: 55.5, y: 56.5)],
            ["size": CGSize(width: 200, height: 200),
             "color": "49EAF7",
             "centerOffset": CGPoint(x: -24.5, y: -23.5)]
        ]
        for dict in bubbleViewConfig {
            let size:CGSize = dict["size"] as! CGSize
            let colorHex:String = dict["color"] as! String
            let centerOffset:CGPoint = dict["centerOffset"] as! CGPoint
            let bubbleview = self.createBubbleView(size: size, colorHex: colorHex)
            self.bubbleViewContainerView.addSubview(bubbleview)
            bubbleview.center = self.view.center
            bubbleview.center.x += centerOffset.x
            bubbleview.center.y += centerOffset.y
        }
    }
    
    func createBubbleView(size: CGSize, colorHex: String) -> BubbleView{
        let bubbleView = BubbleView(frame: CGRect.zero)
        bubbleView.frame.size = size
        bubbleView.color = UIColor(colorHex: colorHex)
        bubbleView.backgroundColor = .clear
        return bubbleView
    }
    
    func createDynamic() {
        self.animator = UIDynamicAnimator(referenceView: self.bubbleViewContainerView)
        for view in self.bubbleViewContainerView.subviews {
            let attachment = UIAttachmentBehavior(item: view, attachedToAnchor: view.center)
            attachment.length = 20
            attachment.damping = 0
            attachment.frequency = 0.3
            self.bubbleViewStopAttachments.append(attachment)
            let randomOffset = CGFloat(arc4random() % 30)
//            if randomOffset < 15 {
//                randomOffset = -CGFloat(arc4random() % 30)
//                if (randomOffset > -10) {
//                    randomOffset = -10
//                }
//            }
            view.center.y -= randomOffset
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.view.isUserInteractionEnabled = false
        //开始游戏
        for behavior in self.bubbleViewStopAttachments {
            behavior.anchorPoint.y = -200
            if behavior.anchorPoint.x <= self.view.center.x {
                behavior.anchorPoint.x -= CGFloat(arc4random() % 200)
            } else {
                behavior.anchorPoint.x += CGFloat(arc4random() % 200)
            }
        }
        UIView.animateKeyframes(withDuration: 2, delay: 0, options: [.calculationModeLinear,.beginFromCurrentState], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0 / 3.0, animations: {
                self.titleLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.tipLabel.alpha = 0
            })
            UIView.addKeyframe(withRelativeStartTime: 1.0 / 3.0, relativeDuration: 1.0 / 6.0, animations: {
                self.titleLabel.transform = CGAffineTransform.identity
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.titleLabel.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                self.titleLabel.frame.origin = CGPoint(x: 30, y: 20)
            })
        }) { _ in
            let menuViewController = GameMenuViewController()
            self.present(menuViewController, animated: false, completion: nil)
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
