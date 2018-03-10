//
//  GameMenuViewController.swift
//  BrainDot
//
//  Created by Jane Ren on 2018/2/21.
//  Copyright © 2018年 Jane Ren. All rights reserved.
//

import UIKit
import SpriteKit
import RealmSwift

class GameMenuViewController: UIViewController {

    var firstMenuCollectionView: UICollectionView!
    var secondMenuCollectionView: UICollectionView!
    var thirdMenuCollectionView: UICollectionView!
    var titleLabel: UILabel!
    var menus: Array<GameMenu>!
    
    var sceneGroupList: Array<SceneDataGroup>?
    var selectedMenuCell: UIView?
    var selectedOriginPosition: CGPoint = CGPoint.zero
    
    var selectedGroup: SceneDataGroup?
    
    var gameView: GameView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.createComponent()
    }
    
    func createComponent() {
        self.createMenuData()
        self.createFirstMenuCollectionView()
        self.createSecondMenuCollectionView()
        self.createThirdMenuCollectionView()
        self.createTitleLabel()
        self.createGameView()
    }
    
    func createGameView() {
        let view = GameView(frame: self.view.bounds)
        view.gameViewDelegate = self
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.isHidden = true
        self.view.addSubview(view)
        view.backgroundColor = .clear
        self.gameView = view
    }
    
    func loadSceneGroupList(with menu:GameMenu) {
        var list = Array<SceneDataGroup>()
        for i in 0 ..< 3 {
            let group = SceneDataGroup()
            group.groupIndex = i
            group.lock = i != 0
            let sceneData = GameData()
            let barrier = BarrierObject()
            barrier.barrierType = BarrierType.rectangle.rawValue
            barrier.sizeHeight = 0.25
            barrier.sizeWidth = 0.25
            barrier.positionXOffset = 0.375
            barrier.positionYOffset = 0.375
            sceneData.barriers.append(barrier)
            
            let ball = BallObject()
            ball.sizeWidth = 0.1
            ball.sizeHeight = 0.1
            ball.positionXOffset = 0
            ball.positionYOffset = 0
            ball.colorHex = "4A90E2"
            sceneData.balls.append(ball)
            
            let ball2 = BallObject()
            ball2.sizeWidth = 0.1
            ball2.sizeHeight = 0.1
            ball2.positionXOffset = 0.2
            ball2.positionYOffset = 0.2
            ball2.colorHex = "4A90E2"
            sceneData.balls.append(ball2)
            
            sceneData.lock = false
            group.sceneDatas.append(sceneData)
            for _ in 0 ..< 10 {
                group.sceneDatas.append(GameData())
            }
            list.append(group)
        }
        self.sceneGroupList = list
    }
    
    func createMenuData() {
        var array = Array<GameMenu> ()
        for i in 0...2 {
            if let menu = self.gameMenu(with: i) {
                array.append(menu)
            }
        }
        self.menus = array
    }
    
    func gameMenu(with index:Int) -> GameMenu? {
        let menuNameArray = ["关卡","收藏","自制"]
        if index < menuNameArray.count {
            var menu = GameMenu()
            menu.menuID = index
            menu.iconImageName = "game_menu_icon_\(index)"
            menu.menuName = menuNameArray[index]
            return menu
        }
        return nil
    }
 
    func createTitleLabel() {
        self.titleLabel = UILabel()
        self.titleLabel.text = "脑点子"
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 64)
        self.titleLabel.textColor = UIColor(colorHex: "1B91DC")
        self.titleLabel.sizeToFit()
        self.view.addSubview(self.titleLabel)
        self.titleLabel.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        self.titleLabel.frame.origin = CGPoint(x: 30, y: 20)
    }
    
    func createFirstMenuCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let space: CGFloat = 80
        layout.itemSize = CGSize(width: 140, height: 165)
        layout.minimumInteritemSpacing = space
        layout.minimumLineSpacing = space
        layout.scrollDirection = .horizontal
        self.firstMenuCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.firstMenuCollectionView.showsVerticalScrollIndicator = false
        self.firstMenuCollectionView.showsHorizontalScrollIndicator = false
        self.firstMenuCollectionView.delegate = self
        self.firstMenuCollectionView.dataSource = self
        self.firstMenuCollectionView.register(GameFirstMenuCollectionViewCell.self, forCellWithReuseIdentifier: "firstMenuCell")
        self.firstMenuCollectionView.backgroundColor = .white
        self.view.addSubview(self.firstMenuCollectionView)
        self.firstMenuCollectionView.frame.size = CGSize(width: self.view.frame.width, height: 165)
        self.firstMenuCollectionView.center = self.view.center
        var leftInset = (self.view.frame.width - (layout.itemSize.width + space) * CGFloat(self.menus.count) + space) / 2
        if leftInset < 40 {
            leftInset = 40
        }
        self.firstMenuCollectionView.contentInset = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: 0)
    }
    
    private func createSecondMenuCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let space: CGFloat = 40
        layout.itemSize = CGSize(width: 330, height: 225)
        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = space
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: layout.itemSize.height), collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GameSecondMenuCollectionViewCell.self, forCellWithReuseIdentifier: "secondMenuCell")
        collectionView.backgroundColor = .white
        collectionView.top = 80
        collectionView.contentInset = UIEdgeInsetsMake(0, (self.view.width - layout.itemSize.width) / 2, 0, (self.view.width - layout.itemSize.width) / 2)
        collectionView.clipsToBounds = false
        self.view.addSubview(collectionView)
        collectionView.isHidden = true
        self.secondMenuCollectionView = collectionView
    }
    
    private func createThirdMenuCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let lineSpace: CGFloat = 30
        let itemSpace: CGFloat = 20
        layout.itemSize = CGSize(width: 150, height: 85)
        layout.minimumLineSpacing = lineSpace
        layout.minimumInteritemSpacing = itemSpace
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: layout.itemSize.height * 2 + lineSpace), collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GameThirdMenuCollectionViewCell.self, forCellWithReuseIdentifier: "thirdMenuCell")
        collectionView.backgroundColor = .white
        collectionView.top = 80
        collectionView.contentInset = UIEdgeInsetsMake(0, 50, 0, 50)
        collectionView.clipsToBounds = false
        self.view.addSubview(collectionView)
        collectionView.isHidden = true
        self.thirdMenuCollectionView = collectionView
    }
}

