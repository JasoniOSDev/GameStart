//
//  GameView.swift
//  BrainDot
//
//  Created by Jane Ren on 2018/2/28.
//  Copyright © 2018年 Jane Ren. All rights reserved.
//

import UIKit
import SpriteKit
import RealmSwift

protocol GameViewDelegate: NSObjectProtocol {
    
    func gameViewBackButtonClicked(view: GameView)
    
    func gameViewRetryButtonClicked(view: GameView)
    
    func gameViewNextButtonClicked(view: GameView)
}

class GameView: SKView {
    
    var backButton: UIButton!
    var retryButton: UIButton!
    var conquerContainerView: UIView?
    var favoriteButton: UIButton!
    var conquerView: GameConquerView?
    var curGameData: GameData? {
        didSet{
            if let data = self.curGameData {
                self.favoriteButton.isSelected = data.userFavorite
            }
        }
    }
    var previewMode: Bool = false {
        didSet{
            self.favoriteButton.isHidden = self.previewMode
        }
    }
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
        back.frame.size = CGSize(width: 40, height: 40)
        self.backButton = back
        
        let retry = UIButton(type: .custom)
        retry.addTarget(self, action: #selector(self.retryButtonClicked), for: .touchUpInside)
        retry.setImage(UIImage(named: "retry"), for: .normal)
        self.addSubview(retry)
        retry.sizeToFit()
        self.retryButton = retry
        
        let favorite = UIButton(type: .custom)
        favorite.addTarget(self, action: #selector(self.favoriteButtonClicked), for: .touchUpInside)
        favorite.setImage(UIImage(named: "favorite_icon"), for: .selected)
        favorite.setImage(UIImage(named: "un_favlour"), for: .normal)
        favorite.frame.size = CGSize(width: 40, height: 40)
        self.addSubview(favorite)
        self.favoriteButton = favorite
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backButton.left = 20
        self.backButton.top = 20
        
        self.retryButton.right = self.width - 20
        self.retryButton.top = 20

        self.favoriteButton.center.x = self.width / 2
        self.favoriteButton.top = 20
    }
    
    @objc func backButtonClicked() {
        if (self.conquerContainerView != nil) {
            self.conquerContainerView?.removeFromSuperview()
            self.conquerContainerView = nil
        }
        if let gameViewDelegate = self.gameViewDelegate {
            gameViewDelegate.gameViewBackButtonClicked(view: self)
        }
    }
    
    @objc func favoriteButtonClicked() {
        if let data = self.curGameData {
            let realm = try! Realm()
            try! realm.write {
                UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .calculationModeLinear, animations: {
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                        self.favoriteButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    })
                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                        self.favoriteButton.transform = CGAffineTransform.identity
                    })
                }, completion: {
                    _ in
                    self.favoriteButton.isSelected = !self.favoriteButton.isSelected
                })
                data.userFavorite = !data.userFavorite
            }
        }
    }
    
    @objc func retryButtonClicked() {
        if (self.conquerContainerView != nil) {
            self.conquerContainerView?.removeFromSuperview()
            self.conquerContainerView = nil
        }
        if let gameViewDelegate = self.gameViewDelegate {
            gameViewDelegate.gameViewRetryButtonClicked(view: self)
        }
    }
    
    @objc func nextButtonClicked() {
        if let gameViewDelegate = self.gameViewDelegate {
            gameViewDelegate.gameViewNextButtonClicked(view: self)
        }
    }
    
    func showConquerView(next sceneData: GameData?) {
        let containerView = UIView(frame: self.bounds)
        self.insertSubview(containerView, belowSubview: backButton)
        containerView.backgroundColor = UIColor(colorHex: "D8D8D878")
        let conquerView = GameConquerView(frame: CGRect(x: 0, y: 0, width: 280, height: 190))
        conquerView.nextGameData = sceneData
        conquerView.nextButton.addTarget(self, action: #selector(self.nextButtonClicked), for: .touchUpInside)
        conquerView.center = CGPoint(x: self.width / 2, y: self.height / 2)
        containerView.addSubview(conquerView)
        conquerView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.25) {
            conquerView.transform = CGAffineTransform.identity
        }
        self.conquerView = conquerView
        self.conquerContainerView = containerView
    }
    
    func showGameScene(gameData: GameData) {
        let scene = MainGameScene(size: self.frame.size, data: gameData)
        self.curGameData = gameData
        self.presentScene(scene)
    }
}
