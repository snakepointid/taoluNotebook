//
//  CommentTableViewController.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/17.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit
import RealmSwift

class CommentTableView:UITableView {
    weak var commentDelegate:CommentDelegate!
    var selfComments:Results<Comment>?
    var popComments:Results<Comment>?
    var newestComments:Results<Comment>?
    var cachedComments:[Comment]=[]
 
    var selfCommentNumber:Int!
    var popCommentsNumber:Int!
    var newestCommentNumber:Int!
    var header:UILabel!
    private func setDelegate(){
        selfCommentNumber=0
        popCommentsNumber=0
        newestCommentNumber=0
        self.delegate = self
        self.dataSource = self
    }
    private func layout(){
        self.header.snp.makeConstraints{make in
            make.left.right.equalToSuperview()
            make.top.centerX.equalToSuperview()
        }
    }
    private func initSubviews(){
        self.header = UILabel()
        self.header.textAlignment = .center
        self.header.backgroundColor = UIColor.textEdit
        self.header.text = "评论区(0)"
        self.tableHeaderView = header
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setDelegate()
        initSubviews()
        layout()
    }
    required init?(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)
        setDelegate()
        initSubviews()
        layout()
    }
    
    deinit {
        self.cachedComments = []
    }
}
//table view behaviror
extension CommentTableView:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let commentNumber = self.popComments?.count{
            self.popCommentsNumber =   min(Int(arc4random_uniform(30))+5,commentNumber)
        }
        if let commentNumber = self.selfComments?.count{
            self.selfCommentNumber =  commentNumber
        }
        if let commentNumber = self.newestComments?.count{
            self.newestCommentNumber =  commentNumber
        }
        return self.popCommentsNumber+self.selfCommentNumber+self.newestCommentNumber
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        var comment:Comment!
        if row < self.cachedComments.count{
            comment = self.cachedComments[row]
        }else{
            if row<self.selfCommentNumber{
                comment = self.selfComments![row]
            }else if row<self.selfCommentNumber+self.popCommentsNumber{
                comment = self.popComments![row-self.selfCommentNumber]
            }else{
                comment = self.newestComments![row-self.selfCommentNumber-self.popCommentsNumber]
            }        
            self.cachedComments.append(comment)
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath as IndexPath)as! CommentCell
        cell.delegate = self.commentDelegate
        cell.setCommentInfo(comment:comment)
        cell.selectionStyle = .none
        return cell
        
    }
}
//api
extension CommentTableView{
    func setCommentInfo(allComments:Results<Comment>){
        var nickname:String? = Watcher.UserInfo!.nickname
        if nickname == nil {
            nickname = "0"
        }
        self.selfComments = allComments.filter("upFlag = true OR commenterInfo.nickname = '"+nickname!+"'").sorted(byKeyPath: "commentTime",ascending:false)
        let notSelfComments = allComments.filter("upFlag = false AND commenterInfo.nickname != '"+nickname!+"'")
        if arc4random_uniform(2) == 1 {
            self.popComments = notSelfComments.filter("popFlag = true")
            self.newestComments = notSelfComments.filter("popFlag = false")
        }else{
            self.popComments = notSelfComments.filter("popFlag = false")
            self.newestComments = notSelfComments.filter("popFlag = true")
        }
        self.popComments = self.popComments?.sorted(byKeyPath: "likeNum",ascending:false)
        self.newestComments = self.newestComments?.sorted(byKeyPath: "commentTime",ascending:false)
        self.header.text = String(format: "评论区(%d)", allComments.count)
    }
    
}

