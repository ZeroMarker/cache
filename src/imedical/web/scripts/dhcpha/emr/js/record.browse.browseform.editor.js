var loadFalg = false;
var loadContainer = "";
$(function(){	
	var tempParam = {"id":id,"text":text,"chartItemType":chartItemType,"pluginType":pluginType,"emrDocId":emrDocId,"characteristic":characteristic,"status":status};
	if ((id+text+chartItemType+pluginType+emrDocId+characteristic+status).length){
		loadDocument(tempParam);
	}
});

//关闭窗口
function closeWindow() {
    window.opener = null;
    window.open('', '_self');
    window.close();
}

function autoPrint(){
	var argJson = {action:"PRINT_DOCUMENT",args:{"actionType":"PrintDirectly"}}; 
	var ret=cmdSyncExecute(argJson);
	var obj = JSON.parse(ret);
	if ('OK'==obj.result) { 
	    if (typeof window.external.FinishPrint === 'function') window.external.FinishPrint();
		if (closeAfterPrint == 'Y') closeWindow();
	}
}

//加载文档
function loadDocument(tempParam)
{  	
	var privileges = getPrivilege("BrowsePrivilege",tempParam.id);
	if (privileges.canView == "0")
	{
		$("#promptMessage").css("display","block");
		$("#promptMessage").html('您没有权限查看 "'+tempParam.text+'"');
		if (parent.eventDispatch)
		{
			parent.eventDispatch({"action":"eventLoadDocument"});
		}
		return;
	}
	else
	{
		$("#promptMessage").css("display","none");
	}
    if ((param != "") && (tempParam.emrDocId == param.emrDocId) && (tempParam.characteristic == "1"))
    {
	   focusDocument(tempParam.id,"","First");
	   param = tempParam;
    }
    else
    {
		//判断上一个文档是后加载完成
		if (loadFalg) 
		{
			loadContainer = tempParam;
			return;
		}
		loadContainer = "";
		loadFalg = true;
	  	param = tempParam;
		switch (param.pluginType)
		{
			case "DOC":
				wordDoc();
			break;
			case "GRID":
				girdDoc();
			break;
		    //default:
				//hisData();	
		}
    }
    if (action == "quality")
    {
    	setQualityColor();
    }
    setDataToLog();	
    	
}

///创建编辑器//////////////////////////////////////////////////////////////////////////////////////
//创建word编辑器
function wordDoc()
{
	if(iword)
	{
		$("#containerGrid").css("display","none");
	}
	$("#containerWord").css("display","block");
	if (!iword)
	{
		var objString = "<object id='browspluginWord' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'>"
		objString = objString + "<param name='install-url' value='" + pluginUrl + "'/>";
		objString = objString + "<param name='product' value='GlobalEMR'/>";
		objString = objString + "</object>";
	    document.getElementById("containerWord").innerHTML = objString;
	    if (!$("#browspluginWord")[0].initWindow)
		{
			setUpPlug();
		} 
		pluginAdd(); 
		$("#browspluginWord")[0].initWindow("iEditor");                 
		init();  
		iword = true;                             	
	}
	//设置工作环境
	setWorkEnvironment(); 
	openDocument();
	setReadOnly();
	setViewRevision();
}

//创建gird编辑器
function girdDoc()
{
	$("#containerWord").css("display","none");
	$("#containerGrid").css("display","block");
	if(!igrid)
	{
		var objString = "<object id='browspluginGrid' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'>";         
	    objString = objString + "<param name='install-url' value='" + pluginUrl + "'/>";
	    objString = objString + "<param name='product' value='GlobalEMR'/>";
	    objString = objString + "</object>";
	    document.getElementById("containerGrid").innerHTML = objString;
	    if (!$("#browspluginGrid")[0].initWindow)
		{
			setUpPlug();
		} 
		pluginAdd();                            
		$("#browspluginGrid")[0].initWindow("iGridEditor");  //创建表格编辑器
		init();
		igrid = true;                         //创建视图
	}
	setWorkEnvironment();
	openDocument();	
	setReadOnly();
	setViewRevision();
}
//加载文档
function openDocument()
{
	if (param.status == "BROWSE")
	{
		getPrivateDomains(param.id,ssgroupId,"VIEW");
	}
	var argJson = {action:"LOAD_DOCUMENT",args:{params:{"status":param.status},InstanceID:param.id,actionType:param.actionType}};
	cmdDoExecute(argJson);	
}

function setReadOnly()
{
	argJson = {action:"SET_READONLY",args:{"ReadOnly":true}}
	cmdDoExecute(argJson);		
}

//设置不显示留痕
function setViewRevision()
{
	var argJson = {action:"SET_REVISION_VISIBLE",args: {"Visible":false}}
	cmdDoExecute(argJson);
}

