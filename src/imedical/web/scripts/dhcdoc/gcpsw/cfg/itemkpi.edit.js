/**
 * itemkpi.edit.js
 * 
 * Copyright (c) 2020-2090 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-09-08
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

//医嘱名称
function InitCombox(){
	var InType="L"
	PLObject.m_Arcim = $HUI.combobox("#arcim", {
		url:$URL+"?ClassName=DHCDoc.GCPSW.COM.Qry&QueryName=FindMasterItem&InType="+InType+"&ResultSetType=array",
		valueField:'ArcimDR',
		textField:'ArcimDesc',
		//multiple:true,
		editable:true,
		selectOnNavigation:false,
		blurValidValue:true,
		mode:'remote',
		onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{arcimdesc:desc});
	    }
		
	});
	
	$HUI.combobox("#arcim2",{
		valueField:'id', textField:'text', multiple:true,selectOnNavigation:false,panelHeight:"auto",editable:true,
		data:[
			{id:'css',text:'CSS语言'},{id:'html',text:'HTML语言'}
			,{id:'c',text:'C语言'},{id:'cplus',text:'C++语言'}
			,{id:'java',text:'JAVA语言'},{id:'cache',text:'M语言'}
			,{id:'sql',text:'结构化查询语言'}
		]
	});
	
}

function InitEvent () {
	$("#save").click(saveHandler);
}

function PageHandle() {
	
}

function InitData() {
	if (ServerObj.IKID!="") {
		$cm({
			ClassName:"DHCDoc.GCPSW.Model.ItemKPI",
			MethodName:"GetInfo",
			id: ServerObj.IKID
		},function(MObj){
			$("#code").val(MObj.IKCode)
			$("#name").val(MObj.IKName)
			$("#note").val(MObj.IKNote)
			$("#express").val(MObj.IKExpress)
			if (MObj.IKArcim!="") {
				var IKArcim = MObj.IKArcim.split(",")
				PLObject.m_Arcim.setValues(IKArcim)
			}
			
			if (MObj.IKComplex=="Y") {
				$("#complex").checkbox("check")
			} else {
				$("#complex").checkbox("uncheck")
			}
			
		});
	}
}

function saveHandler() {
	var id = ServerObj.IKID;
	var ITID = ServerObj.ITID;
	var code = $.trim($("#code").val());
	var name = $.trim($("#name").val());
	var note = $.trim($("#note").val());
	var user = GetSession("USER");
	var complex = $("#complex").checkbox("getValue")?"Y":"N";
	var express = $.trim($("#express").val());
	//var arcim = PLObject.m_Arcim.getValue()||"";
	var arcim = PLObject.m_Arcim.getValues();
	arcim = arcim.join(",")
	if (code=="") {
		$.messager.alert("提示","指标代码不能为空！","warning")
		return false;
	}
	
	if (arcim=="") {
		$.messager.alert("提示","医嘱名称不能为空！","warning")
		return false;
	}
	
	var mList = id+"^"+code+"^"+name+"^"+complex+"^"+note+"^"+user+"^"+express+"^"+arcim
	
	$m({
		ClassName:"DHCDoc.GCPSW.CFG.ItemKPI",
		MethodName:"Save",
		ITID:ITID,
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