//
//  MessageCell.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/27.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit
import SnapKit

class MessageCell: BasicViewCell {
    var titleLabel:UILabel!
    var detailLabel:UILabel!
    var timeLabel:UILabel!
    var impImg:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        initSubviews()
        layout()
        config()
        
    }
}
//api
extension MessageCell{
    func setCellInfo(messageInfo:Message){
        titleLabel.text = messageInfo.title
        detailLabel.text = messageInfo.detail
        timeLabel.text = messageInfo.messageTime
        impImg.isHidden = messageInfo.importFlag ? false:true
    }
    
    
}

//basic
extension MessageCell{
    private func config(){
        impImg.image = UIImage(named: "important.png")
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name:"ArialMT", size:20)
        
        detailLabel.textAlignment = .left
        detailLabel.font = UIFont(name:"ArialMT", size:15)
        detailLabel.numberOfLines=0
        detailLabel.lineBreakMode = NSLineBreakMode.byCharWrapping
        
        timeLabel.font = UIFont(name:"ArialMT", size:10)
        timeLabel.textColor = UIColor.gray
        timeLabel.alpha = 0.9
    }
    
    private func initSubviews(){
        titleLabel = UILabel()
        detailLabel = UILabel()
        timeLabel = UILabel()
        impImg = UIImageView()
        
        self.contentView.addSubview(titleLabel)
        self.addSubview(detailLabel)
        self.addSubview(timeLabel)
        self.contentView.addSubview(impImg)
    }
    private func layout(){
        self.contentView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
        }
        self.impImg.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.centerY.equalTo(titleLabel)
            make.height.width.equalTo(15)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(impImg.snp.right).offset(5)
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(30)
        }
        self.timeLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalTo(titleLabel) 
        }
        self.detailLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-5)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        detailLabel.removeFromSuperview()
        contentView.addSubview(detailLabel)
        self.detailLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-5)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        self.contentView.snp.makeConstraints { (make) in
            make.bottom.greaterThanOrEqualTo(detailLabel).offset(20)
        }
    }
    
}