//安装插件提示
function setUpPlug()
{
	var result = window.showModalDialog("emr.record.downloadplugin.csp?PluginUrl="+pluginUrl,"","dialogHeight:100px;dialogWidth:200px;resizable:yes;status:no");
	if (result)
	{
		window.location.reload();
	}
}
//挂接插件\事件监听
function pluginAdd() {
	addEvent(plugin(), 'onFailure', function(command){alert(command);});
    addEvent(plugin(), 'onExecute', function(command){
	    var obj = JSON.parse(command);
		if (obj.action == "eventLoadDocument")
		{
			if (action != "quality") previewDocument();
			eventLoadDocument(obj);
			if ((needPrint == 'Y')&&(obj.args.result == "OK"))
			{
				autoPrint(); 
			}
		}
		if (parent.eventDispatch)
		{
			parent.eventDispatch(obj);
		}
			
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

//查找插件
function plugin() {
	if(param.pluginType == "DOC")
	{
		return $("#browspluginWord")[0];
	}else
	{
		return $("#browspluginGrid")[0];
	}
}

//异步执行execute
function cmdDoExecute(argJson){
	plugin().execute(JSON.stringify(argJson));
};

//同步执行
function cmdSyncExecute(argJson){
	return plugin().syncExecute(JSON.stringify(argJson));
};
function init()
{
	//建立数据连接
	var strJson = {action:"SET_NET_CONNECT",args:argConnect};
	cmdDoExecute(strJson);	
	//设置文字只读颜色
	argJson = {action:"SET_READONLY_COLOR",args:{"color":"#000000"}};
	cmdDoExecute(argJson);	
}
//设置加载环境
function setWorkEnvironment()
{
	//清空文档
    var argJson = {action:"CLEAN_DOCUMENT",args:""};
    cmdDoExecute(argJson);
	//设置工作环境
	var strJson = {"action":"SET_WORKSPACE_CONTEXT","args": param.chartItemType};
	cmdDoExecute(strJson);
	//设置书写状态
	argJson = {action:"SET_NOTE_STATE",args:"Browse"};
	cmdDoExecute(argJson);	
	//设置默认字体
	var strJson = eval("("+"{'action':'SET_DEFAULT_FONTSTYLE','args':{"+setDefaultFontStyle+"}}"+")");
	cmdDoExecute(strJson);
	//设置参数
    var argJson = {action: "SET_PATIENT_INFO",args:{"PatientID":patientId,"EpisodeID":episodeId,"UserID":userID,"UserName":userName,"SsgroupID":ssgroupId,"IPAddress":ipAddress}};
    cmdDoExecute(argJson);
}

//定位文档
function focusDocument(instanceId,path,actionType)
{
	var argJson = {action:"FOCUS_ELEMENT",args:{"InstanceID":instanceId,"Path":path,"actionType":actionType}}
	cmdDoExecute(argJson);
}

//隐私保护元素集合
function getPrivateDomains(InstanceId,groupId,operation)
{
	var argJson = {action:"LOAD_PRIVACY_ELEMENTS",args:{"params":{"InstanceID":InstanceId,"SSgroupID":groupId,"Operation":operation}}};
	return cmdSyncExecute(argJson);	
}

//打印文档
function printDocument()
{
	var argJson = {action:"PRINT_DOCUMENT",args:{"actionType":"PrintDirectly"}}; 
	cmdDoExecute(argJson);
}
//打印预览
function previewDocument()
{
	var argJson = {"action":"PREVIEW_DOCUMENT","args":{"Preview":true}};
	cmdDoExecute(argJson);
}

//设置质控颜色
function setQualityColor()
{
	var qccolor = "",recolor = "";
	jQuery.ajax({
		type: "GET",
		dataType: "json",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data:  {
			"OutputType":"String",
			"Class":"EMRservice.SystemParameter",
			"Method":"QulaityColor"
		},
		success: function(d) {
			if (d != "") qccolor = d.QCColor, recolor = d.RecoverColor;
		},
		error : function(d) { alert("设置质控标注颜色错误");}
	});	
	
	var argJson = {"action":"SET_QC_PARAMS","args":{"QCType":"1","QCColor":qccolor,"RecoverColor":recolor}};
	cmdDoExecute(argJson);
}

///脚本权限
function getPrivilege(type,instanceId)
{
	var result = "0";
	jQuery.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.privilege.cls",
		async: false,
		data: {
			"EpisodeID":  episodeId,
			"PatientID":  patientId,
			"InstanceID": instanceId,
			"Type":       type
		},
		success: function(d) {
			if (d != "") result = eval("("+d+")");
		},
		error : function(d) { alert(action + " error");}
	});
	return result;	
}

//文档加载成功事件
function eventLoadDocument(commandJson)
{
	loadFalg = false;
	//加载待加载的文档
	if (loadContainer != "")
	{
		loadDocument(loadContainer);
	}
}

//鼠标选中的文档内容
function selectedContent()
{
	var argJson = {"action":"GET_SELECT_TEXT","args":""}; 
	var returnvalue = cmdSyncExecute(argJson);
	return JSON.parse(returnvalue)["Value"];
}

function setDataToLog()
{
	if (IsSetToLog == "Y")
	{
		var ModelName = "EMR.Browse";
		var ipAddress = getIpAddress();
		var Condition = "";
		Condition = Condition + '{"patientID":"' + patientId + '",';
		Condition = Condition + '"episodeID":"' + episodeId + '",';
		Condition = Condition + '"userName":"' + userName + '",';
		Condition = Condition + '"userID":"' + userID + '",';
		Condition = Condition + '"ipAddress":"' + ipAddress + '",';
		Condition = Condition + '"id":"' + param["id"] + '",';
		Condition = Condition + '"pluginType":"' + param["pluginType"] + '",';
		Condition = Condition + '"chartItemType":"' + param["chartItemType"] + '",';
		Condition = Condition + '"emrDocId":"' + param["emrDocId"] + '",';
		Condition = Condition + '"status":"' + param["status"] + '",';
		Condition = Condition + '"text":"' + param["text"] + '"}';
		var ConditionAndContent = Condition;
		//alert(ConditionAndContent);
		$.ajax({ 
			type: "POST", 
			url: "../EMRservice.Ajax.SetDataToEventLog.cls", 
			data: "ModelName="+ ModelName + "&ConditionAndContent=" + ConditionAndContent + "&SecCode=" + ""
		});
	}
}