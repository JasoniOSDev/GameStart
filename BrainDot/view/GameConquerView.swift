//
//  GameConquerView.swift
//  BrainDot
//
//  Created by chenjiesheng on 2018/2/27.
//  Copyright © 2018年 陈杰生. All rights reserved.
//

import UIKit

class GameConquerView: UIView {
    
    var iconImageView: UIImageView!
    var tipLabel: UILabel!
    var nextButton: UIButton!
    weak var gameViewDelegate: GameViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createComponent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var top = self.height * 0.1
        let padding = self.height * 0.07
        
        if self.nextButton.isHidden {
            top = self.height * 0.17
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
        button.setTitle("下一关", for: .normal)
        button.frame.size = CGSize(width: 150, height: 30)
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor(colorHex: "9B9B9B").cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 2
        button.addTarget(self, action: #selector(self.nextButtonClicked), for: .touchUpInside)
        self.addSubview(button)
        self.nextButton = button
    }
    
    @objc func nextButtonClicked() {
        if let delegate = self.gameViewDelegate,let supView = self.superview as? GameView {
            delegate.gameViewNextButtonClicked(view: supView)
        }
    }
    
}
