//
//  ChatViewController.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/29.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit
import RealmSwift

class ChatViewController: BasicTableViewController {
    var chats:Results<Chat>!
    override func viewDidLoad() {
        super.viewDidLoad()
        let localRealm = try! Realm()
        self.chats = localRealm.objects(Chat.self).sorted(byKeyPath: "chatTime",ascending:false)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chats.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = self.chats![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatPreviewCell", for: indexPath as IndexPath)as! ChatPreviewCell
        cell.setCellInfo(chatInfo: chat)
        cell.delegate = self
        return cell
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
        indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let report = UIContextualAction(style: .normal, title: "举报") {
            (action, view, completionHandler) in
            Watcher.reportCotentID = self.chats![indexPath.row].target
            Watcher.reportCotentType = "chat"
            self.performSegue(withIdentifier: "showUGCReport", sender: nil)
            completionHandler(true)
        }
        report.backgroundColor = UIColor.lightGray
 
        let delete = UIContextualAction(style: .destructive, title: "删除") {
            (action, view, completionHandler) in
            let chat = self.chats![indexPath.row]
            let localRealm = try! Realm()
            try! localRealm.write {
                localRealm.delete(chat)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        //返回所有的事件按钮
        let configuration = UISwipeActionsConfiguration(actions: [delete,report])
        
        return configuration
    }

}
//delegate
//mine delegate
extension ChatViewController:SegueDelegate{
    func changeSegue(){
        self.performSegue(withIdentifier: "showChatDetail", sender: nil)
    }
    @IBAction func backToChatViewController(_ segue: UIStoryboardSegue) {
        
    }
}
