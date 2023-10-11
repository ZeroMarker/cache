$(function(){
    if (emrDocIDs[0] != ""){
        if (getRecordData()){
            getTempCateData();
        }
    }else{
        setMessage('未获取到病历参数，请检查系统参数CollectMedicalRecordConfig配置!','info');
    }
});
//获取病历数据
function getRecordData(){
    var rtn = false;
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType": "Stream",
            "Class": "EMRservice.BL.BLClientCategory",
            "Method": "GetParamJsonByDocID",
            "p1": emrDocIDs[0],
            "p2": parent.episodeID
        },
        success: function(d) {
            if (d != "") {
                recordParam = JSON.parse(d);
                rtn = true;
            }
        },
        error: function() { 
            alert("getRecordData error");
        }
    });
    return rtn;
}
//获取模板数据
function getTempCateData(){
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType": "Stream",
            "Class": "EMRservice.BL.BLClientCategory",
            "Method": "GetTempCateJsonByDocID",
            "p1": emrDocIDs[1],
            "p2": recordParam.id
        },
        success: function(d) {
            if (d != "") {
                debugger;
                tempParam = JSON.parse(d);
                doCreate();
            }
        },
        error: function() { 
            alert("getTempCateData error");
        }
    });
}
//创建
function doCreate()
{
    if (tempParam.pluginType == "GRID")
    {
        if (!girdDoc()){
            return false;
        }
    }
    else
    {
        setMessage("插件创建失败",'warning');
        return false;
    }
    setProductSource();
    setPatientInfo();
    var isMutex = (tempParam.isMutex=="1")?true:false;
    var isGuideBox = (tempParam.isLeadframe == "1")?true:false;
    setDocTempalte(tempParam.emrDocId,isMutex,isGuideBox); 
    createDocument();
}
//创建gird编辑器
function girdDoc()
{
    var result = true;
    var igrid = plugingrid();
    if(igrid==null || igrid.innerHTML== undefined || !igridFlag)
    {
        var objString = "<object id='pluginGridPrint' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'>";         
        objString = objString + "<param name='install-url' value='" + pluginUrl + "'/>";
        objString = objString + "<param name='product' value='GlobalEMR'/>";
        objString = objString + "</object>";
        document.getElementById("collectGrid").innerHTML = objString;  
        if (!plugingrid()||!plugingrid().valid)
        {
            setUpPlug();
            return;
        }  
        pluginAdd(); 
        var ret = plugingrid().initWindow("iGridEditor");
        if (!ret)
        {
            setMessage('创建编辑器失败!','warning');
            result = false;
            return result;
        }              
        var nectresult = setConnect();
        if (nectresult != "" && nectresult.result != "OK")
        {
            setMessage('数据库连接失败!','warning');
            result = false;
            return result;
        }
        igridFlag = true;
        setRunEMRParams();
    }
    return result;
}
function plugingrid()
{
    return document.getElementById("pluginGridPrint");
}
//安装插件提示
function setUpPlug (){
    var iframeContent = "<iframe id='iframeDownloadPlugin' scrolling='auto' frameborder='0' src='emr.record.downloadplugin.csp?PluginUrl=" +base64encode(utf16to8(encodeURI(pluginUrl)))+"&openWay=editor' style='width:290px; height:140px; display:block;'></iframe>";
    createModalDialog("downloadPluginDialog",emrTrans("下载插件"),310,180,"iframeDownloadPlugin",iframeContent,setUpPlugCallBack,"");
};
function setUpPlugCallBack(returnValue,arr)
{
    if (returnValue)
    {
        window.location.reload();
    }
}
//查找插件
function plugin() {
    if(tempParam.pluginType == "DOC")
    {
        return "";
    }
    else
    {
        return plugingrid();
    }
}
//挂接插件\事件监听
function pluginAdd() {
    addEvent(plugin(), 'onFailure', function(command){
        alert(command);
    });
    addEvent(plugin(), 'onExecute', function(command){
       var commandJson = jQuery.parseJSON(command);
       eventDispatch(commandJson);
    });
}
//添加监听事件
function addEvent(obj, name, func)
{
    if (obj.attachEvent) 
    {
        obj.attachEvent("on"+name, func);
    }  
    else 
    {
        obj.addEventListener(name, func, false); 
    }
}
//异步执行execute
function cmdDoExecute(argJson){
    plugin().execute(JSON.stringify(argJson));
};
//同步执行execute
function cmdSyncExecute(argJson){
    var result = plugin().syncExecute(JSON.stringify(argJson));
    try
    {
        result = jQuery.parseJSON(result);
    }
    catch(err)
    {
        result = "";
    }
    return result;
}
//建立数据库连接
function setConnect(){
    var netConnect = "";
    var port = window.location.port;
    var protocol = window.location.protocol.split(":")[0];
    
    if (protocol == "http")
    {
        port = port==""?"80":port;
    }
    else if (protocol == "https")
    {
        port = port==""?"443":port;
    }
    
    $.ajax({
        type: 'Post',
        dataType: 'text',
        url: '../EMRservice.Ajax.common.cls',
        async: false,
        cache: false,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLSysOption",
            "Method":"GetNetConnectJson",
            "p1":window.location.hostname,
            "p2":port,
            "p3":protocol
        },
        success: function (ret) {

            netConnect = eval("("+ret+")");
        },
        error: function (ret) {
            alert('setConnect error');
            if (!onError) {}
            else {
                onError(ret);
            }
        }
    });
    var strJson = {action:"SET_NET_CONNECT",args:netConnect};
    return cmdSyncExecute(strJson);
}
//设置电子病历运行环境参数
function setRunEMRParams()
{
    $.ajax({
        type: 'GET',
        dataType: 'text',
        url: '../EMRservice.Ajax.common.cls',
        async: false,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLSysOption",
            "Method":"GetRunEMRParams"
        },
        success: function (ret) {
            if (ret != "") {
                result = eval("("+ret+")");
                cmdDoExecute(result);
            }
        },
        error: function (ret) {
            alert('setRunEMRParams error');
        }
    });
}
//设置患者信息
function setPatientInfo()
{
    var argParams = {"DiseaseID":"0","PatientID":parent.patientID,"EpisodeID":parent.episodeID,"UserCode":parent.userCode,"SessionID":parent.sessionID,"UserID":parent.userID,"UserName":parent.userName,"SsgroupID":parent.ssgroupID,"UserLocID":parent.userLocID,"IPAddress":parent.ipAddress,"HospitalID":parent.hospitalID};
    var argJson = {action: "SET_PATIENT_INFO",args:argParams};
    cmdDoExecute(argJson);
}
//设置调用的产品模块的信息
function setProductSource()
{
    var argJson = {action: "SET_PATIENT_INFO",args:{"ProductSourceType":parent.productSourceType,"ProductSourceCode":parent.productSourceCode}};
    cmdDoExecute(argJson);
}
//设置创建模板
function setDocTempalte(emrDocId,isMutex,isGuideBox)
{
    var argJson = {action:"SET_DOCUMENT_TEMPLATE",args:{DocID:emrDocId,IsMutex:isMutex,CreateGuideBox:isGuideBox,"KBLoadMode":"Replace"}};
    cmdDoExecute(argJson);
}
//创建病历
function createDocument()
{
    var strJson = {action:"CREATE_DOCUMENT",args:{"params":{"TemplateID":tempParam.templateId,"TemplateVersion":tempParam.templateVersion},"Title":{"DisplayName":tempParam.text}}};
    cmdDoExecute(strJson);
}
//事件派发
function eventDispatch(commandJson)
{
    if (commandJson["action"] == "eventCreateDocument")
    {
        eventCreateDocument(commandJson);
    }else if (commandJson["action"] == "eventPrintDocument")
    {
        eventPrintDocument(commandJson);
    }
}
//创建文档事件
function eventCreateDocument(commandJson)
{
    if (commandJson["args"]["result"] == "OK")
    {
        var argJson = {"action":"PREVIEW_DOCUMENT","args":{"Preview":true}};
        cmdDoExecute(argJson);
        var returnValue = getRecordData();
        if (returnValue) {
            if (action == "print"){
                argJson = {action:"PRINT_DOCUMENT",args:{"actionType":"PrintDirectly","InstanceID":recordParam.id,"params":{"TemplateID":tempParam.templateId,"TemplateVersion":tempParam.templateVersion}}};
                cmdDoExecute(argJson);
            }
        }
    }
}
//文档打印事件
function eventPrintDocument(commandJson)
{
    if (commandJson["args"].result == "OK")
    {
        if (commandJson["args"].params.result == "OK")
        {
            if (typeof(parent.reloadMenu) == "function")
            {
                parent.reloadMenu(recordParam.id);
            }
            //基础平台组审计和日志记录
            setOperationLog(recordParam,"EMR.Print.OK");
            //关闭页面
            parent.closeDialog(dialogID);
        }else if(commandJson["args"].params.result == "ERROR")
        {
            setMessage('打印日志未记录,请检查网络连接!','warning');
        }
    }else if(commandJson["args"].result == "ERROR")
    {
        //插件返回值只有2个 
        //OK 打印成功 
        //ERROR，可能为取消打印，或网络原因导致打印失败。
        //修改描述'打印日志未记录,请检查网络连接!' 为‘打印操作未完成’，增加友好度。
        setMessage('打印操作未完成!','warning');
    }
}
//保存日志(基础平台组)
function setOperationLog(params,ModelName)
{
    if (IsSetToLog == "Y")
    {
        var Condition = "";
        Condition = Condition + '{"patientID":"' + parent.patientID + '",';
        Condition = Condition + '"episodeID":"' + parent.episodeID + '",';
        Condition = Condition + '"userName":"' + parent.userName + '",';
        Condition = Condition + '"userID":"' + parent.userID + '",';
        Condition = Condition + '"ipAddress":"' + parent.ipAddress + '",';
        Condition = Condition + '"id":"' + params["id"] + '",';
        Condition = Condition + '"pluginType":"' + params["pluginType"] + '",';
        Condition = Condition + '"chartItemType":"' + params["chartItemType"] + '",';
        Condition = Condition + '"emrDocId":"' + params["emrDocId"] + '",';
        Condition = Condition + '"templateId":"' + params["templateId"] + '",';
        Condition = Condition + '"categoryId":"' + params["categoryId"] + '",';
        Condition = Condition + '"isLeadframe":"' + params["isLeadframe"] + '",';
        Condition = Condition + '"isMutex":"' + params["isMutex"] + '",';
        Condition = Condition + '"actionType":"' + params["actionType"] + '",';
        Condition = Condition + '"status":"' + params["status"] + '",';
        Condition = Condition + '"text":"' + params["text"] + '"}';
        var ConditionAndContent = Condition;
        $.ajax({ 
            type: "POST", 
            url: "../EMRservice.Ajax.SetDataToEventLog.cls", 
            data: "ModelName="+ ModelName + "&ConditionAndContent=" + ConditionAndContent + "&SecCode=" + SecCode
        });
    }
}
//将提示消息发送到消息提示区
function setMessage(message,type)
{
    var tmptype = "info";
    if (type == "alert")
    {
        tmptype = "success";
    }
    else if(type == "forbid")
    {
        tmptype = "error";
    }
    else if (type == "warning")
    {
        tmptype = "alert"
    }
    top.$.messager.popover({msg: emrTrans(message),type:tmptype,timeout:messageScheme[type],style:{top:20,left:document.documentElement.clientWidth/2}});
}
