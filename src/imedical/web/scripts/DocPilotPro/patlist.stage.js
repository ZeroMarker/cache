/**
 * patlist.stage.js
 * 
 * Copyright (c) 2020-2090 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-09-28
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
	//InitData()
	
}

function InitEvent () {
	$("#save").click(saveHandler);
}

function PageHandle() {
	
}

function InitData() {
	if (ServerObj.ITID!="") {
		$cm({
			ClassName:"DHCDoc.GCPSW.Model.Item",
			MethodName:"GetInfo",
			id: ServerObj.ITID
		},function(MObj){
			debug(MObj,"kk")
			$("#code").val(MObj.ITCode)
			$("#desc").val(MObj.ITDesc)
			if (MObj.ITArcim) {
				PLObject.m_Arcim.setValue(MObj.ITArcim)
			} else {
				PLObject.m_Arcim.setValue("")
			}
			$("#note").val(MObj.ITNote)
		});
	}
}

//ҽ������
function InitCombox(){
	PLObject.m_Stage = $HUI.combobox("#stage", {
		url:$URL+"?ClassName=web.PilotProject.Extend.Stage&QueryName=QryStage&PrjDR="+ServerObj.PPRowId+"&ResultSetType=array",
		valueField:'id',
		textField:'stageDesc',
		//required:true,
		panelHeight: 'auto',
		blurValidValue:true
	});
}

function saveHandler() {
	var stage = PLObject.m_Stage.getValue()||"";
	if (stage=="") {
		$.messager.alert("��ʾ",$g("�׶β���Ϊ�գ�"),"warning")
		return false;
	}
	
	$m({
		ClassName:"web.PilotProject.Extend.PatList",
		MethodName:"SaveStage",
		PPPatid:ServerObj.PPPatid,
		StageDr:stage
	}, function(result){
		if (result == 0) {	//parseInt(result)
			$.messager.alert("��ʾ", $g("����ɹ���"), "info", function () {
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