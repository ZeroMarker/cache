var loadFalg = false;
var loadContainer = "";

//获取当前浏览状态
var _preViewRevision = "";

$(function(){	
	var tempParam = {"id":id,"text":text,"chartItemType":chartItemType,"pluginType":pluginType,"emrDocId":emrDocId,"characteristic":characteristic,"status":status,"pdfDocType":pdfDocType};
	if ((id+text+chartItemType+pluginType+emrDocId+characteristic).length){
		loadDocument(tempParam);
	}
	
	if (action == "quality")
    {
        // 若调用时未定义(声明)则会报错，容错处理
        if (typeof parent.parent.parent.parent.parent.getViewRevisionFlag != "function"){
            return;
        }
	    //由于object嵌套iframe无法直接调用内部函数
	    //采用监听留痕显示状态变化
    	setInterval(function(){
			var status = parent.parent.parent.parent.parent.getViewRevisionFlag()
			if(_preViewRevision !== status)
			{
				setViewRevision(status)
				_preViewRevision = status
			}
		},2000)
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
	var obj = cmdSyncExecute(argJson);
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
		$("#promptMessage").html('<img style="position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);"  src="../scripts/emr/image/icon/noview.png"  alt="您没有权限查看当前病历" />');
		if (parent.eventDispatch)
		{
			parent.eventDispatch({"action":"eventLoadDocument"});
		}
		return;
	}
	else
	{
		// 调用平台方法，锁定页面
		setSysMenuDoingSth("正在加载病历...");
		$("#promptMessage").css("display","none");
	}
	//防止因双击触发2次loadDocument导致插件提示命令未注册
	if(loadFalg) return;
	
    if (((typeof tempParam.episodeId == "undefined") || (episodeId == tempParam.episodeId)) && (param != "") && (checkDocument(tempParam.id).result == "OK"))
    {
	   var breakState = getBreakState();
    	if (breakState == "false") return;
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
	    if ((typeof tempParam.episodeId != "undefined") && (episodeId != tempParam.episodeId))
	    {
		    episodeId = tempParam.episodeId;
	    }
		var pluginType = param.pluginType;
		if (param.pdfDocType == "PDF")
        {
            pluginType = "DOC";
        }
		switch (pluginType)
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
		_preViewRevision = "";
    }
    setDataToLog();	
    	
}

///创建编辑器//////////////////////////////////////////////////////////////////////////////////////
//创建word编辑器
function wordDoc()
{

	$("#containerGrid").css("display","none");
    $("#chartOnBlur").focus();
	$("#containerWord").css("display","block");

	var iword = pluginword()
	if(iword==null || iword.innerHTML== undefined  || !iwordFlag)
	{
		
		document.getElementById("containerGrid").innerHTML = "";
		
		var objString = "<object id='browspluginWord' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'>"
		objString = objString + "<param name='install-url' value='" + pluginUrl + "'/>";
		objString = objString + "<param name='product' value='GlobalEMR'/>";
		objString = objString + "</object>";
	    document.getElementById("containerWord").innerHTML = objString;
	    if (!pluginword().initWindow)
		{
			setUpPlug();
		} 
		pluginAdd(); 
		pluginword().initWindow("iEditor");                 
		init();  
		//iword = true; 
		iwordFlag = true;
		igridFlag = false;
		if ((action == "reference")||(action == "externalapp")) { setCopyPaste(); }
        else { setRunEMRParams(); }
	}
	//设置工作环境
	setWorkEnvironment(); 
	openDocument();
	if (action == "quality") setViewRevision("true");
}

//创建gird编辑器
function girdDoc()
{
	$("#containerWord").css("display","none");
    $("#chartOnBlur").focus();
	$("#containerGrid").css("display","block");
	var igrid = plugingrid()
	if(igrid==null || igrid.innerHTML== undefined || !igridFlag)
	{
		
		document.getElementById("containerWord").innerHTML = "";
		
		var objString = "<object id='browspluginGrid' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'>";         
	    objString = objString + "<param name='install-url' value='" + pluginUrl + "'/>";
	    objString = objString + "<param name='product' value='GlobalEMR'/>";
	    objString = objString + "</object>";
	    document.getElementById("containerGrid").innerHTML = objString;
	    if (!plugingrid().initWindow)
		{
			setUpPlug();
		} 
		pluginAdd();                            
		plugingrid().initWindow("iGridEditor");  //创建表格编辑器
		init();
		//igrid = true;
		igridFlag = true;
		iwordFlag = false;
		if ((action === "reference")||(action === "externalapp")) { setCopyPaste(); }                       //创建视图
        else { setRunEMRParams(); }
	}
	setWorkEnvironment();
	openDocument();	
	if (action == "quality") setViewRevision("true");
}
//加载文档
function openDocument()
{
	if (param.status == "BROWSE")
	{
		getPrivateDomains(param.id,ssgroupId,"VIEW");
	}
    var loadMode = "ALL";
    if ((loadDocMode.TitleCode != "")||(loadDocMode.RecordConfig != ""))
    {
        if ((action == "browse")&&(loadDocMode.BrowseConfig == "Y"))
        {
            loadMode = "BATCH";
        }
        if ((action == "reference")&&(loadDocMode.ReferenceConfig == "Y"))
        {
            loadMode = "BATCH";
        }
    }

	//护士浏览需要复制病历内容，所以不展示PDF，传入指定类型Editor时，强制设置LoadType为XML
    var pdfDocType = param.pdfDocType;
    if (viewType == "Editor") pdfDocType = "XML"
    var argJson = {action:"LOAD_DOCUMENT",args:{params:{"status":param.status,"LoadType":pdfDocType,"LoadDocMode":loadMode,"UserLocID":userLocID,"DateTime":param["dateTime"]||""},InstanceID:param.id,actionType:param.actionType}};
	cmdDoExecute(argJson);	
}

//设置只读
function setReadOnly()
{
	argJson = {action:"SET_READONLY",args:{"ReadOnly":true}}
	cmdDoExecute(argJson);		
}

//设置显示留痕
function setViewRevision(status)
{
	var argJson = {action:"SET_REVISION_VISIBLE",args: {"Visible":status}}
	cmdDoExecute(argJson);
}

//设置复制粘贴
function setCopyPaste()
{
    var product = "";
    ///externalapp为门诊历史就诊页面
	if (action == "externalapp")
	{
		product = "OP";
	}
	
    var flagExternalData = false, flagAcrossPatient = false;
    $.ajax({
        type: 'Post',
        dataType: 'json',
        url: '../EMRservice.Ajax.common.cls?MWToken='+getMWToken(),
        async: true,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLSysOption",
            "Method":"GetCopyPastStatus",
            "p1":product
        },
        success: function (ret) {
            if (ret.ExternalData == "N") flagExternalData = true;
            if (ret.AcrossPatient == "N") flagAcrossPatient = true;
            var argJson = {"action":"SET_RUNEMR_PARAMS","args":{"EnablePasteCopyExternalData":flagExternalData,"EnablePasteCopyAcrossPatient":flagAcrossPatient}};
            cmdDoExecute(argJson);
        },
        error: function (ret) {
            alert('setCopyPaste error');
        }
    });
}

