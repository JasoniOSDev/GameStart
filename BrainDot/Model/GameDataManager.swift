//
//  GameDataManager.swift
//  BrainDot
//
//  Created by chenjiesheng on 2018/3/9.
//  Copyright © 2018年 陈杰生. All rights reserved.
//

import UIKit
import RealmSwift
class GameDataManager: NSObject {
    
    class func createSceneGroupIfNeed() {
        //将数据从json文件当中加载到数据库里面
        //每次在使用数据前都会检查一次是否需要加载
        let realm = try! Realm() //通过这个方法拿到对应的数据库实例
        if realm.objects(GameData.self).filter("userCustom == 0").count == 0 {
            let dict = self.defaultGameDataDict()
            //将字典的内容转化成对应的游戏数据结构
            //把每一关都是转化成GameData
            let array: Array<String> = dict.object(forKey: "data") as! Array<String>
            array.forEach { str in
                let data = str.data(using: .utf8)
                let dict = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
                let gameObject = GameData(value: dict)
                //转化完成gameObject -> GameData
                //存到数据库当中
                try! realm.write {
                    realm.add(gameObject)
                }
            }
        }
    }
    
    class func defaultGameDataDict() -> NSDictionary {
        //将gameData.json这个文件的内容加载进来
        //返回一个NSDictnary也就是字典的一个对象给上层
        let filePath = Bundle.main.path(forResource: "gameData", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
        let dict = try! JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
        return dict
    }
    
}
