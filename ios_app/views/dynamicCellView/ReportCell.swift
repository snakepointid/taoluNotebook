//
//  ReportCell.swift
//  taolu
//
//  Created by 佘昌略  on 2018/5/2.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit

class ReportCell: UICollectionViewCell {
    weak var delegate:BtnPressDelegate!
    var reportImg:UIImageView!
    var reportLabel:UILabel!
    var label:String!{
        didSet{
            reportLabel.text=label
        }
    }
 
    var clicked:Bool=false{
        didSet{
            if clicked{
                reportImg.image = UIImage(named:"circle_click.png")
            }else{
                reportImg.image = UIImage(named:"circle.png")
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubviews()
        config()
        layout()
        addListener()
    }
}
//delegate
extension ReportCell{
    @objc func tapped(){
        if delegate != nil {
            clicked = clicked ? false : true
            delegate.ctrBtnTap(info:label)
        }
    }
}
//basic
extension ReportCell{
    private func config(){
        reportLabel.textAlignment = NSTextAlignment.left
        reportLabel.font = UIFont(name:"ArialMT", size:15)
        reportImg.image = UIImage(named:"circle.png")
    }
    private func initSubviews(){
        reportLabel = UILabel()
        reportImg = UIImageView()
        self.contentView.addSubview(reportLabel)
        self.contentView.addSubview(reportImg)
    }
    private func layout(){
        self.contentView.snp.makeConstraints { (make) in
            make.top.right.top.bottom.equalToSuperview()
        }
        reportImg.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(15)
        }
        reportLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(reportImg)
            make.left.equalTo(reportImg.snp.right).offset(10)
            make.width.equalTo(100)
            make.right.equalToSuperview().offset(-10)
        }
    }
    private func addListener(){
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
    }
}
