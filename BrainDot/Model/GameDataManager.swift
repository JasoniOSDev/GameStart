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
        let realm = try! Realm()
        if realm.objects(GameData.self).filter("userCustom == 0").count == 0 {
            let dict = self.defaultGameDataDict()
            let array: Array<String> = dict.object(forKey: "data") as! Array<String>
            array.forEach { str in
                let data = str.data(using: .utf8)
                let dict = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
                let gameObject = GameData(value: dict)
                try! realm.write {
                    realm.add(gameObject)
                }
            }
        }
    }
    
    class func defaultGameDataDict() -> NSDictionary {
        let filePath = Bundle.main.path(forResource: "gameData", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
        let dict = try! JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
        return dict
    }
    
}
