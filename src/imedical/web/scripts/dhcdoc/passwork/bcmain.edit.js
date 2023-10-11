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
	InitData()
	
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
		url:$URL+"?ClassName=DHCDoc.PW.CFG.BCMain&QueryName=QryBType&ResultSetType=array",
		valueField:'rowid',
		textField:'desc',
		//required:true,
		blurValidValue:true
	});
	
}

function saveHandler() {
	var id = ServerObj.MID;
	var type = PageLogicObj.m_Type.getValue()||"";
	var desc = $.trim($("#desc").val());
	var active = $("#active").checkbox("getValue")?1:0;
	var Hosp = ServerObj.Hosp;
	
	if (type=="") {
		$.messager.alert("��ʾ","�������Ͳ���Ϊ�գ�","warning")
		return false;
	}
	
	if (desc=="") {
		$.messager.alert("��ʾ","������������Ϊ�գ�","warning")
		return false;
	}
	
	var inPara = type+"^"+desc+"^"+active+"^"+Hosp;
	
	$m({
		ClassName:"DHCDoc.PW.CFG.BCMain",
		MethodName:"Save",
		ID:id,
		inPara:inPara
	}, function(result){
		var result = result.split("^")
		if (result[0] > 0) {
			$.messager.alert("��ʾ", "����ɹ���", "info", function () {
				parent.websys_showModal("hide");
				parent.websys_showModal('options').CallBackFunc(result[0]);
				parent.websys_showModal("close");	
			});
		}  else {
			$.messager.alert("��ʾ", "����ʧ�ܣ�"+result[1] , "info");
			return false;
		}
	});
	
	
	
}