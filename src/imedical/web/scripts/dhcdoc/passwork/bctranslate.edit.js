/**
 * bctranslate.edit.js
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
	if (ServerObj.ID!="") {
		$cm({
			ClassName:"DHCDoc.PW.Model.BCTranslate",
			MethodName:"GetInfo",
			id: ServerObj.ID
		},function(MObj){
			PageLogicObj.m_Product.setValue(MObj.TProductLine)
			$("#code").val(MObj.TCode)
			$("#desc").val(MObj.TDesc)
			
		});
	}
}

function InitCombox() {
	
	PageLogicObj.m_Product = $HUI.combobox("#product", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.LocalConfig&QueryName=QryProductLine&ResultSetType=array",
		valueField:'code',
		textField:'name'
	});
	
}

function saveHandler() {
	var id = ServerObj.ID;
	var pline = PageLogicObj.m_Product.getValue()||"";
	var code = $.trim($("#code").val());
	var desc = $.trim($("#desc").val());
	if (pline=="") {
		$.messager.alert("提示","产品线不能为空！","warning")
		return false;
	}
	
	if (code=="") {
		$.messager.alert("提示","表名不能为空！","warning")
		return false;
	}
	
	if (desc=="") {
		$.messager.alert("提示","描述不能为空！","warning")
		return false;
	}
	
	var inPara = pline+"^"+code+"^"+desc;
	
	$m({
		ClassName:"DHCDoc.PW.CFG.BCTranslate",
		MethodName:"Save",
		ID:id,
		inPara:inPara
	}, function(result){
		var result = result.split("^")
		if (result[0] > 0) {
			$.messager.alert("提示", "保存成功！", "info", function () {
				parent.websys_showModal("hide");
				parent.websys_showModal('options').CallBackFunc(result[0]);
				parent.websys_showModal("close");	
			});
		}  else {
			$.messager.alert("提示", "保存失败："+result[1] , "info");
			return false;
		}
	});
	
	
	
}