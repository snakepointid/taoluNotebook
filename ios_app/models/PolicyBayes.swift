//
//  Bayes.swift
//  taolu
//
//  Created by 佘昌略  on 2018/3/31.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import RealmSwift

class PositiveBayes: Object {
    @objc dynamic var key: String=""
    @objc dynamic var positive: Int=0
    @objc dynamic var negtive: Int=0
 
    var all: Int{
        return positive+negtive
    }
    var positiveProbability: CGFloat{
        guard all>0 else {
            return 0.0
        }
        return CGFloat(positive)/CGFloat(all)
    }
    override static func primaryKey() -> String? {
        return "key"
    }
}