//安装插件提示
function setUpPlug()
{
	var result = window.showModalDialog("emr.record.downloadplugin.csp?PluginUrl="+pluginUrl+"&MWToken="+getMWToken(),"","dialogHeight:100px;dialogWidth:200px;resizable:yes;status:no");
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
			setReadOnly();
			if (action != "quality") previewDocument();
			
			eventLoadDocument(obj);
			if ((needPrint == 'Y')&&(obj.args.result == "OK"))
			{
				autoPrint(); 
			}
		}
        else if(obj.action == "eventRequestDoc")
        {
            //按条目加载病程，滚动病历滚动轴，请求病历追加事件
            eventRequestDoc(obj);
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

function pluginword()
{
	return document.getElementById('browspluginWord');
}
function plugingrid()
{
	return document.getElementById('browspluginGrid');
}
//查找插件
function plugin() {
	if ((param.pluginType == "DOC")||(param.pdfDocType == "PDF"))
	{
		//return $("#browspluginWord")[0];
		return pluginword();
	}else
	{
		//return $("#browspluginGrid")[0];
		return plugingrid();
	}
}

//异步执行execute
function cmdDoExecute(argJson){
	plugin().execute(JSON.stringify(argJson));
};

//同步执行
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
};
function init()
{
	//建立数据连接
	setConnect();
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
    var argJson = {action: "SET_PATIENT_INFO",args:{"PatientID":patientId,"EpisodeID":episodeId,"UserID":userID,"UserCode":userCode,"UserName":userName,"UserLocID":userLocID,"SsgroupID":ssgroupId,"IPAddress":ipAddress}};
    cmdDoExecute(argJson);
}

