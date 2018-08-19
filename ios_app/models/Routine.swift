//
//  Routine.swift
//  taolu
//
//  Created by 佘昌略  on 2018/3/15.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import RealmSwift

class Routine: Object {
    @objc dynamic var routineID: String = TimeUtils.getUUID()
    @objc dynamic var createTime: String=TimeUtils.getRightNowTime(timeFormat: Constants.timeFormat)
    @objc dynamic var target: String=""
    @objc dynamic var agent: String=""
    @objc dynamic var outcome: String=""
    @objc dynamic var sharedFlag: Bool = false
    @objc dynamic var uploadFlag: Bool = false
    @objc dynamic var complement:Complement?
    
    let policyAndFeedbacks = List<TAPF>()
    
    override static func primaryKey() -> String? {
        return "routineID"
    }
 
  
    var showTime:String{
        let timeInterval = TimeUtils.getTimeInterval(eventTime: createTime)
        return TimeUtils.getShowTime(timeInterval:timeInterval)
    }
    
}
class Complement:Object {
    @objc dynamic var process: String?
    @objc dynamic var title: String?
}
class TAPF:Object {
    @objc dynamic var token: String=""
    @objc dynamic var symbal:String=""
    @objc dynamic var type:String=Constants.defaultType
    @objc dynamic var showProb:Float = 0.0
    var keyToken: String{
        return symbal+token
    }
}


