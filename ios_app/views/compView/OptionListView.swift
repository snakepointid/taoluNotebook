//
//  OptionListView.swift
//  taolu
//
//  Created by 佘昌略  on 2018/3/20.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit

class OptionListView: BasicView {
    weak var delegate:OptionViewDelegate!
    var optionEditView:OptionEditView!
    var optionLabels:[OptionBtn]=[]
    var optionList:[TAPF]=[] {
        didSet
        {
            optionEditView.delegate = self.delegate
            optionLabels.forEach({ $0.removeFromSuperview()})
            optionLabels = []
            showOptions()
        }
    }
    
    
    private func showOptions(){
        let optionBtnWidth = (UIScreen.main.bounds.size.width-70)/3.0
        for index in 0..<optionList.count{
            guard index<9 else{
                break
            }
            
            let optionBtn = OptionBtn(option:optionList[index])
            optionBtn.delegate = self.delegate
            self.addSubview(optionBtn)
            
            guard index > 0 else{
                optionBtn.layUpperLeftCorner(margin: 10,width:optionBtnWidth,height:40)
                optionLabels.append(optionBtn)
                continue
            }
            if index%3==0{
                optionBtn.layBottomUnder(target:optionLabels[index-3],margin: 10)
            }else{
                optionBtn.layRightTo(target:optionLabels.last!,margin: 15)
            }
            optionLabels.append(optionBtn)
        }
        
    }
  
    override init()
    {
        super.init()
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
        optionEditView = OptionEditView()
        self.addSubview(optionEditView)
        
        optionEditView.snp.makeConstraints { (make) in
            make.width.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(170)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
