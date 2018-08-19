//
//  OptionBtn.swift
//  taolu
//
//  Created by 佘昌略  on 2018/3/22.
//  Copyright © 2018年 佘昌略. All rights reserved.
//


import UIKit

class OptionBtn: ClickableView {
    weak var delegate:OptionViewDelegate!
    var optionLabel:UILabel!
    var optionImage:UIImageView!
    var imgSize:CGFloat!
    var imgMargin:CGFloat!
    var option:TAPF!
    
    init(option:TAPF)
    {
        super.init()
        self.option = option
        self.initSubviews()
        self.config()
        self.layout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func clickAction() {
        if delegate != nil {
            delegate!.chooseOption(choosed:option)
        }
    }
}
extension OptionBtn{
    private func initSubviews(){
        optionLabel = UILabel()
        optionImage = UIImageView()
        self.addSubview(optionLabel)
        self.addSubview(optionImage)
    }
    private func layout(){
        optionImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(imgMargin)
            make.width.height.equalTo(imgSize)
        }
        optionLabel.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.left.equalTo(optionImage.snp.right).offset(imgMargin)
        }
    }
    private func config(){
        
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0.2
        
        optionLabel.textColor = UIColor.black
        optionLabel.adjustsFontSizeToFitWidth = true
        optionLabel.text = option.token
        optionLabel.textAlignment = NSTextAlignment.center
        imgSize =  0.0
        imgMargin = 0.0
        switch self.option.symbal{
        case Constants.policySymbal:
            switch option.type{
            case Constants.goodType:
                optionImage.image = UIImage(named:"policy_good.png");
                optionLabel.textAlignment = NSTextAlignment.left;
                imgSize = 15.0;
                imgMargin = 5.0;
                break;
            case Constants.badType:
                optionImage.image = UIImage(named:"policy_bad.png");
                optionLabel.textAlignment = NSTextAlignment.left;
                imgSize = 15.0;
                imgMargin = 5.0;
                break;
            default:
                break;
            }
            break;
        case Constants.feedbackSymbal:
            self.backgroundColor = UIColor.feedbackLabel;
            switch option.type{
            case Constants.goodType:
                optionImage.image = UIImage(named:"feedback_good.png");
                optionLabel.textAlignment = NSTextAlignment.left;
                imgSize = 15.0;
                imgMargin = 5.0;
                break;
            case Constants.badType:
                optionImage.image = UIImage(named:"feedback_bad.png");
                optionLabel.textAlignment = NSTextAlignment.left;
                imgSize = 15.0;
                imgMargin = 5.0;
                break;
            default:
                break;
            }
            break;
        default:
            optionLabel.textColor = UIColor.feedbackLabel;
            break;
        }
    }
}
