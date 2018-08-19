//
//  OptionEditView.swift
//  taolu
//
//  Created by 佘昌略  on 2018/3/23.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit
import SnapKit
class OptionEditView: BasicView{
    weak var delegate:OptionViewDelegate!
    var switcherBtn:UIButton!
    var inputEdit:UITextField!
    
    var switcherBtnTitle:String?=Constants.targetLabel{
        didSet{
            switcherBtn.setTitle(switcherBtnTitle, for: .normal)
        }
    }
    var inputEditHint:String?{
        didSet{
            inputEdit.placeholder=inputEditHint
        }
    }
    
    override init()
    {
        super.init()
        initSubviews()
        config()
        layout()
        setListener()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
// basic
extension OptionEditView{
    private func initSubviews(){
        inputEdit = UITextField()
        self.addSubview(inputEdit)
        switcherBtn = UIButton()
        self.addSubview(switcherBtn)
    }
    private func setListener(){
        inputEdit.delegate = self
        inputEdit.addTarget(self, action: #selector(textChange(_:)), for: .allEditingEvents)
        switcherBtn.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
    }
    private func config(){
        inputEdit.borderStyle = UITextBorderStyle.roundedRect
        inputEdit.layer.masksToBounds = true
        inputEdit.layer.cornerRadius = 5.0
        inputEdit.layer.borderWidth = 0.3
        inputEdit.placeholder="请输入你的目标..."
        inputEdit.textAlignment = .left
        inputEdit.clearButtonMode = .whileEditing
        inputEdit.returnKeyType = UIReturnKeyType.send
        
        switcherBtn.backgroundColor = UIColor.feedbackLabel
        switcherBtn.layer.cornerRadius = 5.0
        switcherBtn.layer.masksToBounds = true
        switcherBtn.layer.borderWidth = 0.3
        switcherBtn.setTitleColor(UIColor.white, for: .normal)
        switcherBtn.setTitle(Constants.targetLabel, for: .normal)
        switcherBtn.titleLabel?.textAlignment = NSTextAlignment.center
    }
    private func layout(){
        switcherBtn.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.width.equalTo(50)
        }
        inputEdit.snp.makeConstraints { (make) in
            make.right.equalTo(switcherBtn.snp.left).offset(-5)
            make.top.bottom.equalTo(switcherBtn)
        }
        
        self.snp.makeConstraints { (make) in
            make.top.equalTo(inputEdit).offset(10)
            make.bottom.equalTo(inputEdit).offset(10)
            make.left.equalTo(inputEdit).offset(-5)
            make.right.equalTo(switcherBtn).offset(5)
        }
    }
}
//listener
extension OptionEditView{
    @objc func textChange(_ textField:UITextField) {
        guard var text = textField.text else{
            return
        }
        if text.count>5{
            text = text.substring(to: 4)
            textField.text = text
        }
        delegate.listOption(enterToken: text)
    }
    @objc func tapped(){
        
        if delegate != nil {
            delegate!.switchOption()
        }
    }
}
//delegate
extension OptionEditView:UITextFieldDelegate{
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let enterToken = inputEdit.text{
            guard enterToken.count>1 && enterToken.count<6 else{
                return true
            }
            delegate.enterOption(enterToken: enterToken)
        }
        
        inputEdit.text = ""
        return false
    }
}
