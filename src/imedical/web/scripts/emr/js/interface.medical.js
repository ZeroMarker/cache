$(function(){
    InitDocument(recordParam);
});
//初始化页面
function InitDocument(tempParam)
{
    if (tempParam.actionType=="LOAD")
    {
        doOpen(tempParam);
        getInstanceInfo(tempParam.id);
    }
    else
    {
        if (!doCreate(tempParam)) return;
    }
}

function doCreate(tempParam)
{
    var result = false;
    pluginType = tempParam.pluginType
    //加载编辑器
    if (pluginType == "DOC")
    {
        if (!wordDoc(tempParam)) return false;
    }
    else if (pluginType == "GRID")
    {
        if (!girdDoc(tempParam)) return false;
    }
    else
    {
        alert("插件创建失败");
        return false;
    }
    if (tempParam.isLeadframe != "1")
    {
        result = doSignleCreate(tempParam);
    }
    else
    {
        result = doMultiplyCreate(tempParam);
    }
    return result;
}

//单文档创建
function doSignleCreate(tempParam)
{
    var result = false;
    id = IsExitInstance(tempParam.emrDocId,tempParam.templateId);
    if (id != "0" && tempParam.chartItemType == "Single")
    {
        //alert('已经创建该类型病历,不能再次创建!');
        tempParam.id = id;
        tempParam.actionType = "Load";
        doOpen(tempParam);
        getInstanceInfo(tempParam.id);
        return result;	
    }
    if ((param != "")&&(tempParam.emrDocId == param.emrDocId)&&(tempParam.chartItemType == "Single"))
    {
        alert('该类型病历正在创建,不能多次创建!');
        return result;		
    }
    if ((param != "")&&(tempParam.categoryId == param.categoryId)&&(param.isMutex == "1")&&(tempParam.isMutex == "1"))
    {
        alert('已经创建该类型病历,不能再次创建!');
        return result;
    }
    if (tempParam.pluginType == "DOC") setWorkEnvironment(tempParam);
    setPatientInfo(tempParam); 
    var isMutex = (tempParam.isMutex=="1")?true:false;
    var isGuideBox = (tempParam.isLeadframe == "1")?true:false;
    setDocTempalte(tempParam.emrDocId,isMutex,isGuideBox); //设置引导框
    createDocument(tempParam);
    result = true;
    return result;
}

///多文档加载
function doMultiplyCreate(tempParam)
{
    var result = false;
    if ((param != "")&&(tempParam.emrDocId == param.emrDocId))
    {
        if (tempParam.actionType == "CREATE")
        {
            focusDocument("GuideDocument","","First");
        }
        else
        {
             createDocument(tempParam);
        }
    }
    else
    {
        id = IsExitInstance(tempParam.emrDocId,tempParam.templateId);
        if (id != "0")
        {
            tempParam.id = id;
            loadDocument(tempParam); 
            if (tempParam.actionType == "CREATE")
            {
                focusDocument("GuideDocument","","First");
                getInstanceInfo(tempParam.id);
            }
            else
            {
                createDocument(tempParam);	
            }
        }
        else
        {
            if (tempParam.pluginType == "DOC") setWorkEnvironment(tempParam); 	                          
            setPatientInfo(tempParam); 
            var isMutex = (tempParam.isMutex=="1")?true:false;	
            var isGuideBox = (tempParam.isLeadframe == "1")?true:false;
            setDocTempalte(tempParam.emrDocId,isMutex,isGuideBox); //设置引导框	
            if (tempParam.actionType == "CREATE")
            {
                focusDocument("GuideDocument","","First");
            }
            else
            {
                createDocument(tempParam);
            }
        }
    }
    result = true;
    return result;
}

///打开文档
function doOpen(tempParam)
{
    pluginType = tempParam["pluginType"];
    if (pluginType == "DOC")
    {
        wordDoc(tempParam);
    }
    else if (pluginType == "GRID")
    {
        girdDoc(tempParam);
    }
    else
    {
        alert("插件创建失败");
        return;
    }
    if ((param != "")&&(param.emrDocId == tempParam.emrDocId) && ((param.characteristic != "0") || (param.id == tempParam.id)))
    {
        focusDocument(tempParam.id,"","Last");
    }
    else
    {
        loadDocument(tempParam); 
    }
}
///文档是否已经被创建
function IsExitInstance(emrDocId,templateId)
{
    var result = "0";
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLInstanceData",
            "Method":"IsHasInstance",
            "p1":episodeID,
            "p2":templateId,
            "p3":emrDocId
        },
        success: function(d) {
            result = d;
        },
        error : function(d) { alert("查数据出错");}
    });
    return result;
}

//创建word编辑器
function wordDoc(tempParam)
{
    var result = true;
    if (iword)
    {
        $("#containerGrid").css("display","none");
    }
    $("#containerWord").css("display","block");
    if (!iword)
    {
        var objString = "<object id='pluginWord' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'>";
        objString = objString + "<param name='install-url' value='" + pluginUrl + "'/>";
        objString = objString + "</object>";
        document.getElementById("containerWord").innerHTML = objString;
        if (!$("#pluginWord")[0]||!$("#pluginWord")[0].valid)
        {
            setUpPlug();
        } 
        pluginAdd();
        
        var ret = $("#pluginWord")[0].initWindow("iEditor") 
        //$("#pluginWord")[0].initWindow("iEmrClient");
        if (!ret)
        {
            alert('创建编辑器失败!');
        }
        //initEditor("iEditor");
                      
        var nectresult = setConnect();
        if (nectresult != "" && nectresult.result != "OK")
        {
            alert('数据库连接失败!');
            result = false;
            return result;
        } 
        SetDefaultFontStyle();
        iword = true;
        $("#containerGrid").css("display","none");
    }
    return result;
}

