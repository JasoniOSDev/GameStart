//
//  GameMenuViewController.swift
//  BrainDot
//
//  Created by chenjiesheng on 2018/2/21.
//  Copyright © 2018年 陈杰生. All rights reserved.
//

import UIKit

class GameMenuViewController: UIViewController {

    var collectionView: UICollectionView!
    var titleLabel: UILabel!
    var menus: Array<GameMenu>!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.createCompoent()
    }
    
    func createCompoent() {
        self.createMenuData()
        self.createCollectionView()
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
    
    func createCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let space:CGFloat = 40
        layout.itemSize = CGSize(width: 140, height: 165)
        layout.minimumInteritemSpacing = space
        layout.minimumLineSpacing = space
        layout.scrollDirection = .horizontal
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(GameMenuCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView.backgroundColor = .white
        self.view.addSubview(self.collectionView)
        self.collectionView.frame.size = CGSize(width: self.view.frame.width, height: 165)
        self.collectionView.center = self.view.center
        var leftInset = (self.view.frame.width - (layout.itemSize.width + space) * CGFloat(self.menus.count) + space) / 2
        if leftInset < 40 {
            leftInset = 40
        }
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: 0)
    }
}

extension GameMenuViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let collectionViewCell: GameMenuCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? GameMenuCollectionViewCell {
            let menu = self.menus[indexPath.row]
            collectionViewCell.setupContent(with: menu)
            return collectionViewCell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let newCell: GameMenuCollectionViewCell = cell as? GameMenuCollectionViewCell {
            newCell.titleLabel.alpha = 0
            newCell.imageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: 0.6, delay: 0.1 * Double(indexPath.row), usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                newCell.imageView.transform = CGAffineTransform.identity
            }) { _ in
            }
            UIView.animate(withDuration: 0.3, delay: 0.6 + 0.1 * Double(self.menus.count - 1), options: .curveLinear, animations: {
                newCell.titleLabel.alpha = 1
            }, completion: nil)
        }
    }
}
