//记录病历行为操作日志
var hisLog;

function HisLogEx() {

    function setDataToEventLog(modelName, condition, secCode) {
        var data = {
            action: "SET_EVENTLOG",
            product: envVar.product
        };
        data.params = condition;
        data.modelName = modelName;
        data.secCode = secCode;
        ajaxPOSTCommon(data, function(ret){
            if (!ret){
                showEditorMsg({msg:"记录病历行为操作日志失败！",type:"error"});
            }
        }, function (error) {
            $.messager.alert("发生错误", "setDataToEventLog error:"+error, "error");
        }, true);
    }

    function setCondition(){
        var condition = {
            patientID: patInfo.patientID,
            episodeID: patInfo.episodeID,
            userName: patInfo.userName,
            userID: patInfo.userID,
            ipAddress: patInfo.ipAddress
        };
        return condition;
    }

    //电子病历.登录 'EMR.OP.Login'
    this.login = function () {
        if (("" === patInfo.episodeID)||("" === patInfo.userID)||("Y" !== sysOption.setLog)) return;
        var condition = setCondition();
        setDataToEventLog("EMR.OP.Login", condition, patInfo.secCode);
    }
    //电子病历.门诊.病历新建 'EMR.OP.CreateDoc'
    //电子病历.门诊.范例病历.病历新建 'EMR.OP.ModelInstance.CreateDoc'
    //电子病历.门诊.历史就诊.病历新建 'EMR.OP.AdmHistoryLst.CreateDoc'
    this.create = function (modelName, docParam) {
        if (("" === patInfo.episodeID)||("" === patInfo.userID)||("Y" !== sysOption.setLog)) return;
        var condition = setCondition();
        condition["documentID"] = "";
        condition["chartItemType"] = docParam.chartItemType;
        condition["templateID"] = docParam.templateID;
        condition["templateCategoryID"] = docParam.templateCategoryID;
        condition["isLeadframe"] = docParam.isLeadframe;
        condition["isMutex"] = docParam.isMutex;
        condition["actionType"] = docParam.actionType;
        condition["status"] = docParam.status;
        condition["text"] = docParam.docName;
        if (docParam.actionType === "QUOTATION") condition['pDocumentID'] = docParam.documentID;
        setDataToEventLog(modelName, condition, patInfo.secCode);
    }
    //电子病历.门诊.病历打开 'EMR.OP.LoadDoc'
    //电子病历.门诊.保存.确定 'EMR.OP.Save.OK'
    //电子病历.门诊.打印.确定 'EMR.OP.Print.OK'
    //电子病历.门诊.删除.确定 'EMR.OP.Delete.OK'
    //电子病历.门诊.签名.确定 'EMR.OP.Sign.OK'
    //电子病历.门诊.刷新绑定 'EMR.OP.BinddataReload'
    //电子病历.门诊.病历导出.保存 'EMR.OP.Export.Save'
    this.operate = function (modelName, docParam) {
        if (("" === patInfo.episodeID)||("" === patInfo.userID)||("Y" !== sysOption.setLog)||("" === docParam)) return;
        var condition = setCondition();
        condition["documentID"] = docParam.documentID;
        condition["chartItemType"] = docParam.chartItemType;
        condition["templateID"] = docParam.templateID;
        condition["templateCategoryID"] = docParam.templateCategoryID;
        condition["isLeadframe"] = docParam.isLeadframe;
        condition["isMutex"] = docParam.isMutex;
        condition["actionType"] = docParam.actionType;
        condition["status"] = docParam.status;
        condition["text"] = docParam.docName;
        setDataToEventLog(modelName, condition, patInfo.secCode);
    }
    //电子病历.病历参考.参考导航.打开 'EMR.Reference.ReferenceNav.Open'
    this.reference = function (docParam) {
        if (("" === patInfo.episodeID)||("" === patInfo.userID)||("Y" !== sysOption.setLog)) return;
        var condition = setCondition();
        condition["documentID"] = docParam.documentID;
        condition["chartItemType"] = docParam.chartItemType;
        condition["templateID"] = docParam.templateID;
        condition["templateCategoryID"] = docParam.templateCategoryID;
        condition["isLeadframe"] = docParam.isLeadframe;
        condition["isMutex"] = docParam.isMutex;
        condition["summary"] = docParam.summary;
        condition["status"] = docParam.status;
        condition["creator"] = docParam.creator;
        condition["happendate"] = docParam.happendate;
        condition["happentime"] = docParam.happentime;
        condition["text"] = docParam.docName;
        setDataToEventLog("EMR.Reference.ReferenceNav.Open", condition, patInfo.secCode);
    }
    //电子病历.添加收藏.确定 'EMR.FavoritesAdd.OK'
    this.favoritesAdd = function (docParam, tags, catalogId) {
        if (("" === patInfo.episodeID)||("" === patInfo.userID)||("Y" !== sysOption.setLog)) return;
        if ("" === docParam.templateCategoryID && "" === docParam.templateID) return;
        var condition = setCondition();
        condition["documentID"] = docParam.documentID;
        condition["templateCategoryID"] = docParam.templateCategoryID;
        condition["templateID"] = docParam.templateID;
        condition["tags"] = tags;
        condition["catalogID"] = catalogId;
        setDataToEventLog("EMR.FavoritesAdd.OK", condition, "");
    }
    //电子病历.打开收藏夹 'EMR.Favorites.Login'
    this.favoritesLogin = function () {
        if (("" === patInfo.episodeID)||("" === patInfo.userID)||("Y" !== sysOption.setLog)) return;
        var condition = setCondition();
        setDataToEventLog("EMR.Favorites.Login", condition, patInfo.secCode);
    }
    //电子病历.手工解锁.解锁 'EMR.UnLock.UnLock'
    this.unlock = function (lockListrow) {
        if (("" === patInfo.episodeID)||("" === patInfo.userID)||("Y" !== sysOption.setLog)) return;
        var condition = {
            LockID: lockListrow.ID,
            LockUserID: lockListrow.UserID,
            LockUserCode: lockListrow.UserCode,
            LockUserName: lockListrow.UserName,
            LockComputer: lockListrow.Computer,
            LockDateTime: lockListrow.LockDateTime,
            Action: lockListrow.Action,
            episodeID: patInfo.episodeID,
            LockDocID: lockListrow.DocID,
            LockDocName: lockListrow.DocName,
            templateCategoryID: lockListrow.templateCategoryID,
            templateID: lockListrow.templateID,
            userName: patInfo.userName,
            userID: patInfo.userID,
            ipAddress: patInfo.ipAddress
        };
        setDataToEventLog("EMR.UnLock.UnLock", condition, patInfo.secCode);
    }
    //电子病历.病历编辑.加锁 'EMR.UnLock.Lock'
    this.lock = function (LockID, LockDocID) {
        if (("" === patInfo.episodeID)||("" === patInfo.userID)||("Y" !== sysOption.setLog)) return;
        var condition = {
            LockID: LockID,
            episodeID: patInfo.episodeID,
            LockDocID: LockDocID,
            userName: patInfo.userName,
            userID: patInfo.userID,
            ipAddress: patInfo.ipAddress
        };
        setDataToEventLog("EMR.UnLock.Lock", condition, patInfo.secCode);
    }
    //电子病历.门诊.病历浏览 'EMR.OP.Browse'
    //电子病历.门诊.历史就诊.病历浏览 'EMR.OP.AdmHistoryLst.Browse'
    this.browse = function (modelName, docParam) {
        if (("" === patInfo.episodeID)||("" === patInfo.userID)||("Y" !== sysOption.setLog)) return;
        var condition = setCondition();
        condition["documentID"] = docParam.documentID;
        condition["chartItemType"] = docParam.chartItemType;
        condition["status"] = docParam.status;
        condition["text"] = docParam.dcoName;
        setDataToEventLog(modelName, condition, "");
    }
}

///集中平台日志
/// action: EMR.Save \ EMR.Sign.OK \ EMR.Print.OK \ EMR.Delete.OK
/*function setEMRDocmentQueue(insID, action) {
    try {
        var data = ajaxDATA('String', 'EMRservice.BIEMRService', 'UpdateEMRDocumentQueue', insID, action);
        ajaxGET(data);
    } catch(e){
        //$.messager.alert('发生错误', e.message, 'error');
        alert(e.message);
    }
}*/
