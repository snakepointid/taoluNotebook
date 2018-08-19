//
//  Option.swift
//  taolu
//
//  Created by 佘昌略  on 2018/3/27.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import RealmSwift

class Option: Object {
    @objc dynamic var key: String=""
    let queries = List<Query>()
    override static func primaryKey() -> String? {
        return "key"
    }
}
class Query:Object {
    @objc dynamic var query: String=""
    @objc dynamic var symbal:String=""
    @objc dynamic var frequency:Int=1
}
 
