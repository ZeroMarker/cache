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

//ҽ������
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
			{id:'css',text:'CSS����'},{id:'html',text:'HTML����'}
			,{id:'c',text:'C����'},{id:'cplus',text:'C++����'}
			,{id:'java',text:'JAVA����'},{id:'cache',text:'M����'}
			,{id:'sql',text:'�ṹ����ѯ����'}
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
		$.messager.alert("��ʾ","ָ����벻��Ϊ�գ�","warning")
		return false;
	}
	
	if (arcim=="") {
		$.messager.alert("��ʾ","ҽ�����Ʋ���Ϊ�գ�","warning")
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
			$.messager.alert("��ʾ", "����ɹ���", "info", function () {
				parent.websys_showModal("hide");
				parent.websys_showModal('options').CallBackFunc();
				parent.websys_showModal("close");	
			});
		} else if (result == "-2") {
			$.messager.alert("��ʾ", "�����Ѵ��ڣ�", "warning");
			return false;
		} else {
			$.messager.alert("��ʾ", "����ʧ�ܣ�" + result , "info");
			return false;
		}
	});
	
	
	
}