//创建gird编辑器
function girdDoc(tempParam)
{
    var result = true;
    $("#containerWord").css("display","none");
    $("#containerGrid").css("display","block");
    if(!igrid)
    {
        var objString = "<object id='pluginGrid' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'>";
        objString = objString + "<param name='install-url' value='" + pluginUrl + "'/>";
        objString = objString + "</object>";
        document.getElementById("containerGrid").innerHTML = objString;
        if (!$("#pluginGrid")[0]||!$("#pluginGrid")[0].valid)
        {
            setUpPlug();
        }  
        pluginAdd();
                                
        var ret = $("#pluginGrid")[0].initWindow("iGridEditor");
        //var ret = $("#pluginGrid")[0].initWindow("iEmrClient");
        if (!ret)
        {
            alert('创建编辑器失败!');
        }
        //initEditor("iGridEditor");
        var nectresult = setConnect();
        if (nectresult != "" && nectresult.result != "OK")
        {
            
            setMessage('数据库连接失败!','warning');
            result = false;
            return result;
        }
        igrid = true;
    }
    return result;
}
//安装插件提示
function setUpPlug (){
    var result = window.showModalDialog("emr.record.downloadplugin.csp?PluginUrl=" +pluginUrl,"","dialogHeight:100px;dialogWidth:200px;resizable:yes;status:no");
    if (result)
    {
        window.location.reload();
    }
};

//查找插件
function plugin() {
    if(pluginType == "DOC")
    {
        return $("#pluginWord")[0];
    }
    else
    {
        return $("#pluginGrid")[0];
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
    return jQuery.parseJSON(result);
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
            alert('get err');
            if (!onError) {}
            else {
                onError(ret);
            }
        }
    });
    var argJson = {action:"SET_NET_CONNECT",args:netConnect};
    return cmdSyncExecute(argJson);
}

//设置默认字体
function SetDefaultFontStyle(){
    var argJson = eval("("+"{'action':'SET_DEFAULT_FONTSTYLE','args':{"+setDefaultFontStyle+"}}"+")");
    cmdDoExecute(argJson);
}
//后台运行
function initEditor(editor)
{
    var argJson = {"action":"CLIENT_INIT_MODULE","args":{"Name":editor}};
    cmdDoExecute(argJson);
}

//设置患者信息
function setPatientInfo(tempParam)
{
    var argParams = {"PatientID":patientID,"EpisodeID":episodeID,"UserCode":userCode,
                   "UserID":userID,"UserName":userName,"SsgroupID":ssgroupID,"UserLocID":userLocID,
                   "DiseaseID":"","IPAddress":ipAddress,"PluginType":tempParam.pluginType,"ChartItemType":tempParam.chartItemType};
    var argJson = {action: "SET_PATIENT_INFO",args:argParams};
    cmdDoExecute(argJson);
}

//设置工作环境
function setWorkEnvironment(tempParam)
{
    //清空文档
    var argJson = {action:"CLEAN_DOCUMENT",args:""};
    cmdDoExecute(argJson);
    //设置工作空间上下文
    argJson = {action:"SET_WORKSPACE_CONTEXT",args:tempParam["chartItemType"]};
    cmdDoExecute(argJson);
    //设置书写状态
    argJson = {action:"SET_NOTE_STATE",args:"Edit"};
    cmdDoExecute(argJson);
    //设置文字只读颜色
    argJson = {action:"SET_READONLY_COLOR",args:{"color":"0000ff"}};
    cmdDoExecute(argJson);
}

//设置只读
function setReadOnly(flag,instanceIds)
{
    var argJson = "";
    if (instanceIds == "")
    {
        argJson = {action:"SET_READONLY", args:{"ReadOnly":flag}};
    }
    else
    {
        argJson = {action:"SET_READONLY", args:{"ReadOnly":flag,"InstanceID":instanceIds}};
    }
    cmdDoExecute(argJson);
}

//获取当前病历只读状态
function getReadOnlyStatus()
{
    var argJson = {action:"GET_READONLY",args:{}};
    return cmdSyncExecute(argJson);
}

//创建病历
function createDocument(tempParam)
{
    if (param.emrDocId != tempParam.emrDocId) loadFalg = true;
    var args = "";
    if (tempParam.args) args = tempParam.args;
        
    if (tempParam.actionType == "QUOTATION")
    {
        var argJson = {action:"CREATE_DOCUMENT_BY_INSTANCE",args:{"params":args,"InstanceID":tempParam.pInstanceId,"Title":{"DisplayName":tempParam.text}}};
    }
    else if (tempParam.actionType == "CREATEBYTITLE")
    {
        var argJson = {action:"CREATE_DOCUMENT_BY_TITLE",args:{"params":args,"TitleCode":tempParam.titleCode}};
    }
    else 
    {
        var argJson = {action:"CREATE_DOCUMENT",args:{"params":args,"Title":{"DisplayName":tempParam.text}}};
    }
    cmdDoExecute(argJson);
}

