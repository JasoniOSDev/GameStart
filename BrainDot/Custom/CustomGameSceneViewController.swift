//
//  CustomGameSceneViewController.swift
//  BrainDot
//
//  Created by chenjiesheng on 2018/3/10.
//  Copyright © 2018年 陈杰生. All rights reserved.
//

import UIKit

class CustomGameSceneViewController: UIViewController {

    var componentView: BackupComponentContainerView!
    var showComponentButton: UIButton!
    var showComponentView: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createComponent()
    }
    
    func createComponent() {
        self.createShowComponentButton()
        self.createComponentView()
    }
    
    func createComponentView() {
        
        func createDatas() -> Array<GameSceneObject> {
            let rectangle = BarrierObject()
            rectangle.barrierType = BarrierType.rectangle.rawValue
            rectangle.fullSize()
            rectangle.colorHex = "ffffff"
            let square = BarrierObject()
            square.barrierType = BarrierType.square.rawValue
            square.fullSize()
            square.colorHex = "ffffff"
            let triangle = BarrierObject()
            triangle.barrierType = BarrierType.triangle.rawValue
            triangle.fullSize()
            triangle.colorHex = "ffffff"
            let datas = [rectangle,square,triangle]
            return datas
        }
        
        let datas = createDatas()
        self.componentView = BackupComponentContainerView(sceneObjects: datas)
        self.componentView.delegate = self
        self.componentView.frame = CGRect(x: 0, y: self.view.height, width: self.view.width, height: 60)
        self.componentView.alpha = 0
        self.view.addSubview(componentView)
    }
    
    func createShowComponentButton() {
        self.showComponentButton = UIButton(type: .custom)
        self.showComponentButton.setImage(UIImage(named: "add"), for: .normal)
        self.showComponentButton.addTarget(self, action: #selector(self.showComponentButtonClicked(btn:)), for: .touchUpInside)
        self.view.addSubview(self.showComponentButton)
        self.showComponentButton.sizeToFit()
        self.showComponentButton.left = 20
        self.showComponentButton.bottom = self.view.height - 20
    }
    
    @objc func showComponentButtonClicked(btn: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            btn.transform = CGAffineTransform(translationX: 0, y: 20)
            btn.alpha = 0
            self.componentView.alpha = 1
            self.componentView.transform = CGAffineTransform(translationX: 0, y: -self.componentView.height)
        }) { _ in
            self.showComponentView = true
        }
    }

}

extension CustomGameSceneViewController: BackupComponentContainerViewDelegate{
    func backupComonponentSelected(sceneData: GameSceneObject) {
        
    }
}
