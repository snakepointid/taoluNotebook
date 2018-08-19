//
//  EditView.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/19.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit
import SnapKit
class EditView: BasicView{
    weak var delegate:BtnPressDelegate!
    var editField: UITextView!
    var ctrBtn: UIButton!
    var resignKB: UIButton!
    var segmentLine:SegmentLine!
    var hintLabel:UILabel!
    var ctrBtnConstraint: Constraint!
    var resignKBConstraint: Constraint!
    var hint:String!
    
    override init()
    {
        super.init( )
        initSubviews()
        layout()
        config()
        setListener()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        
        super.awakeFromNib()
        initSubviews()
        layout()
        config()
        setListener()
    }
}
//basic
extension EditView{
    private func config(){
        self.backgroundColor = UIColor.white
        editField.backgroundColor=UIColor.textEdit
        ctrBtn.backgroundColor=UIColor.feedbackLabel
        segmentLine.backgroundColor = UIColor.darkGray
        
        editField.isScrollEnabled=false
        editField.font = UIFont(name:"ArialMT", size:15)
        editField.textAlignment = NSTextAlignment.left
        editField.layer.masksToBounds = true
        editField.layer.cornerRadius = 10.0
        editField.layer.borderWidth = 0.3
        editField.delegate = self
        editField.returnKeyType = UIReturnKeyType.next
        
        hintLabel.textColor=UIColor.gray
        hintLabel.font = UIFont(name:"ArialMT", size:15)
        hintLabel.textAlignment = NSTextAlignment.left
        
        ctrBtn.layer.cornerRadius = 10.0
        ctrBtn.layer.masksToBounds = true
        ctrBtn.layer.borderWidth = 0.3
        ctrBtn.setTitleColor(UIColor.white, for: .normal)
        ctrBtn.setTitle("回复", for: .normal)
        ctrBtn.titleLabel?.textAlignment = NSTextAlignment.center
        
        resignKB.setImage(UIImage(named:"keyboard_hide.png"), for: .normal)
    }
    private func setListener(){
        ctrBtn.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        resignKB.addTarget(self, action: #selector(tapResignKB), for: .touchUpInside)
    }
    private func initSubviews(){
        hintLabel = UILabel()
        resignKB = UIButton()
        segmentLine = SegmentLine()
        editField = UITextView()
        ctrBtn = UIButton()
        hint = "说点什么..."
        hintLabel.text = hint
        self.addSubview(ctrBtn)
        self.addSubview(resignKB)
        self.addSubview(editField)
        self.addSubview(segmentLine)
        editField.addSubview(hintLabel)
        
    }
    private func layout(){
        ctrBtn.snp.makeConstraints { (make) in
            make.height.equalTo(35)
            ctrBtnConstraint = make.width.equalTo(0).constraint
            make.bottom.equalTo(editField)
        }
        editField.snp.makeConstraints { (make) in
            make.right.equalTo(ctrBtn.snp.left).offset(-5)
            make.left.equalTo(resignKB.snp.right).offset(5)
        }
        resignKB.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            resignKBConstraint = make.width.equalTo(0).constraint
            make.bottom.equalTo(editField)
        }
        segmentLine.snp.makeConstraints { (make) in
            make.top.equalTo(editField).offset(-10)
            make.height.equalTo(0.5)
            make.left.right.equalToSuperview()
        }
        hintLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(5)
            make.height.equalTo(20)
            make.width.equalTo(100)
        }
        self.snp.makeConstraints { (make) in
            make.top.equalTo(segmentLine)
            make.bottom.equalTo(editField).offset(10)
            make.left.equalTo(resignKB).offset(-10)
            make.right.equalTo(ctrBtn).offset(10)
        }
    }
}
//listener
extension EditView{
    @objc private func tapped(){
        if delegate != nil {
            delegate!.ctrBtnTap(info:editField.text)
            editField.text = ""
        }
    }
    @objc private func tapResignKB(){
   
         editField.resignFirstResponder()
    }
}
//delegates
extension EditView: UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let rawText = textView.text else{
            return true
        }
        let textLength = rawText.count + text.count - range.length
        if textLength>0{
            hintLabel.text = ""
        }else{
            hintLabel.text = hint
        }
        if textLength>1{
            ctrBtnConstraint.update(offset:50)
        }else{
            ctrBtnConstraint.update(offset:0)
        }
        
        return textLength<=140
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        resignKBConstraint.update(offset:30)
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        ctrBtnConstraint.update(offset:0)
        resignKBConstraint.update(offset:0)
        hintLabel.text = hint
        editField.text = ""
    }
  
}