//加载文档
function loadDocument(tempParam)
{
    if (tempParam.pluginType == "DOC") setWorkEnvironment(tempParam);
    setPatientInfo(tempParam);
    if (param.emrDocId != tempParam.emrDocId) loadFalg = true;
    //加载文档
    var argJson = {action:"LOAD_DOCUMENT",args:{params:{"status":"NORMAL"},InstanceID:tempParam["id"],actionType:tempParam["actionType"]}};
    cmdDoExecute(argJson); 
    
    //设置引导框
    var isMutex = (tempParam["isMutex"]=="1")?true:false;
    var isGuideBox = (tempParam["isLeadframe"] == "1")?true:false;
    setDocTempalte(tempParam["emrDocId"],isMutex,isGuideBox);
}

//加载本地文档
function cmdLoadLocalDocument()
{
    var argJson = {action : "LOAD_LOCAL_DOCUMENT", args:{path:""}};
    cmdDoExecute(argJson);
}


//设置创建模板
function setDocTempalte(emrDocId,isMutex,isGuideBox)
{
    var argJson = {action:"SET_DOCUMENT_TEMPLATE",args:{DocID:emrDocId,IsMutex:isMutex,CreateGuideBox:isGuideBox}};
    cmdDoExecute(argJson);
}


//获取活动文档上下文
function getDocumentContext(instanceId)
{
    var argJson = {action:"GET_DOCUMENT_CONTEXT",args:{"InstanceID":instanceId}};
    return cmdSyncExecute(argJson);
}
//签名
function signDocument(instanceId,type,signLevel,userId,userName,Image,actionType,description,headerImage,fingerImage)
{
    var argJson = {action:"SIGN_DOCUMENT",args:{"InstanceID":instanceId,"Type":type,"SignatureLevel":signLevel,"actionType":actionType,"Authenticator":{"Id":userId,"Name":userName,"Image":Image,"Description":description, "HeaderImage":headerImage,"FingerImage":fingerImage},"params":{}}}
    return cmdSyncExecute(argJson);
}
//获取文档是否被修改过
function getModifyStatus()
{
    var argJson = {action:"CHECK_DOCUMENT_MODIFY",args:""};
    return cmdSyncExecute(argJson);
}

//刷新绑定数据
function reloadBinddata(autoRefresh,syncDialogVisible,silentRefresh)
{
    if (typeof(param) == "undefined" || param.id == "GuideDocument") return;
    var argJson = {"action":"REFRESH_REFERENCEDATA","args":{"InstanceID":"","AutoRefresh":autoRefresh,"SyncDialogVisible":syncDialogVisible,"SilentRefresh":silentRefresh}};
    cmdDoExecute(argJson);
}

//保存文档
function cmdSaveDocument()
{
    var argJson = {action:"SAVE_DOCUMENT", "args":{"params":{"action":"SAVE_DOCUMENT"}}};
    cmdDoExecute(argJson);
}

//失效签名
function cmdRevokeSignedDocument(signatureLevel,instanceId)
{
    var argJson = {"action":"REVOKE_SIGNED_DOCUMENT","args":{"SignatureLevel":signatureLevel,"InstanceID":instanceId}};
    return cmdSyncExecute(argJson);
}
//保存签名文档及相关操作
function saveSignDocument(instanceId,signUserId,signLevel,signId,digest,type,path,actionType)
{
    var argJson = {action:"SAVE_SIGNED_DOCUMENT",args:{params:{"action":"SAVE_SIGNED_DOCUMENT","SignUserID":signUserId,"SignID":signId,"SignLevel":signLevel,"Digest":digest,"Type":type,"Path":path,"ActionType":actionType},"InstanceID":instanceId}}
    cmdDoExecute(argJson);
}
//回滚签名
function unsignDocument()
{
    var argJson = {action:"UNSIGN_DOCUMENT",args:{}}
    cmdDoExecute(argJson);	
}

//撤销签名
function revokeSignElement(signProperty)
{
    var argJson = {"action":"REVOKE_SIGNED_ELEMENT","args":{"Path":signProperty.Path,params:{"Authenticator":{"Id":signProperty.Id,"Name":signProperty.Name,"Path":signProperty.Path,"SignatureLevel":signProperty.SignatureLevel}}}};
    return cmdSyncExecute(argJson);
}

//保存文档
function saveDocument()
{
    var flag = "save"
    //取文档信息
    var documentContext = getDocumentContext("");
    var modifyResult = getModifyStatus();
    //判断病历被修改且上一次操作是打印,则弹出病历已打印的提醒框
    if ((documentContext.status.curAction == "print")&&(modifyResult.Modified == "True"))
    {
        var text = '病历 "' +param.text + '" 已打印，是否确认保存修改！';
        var Values = "";
        if ($.browser.msie && $.browser.version == '6.0')
        {
            Values = window.showModalDialog("emr.printprompt.csp",text,"dialogHeight:180px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
        }else
        {
            Values = window.showModalDialog("emr.printprompt.csp",text,"dialogHeight:150px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
        }
        if (Values == "cancel") return;
    }
    if (isRevokeSign == "Y")
    {
        if (revokeSignedDocument(modifyResult)) flag = "revoke";
    }
    else
    {
        cmdSaveDocument();
    }
    return flag;
}

///撤销签名
function revokeSignedDocument(modifyResult)
{
    var result = false;
    var noSign = false;
    if (modifyResult.Modified == "False") checkRequiredCell();
    for (var i=0;i<modifyResult.InstanceID.length;i++)
    {
        var instanceId = modifyResult.InstanceID[i];
        var documentContext = getDocumentContext(instanceId);
        var userLevel = getUserInfo().UserLevel;
        if (revokeStatus()!= "Superior") userLevel = "";
        var revokeResult = cmdRevokeSignedDocument(userLevel,instanceId);
        if (revokeResult.result == "ERROR")
        {
            alert('失效文档失败!');
            noSign = false;
            break;
        }
        else
        {
            if( typeof(revokeResult.Authenticator) == "undefined" || revokeResult.Authenticator.length<=0) 
            {
                noSign = true;
                continue;	
            }
            result = true;
            var tmpDocContext = getDocumentContext(instanceId);
            if (tmpDocContext.result == "ERROR") return;

            //当前文档状态
            setStatus(tmpDocContext);

            alert('数据保存成功,签名已失效!');
        }
    }
    if (noSign)
    {
        cmdSaveDocument();
    }
    return result; 
}

///当前用户信息
function getUserInfo()
{
    var result = "";
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLEMRSign",
            "Method":"GetUserInfo",
            "p1":userCode,
            "p2":"",
            "p3":userLocID
        },
        success: function(d) {
            if (d != "")
            {
                result = eval("("+d+")");
                if (signLogic == "Custom")
                {
                    var temp =  getEpisodeThreeDoctor(result);
                    if (temp.flag == 1)
                    {
                        result = temp.userInfo;
                    }else {
                        alert(temp.message);
                    }
                }
            }
        },
        error: function(d) {alert("error");}
    });
    return result;
}

