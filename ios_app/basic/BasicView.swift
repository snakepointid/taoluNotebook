//
//  BasicView.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/28.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit

class BasicView: UIView {
    var className:String!
    
    required init?(coder aDecoder: NSCoder) {
        className = NSStringFromClass(type(of:self)).substring(from: 6)
        super.init(coder: aDecoder)
    }
    
    init(){
        className = NSStringFromClass(type(of:self)).substring(from: 6)
        super.init(frame:CGRect(x:0, y:0, width:100, height:30))
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        //print(className+"........view awakeFromNib")
    }
    deinit {
        //print(className+"........view deinit")
    }
}
