/**
 * arrange.js 门诊化疗床位管理
 * 
 * Copyright (c) 2020- QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-12-17
 * 
 * 
 */
var PLObject = {
	
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
	InitCombox();
	InitData();
	
}

function InitEvent () {
	$("#save").click(Save_Handle)
}

function PageHandle () {
}

function InitCombox() {
	PLObject.m_ChemoPlan = $HUI.combobox("#ChemoPlan", {
		url:$URL+"?ClassName=DHCDoc.Chemo.BS.Bed.Manage&QueryName=ChemoPlanQry&PatientID="+ServerObj.PatientID+"&InHosp="+session['LOGON.HOSPID']+"&ResultSetType=array",
		valueField:'id',
		textField:'PLName',
		blurValidValue:true,
		onSelect: function (record) {
			LoadDrugList("DrugList",record.id);
			SetAdmLoc(record.id);
		}
	});
	
	/*
	PLObject.m_ComLoc = $HUI.combobox("#ComLoc", {
		url:$URL+"?ClassName=DHCDoc.Chemo.BS.Bed.Manage&QueryName=QryChemoDep&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true,
		onSelect: function (record) {
			PLObject.m_OtherLoc.clear();
		}
	});
	*/
	
	PLObject.m_OtherLoc = $HUI.combobox("#AdmLoc", {
		url:$URL+"?ClassName=DHCDoc.Chemo.BS.Bed.Manage&QueryName=QryChemoOtherDep&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		disabled:true,
		blurValidValue:true,
		onSelect: function (record) {
			PLObject.m_ComLoc.clear();
		}
	});
}

function InitData() {
	if (ServerObj.bid!="") {
		$cm({
			ClassName:"DHCDoc.Chemo.Model.Bed",
			MethodName:"GetInfo",
			ID: ServerObj.bid
		},function(MObj){
			console.log(MObj)
			//$("#address").val(MObj.BAddress);
			//PLObject.m_ChemoPlan.setValue(MObj.BPlanDR);
			$("#HasChemoPlanDR").val(MObj.BPlanDR)
			$("#HasChemoPlan").val(MObj.BPlanName)
			/*
			if (typeof MObj.BDrugList!="undefined") {
				if (MObj.BDrugList!="") {
					var TArr = MObj.BDrugList.split(",")		
					for (var i=0; i<TArr.length; i++) {
						$("#DrugList").find("input[value='"+ TArr[i] +"']").checkbox('check');
					}
				}
			}
			*/
			
			
			if (typeof MObj.BComLoc!="undefined") {
				//PLObject.m_ComLoc.setValue(MObj.BComLoc);
			} else if (typeof MObj.BOtherLoc!="undefined") {
				PLObject.m_OtherLoc.setValue(MObj.BOtherLoc);
			} else {}
		});
	}
	
}

function SetAdmLoc(PlanDR) {
	$m({
		ClassName:"DHCDoc.Chemo.BS.Bed.Manage",
		MethodName:"GetAdmLoc",
		PlanDR:PlanDR||""
	}, function(result){
		PLObject.m_OtherLoc.setValue(result);
	});
}

function LoadDrugList(Selector,PlanDR) {
	$m({
		ClassName:"DHCDoc.Chemo.BS.Bed.Manage",
		MethodName:"LoadDrugList",
		bid:ServerObj.bid,
		ChemoDate:ServerObj.ChemoDate,
		PlanDR:PlanDR||""
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
	var Address=""	//$.trim($("#address").val());
	var DrugList = "";
	/*
	var DrugList = [];
	$("#DrugList").find("input[type='checkbox']:checked").each(function () {
		DrugList.push($(this).val());
	})
	DrugList = DrugList.join(",");
	*/
	
	var AdmLoc = "";
	//var ComLoc = PLObject.m_ComLoc.getValue()||"";
	//var OtherLoc = PLObject.m_OtherLoc.getValue()||"";
	
	if (ServerObj.bid=="") {
		var ChemoPlan = PLObject.m_ChemoPlan.getValue()||""; 
	} else {
		var ChemoPlan =  PLObject.m_ChemoPlan.getValue()||""; 
		if (ChemoPlan == "") ChemoPlan = $("#HasChemoPlanDR").val();
	}
	if (ChemoPlan=="") {
		$.messager.alert("提示", "请关联化疗方案！", "info");
		return false;
	}
	/*
	if ((ComLoc=="")&&(OtherLoc=="")) {
		$.messager.alert("提示", "请填写就诊科室！", "info");
		return false;
	}
	
	
	if (ComLoc!="") {
		AdmLoc = ComLoc;
	} else {
		AdmLoc = OtherLoc;
	}
	*/
	
	
	$m({
		ClassName:"DHCDoc.Chemo.BS.Bed.Manage",
		MethodName:"Edit",
		UserID:session['LOGON.USERID'],
		bid:ServerObj.bid,
		Address:Address,
		DrugList:DrugList,
		AdmLoc:AdmLoc,
		ChemoPlan:ChemoPlan
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


