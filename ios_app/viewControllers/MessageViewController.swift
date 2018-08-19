//
//  MessageViewController.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/27.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit
import RealmSwift

class MessageViewController: BasicTableViewController {
    var messages:Results<Message>!
    var messageNum:Int=0
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let cacheRealm = Watcher.CacheRealm else{
            return
        }
        self.messages = cacheRealm.objects(Message.self)
        guard self.messages.count == 0 else{
            return
        }
        guard let conf = Watcher.GloabalRealmConf else{
            return
        }
        let remoteRealm = try! Realm(configuration: conf)
        self.messages = remoteRealm.objects(Message.self)
        try! cacheRealm.write {
            for message in self.messages{
                cacheRealm.create(Message.self,value:message)
            }
        }
    }
 
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.messageNum =  self.messages.count
        
        return self.messageNum  
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.messages![self.messageNum-1-indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath as IndexPath)as! MessageCell
        cell.setCellInfo(messageInfo: message)
        return cell
    }
    
}
