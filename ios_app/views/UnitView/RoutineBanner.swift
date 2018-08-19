//
//  RoutineBanner.swift
//  taolu
//
//  Created by 佘昌略  on 2018/3/18.
//  Copyright © 2018年 佘昌略. All rights reserved.
//
import UIKit

class RoutineBanner: BasicView{
    weak var delegate:OptionViewDelegate!
    var targetLabel:UIButton!
    var agentLabel:UIButton!
    var outcomeImage:UIImageView?
    var probabilityLabel:UILabel?
    var segmentLine:SegmentLine!
    
    var targetEdited:Bool = false
    var agentEdited:Bool = false
    var targetRawText:String?
    var targetText:String? {
        didSet
        {
            targetLabel.setTitle(targetText, for: .normal)
            targetRawText = Constants.targetSymbal+targetText!
            targetEdited = targetText!.count>1 ?true:false
        }
    }
    var agentRawText:String?
    var agentText:String? {
        didSet
        {
            agentLabel.setTitle(agentText, for: .normal)
            agentRawText = Constants.agentSymbal+agentText!
            agentEdited = agentText!.count>1 ?true:false
        }
    }
    var probabilities:[Float]=[]
    var showProb:Float?{
        didSet{
            if probabilityLabel == nil {
                configProbability()
            }
            probabilityLabel!.text = String(format:"%.2f",showProb!)
        }
    }
    private func initSubviews(){
        targetLabel = UIButton()
        agentLabel = UIButton()
        
        segmentLine = SegmentLine()
        self.addSubview(targetLabel)
        self.addSubview(agentLabel)
        
        self.addSubview(segmentLine)
    }
    private func layout(){
        let labelWidth:CGFloat = 80.0
        targetLabel.layLeftCorner(margin: 10,width:labelWidth,height:nil)
        agentLabel.layRightCorner(margin: 10,width:labelWidth,height:nil)
        
        segmentLine.layBottom()
    }
    private func config(){
        targetLabel.setTitleColor(UIColor.kRGBColorFromHex(hex: "#37B139"), for: .normal)
        targetLabel.titleLabel?.font = UIFont(name:"ArialMT", size:15)
        targetLabel.titleLabel?.textAlignment = NSTextAlignment.center
        agentLabel.setTitleColor(UIColor.kRGBColorFromHex(hex: "#37B139"), for: .normal)
        agentLabel.titleLabel?.font = UIFont(name:"ArialMT", size:15)
        agentLabel.titleLabel?.textAlignment = NSTextAlignment.center
        
        
        
    }
    private func configOutcome(){
        outcomeImage = UIImageView()
        self.addSubview(outcomeImage!)
        outcomeImage!.layCenter(width:15,height:15)
    }
    private func configProbability(){
        probabilityLabel = UILabel()
        self.addSubview(probabilityLabel!)
        probabilityLabel!.layCenter(width:100,height:15)
        probabilityLabel!.textColor = UIColor.gray
        probabilityLabel!.font = UIFont(name:"ArialMT", size:15)
        probabilityLabel!.alpha = 0.8
        probabilityLabel!.textAlignment = NSTextAlignment.center
    }
    private func setListener(){
        targetLabel.addTarget(self, action: #selector(targetLabelTapped), for: .touchUpInside)
        agentLabel.addTarget(self, action: #selector(agentLabelTapped), for: .touchUpInside)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubviews()
        config()
        layout()
        setListener()
    }
    
    override init(){
        super.init()
        initSubviews()
        config()
        layout()
        setListener()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func targetLabelTapped(){
        if delegate != nil {
            delegate!.editTarget()
            
        }
    }
    @objc func agentLabelTapped(){
        if delegate != nil {
            delegate!.editAgent()
        }
    }
    private func getShowProb(){
        var sum:Float=0.0
        var num:Int=0
        for prob in probabilities{
            if prob > 0 {
                sum += prob
                num += 1
            }
        }
        showProb = sum/Float(num)
    }
}
//api
extension RoutineBanner{
    func addProbability(newProb:Float){
        probabilities.append(newProb)
        guard newProb > 0 else{
            return
        }
        getShowProb()
    }
    func dropLastProbability(){
        guard probabilities.count > 0 else{
            return
        }
        probabilities.removeLast()
        guard probabilities.count > 0 else{
            return
        }
        getShowProb()
    }
    func setBannerInfo(target:String,agent:String,outcome:String){
        self.configOutcome()
        targetText = target.substring(from:1)
        agentText = agent.substring(from:1)
        outcomeImage!.image = outcome==Constants.positiveOutcome ? UIImage(named:"happy") : UIImage(named:"sad")
    }
    func setBannerInfo(routine:Routine){
        self.configOutcome()
        targetText = routine.target.substring(from:1)
        agentText = routine.agent.substring(from:1)
        outcomeImage!.image = routine.outcome==Constants.positiveOutcome ? UIImage(named:"happy") : UIImage(named:"sad")
    }
    func setBannerInfo(share:Share){
        self.configOutcome()
        targetText = share.target.substring(from:1)
        agentText = share.agent.substring(from:1)
        outcomeImage!.image = share.outcome==Constants.positiveOutcome ? UIImage(named:"happy") : UIImage(named:"sad")
    }
    
}
