//
//  AdviceSendView.swift
//  taolu
//
//  Created by 佘昌略  on 2018/5/3.
//  Copyright © 2018年 佘昌略. All rights reserved.
//
import UIKit

class AdviceSendView: BasicView{
    weak var delegate:AdviceDelegate!
    var uploadBtn:UIButton!
    
    var adviceLabel: UILabel!
    var adviceEditField: UITextView!
    var advicePlaceholder:UILabel!
    
    var mailLabel: UILabel!
    var mailEditField: UITextField!
    
    var otherLabel: UILabel!
    var otherEditField: UITextField!
    var hint:String!
    override init()
    {
        
        super.init( )
        initSubviews()
        layout()
        config()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        
        super.awakeFromNib()
        initSubviews()
        layout()
        config()
        setData()
    }
}

//basic
extension AdviceSendView{
    private func setData(){
        hint = " 我们将听取意见，积极改进"
        adviceLabel.text = " 意见反馈："
        advicePlaceholder.text = hint
        
        mailLabel.text = " 邮箱(选填)："
        mailEditField.placeholder = "留下邮箱以便我们联系您"
        
        otherLabel.text = " 其他(选填)："
        otherEditField.placeholder = "其他联系方式（QQ/微信/手机号）"
        
        uploadBtn.setTitle("提交", for: .normal)
    }
    private func config(){
        self.backgroundColor = UIColor.searchBarColor
        
        adviceLabel.font = UIFont(name:"ArialMT", size:10)
        adviceLabel.textAlignment = .left
        adviceLabel.backgroundColor = UIColor.white
        
        adviceEditField.isScrollEnabled=false
        adviceEditField.font = UIFont(name:"ArialMT", size:15)
        adviceEditField.textAlignment = NSTextAlignment.left
        adviceEditField.delegate = self
        
        
        advicePlaceholder.font = UIFont(name:"ArialMT", size:15)
        adviceLabel.textAlignment = .left
        advicePlaceholder.textColor = UIColor.gray
        advicePlaceholder.alpha = 0.8
        
        
        mailLabel.font = UIFont(name:"ArialMT", size:10)
        mailLabel.textAlignment = .left
        mailLabel.backgroundColor = UIColor.white
        
        mailEditField.font = UIFont(name:"ArialMT", size:10)
        mailEditField.backgroundColor = UIColor.white
        mailEditField.delegate = self
        mailEditField.autocorrectionType = .no
        mailEditField.autocapitalizationType = .none
        
        otherLabel.font = UIFont(name:"ArialMT", size:10)
        otherLabel.textAlignment = .left
        otherLabel.backgroundColor = UIColor.white
        
        otherEditField.font = UIFont(name:"ArialMT", size:10)
        otherEditField.backgroundColor = UIColor.white
        otherEditField.delegate = self
        otherEditField.autocorrectionType = .no
        otherEditField.autocapitalizationType = .none
        
        uploadBtn.titleLabel?.textAlignment = .center
        uploadBtn.backgroundColor = UIColor.lightGray
        uploadBtn.layer.cornerRadius = 8.0
        uploadBtn.layer.masksToBounds = true
        
        uploadBtn.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    @objc func tapped(){
        guard let advice = adviceEditField.text else{
            return
        }
        guard advice.count>10 else{
            return
        }
        if delegate != nil {
            delegate!.uploadAdvice(advice: advice, mailContact: mailEditField.text, otherContact: otherEditField.text)
        }
    }
    private func initSubviews(){
        adviceLabel = UILabel()
        adviceEditField = UITextView()
        advicePlaceholder = UILabel()
        
        mailLabel = UILabel()
        mailEditField = UITextField()
        
        otherLabel = UILabel()
        otherEditField = UITextField()
        
        uploadBtn = UIButton()
        
        self.addSubview(adviceLabel)
        self.addSubview(adviceEditField)
        self.addSubview(advicePlaceholder)
        
        self.addSubview(mailLabel)
        self.addSubview(mailEditField)
        
        self.addSubview(otherLabel)
        self.addSubview(otherEditField)
        
        self.addSubview(uploadBtn)
    }
    private func layout(){
        
        adviceLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(30)
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
        }
        adviceEditField.snp.makeConstraints { (make) in
            make.top.equalTo(adviceLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(150)
        }
        advicePlaceholder.snp.makeConstraints { (make) in
            make.top.equalTo(adviceLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
        }
        mailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(adviceEditField.snp.bottom).offset(30)
            make.left.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(60)
        }
        
        mailEditField.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(mailLabel)
            make.left.equalTo(mailLabel.snp.right)
            make.right.equalToSuperview()
        }
        otherLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mailEditField.snp.bottom).offset(30)
            make.left.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(60)
        }
        
        otherEditField.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(otherLabel)
            make.left.equalTo(otherLabel.snp.right)
            make.right.equalToSuperview()
        }
        
        uploadBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-30)
            make.height.equalTo(50)
        }
    }
}
//delegate
extension AdviceSendView: UITextFieldDelegate,UITextViewDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else{
            return true
        }
        
        let textLength = text.count + string.count - range.length
        return textLength<=50
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let rawText = textView.text else{
            return true
        }
        let textLength = rawText.count + text.count - range.length
        
        advicePlaceholder.text = textLength>0 ? "":hint
        
        uploadBtn.backgroundColor = textLength > 10 ? UIColor.feedbackLabel: UIColor.lightGray
        
        return textLength<=200
    }
}


