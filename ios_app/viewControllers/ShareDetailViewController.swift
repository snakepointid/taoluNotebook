//
//  ShareDetailViewController.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/17.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit
import RealmSwift
import SnapKit
class ShareDetailViewController: BasicViewController {
    //let localRealm:Realm
    @IBOutlet weak var shareDetailScrollView: ShareDetailScrollView!
    @IBOutlet weak var shareEditView: EditView!
    @IBOutlet weak var routineBanner:RoutineBanner!
    @IBOutlet weak var policyAndFeedbacksView: PolicyAndFeedbacksView!
    @IBOutlet weak var processTitleView: ProcessTitleView!
    @IBOutlet weak var sharePostView:SharePostView!
    @IBOutlet weak var commentTableView: CommentTableView!
    
    required init(coder aDecoder: NSCoder) {
 
        super.init(coder: aDecoder)!
        
    }
    deinit {
        savePostInfo()
        Watcher.RoutineShare = nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        initSubviews()
        setListener()
    }
    
}
//some funcs
extension ShareDetailViewController{
    
    private func savePostInfo(){
        guard let share = Watcher.RoutineShare else{
            return
        }
        let userPosted = share.youPost
        var likeChange = 0
        var dislikeChange = 0
        var followChange = 0
        let newComment = !share.youComment && sharePostView.commentView.clicked
        
        if  share.youFollow != sharePostView.collectView.clicked{
            followChange = sharePostView.collectView.clicked ? 1:-1
        }
        if  share.youLike != sharePostView.likeView.clicked{
            likeChange = sharePostView.likeView.clicked ? 1:-1
        }
        if  share.youDislike != sharePostView.dislikeView.clicked{
            dislikeChange = sharePostView.dislikeView.clicked ? 1:-1
        }
        guard likeChange != 0 || dislikeChange != 0 || followChange != 0 || newComment else{
            return
        }
        let querySQL = "shareID = '"+share.shareID+"'"
        let localRealm = try! Realm()
        if let newShare = localRealm.objects(Share.self).filter(querySQL).first{
            try! localRealm.write {
                newShare.dislikeNum += dislikeChange
                newShare.likeNum += likeChange
                newShare.followNum += followChange
                newShare.commentNum = sharePostView.commentView.num
                newShare.youPost = true
                newShare.youLike = sharePostView.likeView.clicked
                newShare.youDislike = sharePostView.dislikeView.clicked
                newShare.youFollow = sharePostView.collectView.clicked
                newShare.youComment = sharePostView.commentView.clicked
            }
        }
        guard !userPosted else{
            return
        }
        if let conf = Watcher.GloabalRealmConf{
            let remoteRealm = try! Realm(configuration:conf)
            let queriedShare = remoteRealm.objects(Share.self).filter(querySQL)
            if queriedShare.count==1{
                try! remoteRealm.write {
                    queriedShare.first!.dislikeNum += dislikeChange
                    queriedShare.first!.likeNum += likeChange
                    queriedShare.first!.followNum += followChange
                    queriedShare.first!.commentNum = sharePostView.commentView.num
                    queriedShare.first!.userInfo!.point += 1
                }
            }
        }
    }
    
}
//basic
extension ShareDetailViewController{
    
    private func layout(){
        let topMargin:CGFloat = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height+10
        
        self.shareDetailScrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(topMargin)
            make.left.right.bottom.equalToSuperview()
        }
        self.shareEditView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            updatableConstraint = make.bottom.equalToSuperview().constraint
        }
        self.view.bringSubview(toFront: self.shareEditView)
    }
    
    private func initSubviews(){
        if let share = Watcher.RoutineShare{
            self.routineBanner.setBannerInfo(target: share.target, agent: share.agent, outcome: share.outcome)
            policyAndFeedbacksView.setPolicyAndFeedbacksInfo(policyAndFeedbacks: Array(share.policyAndFeedbacks))
            processTitleView.setProcessInfo(share:share)
            sharePostView.setShareInfo(share: share)
            if let conf = Watcher.GloabalRealmConf {
                let remoteRealm = try! Realm(configuration:conf)
                let filterSql = String(format:"shareID = '%@'",share.shareID)
                let allComments = remoteRealm.objects(Comment.self).filter(filterSql)
                commentTableView.commentDelegate = self
                commentTableView.setCommentInfo(allComments: allComments)
                sharePostView.commentView.num = allComments.count
            }
        }
    }
    private func setListener(){
        shareEditView.delegate = self  
        sharePostView.delegate = self
        addSoftKeyboardListener()
    }
}
//CommentDelegate
extension ShareDetailViewController:CommentDelegate{
    func reportBtnPress() {
        self.performSegue(withIdentifier: "showUGCReport", sender: nil)
    }
}
//TextEditDelegate
extension ShareDetailViewController:BtnPressDelegate{
    
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
        guard let _ = remoteUserInfo.nickname  else{
            self.showNicknameEditor()
            return
        }
        guard info.count>1 else{
            showAlterView(message: Constants.AlterMessage.commentShort.rawValue)
            return
        }
        guard self.actable(mesg:"评论过于频繁，请稍后再试") else{
            return
        }
        if let conf = Watcher.GloabalRealmConf,
            let userInfo = Watcher.RemoteUserInfo,
            let share = Watcher.RoutineShare{
            let remoteRealm = try! Realm(configuration:conf)
            let comment = Comment()
            comment.shareID = share.shareID
            comment.text = info
            comment.commenterInfo = userInfo
            comment.upFlag = share.youShare
            if arc4random_uniform(2) == 1{
                comment.popFlag = true
            }else{
                comment.popFlag = false
            }
            try! remoteRealm.write {
                remoteRealm.create(Comment.self,value:comment)
            }
            shareEditView.editField.resignFirstResponder()
            showAlterView(message: Constants.AlterMessage.commentSuccess.rawValue)
            sharePostView.commentView.clicked = true
            commentTableView.cachedComments.insert(comment, at: 0)
            commentTableView.reloadData()
        }else{
            shareEditView.editField.resignFirstResponder()
            showAlterView(message: Constants.AlterMessage.error.rawValue)
        }
    }
}

//ShareDelegate
extension ShareDetailViewController:ShareDelegate{
    func postFeedback(type:Constants.PostType){
        guard let share = Watcher.RoutineShare else{
            return
        }
        switch type {
        case Constants.PostType.collect:
            guard !share.youShare else{
                showAlterView(message: Constants.AlterMessage.shareSelfPost.rawValue)
                return
            };
            
            guard !share.youFollow else{
                showAlterView(message: Constants.AlterMessage.shareFollowPost.rawValue)
                return
            };
            
            if sharePostView.collectView.clicked{
                sharePostView.collectView.clicked = false
                showAlterView(message: Constants.AlterMessage.shareCollectCancel.rawValue)
            }else{
                sharePostView.collectView.clicked = true
                showAlterView(message: Constants.AlterMessage.shareCollect.rawValue)
            };
            break;
        case Constants.PostType.like:
            sharePostView.likeView.clicked = sharePostView.likeView.clicked ? false:true;
            if sharePostView.dislikeView.clicked{
                sharePostView.dislikeView.clicked = false
            };
            break;
        case Constants.PostType.dislike:
            sharePostView.dislikeView.clicked = sharePostView.dislikeView.clicked ? false:true;
            if sharePostView.likeView.clicked{
                sharePostView.likeView.clicked = false
            };
            break;
        default:
            break;
        }
        
        
    }
}
