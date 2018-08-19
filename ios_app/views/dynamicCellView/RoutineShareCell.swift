//
//  RoutineShareCell.swift
//  taolu
//
//  Created by 佘昌略  on 2018/3/25.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit
import SnapKit
class RoutineShareCell: BasicViewCell {
    weak var delegate:SegueDelegate!
    @IBOutlet weak var sharePostView:SharePostView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var targetLabel:UILabel!
    var userInfoView:UserInfoView!
    var processLabel:UILabel!
    var share:Share?{
        didSet{
            sharePostView.setShareInfo(share:share!)
            processLabel.text = share!.process
            titleLabel.text = share!.title
            targetLabel.text = "#"+share!.target.substring(from: 1)
            userInfoView.setUserInfo(share: share!)
        }
    }
    private func layout(){
    
        
        contentView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        userInfoView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(30)
            make.right.equalToSuperview().offset(-20)
        }
        targetLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userInfoView.snp.bottom)
            make.left.equalToSuperview().offset(5)
            make.height.equalTo(20)
            make.width.equalTo(50)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(targetLabel)
            make.left.equalTo(targetLabel.snp.right)
            make.right.equalToSuperview()
        }
        processLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        processLabel.removeFromSuperview()
        contentView.addSubview(processLabel)
        processLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        sharePostView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(processLabel.snp.bottom).offset(30)
            make.height.equalTo(15)
        }
        contentView.snp.makeConstraints { (make) in
            make.bottom.greaterThanOrEqualTo(sharePostView).offset(10)
        }
    }
    
    private func addListener(){
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
        
    }
    private func initSubviews(){
        processLabel = UILabel()
        userInfoView = UserInfoView()
        addSubview(processLabel)
        self.contentView.addSubview(userInfoView)
    }
    private func config(){
        processLabel.textAlignment = NSTextAlignment.left
        processLabel.numberOfLines=0
        processLabel.lineBreakMode = NSLineBreakMode.byCharWrapping
        processLabel.font = UIFont(name:"ArialMT", size:15)
        processLabel.textColor = UIColor.gray
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = NSTextAlignment.left
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont(name:"ArialMT", size:17)
        targetLabel.adjustsFontSizeToFitWidth = true
        targetLabel.textAlignment = NSTextAlignment.right
        targetLabel.numberOfLines = 1
        targetLabel.textColor = UIColor.feedbackLabel
        targetLabel.font = UIFont(name:"ArialMT", size:17)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubviews()
        config()
        layout()
        addListener()
    }
}
extension RoutineShareCell{
    @objc fileprivate func tapGestureAction(){
        Watcher.RoutineShare = share
        delegate.changeSegue()
    }
}
