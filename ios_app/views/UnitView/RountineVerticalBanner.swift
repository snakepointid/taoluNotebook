//
//  RountineVerticalBanner.swift
//  taolu
//
//  Created by 佘昌略  on 2018/3/22.
//  Copyright © 2018年 佘昌略. All rights reserved.
//


import UIKit

class RoutineVerticalBanner: BasicView{
     var targetLabel:UILabel!
     var agentLabel:UILabel!
     var outcomeImage:UIImageView!
     var timeLabel:UILabel!
    

    private func config(){
        targetLabel.adjustsFontSizeToFitWidth = true
        targetLabel.font = UIFont(name:"System", size:15)
        targetLabel.textAlignment = .left
        
        agentLabel.adjustsFontSizeToFitWidth = true
        agentLabel.font = UIFont(name:"System", size:15)
        agentLabel.textAlignment = .left
        
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.font = UIFont(name:"System", size:7)
        timeLabel.textAlignment = .right
        timeLabel.textColor = UIColor.feedbackLabel
    }
    private func initSubviews(){
         targetLabel = UILabel()
         agentLabel = UILabel()
         outcomeImage = UIImageView()
         timeLabel = UILabel()
        self.addSubview(targetLabel)
        self.addSubview(agentLabel)
        self.addSubview(outcomeImage)
        self.addSubview(timeLabel)
    }
    private func layout(){
        //set postion
        outcomeImage.snp.makeConstraints { (make) in
            make.height.width.equalTo(15.0)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(outcomeImage)
            make.right.equalTo(outcomeImage.snp.left).offset(-5.0)
            make.height.equalTo(10.0)
            make.width.equalTo(30.0)
        }
        targetLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel)
            make.top.equalTo(timeLabel.snp.bottom).offset(10.0)
            make.width.equalTo(50.0)
            make.height.equalTo(20.0)
        }
        agentLabel.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(targetLabel)
            make.top.equalTo(targetLabel.snp.bottom).offset(10.0)
        }
        self.snp.makeConstraints { (make) in
            make.top.equalTo(outcomeImage).offset(-10.0)
            make.right.equalTo(outcomeImage).offset(10.0)
            make.left.equalTo(agentLabel).offset(-10.0)
            make.bottom.equalTo(agentLabel).offset(10.0)
        }
    }
    override init()
    {
        super.init()
        initSubviews()
        config()
        layout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubviews()
        config()
        layout()
        
    }
}
extension RoutineVerticalBanner{
    func setRoutineInfo(routine:Routine){
        targetLabel.text = routine.target.substring(from: 1)
        agentLabel.text = routine.agent.substring(from: 1)
        timeLabel.text = routine.showTime
        outcomeImage.image = routine.outcome==Constants.positiveOutcome ? UIImage(named:"happy") : UIImage(named:"sad")
        
    }
}
