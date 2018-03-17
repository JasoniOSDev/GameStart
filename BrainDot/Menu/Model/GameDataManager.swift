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

    func fetchSceneGroup() -> Array<SceneDataGroup> {
        let realm = try! Realm()
        let objects = realm.objects(SceneDataGroup.self)
        var array: Array<SceneDataGroup> = Array()
        if (objects.count > 0) {
            objects.forEach { object in
                array.append(object)
            }
        }
        if (array.count == 0) {
            array = self.createSceneGroup()
        }
        return array
    }
    
    func createSceneGroup() -> Array<SceneDataGroup> {
        return Array()
    }
    
}
