/**
 * arrange.js 门诊化疗床位管理
 * 
 * Copyright (c) 2020- QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-12-17
 * 
 * 
 */
var PageLogicObj = {
	
}

$(function() {
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
	
	//页面元素初始化
	PageHandle();
})


function Init(){
	LoadDrugList("DrugList");
	InitData();
}

function InitEvent () {
	$("#save").click(Save_Handle)
}

function PageHandle () {
}

function InitData() {
	if (ServerObj.bid!="") {
		$cm({
			ClassName:"DHCDoc.Chemo.Model.Bed",
			MethodName:"GetInfo",
			ID: ServerObj.bid
		},function(MObj){
			$("#address").val(MObj.BAddress);
			if (MObj.BDrugList!="") {
				var TArr = MObj.BDrugList.split(",")		
				for (var i=0; i<TArr.length; i++) {
					$("#DrugList").find("input[value='"+ TArr[i] +"']").checkbox('check');
				}
			}
		});
	}
	
}

function LoadDrugList(Selector) {
	$m({
		ClassName:"DHCDoc.Chemo.BS.Bed.Manage",
		MethodName:"LoadDrugList",
		bid:ServerObj.bid
	}, function(result){
		_$dom = $(result);
		$("#"+Selector).empty();
		$("#"+Selector).append(_$dom);
		$(".c-check").checkbox();
		//$(".card").dblclick(Arrange_Handle)
	});
}

//保存
function Save_Handle () {
	var Address=$.trim($("#address").val());
	var DrugList = [];
	$("#DrugList").find("input[type='checkbox']:checked").each(function () {
		DrugList.push($(this).val());
	})
	DrugList = DrugList.join(",");
	
	if (Address=="") {
		//$.messager.alert("提示", "无法获取床位信息！", "info");
		//return false;
	}
	$m({
		ClassName:"DHCDoc.Chemo.BS.Bed.Manage",
		MethodName:"Edit",
		//UserID:session['LOGON.USERID'],
		bid:ServerObj.bid,
		Address:Address,
		DrugList:DrugList
	}, function(result){
		var reArr=result.split("^")
		if (reArr[0] == 0) {
			$.messager.alert("提示", "修改成功！", "info",function () {
				parent.destroyDialog("Edit_Handle");	
			});
			parent.LoadCard(reArr[1]+"MCard",reArr[1]);
			return true;
		} else {
			$.messager.alert("提示", "修改失败：" + result , "info");
			return false;
		}
	});
		
}


