//
//  BasicViewController.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/19.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift

class BasicViewController: UIViewController {
    var actQuato:Int
    var lastActTime:Date!
    var updatableConstraint: Constraint!
    var className:String!
    required init?(coder aDecoder: NSCoder) {
        actQuato = 1
        lastActTime =  Date()
        className = NSStringFromClass(type(of:self)).substring(from: 6)
        super.init(coder: aDecoder)
    }
    
    deinit {
//        print(className+"........view controller deinit")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print(className+"........ viewWillAppear")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        print(className+"........ viewWillDisappear")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(className+"........ viewDidLoad")
        let panGesture = UIScreenEdgePanGestureRecognizer(target:self,action:#selector(pan))
        panGesture.edges = UIRectEdge.left
        self.view.addGestureRecognizer(panGesture)
    }
    
    @objc func pan(){
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    //监听键盘的事件
    @objc  func keyBoardWillShow(aNotification: Notification) {
        
        let userInfo  = aNotification.userInfo! as NSDictionary
        let keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = keyBoardBounds.size.height
        self.updatableConstraint.update(offset: -deltaY)
    }
    //T
    @objc  func keyBoardWillHide(aNotification: Notification) {
        self.updatableConstraint.update(offset: 0)
    }
}
//
extension BasicViewController{
    func keyIsNotUpdated(key:String)->Bool{
        if Watcher.updatedKeys.contains(key) {
            return false
        }else{
            Watcher.updatedKeys.insert(key)
            return true
        }
    }
    func showAlterView(message:String){
        let messageAlter = UIAlertController(title: message, message: nil,preferredStyle:.alert)
        self.present(messageAlter, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            messageAlter.dismiss(animated: true, completion: nil)
        }
    }
    
    func actable(mesg:String?="你操作过于频繁，请稍后再试",base:Float=10.0)->Bool{
        let timeInterval = TimeUtils.getTimeInterval(eventTime:lastActTime)
        let addQuato =  Int(log(_:Float(max(1,timeInterval)))/log(_:base))
        actQuato += addQuato
        if actQuato>0 {
            actQuato -= 1
            lastActTime = Date()
            return true
        }else{
            if let mesg = mesg{
                showAlterView(message: mesg)
            }
            return false
        }
    }
    func showNicknameEditor(){
        let nicknameAlter = UIAlertController(title: "你必须创建一个昵称", message: "",preferredStyle:.alert)
        
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
                    self.showAlterView(message: "创建昵称成功！")
                }
                
            }
        })
        nicknameAlter.addAction(confirmBtn)
        nicknameAlter.addAction(cancelAction)
        self.present(nicknameAlter, animated: true, completion: nil)
    }
    func addSoftKeyboardListener(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillShow(aNotification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillHide(aNotification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}
//delegates
extension BasicViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else{
            return true
        }
        
        let textLength = text.count + string.count - range.length
        return textLength <= Constants.nicknameMaxLength
    }
}
