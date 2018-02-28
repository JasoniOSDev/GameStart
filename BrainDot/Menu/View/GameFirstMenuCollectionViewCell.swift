//
//  GameMenuCollectionViewCell.swift
//  BrainDot
//
//  Created by chenjiesheng on 2018/2/21.
//  Copyright © 2018年 陈杰生. All rights reserved.
//

import UIKit

class GameFirstMenuCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView!
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createComponent()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let image = self.imageView.image {
            self.imageView.frame.size = CGSize(width: self.frame.width, height: self.frame.width * image.size.height / image.size.width)
        }
        self.imageView.frame.origin = CGPoint(x: 0, y: 0)
        self.titleLabel.center = CGPoint(x: self.frame.width / 2, y: (self.imageView.frame.maxY + self.frame.height) / 2)
        self.titleLabel.bottom = self.frame.height
    }
    
    private func createComponent() {
        self.imageView = UIImageView()
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = UIColor(colorHex: "6F6F6F")
        label.textAlignment = .center
        self.titleLabel = label
        self.addSubview(self.imageView)
        self.addSubview(self.titleLabel)
    }
    
    public func setupContent(with menu: GameMenu) {
        self.imageView.image = UIImage(named: menu.iconImageName)
        self.titleLabel.text = menu.menuName
        self.titleLabel.sizeToFit()
        self.setNeedsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
