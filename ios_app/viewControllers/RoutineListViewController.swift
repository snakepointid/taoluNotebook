//
//  RoutineListViewController.swift
//  taolu
//
//  Created by 佘昌略  on 2018/3/16.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift
 
class RoutineListViewController: BasicTableViewController {
    let routineSearchController: UISearchController
    let localRealm:Realm!
    var routineNumber:Int!
    var routines:Results<Routine>!
    var reverseFlag:Bool!
    var showDetail:Bool!
    var notificationToken: NotificationToken!
    var searchText:String!=""
    required init(coder aDecoder: NSCoder) {
        self.routineSearchController = UISearchController(searchResultsController: nil)
        routineSearchController.searchBar.setValue("取消", forKey: "cancelButtonText")
        self.localRealm = try! Realm(configuration: Constants.localRealmConf)
        self.reverseFlag = false
        self.showDetail = false
        self.routines =  self.localRealm.objects(Routine.self).sorted(byKeyPath: "createTime",ascending:reverseFlag)
        
        super.init(coder: aDecoder)!
    }
   
    deinit {
        self.notificationToken?.invalidate()
    }
//T
    @objc  override func keyBoardWillShow(aNotification: Notification) {
    }
    //T
    @objc  override func keyBoardWillHide(aNotification: Notification) {
        if let searchText = self.routineSearchController.searchBar.text{
            self.routineSearchController.isActive = false
            self.routineSearchController.searchBar.text = searchText
            if  searchText.count>0 {
                self.navigationItem.title = String(format:"搜索'%@'的结果",searchText)
            }else{
                 self.navigationItem.title = ""
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard self.routines.count == 0 else{
            return
        }
        self.routines = localRealm.objects(Routine.self).sorted(byKeyPath: "createTime",ascending:reverseFlag)
        tableView.reloadData()
        self.routineSearchController.isActive = false
        self.navigationItem.title = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addSoftKeyboardListener()
         //配置搜索控制
        self.routineSearchController.hidesNavigationBarDuringPresentation = false
        self.routineSearchController.dimsBackgroundDuringPresentation = false
        self.routineSearchController.searchBar.searchBarStyle = .minimal
        self.routineSearchController.searchBar.sizeToFit()
        self.routineSearchController.searchResultsUpdater = self
        self.routineSearchController.searchBar.delegate = self
        self.routineSearchController.searchBar.placeholder = "搜索关键词，用','隔开"
 
        //set delegate and datasource
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableHeaderView = self.routineSearchController.searchBar

        //get data
        //Set results notification block
        self.notificationToken = routines.observe { (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self.tableView.reloadData()
                break
            case .update(_,_, let insertions, let modifications):
                // Query results have changed, so apply them to the TableView
                self.tableView.beginUpdates()
                if self.routines.count==self.routineNumber+1{
                    self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .top)
                }
                self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
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
//Actions
extension RoutineListViewController{
    @IBAction func showRoutineDetail(_ sender: Any) {
        showDetail = showDetail ?false:true
        tableView.reloadData()
    }
    @IBAction func sortRoutineList(_ sender: Any) {
        reverseFlag = reverseFlag ? false:true
        self.routines = self.routines.sorted(byKeyPath: "createTime",ascending:reverseFlag)
        tableView.reloadData()
    }
    
}
//mine delegate
extension RoutineListViewController:SegueDelegate{
    func changeSegue(){
        self.performSegue(withIdentifier: "showRoutineDetail", sender: nil)
    }
    
}
//table view behaviror
extension RoutineListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        routineNumber = self.routines.count
        return routineNumber
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let routine = self.routines[indexPath.row]
        if showDetail{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineListCell", for: indexPath as IndexPath)as! RoutineListCell
            cell.routine = routine
            cell.delegate = self
            return cell
        }else{
           let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineBriefCell", for: indexPath as IndexPath)as! RoutineBriefCell
            cell.routine = routine
            cell.delegate = self
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
        indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //        //创建“删除”事件按钮
        let delete = UIContextualAction(style: .destructive, title: "删除") {
            (action, view, completionHandler) in
            let routine = self.routines[indexPath.row]
            
            try! self.localRealm.write {
                if let complement = routine.complement{
                    self.localRealm.delete(complement)
                }
                let tapf = routine.policyAndFeedbacks
                self.localRealm.delete(tapf)
                self.localRealm.delete(routine)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        //返回所有的事件按钮
        let configuration = UISwipeActionsConfiguration(actions: [delete])
        
        return configuration
    }
    @IBAction func backToRoutineListViewController(_ segue: UIStoryboardSegue) {
    }
    
}

extension RoutineListViewController: UISearchResultsUpdating,UISearchBarDelegate
{
    //实时进行搜索
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.isActive else{
            return
        }
        guard var searchText = searchController.searchBar.text else{
            return
        }
        searchText = searchText.replacingOccurrences(of: "，", with: ",")
        searchText = searchText.replacingOccurrences(of: "'", with: "")
        self.routines = localRealm.objects(Routine.self).sorted(byKeyPath: "createTime",ascending:reverseFlag)
        guard searchText.count>0 else{
            tableView.reloadData()
            return
        }
        for text in searchText.components(separatedBy:  ","){
            guard text.count>0 else{continue}
            let queryCondition = "target LIKE '*"+text+"*' or agent LIKE '*"+text+"*' or ANY policyAndFeedbacks.token LIKE '*"+text+"*'"
            self.routines = self.routines.filter(queryCondition)
        }
        tableView.reloadData()
    }
    //点击取消按钮
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.routines = localRealm.objects(Routine.self).sorted(byKeyPath: "createTime",ascending:reverseFlag)
        tableView.reloadData()
    }
}
