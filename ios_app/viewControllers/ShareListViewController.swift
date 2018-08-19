//
//  ShareListViewController.swift
//  taolu
//
//  Created by 佘昌略  on 2018/3/25.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit
import RealmSwift
import SnapKit
class ShareListViewController: BasicViewController {
    @IBOutlet weak var tableView: UITableView!
    let localRealm:Realm!
    let refreshControl:UIRefreshControl!
    let shareSearchController: UISearchController
    var shares:Results<Share>?
    var shareNumber:Int!
    enum shareTypes{
        case others
        case follow
        case myself
    }
    var shareType:shareTypes
    var notificationToken: NotificationToken!
    required init(coder aDecoder: NSCoder) {
        
        self.localRealm = try! Realm(configuration: Constants.localRealmConf)
        self.shareSearchController = UISearchController(searchResultsController: nil)
        self.shareSearchController.searchBar.setValue("取消", forKey: "cancelButtonText")
        self.refreshControl = UIRefreshControl()
        self.shareType = shareTypes.others
        super.init(coder: aDecoder)!
    }
    private func reloadShareInfo(){
        switch shareType {
        case shareTypes.follow:
            showFollowShares(_:1);
            break;
        case shareTypes.myself:
            showSelfShares(_:1);
            break;
        case shareTypes.others:
            showPublicShares(_: 1);
            break;
        }
    }
    @objc  override func keyBoardWillShow(aNotification: Notification) {
    }
    //T
    @objc  override func keyBoardWillHide(aNotification: Notification) {
        if let searchText = self.shareSearchController.searchBar.text{
            self.shareSearchController.isActive = false
            self.shareSearchController.searchBar.text = searchText
            if  searchText.count>0 {
                self.navigationItem.title = String(format:"搜索'%@'的结果",searchText)
            }else{
                reloadShareInfo()
            }
        }
    }
    deinit {
        self.notificationToken?.invalidate()
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        addSoftKeyboardListener()
        //配置搜索控制器
        self.shareSearchController.hidesNavigationBarDuringPresentation = false
        self.shareSearchController.dimsBackgroundDuringPresentation = false
        self.shareSearchController.searchBar.searchBarStyle = .minimal
        self.shareSearchController.searchBar.sizeToFit()
        self.shareSearchController.searchBar.delegate = self
        self.shareSearchController.searchBar.placeholder = "搜索别人的分享"
        //set delegate and datasource
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableHeaderView = self.shareSearchController.searchBar
        //添加刷新
        self.refreshControl.addTarget(self, action: #selector(refreshData), for: UIControlEvents.valueChanged)
        self.refreshControl.attributedTitle = NSAttributedString(string: "松开后自动刷新")
        self.tableView.addSubview(refreshControl)
        self.navigationItem.title = "他人分享的套路"
        showPublicShares(_: 1)
        
        self.notificationToken = self.shares?.observe { (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self.tableView.reloadData()
                break
            case .update(_,let deletions, let insertions, let modifications):
                
                // Query results have changed, so apply them to the TableView
                self.tableView.beginUpdates()
                if self.shares?.count==self.shareNumber+1{
                    self.tableView.insertRows(at: insertions.map { _ in IndexPath(row:0, section: 0) }, with: .top)
                }
                if self.shares?.count==self.shareNumber-1{
                    self.tableView.deleteRows(at: deletions.map {row in IndexPath(row: self.shareNumber-row-1, section: 0) }, with: .top)
                }
                
                self.tableView.reloadRows(at: modifications.map { row in IndexPath(row: self.shareNumber-row-1, section: 0) }, with: .automatic)
                self.tableView.endUpdates()
                break
            case .error(let err):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(err)")
                break
            }
        }
    }
}
//mine delegate
extension ShareListViewController:SegueDelegate{
    func changeSegue(){
        self.performSegue(withIdentifier: "showShareDetail", sender: nil)
    }
}

extension ShareListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let share = self.shares else{
            self.shareNumber = 0
            return 0
        }
        if self.shareSearchController.isActive {
            self.shareNumber = min(20,share.count)
        }else{
            self.shareNumber = share.count
        }
        
        return self.shareNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let share = self.shares![self.shareNumber-indexPath.row-1]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineShareCell", for: indexPath as IndexPath)as! RoutineShareCell
        cell.share = share
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
        indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let report = UIContextualAction(style: .normal, title: "举报") {
            (action, view, completionHandler) in
            Watcher.reportCotentID = self.shares![self.shareNumber-indexPath.row-1].shareID
            Watcher.reportCotentType = "share"
            self.performSegue(withIdentifier: "showUGCReport", sender: nil)
            completionHandler(true)
        }
        report.backgroundColor = UIColor.lightGray
        
