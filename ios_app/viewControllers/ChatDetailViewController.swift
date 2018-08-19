//
//  ChatDetailViewController.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/29.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit
import RealmSwift

class ChatDetailViewController: BasicViewController {
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var chatEditView: EditView!
    var newChatNumLabel:UIButton!
    var selfChatFlag:Bool = false
    var chats:Results<Chat>?
    var chatNum:Int=0{
        didSet{
            updateUnreadNum()
        }
    }
    var maxIndex:Int=0{
        didSet{
            updateUnreadNum()
        }
    }
    var notificationToken: NotificationToken!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        config()
        setListener()
        initData()
        addNotification()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.notificationToken?.invalidate()
    }
    
    deinit {
        updateChatInfo()
        Watcher.ChatTarget = nil
    }
    private func updateChatInfo(){
        guard let chatTarget = Watcher.ChatTarget else{
            return
        }
        
        let localRealm = try! Realm()
        let filterSql = String(format: "target = '%@'", chatTarget)
        let chatInfo = localRealm.objects(Chat.self).filter(filterSql)
        
        guard chatInfo.count>0 else{
            return
        }
        
        guard let lastChat = self.chats?.last else {
            return
        }
        
        try! localRealm.write {
            chatInfo.first!.chatTime = lastChat.chatTime
            chatInfo.first!.text = lastChat.text
            chatInfo.first!.nickname = lastChat.nickname
        }
        guard let chats = self.chats,
            let conf = Watcher.GloabalRealmConf else {
                return
        }
        let remoteRealm = try! Realm(configuration: conf)
        var deleteNum = max(0,chats.count-Constants.chatRetainNum)
        guard deleteNum>0 else{
            return
        }
        try! remoteRealm.write {
            for chat in chats{
                remoteRealm.delete(chat)
                deleteNum -= 1
                if deleteNum < 1 {
                    break
                }
            }
        }
    }
}
//private funcs
extension ChatDetailViewController{
    private func updateUnreadNum(){
        let unreadNum = chatNum - maxIndex - 1
        if unreadNum > 0 {
            self.newChatNumLabel.isHidden = false
            self.newChatNumLabel.setTitle(String(unreadNum), for: .normal)
        }else{
            self.newChatNumLabel.isHidden = true
        }
    }
    private func layout(){
        newChatNumLabel = UIButton()
        self.view.addSubview(newChatNumLabel)
        self.chatEditView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            updatableConstraint = make.bottom.equalToSuperview().constraint
        }
        self.newChatNumLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(chatEditView.snp.top)
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(30)
        }
    }
    private func setListener(){
        addSoftKeyboardListener()
        chatEditView.delegate = self
        chatTableView.delegate = self
        chatTableView.dataSource = self
    }
    private func config(){
        self.chatTableView.backgroundColor = UIColor.textEdit
        chatTableView.contentInset = UIEdgeInsetsMake(0, 0.0, 100, 0.0)
        self.newChatNumLabel.titleLabel?.textColor = UIColor.white
        self.newChatNumLabel.titleLabel?.textAlignment = .center
        self.newChatNumLabel.setBackgroundImage(UIImage(named:"newChat.png"), for: .normal)
        self.newChatNumLabel.isHidden = true
        
        self.newChatNumLabel.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    @objc func tapped(){
        self.scrollToBottom()
    }
    private func scrollToBottom(){
        guard self.chatNum > 0 else{
            return
        }
        self.chatTableView.scrollToRow(at: IndexPath(row: self.chatNum - 1, section: 0), at: .bottom, animated: true)
        self.selfChatFlag = false
    }
    private func initData(){
        guard let conf = Watcher.GloabalRealmConf,
            let chatTarget = Watcher.ChatTarget else{
                return
        }
        self.navigationItem.title = chatTarget
        let remoteRealm = try! Realm(configuration: conf)
        let filterSql = String(format: "target = '%@'", chatTarget)
        self.chats = remoteRealm.objects(Chat.self).filter(filterSql)
    }
    private func addNotification(){
        self.notificationToken = self.chats?.observe { (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self.chatTableView.reloadData();
                self.scrollToBottom();
                break;
            case .update(_,let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the TableView
                self.chatTableView.beginUpdates()
                if self.chats!.count != self.chatNum{
                    self.chatTableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .top)
                    self.chatNum = self.chats!.count
                }
                self.chatTableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .top)
                self.chatTableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.chatTableView.endUpdates();
                
                if self.chatNum == self.maxIndex + 1 || self.selfChatFlag {
                    self.scrollToBottom()
                }
                break;
            case .error(let err):
                fatalError("\(err)")
                break;
            }
        }
    }
}
extension ChatDetailViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let chat = self.chats{
            self.chatNum = chat.count
        }
        
        return self.chatNum
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > self.maxIndex {
            self.maxIndex = indexPath.row
        }
        let chat = self.chats![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatDetailCell", for: indexPath as IndexPath)as! ChatDetailCell
        cell.setCellInfo(chatInfo: chat)
        return cell
    }
    
}
//TextEditDelegate
extension ChatDetailViewController:BtnPressDelegate{
    
    func ctrBtnTap(info:String){
      
        guard let remoteUserInfo = Watcher.RemoteUserInfo else{
            UserInfoUtil.loadUserInfo()
            showAlterView(message:Constants.AlterMessage.error.rawValue)
            return
        }
        guard remoteUserInfo.verifiedFlag else{
            showAlterView(message:"由于某些原因，你被禁止使用该功能")
            return
        }
        guard let nickname = remoteUserInfo.nickname  else{
            self.showNicknameEditor()
            return
        }
        guard self.actable(mesg:"发言过于频繁，请稍后再试") else{
            return
        }
        if let conf = Watcher.GloabalRealmConf,
            let chatTarget = Watcher.ChatTarget{
            let remoteRealm = try! Realm(configuration:conf)
            let chatInfo = Chat()
            chatInfo.nickname = nickname
            chatInfo.target = chatTarget
            chatInfo.text = info
            
            try! remoteRealm.write {
                remoteRealm.create(Chat.self,value:chatInfo)
            }
            chatEditView.editField.resignFirstResponder()
            selfChatFlag = true
        }else{
            chatEditView.editField.resignFirstResponder()
            showAlterView(message: Constants.AlterMessage.error.rawValue)
        }
    }
}