extension GameMenuViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.firstMenuCollectionView {
            return firstMenuCollectionView(collectionView: collectionView, numberOfItemsInSection: section)
        }
        if collectionView == self.secondMenuCollectionView {
            return secondMenuCollectionView(collectionView: collectionView, numberOfItemsInSection: section)
        }
        if collectionView == self.thirdMenuCollectionView {
            return thirdMenuCollectionView(collectionView: collectionView, numberOfItemsInSection: section)
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.firstMenuCollectionView
        {
            return firstMenuCollectionView(collectionView: collectionView, cellForItemAt: indexPath)
        }
        if collectionView == self.secondMenuCollectionView
        {
            return secondMenuCollectionView(collectionView: collectionView, cellForItemAt: indexPath)
        }
        if collectionView == self.thirdMenuCollectionView {
            return thirdMenuCollectionView(collectionView: collectionView, cellForItemAt: indexPath)
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.firstMenuCollectionView {
            firstMenuCollectionView(collectionView: collectionView,willDisplay: cell,forItemAt: indexPath)
        }
        if collectionView == self.secondMenuCollectionView {
            secondMenuCollectionView(collectionView: collectionView,willDisplay: cell,forItemAt: indexPath)
        }
        if collectionView == self.thirdMenuCollectionView {
            thirdMenuCollectionView(collectionView: collectionView,willDisplay: cell,forItemAt: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.firstMenuCollectionView {
            firstMenuCollectionView(collectionView: collectionView, didSelectItemAt: indexPath)
        }
        if collectionView == self.secondMenuCollectionView {
            secondMenuCollectionView(collectionView: collectionView, didSelectItemAt: indexPath)
        }
        if collectionView == self.thirdMenuCollectionView {
            thirdMenuCollectionView(collectionView: collectionView, didSelectItemAt: indexPath)
        }
    }
}

extension GameMenuViewController
{
    //touch
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        if self.handleTouchInSelectedCell(with: touch) {
            return
        }
    }
}

extension GameMenuViewController
{
    fileprivate func handleTouchInSelectedCell(with touch: UITouch) -> Bool {
        let location = touch.location(in: self.view)
        guard let selectedCell = self.selectedMenuCell,selectedCell.isUserInteractionEnabled,selectedCell.frame.contains(location) else {
            return false
        }
        self.touchInSelectedCell()
        return true
    }
    
    func touchInSelectedCell() {
        guard let selectedCell = self.selectedMenuCell else {
            return
        }
        guard self.secondMenuCollectionView.isHidden == false,self.thirdMenuCollectionView.isHidden == true else {
            self.thirdMenuCollectionView.isHidden = true
            self.secondMenuCollectionView.isHidden = false
            return
        }
        selectedCell.isUserInteractionEnabled = false
        self.secondMenuCollectionView.isHidden = true
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
            selectedCell.transform = CGAffineTransform.identity
            selectedCell.center = self.selectedOriginPosition
        }) { _ in
            self.firstMenuCollectionView.isHidden = false
            selectedCell.removeFromSuperview()
            self.selectedMenuCell = nil
            self.sceneGroupList = nil
        }
    }
}