        if let searchText = self.shareSearchController.searchBar.text{
            guard searchText.count==0 else{
                let configuration = UISwipeActionsConfiguration(actions: [report])
                return configuration
            }
        }
        let delete = UIContextualAction(style: .destructive, title: "删除") {
            (action, view, completionHandler) in
           
            let share = self.shares![self.shareNumber-indexPath.row-1]
            
            try! self.localRealm.write {
                self.localRealm.delete(share)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        //返回所有的事件按钮
        let configuration = UISwipeActionsConfiguration(actions: [delete,report])
        
        return configuration
    }
    @IBAction func backToShareListViewController(_ segue: UIStoryboardSegue) {
        
    }
    
}
//Actions
extension ShareListViewController{
    @IBAction func showPublicShares(_ sender: Any) {
        self.shareSearchController.isActive = false
        self.navigationItem.title = "他人分享的套路"
        shareType = shareTypes.others
        self.shares = self.localRealm.objects(Share.self).filter("youFollow = false And youShare = false")
        tableView.reloadData()
        
    }
    @IBAction func showFollowShares(_ sender: Any) {
        self.shareSearchController.isActive = false
        shareType = shareTypes.follow
        self.navigationItem.title = "收藏的套路"
        self.shares = self.localRealm.objects(Share.self).filter("youFollow = true")
        tableView.reloadData()
    }
    @IBAction func showSelfShares(_ sender: Any) {
        self.shareSearchController.isActive = false
        shareType = shareTypes.myself
        self.navigationItem.title = "自己分享的套路"
        self.shares = self.localRealm.objects(Share.self).filter("youShare = true")
        tableView.reloadData()
    }
    
    @objc private func refreshData() {
        guard self.actable(mesg:nil) else{
            self.refreshControl.attributedTitle = NSAttributedString(string: "推荐引擎暂时没有更多新数据")
            self.refreshControl.endRefreshing()
            return
        }
        var saveNum:Int=0
        if let conf = Watcher.GloabalRealmConf{
            let remoteRealm = try! Realm(configuration: conf)
            var recShares = remoteRealm.objects(Share.self)
            let allShareNum = recShares.count

            if allShareNum <= Constants.shareRandomThreshold {
                recShares = recShares.sorted(byKeyPath: "likeNum",ascending:false)
            }else{
                let randomSeedRange = min(10000,Int(allShareNum/Constants.shareRandomThreshold))
                let randomSeed =  String(arc4random_uniform(UInt32(randomSeedRange)))
                let filtersql = String(format:"randomSeed LIKE '*%@'",randomSeed)
                recShares = recShares.filter(filtersql).sorted(byKeyPath: "likeNum",ascending:false)
            }
            
            for newShare in recShares{
                guard saveNum<5 else{
                    break
                }
                let filterSql = String(format:"shareID = '%@'",newShare.shareID)
                let oldShare = self.localRealm.objects(Share.self).filter(filterSql)
                guard oldShare.count==0 else{
                    continue
                }
                try!self.localRealm.write {
                    self.localRealm.create(Share.self,value:newShare,update:true)
                }
                saveNum+=1
            }}
        else{
            self.refreshControl.attributedTitle = NSAttributedString(string: "网络故障")
        }
        if saveNum>0{
            self.refreshControl.attributedTitle = NSAttributedString(string:  "推荐系统更新"+String(saveNum)+"条数据")
        }else{
            self.refreshControl.attributedTitle = NSAttributedString(string:  "暂时没有最新分享")
        }
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
}

extension ShareListViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.shares = nil
        self.tableView.reloadData()
        return true
    }
    //点击搜索按钮
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text!
        guard searchText.count>1 else{
            return
        }
        guard self.actable(mesg:"搜索过于频繁，请稍后再试") else{
            return
        }
        if let conf = Watcher.GloabalRealmConf{
            let remoteRealm = try! Realm(configuration: conf)
            let querySql = String(format: "target LIKE '*%@*'", searchText)
            self.shares = remoteRealm.objects(Share.self).filter(querySql).sorted(byKeyPath: "likeNum",ascending:false)
        }
        guard self.shares!.count>0 else{
            showAlterView(message: "没有搜索到相关分享")
            return
        }
        self.tableView.reloadData()
    }
    
}
