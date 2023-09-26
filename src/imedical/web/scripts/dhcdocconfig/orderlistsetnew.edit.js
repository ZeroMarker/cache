/**
 * pageset.message.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2019-07-16
 * 
 * 
 */
var PageLogicObj = {
	m_MustFillBox: ""
}

$(function() {
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
	
	//页面元素初始化
	//PageHandle();
})


function Init(){
	InitData();
}

function InitData () {
	var sp = String.fromCharCode(1);
	
	if (ServerObj.keyid != "") {
		var responseText = $.m({
			ClassName: "DHCDoc.DHCDocConfig.AdmColSet",
			MethodName: "GetColSetInfo",
			colid: ServerObj.id,
			sp: sp
		},false);
		
		if (responseText != "") {
			var responseArr = responseText.split(sp);
			$("#code").val(responseArr[0]);
			$("#desc").val(responseArr[1]);
			$("#colWidth").val(responseArr[2]);
			if (responseArr[3] == "Y") {
				$("#hidden").checkbox("check");
			} else {
				$("#hidden").checkbox("uncheck");
			}
			$("#func").val(responseArr[4]);
		}
	}
}



function InitEvent () {
	$("#i-save").click(function () {
		var id = ServerObj.id;
		var sp = String.fromCharCode(1);
		
		var code = $.trim($("#code").val());
		var desc = $.trim($("#desc").val());
		var colWidth = $.trim($("#colWidth").val());
		var func = $.trim($("#func").val());
		var hidden = $("#hidden").checkbox("getValue")?"Y":"N";
		
		if (code == "") {
			$.messager.alert('提示','请填写列ID！' , "info",function(){
				$("#code").focus();
			});
			return false;
		}
		if (desc == "") {
			$.messager.alert('提示','请填写列描述！' , "info",function(){
				$("#desc").focus();
			});
			return false;
		}
		if (colWidth == "") {
			$.messager.alert('提示','请填写列宽！' , "info",function(){
				$("#colWidth").focus();
			});
			return false;
		}
		if (func == "") {
			$.messager.alert('提示','请填写表达式！' , "info",function(){
				$("#func").focus();
			});
			return false;
		}
		
		if (id != "") {	
			var responseText = $.m({
				ClassName: "web.DHCDocOrderListCommon",
				MethodName: "Update",
				RowId: id,
				code: code,
				desc: desc,
				colwidth: colWidth,
				hidden: hidden,
				expression: func
			},false);
			if (responseText == 0) {
				$.messager.alert('提示','保存成功！' , "info", function () {
					parent.findColSet();
					parent.destroyDialog("colEditDiag");
				});
				
				return false;
			}  else {
				$.messager.alert('提示','保存失败：' + responseText , "info");
				return false;
			}
		} else {
			var responseText = $.m({
				ClassName: "web.DHCDocOrderListCommon",
				MethodName: "Add",
				DOGRowId: ServerObj.dgid,
				code: code,
				desc: desc,
				colwidth: colWidth,
				hidden: hidden,
				expression: func
			},false);
			if (responseText == 0) {
				$.messager.alert('提示','保存成功！' , "info", function () {
					parent.findColSet();
					parent.destroyDialog("colEditDiag");
				});
				return false;
			}  else {
				$.messager.alert('提示','保存失败：' + responseText , "info");
				return false;
			}
		}
		

		
	})
}