//firstMenu extension
extension GameMenuViewController
{
    fileprivate func firstMenuCollectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.menus.count
    }
    
    fileprivate func firstMenuCollectionView(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionViewCell: GameFirstMenuCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "firstMenuCell", for: indexPath) as? GameFirstMenuCollectionViewCell else {
            return UICollectionViewCell()
        }
        let menu = self.menus[indexPath.row]
        collectionViewCell.setupContent(with: menu)
        return collectionViewCell
    }
    
    fileprivate func firstMenuCollectionView(collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let validCell: GameFirstMenuCollectionViewCell = cell as? GameFirstMenuCollectionViewCell else {
            return
        }
        validCell.titleLabel.alpha = 0
        validCell.imageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.6, delay: 0.1 * Double(indexPath.row), usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            validCell.imageView.transform = CGAffineTransform.identity
        }) { _ in
        }
        UIView.animate(withDuration: 0.3, delay: 0.6 + 0.1 * Double(self.menus.count - 1), options: .curveLinear, animations: {
            validCell.titleLabel.alpha = 1
        }, completion: nil)
    }
    
    fileprivate func firstMenuCollectionView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GameFirstMenuCollectionViewCell,self.menus.count > indexPath.row else {
            return
        }
        guard let selectCellSnapshot = cell.imageView.snapshotView(afterScreenUpdates: false) else {
            return
        }
        let menu = self.menus[indexPath.row]
        selectCellSnapshot.frame = cell.imageView.convert(cell.imageView.bounds, to: self.view)
        self.selectedOriginPosition = selectCellSnapshot.center
        self.selectedMenuCell = selectCellSnapshot
        self.view.addSubview(selectCellSnapshot)
        collectionView.isHidden = true
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
            selectCellSnapshot.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            selectCellSnapshot.center = CGPoint(x: 30 + selectCellSnapshot.width / 2, y: self.view.height - 25 - selectCellSnapshot.height / 2)
        }) { _ in
            self.loadSceneGroupList(with: menu)
            self.secondMenuCollectionView.isHidden = false
            self.secondMenuCollectionView.reloadData()
        }
    }
}

