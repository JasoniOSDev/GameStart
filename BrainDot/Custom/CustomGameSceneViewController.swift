//
//  CustomGameSceneViewController.swift
//  BrainDot
//
//  Created by chenjiesheng on 2018/3/10.
//  Copyright © 2018年 陈杰生. All rights reserved.
//

import UIKit
import SpriteKit
import RealmSwift
class CustomGameSceneViewController: UIViewController {

    var componentView: BackupComponentContainerView!
    var showComponentButton: UIButton!
    var showComponentView: Bool = false
    var allButtonIsShow: Bool = true
    var userIsTouch: Bool = false
    var finishButton: UIButton!
    var backButton: UIButton!
    var resetButton: UIButton!
    var testButton: UIButton!
    var blueBallLayer: GameSceneLayer!
    var redBallLayer: GameSceneLayer!
    var selectedLayer: GameSceneLayer?
    var layerContainerView: UIView!
    var selectedLayerPosition: CGPoint = CGPoint.zero
    var touchOriginPoint: CGPoint = CGPoint.zero
    var gameSceneLayers: Array<GameSceneLayer> = Array()
    var barrierObject:Array<BarrierObject> = Array()
    var pinGesture: UIPinchGestureRecognizer!
    var panGesture: UIPanGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.createComponent()
    }
    
    func createComponent() {
        
        self.layerContainerView = UIView(frame: self.view.bounds)
        self.layerContainerView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.layerContainerView.backgroundColor = .clear
        self.layerContainerView.isUserInteractionEnabled = false
        self.view.addSubview(self.layerContainerView)
        
        self.createShowComponentButton()
        self.createComponentView()
        self.createBackAndResetButton()
        self.createFinishButton()
        self.createBalls()
        self.createPinchGesture()
    }
    
    func createPinchGesture() {
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(self.scaleGestureAction(gesture:)))
        self.view.addGestureRecognizer(gesture)
        self.pinGesture = gesture
        let panGestuer = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureAction(gesture:)))
        self.view.addGestureRecognizer(panGestuer)
        self.panGesture = panGestuer
    }
    
    func createBalls() {
        let blue = BallObject()
        blue.colorHex = "4A90E2"
        blue.setPercentPosition(x: -0.31, y: -0.18)
        let red = BallObject()
        red.colorHex = "D0021B"
        red.setPercentPosition(x: 0.25, y: -0.18)
        let redLayer = GameSceneLayer.layer(with: red)
        let blueLayer = GameSceneLayer.layer(with: blue)
        self.layerContainerView.layer.addSublayer(redLayer)
        self.layerContainerView.layer.addSublayer(blueLayer)
        self.refreshFrame(with: redLayer, data: red)
        self.refreshFrame(with: blueLayer, data: blue)
        self.redBallLayer = redLayer
        self.blueBallLayer = blueLayer
        self.gameSceneLayers.append(redLayer)
        self.gameSceneLayers.append(blueLayer)
    }
    
    private func refreshFrame(with layer: CALayer, data: GameSceneObject) {
        let width = self.view.width
        let height = self.view.height
        let layerWidth = width * data.sizeWidth
        let layerHeight = height * data.sizeHeight
        let offsetX = width * data.positionXOffset
        let offsetY = height * data.positionYOffset
        let positionX = width / 2 + offsetX
        let positionY = height / 2 + offsetY
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        layer.bounds = CGRect(x: 0, y: 0, width: layerWidth, height: layerHeight)
        layer.position = CGPoint(x: positionX, y: positionY)
        CATransaction.commit()
    }
    
    func createBackAndResetButton() {
        self.backButton = UIButton(type: .custom)
        self.backButton.setTitle("退出", for: .normal)
        self.backButton.setTitleColor(.black, for: .normal)
        self.backButton.sizeToFit()
        self.backButton.frame.origin = CGPoint(x: 20, y: 20)
        self.backButton.addTarget(self, action: #selector(self.backButtonClicked), for: .touchUpInside)
        self.view.addSubview(self.backButton)
        self.resetButton = UIButton(type: .custom)
        self.resetButton.setImage(UIImage(named: "retry"), for: .normal)
        self.resetButton.sizeToFit()
        self.resetButton.top = 20
        self.resetButton.right = self.view.width - 20
        self.resetButton.addTarget(self, action: #selector(self.resetButtonClicked), for: .touchUpInside)
        self.view.addSubview(self.resetButton)
    }
    
    func createFinishButton() {
        
        self.testButton = UIButton(type: .custom)
        self.testButton.setTitle("预览", for: .normal)
        self.testButton.setTitleColor(.black, for: .normal)
        self.testButton.sizeToFit()
        self.testButton.addTarget(self, action: #selector(self.testButtonClicked), for: .touchUpInside)
        self.testButton.center.x = self.view.width / 2
        self.testButton.center.y = self.showComponentButton.center.y + 20
        self.view.addSubview(self.testButton)
        
        self.finishButton = UIButton(type: .custom)
        self.finishButton.setImage(UIImage(named: "finish"), for: .normal)
        self.finishButton.sizeToFit()
        self.finishButton.addTarget(self, action: #selector(self.finishButtonClicked), for: .touchUpInside)
        self.view.addSubview(self.finishButton)
        self.finishButton.center.y = self.showComponentButton.center.y
        self.finishButton.right = self.view.width - 20;
    }
    
    func createComponentView() {
        
        func createDatas() -> Array<GameSceneObject> {
            let rectangle = BarrierObject()
            rectangle.barrierType = BarrierType.rectangle.rawValue
            rectangle.fullSize()
            rectangle.sizeHeight *= 2.0 / 3;
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
        self.pinGesture.isEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            btn.transform = CGAffineTransform(translationX: 0, y: 20)
            btn.alpha = 0
            self.finishButton.transform = CGAffineTransform(translationX: 0, y: 20)
            self.finishButton.alpha = 0
            self.testButton.transform = CGAffineTransform(translationX: 0, y: 20)
            self.testButton.alpha = 0
            self.componentView.alpha = 1
            self.componentView.transform = CGAffineTransform(translationX: 0, y: -self.componentView.height)
        }) { _ in
            self.showComponentView = true
        }
    }

    @objc func backButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func resetButtonClicked() {
        while self.gameSceneLayers.count > 0 {
            if let layer = self.gameSceneLayers.first {
                self.removeLayerWith(layer: layer)
            }
            self.gameSceneLayers.removeFirst()
        }
        self.redBallLayer.removeFromSuperlayer()
        self.blueBallLayer.removeFromSuperlayer()
        self.createBalls()
    }
    
    @objc func finishButtonClicked() {
        let realm = try! Realm()
        let lastData = realm.objects(GameData.self).filter("userCustom == 1").sorted(byKeyPath: "index", ascending: true).last
        
        let gameData = GameData()
        let ballList = List<BallObject>()
        let barrierList = List<BarrierObject>()
        ballList.append(blueBallLayer.sceneObject as! BallObject)
        ballList.append(redBallLayer.sceneObject as! BallObject)
        barrierList.append(objectsIn: self.barrierObject)
        gameData.balls = ballList
        gameData.barriers = barrierList
        gameData.userCustom = true
        gameData.lock = false
        gameData.index = (lastData?.index ?? 0) + 1
        try! realm.write {
            realm.add(gameData)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func testButtonClicked() {
        let gameData = GameData()
        let ballList = List<BallObject>()
        let barrierList = List<BarrierObject>()
        ballList.append(blueBallLayer.sceneObject as! BallObject)
        ballList.append(redBallLayer.sceneObject as! BallObject)
        barrierList.append(objectsIn: self.barrierObject)
        gameData.balls = ballList
        gameData.barriers = barrierList
        gameData.userCustom = true
        gameData.lock = false
        self.showGameScene(gameData: gameData)
    }
    
    func showGameScene(gameData: GameData) {
        let gameVC = MainGameViewController(gameData: gameData)
        self.present(gameVC, animated: true, completion: nil)
    }
}

extension CustomGameSceneViewController: BackupComponentContainerViewDelegate{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.hideComponentView()
        if let touch = touches.first{
            let location = touch.location(in: self.view)
            for layer in self.gameSceneLayers {
                if layer.frame.contains(location) {
                    self.selectedLayer?.selected = false
                    layer.selected = true
                    self.selectedLayer = layer
                }
            }
        }
    }
    
    @objc func panGestureAction(gesture: UIPanGestureRecognizer) {
        if let layer = self.selectedLayer {
            switch gesture.state{
                case .began:
                    layer.move = true
                    let location = gesture.location(in: self.view)
                    self.touchOriginPoint = location
                    self.selectedLayerPosition = layer.position
                    self.hiddenButtons()
                case .changed:
                    let location = gesture.location(in: self.view)
                    let preLocation = self.touchOriginPoint
                    let diff = CGPoint(x: location.x - preLocation.x, y: location.y - preLocation.y)
                    let newPoint = CGPoint(x: diff.x + self.selectedLayerPosition.x, y: diff.y + self.selectedLayerPosition.y)
                    layer.sceneObject.updatePosition(newPoint: newPoint)
                    self.refreshFrame(with: layer, data: layer.sceneObject)
                case .cancelled,.ended:
                    layer.move = false
                    self.perform(#selector(self.showButtons), with: nil, afterDelay: 1)
                    if !self.view.bounds.intersects(layer.frame) {
                        self.showButtons()
                        self.removeLayerWith(layer: layer)
                    }
                default:
                    break
            }
           
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.selectedLayerPosition = CGPoint.zero
        self.touchOriginPoint = CGPoint.zero
    }
    
    @objc func scaleGestureAction(gesture: UIPinchGestureRecognizer) {
        guard let layer = self.selectedLayer else {
            return
        }
        if layer == self.redBallLayer || layer == self.blueBallLayer {
            return
        }
        let diff: CGFloat = (gesture.scale - 1) * 0.8
        let scale: CGFloat = diff + 1
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        layer.transform = CATransform3DMakeScale(scale, scale, 1)
        CATransaction.commit()
        switch gesture.state {
        case .began:
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            layer.selected = false
            CATransaction.commit()
            self.userIsTouch = true
            self.hiddenButtons()
        case .cancelled,
             .ended:
            self.userIsTouch = false
            self.perform(#selector(self.showButtons), with: nil, afterDelay: 1)
            var width = layer.sceneObject.sizeWidth
            var height = layer.sceneObject.sizeHeight
            width *= scale
            height *= scale
            width = CGFloat.minimum(1, CGFloat.maximum(0.05, width))
            height = CGFloat.minimum(1, CGFloat.maximum(0.05, height))
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            layer.transform = CATransform3DIdentity
            layer.sceneObject.setPercentSize(width: width, height: height)
            self.refreshFrame(with: layer, data: layer.sceneObject)
            layer.selected = true
            CATransaction.commit()
        default:
            break
        }
    }
    
    func addComponentWith(sceneData: GameSceneObject) {
        sceneData.colorHex = "9B9B9B"
        sceneData.sizeWidth = 0.3
        sceneData.sizeHeight = 0.3
        let layer = GameSceneLayer.layer(with: sceneData)
        self.gameSceneLayers.append(layer)
        self.barrierObject.append(sceneData as! BarrierObject)
        self.refreshFrame(with: layer, data: sceneData)
        self.layerContainerView.layer.addSublayer(layer)
        layer.layoutSublayers()
        self.selectedLayer?.selected = false
        self.selectedLayer = layer
        layer.selected = true
    }
    
    func removeLayerWith(layer: GameSceneLayer) {
        if let data = layer.sceneObject as? BarrierObject {
            layer.removeFromSuperlayer()
            if let index = self.barrierObject.index(of: data) {
                if (index != NSNotFound) {
                    self.barrierObject.remove(at: index)
                }
            }
            if self.selectedLayer == layer {
                self.selectedLayer = nil
            }
        }
    }
    
    func hideComponentView(){
        if !self.showComponentView {
            return
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.showComponentButton.transform = CGAffineTransform.identity
            self.showComponentButton.alpha = 1
            self.finishButton.transform = CGAffineTransform.identity
            self.finishButton.alpha = 1
            self.testButton.transform = CGAffineTransform.identity
            self.testButton.alpha = 1
            self.componentView.alpha = 0
            self.componentView.transform = CGAffineTransform.identity
        }) { _ in
            self.showComponentView = false
            self.pinGesture.isEnabled = true
        }
    }
    
    func hiddenButtons() {
        if !allButtonIsShow {
            return
        }
        allButtonIsShow = false
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.showButtons), object: nil)
        UIView.animate(withDuration: 0.3, animations: {
            self.finishButton.transform = CGAffineTransform(translationX: 0, y: 20)
            self.finishButton.alpha = 0
            self.showComponentButton.transform = CGAffineTransform(translationX: 0, y: 20)
            self.showComponentButton.alpha = 0
            self.testButton.transform = CGAffineTransform(translationX: 0, y: 20)
            self.testButton.alpha = 0
            self.resetButton.transform = CGAffineTransform(translationX: self.view.width - self.resetButton.right, y: 0)
            self.resetButton.alpha = 0
            self.backButton.transform = CGAffineTransform(translationX: -self.backButton.left, y: 0)
            self.backButton.alpha = 0
        })
    }
    
    @objc func showButtons() {
        if allButtonIsShow || self.userIsTouch{
            return
        }
        allButtonIsShow = true
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.showButtons), object: nil)
        UIView.animate(withDuration: 0.3, animations: {
            self.finishButton.transform = CGAffineTransform.identity
            self.finishButton.alpha = 1
            self.showComponentButton.transform = CGAffineTransform.identity
            self.showComponentButton.alpha = 1
            self.testButton.transform = .identity
            self.testButton.alpha = 1
            self.resetButton.transform = CGAffineTransform.identity
            self.resetButton.alpha = 1
            self.backButton.transform = CGAffineTransform.identity
            self.backButton.alpha = 1
        })
    }
    
    func backupComonponentSelected(sceneData: GameSceneObject) {
        self.hideComponentView()
        self.addComponentWith(sceneData: sceneData)
    }
}
