/**
 * nmain.submit.js
 * 
 * Copyright (c) 2020-2090 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-09-02
 * 
 * 
 */

var PageLogicObj = {
	
}

$(function() {
	Init();
	InitEvent();
	PageHandle();
})


function Init(){
	InitCombox();
	InitData();
}

function InitEvent () {
	$("#Save").click(SaveHandler);
}

function PageHandle() {
	
}

function InitCombox() {
	PageLogicObj.m_SubmitUser = $HUI.combobox("#SubmitUser", {
		url:$URL+"?ClassName=DHCDoc.PW.COM.Query&QueryName=QryHisDoc&LocId="+session['LOGON.CTLOCID']+"&ResultSetType=array",
		valueField:'id',
		textField:'text',
		blurValidValue:true,
		mode:'remote',
		onBeforeLoad:function(param){
			param.Desc = param["q"];
		}
	});
	
	PageLogicObj.m_AcceptUser = $HUI.combobox("#AcceptUser", {
		url:$URL+"?ClassName=DHCDoc.PW.COM.Query&QueryName=QryHisDoc&LocId="+session['LOGON.CTLOCID']+"&ResultSetType=array",
		valueField:'id',
		textField:'text',
		blurValidValue:true,
		mode:'remote',
		onBeforeLoad:function(param){
			param.Desc = param["q"];
		}
	});
	
	
}

function InitData() {
	if (ServerObj.NID!="") {
		$cm({
			ClassName:"DHCDoc.PW.Model.NMainInfo",
			MethodName:"GetInfo",
			id: ServerObj.NID
		},function(MObj){
			if (MObj.AcceptUserID) {
				PageLogicObj.m_AcceptUser.setValue(MObj.AcceptUserID)
			}
			if (MObj.SubmitUserID) {
				PageLogicObj.m_SubmitUser.setValue(MObj.SubmitUserID)
			}
		});
	} else {
		
	}
}

function SaveHandler() {
	var SubmitUser = PageLogicObj.m_SubmitUser.getValue()||"";
	var AcceptUser = PageLogicObj.m_AcceptUser.getValue()||"";
	if (SubmitUser == "") {
		//$.messager.alert("提示", "交班医生不能为空", "info");
		//return false;
	}
	var C1 = String.fromCharCode(1);
	var InPara = session['LOGON.USERID']+C1+SubmitUser+C1+AcceptUser
	
	$m({
		ClassName:"DHCDoc.PW.BS.NMain",
		MethodName:"SumbitPW",
		NID:ServerObj.NID,
		InPara:InPara
	}, function(result){
		var result = result.split("^")
		if (result[0] > 0) {
			$.messager.alert("提示", "保存成功！", "info",function () {
				parent.websys_showModal("hide");
				parent.websys_showModal('options').CallBackFunc();
				parent.websys_showModal("close");	
			});
		}  else {
			$.messager.alert("提示", "保存失败："+result[1] , "info");
			return false;
		}
	});	
	
}