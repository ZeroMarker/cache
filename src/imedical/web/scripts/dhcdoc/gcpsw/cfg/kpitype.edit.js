/**
 * kpitype.edit.js
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
	if (ServerObj.KTID!="") {
		$cm({
			ClassName:"DHCDoc.GCPSW.Model.KPIType",
			MethodName:"GetInfo",
			id: ServerObj.KTID
		},function(MObj){
			$("#code").val(MObj.KTCode)
			$("#desc").val(MObj.KTDesc)
			$("#note").val(MObj.KTNote)
		});
	}
}

function InitCombox() {
	PLObject.m_Stage = $HUI.combobox("#stage", {
		url:$URL+"?ClassName=web.PilotProject.Extend.Stage&QueryName=QryStageDic&ResultSetType=array",
		valueField:'id',
		textField:'name',
		//required:true,
		blurValidValue:true,
		mode:'remote',
		onBeforeLoad:function(param){
			param.Desc = param["q"];
		},
		onSelect: function () {
			
		}
	});
	
}

function saveHandler() {
	var id = ServerObj.KTID;
	var code = $.trim($("#code").val());
	var desc = $.trim($("#desc").val());
	var note = $.trim($("#note").val());
	var user = GetSession("USER");
	
	if (code=="") {
		$.messager.alert("提示","代码不能为空","warning")
		return false;
	}
	
	if (desc=="") {
		$.messager.alert("提示","描述不能为空","warning")
		return false;
	}
	
	var mList = id+"^"+code+"^"+desc+"^"+note+"^"+user;
	
	$m({
		ClassName:"DHCDoc.GCPSW.CFG.KPIType",
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
		} else {
			$.messager.alert("提示", "保存失败：" + result , "info");
			return false;
		}
	});
	
	
	
}