/**
 * prj.edit.js
 * 
 * Copyright (c) 2020-2090 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-09-02
 * 
 * 
 */
$(function() {
	Init();
	InitEvent();
	//PageHandle();
})


function Init(){
	InitCombox();
	InitData();
	
}

function InitEvent () {
	$("#save").click(saveHandler);
}

function PageHandle() {
	
}

function InitData() {
	if (ServerObj.PID!="") {
		$cm({
			ClassName:"DHCDoc.GCPSW.Model.Prj",
			MethodName:"GetInfo",
			id: ServerObj.PID
		},function(MObj){
			//debug(MObj,"MObj")
			$("#code").val(MObj.PCode)
			$("#desc").val(MObj.PDesc)
			$("#note").val(MObj.PNote)
			$("#startdate").datebox("setValue",MObj.PStartDate)
			$("#enddate").datebox("setValue",MObj.PEndDate)
			PLObject.m_GCP.setValue(MObj.PPPRowId)
		});
	}
}

function InitCombox() {
	PLObject.m_GCP = $HUI.combobox("#gcp", {
		//url:$URL+"?ClassName=DHCDoc.GCPSW.COM.Qry&QueryName=QryGCP&ResultSetType=array",
		url:$URL+"?ClassName=DHCDoc.GCPSW.COM.Qry&QueryName=QryGCP&UserID="+session['LOGON.USERID']+"&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		//required:true,
		blurValidValue:true,
		mode:'remote',
		defaultFilter:4,
		onBeforeLoad:function(param){
			param.inDesc = param["q"];
		},
		onSelect: function (r) {
			$("#code").val(r.code)
		}
	});
	
}

function saveHandler() {
	var id = ServerObj.PID;
	var code = $.trim($("#code").val());
	var desc = $.trim($("#desc").val());
	var note = $.trim($("#note").val());
	var user = GetSession("USER");
	var startdate = $("#startdate").datebox("getValue")||"";
	var enddate = $("#enddate").datebox("getValue")||"";
	var gcp = PLObject.m_GCP.getValue()||"";
	
	if (code=="") {
		$.messager.alert("提示","代码不能为空!","warning")
		return false;
	}
	
	if (desc=="") {
		$.messager.alert("提示","描述不能为空!","warning")
		return false;
	}
	if (gcp=="") {
		$.messager.alert("提示","科研项目不能为空！","warning")
		return false;
	}
	if (startdate=="") {
		$.messager.alert("提示","开始日期不能为空!","warning")
		return false;
	}
	if (enddate=="") {
		$.messager.alert("提示","结束日期不能为空!","warning")
		return false;
	}
	var mList = id+"^"+code+"^"+desc+"^"+note+"^"+user+"^"+startdate+"^"+enddate+"^"+gcp;
	
	$m({
		ClassName:"DHCDoc.GCPSW.CFG.Prj",
		MethodName:"Save",
		mList:mList
	}, function(result){
		if (result >= 0) {
			$.messager.alert("提示", "保存成功！", "info", function () {
				parent.websys_showModal("hide");
				parent.websys_showModal('options').CallBackFunc();
				parent.websys_showModal("close");	
			});
		} else if (result == "-2") {
			$.messager.alert("提示", "配置已存在！", "warning");
			return false;
		} else if (result == "-3") {
			$.messager.alert("提示", "筛选日期不满足要求，根据要求：筛选日期控制半年以内！", "warning");
			return false;
		} 
		else {
			$.messager.alert("提示", "保存失败：" + result , "info");
			return false;
		}
	});
	
	
	
}