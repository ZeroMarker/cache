/**
 * bcmain.edit.js
 * 
 * Copyright (c) 2020-2090 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-09-02
 * 
 * 
 */

var PageLogicObj = {
	m_Type:""
}

$(function() {
	Init();
	InitEvent();
	//PageHandle();
})


function Init(){
	InitCombox();
	//InitData()
	
}

function InitEvent () {
	$("#save").click(saveHandler);
}

function PageHandle() {
	
}


function InitData() {
	if (ServerObj.MID!="") {
		$cm({
			ClassName:"DHCDoc.PW.Model.BCMain",
			MethodName:"GetInfo",
			id: ServerObj.MID
		},function(MObj){
			PageLogicObj.m_Type.setValue(MObj.BMType)
			$("#desc").val(MObj.BMDesc)
			if (MObj.BMActive==1) {
				$("#active").checkbox("check");
			} else {
				$("#active").checkbox("uncheck");
			}
		});
	}
}

function InitCombox() {
	PageLogicObj.m_Type = $HUI.combobox("#type", {
		url:$URL+"?ClassName=DHCDoc.GCP.CFG.Auth&QueryName=FindGroup&InHosp="+ServerObj.InHosp+"&InType="+ServerObj.InType+"&ResultSetType=array",
		valueField:'AValueDR',
		textField:'desc',
		//required:true,
		defaultFilter:4,
		blurValidValue:true
	});
	
}

function saveHandler() {
	var AValue=PageLogicObj.m_Type.getValue()||"";
	if (AValue=="") {
		$.messager.alert("提示","描述不能为空！","warning")
		return false;
	}

	var BaseParamObj = {
		ID:"",
		AActive:1,
		AHospID:ServerObj.InHosp,
		AType:ServerObj.InType,
		AValue:AValue,
		AAddUser:session['LOGON.USERID']
	}
	
	var BaseParamJson=JSON.stringify(BaseParamObj);
	
	$m({
		ClassName:"DHCDoc.GCP.CFG.Auth",
		MethodName:"Save",
		BaseParamJson:BaseParamJson
	}, function(result){
		result = result.split("^")
		if (result[0]> 0) {
			$.messager.alert("提示", "保存成功！", "info", function () {
				websys_showModal("hide");
				websys_showModal('options').CallBackFunc();
				websys_showModal("close");	
			});
		} else {
			$.messager.alert("提示", result[1] , "warning");
			return false;
		}
	});
	
	
	
	
}