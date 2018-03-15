//
//  BackupComponentView.swift
//  BrainDot
//
//  Created by chenjiesheng on 2018/3/10.
//  Copyright © 2018年 陈杰生. All rights reserved.
//

import UIKit

protocol BackupComponentContainerViewDelegate: NSObjectProtocol {
    func backupComonponentSelected(sceneData: GameSceneObject)
}

class BackupComponentContainerView: UIView {
    
    var sceneObjects: Array<GameSceneObject> = Array()
    var sceneViews: Array<GameSceneView> = Array()
    var scrollView: UIScrollView!
    weak var delegate: BackupComponentContainerViewDelegate?
    
    init(sceneObjects: Array<GameSceneObject>) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor(colorHex: "3B3B3B")
        self.scrollView = UIScrollView(frame: self.bounds)
        self.scrollView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(self.scrollView)
        self.refreshDatas(with: sceneObjects)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let componentViewWidth = self.height - 20
        let paddingLeftComponentView: CGFloat = 10
        var viewLeft = paddingLeftComponentView
        self.sceneViews.forEach { view in
            if !view.isHidden {
                view.frame.size = CGSize(width: componentViewWidth, height: componentViewWidth)
                view.left = viewLeft
                view.center.y = self.height / 2
                viewLeft = view.right + paddingLeftComponentView
            }
        }
        self.scrollView.contentSize = CGSize(width: viewLeft, height: self.height)
    }
    
    func refreshDatas(with datas: Array<GameSceneObject>) {
        self.sceneObjects = datas
        for i in 0 ..< self.sceneViews.count {
            let view = self.sceneViews[i]
            view.isHidden = true
        }
        let dis = datas.count - self.sceneViews.count
        if dis > 0 {
            for _ in 0 ..< dis {
                let view = GameSceneView()
                view.addTarget(self, action: #selector(self.buttonClicked(btn:)), for: .touchUpInside)
                self.scrollView.addSubview(view)
                self.sceneViews.append(view)
            }
        }
        for i in 0 ..< datas.count {
            let data = datas[i]
            let view = self.sceneViews[i]
            view.refreshData(with: data)
            view.isHidden = false
        }
        self.setNeedsLayout()
    }
    
    @objc func buttonClicked(btn: GameSceneView) {
        if let delegate = self.delegate,let data = btn.sceneData {
            delegate.backupComonponentSelected(sceneData: data.copy() as! GameSceneObject)
        }
    }
}
