//
//  ShareDetailScrollView.swift
//  taolu
//
//  Created by 佘昌略  on 2018/4/17.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit

class ShareDetailScrollView: UIScrollView {
    @IBOutlet weak var policyAndFeedbacksView: PolicyAndFeedbacksView!
    @IBOutlet weak var processTitleView: ProcessTitleView!
    @IBOutlet weak var sharePostView:SharePostView!
    @IBOutlet weak var commentTableView: CommentTableView!
    @IBOutlet weak var routineBanner:RoutineBanner!
    private func layout(){
        self.routineBanner.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        self.policyAndFeedbacksView.snp.makeConstraints { (make) in
            make.top.equalTo(self.routineBanner.snp.bottom)
            make.left.right.equalToSuperview()
        }
        self.policyAndFeedbacksView.tokenLabelWidth = UIScreen.main.bounds.size.width/5.0
        self.processTitleView.snp.makeConstraints { (make) in
            make.top.equalTo(self.policyAndFeedbacksView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        self.sharePostView.snp.makeConstraints { (make) in
            make.top.equalTo(self.processTitleView.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(20)
        }
 
        self.commentTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.sharePostView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.size.height)
            
        }
        self.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.size.width)
            make.bottom.equalTo(self.commentTableView)
        }
        
        
    }
    private func config(){
        self.commentTableView.isScrollEnabled = false
        self.showsVerticalScrollIndicator = false
        self.bounces = true
        self.alwaysBounceVertical = true
        self.delegate = self
    }
    private func setListener(){
        
    }
    init(){
        super.init(frame:CGRect(x:0, y:0, width:100, height:30))
        config()
        layout()
        
    }
 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        config()
        layout()
    }
}
 
extension ShareDetailScrollView:UIScrollViewDelegate{
    /// MARK: UIScrollViewDelegate 代理
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let addy = self.contentOffset.y - self.commentTableView.frame.origin.y
        if  addy > 0 && self.commentTableView.contentOffset.y>=0{
            guard self.commentTableView.visibleCells.count>3 else{
                return
            }
            self.contentOffset.y = self.commentTableView.frame.origin.y
            self.commentTableView.contentOffset.y += addy
        }else if addy < 0 && self.commentTableView.contentOffset.y>0{
            let addy = self.contentOffset.y - self.commentTableView.frame.origin.y
            self.contentOffset.y = self.commentTableView.frame.origin.y
            self.commentTableView.contentOffset.y += addy
        }else if self.commentTableView.contentOffset.y<0{
            self.commentTableView.contentOffset.y=0
        }
        
    }
    
}
