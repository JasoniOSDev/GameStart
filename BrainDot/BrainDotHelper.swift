//
//  BrainDotHelper.swift
//  BrainDot
//
//  Created by chenjiesheng on 2018/2/21.
//  Copyright © 2018年 陈杰生. All rights reserved.
//

import Foundation

func isEmptyString(str: NSString?) -> Bool {
    if let string = str {
        if string.isKind(of: NSString.self) && !string.isEqual(to: "") {
            return false
        }
    }
    return true
}
