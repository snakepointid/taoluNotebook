//
//  AppInfoView.swift
//  taolu
//
//  Created by 佘昌略  on 2018/5/3.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit

class AppInfoView: BasicView{
    var edition: UILabel!
    var copyRight: UILabel!
    var appImg:UIImageView!
    var appTitle:UILabel!
    var appDescription:UILabel!
    
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
extension AppInfoView{
    private func config(){
        appImg.layer.masksToBounds = true
        appImg.layer.cornerRadius = 10
        
        appTitle.font = UIFont(name:"ArialMT", size:20)
        appTitle.textAlignment = .center
        
        
        edition.font = UIFont(name:"ArialMT", size:10)
        edition.textColor = UIColor.gray
        edition.alpha = 0.9
        edition.textAlignment = .center
        
        appDescription.font = UIFont(name:"ArialMT", size:15)
        appDescription.textColor = UIColor.darkGray
        appDescription.alpha = 0.9
        appDescription.numberOfLines=0
        appDescription.textAlignment = NSTextAlignment.left
        appDescription.lineBreakMode = NSLineBreakMode.byCharWrapping
        
        copyRight.font = UIFont(name:"ArialMT", size:10)
        copyRight.textColor = UIColor.gray
        copyRight.alpha = 0.9
        copyRight.textAlignment = .center
        
    }
    private func setData(){
        appImg.image = UIImage(named: "appImg.png")
        appTitle.text = "套路笔记"
        edition.text = "当前版本号：1.0.1"
        appDescription.text = "套路笔记是一款以机器学习和人工智能作为驱动引擎的笔记应用。目的是方便用户进行快速记录，并且通过算法挖掘出帮助用户实现目标的优势策略。同时，利用算法把具有相同目标需求以及类似特征的人群聚合到一起，方便他们进行知识分享"
        copyRight.text = "佘昌略 版权所有"
    }
    private func initSubviews(){
        edition = UILabel()
        copyRight = UILabel()
        appImg = UIImageView()
        appTitle = UILabel()
        appDescription = UILabel()
        self.addSubview(edition)
        self.addSubview(copyRight)
        self.addSubview(appImg)
        self.addSubview(appTitle)
        self.addSubview(appDescription)
    }
    private func layout(){
        appImg.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
        }
        appTitle.snp.makeConstraints { (make) in
            make.top.equalTo(appImg.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
        }
        edition.snp.makeConstraints { (make) in
            make.top.equalTo(appTitle.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(15)
        }
        appDescription.snp.makeConstraints { (make) in
            make.top.equalTo(edition.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        copyRight.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-40)
            make.left.right.equalToSuperview()
            make.height.equalTo(15)
        }
        
    }
}
