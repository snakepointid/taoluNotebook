//
//  TextEditDelegate.swift
//  taolu
//
//  Created by 佘昌略  on 2018/3/21.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import Foundation

protocol BtnPressDelegate : NSObjectProtocol{
 
    func ctrBtnTap(info:String)
}
protocol CommentDelegate : NSObjectProtocol{
     
    func reportBtnPress()
}
