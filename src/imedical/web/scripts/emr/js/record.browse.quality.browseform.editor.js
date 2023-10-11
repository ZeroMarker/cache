var loadFalg = false;
var loadContainer = "";

//��ȡ��ǰ���״̬
var _preViewRevision = "";

$(function(){	
	var tempParam = {"id":id,"text":text,"chartItemType":chartItemType,"pluginType":pluginType,"emrDocId":emrDocId,"characteristic":characteristic,"status":status,"Path":path};
	if ((id+text+chartItemType+pluginType+emrDocId+characteristic+status).length){
		loadDocument(tempParam);
	}
	
	if (action == "quality")
    {
	    //����objectǶ��iframe�޷�ֱ�ӵ����ڲ�����
	    //���ü���������ʾ״̬�仯
    	setInterval(function(){
			var status = parent.parent.parent.parent.parent.getViewRevisionFlag()
			if(_preViewRevision !=status)
			{
				setViewRevision(status)
				_preViewRevision = status
			}
		},2000)
    }
});
window.onbeforeunload = function(){
	//�ر�ʱ, ����ƽ̨����
    setSysMenuDoingSth();
	window.close();
}
//�رղ���ҳǩ(����ֹ�رգ���return false)
function onBeforeCloseTab()
{
	setSysMenuDoingSth();
	return true;
}
//�رմ���
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

//�����ĵ�
function loadDocument(tempParam)
{  	
	// ����ƽ̨����������ҳ��
	setSysMenuDoingSth("���ڼ��ز���...");
	var privileges = getPrivilege("BrowsePrivilege",tempParam.id);
	if (privileges.canView == "0")
	{
		$("#promptMessage").css("display","block");
		$("#promptMessage").html('��û��Ȩ�޲鿴 "'+tempParam.text+'"');
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
		//�ж���һ���ĵ��Ǻ�������
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
    
    //���Ӷ�λ
    if (tempParam.Path !="")
    {
	   	focusDocument("",tempParam.Path,"") 
	}
    	
}

///�����༭��//////////////////////////////////////////////////////////////////////////////////////
//����word�༭��
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
		if (action == "reference") setCopyPaste();
	}
	//���ù�������
	setWorkEnvironment(); 
	openDocument();
	setReadOnly();
	if (action == "quality") setViewRevision("true");
}

//����gird�༭��
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
		$("#browspluginGrid")[0].initWindow("iGridEditor");  //�������༭��
		init();
		igrid = true; 
		if (action == "reference") setCopyPaste();                        //������ͼ
	}
	setWorkEnvironment();
	openDocument();	
	setReadOnly();
	if (action == "quality") setViewRevision("true");
}
//�����ĵ�
function openDocument()
{
	if (param.status == "BROWSE")
	{
		getPrivateDomains(param.id,ssgroupId,"VIEW");
	}
	var argJson = {action:"LOAD_DOCUMENT",args:{params:{"status":param.status},InstanceID:param.id,actionType:param.actionType}};
	cmdDoExecute(argJson);	
}

//����ֻ��
function setReadOnly()
{
	argJson = {action:"SET_READONLY",args:{"ReadOnly":true}}
	cmdDoExecute(argJson);		
}

//������ʾ����
function setViewRevision(status)
{
	var argJson = {action:"SET_REVISION_VISIBLE",args: {"Visible":status}}
	cmdDoExecute(argJson);
}

