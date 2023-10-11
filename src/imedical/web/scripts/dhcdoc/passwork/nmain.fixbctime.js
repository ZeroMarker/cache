/**
 * nmain.fixbctime.js
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

function InitCombox() {
	PageLogicObj.m_nextday = $HUI.combobox("#nextDay",{
		valueField:'id',
		textField:'text',
		multiple:false,
		//rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'0',text:$g('不跨日')},{id:'1',text:$g('单跨明天')},{id:'2',text:$g('横跨今天和明天')}
		]
	});	
}

function PageHandle() {
	
}
function InitData() {
	if (ServerObj.NID!="") {
		$cm({
			ClassName:"DHCDoc.PW.Model.NMainInfo",
			MethodName:"GetInfo",
			id: ServerObj.NID
		},function(MObj){
			if (MObj.STime) {
				$("#i-diag-stime").timespinner("setValue", MObj.STime);
			}
			if (MObj.ETime) {
				$("#i-diag-etime").timespinner("setValue", MObj.ETime);
			}
			if (MObj.NextDay) {
				PageLogicObj.m_nextday.setValue(MObj.NextDay)
			}
		});
	} else {
		
	}
}

function SaveHandler() {
	var stime = $("#i-diag-stime").timespinner("getValue")||"";
    var etime = $("#i-diag-etime").timespinner("getValue")||"";
    var nextDay = PageLogicObj.m_nextday.getValue()||"";
	if (stime == "") {
		$.messager.alert("提示", "开始时间不能为空！", "info");
		return false;
	}
	if (etime == "") {
		$.messager.alert("提示", "结束时间不能为空！", "info");
		return false;
	}
	if (nextDay == "") {
		$.messager.alert("提示", "跨日标志不能为空！", "info");
		return false;
	}
	var C1 = String.fromCharCode(1);
	var InPara = session['LOGON.USERID']+C1+stime+C1+etime+C1+nextDay
	
	$m({
		ClassName:"DHCDoc.PW.BS.NMain",
		MethodName:"FixBC",
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