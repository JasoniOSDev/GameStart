//
//  GameMenuSceneView.swift
//  BrainDot
//
//  Created by Jane Ren on 2018/2/23.
//  Copyright © 2018年 Jane Ren. All rights reserved.
//

import UIKit

class GameMenuSceneView: UIView {

    var sceneData: GameData?{
        didSet{
            self.setNeedsLayout()
        }
    }
    
    var favoriteIconImageView: UIImageView!
    var conquerImageView: UIImageView!
    var sceneSnapshotView: GameSceneSnapShotView!
    var lockContainerView: UIView!
    var lockIconImageView: UIImageView!
    var indexLabel: UILabel!
    var showLockContainerView = true {
        didSet{
            self.setNeedsLayout()
        }
    }
    var showIndexLabel = true {
        didSet{
            self.setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor(colorHex: "9B9B9B").cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 6
        self.createComponent()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.refreshLockContainerView()
        self.refreshIcons()
        self.refreshIndexLabel()
    }
    
    private func refreshLockContainerView() {
        guard self.showLockContainerView, let data = self.sceneData else {
            self.lockContainerView.isHidden = true
            return
        }
        self.lockContainerView.isHidden = !data.lock
        self.lockIconImageView.frame.size = CGSize(width: 21 * self.lockContainerView.width / 319, height: 31 * self.lockContainerView.height / 180)
        self.lockIconImageView.center = CGPoint(x: self.lockContainerView.width / 2, y: self.lockContainerView.height / 2)
    }
    
    private func refreshIcons() {
        guard let sceneData = self.sceneData else {
            self.favoriteIconImageView.isHidden = true
            self.conquerImageView.isHidden = true
            return
        }
        self.favoriteIconImageView.isHidden = !sceneData.userFavorite
        self.conquerImageView.isHidden = !sceneData.userConquer
        self.favoriteIconImageView.left = 10
        self.favoriteIconImageView.bottom = self.height - 10
        self.conquerImageView.right = self.width - 15
        self.conquerImageView.top = 15
    }
    
    private func refreshIndexLabel() {
        guard self.showIndexLabel, let data = self.sceneData else {
            self.indexLabel.isHidden = true
            return
        }
        self.indexLabel.isHidden = false
        if self.lockContainerView.isHidden {
            self.indexLabel.textColor = UIColor(colorHex: "6F6F6F")
        } else {
            self.indexLabel.textColor = .white
        }
        self.indexLabel.text = "\(data.index)"
        self.indexLabel.sizeToFit()
        self.indexLabel.left = self.width * 0.0468
        self.indexLabel.top = self.height * 0.056
    }
    
    private func createComponent() {
        defer {
            self.createLockRegion()
            self.createIndexLabel()
        }
        self.createGameSceneSnapshotView()
        self.createFavoriteImageView()
        self.createConquerImageView()
    }
    
    private func createGameSceneSnapshotView() {
        let view = GameSceneSnapShotView(frame: self.bounds)
        view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.backgroundColor = .white
        self.addSubview(view)
        self.sceneSnapshotView = view
    }
    
    private func createFavoriteImageView() {
        let imageView = UIImageView(image: UIImage(named: "favorite_icon"))
        imageView.sizeToFit()
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        imageView.isHidden = true
        self.favoriteIconImageView = imageView
    }
    
    private func createConquerImageView() {
        let imageView = UIImageView(image: UIImage(named: "user_conquer"))
        imageView.sizeToFit()
        self.addSubview(imageView)
        imageView.isHidden = true
        self.conquerImageView = imageView
    }
    
    private func createLockRegion() {
        let containerView = UIView(frame: self.bounds)
        containerView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        containerView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let iconImageView = UIImageView(image: UIImage(named: "lock"))
        iconImageView.contentMode = .scaleAspectFit
        
        containerView.addSubview(iconImageView)
        self.addSubview(containerView)
        self.lockContainerView = containerView
        self.lockIconImageView = iconImageView
    }
    
    private func createIndexLabel() {
        let label = UILabel()
        label.textColor = UIColor(colorHex: "6F6F6F")
        label.font = UIFont.boldSystemFont(ofSize: 26)
        
        self.addSubview(label)
        self.indexLabel = label
    }
    
    convenience init(sceneData: GameData) {
        self.init(frame: CGRect.zero)
        self.sceneData = sceneData
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setupView(with data: GameData) {
        self.sceneData = data
        self.sceneSnapshotView.setupContentWithSceneData(sceneData: data)
    }
}
