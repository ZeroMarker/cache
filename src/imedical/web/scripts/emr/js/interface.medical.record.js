$(function(){
	InitDocument(recordParam)
});
//初始化页面
function InitDocument(tempParam)
{  

    
	if (tempParam.actionType=="LOAD")
	{
		doOpen(tempParam); 
		
	}
	else
	{
		if (!doCreate(tempParam)) closeWindow();
	}
}

function doCreate(tempParam)
{
	var result = false;
	pluginType = tempParam.pluginType
	//加载编辑器
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
	parent.$('.tooledit').css("display","block");
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
		
		//$("#pluginWord")[0].initWindow("iEditor") 
		$("#pluginWord")[0].initWindow("iEmrClient");
		initEditor("iEditor");               
		              
		setConnect();  
		SetDefaultFontStyle();
		iword = true;                             	
		$("#containerGrid").css("display","none");
	}
}

//创建gird编辑器
function girdDoc(tempParam)
{
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
		                        
		//$("#pluginGrid")[0].initWindow("iGridEditor");  //创建表格编辑器
		$("#pluginGrid")[0].initWindow("iEmrClient");
		initEditor("iGridEditor");

		setConnect();
		igrid = true;                         //创建视图
	}
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

function cmdDoShellExecute(argJson)
{
	var argJson = {"action":"CLIENT_SHELL","args":argJson};
	plugin().execute(JSON.stringify(argJson));
}

//同步执行execute
function cmdSyncExecute(argJson){
	var result = plugin().syncExecute(JSON.stringify(argJson));
	return jQuery.parseJSON(result);
}

function cmdSyncShellExecute(argJson)
{
	var argJson = {"action":"CLIENT_SHELL","args":argJson};
	return plugin().syncExecute(JSON.stringify(argJson));
};

//建立数据库连接
function setConnect(){
	var strJson = {action:"SET_NET_CONNECT",args:parent.argConnect};
	cmdDoShellExecute(strJson);
}

//设置默认字体
function SetDefaultFontStyle(){
	var strJson = eval("("+"{'action':'SET_DEFAULT_FONTSTYLE','args':{"+setDefaultFontStyle+"}}"+")");
	cmdDoShellExecute(strJson);
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
    cmdDoShellExecute(argJson);
}

//设置工作环境
function setWorkEnvironment(tempParam)
{
	//清空文档
	var argJson = {action:"CLEAN_DOCUMENT",args:""};
	cmdDoShellExecute(argJson);
	//设置工作空间上下文
	argJson = {action:"SET_WORKSPACE_CONTEXT",args:tempParam["chartItemType"]};
	cmdDoShellExecute(argJson);
	//设置书写状态
	argJson = {action:"SET_NOTE_STATE",args:"Edit"};
	cmdDoShellExecute(argJson);
	//设置文字只读颜色
	argJson = {action:"SET_READONLY_COLOR",args:{"color":"0000ff"}};
	cmdDoShellExecute(argJson);	
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
	cmdDoShellExecute(argJson);
}

//创建病历
function createDocument(tempParam)
{
	if (param.emrDocId != tempParam.emrDocId) loadFalg = true;
	var args = "";
	if (tempParam.args) args = tempParam.args;
		
	if (tempParam.actionType == "QUOTATION")
	{
		var strJson = {action:"CREATE_DOCUMENT_BY_INSTANCE",args:{"params":args,"InstanceID":tempParam.pInstanceId,"Title":{"DisplayName":tempParam.text}}};
	}
	else if (tempParam.actionType == "CREATEBYTITLE")
	{
		var strJson = {action:"CREATE_DOCUMENT_BY_TITLE",args:{"params":args,"TitleCode":tempParam.titleCode}};	
	}
	else 
	{
		var strJson = {action:"CREATE_DOCUMENT",args:{"params":args,"Title":{"DisplayName":tempParam.text}}};
	}
	cmdDoShellExecute(strJson);
}

//加载文档
function loadDocument(tempParam)
{
	if (tempParam.pluginType == "DOC") setWorkEnvironment(tempParam); 	                          
	setPatientInfo(tempParam);
	if (param.emrDocId != tempParam.emrDocId) loadFalg = true;
	var status = tempParam["status"];
	//加载文档
	var argJson = {action:"LOAD_DOCUMENT",args:{params:{"status":status},InstanceID:tempParam["id"],actionType:tempParam["actionType"]}};
	cmdDoShellExecute(argJson); 
	
	if (status == "DELETE")
	{
		setReadOnly(true,[tempParam["id"]]);
	}
	else
	{
		//设置引导框
		var isMutex = (tempParam["isMutex"]=="1")?true:false;
		var isGuideBox = (tempParam["isLeadframe"] == "1")?true:false;
		setDocTempalte(tempParam["emrDocId"],isMutex,isGuideBox); 
	} 
}

//加载本地文档
function cmdLoadLocalDocument()
{
	var argJson = {action : "LOAD_LOCAL_DOCUMENT", args:{path:""}};
	cmdDoShellExecute(argJson);
}


//设置创建模板
function setDocTempalte(emrDocId,isMutex,isGuideBox)
{
	var argJson = {action:"SET_DOCUMENT_TEMPLATE",args:{DocID:emrDocId,IsMutex:isMutex,CreateGuideBox:isGuideBox}};
	cmdDoShellExecute(argJson);
}


//获取活动文档上下文
function getDocumentContext(instanceId)
{
	var argJson = {action:"GET_DOCUMENT_CONTEXT",args:{"InstanceID":instanceId}};
	return cmdSyncShellExecute(argJson);
}

//刷新绑定数据
function reloadBinddata(autoRefresh,syncDialogVisible)
{
	var argJson = {"action":"REFRESH_REFERENCEDATA","args":{"InstanceID":"","AutoRefresh":autoRefresh,"SyncDialogVisible":syncDialogVisible,"SilentRefresh":true}};
	cmdDoShellExecute(argJson);	
}

//保存文档
function cmdSaveDocument()
{
	var argJson = {action:"SAVE_DOCUMENT", "args":{"params":{"action":"SAVE_DOCUMENT"}}};
	cmdDoShellExecute(argJson);		
}

//事件派发
function eventDispatch(commandJson)
{
	if (commandJson["action"] == "eventCreateDocument")   
	{
		cmdSaveDocument();
	}
	else if (commandJson["action"] == "eventSaveDocument")      
	{
		//保存监听
		eventSaveDocument(commandJson);
	}
	else if(commandJson["action"] == "eventLoadDocument")
	{
		reloadBinddata(true,false);
	}
	else if (commandJson["action"] =="eventRefreshReferenceData")
	{
		cmdSaveDocument();
	}
	
}

//保存事件监听
function eventSaveDocument(commandJson)
{
	if (commandJson["args"]["result"] == "OK")
	{
	    if (commandJson["args"]["params"]["result"] == "OK")
	    { 
	    	closeWindow();
	    }
	    else
	    {
		    alert('数据保存失败!');
		    closeWindow();
		}
	}
	else if (commandJson["args"]["result"] == "ERROR")
	{
	    alert('保存失败');
	    closeWindow();
	}
	else if (commandJson["args"]["result"] == "INVALID")
    {
		alert('病历存在非法字符，不能保存。'); 
		closeWindow();
    }
}

function closeWindow()
{
	window.opener=null;
	window.open('','_self');
	window.close();	
}
