//
//  ShareDelegate.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/15.
//  Copyright © 2018年 佘昌略. All rights reserved.
//


import Foundation
protocol ShareDelegate : NSObjectProtocol{
    func postFeedback(type:Constants.PostType)
}
