/**
 * freeorder.edit.js
 * 
 * Copyright (c) 2021-2022 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2021-01-18
 * 
 * 
 */
var PageLogicObj = {
	
}

$(function() {
	Init();
	InitEvent();
})


function Init(){
	InitCombox();
	InitData();
}

function InitEvent () {
	$("#Save").click(Save_Handle)
}

function InitCombox() {
	PageLogicObj.m_Stage = $HUI.combobox("#PPFPrjStage", {
		url:$URL+"?ClassName=web.PilotProject.Extend.Stage&QueryName=QryStage&PrjDR="+ServerObj.PPRowId+"&ResultSetType=array",
		valueField:'id',
		textField:'stageDesc',
		//required:true,
		blurValidValue:true
	});
	
	var Form=session['LOGON.CTLOCID']+String.fromCharCode(3)+ServerObj.InHosp;
	$("#PPFItmMastDR").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'ARCIMDesc',
        columns:[[  
           {field:'ARCIMDesc',title:'名称',width:250},
           {field:'HIDDEN',title:'医嘱项ID',width:120,sortable:true},
           {field:'ItemPrice',title:'单价',width:100},
           {field:'billuom',title:'计价单位',width:100}
           
        ]],
        pagination:true,
        panelWidth:500,
        panelHeight:400,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCDocOrderEntry',QueryName: 'LookUpItem','Form':Form},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        if (desc=="") return false;
			param = $.extend(param,{Item:desc});	//TYPE:"L^SERVICE"
	    },onSelect:function(ind,item){
		    PageLogicObj.m_PPFItmMastDR=item['HIDDEN'];
		}
    });
	
}

function InitData() {
	$cm({
		ClassName:"web.PilotProject.CFG.FindGCP",
		MethodName:"GetInfo",
		ID: ServerObj.id,
		PPRowId:ServerObj.PPRowId
	},function(MObj){
		console.log(MObj)
		
		if (ServerObj.id!="") {
			$("#PPFItmMastDR").lookup("disable");
			PageLogicObj.m_Stage.setValue(MObj.PPFPrjStage)
			$("#PPFItmMastDR").lookup("setText",MObj.PPFItmMastDesc);
			PageLogicObj.m_PPFItmMastDR = MObj.PPFItmMastDR;
			$("#PPFSttDate").datebox("setValue",MObj.PPFSttDate);
			$("#PPFEndDate").datebox("setValue",MObj.PPFEndDate);
			$("#PPFEndTime").timespinner("setValue",MObj.PPFEndTime);
			$("#PPFSttTime").timespinner("setValue",MObj.PPFSttTime);
			$("#PPFFreeNum").val(MObj.PPFFreeNum)
			if (MObj.PPFLimitEntryAfterNoFreeNum=="Y") {
				$("#PPFLimitEntryAfterNoFreeNum").checkbox("check")
			} else {
				$("#PPFLimitEntryAfterNoFreeNum").checkbox("uncheck")
			}
		} else {
			if (typeof MObj.PPFSttDate != "undefined") {
				if (MObj.PPFSttDate=="NULL") {
					$("#PPFSttDate").datebox("setValue","");
				} else {
					$("#PPFSttDate").datebox("setValue",MObj.PPFSttDate);
				}
			} else {
				$("#PPFSttDate").datebox("setValue","");
			}
			
			if (typeof MObj.PPFEndDate != "undefined") {
				if (MObj.PPFEndDate=="NULL") {
					$("#PPFEndDate").datebox("setValue","");
				} else {
					$("#PPFEndDate").datebox("setValue",MObj.PPFEndDate);
				}
			} else {
				$("#PPFEndDate").datebox("setValue","");
			}
			
			
			
		}
	})
	
}

function Save_Handle () {
	SaveData(ServerObj.id)
}