///取为患者设定的三级医师
function getEpisodeThreeDoctor(userInfo)
{
    var result = {};
    $.ajax({
        type: 'POST',
        dataType: 'json',
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLEMRSign",
            "Method":"GetThreeLevelDoctor",
            "p1":episodeID
        },
        success: function(ret) {
            if (ret == "")
            {
                result.flag = "0";
                result.message = "没维护三级医师";
                return result;
            } 
            for (var i=0;i<ret.length;i++)
            {
                if (ret[i].Id == userInfo.UserID) 
                {
                    userInfo.UserLevel = ret[i].level;
                    userInfo.LevelDesc = ret[i].desc;
                    result.flag = "1";
                    result.message = "";
                    result.userInfo = userInfo;
                    break;
                }
            }
            if (result.flag ==undefined || result.flag != "1")
            {
                result.flag = "0";
                result.message = "该用户不是该患者的责任医师,无权限签名";
            }

        },
        error: function(ret) {alert(ret);}
    });
    return result;
}

//是否调用签名失效
function revokeStatus()
{
    var result = "";
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.SystemParameter",
            "Method":"GetRevokeStatus"
        },
        success: function(d) {
            result = d;
        },
        error: function(d) {alert("error");}
    });
    return result;
}

///检查必填项
function checkRequiredCell()
{
    var result =  false;
    if ((requiredFlag.Grid == "1")&&(param.pluginType == "GRID")||(requiredFlag.Word == "1")&&(param.pluginType == "DOC"))
    {
        //脚本检查
        var resultMarkRequired = markRequiredObject();
        if (resultMarkRequired.MarkCount>0) result = true;
    }
    return result;
}

//设置状态
function setStatus(documentText)
{
    if (documentText == null) return;
    if (documentText.result == "ERROR") return;
    curStatus = documentText.status.curStatus;
}

//事件派发
function eventDispatch(commandJson)
{
    if (commandJson["action"] == "eventCreateDocument")
    {
        eventCreateDocument(commandJson);
    }
    else if (commandJson["action"] == "eventSaveDocument")
    {
        //保存监听
        eventSaveDocument(commandJson);
    }
    else if(commandJson["action"] == "eventLoadDocument")
    {
        eventLoadDocument(commandJson);
    }
    else if (commandJson["action"] =="eventRefreshReferenceData")
    {
        eventRefreshReferenceData(commandJson);
    }
    else if(commandJson["action"] == "eventSaveSignedDocument")
    {
        //文档签名
        eventSaveSignedDocument(commandJson);
    }
    else if (commandJson["action"] == "eventRequestSign")
    {
        //签名
        eventRequestSign(commandJson);
    }
}

function eventCreateDocument(commandJson)
{
    loadFalg = false;
    if (commandJson["args"]["result"] == "OK")
    {
        //cmdSaveDocument();
        getInstanceInfo(commandJson["args"]["InstanceID"]);
    }
}

//保存事件监听
function eventSaveDocument(commandJson)
{
    if (commandJson["args"]["result"] == "OK")
    {
        if (commandJson["args"]["params"]["result"] == "OK")
        { 
            alert('数据保存成功!');
            getInstanceInfo(commandJson["args"]["params"]["InstanceID"]);
        }
        else
        {
            alert('数据保存失败!');
        }
    }
    else if (commandJson["args"]["result"] == "ERROR")
    {
        if (commandJson["args"]["params"]["status"] == "0")
        {
            alert('病历已存在!');
        }
        else
        {
            alert('保存失败');
        }
    }
    else if (commandJson["args"]["result"] == "INVALID")
    {
		alert('病历存在非法字符，不能保存。'); 
    }
    else if (commandJson["args"]["result"] != "NONE")
    {
        alert('文档没有发生改变');
    }
}

//文档加载成功事件
function eventLoadDocument(commandJson)
{
    loadFalg = false;
    //获取当前病历只读状态
    var readOnlyStatus = getReadOnlyStatus().ReadOnly;
    if (readOnlyStatus == "False")
    {
        reloadBinddata("true","true","false");
        //refreshReferenceData(commandJson.args.InstanceID,"true","false","true");
    }
}

