//
//  TextEditView.swift
//  taolu
//
//  Created by 佘昌略  on 2018/3/21.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit
import SnapKit
class inputEditView: UIView {
    var switherBtn:UIButton!
    var switcherBtnTitle:String?{
        didSet{
            switherBtn.setTitle(switcherBtnTitle, for: .normal)
        }
    }
    init()
    {
        super.init(frame:CGRect(x:0, y:0, width:100, height:20))
        let inputEdit = UITextField()
        inputEdit.borderStyle = UITextBorderStyle.roundedRect
        inputEdit.layer.masksToBounds = true
        inputEdit.layer.cornerRadius = 5.0
        inputEdit.layer.borderWidth = 1.0
        inputEdit.placeholder="请输入用户名"
        inputEdit.textAlignment = .left
        inputEdit.clearButtonMode = .whileEditing
        self.addSubview(inputEdit)
        switherBtn = UIButton()
        switherBtn.layer.cornerRadius = 5.0
        switherBtn.layer.masksToBounds = true
        switherBtn.layer.borderWidth = 1
        switherBtn.setTitleColor(UIColor.darkGray, for: .normal)
        switherBtn.titleLabel?.textAlignment = NSTextAlignment.center
        switherBtn.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        self.addSubview(switherBtn)
        switherBtn.snp.makeConstraints { (make) in
             make.width.height.equalTo(30)
        }
        inputEdit.snp.makeConstraints { (make) in
            make.right.equalTo(switherBtn.snp.left).offset(5)
            make.top.bottom.equalTo(switherBtn)
        }
        self.snp.makeConstraints { (make) in
            make.left.top.equalTo(inputEdit).offset(5)
            make.right.bottom.equalTo(switherBtn).offset(5)
        }
    }
    @objc func tapped(){
        if switherBtn.titleLabel?.text==Constants.policyLabel{
            switcherBtnTitle = Constants.feedbackLabel
        }else if switherBtn.titleLabel?.text==Constants.feedbackLabel{
            switcherBtnTitle = Constants.policyLabel
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
}

