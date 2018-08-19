//
//  AccountDelegate.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/27.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import Foundation
protocol AccountDelegate : NSObjectProtocol{
    
    func editNickname()
}

protocol AdviceDelegate : NSObjectProtocol{
    
    func uploadAdvice(advice:String,mailContact:String?,otherContact:String?)
}
