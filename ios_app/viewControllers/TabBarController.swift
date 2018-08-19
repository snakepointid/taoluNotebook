//
//  TabBarController.swift
//  taolu
//
//  Created by 佘昌略  on 2018/3/20.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit
import RealmSwift
class TabBarController: UITabBarController {
    var lastUpdateTime:String!
    required init(coder aDecoder: NSCoder) {
        lastUpdateTime = TimeUtils.getRightNowTime()
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAddBtn()
        UserInfoUtil.getUserInfo()
        deleteSomething()
        getCacheRealm()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(_:animated)
        getGloabalRealmConf()
        uploadRoutine()
        updateEverything()
    }
}

extension TabBarController{
    private func updateEverything(){
        let updateTime:String = TimeUtils.getRightNowTime()
        guard updateTime != lastUpdateTime else{
            return
        }
        Watcher.CacheRealm = nil
        getCacheRealm()
        UserInfoUtil.loadUserInfo()
        Watcher.updatedKeys = Set<String>()
        lastUpdateTime = updateTime
    }
    private func initAddBtn(){
        let addBtn = UIButton()
        self.tabBar.addSubview(addBtn)
        addBtn.layTopCenter(margin:0,width:50,height:50)
        addBtn.setBackgroundImage(UIImage(named: "add"), for: .normal)
        addBtn.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    private func deleteSomething(){
        let localRealm = try! Realm()
        let shares = localRealm.objects(Share.self).filter("youFollow = false And youShare = false")
        var deleteNum = max(0,shares.count-Constants.shareRetainNum)
        if deleteNum>0{
            try! localRealm.write {
                for share in shares{
                    localRealm.delete(share)
                    deleteNum -= 1
                    if deleteNum < 0 {
                        break
                    }
                }
            }
        }
    }
    private func getCacheRealm(){
        if let _ = Watcher.CacheRealm{
            return
        }
        Watcher.CacheRealm = try! Realm(configuration: Constants.cacheRealmConf)
    }
    private func getGloabalRealmConf(){
        if let _ = Watcher.GloabalRealmConf{
            return
        }
        
        if SyncUser.all.count == 1{
            Watcher.GloabalRealmConf = Realm.Configuration(syncConfiguration: SyncConfiguration(user: SyncUser.current!, realmURL: Constants.REALM_URL))
            UserInfoUtil.loadUserInfo()
        }else{
            loginUser()
        }
        
    }
    
    private func loginUser(){
        let creds = SyncCredentials.usernamePassword(username: Constants.globalUserIdentifier, password: Constants.globalUserPasswd,register: false)
        SyncUser.logIn(with: creds, server: Constants.AUTH_URL, onCompletion: {  (user, err) in
            if user != nil{
                Watcher.GloabalRealmConf = Realm.Configuration(syncConfiguration: SyncConfiguration(user: user!, realmURL: Constants.REALM_URL))
                UserInfoUtil.loadUserInfo()
            }
        })
    }
    
    private func uploadRoutine(){
        if let conf = Watcher.GloabalRealmConf,
            let userInfo = Watcher.UserInfo{
            let localRealm = try!Realm()
            let routines = localRealm.objects(Routine.self).filter("uploadFlag = false")
            guard routines.count>0 else{
                return
            }
            let remoteRealm = try! Realm(configuration: conf)
            try! remoteRealm.write {
                for routine in routines{
                    let userRoutine = UserRoutines()
                    userRoutine.uid = userInfo.uid
                    userRoutine.routine = routine
                    remoteRealm.create(UserRoutines.self,value:userRoutine)
                }
            }
            try! localRealm.write {
                for routine in routines{
                    routine.uploadFlag = true
                }
            }
        }
    }
    
    @objc func tapped(){
        self.performSegue(withIdentifier: "addNewRoutine", sender:nil)
    }
}
