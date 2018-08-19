//
//  RoutineDetailsViewController.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/18.
//  Copyright © 2018年 佘昌略. All rights reserved.
//
import UIKit
import SnapKit
import RealmSwift
class RoutineDetailViewController: BasicViewController {
    let localRealm:Realm!
    var processNum:Int!
    @IBOutlet weak var routineDetailScrollView:RoutineDetailScrollView!
    @IBOutlet weak var processTitleView:ProcessTitleView!
    
    required init(coder aDecoder: NSCoder) {
        self.localRealm = try! Realm()
        processNum = 0
        super.init(coder: aDecoder)!
        
    }
    private func layout(){
        let topMargin:CGFloat = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height+10
        
        self.routineDetailScrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(topMargin)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func initSubviews(){
        if let routine = Watcher.RoutineDetail{
            if let process = routine.complement?.process{
                processNum = process.count
            }
            self.routineDetailScrollView.setRoutineInfo(routine:routine)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        initSubviews()
    }
    
    deinit {
        saveProcessInfo()
        Watcher.RoutineDetail = nil
    }
    private func saveProcessInfo(){
        guard let routine = Watcher.RoutineDetail else{
            return
        }
        let process = processTitleView.getProcess()
        var title = processTitleView.getTitle()
        
        guard process.count>0 || processNum>0 else{
            if let _ = routine.complement{
                try! self.localRealm.write {
                    routine.complement = nil
                }
            }
            return
        }
        
        if title==nil {
            title = routine.target.substring(from: 1)+"的套路经历"
        }
        if let complement = routine.complement{
            try! self.localRealm.write {
                complement.process = process
                complement.title = title
            }
        }else{
            let newComplement = Complement()
            newComplement.process = process
            newComplement.title = title
            try! self.localRealm.write {
                routine.complement = newComplement
            }
        }
        
    }
}
//action extention
extension RoutineDetailViewController {
    
    @IBAction func uploadRoutine() {
        guard let routine = Watcher.RoutineDetail else{
            return
        }
        guard !routine.sharedFlag else{
            showAlterView(message:Constants.AlterMessage.shareUploaded.rawValue)
            return
        }
        guard let conf = Watcher.GloabalRealmConf else{
            showAlterView(message:Constants.AlterMessage.error.rawValue)
            return
        }
        guard let remoteUserInfo = Watcher.RemoteUserInfo else{
            UserInfoUtil.loadUserInfo()
            showAlterView(message:Constants.AlterMessage.error.rawValue)
            return
        }
        guard remoteUserInfo.verifiedFlag else{
            showAlterView(message:"由于某些原因，你被禁止使用该功能")
            return
        }
        guard remoteUserInfo.nickname != nil else{
            showNicknameEditor()
            return
        }
        
        let process = processTitleView.getProcess()
        let title = processTitleView.getTitle()
        
        guard process.count>10 && title != nil && title!.count>3 else{
            showAlterView(message:Constants.AlterMessage.shareImcomplete.rawValue)
            processTitleView.beginToEdit(createTime: routine.createTime)
            return
        }
        let remoteRealm = try! Realm(configuration: conf)
        let newShare = Share()
        newShare.shareID = routine.routineID
        newShare.target = routine.target
        newShare.agent = routine.agent
        newShare.outcome = routine.outcome
        newShare.process =  process
        newShare.title = title!
        newShare.userInfo = remoteUserInfo
        newShare.policyAndFeedbacks.append(objectsIn: routine.policyAndFeedbacks)
        try! remoteRealm.write {
            remoteRealm.create(Share.self,value:newShare,update:true)
            remoteUserInfo.point += 10
        }
        processTitleView.processField.resignFirstResponder()
        processTitleView.titleField.resignFirstResponder()
        try! self.localRealm.write {
            routine.sharedFlag = true
            newShare.youShare = true
            self.localRealm.create(Share.self,value:newShare,update:true)
        }
        showAlterView(message:Constants.AlterMessage.shareSuccess.rawValue)
    }
    
    @IBAction func addProcess() {
        processTitleView.beginToEdit(createTime: Watcher.RoutineDetail!.createTime)
    }
    
}
