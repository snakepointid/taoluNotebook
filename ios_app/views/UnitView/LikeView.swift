//
//  likeView.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/15.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit
import SnapKit
class LikeView: UIView{
    weak var delegate:ShareDelegate!
    @IBOutlet weak var likeImg: UIButton!
    @IBOutlet weak var likeNum: UILabel!
    var postType:Constants.PostType?
    var text:String?{
        didSet{
            likeNum.text = text
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init()
    {
        super.init(frame:CGRect(x:0, y:0, width:100, height:20))
        config()
        layout()
    }
    private func config(){
        likeNum.adjustsFontSizeToFitWidth = true
        likeNum.textAlignment = NSTextAlignment.left
        likeNum.font = UIFont(name:"Zapfino", size:10)
    }
    private func setListener(){
        likeImg.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    @objc func tapped(){
        if delegate != nil {
            if let type = self.postType{
                delegate!.postFeedback(type:type)
            }
        }
    }
    private func layout(){
        likeImg.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(20)
        }
        likeNum.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(50)
        }
        
    }
    
}
