//
//  ClickableView.swift
//  taolu
//
//  Created by 佘昌略  on 2018/3/25.
//  Copyright © 2018年 佘昌略. All rights reserved.
//
import UIKit
class ClickableView: BasicView {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init()
    {
        super.init()
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickAction))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
    }
    @objc func clickAction(){
        
    }
}
