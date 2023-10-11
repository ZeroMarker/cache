/**
 * freeorder.copy.js
 * 
 * Copyright (c) 2021-2022 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2021-01-18
 * 
 * 
 */
var PGObject = {
	
}

$(function() {
	Init();
	InitEvent();
})


function Init(){
	InitCombox();
}

function InitEvent () {
	$("#Save").click(Save_Handle)
}

function InitCombox() {
	PGObject.m_Stage = $HUI.combobox("#PPFPrjStage", {
		url:$URL+"?ClassName=web.PilotProject.Extend.Stage&QueryName=QryStage&PrjDR="+ServerObj.PPRowId+"&ResultSetType=array",
		valueField:'id',
		textField:'stageDesc',
		//required:true,
		blurValidValue:true
	});
	
}

function Save_Handle () {
	var toStage = PGObject.m_Stage.getValue()||"";
	//var ExpStr = session['LOGON.USERID'];
	var ExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID'];
	if (toStage == "") {
		$.messager.alert("提示","请选择复制到哪一阶段！","warning")
		return false;
	}
	$m({
			ClassName: "web.PilotProject.CFG.FindGCP",
			MethodName: "CopyFreeOrder",
			PPRowId:ServerObj.PPRowId,
			ids: ServerObj.ids,
			toStage: toStage,
			ExpStr:ExpStr,
			dataType:"text"
		},function(result){
			if (result==0) {
				websys_showModal("hide");
				websys_showModal('options').CallBackFunc();
				websys_showModal("close");	
			} else {
				$.messager.alert("提示","复制失败！","warning")
				return false;
			}
	});
	
}