//���ø���ճ��
function setCopyPaste()
{
	if (action == "externalapp")
	{
		var argJson = {"action":"SET_RUNEMR_PARAMS","args":{"EnablePasteCopyExternalData":true,"EnablePasteCopyAcrossPatient":false}};
		cmdDoExecute(argJson);
	}
	else
	{
		var flagExternalData = false, flagAcrossPatient = false;
	    $.ajax({
			type: 'Post',
			dataType: 'json',
			url: '../EMRservice.Ajax.common.cls',
			async: true,
			data: {
				"OutputType":"String",
				"Class":"EMRservice.BL.BLSysOption",
				"Method":"GetCopyPastStatus"
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
}

//��װ�����ʾ
function setUpPlug()
{
	var result = window.showModalDialog("emr.record.downloadplugin.csp?PluginUrl="+pluginUrl,"","dialogHeight:100px;dialogWidth:200px;resizable:yes;status:no");
	if (result)
	{
		window.location.reload();
	}
}
//�ҽӲ��\�¼�����
function pluginAdd() {
	addEvent(plugin(), 'onFailure', function(command){
		//alert(getSysMenuDoingSth());
		//alert(command);
	});
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
		
		if (obj.action == "eventRequestQcPath")
		{
			/*
			alert(JSON.stringify(obj));
			alert(obj.args.Context);
			alert(obj.args.InstanceID);
			alert(obj.args.Path);
			*/
			
			
			window.open("dhc.emr.quality.checkentry.csp?InstanceId="+obj.args.InstanceID+"&Path="+obj.args.Path+"&EpisodeID="+episodeId,"",'resizable=yes,directories=no,top=0,left=350px,width=750px,height=800px');

			
		}
		
		if (parent.eventDispatch)
		{
			parent.eventDispatch(obj);
		}
			
	});
}
//��Ӽ����¼�
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

//���Ҳ��
function plugin() {
	if(param.pluginType == "DOC")
	{
		return $("#browspluginWord")[0];
	}else
	{
		return $("#browspluginGrid")[0];
	}
}

//�첽ִ��execute
function cmdDoExecute(argJson){
	plugin().execute(JSON.stringify(argJson));
};

//ͬ��ִ��
function cmdSyncExecute(argJson){
	return plugin().syncExecute(JSON.stringify(argJson));
};
function init()
{
	//������������
	setConnect();
	//��������ֻ����ɫ
	argJson = {action:"SET_READONLY_COLOR",args:{"color":"#000000"}};
	cmdDoExecute(argJson);	
}
//���ü��ػ���
function setWorkEnvironment()
{
	//����ĵ�
    var argJson = {action:"CLEAN_DOCUMENT",args:""};
    cmdDoExecute(argJson);
	//���ù�������
	var strJson = {"action":"SET_WORKSPACE_CONTEXT","args": param.chartItemType};
	cmdDoExecute(strJson);
	//������д״̬
	argJson = {action:"SET_NOTE_STATE",args:"Browse"};
	cmdDoExecute(argJson);	
	//����Ĭ������
	var strJson = eval("("+"{'action':'SET_DEFAULT_FONTSTYLE','args':{"+setDefaultFontStyle+"}}"+")");
	cmdDoExecute(strJson);
	//���ò���
    var argJson = {action: "SET_PATIENT_INFO",args:{"PatientID":patientId,"EpisodeID":episodeId,"UserID":userID,"UserName":userName,"userLocID":userLocID,"SsgroupID":ssgroupId,"IPAddress":ipAddress}};
    cmdDoExecute(argJson);
}

//�������ݿ�����
function setConnect(){
	var netConnect = "";
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
			"p2":window.location.port,
			"p3":window.location.protocol.split(":")[0]
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

//��λ�ĵ�
function focusDocument(instanceId,path,actionType)
{
	var argJson = {action:"FOCUS_ELEMENT",args:{"InstanceID":instanceId,"Path":path,"actionType":actionType}}
	cmdDoExecute(argJson);
}

//��˽����Ԫ�ؼ���
function getPrivateDomains(InstanceId,groupId,operation)
{
	var argJson = {action:"LOAD_PRIVACY_ELEMENTS",args:{"params":{"InstanceID":InstanceId,"SSgroupID":groupId,"Operation":operation}}};
	return cmdSyncExecute(argJson);	
}

//��ӡ�ĵ�
function printDocument()
{
	var argJson = {action:"PRINT_DOCUMENT",args:{"actionType":"PrintDirectly"}}; 
	cmdDoExecute(argJson);
}
//��ӡԤ��
function previewDocument()
{
	var argJson = {"action":"PREVIEW_DOCUMENT","args":{"Preview":true}};
	cmdDoExecute(argJson);
}

//�����ʿ���ɫ
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
		error : function(d) { alert("�����ʿر�ע��ɫ����");}
	});	
	
	var argJson = {"action":"SET_QC_PARAMS","args":{"QCType":"1","QCColor":qccolor,"RecoverColor":recolor}};
	cmdDoExecute(argJson);
}

///�ű�Ȩ��
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

//�ĵ����سɹ��¼�
function eventLoadDocument(commandJson)
{
	// ����ƽ̨����������ҳ��
	setSysMenuDoingSth();
	loadFalg = false;
	//���ش����ص��ĵ�
	if (loadContainer != "")
	{
		loadDocument(loadContainer);
	}
	if (action == "quality")
	{
		///window.parent.parent.parent.parent.parent.Right.initRevisionStatus();
	}
}

//���ѡ�е��ĵ�����
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

// ƽ̨����
// ����TAB�л��뿪ʱ
var chartOnBlur = function () {
    document.getElementById('chartOnBlur').focus();
    //return true;
    return '' === getSysMenuDoingSth();
}

// ����TAB�л�����ʱ
var chartOnFocus = function () {
    return true;
}

function setSysMenuDoingSth(sthmsg) {
    if ('undefined' != typeof dhcsys_getmenuform) {
		var frm = dhcsys_getmenuform();
		if (frm) {
			var DoingSth = frm.DoingSth || '';
			if ('' != DoingSth) DoingSth.value = sthmsg || '';;
		}
    }
}

function getSysMenuDoingSth() {
    if ('undefined' != typeof dhcsys_getmenuform) {
		var frm = dhcsys_getmenuform();
		if (frm){
			var DoingSth = frm.DoingSth || '';
			if ('' != DoingSth) return DoingSth.value || '';
		}
    }

    return '';
}