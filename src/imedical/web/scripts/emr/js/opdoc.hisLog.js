//记录病历行为操作日志
var hisLog;

function HisLogEx(IsSetToLog, patientInfo) {

    function setDataToEventLog(ModelName, ConditionAndContent, SecCode) {
        $.ajax({
            type: "POST",
            url: "../EMRservice.Ajax.SetDataToEventLog.cls",
            data: "ModelName=" + ModelName + "&ConditionAndContent=" + ConditionAndContent + "&SecCode=" + SecCode
        });
    }

    function setCondition(){
        var condition = {
            patientID: patientInfo.PatientID,
            episodeID: patientInfo.EpisodeID,
            userName: patientInfo.UserName,
            userID: patientInfo.UserID,
            ipAddress: patientInfo.IPAddress
        };
        return condition;
    }

    //电子病历.登录 'EMR.OP.Login'
    this.login = function () {
        if (('' === patientInfo.EpisodeID)||('' === patientInfo.UserID)||(IsSetToLog !== 'Y')) return;
        var ModelName = 'EMR.OP.Login';
        var condition = setCondition();
        setDataToEventLog(ModelName, JSON.stringify(condition), patientInfo.SecCode);
    }
    //电子病历.门诊.病历新建 'EMR.OP.CreateDoc'
    //电子病历.门诊.范例病历.病历新建 'EMR.OP.ModelInstance.CreateDoc'
    //电子病历.门诊.历史就诊.病历新建 'EMR.OP.AdmHistoryLst.CreateDoc'
    this.create = function (ModelName, docParam) {
        if (('' === patientInfo.EpisodeID)||('' === patientInfo.UserID)||(IsSetToLog !== 'Y')) return;
        var condition = setCondition();
        condition['id'] = '';
        condition['pluginType'] = docParam.pluginType;
        condition['chartItemType'] = docParam.chartItemType;
        condition['emrDocId'] = docParam.emrDocId;
        condition['templateId'] = docParam.templateId;
        condition['categoryId'] = docParam.categoryId;
        condition['isLeadframe'] = docParam.isLeadframe;
        condition['isMutex'] = docParam.isMutex;
        condition['actionType'] = docParam.actionType;
        condition['status'] = docParam.status;
        condition['text'] = docParam.text;
        if (docParam.actionType === "QUOTATION") condition['pInstanceId'] = docParam.id;
        setDataToEventLog(ModelName, JSON.stringify(condition), patientInfo.SecCode);
    }
    //电子病历.门诊.病历打开 'EMR.OP.LoadDoc'
    //电子病历.门诊.保存.确定 'EMR.OP.Save.OK'
    //电子病历.门诊.打印.确定 'EMR.OP.Print.OK'
    //电子病历.门诊.删除.确定 'EMR.OP.Delete.OK'
    //电子病历.门诊.签名.确定 'EMR.OP.Sign.OK'
    //电子病历.门诊.刷新绑定 'EMR.OP.BinddataReload'
    //电子病历.门诊.病历导出.保存 'EMR.OP.Export.Save'
    this.operate = function (ModelName, docParam) {
        if (('' === patientInfo.EpisodeID)||('' === patientInfo.UserID)||(IsSetToLog !== 'Y')) return;
        var condition = setCondition();
        condition['id'] = docParam.id;
        condition['pluginType'] = docParam.pluginType;
        condition['chartItemType'] = docParam.chartItemType;
        condition['emrDocId'] = docParam.emrDocId;
        condition['templateId'] = docParam.templateId;
        condition['categoryId'] = docParam.categoryId;
        condition['isLeadframe'] = docParam.isLeadframe;
        condition['isMutex'] = docParam.isMutex;
        condition['actionType'] = docParam.actionType;
        condition['status'] = docParam.status;
        condition['text'] = docParam.text;
        setDataToEventLog(ModelName, JSON.stringify(condition), patientInfo.SecCode);
    }
    //电子病历.病历参考.参考导航.打开 'EMR.Reference.ReferenceNav.Open'
    this.reference = function (docParam) {
        if (('' === patientInfo.EpisodeID)||('' === patientInfo.UserID)||(IsSetToLog !== 'Y')) return;
        var ModelName = 'EMR.Reference.ReferenceNav.Open';
        var condition = setCondition();
        condition['id'] = docParam.id;
        condition['pluginType'] = docParam.pluginType;
        condition['chartItemType'] = docParam.chartItemType;
        condition['emrDocId'] = docParam.emrDocId;
        condition['templateId'] = docParam.templateId;
        condition['categoryId'] = docParam.categoryId;
        condition['isLeadframe'] = docParam.isLeadframe;
        condition['isMutex'] = docParam.isMutex;
        condition['summary'] = docParam.summary;
        condition['status'] = docParam.status;
        condition['creator'] = docParam.creator;
        condition['happendate'] = docParam.happendate;
        condition['happentime'] = docParam.happentime;
        condition['text'] = docParam.text;
        setDataToEventLog(ModelName, JSON.stringify(condition), patientInfo.SecCode);
    }
    //电子病历.添加收藏.确定 'EMR.FavoritesAdd.OK'
    this.favoritesAdd = function (docParam, tags, catalogId) {
        if (('' === patientInfo.EpisodeID)||('' === patientInfo.UserID)||(IsSetToLog !== 'Y')) return;
        if (docParam.categoryId === '' && docParam.templateId === '') return;
        var ModelName = 'EMR.FavoritesAdd.OK';
        var condition = setCondition();
        condition['InstanceID'] = docParam.id;
        condition['categoryId'] = docParam.categoryId;
        condition['templateId'] = docParam.templateId;
        condition['Tags'] = tags;
        condition['CatalogID'] = catalogId;
        setDataToEventLog(ModelName, JSON.stringify(condition), '');
    }
    //电子病历.打开收藏夹 'EMR.Favorites.Login'
    this.favoritesLogin = function () {
        if (('' === patientInfo.EpisodeID)||('' === patientInfo.UserID)||(IsSetToLog !== 'Y')) return;
        var ModelName = 'EMR.Favorites.Login';
        var condition = setCondition();
        setDataToEventLog(ModelName, JSON.stringify(condition), patientInfo.SecCode);
    }
    //电子病历.门诊.锁.解锁 'EMR.OP.UnLock.UnLock'
    this.unlock = function (LockID) {
        if (('' === patientInfo.EpisodeID)||('' === patientInfo.UserID)||(IsSetToLog !== 'Y')) return;
        var ModelName = 'EMR.OP.UnLock.UnLock';
        var condition = setCondition();
        condition['LockID'] = LockID;
        setDataToEventLog(ModelName, JSON.stringify(condition), patientInfo.SecCode);
    }
    //电子病历.门诊.锁.加锁 'EMR.OP.UnLock.Lock'
    this.lock = function (LockID, LockInsID) {
        if (('' === patientInfo.EpisodeID)||('' === patientInfo.UserID)||(IsSetToLog !== 'Y')) return;
        var ModelName = 'EMR.OP.UnLock.Lock';
        
        if (('' === patientInfo.EpisodeID)||('' === patientInfo.UserID)||(IsSetToLog !== 'Y')) return;
        var condition = setCondition();
        condition['id'] = LockInsID;
        condition['LockID'] = LockID;
        setDataToEventLog(ModelName, JSON.stringify(condition), patientInfo.SecCode);
    }
    //电子病历.门诊.病历浏览 'EMR.OP.Browse'
    //电子病历.门诊.历史就诊.病历浏览 'EMR.OP.AdmHistoryLst.Browse'
    this.browse = function (ModelName, docParam) {
        if (('' === patientInfo.EpisodeID)||('' === patientInfo.UserID)||(IsSetToLog !== 'Y')) return;
        var condition = setCondition();
        condition['id'] = docParam.id;
        condition['pluginType'] = docParam.pluginType;
        condition['chartItemType'] = docParam.chartItemType;
        condition['emrDocId'] = docParam.emrDocId;
        condition['status'] = docParam.status;
        condition['text'] = docParam.text;
        setDataToEventLog(ModelName, JSON.stringify(condition), '');
    }
}

///集中平台日志
/// action: EMR.Save \ EMR.Sign.OK \ EMR.Print.OK \ EMR.Delete.OK
function setEMRDocmentQueue(insID, action) {
    try {
        var data = ajaxDATA('String', 'EMRservice.BIEMRService', 'UpdateEMRDocumentQueue', insID, action);
        ajaxGET(data);
    } catch(e){
        //$.messager.alert('发生错误', e.message, 'error');
        alert(e.message);
    }
}
