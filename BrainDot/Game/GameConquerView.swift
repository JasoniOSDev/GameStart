//
//  GameConquerView.swift
//  BrainDot
//
//  Created by Jane Ren on 2018/2/27.
//  Copyright © 2018年 Jane Ren. All rights reserved.
//

import UIKit

class GameConquerView: UIView {
    
    var iconImageView: UIImageView!
    var tipLabel: UILabel!
    var nextButton: UIButton!
    var nextGameData: GameData?{
        didSet{
            if let _ = self.nextGameData {
                self.nextButton.isHidden = false
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor(colorHex: "9B9B9B").cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 4
        self.layer.cornerRadius = 3
        self.createComponent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var top = self.height * 0.14
        let padding = self.height * 0.1
        
        if self.nextButton.isHidden {
            top = self.height * 0.27
        }
        
        self.iconImageView.top = top
        self.iconImageView.center.x = self.width / 2
        
        self.tipLabel.top = self.iconImageView.bottom + padding
        self.tipLabel.center.x = self.iconImageView.center.x + 5
        
        self.nextButton.bottom = self.height * 0.92
        self.nextButton.center.x = self.iconImageView.center.x
    }
    
    private func createComponent() {
        let iconImageView = UIImageView(image: UIImage(named: "bit_conquer_icon"))
        iconImageView.sizeToFit()
        self.addSubview(iconImageView)
        self.iconImageView = iconImageView
        
        let label = UILabel()
        label.textColor = UIColor(colorHex: "6F6F6F")
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "成功过关!"
        label.sizeToFit()
        self.addSubview(label)
        self.tipLabel = label
        
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.white
        button.setTitle("下一关", for: .normal)
        button.setTitleColor(UIColor(colorHex: "6F6F6F"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.frame.size = CGSize(width: 150, height: 30)
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor(colorHex: "9B9B9B").cgColor
        button.layer.borderWidth = 1
        button.isHidden = true
        self.addSubview(button)
        self.nextButton = button
    }
    
}
