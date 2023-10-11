/**
 *formula.js
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
})

function Init(){
	InitCombox()
	InitData();
}

function InitData() {
	if (ServerObj.VSData!="") {
		//var VSData=Height+"^"+Weight+"^"+BSA+"^"+GFR+"^"+SC+"^"+IBW+"^"+Age+"^"+Sex;
		var mArr = ServerObj.VSData.split("^");
		$("#Height").numberbox("setValue",mArr[0])		//val(mArr[0]);
		$("#Weight").numberbox("setValue",mArr[1])		//val(mArr[1]);
		$("#BSA").val(mArr[2]);
		$("#GFR").val(mArr[3]);
		$("#SC").val(mArr[4]);
		$("#Age").numberbox("setValue",mArr[6]);		//val(mArr[6]);
		$("#Sex").combobox("setValue",mArr[7]);
		
	} 	
}

function InitCombox () {
	/*$("#Sex").combobox({  
		valueField: 'id',
		textField: 'text',
		value:1,
		data:[
			{id:1,text:"男"},
			{id:2,text:"女"}
		]
	}); 
	*/
	
	PLObject.m_Sex = $HUI.combobox("#Sex", {
		url:$URL+"?ClassName=DHCDoc.Chemo.COM.Qry&QueryName=QrySex&ResultSetType=array",
		valueField:'code',
		textField:'desc',
		blurValidValue:true
	});
	
	
}

function InitEvent () {
	$("#Calculate").click(Calculate_Handler)
	$("#Back").click(Back_Handler)
	$("#Reset").click(Reset_Handler)
	$(document.body).bind("keydown",BodykeydownHandler)
}

function Calculate_Handler () {
	var Height = $.trim($("#Height").val());
	var Weight = $.trim($("#Weight").val());
	var Age = $.trim($("#Age").val());
	var Sex = $("#Sex").combobox("getValue")||"";
	var BSAUnit = $.trim($("#BSAUnit").val());
	var SC = $.trim($("#SC").val());
	var AUC = $.trim($("#AUC").val());
	var BSA = CalcBSA(Height,Weight);
	var GFR = CalcGFR (Age,Weight,SC,Sex);
	
	if (Height=="") {
		$.messager.alert("提示","请填写身高！","warning",function () {
			$("#Height").focus();	
		})
		return false;
	}
	if (Weight=="") {
		$.messager.alert("提示","请填写体重！","warning",function () {
			$("#Weight").focus();	
		})
		
		return false;
	}
	if (Age=="") {
		$.messager.alert("提示","请填写年龄！","warning",function () {
			$("#Age").focus();	
		})
		
		return false;
	}
	if (Sex=="") {
		$.messager.alert("提示","请填写性别！","warning",function () {
			$('#Sex').combobox().next('span').find('input').focus();	
		})
		
		return false;
	}
	if (SC=="") {
		$.messager.alert("提示","请填血清肌酐值！","warning",function () {
			$("#SC").focus();	
		})
		
		return false;
	}
	var BSADose = CalcBSADose (BSA, BSAUnit);
	var GFRDose = CalcGFRDose (AUC, GFR);
	$("#BSA").val(BSA);
	$("#GFR").val(GFR);
	$("#BSAResult").val(BSADose);
	$("#GFRResult").val(GFRDose);
	
	return false;
	
}

function Back_Handler () {
	
	var Height = $.trim($("#Height").val());
	var Weight = $.trim($("#Weight").val());
	var Age = $.trim($("#Age").val());
	var Sex = $("#Sex").combobox("getValue")||"";
	var BSAUnit = $.trim($("#BSAUnit").val());
	var SC = $.trim($("#SC").val());
	var AUC = $.trim($("#AUC").val());
	var BSADose = $.trim($("#BSAResult").val());
	var GFRDose = $.trim($("#GFRResult").val());
	
	if (Height=="") {
		$.messager.alert("提示","请填写身高！","warning",function () {
			$("#Height").focus();	
		})
		return false;
	}
	if (Weight=="") {
		$.messager.alert("提示","请填写体重！","warning",function () {
			$("#Weight").focus();	
		})
		
		return false;
	}
	if (Age=="") {
		$.messager.alert("提示","请填写年龄！","warning",function () {
			$("#Age").focus();	
		})
		
		return false;
	}
	if (Sex=="") {
		$.messager.alert("提示","请填写性别！","warning",function () {
			$('#Sex').combobox().next('span').find('input').focus();	
		})
		
		return false;
	}
	if (SC=="") {
		$.messager.alert("提示","请填写血清肌酐值！","warning",function () {
			$("#SC").focus();	
		})
		
		return false;
	}
	if (BSADose=="") {
		$.messager.alert("提示","请填写BSA结果！","warning",function () {
			$("#BSAResult").focus();	
		})
		
		return false;
	}
	if (GFRDose=="") {
		$.messager.alert("提示","请填写GFR结果！","warning",function () {
			$("#GFRResult").focus();	
		})
		
		return false;
	}
	var BSA = CalcBSA(Height,Weight);
	var GFR = CalcGFR (Age,Weight,SC,Sex);
	$("#BSA").val(BSA);
	$("#GFR").val(GFR);
	//var BSADose = CalcBSADose (BSA, BSAUnit);
	//var GFRDose = CalcGFRDose (AUC, GFR);
	

	var BSA = $.trim($("#BSA").val());
	var GFR = $.trim($("#GFR").val());
	
	var BSAUnit = BackBSADose (BSADose,BSA);
	var AUC = BackGFRDose (GFRDose, GFR);
	$("#BSAUnit").val(BSAUnit)
	$("#AUC").val(AUC)
	
	return false;
}

function Reset_Handler () {
	$("input").val("");
	return false;
}

function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	if (keyCode==13) {
		if(SrcObj && SrcObj.id.indexOf("Height")>=0){
			$("#Weight").focus();
		}
		if(SrcObj && SrcObj.id.indexOf("Weight")>=0){
			$("#Age").focus();
		}
		if(SrcObj && SrcObj.id.indexOf("Age")>=0){
			$('#Sex').combobox().next('span').find('input').focus();
		}
		
		return true;
	}
	//浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }   
}

