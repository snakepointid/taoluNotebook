//
//  RoutineEditViewController.swift
//  taolu
//
//  Created by 佘昌略  on 2018/3/22.
//  Copyright © 2018年 佘昌略. All rights reserved.
//


import UIKit
import SnapKit
import RealmSwift
class RoutineEditViewController: BasicViewController {
    //outlet
    @IBOutlet weak var routineDetailScrollView:RoutineDetailScrollView!
    @IBOutlet weak var routineEditBanner:RoutineBanner!
    @IBOutlet weak var policyAndFeedbacksView: PolicyAndFeedbacksView!
    //variable
    var remoteRealm:Realm?
    let localRealm : Realm!
    let cacheRealm : Realm!
    //option query relate
    var queryKeys:[String]!
    var savedQueries:Set<String>!
    var queriedOptions:[TAPF]!
    //final
    let mRoutine:Routine
    
    var optionView:OptionListView
    let optionViewHeight:CGFloat
    enum bayesReturnCode{
        case noExsit
        case notConfidential
        case success
    }
    //T
    @objc override func pan(){
        if !needSaveFlag(){
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    required init(coder aDecoder: NSCoder) {
        self.localRealm = try! Realm()
        self.cacheRealm = Watcher.CacheRealm
        self.mRoutine = Routine()
        self.optionViewHeight = 200.0
        self.optionView = OptionListView()
        super.init(coder: aDecoder)!
        if let conf = Watcher.GloabalRealmConf{
            self.remoteRealm = try! Realm(configuration:conf)
        }
    }
    //监听键盘的事件
    @objc override func keyBoardWillShow(aNotification: Notification) {
        let userInfo  = aNotification.userInfo! as NSDictionary
        let keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = keyBoardBounds.size.height
        
        self.updatableConstraint.update(offset: optionViewHeight+deltaY)
    }
    //T
    @objc override func keyBoardWillHide(aNotification: Notification) {
        self.updatableConstraint.update(offset: optionViewHeight)
    }
    private func layout(){
        let topMargin:CGFloat = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height+10
        self.routineDetailScrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(topMargin)
            make.left.right.bottom.equalToSuperview()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        // setdelegate
        optionView.delegate = self
        routineEditBanner.delegate = self
        //add listener
        addGestureListener()
        addSoftKeyboardListener()
        //show option list view
        showInputHint()
        updateOptions()
        showOptionList()
    }
}

//option list relate funcs
extension RoutineEditViewController{
    //T
    private func getOptions(symbal:String,optRealm:Realm,key:String)->Results<Option>?{
        let filterSql = String(format:"key = '%@'",key)
        let optionModel = optRealm.objects(Option.self).filter(filterSql)
        guard optionModel.count > 0 else{
            return nil
        }
        let queries = optionModel.first!.queries.filter("symbal = '"+symbal+"'").sorted(byKeyPath: "frequency",ascending:false)
        for query in queries{
            guard !savedQueries.contains(query.query) else{
                continue
            }
            let policyOrFeedback = TAPF()
            policyOrFeedback.token = query.query
            policyOrFeedback.symbal = query.symbal
            self.getTAPFType(tapf: policyOrFeedback)
            queriedOptions.append(policyOrFeedback)
            savedQueries.insert(query.query)
            if queriedOptions.count>8{
                break
            }
        }
        return optionModel
    }
    //T
    private func getOptions(symbal:String) {
        savedQueries = Set<String>()
        queriedOptions = []
        
        for key in queryKeys{
            guard queriedOptions.count<9 else{
                return
            }
            let _ = getOptions(symbal: symbal, optRealm: self.localRealm, key: key)
            guard queriedOptions.count<9 else{
                return
            }
            guard let _ = getOptions(symbal: symbal, optRealm: self.cacheRealm, key: key)else{
                
                guard let remoteRealm = self.remoteRealm else{
                    continue
                }
                guard let optionModel = getOptions(symbal: symbal, optRealm: remoteRealm, key: key) else{
                    continue
                }
                try! self.cacheRealm.write {
                    self.cacheRealm.create(Option.self,value:optionModel.first!)
                }
                continue
            }
        }
    }
    
    //T
    private func updateOptionModel(optRealm:Realm,queryToken:String,symbal:String,key:String){
        guard let userInfo = Watcher.UserInfo else{
            return
        }
        let addFrequency = userInfo.level + 1
        let filterSql = String(format:"key = '%@'",key)
        let optionModel = optRealm.objects(Option.self).filter(filterSql)
        guard optionModel.count>0 else{
            let newOption = Option()
            newOption.key = key
            newOption.queries.append(Query(value:[queryToken,symbal,addFrequency]))
            try! optRealm.write {
                optRealm.add(newOption)
            }
            return
        }
        try! optRealm.write {
            let queries = optionModel.first!.queries
            let querySql = String(format:"symbal = '%@' AND query= '%@'",symbal,queryToken)
            let query = queries.filter(querySql)
            if query.count>0{
                query.first!.frequency+=addFrequency
            }else{
                let newQuery = Query(value:[queryToken,symbal,addFrequency])
                queries.append(newQuery)
            }
        }
    }
    private func updateOptionModel(queryToken:String,symbal:String){
        for key in queryKeys{
            let keyToUpdate = "OptionModel:"+key+symbal+queryToken
            guard keyIsNotUpdated(key:keyToUpdate) else{
                continue
            }
            updateOptionModel(optRealm:self.localRealm,queryToken:queryToken,symbal:symbal,key:key)
            
            if let remoteRealm = self.remoteRealm,
                let userInfo = Watcher.UserInfo{
                if userInfo.verifiedFlag{
                    updateOptionModel(optRealm:remoteRealm,queryToken:queryToken,symbal:symbal,key:key)
                }
            }
        }
    }
    //T
    private func showOptionList(){
        let alertController:UIAlertController = UIAlertController(title: nil, message: nil,
                                                                  preferredStyle: .actionSheet)
        alertController.view.snp.makeConstraints { (make) in
            updatableConstraint = make.height.equalTo(optionViewHeight).constraint
            
        }
        
        alertController.view.addSubview(optionView)
        alertController.addAction(UIAlertAction(title: "", style: .cancel, handler: nil))
        optionView.matchParent(bottomMargin:10)
        // support iPad
        if let popController = alertController.popoverPresentationController{
            popController.sourceView = self.view
            popController.sourceRect = CGRect(x:0,y:UIScreen.main.bounds.size.height,width:0,height:0)
            alertController.view.snp.makeConstraints { (make) in
                
                make.width.equalTo(UIScreen.main.bounds.size.width)
            }
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    private func showOption(tapf:TAPF){
        switch tapf.symbal {
        case Constants.targetSymbal:
            routineEditBanner.targetText = tapf.token;
            break;
        case Constants.agentSymbal:
            routineEditBanner.agentText = tapf.token;
            break;
        default:
            policyAndFeedbacksView.addPolicyOrFeedback(policyOrFeedback:tapf);
            break;
        }
        routineEditBanner.addProbability(newProb: tapf.showProb)
        updateOptionModel(queryToken:tapf.token,symbal: tapf.symbal)
        showInputHint()
    }
    //T
    private func showInputHint(){
        if !routineEditBanner.targetEdited{
            showTargetInputHint()
        }else if !routineEditBanner.agentEdited{
            showAgentInputHint()
        }else if policyAndFeedbacksView.isLastPolicy{
            showFeedbackInputHint()
        }else {
            showPolicyInputHint()
        }
    }
    //T
    private func updateOptions(){
        optionView.optionEditView.inputEdit.text = ""
        switch optionView.optionEditView.switcherBtnTitle{
        case Constants.agentLabel?:
            optionView.optionList = getAgentOptions();
            break;
        case Constants.policyLabel?:
            optionView.optionList = getPolicyOptions();
            break;
        case Constants.feedbackLabel?:
            optionView.optionList = getFeedbackOptions();
            break;
        default:
            optionView.optionList = getTargetOptions();
            break;
        }
    }
    //T
    private func getTargetQueryKeys(){
        let routines = localRealm.objects(Routine.self).sorted(byKeyPath: "createTime",ascending:false)
        guard routines.count>0 else {
            queryKeys = [Constants.nullTarget]
            return
        }
        var rawQueryKeys:[String] = []
        
        for routine in routines{
            guard rawQueryKeys.count<3 else{
                break
            }
            guard !rawQueryKeys.contains(routine.target) else{
                continue
            }
            rawQueryKeys.insert(routine.target, at: 0)
        }
        queryKeys = AlgorithmUtils.getCombinedKeys(rawKeys: rawQueryKeys)
    }
    //T
    private func getTargetOptions()->[TAPF]{
        getTargetQueryKeys()
        getOptions(symbal:Constants.targetSymbal)
        return queriedOptions
    }
    //T
    private func getAgentQueryKeys(){
        if let target = routineEditBanner.targetRawText{
            guard target.count>1 else{
                queryKeys = [Constants.nullAgent]
                return
            }
            queryKeys = [target]
        }else{
            queryKeys = [Constants.nullAgent]
            return
        }
    }
    //T
    private func getAgentOptions()->[TAPF]{
        getAgentQueryKeys()
        getOptions(symbal:Constants.agentSymbal)
        return queriedOptions
    }
    //T
    private func getPolicyOrFeedbackQueryKeys(){
        if let target = routineEditBanner.targetRawText,
            let agent = routineEditBanner.agentRawText{
            guard target.count>1 && agent.count>1 else{
                queryKeys = [Constants.nullPolicy]
                return
            }
            var rawQueryKeys:[String] = [agent,target]
            rawQueryKeys+=policyAndFeedbacksView.lastTwoTokens
            queryKeys = AlgorithmUtils.getCombinedKeys(rawKeys: rawQueryKeys)
        }else{
            queryKeys = [Constants.nullPolicy]
            return
        }
    }
    //T
    private func getPolicyOptions()->[TAPF]{
        getPolicyOrFeedbackQueryKeys()
        getOptions(symbal:Constants.policySymbal)
        return queriedOptions
    }
    //T
    private func getFeedbackOptions()->[TAPF]{
        getPolicyOrFeedbackQueryKeys()
        getOptions(symbal:Constants.feedbackSymbal)
        return queriedOptions
    }
    
    //T
    private func showTargetInputHint(){
        optionView.optionEditView.switcherBtnTitle = Constants.targetLabel;
        optionView.optionEditView.inputEditHint = "请输入你的目标...";
    }
    //T
    private func showAgentInputHint(){
        optionView.optionEditView.switcherBtnTitle = Constants.agentLabel;
        optionView.optionEditView.inputEditHint = "请输入"+routineEditBanner.targetText!+"的对象...";
    }
    //T
    private func showPolicyInputHint(){
        optionView.optionEditView.switcherBtnTitle = Constants.policyLabel;
        optionView.optionEditView.inputEditHint = "请输入"+routineEditBanner.targetText!+"的策略...";
    }
    //T
    private func showFeedbackInputHint(){
        optionView.optionEditView.switcherBtnTitle = Constants.feedbackLabel;
        optionView.optionEditView.inputEditHint = "请输入"+routineEditBanner.agentText!+"的反馈...";
    }
}
//set key token
extension RoutineEditViewController{
    //T
    private func getkeyTokenOption(optRealm:Realm,cache:Bool,symbal:String,sql:String)->[TAPF]{
        let results = optRealm.objects(Token.self).filter(sql).sorted(byKeyPath: "frequency",ascending:false)
        var options:[TAPF]=[]
        for result in results{
            if cache{
                try! self.cacheRealm.write {
                    self.cacheRealm.create(Token.self,value:result,update:true)
                }
            }
            let tapf = TAPF()
            tapf.token = result.token
            tapf.symbal = result.symbal
            self.getTAPFType(tapf: tapf)
            
            options.append(tapf)
            if options.count>8{
                break
            }
        }
        return options
    }
    //T
    private func getkeyTokenOption(token:String,symbal:String){
        let sql = String(format:"keyToken LIKE '%@*%@*'",symbal,token )
        let optionList:[TAPF] = self.getkeyTokenOption(optRealm:self.cacheRealm,cache:false,symbal:symbal,sql:sql)
        if optionList.count>0 {
            self.optionView.optionList = optionList
            return
        }
        if let remoteRealm = self.remoteRealm{
            self.optionView.optionList = self.getkeyTokenOption(optRealm:remoteRealm,cache:true,symbal:symbal,sql:sql)
        }else{
            self.optionView.optionList = self.getkeyTokenOption(optRealm:self.localRealm,cache:false,symbal:symbal,sql:sql)
        }
    }
    private func updateKeyTokenModel(){
        var tokenUpdateList:[String] = []
        if keyIsNotUpdated(key:"TokenModel:"+mRoutine.target){
            tokenUpdateList.append(mRoutine.target)
        }
        for token in mRoutine.policyAndFeedbacks{
            guard keyIsNotUpdated(key:"TokenModel:"+token.keyToken) else{
                continue
            }
            tokenUpdateList.append(token.keyToken)
        }
        
        updateKeyTokenModel(tokenUpdateList:tokenUpdateList,optRealm:self.localRealm,remoteFlag :false)
        if let remoteRealm = self.remoteRealm{
            updateKeyTokenModel(tokenUpdateList:tokenUpdateList,optRealm:remoteRealm)
        }
    }
    private func updateKeyTokenModel(tokenUpdateList:[String],optRealm:Realm,remoteFlag:Bool = true){
        let tokenModel = optRealm.objects(Token.self)
        var userInfo:UserInfo!
        if remoteFlag{
            guard let remoteUserInfo = Watcher.RemoteUserInfo else {
                UserInfoUtil.loadUserInfo()
                return
            }
            userInfo = remoteUserInfo
        }else{
            guard let localUserInfo = Watcher.UserInfo else {
                UserInfoUtil.getUserInfo()
                return
            }
            userInfo = localUserInfo
        }
        
        try! optRealm.write {
            for token in tokenUpdateList{
                let tokenRet = tokenModel.filter("keyToken = '"+token+"'")
                if tokenRet.count>0{
                    tokenRet.first!.frequency += 1
                    if remoteFlag{
                        tokenRet.first!.userInfo!.point += 1
                    }
                    
                }else{
                    let newToken = Token()
                    newToken.keyToken = token
                    newToken.userInfo = userInfo
                    optRealm.create(Token.self,value:newToken,update:true)
                }
            }
        }
    }
}
//set get policy type
//T
extension RoutineEditViewController{
    //
    private func getTAPFType(optRealm:Realm,tapf:TAPF,target:String)->bayesReturnCode{
        
        let bayesModel = optRealm.objects(BayesKey.self).filter("key ='"+target+"'")
        guard bayesModel.count>0 else{
            return  bayesReturnCode.noExsit
        }
        guard  bayesModel.first!.all > Constants.confidentialNumber else {
            return  bayesReturnCode.notConfidential
        }
        
        let policyBayes = bayesModel.first!.queries.filter("query ='"+tapf.keyToken+"'")
        guard policyBayes.count==1 && policyBayes.first!.all > Constants.confidentialNumber else{
            return bayesReturnCode.notConfidential
        }
        
        let policyProbability = policyBayes.first!.positiveProbability
        let targetProbability = bayesModel.first!.positiveProbability
        
        tapf.showProb = policyProbability > 0 ?  Float(policyProbability):0.01
        let thresholder = CGFloat(Constants.badGoodPolicyThresholder)
        if targetProbability-policyProbability > thresholder{
            tapf.type = Constants.badType
        }else if policyProbability-targetProbability > thresholder{
            tapf.type = Constants.goodType
        }else{
            tapf.type = Constants.defaultType
        }
        return bayesReturnCode.success
    }
    
    //T
    private func getTAPFType(tapf:TAPF){
        guard tapf.symbal != Constants.targetSymbal else{
            return
        }
        var type:bayesReturnCode!
        
        guard let targetToken = routineEditBanner.targetRawText else{
            return
        }
        
        type = getTAPFType(optRealm:self.localRealm,tapf:tapf,target:targetToken)
        guard type != bayesReturnCode.success else{
            return
        }
        type = getTAPFType(optRealm:self.cacheRealm,tapf:tapf,target:targetToken)
        guard type == bayesReturnCode.noExsit else{
            return
        }
        
        guard let remoteRealm = self.remoteRealm else{
            return
        }
        type = getTAPFType(optRealm:remoteRealm,tapf:tapf,target:targetToken)
        guard type != bayesReturnCode.noExsit else{
            return
        }
        let bayesModel = remoteRealm.objects(BayesKey.self).filter("key ='"+targetToken+"'")
        try! self.cacheRealm.write {
            self.cacheRealm.create(BayesKey.self,value:bayesModel.first!,update:true)
        }
    }
    //T
    private func updateBayesModel(bayesUpdateList:Set<String>,target:String,optRealm:Realm,localFlag:Bool=false){
        guard let userInfo = Watcher.UserInfo else{
            return
        }
        
        let bayesModel = optRealm.objects(BayesKey.self).filter("key ='"+target+"'")
        var posAdd = 0
        var negAdd = 0
        if mRoutine.outcome==Constants.positiveOutcome{
            posAdd = localFlag ? 1 : userInfo.level + 1
        }else{
            negAdd = localFlag ? 1 : userInfo.level + 1
        }
        guard bayesModel.count > 0 else{
            let newBayesKey = BayesKey()
            newBayesKey.key = target
            newBayesKey.positive=posAdd
            newBayesKey.negtive=negAdd
            for tapfToken in bayesUpdateList{
                let newQuery = BayesQuery()
                newQuery.query = tapfToken
                newQuery.positive = posAdd
                newQuery.negtive = negAdd
                newBayesKey.queries.append(newQuery)
            }
            
            try! optRealm.write {
                optRealm.add(newBayesKey)
            }
            return
        }
        try! optRealm.write {
            bayesModel.first!.positive += posAdd
            bayesModel.first!.negtive += negAdd
            
            let queries = bayesModel.first!.queries
            
            for tapfToken in bayesUpdateList{
                let query = queries.filter("query = '"+tapfToken+"'")
                if query.count==0 {
                    let newQuery = BayesQuery()
                    newQuery.query = tapfToken
                    newQuery.positive = posAdd
                    newQuery.negtive = negAdd
                    queries.append(newQuery)
                }else{
                    query.first!.positive += posAdd
                    query.first!.negtive += negAdd
                }
            }
        }
    }
    //  T
    private func updateBayesModel(){
        var localBayesUpdateList:Set<String>=Set()
        var bayesUpdateList:Set<String>=Set()
        for policyOrFeedback in mRoutine.policyAndFeedbacks{
            let token = policyOrFeedback.keyToken
            localBayesUpdateList.insert(token)
            guard keyIsNotUpdated(key:"BayesModel:"+token)else{
                
                continue
            }
            bayesUpdateList.insert(token)
        }
        localBayesUpdateList.insert(mRoutine.agent)
        updateBayesModel(bayesUpdateList:localBayesUpdateList,target:mRoutine.target,optRealm:self.localRealm,localFlag:true)
        guard bayesUpdateList.count>0 else{
            return
        }
        bayesUpdateList.insert(mRoutine.agent)
        
        if let remoteRealm = self.remoteRealm{
            updateBayesModel(bayesUpdateList:bayesUpdateList,target:mRoutine.target,optRealm:remoteRealm)
        }
    }
}
//add listener or action
//T
extension RoutineEditViewController{
    //T
    @objc private func tapSingleDid(_ sender:UITapGestureRecognizer){
        showInputHint()
        updateOptions()
        showOptionList()
    }
    //T
    private func addGestureListener(){
        let tapSingle=UITapGestureRecognizer(target:self,action:#selector(tapSingleDid))
        tapSingle.numberOfTapsRequired = 1
        tapSingle.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tapSingle)
    }
    
    
    //T
    @IBAction func backToRoutineList() {
        
        if needSaveFlag(){
            let saveAlter = UIAlertController(title: nil, message: "不保存该套路吗？",preferredStyle:.alert)
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
            let okAction = UIAlertAction(title: "不保存", style: UIAlertActionStyle.default, handler:  {(action: UIAlertAction!)->Void in
                self.presentingViewController!.dismiss(animated: true, completion: nil)
            })
            saveAlter.addAction(okAction)
            saveAlter.addAction(cancelAction)
            self.present(saveAlter, animated: true, completion: nil)
        }else{
            self.presentingViewController!.dismiss(animated: true, completion: nil)
        }
    }
    //T
    @IBAction func dropLastOne() {
        policyAndFeedbacksView.dropLastOne()
        routineEditBanner.dropLastProbability()
    }
}
//delegates
//T
extension RoutineEditViewController:OptionViewDelegate{
    //T
    func chooseOption(choosed:TAPF){
        showOption(tapf:choosed)
        updateOptions()
    }
    //T
    func switchOption(){
        switch optionView.optionEditView.switcherBtnTitle {
        case Constants.policyLabel?:
            showFeedbackInputHint()
            break;
        case Constants.feedbackLabel?:
            showPolicyInputHint()
            break;
        default:
            break;
        }
        updateOptions()
    }
    //T
    func editTarget(){
        showTargetInputHint()
        updateOptions()
        showOptionList()
    }
    //T
    func editAgent(){
        showAgentInputHint()
        updateOptions()
        showOptionList()
    }
    //T
    func enterOption(enterToken:String){
        let tapf = TAPF()
        tapf.token = enterToken
        switch optionView.optionEditView.switcherBtnTitle{
        case Constants.targetLabel?:
            tapf.symbal = Constants.targetSymbal;
            break;
        case Constants.agentLabel?:
            tapf.symbal = Constants.agentSymbal;
            
            break;
        case Constants.policyLabel?:
            tapf.symbal = Constants.policySymbal;
            
            break;
        case Constants.feedbackLabel?:
            tapf.symbal = Constants.feedbackSymbal;
            
            break;
        default:
            break;
        }
        getTAPFType(tapf: tapf)
        showOption(tapf: tapf)
        updateOptions()
    }
    
    //T
    func listOption(enterToken: String) {
        guard enterToken.count>0 else{
            updateOptions()
            return
        }
        switch optionView.optionEditView.switcherBtnTitle{
        case Constants.targetLabel?:
            getkeyTokenOption(token: enterToken,symbal: Constants.targetSymbal);
            break;
        case Constants.agentLabel?:
            getkeyTokenOption(token: enterToken,symbal: Constants.agentSymbal);
            break;
        case Constants.policyLabel?:
            getkeyTokenOption(token: enterToken,symbal: Constants.policySymbal);
            break;
        case Constants.feedbackLabel?:
            getkeyTokenOption(token: enterToken,symbal: Constants.feedbackSymbal);
            break;
        default:
            break;
        }
    }
    
}
//save routine
//T
extension RoutineEditViewController {
    
    @IBAction func saveRoutine() {
        if needSaveFlag(){
            showOutcomeChooser()
        }else{
            showAlterView(message:"套路不完整，无法保存")
        }
    }
    //T
    private func saveRoutine(outcome:String){
        mRoutine.outcome = outcome
        mRoutine.agent = routineEditBanner.agentRawText!
        mRoutine.target = routineEditBanner.targetRawText!
        mRoutine.policyAndFeedbacks.append(objectsIn: policyAndFeedbacksView.savedPolicyAndFeedbacks)
        let chatTarget = mRoutine.target.substring(from:1)
        let filterSql = String(format: "target = '%@'", chatTarget)
        let chat = localRealm.objects(Chat.self).filter(filterSql)
        if chat.count == 0 {
            let newChat = Chat()
            newChat.target = chatTarget
            try! localRealm.write {
                localRealm.add(newChat)
            }
        }
        try! localRealm.write {
            localRealm.add(mRoutine)
        }
        updateBayesModel()
        updateKeyTokenModel()
        self.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    //T
    private func showOutcomeChooser(){
        let saveAlter = UIAlertController(title: "你对本次套路满意吗？", message: "",preferredStyle:.alert)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        let positiveBtn = UIAlertAction(title: "满意", style: UIAlertActionStyle.default, handler:  {(action: UIAlertAction!)->Void in
            self.saveRoutine(outcome: Constants.positiveOutcome)
        })
        let negtiveBtn = UIAlertAction(title: "不满意", style: UIAlertActionStyle.default, handler:  {(action: UIAlertAction!)->Void in
            self.saveRoutine(outcome: Constants.negtiveOutcome)
        })
        saveAlter.addAction(positiveBtn)
        saveAlter.addAction(negtiveBtn)
        saveAlter.addAction(cancelAction)
        self.present(saveAlter, animated: true, completion: nil)
    }
    //T
    private func needSaveFlag()->Bool{
        if routineEditBanner.targetEdited && routineEditBanner.agentEdited && policyAndFeedbacksView.isPolicyAndFeedbackEdited{
            return true
        }
        return false
    }
}
