//
//  UserInfo.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/11.
//  Copyright © 2018年 佘昌略. All rights reserved.
//


import RealmSwift

class UserInfo: Object {
    @objc dynamic var uid: String = TimeUtils.getUUID()
    @objc dynamic var initialTime: String=TimeUtils.getRightNowTime()
    @objc dynamic var verifiedFlag = true
    @objc dynamic var point:Int = 0
    @objc dynamic var nickname:String?
    
    var level: Int{
        let ret = log(_:Float(max(1,point)))/log(_:10.0)
        return Int(min(6,ret))
    }
    
    override static func primaryKey() -> String? {
        return "uid"
    }
    override static func indexedProperties() -> [String] {
        return ["nickname"]
    }
}

class UserRoutines: Object {
    @objc dynamic var uid: String = ""
    @objc dynamic var routine:Routine?
    override static func indexedProperties() -> [String] {
        return ["uid"]
    }
}


class Token: Object {
    @objc dynamic var userInfo: UserInfo?
    @objc dynamic var keyToken: String=""
    @objc dynamic var frequency:Int=1
    
    var token: String{
        return keyToken.substring(from:1)
    }
    var symbal:String{
       return keyToken[0]
    }
    
    override static func primaryKey() -> String? {
        return "keyToken"
    }
    
}