function SaveData(PPFRowId){
	var myrtn=CheckBeforeUpdate();
	if (myrtn==false)retrun;
	var myExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID'];
	var ArcimIDStr=getProjecctInfo();
	var rtn=$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		MethodName:"SaveProFreeOrd",
		PPRowID:ServerObj.PPRowId,
		PPFRowID:PPFRowId,
		ProFreeOrdInfo:ArcimIDStr,
		myExpStr:myExpStr,
		dataType:"text"
	},false)
	if (rtn==0){
		$.messager.popover({msg: '保存成功!',type:'success'});
		websys_showModal("hide");
		websys_showModal('options').CallBackFunc();
		websys_showModal("close");	
	}else if(rtn==-1){
		$.messager.alert("提示","保存失败!项目重复!","warning");
	}else if(rtn==-2){
		$.messager.alert("提示","保存失败!开始日期大于结束日期!","warning");
	}else{
		$.messager.alert("提示","保存失败!","error");
	}
}
function CheckBeforeUpdate(){
	if ($("#PPFItmMastDR").lookup('getText')=="")  PageLogicObj.m_PPFItmMastDR="";
	if (PageLogicObj.m_PPFItmMastDR==""){
		$.messager.alert("提示","请选择医嘱!","info",function(){
			$("#PPFItmMast").next('span').find('input').focus();
		});
		return false;
	}
	var stage=PageLogicObj.m_Stage.getValue()||"";
	if (stage=="") {
		$.messager.alert("提示","阶段不能为空！","warning");
		return false;
	}
	var PPFFreeNum=$("#PPFFreeNum").val();
	if (PPFFreeNum==""){
		$.messager.alert("提示","免费次数不能为空!","info",function(){
			$("#PPFFreeNum").next('span').find('input').focus();
		});
		return false;
	}else{
		var reg=/^[1-9]+\d*$/;
		if(!reg.test(PPFFreeNum)){
		    $.messager.alert("提示","免费次数只能是大于0的整数!","info",function(){
				$("#PPFFreeNum").next('span').find('input').focus();
			});
			return false;
		}
	}
	var PPFSttDate=$("#PPFSttDate").datebox('getValue');
	if (PPFSttDate==""){
		$.messager.alert("提示","请选择开始日期!","info",function(){
			$("#PPFSttDate").next('span').find('input').focus();
		});
		return false;
	}
	return true;
}

function getProjecctInfo(){
	var myxml="";
	var myparseinfo = $("#InitProjectEntity").val();
	var myxml=GetEntityClassInfoToXML(myparseinfo)
	return myxml;
}

function GetEntityClassInfoToXML(ParseInfo)
{
	var myxmlstr="";
	//try{
		var myary=ParseInfo.split("^");
		var xmlobj=new XMLWriter();
		xmlobj.BeginNode(myary[0]);
		for(var myIdx=1;myIdx<myary.length;myIdx++){
			xmlobj.BeginNode(myary[myIdx]);
			var _$id=$("#"+myary[myIdx]);
			if (_$id.length==0){
				var myval="";
			}else{
				if (_$id.hasClass("hisui-combobox")){
					var myval=_$id.combobox("getValue");
					if (myval==undefined) myval="";
					if (myval!=""){
						myval=myval.split("^")[0];
					}
				}else if(_$id.hasClass("hisui-datebox")){
					var myval=_$id.datebox("getValue");
				}else if(_$id.hasClass("hisui-timespinner")){
					var myval=_$id.timespinner("getValue");
				}else if(myary[myIdx]=="PPFItmMastDR"){
					if ($("#PPFItmMastDR").lookup('getText')=="")  PageLogicObj.m_PPFItmMastDR="";
					var myval=PageLogicObj.m_PPFItmMastDR;
				}else if(_$id.hasClass("hisui-checkbox")){
					var myval="N";
					if (_$id.checkbox("getValue")){
						myval="Y";
					}
				}else{
					var myval=_$id.val();
				}
			}
			xmlobj.WriteString(myval);
			xmlobj.EndNode();
		}
		xmlobj.Close();
		myxmlstr = xmlobj.ToString();
	//}catch(Err){
	//	$.messager.alert("提示","Error: " + Err.description);
	//}
	return myxmlstr;
}
