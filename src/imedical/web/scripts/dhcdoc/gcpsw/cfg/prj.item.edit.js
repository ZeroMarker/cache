/**
 * kpit.edit.js
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
	InitPLObject();
	InitCombox();
	InitData()
}

function InitEvent () {
	$("#save").click(saveHandler);

}

function PageHandle() {
	
}

function InitPLObject() {
	PLObject.m_Val="";
}

function InitCombox() {
	PLObject.m_KPIType = $HUI.combobox("#kpitype", {
		url:$URL+"?ClassName=DHCDoc.GCPSW.CFG.PrjKPIItem&QueryName=QryItem&PKID="+ServerObj.PKID+"&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true
		/*,onSelect: function (record) {
			var url = $URL+"?ClassName=DHCDoc.GCPSW.CFG.ItemKPI&QueryName=QryKPI&ITID="+record.id+"&ResultSetType=array";
			PLObject.m_KPI.reload(url)
		}*/
	});
	
	/*
	PLObject.m_KPI = $HUI.combobox("#kpi", {
		url:$URL+"?ClassName=DHCDoc.GCPSW.CFG.ItemKPI&QueryName=QryKPI&ResultSetType=array",
		valueField:'id',
		textField:'name',
		blurValidValue:true,
		onSelect: function (record) {
			
		}
	});*/
	PLObject.m_Rule = $HUI.combobox("#rule", {
		url:$URL+"?ClassName=DHCDoc.GCPSW.CFG.PrjKPIItem&QueryName=QryRule&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true,
		onSelect: function (record) {
			
		}
	});
	
}

function InitData() {
	if (ServerObj.PKIID!="") {
		$cm({
			ClassName:"DHCDoc.GCPSW.Model.PrjKPIItem",
			MethodName:"GetInfo",
			id: ServerObj.PKIID
		},function(MObj){
			debug(MObj,"Mobj")
			$("#uom").val(MObj.Uom)
			$("#note").val(MObj.Note)
			if (MObj.Section=="1") {
				$("#section").checkbox("check")
			} else {
				$("#section").checkbox("uncheck")
			}
			PLObject.m_KPIType.select(MObj.KPIType)
			PLObject.m_Rule.select(MObj.Rule)
			$("#val").val(MObj.Val)
			$("#stdval").val(MObj.StdVal)
			setTimeout(function () {
				PLObject.m_KPI.select(MObj.KPI)	
			},100)
			
			
			
		});
	}
}

function saveHandler() {
	var id = ServerObj.PKIID;
	var PKID = ServerObj.PKID;
	var KPI = ""	//PLObject.m_KPI.getValue()||"";
	var section = $("#section").checkbox("getValue")?"1":"0";
	var val = $.trim($("#val").val());
	var stdval = $.trim($("#stdval").val());
	var uom = $.trim($("#uom").val());
	var note = $.trim($("#note").val());
	var user = GetSession("USER");
	var rule = PLObject.m_Rule.getValue()||"";
	var KPIType = PLObject.m_KPIType.getValue()||"";
	if (KPIType=="") {
		$.messager.alert("提示","指标不能为空！","warning")
		return false;
	}

	if (rule == "") {
		//$.messager.alert("提示","匹配模式不能为空！","warning")
		//return false;
	}
	
	if (val=="") {
		$.messager.alert("提示","筛选值不能为空！","warning")
		return false;
	}
	
	
	var mList = id+"^"+KPI+"^"+section+"^"+val+"^"+uom+"^"+user+"^"+note+"^"+stdval+"^"+rule+"^"+KPIType;
	
	$m({
		ClassName:"DHCDoc.GCPSW.CFG.PrjKPIItem",
		MethodName:"Save",
		PKID:PKID,
		mList:mList
	}, function(result){
		if (parseInt(result) > 0) {
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