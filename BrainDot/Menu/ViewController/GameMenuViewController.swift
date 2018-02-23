//
//  GameMenuViewController.swift
//  BrainDot
//
//  Created by chenjiesheng on 2018/2/21.
//  Copyright © 2018年 陈杰生. All rights reserved.
//

import UIKit

class GameMenuViewController: UIViewController {

    var firstMenuCollectionView: UICollectionView!
    var secondMenuCollectionView: UICollectionView!
    var ThirdMenuCollectionView: UICollectionView!
    var titleLabel: UILabel!
    var menus: Array<GameMenu>!
    var sceneGroupList: Array<SceneDataGroup>?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.createCompoent()
    }
    
    func createCompoent() {
        self.createMenuData()
        self.createFirstMenuCollectionView()
        self.createSecondMenuCollectionView()
        self.createTitleLabel()
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
    
    func createSecondMenuCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let space: CGFloat = 40
        layout.itemSize = CGSize(width: 330, height: 225)
        layout.minimumLineSpacing = space
        layout.minimumLineSpacing = space
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: layout.itemSize.height), collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GameSecondMenuCollectionViewCell.self, forCellWithReuseIdentifier: "secondMenuCell")
        collectionView.backgroundColor = .white
        collectionView.top = 80
        collectionView.contentInset = UIEdgeInsetsMake(0, (self.view.width - layout.itemSize.width) / 2, 0, 0)
        self.secondMenuCollectionView = collectionView
    }
}

extension GameMenuViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.firstMenuCollectionView {
            return self.menus.count
        }
        if collectionView == self.secondMenuCollectionView {
            guard let list = self.sceneGroupList else {
                return 0
            }
            return list.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.firstMenuCollectionView
        {
            guard let collectionViewCell: GameFirstMenuCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "firstMenuCell", for: indexPath) as? GameFirstMenuCollectionViewCell else {
                return UICollectionViewCell()
            }
            let menu = self.menus[indexPath.row]
            collectionViewCell.setupContent(with: menu)
            return collectionViewCell
        }
        if collectionView == self.secondMenuCollectionView
        {
            guard let list = self.sceneGroupList, let cell: GameSecondMenuCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "secondMenuCell", for: indexPath) as? GameSecondMenuCollectionViewCell else {
                return UICollectionViewCell()
            }
            let sceneGroup = list[indexPath.row]
            cell.setupContent(with: sceneGroup)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.firstMenuCollectionView {
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
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

//firstMenu extension
extension GameMenuViewController
{

    func firstMenuCollectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
    }
    
    func firstMenuCollectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    }
    
    func firstMenuCollectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func firstMenuCollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

//secondMenu extension
extension GameMenuViewController
{
    func firstMenuCollectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
    }
    
    func firstMenuCollectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    }
    
    func firstMenuCollectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func firstMenuCollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
