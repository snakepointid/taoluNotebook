//
//  ProcessTitleView.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/18.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit

class ProcessTitleView: BasicView{
    var createTimeLabel:UILabel!
    var titleField:UITextField!
    var processField:UITextView!
    
    private func layout(){
        createTimeLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(20)
            make.height.equalTo(10)
        }
        titleField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(createTimeLabel!.snp.bottom).offset(5)
            make.height.equalTo(20)
        }
        processField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.top.equalTo(titleField.snp.bottom)
            //make.height.equalTo(30)
        }
        self.snp.makeConstraints { (make) in
            make.bottom.equalTo(processField)
            make.width.equalTo(UIScreen.main.bounds.size.width)
        }
    }
    private func config(){
        createTimeLabel.textColor = UIColor.darkGray
        createTimeLabel.alpha = 0.5
        createTimeLabel.font = UIFont(name:"ArialMT", size:10)
        
        processField.isScrollEnabled=false
        processField.font = UIFont(name:"ArialMT", size:15)
        processField.textAlignment = NSTextAlignment.left
        processField.isEditable = false
        processField.delegate = self
        processField.textColor = UIColor.darkGray
        
        titleField.font = UIFont(name:"ArialMT", size:17)
        titleField.textAlignment = NSTextAlignment.left
        titleField.adjustsFontSizeToFitWidth = true
        titleField.isEnabled = false
        titleField.delegate = self
    }
 
    private func initSubviews(){
        createTimeLabel = UILabel()
        titleField = UITextField()
        processField = UITextView()
        self.addSubview(createTimeLabel)
        self.addSubview(titleField)
        self.addSubview(processField)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubviews()
        config()
        layout()
        
    }
    
    required init?(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)
        initSubviews()
        config()
        layout()
        
    }
}
//api
extension ProcessTitleView{
    
    func setProcessInfo(routine:Routine){
        createTimeLabel.text = routine.createTime
        titleField.text = routine.complement?.title
        processField.text = routine.complement?.process
       // updateLayout()
    }
    func setProcessInfo(share:Share){
        createTimeLabel.text = share.shareTime
        titleField.text = share.title
        processField.text = share.process
        //updateLayout()
    }
    func getProcess()->String{
        return processField.text
    }
    func getTitle()->String?{
        return titleField.text
    }
    func beginToEdit(createTime:String){
        processField.isEditable = true
        titleField.isEnabled = true
        createTimeLabel.text = createTime
        titleField.placeholder = "点击修改标题"
        processField.becomeFirstResponder()
    }
}
//delegate
extension ProcessTitleView: UITextFieldDelegate,UITextViewDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else{
            return true
        }
        
        let textLength = text.count + string.count - range.length
        return textLength<=15
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let text = textView.text else{
            return true
        }
        return text.count<=500
    }
}
