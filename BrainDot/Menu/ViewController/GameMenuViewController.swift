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

    var mainMenuCollectionView: UICollectionView!
    var subMenuCollectionView: UICollectionView!
    var addSceneButton: UIButton!
    var exportDataButton: UIButton!
    var titleLabel: UILabel!
    var menus: Array<GameMenu>!
    var selectedMenu: GameMenu?
    
    var selectedMenuCell: UIView?
    var selectedOriginPosition: CGPoint = CGPoint.zero
    
    var gameView: GameView?
    var gameDatas: Results<GameData>?
    var dataNotificationToken:NotificationToken?
    
    deinit {
        self.dataNotificationToken?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.createComponent()
        self.createExportButton()
    }
    
    func createExportButton() {
        self.exportDataButton = UIButton(type: .custom)
        self.exportDataButton.setTitle("导出自制关卡", for: .normal)
        self.exportDataButton.setTitleColor(.black, for: .normal)
        self.exportDataButton.sizeToFit()
        self.view.addSubview(self.exportDataButton)
        self.exportDataButton.addTarget(self, action: #selector(self.exportButtonClicked), for: .touchUpInside)
        self.exportDataButton.center.x = self.view.width / 2
        self.exportDataButton.top = 20
        self.exportDataButton.isHidden = true
    }
    
    @objc func exportButtonClicked() {
//        let realm = try! Realm()
//        if let filePath = realm.configuration.fileURL {
//            let paste = UIPasteboard.general
//
//        }
        var datas = [String]()
        self.gameDatas?.forEach { data in
            if let str = data.toJsonStr() {
                datas.append(str)
            }
        }
        let dataJson = ["data" : datas]
        let jsonData = try! JSONSerialization.data(withJSONObject: dataJson, options: [])
        let str = String(data: jsonData, encoding: .utf8)
        let paste = UIPasteboard.general
        paste.string = str
        UIApplication.shared.open(URL(string: "weixin://")!, options: [:], completionHandler: nil)
    }
    
    func refreshSelectedDatas(selectedMenuID: Int) {
        GameDataManager.createSceneGroupIfNeed()
        let realm = try! Realm()
        
        switch selectedMenuID {
        case 0:
            self.gameDatas = realm.objects(GameData.self).filter("userCustom == 0")
        case 1:
            self.gameDatas = realm.objects(GameData.self).filter("userFavorite == 1")
        case 2:
            self.gameDatas = realm.objects(GameData.self).filter("userCustom == 1")
        default:
            break;
        }
        if self.dataNotificationToken == nil {
            self.dataNotificationToken = self.gameDatas!.observe { [weak self]
                change in
                guard let strongSelf = self else {
                    return
                }
                switch change {
                case .update(_, deletions: _, insertions: _, modifications: _):
                    strongSelf.subMenuCollectionView.reloadData()
                default:
                    break
                }
            }
        }
    }
    
    func createComponent() {
        self.createMenuData()
        self.createMainMenuCollectionView()
        self.createsubMenuCollectionView()
        self.createTitleLabel()
        self.createGameView()
        self.createAddSceneButton()
    }
    
    func createAddSceneButton() {
        self.addSceneButton = UIButton(type: .custom)
        self.addSceneButton.setTitle("新增", for: .normal)
        self.addSceneButton.setTitleColor(.black, for: .normal)
        self.addSceneButton.sizeToFit()
        self.addSceneButton.center.y = self.titleLabel.center.y
        self.addSceneButton.right = self.view.right - 25
        self.view.addSubview(self.addSceneButton)
        self.addSceneButton.addTarget(self, action: #selector(self.addSceneButtonClicked(btn:)), for: .touchUpInside)
        self.addSceneButton.isHidden = true
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
    
    func createMainMenuCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let space: CGFloat = 80
        layout.itemSize = CGSize(width: 140, height: 165)
        layout.minimumInteritemSpacing = space
        layout.minimumLineSpacing = space
        layout.scrollDirection = .horizontal
        self.mainMenuCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.mainMenuCollectionView.showsVerticalScrollIndicator = false
        self.mainMenuCollectionView.showsHorizontalScrollIndicator = false
        self.mainMenuCollectionView.delegate = self
        self.mainMenuCollectionView.dataSource = self
        self.mainMenuCollectionView.register(MainMenuCollectionViewCell.self, forCellWithReuseIdentifier: "mainMenuCell")
        self.mainMenuCollectionView.backgroundColor = .white
        self.view.addSubview(self.mainMenuCollectionView)
        self.mainMenuCollectionView.frame.size = CGSize(width: self.view.frame.width, height: 165)
        self.mainMenuCollectionView.center = self.view.center
        var leftInset = (self.view.frame.width - (layout.itemSize.width + space) * CGFloat(self.menus.count) + space) / 2
        if leftInset < 40 {
            leftInset = 40
        }
        self.mainMenuCollectionView.contentInset = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: 0)
    }
    
    private func createsubMenuCollectionView() {
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
        collectionView.register(SubMenuCollectionViewCell.self, forCellWithReuseIdentifier: "subMenuCell")
        collectionView.backgroundColor = .white
        collectionView.top = 80
        collectionView.contentInset = UIEdgeInsetsMake(0, 50, 0, 50)
        collectionView.clipsToBounds = false
        self.view.addSubview(collectionView)
        collectionView.isHidden = true
        self.subMenuCollectionView = collectionView
    }
}

