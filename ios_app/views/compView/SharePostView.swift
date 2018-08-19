//
//  ShareCommentView.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/14.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit
import SnapKit
class SharePostView: BasicView{
    weak var delegate:ShareDelegate!
    var collectView: PostView!
    var likeView: PostView!
    var dislikeView: PostView!
    var commentView: PostView!
    
    var postViewWidth:CGFloat!
 
    override init()
    {
        super.init()
        initSubviews()
        layout()
        config()
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubviews()
        layout()
        config()
    }
}
//basic
extension SharePostView{
    private func initSubviews(){
        collectView = PostView()
        likeView = PostView()
        dislikeView = PostView()
        commentView = PostView()
        self.addSubview(collectView)
        self.addSubview(likeView)
        self.addSubview(dislikeView)
        self.addSubview(commentView)
    }
    private func config(){
        collectView.postType = Constants.PostType.collect
        likeView.postType = Constants.PostType.like
        dislikeView.postType = Constants.PostType.dislike
        commentView.postType = Constants.PostType.comment
        
        collectView.delegate = self
        likeView.delegate = self
        dislikeView.delegate = self
        commentView.delegate = self
        
        collectView.baseName = "collect"
        likeView.baseName = "like"
        dislikeView.baseName = "dislike"
        commentView.baseName = "comment"
    }
    
    private func layout(){
        postViewWidth = 70
        collectView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(postViewWidth)
        }
        likeView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(collectView.snp.right)
            make.width.equalTo(postViewWidth)
        }
        dislikeView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(likeView.snp.right)
            make.width.equalTo(postViewWidth)
        }
        commentView.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(postViewWidth)
        }
        
    }
}
//api
extension SharePostView{
    func setShareInfo(share:Share){
        likeView.clicked = share.youLike
        dislikeView.clicked = share.youDislike
        collectView.clicked = share.youFollow
        commentView.clicked = share.youComment
        
        collectView.num =  share.followNum
        likeView.num = share.likeNum
        dislikeView.num = share.dislikeNum
        commentView.num = share.commentNum
    }
}
//ShareDelegate
extension SharePostView:ShareDelegate{
    func postFeedback(type:Constants.PostType){
        if self.delegate != nil {
            self.delegate!.postFeedback(type:type)
        }
    }
}