//将是否显示绑定数据提示框状态存入表中
function eventRefreshReferenceData(commandJson)
{
    if (commandJson["args"]["result"] == "OK")
    {
        //cmdSaveDocument();
        jQuery.ajax({
            type : "GET", 
            dataType : "text",
            url : "../EMRservice.Ajax.common.cls",
            async : true,
            data : {
                    "OutputType":"String",
                    "Class":"EMRservice.BL.BLRefreshBindData",
                    "Method":"InputData",
                    "p1":param.id,
                    "p2":commandJson["args"]["SyncDialogVisible"]
                }
        });
    }
}

//文档签名事件
function eventSaveSignedDocument(commandJson)
{
    if ((commandJson["args"]["result"] == "OK")&&(commandJson["args"]["params"]["result"] == "OK")) 
    {
        //取文档信息
        var documentContext = getDocumentContext(commandJson["args"]["params"]["InstanceID"]);
        //设置当前文档操作权限
        //setPrivelege(documentContext);
        //当前文档状态
        setStatus(documentContext);
        
        alert('数据签名成功!');
        getInstanceInfo(commandJson["args"]["params"]["InstanceID"]);
        
        
        //请求上级签名是否成功
        if (commandJson["args"]["params"]["MessageFlag"] == "0")
        {
           alert('请求上级签名失败!请检查');
        }
    }
    else
    {
        alert('签名失败或级别不符!');
        unsignDocument();
    }
}

//签名
function eventRequestSign(commandJson)
{
    if (getModifyStatus().Modified == "True")
    {
        if (saveDocument()=="revoke") return;
    }
    var signProperty = commandJson.args;
    audit(signProperty);
}

// 打开签名窗口
function audit(signProperty)
{
    var documentContext = getDocumentContext("");
    var canRevokCheck = documentContext.privelege.canRevokCheck;
    if (pluginType != "GRID") canRevokCheck =0;
    var tmpInstanceId = signProperty.InstanceID;
    var openFlag = episodeType=="O"?"0":"1";
    if (signProperty.OriSignatureLevel.toUpperCase() == 'PATIENT') 
    {
        var argEditor = {
            instanceId: tmpInstanceId,
            signDocument: signDocument,
            saveSignedDocument: saveSignDocument,
            //signProperty: signProperty
            actionType: (function () {
                if (signProperty.Authenticator.length>0) {
                    return 'Replace';
                }
                else {
                    return 'Append';
                }	
            })()
        };
        handSign.sign(argEditor);
        return;
    }
    if ('1' == CAServicvice) 
    {
        var signParam = {"topwin":window,"canRevokCheck":canRevokCheck,"cellName":signProperty.Name};
        var returnValues = window.showModalDialog("emr.record.signca.csp?UserID="+userID+"&OpenFlag="+openFlag+"&UserLocID="+userLocID,signParam,"dialogHeight:150px;dialogWidth:300px;resizable:yes;status:no");
        if (returnValues != "" && returnValues != undefined)
        {
            returnValues = eval("("+returnValues+")");
            userInfo = returnValues.userInfo;
            if (userInfo == "") 
            {
                return;
            }
            if ((userInfo.UserLevel == "")&&(userInfo.UserPos == ""))
            {
                alert('请先维护用户级别');
                return;
            }
            if (returnValues.action == "sign")
            {
                if (userInfo.Type == "Graph" && userInfo.Image == "")
                {
                    alert('签名图片未维护，请维护');
                    return;
                }
                caSign(signProperty,userInfo,tmpInstanceId);
            }
            else if (returnValues.action == "revoke")
            {
                if (userInfo.UserID != signProperty.Id)
                {
                    alert('非本人签名,不能撤销');
                    return;
                }
                var ret = revokeSignElement(signProperty);
                if (ret.result == "OK")
                {
                    alert('撤销成功');
                }
                else
                {
                    alert('撤销失败');
                }
            }
        }
    }
    else
    {
        var signParam = {"canRevokCheck":canRevokCheck,"cellName":signProperty.Name};
        var returnValues = window.showModalDialog("emr.record.sign.csp?UserName="+userName+"&UserCode="+userCode+"&OpenFlag="+openFlag+"&UserLocID="+userLocID+"&EpisodeID="+episodeID,signParam,"dialogHeight:220px;dialogWidth:300px;resizable:yes;status:no");
        if (returnValues != "" && returnValues != undefined)
        {
            returnValues = eval("("+returnValues+")");
            userInfo = returnValues.userInfo;
            if ((userInfo.UserLevel == "")&&(userInfo.UserPos == ""))
            {
                alert('请先维护用户级别');
                return;
            }
            if (returnValues.action == "sign")
            {
                if (userInfo.Type == "Graph" && userInfo.Image == "")
                {
                    alert('签名图片未维护，请维护');
                    return;
                }
                checkSign(signProperty,userInfo,tmpInstanceId,documentContext);
            }
            else if (returnValues.action == "revoke")
            {
                if (userInfo.UserID != signProperty.Id)
                {
                    alert('非本人签名,不能撤销');
                    return;
                }
                var ret = revokeSignElement(signProperty);
                if (ret.result == "OK")
                {
                    alert('撤销成功');
                }
                else
                {
                    alert('撤销失败');
                }
            }
            
        }
    }
}

