//
//  BasicTableViewController.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/28.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit

class BasicTableViewController: UITableViewController {
    var actQuato:Int
    var lastActTime:Date!
    var className:String!
    required init?(coder aDecoder: NSCoder) {
        actQuato = 1
        lastActTime =  Date()
        className = NSStringFromClass(type(of:self)).substring(from: 6)
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(className+"........ viewDidLoad")
        let panGesture = UIScreenEdgePanGestureRecognizer(target:self,action:#selector(pan(_:)))
        panGesture.edges = UIRectEdge.left
        self.view.addGestureRecognizer(panGesture)
    }
    
    @objc  func pan(_ recognizer:UIScreenEdgePanGestureRecognizer){
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print(className+"........ viewWillAppear")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        print(className+"........ viewWillDisappear")
    }
    deinit {
//        print(className+"........table view deinit")
    }
    //监听键盘的事件
    @objc  func keyBoardWillShow(aNotification: Notification) {
       
    }
    //T
    @objc  func keyBoardWillHide(aNotification: Notification) {
        
    }

}
//api
extension BasicTableViewController{
    func addSoftKeyboardListener(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillShow(aNotification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillHide(aNotification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
}
