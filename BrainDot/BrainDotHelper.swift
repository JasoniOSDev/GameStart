//
//  BrainDotHelper.swift
//  BrainDot
//
//  Created by Jane Ren on 2018/2/21.
//  Copyright © 2018年 Jane Ren. All rights reserved.
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
