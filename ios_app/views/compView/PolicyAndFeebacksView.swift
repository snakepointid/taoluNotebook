//
//  PolicyAndFeebacksView.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/18.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit
import SnapKit
class PolicyAndFeedbacksView:BasicView{
    var savedPolicyAndFeedbacks:[TAPF]=[]
    var tokenLabelWidth:CGFloat!
    var postionManager:PositionManager!
    var bottomConstraint:Constraint?
    let tokenLabelNum:Int = 5
    
    enum PositionTypes{
        case bottom
        case left
        case right
        case first
    }
    
    struct PositionManager{
        var addLeftTimes:Int!=0
        var addRightTimes:Int!=0
        var addBottomTimes:Int!=0
        var indexPositionType:PositionTypes = PositionTypes.first
        var shouldAddRight:Bool!=false
    }
    
    private func refreshLabelPostion(){
        switch postionManager.indexPositionType {
        case .right:
            postionManager.addRightTimes!+=1;
            if postionManager.addRightTimes==tokenLabelNum-1{
                postionManager.indexPositionType = PositionTypes.bottom
                postionManager.addRightTimes=0
                postionManager.shouldAddRight = false
            };
            break;
        case .left:
            postionManager.addLeftTimes!+=1;
            if postionManager.addLeftTimes==tokenLabelNum-1{
                postionManager.indexPositionType = PositionTypes.bottom
                postionManager.addLeftTimes=0
                postionManager.shouldAddRight = true
            };
            break;
        case .bottom:
            postionManager.addBottomTimes!+=1;
            if postionManager.addBottomTimes==2{
                postionManager.addBottomTimes = 0
                if postionManager.shouldAddRight{
                    postionManager.indexPositionType = PositionTypes.right
                }else{
                    postionManager.indexPositionType = PositionTypes.left
                }
            };
            break;
        case .first:
            postionManager.indexPositionType = PositionTypes.right;
            break;
        }
        
    }
    
    private func config(){
        postionManager = PositionManager()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        config()
    }
}
//api
extension PolicyAndFeedbacksView{
    func setPolicyAndFeedbacksInfo(policyAndFeedbacks:[TAPF]){
        self.subviews.forEach{ $0.removeFromSuperview()}
        postionManager = PositionManager()
        for policyOrFeedback in  policyAndFeedbacks{
        addPolicyOrFeedback(policyOrFeedback: policyOrFeedback,addFlag: false)
        }
    }
    func addPolicyOrFeedback(policyOrFeedback:TAPF,addFlag:Bool=true){
        if addFlag{
            savedPolicyAndFeedbacks.append(policyOrFeedback)
        }
        let policyOrFeedbackLabel = PolicyOrFeedbackLabel(tapf: policyOrFeedback)
        self.addSubview(policyOrFeedbackLabel)
        
        switch postionManager.indexPositionType{
        case .bottom:
            policyOrFeedbackLabel.layBottomUnder(target:subviews.lastN(at:2));
            break;
        case .left:
            policyOrFeedbackLabel.layLeftTo(target:subviews.lastN(at:2));
            break;
        case .right:
            policyOrFeedbackLabel.layRightTo(target:subviews.lastN(at:2));
            break;
        case .first:
            policyOrFeedbackLabel.snp.makeConstraints { (make) in
                make.top.left.equalToSuperview()
                make.width.equalTo(tokenLabelWidth)
                make.height.equalTo(40)};
            break;
        }
        bottomConstraint?.deactivate()
        self.snp.makeConstraints { (make) in
            bottomConstraint = make.bottom.equalTo(subviews.last!).constraint
        }
        refreshLabelPostion()
    }
    
    func dropLastOne(){
        if let lastView =  subviews.last{
            lastView.removeFromSuperview()
            savedPolicyAndFeedbacks.removeLast()
            postionManager = PositionManager()
            subviews.forEach({ _ in refreshLabelPostion()})
        }
    }
    var isLastPolicy:Bool{
        get{
            guard let tapf = savedPolicyAndFeedbacks.last else{
                return false
            }
            return tapf.symbal == Constants.policySymbal
        }
       
    }
    var isPolicyAndFeedbackEdited:Bool{
        get{
             return savedPolicyAndFeedbacks.count > 1
        }
       
    }
    
    var policyAndFeedbackNumber:Int{
        get{
            return savedPolicyAndFeedbacks.count
        }
        
    }
    var lastTwoTokens: [String]{
        
        guard policyAndFeedbackNumber>0 else{
            return []
        }
        guard policyAndFeedbackNumber>1 else{
            return [savedPolicyAndFeedbacks[0].keyToken]
        }
        return [savedPolicyAndFeedbacks[policyAndFeedbackNumber-2].keyToken,
                savedPolicyAndFeedbacks[policyAndFeedbackNumber-1].keyToken]
    }
}

