//
//  UserInfoCell.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/27.
//  Copyright © 2018年 佘昌略. All rights reserved.
//
import UIKit
import SnapKit

class UserInfoCell:UITableViewCell{
    weak var delegate:AccountDelegate!
    var nicknameLabel: UILabel!
    var initTimeLabel: UILabel!
    var levelImgLabel: UILabel!
    var pointLabel: UILabel!
    
    var nickname: UILabel!
    var initTime: UILabel!
    var levelImg: UIImageView!
    var point: UILabel!
    var nicknameEditBtn:UIButton!
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubviews()
        layout()
        config()
        
    }
}
//api
extension UserInfoCell{
    func setUserInfo(userInfo:UserInfo){
        if let nicknameText = userInfo.nickname{
            nickname.text = nicknameText
        }
        point.text = String(userInfo.point)
        initTime.text = userInfo.initialTime.substring(to: 10)
        levelImg.image = UIImage(named:String(format:"level%d.png",userInfo.level))
    }
    func changeNickname(newNickname:String){
        nickname.text = newNickname
    }
    @objc func tapped(){
        if delegate != nil {
            delegate!.editNickname()
        }
    }
    
}

//basic
extension UserInfoCell{
    private func config(){
        
        nicknameLabel.font = UIFont(name:"ArialMT", size:15)
        initTimeLabel.font = UIFont(name:"ArialMT", size:15)
        levelImgLabel.font = UIFont(name:"ArialMT", size:15)
        pointLabel.font = UIFont(name:"ArialMT", size:15)
        nickname.font = UIFont(name:"ArialMT", size:15)
        initTime.font = UIFont(name:"ArialMT", size:15)
        point.font = UIFont(name:"ArialMT", size:15)
        
        nickname.adjustsFontSizeToFitWidth = true
        point.adjustsFontSizeToFitWidth = true
        initTime.adjustsFontSizeToFitWidth = true
        
        nicknameEditBtn.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    private func initSubviews(){
        nicknameLabel = UILabel()
        initTimeLabel = UILabel()
        levelImgLabel = UILabel()
        pointLabel = UILabel()
        
        nicknameLabel.text = "昵称:"
        initTimeLabel.text = "首次使用时间:"
        levelImgLabel.text = "等级:"
        pointLabel.text = "积分:"
        
        nickname = UILabel()
        initTime = UILabel()
        levelImg = UIImageView()
        point = UILabel()
        nicknameEditBtn = UIButton()
        
        nicknameEditBtn.setImage(UIImage(named:"edit.png"), for: .normal)
        self.contentView.addSubview(nicknameLabel)
        self.contentView.addSubview(initTimeLabel)
        self.contentView.addSubview(levelImgLabel)
        self.contentView.addSubview(pointLabel)
        self.contentView.addSubview(nickname)
        self.contentView.addSubview(initTime)
        self.contentView.addSubview(levelImg)
        self.contentView.addSubview(point)
        self.contentView.addSubview(nicknameEditBtn)
    }
    private func layout(){
        self.nicknameLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(20)
            make.height.equalTo(20)
            make.width.equalTo(50)
        }
        self.nickname.snp.makeConstraints { (make) in
            make.left.equalTo(nicknameLabel.snp.right).offset(5)
            make.top.bottom.equalTo(nicknameLabel)
            make.width.equalTo(50)
        }
        self.nicknameEditBtn.snp.makeConstraints { (make) in
            make.left.equalTo(nickname.snp.right).offset(5)
            make.bottom.equalTo(nicknameLabel)
            make.width.height.equalTo(15)
        }
        self.pointLabel.snp.makeConstraints { (make) in
            make.left.height.width.equalTo(nicknameLabel)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
        }
        self.point.snp.makeConstraints { (make) in
            make.left.equalTo(pointLabel.snp.right).offset(5)
            make.top.bottom.equalTo(pointLabel)
            make.width.equalTo(100)
        }
        self.levelImgLabel.snp.makeConstraints { (make) in
            make.left.height.width.equalTo(nicknameLabel)
            make.top.equalTo(pointLabel.snp.bottom).offset(10)
        }
        self.levelImg.snp.makeConstraints { (make) in
            make.left.equalTo(pointLabel.snp.right).offset(5)
            make.top.bottom.equalTo(levelImgLabel)
            make.width.equalTo(30)
        }
        self.initTimeLabel.snp.makeConstraints { (make) in
            make.left.height.equalTo(nicknameLabel)
            make.top.equalTo(levelImgLabel.snp.bottom).offset(10)
            make.width.equalTo(100)
        }
        self.initTime.snp.makeConstraints { (make) in
            make.left.equalTo(initTimeLabel.snp.right).offset(5)
            make.top.bottom.equalTo(initTimeLabel)
            make.width.equalTo(100)
        }
    }
}
