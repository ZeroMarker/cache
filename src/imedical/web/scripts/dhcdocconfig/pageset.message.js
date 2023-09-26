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
	
	if (ServerObj.msid != "") {
		var responseText = $.m({
			ClassName: "web.DHCDocPageDom",
			MethodName: "GetMessageInfo",
			msid: ServerObj.msid,
			sp: sp
		},false);
		
		if (responseText != "") {
			var responseArr = responseText.split(sp);
			$("#mCdoe").val(responseArr[0]);
			$("#mDesc").val(responseArr[1]);
			$("#mOther").val(responseArr[2]);
		}
	}
}



function InitEvent () {
	$("#i-save").click(function () {
		var id = ServerObj.msid;
		var sp = String.fromCharCode(1);
		
		var mCdoe = $.trim($("#mCdoe").val());
		var mDesc = $.trim($("#mDesc").val());
		var mOther = $.trim($("#mOther").val());
		
		if (mCdoe == "") {
			$.messager.alert('提示','请填写消息提示代码！' , "info");
			return false;
		}
		if (mDesc == "") {
			$.messager.alert('提示','请填写消息提示描述！' , "info");
			return false;
		}
		var responseText = $.m({
			ClassName: "web.DHCDocOrderListCommon",
			MethodName: "UpdateMessage",
			ID: id,
			DOPRowId: ServerObj.psRef,
			Code: mCdoe,
			Desc: mDesc,
			OtherDesc: mOther
		},false);
		if (responseText == 0) {
			$.messager.alert('提示','保存成功！' , "info", function () {
				parent.reloadMessageGrid();
				parent.destroyDialog("msEditDiag");
			});
			
			return false;
		}  else {
			$.messager.alert('提示','保存失败：' + responseText , "info");
			return false;
		}

		
	})
}