//设置电子病历运行环境参数
function setRunEMRParams()
{
    $.ajax({
		type: 'GET',
		dataType: 'text',
		url: '../EMRservice.Ajax.common.cls?MWToken='+getMWToken(),
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLSysOption",
			"Method":"GetRunEMRParams"
		},
		success: function (ret) {
			if (ret != "") {
                result = eval("("+ret+")");
            }
		},
		error: function (ret) {
			alert('setRunEMRParams error');
		}
	});
	
	//var strJson = {action:"SET_RUNEMR_PARAMS",args:result};
	return cmdSyncExecute(result);
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
		url: '../EMRservice.Ajax.common.cls?MWToken='+getMWToken(),
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
		url: "../EMRservice.Ajax.common.cls?MWToken="+getMWToken(),
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
		url: "../EMRservice.Ajax.privilege.cls?MWToken="+getMWToken(),
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
	// 调用平台方法，锁定页面
	setSysMenuDoingSth();
	loadFalg = false;
	//加载待加载的文档
	if (loadContainer != "")
	{
		loadDocument(loadContainer);
	}
	/*if (action == "quality")
	{
		window.parent.parent.parent.parent.parent.Right.initRevisionStatus();
	}*/
	focusDocument(commandJson.args.InstanceID,"","First");
}

//按条目加载病程，滚动病历滚动轴，请求病历追加事件
function eventRequestDoc(commandJson)
{
    //判断上一个文档是后加载完成
    if (loadFalg) return;
    loadFalg = true;
    var loadDocMode = commandJson["args"]["LoadDocMode"];
    var loadDirection = commandJson["args"]["LoadDirection"];
    var batchMode = commandJson["args"]["BatchMode"];
    var instanceID = commandJson["args"]["InstanceID"];
    var argJson = {"action":"LOAD_DOCUMENT","args":{"params":{"status":"NORMAL","LoadDocMode":loadDocMode,"LoadDirection":loadDirection,"BatchMode":batchMode},"InstanceID":instanceID,"actionType":"LOAD"}};
    var rtn = cmdSyncExecute(argJson);
    loadFalg = false;
    if (rtn["result"] != "OK")
    {
        alert('文档同步追加失败');
    }
}

//鼠标选中的文档内容
function selectedContent()
{
	var argJson = {"action":"GET_SELECT_TEXT","args":""}; 
	var returnvalue = cmdSyncExecute(argJson);
	return returnvalue["Value"];
}

//查询病历instanceId是否已显示在编辑器中
function checkDocument(instanceId)
{
	var argJson = {"action":"CHECK_DOCUMENT","args":{"InstanceID":instanceId}};
	return cmdSyncExecute(argJson);
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
			url: "../EMRservice.Ajax.SetDataToEventLog.cls?MWToken="+getMWToken(),
			data: "ModelName="+ ModelName + "&ConditionAndContent=" + ConditionAndContent + "&SecCode=" + ""
		});
	}
}

window.onbeforeunload = function(){
    //关闭时, 调用平台方法
    setSysMenuDoingSth();
    window.close();
}

// 平台调用
// 诊疗TAB切换离开时
var chartOnBlur = function () {
    document.getElementById('chartOnBlur').focus();
    //return true;
    return '' === getSysMenuDoingSth();
}

// 诊疗TAB切换进入时
var chartOnFocus = function () {
    return true;
}

function setSysMenuDoingSth(sthmsg) {
    if ('undefined' != typeof dhcsys_getmenuform) {
        var frm = dhcsys_getmenuform();
        if (frm) {
            var DoingSth = frm.DoingSth || '';
            if ('' != DoingSth) DoingSth.value = sthmsg || '';
        }
    }
}

function getSysMenuDoingSth() {
    if ('undefined' != typeof dhcsys_getmenuform) {
        var frm = dhcsys_getmenuform();
        if (frm) {
            var DoingSth = frm.DoingSth || '';
            if ('' != DoingSth) return DoingSth.value || '';
        }
    }

    return '';
}

//关闭病历页签(若阻止关闭，则return false)
function onBeforeCloseTab()
{
    setSysMenuDoingSth();
    return true;
}

function getBreakState()
{
	var argJson = {action:"GET_BREAKCHAGE_STATE",args:{"InstanceID":""}};
	var returnvalue = cmdSyncExecute(argJson);
	return returnvalue["BreakState"];
}

//导出文档
function exportDocument()
{
	if (!param || param.id == "GuideDocument")
	{
		setMessage('请选中要导出的文档!','forbid');
		return;
	}
	var argJson = {"action":"SAVE_LOCAL_DOCUMENT","args":{}};
	cmdDoExecute(argJson);
}
