//
//  Bayes.swift
//  taolu
//
//  Created by 佘昌略  on 2018/3/31.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import RealmSwift

class BayesKey: Object {
    @objc dynamic var key: String=""
    @objc dynamic var positive: Int=0
    @objc dynamic var negtive: Int=0
    let queries = List<BayesQuery>()
    var all: Int{
        return positive+negtive
    }
    var token: String{
        return key.substring(from:1)
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

class BayesQuery:Object {
    @objc dynamic var query: String=""
    @objc dynamic var positive: Int=0
    @objc dynamic var negtive: Int=0
    var token: String{
        return query.substring(from:1)
    }
    var all: Int{
        return positive+negtive
    }
    var positiveProbability: CGFloat{
        guard all>0 else {
            return 0.0
        }
        return CGFloat(positive)/CGFloat(all)
    }
    override static func indexedProperties() -> [String] {
        return ["query"]
    }
}
