//
//  RoutineListCell.swift
//  taolu
//
//  Created by 佘昌略  on 2018/3/16.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit
import SnapKit
class RoutineListCell: BasicViewCell {
    weak var delegate:SegueDelegate!
    @IBOutlet weak var verticalBanner:RoutineVerticalBanner!
    @IBOutlet weak var policyAndFeedbacksView: PolicyAndFeedbacksView!
    
    var routine:Routine!{
        didSet{
            
            verticalBanner.setRoutineInfo(routine:routine)
            policyAndFeedbacksView.tokenLabelWidth = (UIScreen.main.bounds.size.width-80)/5.0
            policyAndFeedbacksView.setPolicyAndFeedbacksInfo(policyAndFeedbacks: Array(routine.policyAndFeedbacks))
        }
    }
 
    @objc fileprivate func tapGestureAction(){
        Watcher.RoutineDetail = routine
        delegate.changeSegue()
    }
    private func setListener(){
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
        
    }
    private func layout(){
        contentView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        verticalBanner.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
        }
        policyAndFeedbacksView.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.left.equalTo(verticalBanner.snp.right)
        }
        contentView.snp.makeConstraints { (make) in
            make.bottom.greaterThanOrEqualTo(policyAndFeedbacksView).offset(20)
            make.bottom.greaterThanOrEqualTo(verticalBanner)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setListener()
        layout()
    }
}



