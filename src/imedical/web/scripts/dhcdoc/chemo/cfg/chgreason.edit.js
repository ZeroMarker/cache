/**
 * chgreason.edit.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-04-28
 * 
 * 
 */
$(function() {
	Init();
	InitEvent();
})


function Init(){
	InitCombox();
	InitData()
}

function InitEvent () {
	$("#save").click(Save)
}

function InitCombox() {
	PLObject.m_TPL = $HUI.combobox("#tpl", {
		url:$URL+"?ClassName=DHCDoc.Chemo.CFG.Template&InActive=Y&QueryName=QryTPL&ResultSetType=array&InHosp="+ServerObj.InHosp,
		valueField:'id',
		textField:'name',
		blurValidValue:true
	});
	
}

function InitData() {
	if (ServerObj.CRID!="") {
		$cm({
			ClassName:"DHCDoc.Chemo.Model.ChgReason",
			MethodName:"GetInfo",
			CRID: ServerObj.CRID
		},function(MObj){
			$("#reason").val(MObj.CRReason)
			PLObject.m_TPL.select(MObj.CRTemplateDR)
			if (MObj.CRActive == "Y") {
				$("#active").checkbox("check")
			} else {
				$("#active").checkbox("uncheck")
			}
		});
	}
	
}

function Save () {
	var CRID = ServerObj.CRID;
	var TplDR = PLObject.m_TPL.getValue()||"";
	var Reason = $.trim($("#reason").val());
	var Active = $("#active").checkbox("getValue")?"Y":"N";
	var User = session['LOGON.USERID'];
	
	if (Reason == "") {
		$.messager.alert("��ʾ", "����д���ԭ��", "info");
		return false;
	}
	$m({
		ClassName:"DHCDoc.Chemo.CFG.ChgReason",
		MethodName:"Save",
		CRID:CRID,
		TplDR:TplDR,
		Reason:Reason,
		Active:Active,
		InHosp:ServerObj.InHosp
	}, function(result){
		if (result == 0) {
			$.messager.alert("��ʾ", "����ɹ���", "info", function () {
				websys_showModal("hide");
				websys_showModal('options').CallBackFunc();
				websys_showModal("close");	
			});
		} else {
			$.messager.alert("��ʾ", "����ʧ�ܣ�" + result , "info");
			return false;
		}
	});
}