//secondMenu extension
extension GameMenuViewController
{
    fileprivate func secondMenuCollectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let list = self.sceneGroupList else {
            return 0
        }
        return list.count
    }
    
    fileprivate func secondMenuCollectionView(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let list = self.sceneGroupList, let cell: GameSecondMenuCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "secondMenuCell", for: indexPath) as? GameSecondMenuCollectionViewCell else {
            return UICollectionViewCell()
        }
        let sceneGroup = list[indexPath.row]
        cell.setupContent(with: sceneGroup)
        return cell
    }
    
    fileprivate func secondMenuCollectionView(collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.25) {
            cell.alpha = 1
        }
    }
    
    fileprivate func secondMenuCollectionView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let groupList = self.sceneGroupList,
            groupList.count > indexPath.row else {
            return
        }
        let group = groupList[indexPath.row]
        if group.lock == false {
            self.selectedGroup = group
            collectionView.isHidden = true
            self.thirdMenuCollectionView.isHidden = false
            self.thirdMenuCollectionView.reloadData()
        }
    }
}

//thirdMenu extension
extension GameMenuViewController
{
    fileprivate func thirdMenuCollectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let group = self.selectedGroup else {
            return 0
        }
        return group.sceneDatas.count
    }
    
    fileprivate func thirdMenuCollectionView(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let group = self.selectedGroup, let cell: GameThirdMenuCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "thirdMenuCell", for: indexPath) as? GameThirdMenuCollectionViewCell else {
            return UICollectionViewCell()
        }
        let sceneData = group.sceneDatas[indexPath.row]
        cell.sceneData = sceneData
        return cell
    }
    
    fileprivate func thirdMenuCollectionView(collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.25) {
            cell.alpha = 1
        }
    }
    
    fileprivate func thirdMenuCollectionView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let group = self.selectedGroup, group.sceneDatas.count > indexPath.row,let gameView = self.gameView else {
            return
        }
        let sceneData = group.sceneDatas[indexPath.row]
        guard !sceneData.lock else {
            return
        }
        let scene = MainGameScene(size: self.view.frame.size, data: sceneData)
        scene.gameDelegate = self
        self.view.bringSubview(toFront: gameView)
        gameView.isHidden = false
        gameView.presentScene(scene)
    }
}

extension GameMenuViewController: MainGameSceneDelegate,GameViewDelegate {
    
    func gameViewBackButtonClicked(view: GameView) {
        view.presentScene(nil)
        view.isHidden = true
    }
    
    func gameViewRetryButtonClicked(view: GameView) {
        if let gameScene = view.scene as? MainGameScene,let data = gameScene.data {
            let newScene = MainGameScene(size: gameScene.size, data: data)
            newScene.gameDelegate = self
            view.presentScene(newScene)
        }
    }
    
    func gameViewNextButtonClicked(view: GameView) {
        if let gameScene = view.scene as? MainGameScene,
            let conquerView = view.conquerView,
            let nextData = conquerView.nextGameData {
            
            view.conquerContainerView?.removeFromSuperview()
            gameScene.updateComonent(with: nextData)
            gameScene.isPaused = false
        }
    }
    
    func gameFinish(sceneData: GameData, balls: Array<SKShapeNode>, barriers: Array<SKShapeNode>, drawNode: Array<SKSpriteNode>) {
        guard let group = self.selectedGroup,
            let groupList = self.sceneGroupList,
            let index = group.sceneDatas.index(of: sceneData),
            let indexOfGroup = groupList.index(of: group),
            let gameView = self.gameView else {
            return
        }
        
        let realm = try! Realm()
        try! realm.write {
            sceneData.userConquer = true
        }
        
        var nextSceneData: GameData?
        
        if (index + 1) == group.sceneDatas.count {
            if (indexOfGroup + 1) == groupList.count {
                return
            } else {
                let nextGroup = groupList[indexOfGroup + 1]
                nextSceneData = nextGroup.sceneDatas.first
            }
        } else {
            nextSceneData = group.sceneDatas[index + 1]
        }
        nextSceneData?.lock = false
        gameView.showConquerView(next: nextSceneData)
    }
}