//数字签名
function caSign(signProperty,userInfo,instanceId)
{
    //权限检查
    var checkresult = checkPrivilege(userInfo,signProperty);
    if(!checkresult.flag) return;

    //开始签名
    var cert = GetSignCert(strKey);
    var UsrCertCode = GetUniqueID(cert,strKey);
    if (!UsrCertCode || '' == UsrCertCode) return '用户唯一标示为空！';
    
    var signlevel = signProperty.SignatureLevel;
    var actionType = checkresult.ationtype;
    if (signProperty.OriSignatureLevel == "Check") signlevel = userInfo.UserLevel
    var signInfo = signDocument(instanceId,userInfo.Type,signlevel,userInfo.UserID,userInfo.UserName,userInfo.Image,actionType,userInfo.LevelDesc,"","");

    if (!signInfo.Digest || signInfo.Digest == "") 
    {
        alert('签名原文为空！');
        return ;
    }
    var signValue = SignedData(signInfo.Digest,strKey);
    $.ajax({
        type: 'POST',
        dataType: 'json',
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        cache: false,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLEMRSign",
            "Method":"Sign",
            "p1":UsrCertCode,
            "p2":signValue,
            "p3":signInfo.Digest
        },
        success: function(ret) {
            if (ret && ret.Err) 
            {
                alert(ret.Err);
            } 
            else 
            {
                saveSignDocument(instanceId,userInfo.UserID,signlevel,ret.SignID,signInfo.Digest,"CA",signInfo.Path,actionType);
                //签名成功后，判断是否需要发送消息给Portal系统
                if (IsSetToPortal == "Y")
                {
                    //setInfoToPortal(userInfo.UserID);
                }
            }
        },
        error: function(ret) {alert(ret);}
    });
}
//系统签名
function checkSign(signProperty,userInfo,instanceId,documentContext)
{
    //权限检查
    var checkresult = checkPrivilege(userInfo,signProperty);
    if(!checkresult.flag) return;
    var signlevel = signProperty.SignatureLevel;
    var actionType = checkresult.ationtype;
    if ((actionType == "Append" && documentContext.privelege.canCheck == 0) || (actionType == "Replace" && documentContext.privelege.canReCheck == 0))
    {
        alert("没有权限签名");
        return
    }
    
    //开始签名
    if (signProperty.OriSignatureLevel == "Check") signlevel = userInfo.UserLevel
    var signInfo = signDocument(instanceId,userInfo.Type,signlevel,userInfo.UserID,userInfo.UserName,userInfo.Image,actionType,userInfo.LevelDesc,"","");
    if (signInfo.result == "OK")
    {
        saveSignDocument(instanceId,userInfo.UserID,signlevel,"","","SYS",signInfo.Path,actionType);
        
        //签名成功后，判断是否需要发送消息给Portal系统
        if (IsSetToPortal == "Y")
        {
            //setInfoToPortal(userInfo.UserID);
        }
    }
    else
    {
        alert('签名失败');
    }
}

//签名成功后，发送消息给Portal系统
function setInfoToPortal(UserID)
{
    var signUserID = UserID;
    //alert("signUserID"+signUserID);
    var InstanceId = param.id;
    var categoryId = param.categoryId;
    var templateId = param.templateId;
    var emrDocId = param.emrDocId;
    var chartItemType = param.chartItemType;

    //取文档信息
    var documentContext = getDocumentContext("");

    var TitleCode = documentContext["Title"]["Code"];
    var TitleDesc = documentContext["Title"]["DisplayName"];
    var curStatus = documentContext["status"]["curStatus"];
    var curStatusDesc = documentContext["status"]["curStatusDesc"];
    var signStatus = documentContext["status"]["signStatus"];

    var canAttendingCheck = documentContext["privelege"]["canAttendingCheck"];
    var canChiefCheck = documentContext["privelege"]["canChiefCheck"];

    $.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.SetDataToPortal.cls", 
        data: "EpisodeID=" + episodeID + "&signUserID="+ signUserID + "&InstanceId=" + InstanceId + "&categoryId=" + categoryId + "&templateId=" + templateId + "&emrDocId=" + emrDocId + "&chartItemType=" + chartItemType + "&TitleCode=" + TitleCode + "&TitleDesc=" + TitleDesc + "&curStatus=" + curStatus + "&curStatusDesc=" + curStatusDesc + "&signStatus=" + signStatus + "&canAttendingCheck=" + canAttendingCheck + "&canChiefCheck=" + canChiefCheck
    });
}

