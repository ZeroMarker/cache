/**
 * audit.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-04-28
 * 
 * 
 */
$(function() {
	Init();
	InitEvent();
	//PageHandle();
})


function Init(){
	InitCombox()
}

function InitCombox() {
	PLObject.TplReason = $HUI.combobox("#TplReason", {
		url:$URL+"?ClassName=DHCDoc.Chemo.BS.Ext.Audit&QueryName=QryRefuseReason&ResultSetType=array",
		valueField:'id',
		textField:'text',
		blurValidValue:true,
		onSelect: function (record) {
			if (record.id==6) {
				$("#Reason").removeAttr("disabled").val("");
			} else {
				$("#Reason").attr("disabled","disabled").val(record.text);
			}
		}
	});
	
}
function InitEvent () {
	$("#Save").click(Save_Handler);
}
function PageHandle() {

}

function Save_Handler () {
	
	var Reason = $.trim($("#Reason").val());
	if (Reason == "") {
		$.messager.alert("提示", "请填写拒绝原因！", "info");
		return false;
	}
	var PDAID=ServerObj.PDAID
	var Status=""
	if (ServerObj.Type=="KS") {
		Status="RS"	
	} else {
		Status="RY"	
	}
	var mList=Status+"^"+session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID'];
	
	
	$m({
		ClassName:"DHCDoc.Chemo.BS.Ext.Audit",
		MethodName:"Verify",
		PDAID:PDAID,
		Reason:Reason,
		Type:ServerObj.Type,
		mList: mList,
		LinkPDAID:ServerObj.LinkPDAID
	}, function(result){
		if (result == 0) {
			$.messager.alert("提示", "保存成功！", "info", function () {
				websys_showModal("hide");
				websys_showModal('options').CallBackFunc();
				websys_showModal("close");	
			})
		} else {
			var resultArr=result.split("^");
			var Msg = resultArr[1]||"拒绝失败！";
			
			$.messager.alert("提示", Msg , "info");
			return false;
		}
	});
}


