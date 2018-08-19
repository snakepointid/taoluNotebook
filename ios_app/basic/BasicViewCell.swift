//
//  BasicViewCell.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/30.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit

class BasicViewCell: UITableViewCell {
    var className:String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        className = NSStringFromClass(type(of:self)).substring(from: 6)
//        print(className+"........table cell awakeFromNib")
        self.selectionStyle = .none
    }
    deinit {
//        print(className+"........table cell deinit")
    }
}