//检查签名权限脚本
function checkPrivilege(userInfo,signProperty)
{
    var result = {"flag":false,"ationtype":""};
    if (signLogic == "Custom")
    {
        var tempResult = getEpisodeThreeDoctor(userInfo);
        if (tempResult.flag !== "1") 
        {
            alert(tempResult.message);
            return result;
        }
        else
        {
            userInfo = tempResult.userInfo; 
        }
    }	
    var count = signProperty.Authenticator.length;
    if ((count >0) && (signProperty.Id == userInfo.UserID) && (isEnableSelectUserLevel != "Y"))
    {
        result = {"flag":false,"ationtype":""};
        alert('已签名,不必再签');
        return result;
    }
    
    var signArray = ["All","QCDoc","QCNurse","ChargeNurse","student","intern","Refresher","Coder"];
    
    if ($.inArray(signProperty.OriSignatureLevel, signArray) != -1)
    {
        if (count>0)
        {
            //改签
            if (confirm("已签名，是否改签")==true)
            {
                result = {"flag":true,"ationtype":"Replace"};
            }
            else
            {
                result = {"flag":false,"ationtype":""};
            }
        }
        else
        {
            //签名
             result = {"flag":true,"ationtype":"Append"};
        }
    }
    else if (signProperty.OriSignatureLevel == "Check")
    {
        if (count <=0)
        {
            //签名
            result = {"flag":true,"ationtype":"Append"};
        }
        else
        {
            if (userInfo.UserLevel == "student")
            {
                if (count == 1 && signProperty.SignatureLevel == "student")
                {
                    //改签
                    if (confirm("已签名，是否改签")==true)
                    {
                        result = {"flag":true,"ationtype":"Replace"};
                    }
                    else
                    {
                        result = {"flag":false,"ationtype":""};
                    }
                }
                else
                {
                    //无权限签
                    result = {"flag":false,"ationtype":""};
                    alert("无权限签名");
                }
    
            }
            else if (userInfo.UserLevel == "intern")
            {
                if (count == 1 && signProperty.SignatureLevel == "intern")
                {
                    //改签
                    if (confirm("已签名，是否改签")==true)
                    {
                        result = {"flag":true,"ationtype":"Replace"};
                    }
                    else
                    {
                        result = {"flag":false,"ationtype":""};
                    }
                }
                else
                {
                    //无权限签
                    result = {"flag":false,"ationtype":""};
                    alert("无权限签名");
                }
    
            }	
            else if (userInfo.UserLevel == "Resident")
            {
                var flag = 0
                for (var i=0;i<count;i++)
                {
                    if ($.inArray(signProperty.Authenticator[i].SignatureLevel,["Attending","ViceChief","Chief"]) != -1)
                    {
                        flag = 1
                        break;
                    } 
                }
                
                if (flag == 1)
                {
                    //无权限签
                    result = {"flag":false,"ationtype":""};
                    alert("无权限签名");
                    return result;
                }
                
                flag = 0
                for (var i=0;i<count;i++)
                {
                    if (signProperty.Authenticator[i].SignatureLevel == "Resident")
                    {
                        flag = 1
                        break;
                    } 
                }
                
                if (flag != 1)
                {
                    //签名
                    result = {"flag":true,"ationtype":"Append"};		
                }
                else if (signProperty.SignatureLevel == "Resident")
                {
                    //改签
                    if (confirm("已签名，是否改签")==true)
                    {
                        result = {"flag":true,"ationtype":"Replace"};
                    }
                    else
                    {
                        result = {"flag":false,"ationtype":""};
                    }
                }
                else
                {
                    //无权限签
                    result = {"flag":false,"ationtype":""};
                    alert("无权限签名");
                }
            }
            else if (userInfo.UserLevel == "Attending")
            {
                var flag = 0
                for (var i=0;i<count;i++)
                {
                    if ($.inArray(signProperty.Authenticator[i].SignatureLevel,["ViceChief","Chief"]) != -1)
                    {
                        flag = 1
                        break;
                    } 
                }
                
                if (flag == 1)
                {
                    //无权限签
                    result = {"flag":false,"ationtype":""};
                    alert("无权限签名");
                    return result;
                }
                
                flag = 0
                for (var i=0;i<count;i++)
                {
                    if (signProperty.Authenticator[i].SignatureLevel == "Attending")
                    {
                        flag = 1
                        break;
                    } 
                }
                
                if (flag != 1)
                {
                    //签名
                    result = {"flag":true,"ationtype":"Append"};		
                }
                else if (signProperty.SignatureLevel == "Attending")
                {
                    //改签
                    if (confirm("已签名，是否改签")==true)
                    {
                        result = {"flag":true,"ationtype":"Replace"};
                    }
                    else
                    {
                        result = {"flag":false,"ationtype":""};
                    }
                }
                else
                {
                    //无权限签
                    result = {"flag":false,"ationtype":""};
                    alert("无权限签名");
                }
            }			
            else if ($.inArray(userInfo.UserLevel,["Chief","ViceChief"]) != -1)
            {
                var flag = 0
                for (var i=0;i<count;i++)
                {
                    if ($.inArray(signProperty.Authenticator[i].SignatureLevel,["Chief","ViceChief"]) != -1)
                    {
                        flag = 1
                        break;
                    } 
                }
                if (flag != 1)
                {
                    //签名
                    result = {"flag":true,"ationtype":"Append"};		
                }
                else if ($.inArray(signProperty.SignatureLevel,["Chief","ViceChief"]) != -1)
                {
                    //改签
                    if (confirm("已签名，是否改签")==true)
                    {
                        result = {"flag":true,"ationtype":"Replace"};
                    }
                    else
                    {
                        result = {"flag":false,"ationtype":""};
                    }
                }
                else
                {
                    //无权限签
                    result = {"flag":false,"ationtype":""};
                    alert("无权限签名");
                }
            }
        }
    }
    else if(signProperty.OriSignatureLevel == "Resident")
    {
        //住院医师签名可签上级
        if ($.inArray(userInfo.UserLevel,["Chief","ViceChief","Attending","Resident"]) != -1)
        {
            if (count <=0)
            {
                //签名
                result = {"flag":true,"ationtype":"Append"};		
            }
            else
            {
                //改签
                if (confirm("已签名，是否改签")==true)
                {
                    result = {"flag":true,"ationtype":"Replace"};
                }
                else
                {
                    result = {"flag":false,"ationtype":""};
                }	
            }	
        }
        else
        {
            //无权限签
            result = {"flag":false,"ationtype":""};
            alert("无权限签名");
        }
    }
    else if (signProperty.OriSignatureLevel == "Attending")
    {
        //住治医师签名可签上级
        if ($.inArray(userInfo.UserLevel,["Attending","ViceChief","Chief"]) != -1)
        {
            if (count <=0)
            {
                //签名
                result = {"flag":true,"ationtype":"Append"};
            }
            else
            {
                //改签
                if (confirm("已签名，是否改签")==true)
                {
                    result = {"flag":true,"ationtype":"Replace"};
                }
                else
                {
                    result = {"flag":false,"ationtype":""};
                }	
            }	
        }
        else
        {
            //无权限签
            result = {"flag":false,"ationtype":""};
            alert("无权限签名");
        }
    }
    else if ($.inArray(signProperty.OriSignatureLevel,["ViceChief","Chief"]) != -1)
    {
        //主任副主任可签
        if ($.inArray(userInfo.UserLevel,["ViceChief","Chief"]) != -1)
        {
            if (count <=0)
            {
                //签名
                result = {"flag":true,"ationtype":"Append"};		
            }
            else
            {
                //改签
                if (confirm("已签名，是否改签")==true)
                {
                    result = {"flag":true,"ationtype":"Replace"};
                }
                else
                {
                    result = {"flag":false,"ationtype":""};
                }	
            }	
        }
        else
        {
            //无权限签
            result = {"flag":false,"ationtype":""};
            alert("无权限签名");
        }
    }
    else 
    {
        if (signProperty.OriSignatureLevel != userInfo.UserLevel && signProperty.OriSignatureLevel != userInfo.UserPos)
        {
            //无权限签
            result = {"flag":false,"ationtype":""};
            alert("签名身份不符，无权限签名");
        }
        else if (count > 0)
        {
            //改签
            if (confirm("已签名，是否改签")==true)
            {
                result = {"flag":true,"ationtype":"Replace"};
            }
            else
            {
                result = {"flag":false,"ationtype":""};
            }
        }
        else
        {
            //签名
            result = {"flag":true,"ationtype":"Append"};
        }
    }
    return result;
}


