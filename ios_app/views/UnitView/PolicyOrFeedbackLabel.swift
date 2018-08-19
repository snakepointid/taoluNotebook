//
//  PolicyOrFeedbackLabel.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/18.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit

class PolicyOrFeedbackLabel: BasicView {
    var policyTypeImg:UIImageView!
    var tokenLabel:UILabel!
    let tapf:TAPF
    
    init(tapf:TAPF)
    {
        self.tapf = tapf
        super.init()
        self.initSubviews()
        self.layout()
        self.config()
    }
    
    private func config(){
        if self.tapf.symbal==Constants.policySymbal{
            switch  self.tapf.type{
            case Constants.goodType:
                policyTypeImg.image = UIImage(named:"policy_good")
                break;
            case Constants.badType:
                policyTypeImg.image = UIImage(named:"policy_bad")
                break;
            default:
                break;
            }
        }else{
            tokenLabel.backgroundColor = UIColor.feedbackLabel
            switch  self.tapf.type{
            case Constants.goodType:
                policyTypeImg.image = UIImage(named:"feedback_good")
                break;
            case Constants.badType:
                policyTypeImg.image = UIImage(named:"feedback_bad")
                break;
            default:
                break;
            }
        }
        tokenLabel.adjustsFontSizeToFitWidth = true
        tokenLabel.textAlignment = NSTextAlignment.center
        tokenLabel.font = UIFont(name:"ArialMT", size:10)
        tokenLabel.layer.cornerRadius = 5.0
        tokenLabel.layer.masksToBounds = true
        tokenLabel.layer.borderWidth = 0.2
        tokenLabel.text = self.tapf.token
    }
    
    private func initSubviews(){
        tokenLabel = UILabel()
        policyTypeImg = UIImageView()
      
        self.addSubview(tokenLabel)
        self.addSubview(policyTypeImg)
    }
    private func layout(){
        tokenLabel.matchParent(margin: 5.0)
        policyTypeImg.snp.makeConstraints { (make) in
            make.bottom.centerX.equalTo(tokenLabel)
            make.width.height.equalTo(10)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
