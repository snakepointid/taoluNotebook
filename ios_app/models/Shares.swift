//
//  Shares.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/13.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import RealmSwift
class Share: Object {
    @objc dynamic var shareID: String = ""
    @objc dynamic var shareTime: String = TimeUtils.getRightNowTime(timeFormat: Constants.timeFormat)
    
    @objc dynamic var target: String=""
    @objc dynamic var agent: String=""
    @objc dynamic var outcome: String=""
    @objc dynamic var process:String=""
    @objc dynamic var title:String=""
    
    @objc dynamic var userInfo: UserInfo?
    
    @objc dynamic var randomSeed:String = String(10000+arc4random_uniform(90000))
    let policyAndFeedbacks = List<TAPF>()
    @objc dynamic var likeNum: Int=0
    @objc dynamic var dislikeNum: Int=0
    @objc dynamic var commentNum: Int=0
    @objc dynamic var followNum: Int=0
    @objc dynamic var youLike:Bool=false
    @objc dynamic var youComment:Bool=false
    @objc dynamic var youDislike:Bool=false
    @objc dynamic var youFollow:Bool=false
    @objc dynamic var youShare:Bool=false
    @objc dynamic var youPost:Bool=false
    
    override static func primaryKey() -> String? {
        return "shareID"
    }
    
    var showTime:String{
        let timeInterval = TimeUtils.getTimeInterval(eventTime: shareTime)
        return TimeUtils.getShowTime(timeInterval:timeInterval)
    }

}

class Comment: Object {
    @objc dynamic var commentID: String = TimeUtils.getUUID()
    @objc dynamic var shareID: String = ""
 
    @objc dynamic var text: String=""
    @objc dynamic var commentTime:String = TimeUtils.getRightNowTime(timeFormat: Constants.timeFormat)
    @objc dynamic var commenterInfo:UserInfo?
    
    @objc dynamic var upFlag: Bool = false
    
    @objc dynamic var likeNum: Int=0
    @objc dynamic var dislikeNum: Int=0
    @objc dynamic var popFlag: Bool = true
    @objc dynamic var youLike: Bool = false
    @objc dynamic var youDislike: Bool = false
    
 
    override static func indexedProperties() -> [String] {
        return ["shareID","commenterNickname"]
    }
    override static func primaryKey() -> String? {
        return "commentID"
    }
    
    var showTime:String{
        let timeInterval = TimeUtils.getTimeInterval(eventTime: commentTime)
        return TimeUtils.getShowTime(timeInterval:timeInterval)
    }
 
}

