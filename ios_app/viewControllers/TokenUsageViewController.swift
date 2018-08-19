//
//  TokenUsageViewController.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/27.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit
import RealmSwift

class TokenUsageViewController: BasicTableViewController {
    
    var tokenStatics:Results<Token>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let cacheRealm = Watcher.CacheRealm else{
            return
        }
        self.tokenStatics = cacheRealm.objects(Token.self)
        guard self.tokenStatics.count == 0 else{
            return
        }
        guard let conf = Watcher.GloabalRealmConf,
            let userInfo = Watcher.UserInfo else{
                return
        }
        let remoteRealm = try! Realm(configuration: conf)
        let filterSql = String(format:"userInfo.uid = '%@'",userInfo.uid)
        self.tokenStatics = remoteRealm.objects(Token.self).filter(filterSql).sorted(byKeyPath: "frequency",ascending:false)
            
        guard self.tokenStatics.count > 0 else {
            return
        }
        try! cacheRealm.write {
            for token in self.tokenStatics{
                cacheRealm.create(Token.self,value:token,update:true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tokenStatics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let token = self.tokenStatics[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TokenStaticCell", for: indexPath as IndexPath)as! TokenStaticCell
        cell.setCellInfo(token: token)
        return cell
    }
    
}