//保存
document.getElementById("save").onclick = function(){
    saveDocument();
};

var btnFlag = false;
//传送数据
document.getElementById("sendData").onclick = function(){
    if (btnFlag) { return; }
    btnFlag = true;
    var sendDataCmd = "c:\\bajkbm\\bajkbm.exe " + episodeID;
    doSendData(sendDataCmd);
    setTimeout(function(){
        btnFlag = false;
    }, 2000);
};

function doSendData(sendDataCmd) {
    try {
        var obj = new ActiveXObject("Wscript.Shell");
        obj.run(sendDataCmd);
        SaveSendDataLog();
    } catch (e) {
        alert("病案3.0数据传送异常!");
    }
}

function SaveSendDataLog() {
    var dateTime = new Date();
    var date = dateTime.getFullYear() + "-" + (dateTime.getMonth()+1) + "-" + dateTime.getDate();
    var time = dateTime.getHours() + ":" + dateTime.getMinutes() + ":" + dateTime.getSeconds();
    $.ajax({
        type: "GET",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: true,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLMedicalLogs",
            "Method":"SaveSendDataLog",
            "p1":episodeID,
            "p2":date,
            "p3":time,
            "p4":userID,
            "p5":userName,
            "p6":ipAddress
        },
        success: function(d) {
            if (d == "0") {
                alert("保存编目传送记录失败");
            }
        },
        error: function(d) {alert("SaveSendDataLog error");}
    });
}

//刷新绑定数据
document.getElementById("binddatareload").onclick = function(){
    //取文档信息
    var documentContext = getDocumentContext("");
    reloadBinddata("false","true","false");
    //refreshReferenceData(documentContext.InstanceID,"false","true","false");
};

//病历加载完成后触发绑定数据同步
function refreshReferenceData(InstanceID,autoRefresh,syncDialogVisible,silentRefresh)
{
    if (InstanceID == "") return;
    //获取是否显示同步提示框状态
    jQuery.ajax({
        type : "GET", 
        dataType : "text",
        url : "../EMRservice.Ajax.common.cls",
        async : true,
        data : {
                "OutputType":"String",
                "Class":"EMRservice.BL.BLRefreshBindData",
                "Method":"getBindDataSyncDialogVisible",
                "p1":InstanceID
            },
        success : function(d) {
           if ( d != "") 
           {
                if (d == "True")
                {
                    syncDialogVisible = "true";
                }
                else if(d == "False")
                {
                    syncDialogVisible = "false";
                }
                reloadBinddata(autoRefresh,syncDialogVisible,silentRefresh);
           }
        }
    });
}

///当前病历状态信息
function getInstanceInfo(id)
{
    $.ajax({
        type: "POST",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLEMRLogs",
            "Method":"GetInsStatusInfo",
            "p1":id
        },
        success: function(d) {
            if (d != "") {
                $("#insInfo").html("");
                var data = eval("("+d+")");
                var createInfo = data.creator + '&nbsp' + data.createDate + '&nbsp' + data.createTime
                var splitor = '&nbsp&nbsp|&nbsp&nbsp';
                var htmlStr = '&nbsp';
                htmlStr += '<span class="spancolorleft">创建:</span>&nbsp'+ createInfo;
                htmlStr += splitor + data.operator;
                htmlStr += splitor + '<span class="spancolorleft">'+ data.statusDesc +'</span>';
                //htmlStr += splitor + data.operator + '&nbsp' + data.actionDesc;
                $("#insInfo").append(htmlStr);
            }
        },
        error: function(d) {alert("GetInsStatusInfo error");}
    });
}

