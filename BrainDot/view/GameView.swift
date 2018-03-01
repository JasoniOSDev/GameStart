//
//  GameView.swift
//  BrainDot
//
//  Created by chenjiesheng on 2018/2/28.
//  Copyright © 2018年 陈杰生. All rights reserved.
//

import UIKit
import SpriteKit

protocol GameViewDelegate: NSObjectProtocol {
    
    func gameViewBackButtonClicked(view: GameView)
    
    func gameViewRetryButtonClicked(view: GameView)
    
    func gameViewNextButtonClicked(view: GameView)
}

class GameView: SKView {
    
    var backButton: UIButton!
    var retryButton: UIButton!
    weak var gameViewDelegate: GameViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.createComponent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func createComponent() {
        let back = UIButton(type: .custom)
        back.addTarget(self, action: #selector(self.backButtonClicked), for: .touchUpInside)
        back.setImage(UIImage(named: "back"), for: .normal)
        self.addSubview(back)
        back.sizeToFit()
        self.backButton = back
        
        let retry = UIButton(type: .custom)
        retry.addTarget(self, action: #selector(self.retryButtonClicked), for: .touchUpInside)
        retry.setImage(UIImage(named: "retry"), for: .normal)
        self.addSubview(retry)
        retry.sizeToFit()
        self.retryButton = retry
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backButton.left = 20
        self.backButton.top = 20
        
        self.retryButton.right = self.width - 20
        self.retryButton.top = 20
    }
    
    @objc func backButtonClicked() {
        if let gameViewDelegate = self.gameViewDelegate {
            gameViewDelegate.gameViewBackButtonClicked(view: self)
        }
    }
    
    @objc func retryButtonClicked() {
        if let gameViewDelegate = self.gameViewDelegate {
            gameViewDelegate.gameViewRetryButtonClicked(view: self)
        }
    }
    
    func showConquerView(next sceneData: GameData?) {
        let conquerView = GameConquerView(frame: CGRect(x: 0, y: 0, width: 280, height: 190))
        conquerView.center = CGPoint(x: self.width / 2, y: self.height / 2)
        self.backgroundColor = UIColor(colorHex: "D8D8D878")
        self.addSubview(conquerView)
        conquerView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.25) {
            conquerView.transform = CGAffineTransform.identity
        }
    }
}
