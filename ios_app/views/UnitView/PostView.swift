//
//  postView.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/15.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit
import SnapKit
class PostView: UIView{
    weak var delegate:ShareDelegate!
    var postImg: UIImageView!
    var postNum: UILabel!
    var baseName:String!{
        didSet{
            clicked=false
        }
    }
    var clicked:Bool!{
        didSet{
            if clicked{
                num += 1
                imgName = baseName+"_click.png"
            }else{
                imgName = baseName+".png"
                if num>0{
                    num -= 1
                }
            }
        }
    }
    var postType:Constants.PostType?
    var num:Int=0{
        didSet{
            postNum.text = String(num)
        }
    }
    var imgName:String!{
        didSet{
            postImg.image = UIImage(named:imgName)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init()
    {
        super.init(frame:CGRect(x:0, y:0, width:100, height:20))
        initSubviews()
        config()
        layout()
        addListener()
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
extension PostView{
 
    @objc func tapped(){
        if delegate != nil {
            if let type = self.postType{
                delegate!.postFeedback(type:type)
            }
        }
    }
}
//basic
extension PostView{
    private func config(){
        postNum.adjustsFontSizeToFitWidth = true
        postNum.textAlignment = NSTextAlignment.left
        postNum.font = UIFont(name:"ArialMT", size:10)
        postNum.textColor = UIColor.darkGray
        postNum.alpha = 0.5
    }
    private func initSubviews(){
        postNum = UILabel()
        postImg = UIImageView()
        self.addSubview(postNum)
        self.addSubview(postImg)
    }
    private func layout(){
        postImg.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(postImg.snp.height)
        }
        postNum.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.left.equalTo(postImg.snp.right)
        }
    }
    private func addListener(){
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
    }
}

