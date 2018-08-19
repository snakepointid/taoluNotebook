//
//  ButtonPressDelegate.swift
//  taolu
//
//  Created by 佘昌略  on 2018/3/22.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import Foundation
protocol OptionViewDelegate : NSObjectProtocol{
    func chooseOption(choosed:TAPF)
    func switchOption()
    func editTarget()
    func editAgent()
    func enterOption(enterToken:String)
    func listOption(enterToken:String)
}
