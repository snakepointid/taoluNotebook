//
//   UserInfoView.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/26.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit
import SnapKit

class UserInfoView: BasicView{
    var nickname: UILabel!
    var createTime: UILabel!
    var userLevel: UIImageView!
    var upperImg:UIImageView?
    
    override init()
    {
        
        super.init( )
        initSubviews()
        layout()
        config()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        
        super.awakeFromNib()
        initSubviews()
        layout()
        config()
        
    }
}
//api
extension UserInfoView{
    func setUserInfo(comment:Comment){
        createTime.text = comment.showTime
        if let userInfo = comment.commenterInfo{
            nickname.text = userInfo.nickname
            userLevel.image = UIImage(named:String(format:"level%d.png",userInfo.level))
        }
        if comment.upFlag{
            configUpImg()
        }else{
            upperImg?.removeFromSuperview()
            upperImg = nil
        }
    }
    func setUserInfo(share:Share){
        nickname.text = share.userInfo?.nickname
        createTime.text = share.showTime
        userLevel.image = UIImage(named:String(format:"level%d.png",share.userInfo!.level))
    }
}
//basic
extension UserInfoView{
    private func configUpImg(){
        if let _ = upperImg{
            return
        }
        upperImg = UIImageView()
        self.addSubview(upperImg!)
        upperImg!.image = UIImage(named:"sharer.png")
        self.upperImg!.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.userLevel.snp.right).offset(5)
            make.width.equalTo(self.userLevel)
        }
    }
    private func config(){
        nickname.font = UIFont(name:"ArialMT", size:15)
        nickname.textColor = UIColor.gray
        
        createTime.font = UIFont(name:"ArialMT", size:7)
        createTime.textColor = UIColor.gray
        createTime.alpha = 0.9
    }
    
    private func initSubviews(){
        nickname =  UILabel()
        createTime = UILabel()
        userLevel = UIImageView()
        self.addSubview(nickname)
        self.addSubview(createTime)
        self.addSubview(userLevel)
        
    }
    private func layout(){
        
        self.nickname.snp.makeConstraints { (make) in
            make.top.bottom.left.equalToSuperview()
        }
        self.userLevel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.nickname.snp.right).offset(10)
            make.width.equalTo(self.userLevel.snp.height)
        }
        
        self.createTime.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
        }
    }
}

