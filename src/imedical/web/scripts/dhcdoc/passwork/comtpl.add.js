/**
 * comtpl.add.js
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
	document.onkeydown = DocumentOnKeyDown;
}

function PageHandle() {
	
}

function InitCombox() {
	PageLogicObj.m_PType = $HUI.combobox("#PatType", {
		url:$URL+"?ClassName=DHCDoc.PW.CFG.BCPatType&QueryName=PTypeQry&LocID="+session['LOGON.CTLOCID']+"&NoDisplayALL=1&ResultSetType=array",
		valueField:'code',
		textField:'desc',
		multiple:true,
		rowStyle:'checkbox', 
		blurValidValue:true,
		editable:false
	});
	
}

function InitData() {
	if (ServerObj.SID!="") {
		$cm({
			ClassName:"DHCDoc.PW.Model.NSub",
			MethodName:"GetInfo",
			id: ServerObj.SID
		},function(MObj){
			$("#i-patno").val(MObj.PatNo).attr("disabled","disabled");
			if (MObj.PType) {
				var PTArr = MObj.PType.split(",")
				PageLogicObj.m_PType.setValues(PTArr);
			}
			
		});
	} else {
		if (ServerObj.PType!="") {
			PageLogicObj.m_PType.setValue(ServerObj.PType)
		}
		
		
	}
}

function SaveHandler() {
	var PType = PageLogicObj.m_PType.getValues();
	PType = PType.join(",")
	var PatNo = $.trim($("#i-patno").val())
	if (PType == "") {
		$.messager.alert("提示", "类型不能为空", "info");
		return false;
	}
	if (ServerObj.SID=="") { 
		if (PatNo == "") {
			$.messager.alert("提示", "请输入登记号", "info");
			return false;
		}
	}
	var InAdd = PatNo+"^"+PType+"^"+ServerObj.BCDate+"^"+ServerObj.BCCode+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.USERID'];
	var InTypeEdit = PType+"^"+ServerObj.BCDate+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.USERID'];
	if (ServerObj.SID=="") {
		$m({
			ClassName:"DHCDoc.PW.BS.NSub",
			MethodName:"AddPat",
			NID:ServerObj.NID,
			InAdd:InAdd,
			InHosp:session['LOGON.HOSPID']
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
	} else {
		$m({
			ClassName:"DHCDoc.PW.BS.NSub",
			MethodName:"EditPat",
			SID:ServerObj.SID,
			InTypeEdit:InTypeEdit
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
	
	
	
	
}

function FindBType () {
	PageLogicObj.m_BTypeGrid.reload({
		ClassName : "DHCDoc.PW.CFG.BCLoc",
		QueryName : "QryBCLoc",
		InMID:ServerObj.MID
	});
}

function DocumentOnKeyDown(e){
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
		if(SrcObj && SrcObj.id.indexOf("i-patno")>=0){
			var PatNo=$('#i-patno').val();
			//if (PatNo=="") return;
			if ((PatNo.length<10)&&(PatNo!="")) {
				for (var i=(10-PatNo.length-1); i>=0; i--) {
					PatNo="0"+PatNo;
				}
			}
			$('#i-patno').val(PatNo);
			//FindGrid ();
			return false;
		}
		return true;
	}
}
