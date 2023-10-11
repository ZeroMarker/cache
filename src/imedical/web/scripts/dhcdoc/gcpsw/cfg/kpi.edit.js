/**
 * kpit.edit.js
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
	InitData()
	
}

function InitEvent () {
	$("#save").click(saveHandler);
}

function PageHandle() {
	
}

function InitData() {
	if (ServerObj.KPIID!="") {
		$cm({
			ClassName:"DHCDoc.GCPSW.Model.KPI",
			MethodName:"GetInfo",
			id: ServerObj.KPIID
		},function(MObj){
			debug(MObj,"MOBJ")
			$("#code").val(MObj.KPICode)
			$("#name").val(MObj.KPIName)
			$("#express").val(MObj.KPIExpress)
			$("#note").val(MObj.KPINote)
			if (MObj.KPIComplex=="Y") {
				$("#complex").checkbox("check")
			} else {
				$("#complex").checkbox("uncheck")
			}
			
		});
	}
}

function saveHandler() {
	var id = ServerObj.KPIID;
	var KTID = ServerObj.KTID;
	var code = $.trim($("#code").val());
	var name = $.trim($("#name").val());
	var note = $.trim($("#note").val());
	var express = $.trim($("#express").val());
	var user = GetSession("USER");
	var complex = $("#complex").checkbox("getValue")?"Y":"N";
	
	if (code=="") {
		$.messager.alert("��ʾ","ָ����벻��Ϊ�գ�","warning")
		return false;
	}
	
	if (name=="") {
		$.messager.alert("��ʾ","ָ�����Ʋ���Ϊ�գ�","warning")
		return false;
	}
	
	var mList = id+"^"+code+"^"+name+"^"+complex+"^"+note+"^"+user+"^"+express;
	
	$m({
		ClassName:"DHCDoc.GCPSW.CFG.KPI",
		MethodName:"Save",
		KTID:KTID,
		mList:mList
	}, function(result){
		if (parseInt(result) > 0) {
			$.messager.alert("��ʾ", "����ɹ���", "info", function () {
				parent.websys_showModal("hide");
				parent.websys_showModal('options').CallBackFunc();
				parent.websys_showModal("close");	
			});
		} else if (result == "-2") {
			$.messager.alert("��ʾ", "�����Ѵ��ڣ�", "warning");
			return false;
		} else {
			$.messager.alert("��ʾ", "����ʧ�ܣ�" + result , "info");
			return false;
		}
	});
	
	
	
}