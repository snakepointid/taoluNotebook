//
//  ChatDetailCell.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/29.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit

class ChatDetailCell: BasicViewCell {
    var nicknameLabel:UILabel!
    var chatTextLabel:UILabel!
    var timeLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubviews()
        layout()
        config()
    }
}
//api
extension ChatDetailCell{
    func setCellInfo(chatInfo:Chat){
        nicknameLabel.text = chatInfo.nickname
        chatTextLabel.text = chatInfo.text
        timeLabel.text = chatInfo.showTime
    }
}

//basic
extension ChatDetailCell{
    private func config(){
        self.contentView.backgroundColor = UIColor.textEdit
        nicknameLabel.numberOfLines = 1
        nicknameLabel.textAlignment = .left
        nicknameLabel.font = UIFont(name:"ArialMT", size:10)
  
        chatTextLabel.textColor = UIColor.darkText
        chatTextLabel.textAlignment = .left
        chatTextLabel.font = UIFont(name:"ArialMT", size:16)
        chatTextLabel.numberOfLines=0
        chatTextLabel.lineBreakMode = NSLineBreakMode.byCharWrapping
    
        timeLabel.font = UIFont(name:"ArialMT", size:7)
        timeLabel.textColor = UIColor.gray
        timeLabel.alpha = 0.9

    }
  
    private func initSubviews(){
        nicknameLabel = UILabel()
        chatTextLabel = UILabel()
        timeLabel = UILabel()
        self.contentView.addSubview(nicknameLabel)
        self.contentView.addSubview(timeLabel)
        self.addSubview(chatTextLabel)
        
    }
    private func layout(){
        self.contentView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
        }
        self.nicknameLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(20)
            make.height.equalTo(30)
        }
        self.timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nicknameLabel.snp.right).offset(10)
            make.centerY.equalTo(nicknameLabel)
            make.height.equalTo(10)
        }
        self.chatTextLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(nicknameLabel.snp.bottom)
            make.right.equalToSuperview().offset(-10)
        }
        
        chatTextLabel.removeFromSuperview()
        contentView.addSubview(chatTextLabel)
        self.chatTextLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(nicknameLabel.snp.bottom) 
            make.right.equalToSuperview().offset(-10)
        }
        self.contentView.snp.makeConstraints { (make) in
            make.bottom.greaterThanOrEqualTo(chatTextLabel)
        }
    }
    
}
