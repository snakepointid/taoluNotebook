//
//  AdviceViewController.swift
//  taolu
//
//  Created by 佘昌略  on 2018/5/3.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit
import RealmSwift
class AdviceViewController: BasicViewController {
    
    @IBOutlet weak var adviceSendView: AdviceSendView!
    override func viewDidLoad() {
        super.viewDidLoad()
        adviceSendView.delegate = self
    }
}
//delegate
extension AdviceViewController:AdviceDelegate{
    func uploadAdvice(advice: String, mailContact: String?, otherContact: String?) {
        guard self.actable(mesg: "操作太频繁，请稍后再试",base: 30) else{
            return
        }
        guard let remoteUserInfo = Watcher.RemoteUserInfo else{
            UserInfoUtil.loadUserInfo()
            showAlterView(message:Constants.AlterMessage.error.rawValue)
            return
        }
        
        guard let conf = Watcher.GloabalRealmConf else{
            showAlterView(message:Constants.AlterMessage.error.rawValue)
            return
        }
        
        let remoteRealm = try! Realm(configuration:conf)
        let newAdvice = Advice()
        newAdvice.advice = advice
        newAdvice.advicer = remoteUserInfo
        newAdvice.mailContact = mailContact
        newAdvice.otherContact = otherContact
        
        try! remoteRealm.write {
            remoteRealm.add(newAdvice)
        }
        showAlterView(message:"非常感谢你的意见，我们会积极改进")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {[weak self] in
            self?.pan()
        }
    }
}
