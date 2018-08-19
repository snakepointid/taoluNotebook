//
//  ReportViewController.swift
//  taolu
//
//  Created by 佘昌略  on 2018/5/2.
//  Copyright © 2018年 佘昌略. All rights reserved.
//

import UIKit
import RealmSwift
class ReportViewController: BasicViewController{
    var uploadBtn:UIButton!
    var reportType:String?{
        didSet{
            uploadBtn.backgroundColor = UIColor.feedbackLabel
        }
    }
    struct ReportSec {
        var title:String
        var detail:[String]
    }
    @IBOutlet weak var reportViewPad: UICollectionView!
    let reportDetails:[ReportSec] = [
        ReportSec(title: "违反法律法规", detail: ["违法违规","色情","暴力","赌博诈骗","低俗"]),
        ReportSec(title: "侵犯个人权益", detail: ["人身攻击","侵犯隐私"]),
        ReportSec(title: "有害社区环境", detail: ["垃圾广告","引战","刷屏","少儿不宜"])
    ]
    private func configBtn(){
        uploadBtn = UIButton()
        self.view.addSubview(uploadBtn)
        uploadBtn.setTitle("提交", for: .normal)
        uploadBtn.titleLabel?.textAlignment = .center
        uploadBtn.backgroundColor = UIColor.lightGray
        uploadBtn.layer.cornerRadius = 8.0
        uploadBtn.layer.masksToBounds = true
        
        uploadBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        uploadBtn.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    @objc func tapped(){
        guard let reportType = self.reportType else{
            return
        }
        guard let contentId = Watcher.reportCotentID,
            let contentType = Watcher.reportCotentType else{
                showAlterView(message: "举报失败")
                return
        }
        guard let conf = Watcher.GloabalRealmConf else{
            showAlterView(message: Constants.AlterMessage.error.rawValue)
            return
        }
        let keyToUpdate = "report:"+contentId
        guard keyIsNotUpdated(key:keyToUpdate) else{
            showAlterView(message: "你已经举报过了")
            return
        }
        let remote = try! Realm(configuration: conf)
        let filterSql = String(format:"cotentID = '%@' AND reportType='%@'",contentId,reportType)
        let report = remote.objects(Report.self).filter(filterSql)
        try! remote.write {
            if report.count>0{
                report.first!.reportTimes += 1
            }else{
                let newReport = Report()
                newReport.cotentID = contentId
                newReport.cotentType = contentType
                newReport.reportType = reportType
                newReport.reportTimes = 1
                remote.add(newReport)
            }
        }
        showAlterView(message: "感谢你的举报，净化网络人人有责")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {[weak self] in
            self?.pan()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        reportViewPad.delegate = self
        reportViewPad.dataSource = self
        reportViewPad.reloadData()
        reportViewPad.contentInset = UIEdgeInsetsMake(0, 0.0, 100, 0.0)
        configBtn()
    }
    
    @IBAction func backBtnPress(_ sender: Any) {
        pan()
    }
    
}
//collectview delegate
extension ReportViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reportDetails[section].detail.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return reportDetails.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview:UICollectionReusableView!
        
        
        if kind == UICollectionElementKindSectionHeader{
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: "HeaderView", for: indexPath)
            
            let label = reusableview.viewWithTag(1) as! UILabel
            label.text = reportDetails[indexPath.section].title
        }
        
        return reusableview
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //获取单元格
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReportCell",
                                                      for: indexPath) as! ReportCell
        
        cell.label = reportDetails[indexPath.section].detail[indexPath.item]
        if let reportType = self.reportType{
            cell.clicked = cell.label == reportType
        }
        cell.delegate = self
        return cell
    }
}
//
extension ReportViewController:BtnPressDelegate{
    func ctrBtnTap(info: String) {
        reportType = info
        reportViewPad.reloadData()
    }
}
