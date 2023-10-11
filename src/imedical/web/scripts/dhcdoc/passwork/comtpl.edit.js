/*
 * @Author: qiupeng
 * @Date: 2022-10-24 15:21:31
 * @LastEditors: qiupeng
 * @LastEditTime: 2022-10-24 16:03:05
 * @FilePath: scripts/dhcdoc/passwork/comtpl.edit.js
 * @Description: 
 * 
 * Copyright (c) 2022 by qiupeng, All Rights Reserved. 
 */
var PageLogicObj = {
	c_Focus:"Content"
}
$(function() {
	Init();
	InitEvent();
	PageHandle();
})

function Init(){
	TOOL.LoadBar(ServerObj.EpisodeID);
	InitData();
}

function InitEvent () {
	$("#Link").click(TOOL.LinkRef_Handler)
	$("#BL").click(TOOL.BLHandler)
	$("#Save").click(SaveHandler)
	$("#Content").focus(function(){
		PageLogicObj.c_Focus = "Content"
	});
	$("#AcceptContent").focus(function(){
		PageLogicObj.c_Focus = "AcceptContent"
	});
	$("#Next").click(Next_Handler);
	$("#Prev").click(Prev_Handler);
	
}
function PageHandle() {
}
function InitData() {
	if (ServerObj.SID!="") {
		$cm({
			ClassName:"DHCDoc.PW.Model.NSub",
			MethodName:"GetInfo",
			id: ServerObj.SID
		},function(MObj){
			if (MObj.SubmitContent) {
				$("#Content").val(MObj.SubmitContent)
			} else {
				$("#Content").val("")
			}
			if (MObj.AcceptContent) {
				$("#AcceptContent").val(MObj.AcceptContent)
			} else {
				$("#AcceptContent").val("")
			}
		});
	} else {
		$("#Content").val("")
		$("#AcceptContent").val("")
		
	}
}

function SaveHandler () {
	
	var BCNote = $.trim($("#Content").val());
	if (BCNote == "") {
		$.messager.alert('提示','请填写交班内容!',"info",function () {
			$("#Content").focus();
		});
		return false;
	}
	var AcceptNote = $.trim($("#AcceptContent").val());
	if (AcceptNote == "") {
		$.messager.alert('提示','请填写接班内容!',"info",function () {
			$("#AcceptContent").focus();
		});
		return false;
	}
	$.m({
		ClassName:"DHCDoc.PW.BS.NSub",
		MethodName:"EditPWContent",
		UserId: session['LOGON.USERID'],
		SID: ServerObj.SID,
		BCNote: BCNote,
		AcceptNote: AcceptNote
	},function (responseText){
		var responseText = responseText.split("^")
		if(responseText[0] > 0) {
			//var selectedOld = parent.PageLogicObj.m_ItemGrid.getSelected();
			//var rowIndexOld = parent.PageLogicObj.m_ItemGrid.getRowIndex(selectedOld);
			//parent.PageLogicObj.m_ItemGrid.reload();
			$.messager.alert('提示','保存成功',"info",function() {
				//parent.PageLogicObj.m_ItemGrid.selectRow(rowIndexOld);
				//parent.websys_showModal("hide");
				parent.websys_showModal('options').CallBackFunc();
				//parent.websys_showModal("close");	
				
			});
			
		} else {
			$.messager.alert('提示','错误: '+ responseText[1] , "error");
			return false;
		}	
	})
	
	
}

function Prev_Handler () {
	//var nextOBJ = parent.NextOrPrev('prev');
	var nextOBJ = parent.websys_showModal('options').NextOrPrev('prev');
	Reload(nextOBJ);
	return false;
	
}

function Next_Handler () {
	//var nextOBJ = parent.NextOrPrev('next');
	var nextOBJ = parent.websys_showModal('options').NextOrPrev('next');
	Reload(nextOBJ);
	return false;
}

function Reload(nextOBJ) {
	if (nextOBJ.Success) {
		ServerObj.NID = nextOBJ.NID;
		ServerObj.SID = nextOBJ.SID;
		ServerObj.PType = nextOBJ.PType;
		ServerObj.EpisodeID = nextOBJ.EpisodeID;
		ServerObj.BCDate = nextOBJ.BCDate;
		ServerObj.BCCode = nextOBJ.BCCode;

	} else {
		$.messager.alert('提示',nextOBJ.Msg,"info");
		return false;
	}
	Init();
}