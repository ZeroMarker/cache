/**
 * stage.js
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
	InitData()
	
}

function InitEvent () {
	$("#save").click(saveHandler);
}

function PageHandle() {
	
}

function InitCombox() {
	PageLogicObj.m_Project = $HUI.combobox("#Project", {
		url:$URL+"?ClassName=web.PilotProject.Extend.Stage&QueryName=QryGCP&InHosp="+ServerObj.InHosp+"&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		//required:true,
		value:ServerObj.PPRowId,
		blurValidValue:true,
		onBeforeLoad:function(param){
			param.inDesc = param["q"];
		}
	});
}


function InitData() {
	$cm({
		ClassName:"web.PilotProject.Model.Stage",
		MethodName:"GetInfo",
		id: ServerObj.ID
	},function(MObj){
		//debug(MObj,"MObj")
		if (ServerObj.ID!="") {
			$("#code").numberbox("setValue",MObj.STCode);
			$("#name").val(MObj.STName);
			//$("#days").numberbox("setValue",MObj.STDays);
			if (MObj.STActive==1) {
				$("#active").checkbox("check")
			} else {
				$("#active").checkbox("uncheck")
			}
			if (MObj.STProject) {
				PageLogicObj.m_Project.setValue(MObj.STProject)
			}
		}
		//$("#seqno").numberbox("setValue", MObj.STSeqno);

	});
	
}

function saveHandler() {
	var id = ServerObj.ID;
	var code = $.trim($("#code").val());
	var name = $.trim($("#name").val());
	var seqno = ""	//$.trim($("#seqno").val());
	var project = PageLogicObj.m_Project.getValue()||"";
	var active = $("#active").checkbox("getValue")?1:0;
	var days = ""	//$.trim($("#days").val());
	if (project=="") {
		$.messager.alert("��ʾ","������Ŀ����Ϊ�գ�","warning")
		return false;
	}
	if (code=="") {
		$.messager.alert("��ʾ","�ڼ��׶β���Ϊ�գ�","warning")
		return false;
	}
	if (name=="") {
		$.messager.alert("��ʾ","�׶����Ʋ���Ϊ��!","warning")
		return false;
	}
	if (seqno=="") {
		//$.messager.alert("��ʾ","�׶�˳����Ϊ��!","warning")
		//return false;
	} 
	
	var mList = id+"^"+code+"^"+name+"^"+seqno+"^"+project+"^"+active+"^"+days;

	$m({
		ClassName:"web.PilotProject.Extend.Stage",
		MethodName:"SaveDic",
		mList:mList
	}, function(result){
		if (result >= 0) {
			$.messager.alert("��ʾ", "����ɹ���", "info", function () {
				websys_showModal("hide");
				websys_showModal('options').CallBackFunc();
				websys_showModal("close");	
			});
		} else if (result == "-102") {
			$.messager.alert("��ʾ", "�����Ѵ��ڣ�", "warning");
			return false;
		} else {
			$.messager.alert("��ʾ", "����ʧ�ܣ�" + result , "info");
			return false;
		}
	});
	
	
	
}