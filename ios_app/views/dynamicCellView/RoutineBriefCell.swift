//
//  RoutineBriefCell.swift
//  taolu
//
//  Created by 佘昌略  on 2018/3/29.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit
import SnapKit
import Foundation
class RoutineBriefCell: BasicViewCell {
    weak var delegate:SegueDelegate!
    @IBOutlet weak var verticalBanner:RoutineVerticalBanner!
    var routineBriefInfo:UILabel!
    var routine:Routine?{
        didSet{
            
            if let process = routine?.complement?.process{
                if process.count>2{
                     routineBriefInfo.text = process
                }else{
                    var breifInfo = ""
                    for policyOrFeedback in routine!.policyAndFeedbacks{
                        breifInfo = breifInfo+"->"+policyOrFeedback.token
                    }
                    routineBriefInfo.text = breifInfo.substring(from: 2)
                }
               
            }else{
                var breifInfo = ""
                for policyOrFeedback in routine!.policyAndFeedbacks{
                    breifInfo = breifInfo+"->"+policyOrFeedback.token
                }
                routineBriefInfo.text = breifInfo.substring(from: 2)
            }
            
            verticalBanner.setRoutineInfo(routine: routine!)
        }
    }
    
    @objc fileprivate func tapGestureAction(){
        Watcher.RoutineDetail = routine
        delegate.changeSegue()
    }
    private func config(){
        routineBriefInfo = UILabel()
        routineBriefInfo.textAlignment = NSTextAlignment.left
        routineBriefInfo.numberOfLines=0
        routineBriefInfo.lineBreakMode = NSLineBreakMode.byCharWrapping
        routineBriefInfo.textColor = UIColor.darkGray
        routineBriefInfo.alpha = 0.7
        routineBriefInfo.font = UIFont(name:"ArialMT", size:15)
        addSubview(routineBriefInfo)
    }
    private func layout(){
        
        contentView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        verticalBanner.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
        }
        routineBriefInfo.snp.makeConstraints { (make) in
            make.centerY.right.equalToSuperview()
            make.left.equalTo(verticalBanner.snp.right)
        }
        
        routineBriefInfo.removeFromSuperview()
        contentView.addSubview(routineBriefInfo)
        
        routineBriefInfo.snp.makeConstraints { (make) in
            make.centerY.right.equalToSuperview()
            make.left.equalTo(verticalBanner.snp.right)
        }
        contentView.snp.makeConstraints { (make) in
            make.bottom.greaterThanOrEqualTo(routineBriefInfo).offset(20)
            make.bottom.greaterThanOrEqualTo(verticalBanner)
        }
        
    }
    private func addListener(){
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        config()
        addListener()
        layout()
        
    }
}
