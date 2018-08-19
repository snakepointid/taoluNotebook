//
//  SearchBarView.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/30.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit

class SearchBarView: BasicView{
 
    var searchImg: UIImageView!
    var searchEditField: UITextField!
    var cancelBtn: UIButton!
    var placeholder:String!{
        didSet{
            searchEditField.placeholder = placeholder
        }
    }
    
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
////api
//extension SearchBarView{
//    func resignFirstResponder(){
//        searchEditField.resignFirstResponder()
//    }
//}
//basic
extension SearchBarView{
    private func config(){
        self.backgroundColor = UIColor.searchBarColor
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
     
        searchImg.backgroundColor=UIColor.clear
        searchEditField.backgroundColor=UIColor.clear
        
        searchEditField.font = UIFont(name:"ArialMT", size:15)
 
        searchEditField.textAlignment = NSTextAlignment.left
        searchEditField.returnKeyType = UIReturnKeyType.search
       
        searchImg.image = UIImage(named:"search.png")
        cancelBtn.setImage(UIImage(named:"cancel.png"), for: .normal)
    }
    private func setListener(){
        cancelBtn.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    private func initSubviews(){
        searchImg =  UIImageView()
        searchEditField = UITextField()
        cancelBtn = UIButton()
       
        
        self.addSubview(searchImg)
        self.addSubview(searchEditField)
        self.addSubview(cancelBtn)
    }
    private func layout(){
        searchImg.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
        }
        searchEditField.snp.makeConstraints { (make) in
            make.left.equalTo(searchImg.snp.right).offset(5)
            make.top.bottom.equalTo(searchImg)
            make.right.equalTo(cancelBtn.snp.left)
        }
        cancelBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(15)
            make.centerY.equalToSuperview()
        }
        self.snp.makeConstraints { (make) in
            make.top.equalTo(searchEditField).offset(-10)
            make.bottom.equalTo(searchEditField).offset(10)
        }
        
    }
}
//listener
extension SearchBarView{
    @objc private func tapped(){
        searchEditField.text = ""
    }
}

