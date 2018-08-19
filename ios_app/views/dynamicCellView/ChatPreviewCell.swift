//
//  ChatPreviewCell.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/29.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit

class ChatPreviewCell: BasicViewCell {
    weak var delegate:SegueDelegate!
    var targetLabel:UILabel!
    var chatTextLabel:UILabel!
    var timeLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubviews()
        layout()
        config()
        setListener()
        
    }
}
//api
extension ChatPreviewCell{
    func setCellInfo(chatInfo:Chat){
        targetLabel.text = chatInfo.target
        let lastChatInfo = chatInfo.nickname+":"+chatInfo.text
        guard lastChatInfo.count>3 else{
            return
        }
        chatTextLabel.text = chatInfo.nickname+":"+chatInfo.text
        timeLabel.text = chatInfo.showTime
    }
}

//basic
extension ChatPreviewCell{
    private func config(){
        targetLabel.numberOfLines = 1
        targetLabel.textAlignment = .left
        targetLabel.font = UIFont(name:"ArialMT", size:17)
        
        chatTextLabel.textAlignment = .left
        chatTextLabel.textColor = UIColor.darkGray
        chatTextLabel.alpha = 0.9
        chatTextLabel.font = UIFont(name:"ArialMT", size:15)
        chatTextLabel.numberOfLines=0
        chatTextLabel.lineBreakMode = NSLineBreakMode.byCharWrapping
        
        timeLabel.font = UIFont(name:"ArialMT", size:10)
        timeLabel.textColor = UIColor.gray
        timeLabel.alpha = 0.9
    }
    @objc fileprivate func tapGestureAction(){
        Watcher.ChatTarget = targetLabel.text
        delegate.changeSegue()
    }
    private func setListener(){
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
        
    }
    private func initSubviews(){
        targetLabel = UILabel()
        chatTextLabel = UILabel()
        timeLabel = UILabel()
        self.contentView.addSubview(targetLabel)
        self.contentView.addSubview(timeLabel)
        self.addSubview(chatTextLabel)
 
    }
    private func layout(){
        self.contentView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
        }
        self.targetLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(10)
            make.height.equalTo(30)
            make.right.equalToSuperview()
        }
        self.timeLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalTo(targetLabel)
        }
        self.chatTextLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(targetLabel.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
 
        chatTextLabel.removeFromSuperview()
        contentView.addSubview(chatTextLabel)
        self.chatTextLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(targetLabel.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        self.contentView.snp.makeConstraints { (make) in
            make.bottom.greaterThanOrEqualTo(chatTextLabel).offset(10)
        }
    }
    
}

