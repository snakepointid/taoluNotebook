//
//  TokenStaticCell.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/27.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit

class TokenStaticCell: BasicViewCell {
    
    var typeLabel:UILabel!
    var tokenLabel:UILabel!
    var frequencyLabel:UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubviews()
        layout()
        config()
        
    }
}
//api
extension TokenStaticCell{
    func setCellInfo(token:Token){
        switch token.symbal {
        case Constants.targetSymbal:
            typeLabel.text = Constants.targetLabel;
            break;
        case Constants.policySymbal:
            typeLabel.text = Constants.policyLabel;
            break;
        case Constants.feedbackSymbal:
            typeLabel.text = Constants.feedbackLabel;
            break;
        default:
            typeLabel.text = Constants.agentLabel;
            break;
        }
        frequencyLabel.text = String(token.frequency)
        tokenLabel.text = token.token
    }
 
    
}

//basic
extension TokenStaticCell{
    private func config(){
        tokenLabel.font = UIFont(name:"ArialMT", size:15)
        frequencyLabel.font = UIFont(name:"ArialMT", size:15)
        typeLabel.font = UIFont(name:"ArialMT", size:15)
        
        tokenLabel.textAlignment = .left
        frequencyLabel.textAlignment = .left
        typeLabel.textAlignment = .center
    }
    
    private func initSubviews(){
       tokenLabel = UILabel()
        frequencyLabel = UILabel()
        typeLabel = UILabel()
        
        self.contentView.addSubview(tokenLabel)
        self.contentView.addSubview(frequencyLabel)
        self.contentView.addSubview(typeLabel)
        
    }
    private func layout(){
        let screenWidth = UIScreen.main.bounds.size.width
        self.contentView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
        }
        self.typeLabel.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(screenWidth/3)
        }
        self.frequencyLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(typeLabel)
            make.right.equalToSuperview()
            make.width.equalTo(screenWidth/6)
        }
        self.tokenLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(typeLabel)
            make.left.equalTo(typeLabel.snp.right)
            make.right.equalTo(frequencyLabel.snp.left)
        }
        self.contentView.snp.makeConstraints { (make) in
            make.bottom.greaterThanOrEqualTo(tokenLabel).offset(20)
        }
    }
}
