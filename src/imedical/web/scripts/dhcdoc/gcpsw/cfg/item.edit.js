/**
 * item.edit.js
 * 
 * Copyright (c) 2020-2090 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-09-07
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

function InitData() {
	if (ServerObj.ITID!="") {
		$cm({
			ClassName:"DHCDoc.GCPSW.Model.Item",
			MethodName:"GetInfo",
			id: ServerObj.ITID
		},function(MObj){
			$("#code").val(MObj.ITCode)
			$("#desc").val(MObj.ITDesc)
			/*if (MObj.ITArcim) {
				MObj.ITArcim = MObj.ITArcim.split(",")
				PLObject.m_Arcim.setValues(MObj.ITArcim)
			} else {
				PLObject.m_Arcim.setValues([])
			}
			$("#note").val(MObj.ITNote)*/
		});
	}
}

//医嘱名称
function InitCombox(){
	var InType="L"
	PLObject.m_Arcim = $HUI.combobox("#arcim", {
		url:$URL+"?ClassName=DHCDoc.GCPSW.COM.Qry&QueryName=FindMasterItem&InType="+InType+"&ResultSetType=array",
		valueField:'ArcimDR',
		textField:'ArcimDesc',
		multiple:true,
		blurValidValue:true,
		mode:'remote',
		onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{arcimdesc:desc});
	    }
		
	});
}

function saveHandler() {
	var id = ServerObj.ITID;
	var code = $.trim($("#code").val());
	var desc = $.trim($("#desc").val());
	var note = "";
	var user = GetSession("USER");
	var arcim = "";
	if (code=="") {
		$.messager.alert("提示","代码不能为空！","warning")
		return false;
	}
	
	if (desc=="") {
		$.messager.alert("提示","描述不能为空！","warning")
		return false;
	}
	
	var mList = id+"^"+code+"^"+desc+"^"+note+"^"+user+"^"+arcim;
	
	$m({
		ClassName:"DHCDoc.GCPSW.CFG.Item",
		MethodName:"Save",
		KTID:ServerObj.KTID,
		mList:mList
	}, function(result){
		if (parseInt(result) >= 0) {
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