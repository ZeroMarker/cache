/**
 * nmain.resubmit.js
 * 
 * Copyright (c) 2020-2090 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-09-02
 * 
 * 
 */

var PageLogicObj = {
	m_BCCode:""
}

$(function() {
	Init();
	InitEvent();
	PageHandle();
})


function Init(){
	InitHISUI();
	InitDate();
	InitCombox();
}

function InitEvent () {
	$("#Save").click(SaveHandler);
}

function InitCombox() {
	PageLogicObj.m_BCCode = $HUI.combobox("#BCCode", {
		url:$URL+"?ClassName=DHCDoc.PW.CFG.BCTime&QueryName=QryBCTimeByLocID&LocID="+session['LOGON.CTLOCID']+"&ResultSetType=array",
		valueField:'code',
		textField:'bcText',
		multiple:true,
		rowStyle:'checkbox', 
		blurValidValue:true,
		editable:false
	});
	
}

function InitDate() {
	$("#BCDate").datebox({
		//required:true,
		editable:false
	})	
	
}

function PageHandle() {
	$('#BCDate').datebox('calendar').calendar({
        validator: function (date) {
            var curr_time = new Date()
            var d1 = new Date(curr_time.getFullYear(), curr_time.getMonth(), curr_time.getDate());
            return d1 > date;
        }
    });
}

function InitHISUI () {
	$.extend($.fn.datebox.defaults, {
		currentText: ""
	});
}


function SaveHandler() {
	var BCDate = $('#BCDate').datebox("getValue")||"";
	var BCCodeStr = PageLogicObj.m_BCCode.getValues();
	BCCodeStr = BCCodeStr.join(",")
	if (BCCodeStr == "") {
		$.messager.alert("提示", "请选择补交班次！", "info");
		return false;
	}
	if (BCDate == "") {
		$.messager.alert("提示", "请选择补交日期！", "info");
		return false;
	}
	var C1 = String.fromCharCode(1);
	var InPara = BCDate+C1+session['LOGON.CTLOCID']+C1+session['LOGON.USERID']+C1+session['LOGON.HOSPID']
	
	$m({
		ClassName:"DHCDoc.PW.BS.NMain",
		MethodName:"ReSubmit",
		BCCodeStr:BCCodeStr,
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