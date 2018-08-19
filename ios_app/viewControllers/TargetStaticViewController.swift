//
//  TargetStaticViewController.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/27.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit
import RealmSwift
class TargetStaticViewController: BasicTableViewController {

    var targetStatics:Results<BayesKey>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let localRealm = try! Realm()
        self.targetStatics = localRealm.objects(BayesKey.self).sorted(byKeyPath: "positive",ascending:false)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.targetStatics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let targetInfo = self.targetStatics[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TargetStaticCell", for: indexPath as IndexPath)as! TargetStaticCell
        cell.setCellInfo(targetInfo: targetInfo)
        return cell
    }

}
