//
//  TargetStaticCell.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/27.
//  Copyright © 2018年 佘昌略. All rights reserved.
//
import UIKit

class TargetStaticCell: BasicViewCell {
    
    var targetLabel:UILabel!
    var successLabel:UILabel!
    var timesLabel:UILabel!
    var agentMostLabel:UILabel!
    var agentSuccessLabel:UILabel!
    var agentTimesLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubviews()
        layout()
        config()
        
    }
}
//api
extension TargetStaticCell{
    func setCellInfo(targetInfo:BayesKey){
        targetLabel.text = "目标："+targetInfo.token
        timesLabel.text = "频次："+String(targetInfo.all)
        successLabel.text = "满意率："+String(format:"%.2f",targetInfo.positiveProbability)
        
        let queries = targetInfo.queries.filter("query LIKE '2*'")
        guard queries.count > 0 else{
            return
        }
        var old = 0
        var mostAgent:BayesQuery!
        for query in queries{
            if query.all > old{
                old = query.all
                mostAgent = query
            }
        }
        agentMostLabel.text = "关注对象："+mostAgent.token
        agentTimesLabel.text = "频次："+String(mostAgent.all)
        agentSuccessLabel.text = "满意率："+String(format:"%.2f",mostAgent.positiveProbability)
    }
    
    
}

//basic
extension TargetStaticCell{
    private func config(){
        targetLabel.font = UIFont(name:"ArialMT", size:15)
        successLabel.font = UIFont(name:"ArialMT", size:15)
        timesLabel.font = UIFont(name:"ArialMT", size:15)
        
        agentMostLabel.font = UIFont(name:"ArialMT", size:15)
        agentSuccessLabel.font = UIFont(name:"ArialMT", size:15)
        agentTimesLabel.font = UIFont(name:"ArialMT", size:15)
        
        targetLabel.adjustsFontSizeToFitWidth = true
        agentMostLabel.adjustsFontSizeToFitWidth = true
        
        targetLabel.textAlignment = .left
        successLabel.textAlignment = .left
        timesLabel.textAlignment = .left
        agentMostLabel.textAlignment = .left
        agentSuccessLabel.textAlignment = .left
        agentTimesLabel.textAlignment = .left
    }
    
    private func initSubviews(){
        targetLabel = UILabel()
        successLabel = UILabel()
        timesLabel = UILabel()
        agentMostLabel = UILabel()
        agentSuccessLabel = UILabel()
        agentTimesLabel = UILabel()
        
        self.contentView.addSubview(targetLabel)
        self.contentView.addSubview(successLabel)
        self.contentView.addSubview(timesLabel)
        self.contentView.addSubview(agentMostLabel)
        self.contentView.addSubview(agentSuccessLabel)
        self.contentView.addSubview(agentTimesLabel)
        
    }
    private func layout(){
        let screenWidth = UIScreen.main.bounds.size.width
        self.contentView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
        }
        self.targetLabel.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
            
            make.width.equalTo(screenWidth/3)
        }
        self.agentMostLabel.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(targetLabel)
            make.top.equalTo(targetLabel.snp.bottom).offset(10)
             
        }
        self.successLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(targetLabel)
            make.right.equalToSuperview()
            make.width.equalTo(screenWidth/3)
        }
        self.agentSuccessLabel.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(successLabel)
            make.top.equalTo(successLabel.snp.bottom).offset(10)
            
        }
        self.timesLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(targetLabel)
            make.left.equalTo(targetLabel.snp.right)
            make.right.equalTo(successLabel.snp.left)
            
        }
        self.agentTimesLabel.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(timesLabel)
            make.top.equalTo(timesLabel.snp.bottom).offset(10)
        }
        self.contentView.snp.makeConstraints { (make) in
            make.bottom.greaterThanOrEqualTo(agentTimesLabel).offset(20)
        }
    }
}
