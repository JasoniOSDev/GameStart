//
//  GameMenuSceneView.swift
//  BrainDot
//
//  Created by chenjiesheng on 2018/2/23.
//  Copyright © 2018年 陈杰生. All rights reserved.
//

import UIKit

class GameMenuSceneView: UIView {

    var sceneData: GameData?{
        didSet{
            self.setNeedsLayout()
        }
    }
    
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
        self.indexLabel.left = 15
        self.indexLabel.top = 12
    }
    
    private func createComponent() {
        defer {
            self.createLockRegion()
            self.createIndexLabel()
        }
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
        
    }
}
