/**
 * poison.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2019-07-16
 * 
 * 
 */
PLObject = {
	v_Type: "",
	v_OhterLoc:""	// PLObject.v_OhterLoc
}
$(function() {
	Init();
	InitEvent();
})


function Init(){
	InitCombox();
	InitData()
}

function InitEvent () {
	$("#save").click(SaveTPL)
	$("#Clear").click(Clear_Handle)
}

function InitCombox() {
	
	PLObject.m_Type = $HUI.combobox("#type", {
		url:$URL+"?ClassName=DHCDoc.Chemo.CFG.Template&QueryName=QryTPLType&ResultSetType=array",
		valueField:'id',
		textField:'text',
		blurValidValue:true,
		onSelect: function (record) {
			PLObject.m_Desc = $HUI.combobox("#desc", {
				url:$URL+"?ClassName=DHCDoc.Chemo.CFG.Template&QueryName=QryTPLDesc&ResultSetType=array&InHosp="+ServerObj.InHosp,
				valueField:'id',
				textField:'text',
				mode:'remote',
				blurValidValue:true,
				onBeforeLoad:function(param){
					if (!record) {
						param.InType= PLObject.v_Type;
					} else {
						param.InType= record.id;
					}
				}
			});
			
			/*PLObject.m_OtherDesc = $HUI.combobox("#OtherDesc", {
				url:$URL+"?ClassName=DHCDoc.Chemo.CFG.Template&QueryName=QryTPLDesc&ResultSetType=array",
				valueField:'id',
				textField:'text',
				multiple:true,
				mode:'remote',
				blurValidValue:true,
				onBeforeLoad:function(param){
					if (!record) {
						param.InType= PLObject.v_Type;
					} else {
						param.InType= record.id;
					}
				}
			});
			
			if (record.id=="DEP") {
				PLObject.m_OtherDesc.disable();	
			} else {
				PLObject.m_OtherDesc.enable();	
			}
			
			if (record.id=="HOSP") {
				PLObject.m_OtherLoc.disable();	
			} else {
				PLObject.m_OtherLoc.enable();	
			}
			*/
			
		}
	});
	
	
	PLObject.m_Desc = $HUI.combobox("#desc", {
		url:$URL+"?ClassName=DHCDoc.Chemo.CFG.Template&QueryName=QryTPLDesc&ResultSetType=array",
		valueField:'id',
		textField:'text',
		mode:'remote',
		blurValidValue:true
	});
	
	/*
	PLObject.m_OtherDesc = $HUI.combobox("#OtherDesc", {
		url:$URL+"?ClassName=DHCDoc.Chemo.CFG.Template&QueryName=QryTPLDesc&ResultSetType=array",
		valueField:'id',
		textField:'text',
		multiple:true,
		mode:'remote',
		blurValidValue:true
	});
	
	
	PLObject.m_OtherLoc = $HUI.combobox("#OtherLoc", {
		url:$URL+"?ClassName=DHCDoc.Chemo.CFG.Template&QueryName=QryTPLDesc&InType=DEP&ResultSetType=array",
		valueField:'id',
		textField:'text',
		multiple:true,
		defaultFilter:4
	
	});
	*/
	
}

function InitData() {
	if (ServerObj.TPID!="") {
		$cm({
			ClassName:"DHCDoc.Chemo.Model.Template",
			MethodName:"GetInfo",
			TPID: ServerObj.TPID
		},function(MObj){
			PLObject.v_Type = MObj.TPType;
			PLObject.m_Type.select(MObj.TPType);
			PLObject.m_Desc.select(MObj.TPDesc);
			PLObject.m_Type.disable();
			PLObject.m_Desc.disable();
			$("#stagenum").numberbox("setValue", MObj.TPStageNum);
			$("#name").val(MObj.TPName);
			$("#mainNote").val(MObj.TPMainNote);
			$("#title").val(MObj.TPTitle);
			$("#otherName").val(MObj.TPOtherName);
			if (MObj.TPActive == "Y") {
				$("#active").checkbox("check")
			} else {
				$("#active").checkbox("uncheck")
			}
			/*
			if (MObj.TPOtherDesc) {
				PLObject.m_OtherDesc.setValues(MObj.TPOtherDesc.split(","));
			}
			if (MObj.TPOtherLoc) {
				PLObject.m_OtherLoc.setValues(MObj.TPOtherLoc.split(","));
			}
			*/
		});
	}
	
}

