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
		$.messager.alert("��ʾ","���벻��Ϊ��!","warning")
		return false;
	}
	
	if (desc=="") {
		$.messager.alert("��ʾ","��������Ϊ��!","warning")
		return false;
	}
	if (gcp=="") {
		$.messager.alert("��ʾ","������Ŀ����Ϊ�գ�","warning")
		return false;
	}
	if (startdate=="") {
		$.messager.alert("��ʾ","��ʼ���ڲ���Ϊ��!","warning")
		return false;
	}
	if (enddate=="") {
		$.messager.alert("��ʾ","�������ڲ���Ϊ��!","warning")
		return false;
	}
	var mList = id+"^"+code+"^"+desc+"^"+note+"^"+user+"^"+startdate+"^"+enddate+"^"+gcp;
	
	$m({
		ClassName:"DHCDoc.GCPSW.CFG.Prj",
		MethodName:"Save",
		mList:mList
	}, function(result){
		if (result >= 0) {
			$.messager.alert("��ʾ", "����ɹ���", "info", function () {
				parent.websys_showModal("hide");
				parent.websys_showModal('options').CallBackFunc();
				parent.websys_showModal("close");	
			});
		} else if (result == "-2") {
			$.messager.alert("��ʾ", "�����Ѵ��ڣ�", "warning");
			return false;
		} else if (result == "-3") {
			$.messager.alert("��ʾ", "ɸѡ���ڲ�����Ҫ�󣬸���Ҫ��ɸѡ���ڿ��ư������ڣ�", "warning");
			return false;
		} 
		else {
			$.messager.alert("��ʾ", "����ʧ�ܣ�" + result , "info");
			return false;
		}
	});
	
	
	
}