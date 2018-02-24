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
    var sceneViewsContainerView: UIView!
    
    var tipIconView: UIImageView!
    var tipLabel: UILabel!
    var tipRegion: UIView!
    
    var lockContainerView: UIView!
    var lockIconImageView: UIImageView!
    
    var indexLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createComponent()
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
        
        if let view = self.sceneViews.first {
            self.indexLabel.left = 15
            self.indexLabel.top = 12
            self.lockContainerView.frame = view.convert(view.bounds, to: self.lockContainerView.superview)
        }
        
        refreshTipRegion(sceneViewBottom)
        if !self.lockContainerView.isHidden {
            self.indexLabel.textColor = .white
            self.lockIconImageView.center = CGPoint(x: self.lockContainerView.width / 2, y: self.lockContainerView.height / 2)
        } else {
            self.indexLabel.textColor = UIColor(colorHex: "6F6F6F")
        }
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
    
    private func createComponent() {
        self.createSceneView()
        self.createTipRegion()
        self.createLockRegion()
        self.createIndexLabel()
    }
    
    private func createSceneView() {
        let containerView = UIView(frame: self.bounds)
        containerView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        containerView.backgroundColor = .clear
        self.contentView.addSubview(containerView)
        self.sceneViewsContainerView = containerView
        
        for _ in 0 ..< 3 {
            let view = GameMenuSceneView()
            view.isHidden = true
            view.showLockContainerView = false
            view.showIndexLabel = false
            containerView.addSubview(view)
            self.sceneViews.append(view)
        }
        self.sceneViews = self.sceneViews.reversed()
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
        self.contentView.addSubview(containerView)
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
        self.lockContainerView = containerView
        
        containerView.addSubview(icon)
        self.contentView.addSubview(containerView)
    }
    
    private func createIndexLabel() {
        let label = UILabel()
        label.textColor = UIColor(colorHex: "6F6F6F")
        label.font = UIFont.boldSystemFont(ofSize: 26)
        self.contentView.addSubview(label)
        self.indexLabel = label
    }
    
    public func setupContent(with group: SceneDataGroup?) {
        self.sceneGroup = group
        guard let sceneGroup = group else {
            return
        }
        self.setupSceneView(with: sceneGroup)
        self.setupTipRegion(with: sceneGroup)
        self.setupIndexLabel(with: sceneGroup.sceneDatas.first)
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
                view.transform = CGAffineTransform.identity
                if i > 0 {
                    view.transform = CGAffineTransform(rotationAngle: CGFloat(1.5 / 180.0 * Double.pi * Double((i & 1)  == 1 ? 1 : -1)))
                    
                }
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
    
    private func setupIndexLabel(with sceneData: GameData?) {
        guard let data = sceneData else {
            self.indexLabel.text = nil
            return
        }
        self.indexLabel.text = "\(data.index)"
        self.indexLabel.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