function Clear_Handle() {
	if (ServerObj.TPID!="") {
		var Type = PLObject.m_Type.getValue();
		$("#name,#stagenum,#mainNote,#title,#otherName").val("");
		$("#active").checkbox("uncheck");
		
		/*if (Type=="DEP") {
			PLObject.m_OtherLoc.clear();
			PLObject.v_OhterLoc = "";	
		} else if (Type=="HOSP") {
			PLObject.m_OtherDesc.clear();
		} else {
			PLObject.m_OtherDesc.clear();
		}*/
		
		
	} else {
		PLObject.m_Type.clear();
		PLObject.m_Desc.clear();
		//PLObject.m_OtherDesc.clear();
		$("#name,#stagenum,#mainNote,#title,#otherName").val("");
		$("#active").checkbox("uncheck");
		//PLObject.m_OtherLoc.clear();
		//PLObject.v_OhterLoc = "";
		
		
	}
	
	
}

function SaveTPL () {
	var id = ServerObj.TPID;
	var type = PLObject.m_Type.getValue()||"";
	var desc = PLObject.m_Desc.getValue()||"";
	var name = $.trim($("#name").val());
	var stagenum = $.trim($("#stagenum").val());
	var active = $("#active").checkbox("getValue")?"Y":"N";
	var user = session['LOGON.USERID'];
	var mainNote = $.trim($("#mainNote").val());
	var title = $.trim($("#title").val());
	var otherName = $.trim($("#otherName").val());
	
	var OtherDesc = ""	//PLObject.m_OtherDesc.getValues();
	//OtherDesc = OtherDesc.join(",")
	
	var OtherLoc = ""	//PLObject.m_OtherLoc.getValues();
	//OtherLoc = OtherLoc.join(",")
	
	if (type == "") {
		$.messager.alert("��ʾ", "��ѡģ�����ͣ�", "info");
		return false;
	}
	if (desc == "") {
		$.messager.alert("��ʾ", "��ѡ��ģ��������", "info");
		return false;
	}
	if (name == "") {
		$.messager.alert("��ʾ", "����д���Ƶ����ƣ�", "info");
		return false;
	}
	if (stagenum == "") {
		$.messager.alert("��ʾ", "����д�ܽ׶�����", "info");
		return false;
	}
	if (mainNote == "") {
		$.messager.alert("��ʾ", "����д��ҩ��ע��", "info");
		return false;
	}
	if (title == "") {
		$.messager.alert("��ʾ", "����д���Ʊ��⣡", "info");
		return false;
	}
	var mList = id + "^" + type + "^" + desc + "^" + name + "^" + stagenum + "^" + active + "^" + user + "^" + mainNote + "^" + title + "^" + otherName + "^" + OtherDesc + "^" + OtherLoc + "^" + ServerObj.InHosp;
	//alert(mList);
	$m({
		ClassName:"DHCDoc.Chemo.CFG.Template",
		MethodName:"SaveTPL",
		mList:mList
	}, function(result){
		if (result > 0) {
			$.messager.alert("��ʾ", "����ɹ���", "info", function () {
				websys_showModal("hide");
				websys_showModal('options').CallBackFunc(result);
				websys_showModal("close");	
			});
		} else if (result == -99) {
			$.messager.alert("��ʾ", "ģ���Ѵ��ڣ�" , "info");
			return false;
		} else {
			$.messager.alert("��ʾ", "����ʧ�ܣ�" + result , "info");
			return false;
		}
	});
}
