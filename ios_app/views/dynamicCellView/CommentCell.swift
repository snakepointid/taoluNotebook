//
//  CommentCell.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/17.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit
import RealmSwift
class CommentCell: BasicViewCell {
    weak var delegate:CommentDelegate!
    var commentDetail: UILabel!
    var userInfoView: UserInfoView!
    var likeView: PostView!
    var dislikeView: PostView!
    var commentID:String?
    var reportBtn:UIButton!
    var postActNum:Int=0
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubviews()
        config()
        layout()
    }
}
//api
extension CommentCell{
    func setCommentInfo(comment:Comment){
        self.commentID = comment.commentID
        userInfoView.setUserInfo(comment: comment)
        likeView.clicked = comment.youLike
        dislikeView.clicked = comment.youDislike
        likeView.num = comment.likeNum
        dislikeView.num = comment.dislikeNum
        commentDetail.text = comment.text
      
        
    }
}
//basic
extension CommentCell{
    @objc func tapped(){
        if delegate != nil {
            Watcher.reportCotentID = self.commentID
            Watcher.reportCotentType = "comment"
            delegate.reportBtnPress()
        }
    }
    private func config(){
        reportBtn.setTitleColor(UIColor.lightGray, for: .normal)
        reportBtn.titleLabel?.font = UIFont(name:"ArialMT", size:10)
        reportBtn.titleLabel?.alpha = 0.9
        reportBtn.setTitle("举报Ta", for: .normal)
        reportBtn.titleLabel?.textAlignment = .left
        reportBtn.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        likeView.postType = Constants.PostType.like
        dislikeView.postType = Constants.PostType.dislike
        
        likeView.delegate = self
        dislikeView.delegate = self
        likeView.baseName = "like"
        dislikeView.baseName = "dislike"
        
        commentDetail.font = UIFont(name:"ArialMT", size:15)
        commentDetail.numberOfLines=0
        commentDetail.textAlignment = NSTextAlignment.left
        commentDetail.lineBreakMode = NSLineBreakMode.byCharWrapping
        commentDetail.adjustsFontSizeToFitWidth = true
    }
    private func layout(){
        contentView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        self.userInfoView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(20)
            make.height.equalTo(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        self.commentDetail.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            
            make.top.equalTo(self.userInfoView.snp.bottom).offset(10)
        }
        commentDetail.removeFromSuperview()
        contentView.addSubview(commentDetail)
        self.commentDetail.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.userInfoView)
            make.top.equalTo(self.userInfoView.snp.bottom).offset(10)
        }
        
        self.likeView.snp.makeConstraints { (make) in
            make.left.equalTo(self.userInfoView).offset(10)
            make.height.equalTo(15)
            make.width.equalTo(70)
            make.top.equalTo(self.commentDetail.snp.bottom).offset(20)
        }
        self.dislikeView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.likeView)
            make.width.equalTo(70)
            make.left.equalTo(self.likeView.snp.right)
        }
        self.reportBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.likeView)
            make.width.equalTo(70)
            make.left.equalTo(self.dislikeView.snp.right).offset(10)
        }
        contentView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.likeView).offset(10)
        }
    }
    func initSubviews(){
        reportBtn = UIButton()
        userInfoView = UserInfoView()
        likeView = PostView()
        dislikeView = PostView()
        commentDetail = UILabel()
        self.contentView.addSubview(likeView)
        self.contentView.addSubview(reportBtn)
        self.contentView.addSubview(userInfoView)
        self.contentView.addSubview(dislikeView)
        self.addSubview(commentDetail)
    }
}
//ShareDelegate
extension CommentCell:ShareDelegate{
    
    func postFeedback(type:Constants.PostType){
        var addLikeNum = 0
        var addDislikeNum = 0
        switch type {
        case Constants.PostType.like:
            if self.likeView.clicked{
                self.likeView.clicked = false
                addLikeNum = -1
            }else{
                self.likeView.clicked = true
                addLikeNum = 1
            }
            if self.dislikeView.clicked{
                self.dislikeView.clicked = false
                addDislikeNum = -1
            };
            break;
        case Constants.PostType.dislike:
            if self.dislikeView.clicked{
                self.dislikeView.clicked = false
                addDislikeNum = -1
            }else{
                self.dislikeView.clicked = true
                addDislikeNum = 1
            }
            if self.likeView.clicked{
                self.likeView.clicked = false
                addLikeNum = -1
            };
            break;
        default:
            break;
        }
        
        postActNum+=1
        guard postActNum<2 else{
            return
        }
        if let conf = Watcher.GloabalRealmConf,
            let commentid = self.commentID{
            let remoteRealm = try! Realm(configuration: conf)
            let filterSql = String(format:"commentID = '%@'",commentid)
            let remoteComment = remoteRealm.objects(Comment.self).filter(filterSql)
            if remoteComment.count>0{
                try! remoteRealm.write {
                    remoteComment.first!.likeNum += addLikeNum
                    remoteComment.first!.dislikeNum += addDislikeNum
                }
            }
        }
        
    }
}
