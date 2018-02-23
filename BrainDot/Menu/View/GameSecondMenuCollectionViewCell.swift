//
//  GameSecondMenuCollectionViewCell.swift
//  BrainDot
//
//  Created by chenjiesheng on 2018/2/23.
//  Copyright © 2018年 陈杰生. All rights reserved.
//

import UIKit

class GameSecondMenuCollectionViewCell: UICollectionViewCell {
    
    var sceneGroup: SceneDataGroup?
    var sceneViews: Array<GameMenuSceneView> = Array()
    
    var tipIconView: UIImageView!
    var tipLabel: UILabel!
    var tipRegion: UIView!
    
    var lockContainerView: UIView!
    var lockIconImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createCompoent()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let group = self.sceneGroup, group.sceneDatas.count > 0 else {
            return
        }
        var sceneViewBottom: CGFloat = 0
        for view in self.sceneViews {
            if view.isHidden {
                break
            }
            view.frame.origin = CGPoint(x: 0, y: 10)
            view.frame.size = CGSize(width: self.frame.width,
                                     height: UIScreen.main.bounds.height / UIScreen.main.bounds.width * self.frame.width)
            sceneViewBottom = view.bottom
        }
        
        refreshTipRegion(sceneViewBottom)
    }
    
    fileprivate func refreshTipRegion(_ sceneViewBottom: CGFloat) {
        guard let sceneGroup = self.sceneGroup else {
            return
        }
        self.setupTipRegion(with: sceneGroup)
        
        let leftPaddingTipLabel:CGFloat = 5.0
        self.tipRegion.frame.size = CGSize(width: self.tipIconView.frame.width + leftPaddingTipLabel + self.tipLabel.frame.width, height: CGFloat.maximum(self.tipIconView.frame.height, self.tipLabel.frame.height))
        self.tipIconView.left = 0
        self.tipIconView.midY = self.tipRegion.frame.height / 2
        self.tipLabel.left = self.tipIconView.right + leftPaddingTipLabel
        self.tipLabel.midY = self.tipIconView.midY
        self.tipRegion.midX = self.width / 2
        self.tipRegion.top = sceneViewBottom + 6.0
    }
    
    private func createCompoent() {
        self.createSceneView()
        self.createTipRegion()
        self.createLockRegion()
    }
    
    private func createSceneView() {
        for _ in 0..<3 {
            let view = GameMenuSceneView()
            view.isHidden = true
            self.addSubview(view)
            sceneViews.append(view)
        }
    }
    
    private func createTipRegion() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "user_conquer")
        imageView.contentMode = .scaleAspectFit
        imageView.frame.size = CGSize(width: 20, height: 20)
        self.tipIconView = imageView
        
        let label = UILabel()
        label.textColor = UIColor(colorHex: "6F6F6F")
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        self.tipLabel = label
        
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.addSubview(imageView)
        containerView.addSubview(label)
        self.addSubview(containerView)
        self.tipRegion = containerView
    }
    
    private func createLockRegion() {
        let icon = UIImageView()
        icon.image = UIImage(named: "lock")
        icon.contentMode = .scaleAspectFit
        icon.frame.size = CGSize(width: 21, height: 31)
        self.lockIconImageView = icon
        
        let containerView = UIView(frame: self.bounds)
        containerView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        containerView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.lockContainerView = containerView
        
        containerView.addSubview(icon)
        self.addSubview(containerView)
    }
    
    public func setupContent(with group: SceneDataGroup?) {
        self.sceneGroup = group
        guard let sceneGroup = group else {
            return
        }
        self.setupSceneView(with: sceneGroup)
        self.setupTipRegion(with: sceneGroup)
    }
    
    private func setupSceneView(with group: SceneDataGroup) {
        let datas = group.sceneDatas
        for view in self.sceneViews {
            view.isHidden = true
            view.transform = CGAffineTransform.identity
        }
        
        if (datas.count > 0) {
            let count = datas.count > 3 ? 3 : datas.count
            for i in 0 ..< count {
                let sceneData = datas[i]
                let view = self.sceneViews[i]
                view.isHidden = false
                view.setupView(with: sceneData)
                view.transform = CGAffineTransform(rotationAngle: CGFloat(3.0 / 180.0 * Double.pi * Double(i * ((i & 1)  == 1 ? 1 : -1))))
            }
        }
    }
    
    private func setupTipRegion(with group: SceneDataGroup) {
        guard group.lock == false else {
            self.tipRegion.isHidden = true
            self.lockContainerView.isHidden = false
            return
        }
        self.tipRegion.isHidden = false
        self.lockContainerView.isHidden = true
        
        let datas = group.sceneDatas
        var conquerCount = 0
        for sceneData in datas {
            if sceneData.userConquer {
                conquerCount += 1
            }
        }
        
        self.tipIconView.isHidden = conquerCount == 0
        if self.tipIconView.isHidden {
            self.tipLabel.text = "\(datas.count)"
        } else {
            self.tipLabel.text = "\(conquerCount) / \(datas.count)"
        }
        self.tipLabel.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
