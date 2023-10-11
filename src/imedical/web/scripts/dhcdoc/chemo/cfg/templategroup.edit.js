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
	$("#save").click(SaveTPL)
}

function InitCombox() {

	PLObject.m_Code = $HUI.combobox("#code", {
		url:$URL+"?ClassName=DHCDoc.Chemo.COM.Qry&QueryName=QryTPLGroupCode&ResultSetType=array",
		valueField:'id',
		textField:'text',
		mode:'remote',
		blurValidValue:true
	});
	
	PLObject.m_Desc = $HUI.combobox("#desc", {
		url:$URL+"?ClassName=DHCDoc.Chemo.COM.Qry&QueryName=QryChemoDic&ResultSetType=array&InCode=CHEMOGORUP",
		valueField:'id',
		textField:'desc',
		mode:'remote',
		blurValidValue:true
	});
	
}

function InitData() {
	if (ServerObj.TPGID!="") {
		$cm({
			ClassName:"DHCDoc.Chemo.Model.TemplateGroup",
			MethodName:"GetInfo",
			TPGID: ServerObj.TPGID
		},function(MObj){
			PLObject.m_Code.select(MObj.TPGCode);
			PLObject.m_Desc.select(MObj.TPGDesc);
			//$("#desc").val(MObj.TPGDesc);
			$("#planDate").val(MObj.TPGPlanDate);
			$("#note").val(MObj.TPGNote);
			/*if (MObj.TPGVeinFlag == "Y") {
				$("#veinFlag").checkbox("check")
			} else {
				$("#veinFlag").checkbox("uncheck")
			}*/
			if (MObj.TPGMainDrug == "Y") {
				$("#mainDrug").checkbox("check")
			} else {
				$("#mainDrug").checkbox("uncheck")
			}
		});
	}
	
}

function SaveTPL () {
	var TSID = ServerObj.TSID;
	var id = ServerObj.TPGID;
	var code = PLObject.m_Code.getValue()||"";
	var desc = PLObject.m_Desc.getValue()||"";
	//var desc = $.trim($("#desc").val());
	var planDate = $.trim($("#planDate").val());
	var veinFlag = "N"	//$("#veinFlag").checkbox("getValue")?"Y":"N";
	var mainDrug = $("#mainDrug").checkbox("getValue")?"Y":"N";
	var note = $.trim($("#note").val());
	//var user = session['LOGON.USERID'];
	
	if (code == "") {
		$.messager.alert("提示", "请填写组编号！", "info");
		return false;
	}
	if (desc == "") {
		$.messager.alert("提示", "请填写组描述！", "info");
		return false;
	}
	if (planDate == "") {
		//$.messager.alert("提示", "请填写多选化疗日期！", "info");
		//return false;
	}
	
	var mList = id + "^" + code + "^" + desc + "^" + planDate + "^" + veinFlag + "^" + note + "^" + mainDrug;
	$m({
		ClassName:"DHCDoc.Chemo.CFG.Group",
		MethodName:"Save",
		TSID:TSID,
		mList:mList
	}, function(result){
		if (parseInt(result) > 0) {
			$.messager.alert("提示", "保存成功！", "info",function () {
				websys_showModal("hide");
				websys_showModal('options').CallBackFunc();
				websys_showModal("close");	
			});
		} else if (result == "-104") {
			$.messager.alert("提示", "配置已存在！" , "info");
			return false;
		} else {
			$.messager.alert("提示", "保存失败：" + result , "info");
			return false;
		}
	});
}
