/**
 * template.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-04-28
 * 
 * 
 */
PLObject = {
	v_Type: ""
}
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

	PLObject.m_Stage = $HUI.combobox("#stage", {
		url:$URL+"?ClassName=DHCDoc.Chemo.COM.Qry&QueryName=QryTPLStage&TPID="+ServerObj.TPID+"&ResultSetType=array",
		valueField:'id',
		textField:'text',
		mode:'remote',
		blurValidValue:true
	});
}

function InitData() {
	if (ServerObj.TSID!="") {
		$cm({
			ClassName:"DHCDoc.Chemo.Model.TemplateStage",
			MethodName:"GetInfo",
			ID: ServerObj.TSID
		},function(MObj){
			PLObject.m_Stage.select(MObj.TSStage);
			$("#desc").val(MObj.TSDesc);
			$("#startDate").val(MObj.TSStartDate);
			$("#endDate").val(MObj.TSEndDate);
			$("#nextNum").val(MObj.TSNextNum);
			$("#chemoDate").val(MObj.TSChemoDate);
		});
	}
}

function Save () {
	var TPID = ServerObj.TPID;
	var id = ServerObj.TSID;
	var stage = PLObject.m_Stage.getValue()||"";
	var desc = $.trim($("#desc").val());
	var startDate = $.trim($("#startDate").val());
	var endDate = $.trim($("#endDate").val());
	var nextNum = $.trim($("#nextNum").val());
	var chemoDate = $.trim($("#chemoDate").val());
	
	if (stage == "") {
		$.messager.alert("提示", "请填写周期代码！", "info");
		return false;
	}
	if (desc == "") {
		$.messager.alert("提示", "请填写周期描述！", "info");
		return false;
	}
	if (startDate == "") {
		$.messager.alert("提示", "请填写周期开始日期！", "info");
		return false;
	}
	
	if (endDate == "") {
		$.messager.alert("提示", "请填写周期结束日期！", "info");
		return false;
	}
	if (nextNum == "") {
		$.messager.alert("提示", "请填写周期数！", "info");
		return false;
	}
	if (chemoDate == "") {
		$.messager.alert("提示", "请填写化疗日期！", "info");
		return false;
	}
	var mList = id + "^" + stage + "^" + desc + "^" + startDate + "^" + endDate + "^" + nextNum + "^" + chemoDate;
	$m({
		ClassName:"DHCDoc.Chemo.CFG.Stage",
		MethodName:"Save",
		TPID:TPID,
		mList:mList
	}, function(result){
		if (parseInt(result) > 0) {
			$.messager.alert("提示", "保存成功！", "info",function () {
				websys_showModal("hide");
				websys_showModal('options').CallBackFunc();
				websys_showModal("close");	
			});
		} else if (result == "-121") {
			$.messager.alert("提示", "配置已存在！" , "info");
			return false;
		} else {
			$.messager.alert("提示", "保存失败：" + result , "info");
			return false;
		}
	});
}
