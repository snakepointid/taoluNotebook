//
//  Message.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/27.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import RealmSwift

class Message: Object {
    @objc dynamic var title: String=""
    @objc dynamic var detail: String=""
    @objc dynamic var importFlag: Bool=false
    @objc dynamic var messageTime: String=""
}

class Chat: Object {
    @objc dynamic var target: String=""
    @objc dynamic var nickname: String=""
    @objc dynamic var text: String=""
    @objc dynamic var chatTime: String=TimeUtils.getRightNowTime(timeFormat: Constants.timeFormat)
    
    var showTime:String{
        let timeInterval = TimeUtils.getTimeInterval(eventTime: chatTime)
        return TimeUtils.getShowTime(timeInterval:timeInterval)
    }
    override static func indexedProperties() -> [String] {
        return ["target"]
    }
}

class Report: Object {
    @objc dynamic var cotentID: String=""
    @objc dynamic var cotentType:String=""
    @objc dynamic var reportTimes: Int=1
    @objc dynamic var reportType:String=""
}

class Advice: Object {
    @objc dynamic var advice: String=""
    @objc dynamic var advicer: UserInfo?
    @objc dynamic var mailContact:String?
    @objc dynamic var otherContact:String?
}