extension GameMenuViewController: UICollectionViewDelegate,UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.mainMenuCollectionView {
            return mainMenuCollectionView(collectionView: collectionView, numberOfItemsInSection: section)
        }
        if collectionView == self.subMenuCollectionView {
            return subMenuCollectionView(collectionView: collectionView, numberOfItemsInSection: section)
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.mainMenuCollectionView
        {
            return mainMenuCollectionView(collectionView: collectionView, cellForItemAt: indexPath)
        }
        if collectionView == self.subMenuCollectionView {
            return subMenuCollectionView(collectionView: collectionView, cellForItemAt: indexPath)
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.mainMenuCollectionView {
            mainMenuCollectionView(collectionView: collectionView,willDisplay: cell,forItemAt: indexPath)
        }
        if collectionView == self.subMenuCollectionView {
            subMenuCollectionView(collectionView: collectionView,willDisplay: cell,forItemAt: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.mainMenuCollectionView {
            mainMenuCollectionView(collectionView: collectionView, didSelectItemAt: indexPath)
        }
        if collectionView == self.subMenuCollectionView {
            subMenuCollectionView(collectionView: collectionView, didSelectItemAt: indexPath)
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
        
        selectedCell.isUserInteractionEnabled = false
        self.subMenuCollectionView.isHidden = true
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
            selectedCell.transform = CGAffineTransform.identity
            selectedCell.center = self.selectedOriginPosition
        }) { _ in
            self.mainMenuCollectionView.isHidden = false
            selectedCell.removeFromSuperview()
            self.selectedMenuCell = nil
        }
    }
}

//firstMenu extension
extension GameMenuViewController
{
    fileprivate func mainMenuCollectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.menus.count
    }
    
    fileprivate func mainMenuCollectionView(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionViewCell: MainMenuCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainMenuCell", for: indexPath) as? MainMenuCollectionViewCell else {
            return UICollectionViewCell()
        }
        let menu = self.menus[indexPath.row]
        collectionViewCell.setupContent(with: menu)
        return collectionViewCell
    }
    
    fileprivate func mainMenuCollectionView(collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let validCell: MainMenuCollectionViewCell = cell as? MainMenuCollectionViewCell else {
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
    
    fileprivate func mainMenuCollectionView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MainMenuCollectionViewCell,self.menus.count > indexPath.row else {
            return
        }
        guard let selectCellSnapshot = cell.imageView.snapshotView(afterScreenUpdates: false) else {
            return
        }
        let menu = self.menus[indexPath.row]
        self.selectedMenu = menu
        self.addSceneButton.isHidden = !(self.selectedMenu?.menuID == 2)
        selectCellSnapshot.frame = cell.imageView.convert(cell.imageView.bounds, to: self.view)
        self.selectedOriginPosition = selectCellSnapshot.center
        self.selectedMenuCell = selectCellSnapshot
        self.view.addSubview(selectCellSnapshot)
        collectionView.isHidden = true
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
            selectCellSnapshot.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            selectCellSnapshot.center = CGPoint(x: 30 + selectCellSnapshot.width / 2, y: self.view.height - 25 - selectCellSnapshot.height / 2)
        }) { _ in
            self.refreshSelectedDatas(selectedMenuID: menu.menuID)
            let nextCollectionView = self.subMenuCollectionView!
            nextCollectionView.isHidden = false
            nextCollectionView.reloadData()
        }
    }
}

//thirdMenu extension
extension GameMenuViewController
{
    fileprivate func subMenuCollectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.gameDatas?.count ?? 0
    }
    
    fileprivate func subMenuCollectionView(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let _ = self.selectedMenu, let cell: SubMenuCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "subMenuCell", for: indexPath) as? SubMenuCollectionViewCell,let gameDatas = self.gameDatas{
            let gameData = gameDatas[indexPath.row]
            cell.sceneData = gameData
            return cell
        }
        return UICollectionViewCell()
    }
    
    fileprivate func subMenuCollectionView(collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.25) {
            cell.alpha = 1
        }
    }
    
    fileprivate func subMenuCollectionView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = self.selectedMenu,let gameView = self.gameView,let gameDatas = self.gameDatas {
            let sceneData = gameDatas[indexPath.row]
            let scene = MainGameScene(size: self.view.frame.size, data: sceneData)
            scene.gameDelegate = self
            self.view.bringSubview(toFront: gameView)
            gameView.isHidden = false
            gameView.curGameData = sceneData
            gameView.presentScene(scene)
            return
        }
        
    }
}

extension GameMenuViewController: MainGameSceneDelegate,GameViewDelegate {
    
    @objc func addSceneButtonClicked(btn: UIButton) {
        let customSceneVC = CustomGameSceneViewController()
        self.present(customSceneVC, animated: true, completion: nil)
    }
    
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
            view.curGameData = nextData
        }
    }
    
    func gameFinish(sceneData: GameData, balls: Array<SKShapeNode>, barriers: Array<SKShapeNode>, drawNode: Array<SKSpriteNode>) {
        guard let gameDatas = self.gameDatas,
            let index = gameDatas.index(of: sceneData),
            let gameView = self.gameView else {
            return
        }
        
        let realm = try! Realm()
        try! realm.write {
            sceneData.userConquer = true
        }
        
        var nextSceneData: GameData?
        
        if (index + 1) < gameDatas.count {
            nextSceneData = gameDatas[index + 1]
        }
        try! realm.write {
            nextSceneData?.lock = false
        }
        gameView.showConquerView(next: nextSceneData)
    }
}
