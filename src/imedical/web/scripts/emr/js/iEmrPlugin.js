var g_iword = false;
var g_igrid = false;
//创建word编辑器
function wordDoc(tempParam,pluginUrl,defFontStyle)
{
	var result = true;
	$("#containerGrid").css("display","none");
	$("#containerWord").css("display","block");
	if (!g_iword)
	{
		var objString = "<object id='pluginWord' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'>";
	    objString = objString + "<param name='install-url' value='" + pluginUrl + "'/>";
	    objString = objString + "<param name='product' value='GlobalEMR'/>";
	    objString = objString + "</object>";
	    document.getElementById("containerWord").innerHTML = objString;
		if (!$("#pluginWord")[0]||!$("#pluginWord")[0].valid)
		{
			setUpPlug();
			return;
		} 
		pluginAdd();
		var ret = $("#pluginWord")[0].initWindow("iEditor");
		if (!ret)
		{
			alert('创建编辑器失败!');
			result = false;
			return result;
		}              
		var nectresult = cmdSetConnect();
		if (nectresult != "" && nectresult.result != "OK")
		{
			alert('数据库连接失败!');
			result = false;
			return result;
		} 
		cmdSetDefaultFontStyle(defFontStyle);
		iword = true;                             	
	}
	return result;
}

//创建gird编辑器
function girdDoc(tempParam,pluginUrl)
{
	var result = true;
	$("#containerWord").css("display","none");
	$("#containerGrid").css("display","block");
	if (!g_igrid)
	{
		var objString = "<object id='pluginGrid' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'>";         
	    objString = objString + "<param name='install-url' value='" + pluginUrl + "'/>";
	    objString = objString + "<param name='product' value='GlobalEMR'/>";
	    objString = objString + "</object>";
	    document.getElementById("containerGrid").innerHTML = objString;  
		if (!$("#pluginGrid")[0]||!$("#pluginGrid")[0].valid)
		{
			setUpPlug();
			return;
		}  
		pluginAdd(); 
		var ret = $("#pluginGrid")[0].initWindow("iGridEditor");
		if (!ret)
		{
			alert('创建编辑器失败!');
			result = false;
			return result;
		}              
		var nectresult = cmdSetConnect();
		if (nectresult != "" && nectresult.result != "OK")
		{
			
			alert('数据库连接失败!');
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
function cmdSetConnect(){
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
	var strJson = {action:"SET_NET_CONNECT",args:netConnect};
	return cmdSyncExecute(strJson);
}

//设置默认字体
function cmdSetDefaultFontStyle(setDefaultFontStyle){
	var strJson = eval("("+"{'action':'SET_DEFAULT_FONTSTYLE','args':{"+setDefaultFontStyle+"}}"+")");
	cmdDoExecute(strJson);
}

//设置工作环境
function cmdSetWorkEnvironment(tempParam)
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
function cmdSetReadOnly(instanceIds,flag)
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

//设置患者信息
function cmdSetPatientInfo(pInfo)
{
	var argParams = {"PatientID":pInfo.patientID,"EpisodeID":pInfo.episodeID,"UserCode":pInfo.userCode,"SessionID":pInfo.sessionID,
	               "UserID":pInfo.userID,"UserName":pInfo.userName,"SsgroupID":pInfo.ssgroupID,"UserLocID":pInfo.userLocID,
	               "DiseaseID":pInfo.diseaseID,"IPAddress":pInfo.ipAddress};
    var argJson = {action: "SET_PATIENT_INFO",args:argParams};
    cmdDoExecute(argJson);
}

//设置创建模板
function cmdSetDocTempalte(emrDocId,isMutex,isGuideBox)
{
	var argJson = {action:"SET_DOCUMENT_TEMPLATE",args:{DocID:emrDocId,IsMutex:isMutex,CreateGuideBox:isGuideBox}};
	cmdDoExecute(argJson);
}

//插入知识库结点
function cmdAppendComposite(kbNodeID)
{
   var argJson = {action:"APPEND_COMPOSITE",args:{params:{"action":"LOAD_COMPOSITE","KBNodeID":kbNodeID}}};
   cmdDoExecute(argJson);               
}	

//替换知识库结点
function cmdReplaceComposite(kbNodeID)
{
   var argJson = {action:"REPLACE_COMPOSITE",args:{params:{"action":"LOAD_COMPOSITE","KBNodeID":kbNodeID}}};
   cmdDoExecute(argJson);  
}

//判断当前光标在文档中的位置	
function cmdGetElementContext(position)
{
   var argJson = {action:"GET_ELEMENT_CONTEXT",args:{"Type":position}};
	return cmdSyncExecute(argJson);
}

//插入文本
function cmdInsertText(text)
{
	var argJson = {action:"INSERT_TEXT_BLOCK",args:text};
	cmdDoExecute(argJson); 
}

//插入带格式文本
function cmdInsertStyleText(text)
{ 
	var argJson = {action:"INSERT_STYLE_TEXT_BLOCK",args:text};
	cmdDoExecute(argJson); 
}

//定位文档
function cmdFocusDocument(instanceId,path,actionType)
{
	var argJson = {action:"FOCUS_ELEMENT",args:{"InstanceID":instanceId,"Path":path,"actionType":actionType}}
	cmdDoExecute(argJson);
}
//签名
function cmdSignDocument(instanceId,type,signLevel,userId,userName,Image,actionType,description,headerImage,fingerImage)
{
	var argJson = {action:"SIGN_DOCUMENT",args:{"InstanceID":instanceId,"Type":type,"SignatureLevel":signLevel,"actionType":actionType,"Authenticator":{"Id":userId,"Name":userName,"Image":Image,"Description":description, "HeaderImage":headerImage,"FingerImage":fingerImage},"params":{}}}
	return cmdSyncExecute(argJson);
}
//获取活动文档上下文
function cmdGetDocumentContext(instanceId)
{
	var argJson = {action:"GET_DOCUMENT_CONTEXT",args:{"InstanceID":instanceId}};
	return cmdSyncExecute(argJson);
}
//请求目录大纲
function cmdGetOutLine()
{
	var argJson = {"action":"GET_DOCUMENT_OUTLINE","args":""}
	cmdDoExecute(argJson);
}

//获取文档是否被修改过
function cmdGetModifyStatus()
{
	var argJson = {action:"CHECK_DOCUMENT_MODIFY",args:""};
	return cmdSyncExecute(argJson);
}

//同步运行脚本
function cmdRunSyncScript(scripts) {
    var strJson = {action:"RUN_SCRIPT",args:{Script:scripts}};
    return cmdSyncExecute(strJson);
}

//标注必填项
function cmdMarkRequiredObject()
{
	var strJson = {action:"MARK_REQUIRED_OBJECTS",args:{"Mark":"True"}};
	return cmdSyncExecute(strJson);
}

//刷新绑定数据
function cmdReloadBinddata(autoRefresh,syncDialogVisible,silentRefresh)
{
	if (typeof(param) == "undefined" || param.id == "GuideDocument") return;
	
	var argJson = {"action":"REFRESH_REFERENCEDATA","args":{"InstanceID":"","AutoRefresh":autoRefresh,"SyncDialogVisible":syncDialogVisible,"SilentRefresh":silentRefresh}};
	cmdDoExecute(argJson);	
}

//导出文档
function exportDocument()
{
	if (!param || param.id == "GuideDocument")
	{
		alert('请选中要导出的文档!');
		return;
	}
	var argJson = {"action":"SAVE_LOCAL_DOCUMENT","args":{}};
	cmdDoExecute(argJson);	
}

//设置文档参数
function setDocumentParam(id,actionType,params)
{
	var argJson = {"action":"SET_DOCUMENT_PARAMS","args":{"InstanceID":id,"actionType":actionType,"params":params}};
	cmdDoExecute(argJson);
}

//设置留痕基本信息
function setCurrentRevisor(userID,userName,ip,userLevel)
{
	var argJson = {"action":"SET_CURRENT_REVISOR","args":{"Id":userID, "Name":userName,"IP":ip,"Level":userLevel}};
	cmdDoExecute(argJson);		
}

//设置开启关闭留痕
function setRevisionState(InstanceId,status)
{
	var argJson = {action:"SET_REVISION_STATE", args:{"InstanceID":InstanceId,"Mark":status}};
	return cmdSyncExecute(argJson);
}

//显示留痕
function viewRevision(status)
{
	var argJson = {action:"SET_REVISION_VISIBLE",args: {"Visible":status}}
	cmdDoExecute(argJson);
}

//设置ASR语音识别状态
function setASRVoiceStatus(status)
{
	var argJson = {action:"SET_ASR_VOICE_STATE",args:{"Open":status}};
	cmdDoExecute(argJson);
}

//修改或追加单元内容
function updateInstanceData(actiontype,instanceID,path,value) {
    var strJson = {action: "UPDATE_INSTANCE_DATA",args: {"actionType":actiontype,"InstanceID":instanceID,"Path":path,"Value":value}};
    cmdDoExecute(strJson);
}

//保存文档
function cmdSaveDocument()
{
	var argJson = {action:"SAVE_DOCUMENT", "args":{"params":{"action":"SAVE_DOCUMENT"}}};
	cmdDoExecute(argJson);		
}

///失效签名
function cmdRevokeSignedDocument(signatureLevel,instanceId)
{
	var argJson = {"action":"REVOKE_SIGNED_DOCUMENT","args":{"SignatureLevel":signatureLevel,"InstanceID":instanceId}};
	return cmdSyncExecute(argJson);
}

//保存签名文档及相关操作
function cmdSaveSignDocument(instanceId,signUserId,signLevel,signId,digest,type,path,actionType)
{
	var argJson = {action:"SAVE_SIGNED_DOCUMENT",args:{params:{"action":"SAVE_SIGNED_DOCUMENT","SignUserID":signUserId,"SignID":signId,"SignLevel":signLevel,"Digest":digest,"Type":type,"Path":path,"ActionType":actionType},"InstanceID":instanceId}}
	cmdDoExecute(argJson);
}

//回滚签名
function cmdUnsignDocument()
{
	var argJson = {action:"UNSIGN_DOCUMENT",args:{}}
	cmdDoExecute(argJson);	
}

//撤销签名
function cmdRevokeSignElement(signProperty)
{
	var argJson = {"action":"REVOKE_SIGNED_ELEMENT","args":{"Path":signProperty.Path,params:{"Authenticator":{"Id":signProperty.Id,"Name":signProperty.Name,"Path":signProperty.Path,"SignatureLevel":signProperty.SignatureLevel}}}};
	return cmdSyncExecute(argJson);
}

//打印
function cmdPrintDocument()
{	
	var argJson = {action:"PRINT_DOCUMENT",args:{"actionType":"Print"}}; 
 	cmdDoExecute(argJson);	
}

//删除病历
function cmdDeleteDocument(instanceId)
{
	var json = {action:"DELETE_DOCUMENT",args:{"InstanceID":instanceId}};
	cmdDoExecute(json);		
}

//设置进入或退出打印预览显示模式
function cmdSetPreviewDocumentState(status)
{
	var argJson = {"action":"PREVIEW_DOCUMENT","args":{"Preview":status}};
	cmdDoExecute(argJson);
}

//设置质控颜色
function cmdSetQualityColor(qColor,rColor)
{
	var argJson = {"action":"SET_QC_PARAMS","args":{"QCType":"2","QCColor":qColor,"RecoverColor":rColor}};
	cmdDoExecute(argJson);
}

//获取当前病历只读状态
function cmdGetReadOnlyStatus()
{
	var strJson = {action:"GET_READONLY",args:{}};
	return cmdSyncExecute(strJson);
}

//加载文档
function cmdLoadDocument(instanceId,status,actionType)
{
	var argJson = {action:"LOAD_DOCUMENT",args:{params:{"status":status},InstanceID:instanceId,actionType:actionType}};
	cmdDoExecute(argJson); 	
}


//事件派发
function eventDispatch(commandJson)
{
	if(commandJson["action"] == "eventMRSetView")                   
	{
		//创建网格视图完毕加载网格文档
	    eventCreatorReportorView();
	}
	else if(commandJson["action"] == "eventDocumentChanged")        
	{
		//文档改变
		eventDocumentChanged(commandJson);
	}
	else if(commandJson["action"] == "eventSectionChanged")          
	{ 
		//章节改变
		eventSectionChanged(commandJson);
	}
	else if (commandJson["action"] == "eventSaveDocument")      
	{
		//保存监听
		eventSaveDocument(commandJson);
	}
	else if (commandJson["action"] == "eventQuerySaveDocument")
	{
		//提示用户保存文档
		eventQuerySaveDocument();
	}
	else if (commandJson["action"] == "eventGetDocumentOutline")
	{
		//获得文档大纲
		eventGetDocumentOutline(commandJson);
	}	
	else if(commandJson["action"] == "eventCreateDocument")
	{
		//创建文档后事件
		eventCreateDocument(commandJson);
	}
	else if(commandJson["action"] == "eventSaveSignedDocument")
	{
		//文档签名
		eventSaveSignedDocument(commandJson);
	}
	else if(commandJson["action"] == "eventDeleteDocument")
	{
		eventDeleteDocument(commandJson);
	}
	else if(commandJson["action"] == "eventSave")
	{
		//ctrl+s保存事件
		eventSave();
	}
	else if (commandJson["action"] == "eventInsertSummary")
	{
		eventInsertSummary(commandJson);
	}
	else if (commandJson["action"] == "eventCaretContext")
	{
		eventCaretContext(commandJson);
	}
	else if (commandJson["action"] == "eventLoadDocument")
	{
		eventLoadDocument(commandJson);
	}
	else if (commandJson["action"] == "eventPrintDocument")
	{
		eventPrintDocument(commandJson);
	}
	else if(commandJson["action"] == "eventSendCopyCutData")
	{
		eventSendCopyCutData(commandJson);
	}
	else if (commandJson["action"] == "eventSaveLocalDocument")
	{
		eventSaveLocalDocument(commandJson);
	}
	else if (commandJson["action"] == "eventRequestSign")
	{
		eventRequestSign(commandJson);
	}
	else if (commandJson["action"] == "eventReplaceComposite")
	{
		//判断知识库是否替换成功
		eventReplaceView(commandJson);
	}
	else if (commandJson["action"] == "eventRefreshReferenceData")
	{
		//刷新引用数据
		eventRefreshReferenceData(commandJson);
	}
	else if(commandJson["action"] == "eventHyperLink")
	{
		//连接单元
		eventHyperLink(commandJson);
	}
	else if(commandJson["action"] == "eventUpdateInstanceData")
	{
		eventUpdateInstanceData(commandJson);
	}
}
