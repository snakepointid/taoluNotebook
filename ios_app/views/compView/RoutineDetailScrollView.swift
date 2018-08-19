//
//  RoutineDetailsView.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/18.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit

class RoutineDetailScrollView: UIScrollView {
    @IBOutlet weak var policyAndFeedbacksView: PolicyAndFeedbacksView!
    @IBOutlet weak var routineBanner:RoutineBanner!
    @IBOutlet weak var processTitleView: ProcessTitleView!

    private func layout(){
        self.routineBanner.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        self.policyAndFeedbacksView.snp.makeConstraints { (make) in
            make.top.equalTo(self.routineBanner.snp.bottom)
            make.left.right.equalToSuperview()
        }
        self.policyAndFeedbacksView.tokenLabelWidth = UIScreen.main.bounds.size.width/5.0
        self.processTitleView.snp.makeConstraints { (make) in
            make.top.equalTo(self.policyAndFeedbacksView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        self.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.size.width)
            make.bottom.equalTo(self.processTitleView)
        }
    }
    private func config(){
        self.showsVerticalScrollIndicator = false
        self.bounces = true
        self.alwaysBounceVertical = true
    }
 
    init(){
        super.init(frame:CGRect(x:0, y:0, width:100, height:30))
        config()
        layout()
        
    }
 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        config()
        layout()
    }
}
//api
extension RoutineDetailScrollView{
    func setRoutineInfo(routine:Routine){
        self.policyAndFeedbacksView.setPolicyAndFeedbacksInfo(policyAndFeedbacks: Array(routine.policyAndFeedbacks))
        self.routineBanner.setBannerInfo(routine:routine)
        self.processTitleView.setProcessInfo(routine: routine)
    }
}
