//
//  AccountViewController.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/13.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit
import RealmSwift
class AccountViewController: BasicTableViewController{
    
    @IBOutlet weak var userInfoCell: UserInfoCell!
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInfoCell.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let userInfo = Watcher.UserInfo{
            userInfoCell.setUserInfo(userInfo: userInfo)
        }
    }
}
//delegate
extension AccountViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else{
            return true
        }
        
        let textLength = text.count + string.count - range.length
        return textLength <= Constants.nicknameMaxLength
    }
}
//private func
extension AccountViewController:AccountDelegate{
    func editNickname() {
        showNicknameEditor()
    }
    
    func showNicknameEditor(){
        guard self.actable(mesg:"昵称修改过于频繁，请稍后再试",base: 60) else{
            return
        }
        let nicknameAlter = UIAlertController(title: "修改你的昵称", message: "",preferredStyle:.alert)
        
        nicknameAlter.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "输入你的昵称"
            textField.delegate = self
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        let confirmBtn = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler:  {(action: UIAlertAction!)->Void in
            if let nickname = nicknameAlter.textFields!.first!.text{
                if nickname.count<2 {
                    self.showAlterView(message: "昵称太短")
                    return
                }
                guard let conf = Watcher.GloabalRealmConf else{
                    self.showAlterView(message: Constants.AlterMessage.error.rawValue)
                    return
                }
                let remoteRealm = try! Realm(configuration: conf)
                let querySql = String(format:"nickname = '%@'",nickname)
                let userInfo = remoteRealm.objects(UserInfo.self).filter(querySql)
                guard userInfo.count==0 else{
                    self.showAlterView(message: "该昵称已有人使用")
                    return
                }
                if let userInfo = Watcher.UserInfo{
                    let newUserInfo = UserInfo(value:userInfo)
                    newUserInfo.nickname = nickname
                    
                    let localRealm = try! Realm()

                    try! localRealm.write {
                        localRealm.create(UserInfo.self,value:newUserInfo,update:true)
                    }
                    try! remoteRealm.write {
                        remoteRealm.create(UserInfo.self,value:newUserInfo,update:true)
                    }
                    self.showAlterView(message: "修改昵称成功！")
                    self.userInfoCell.changeNickname(newNickname: nickname)
                }
            }
            
        })
        nicknameAlter.addAction(confirmBtn)
        nicknameAlter.addAction(cancelAction)
        self.present(nicknameAlter, animated: true, completion: nil)
    }
}
//actions
extension AccountViewController{
    @IBAction func backToAccountViewController(_ segue: UIStoryboardSegue) {
    }
}

