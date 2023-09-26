/**
 * pageset.domset.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2019-07-16
 * 
 * 
 */
var PageLogicObj = {
	m_MustFillBox: ""
}

$(function() {
	//��ʼ��
	Init();
	
	//�¼���ʼ��
	InitEvent();
	
	//ҳ��Ԫ�س�ʼ��
	PageHandle();
})


function Init(){
	//InitCombox();
	//InitData();
}

function PageHandle() {
	InitData();
}
function InitCombox () {
	PageLogicObj.m_MustFillBox = $HUI.combobox("#mustFill",{
		valueField:'id',
		textField:'text',
		selectOnNavigation:false,
		panelHeight:"auto",
		data:[
			{id:'Y',text:'��'},{id:'N',text:'��'}
		]
	});
}

function InitData () {
	var sp = String.fromCharCode(1);
	
	if (ServerObj.psid != "") {
		var responseText = $.m({
			ClassName: "web.DHCDocPageDom",
			MethodName: "GetDomInfo",
			psid: ServerObj.psid,
			sp: sp
		},false);
		
		if (responseText != "") {
			var responseArr = responseText.split(sp);
			$("#domId").val(responseArr[0]);
			$("#domName").val(responseArr[1]);
			if (responseArr[2] == "Y") {
				$("#mustFill").checkbox("check")
			} else {
				$("#mustFill").checkbox("uncheck")
			}
			$("#seqno").val(responseArr[3]);
			$("#domCss").val(responseArr[4]);
			$("#note").val(responseArr[5]);
			$("#domSelector").val(responseArr[6]);
			$("#comType").val(responseArr[7]).attr("disabled","disabled");
			if (responseArr[8] == "Y") {
				$("#supJump").checkbox("check")
				$("#supJump").checkbox("disable")
			} else {
				$("#supJump").checkbox("uncheck")
				$("#supJump").checkbox("disable")
			}
			if (responseArr[7] == "lookup") {
				$("#seqno").attr("disabled","disabled");
				if (responseArr[0] == "AdmDiadesc") {
					$("#mustFill").checkbox("disable");
				}
			}
		}
	} else {
		
	}
}



function InitEvent () {
	$("#supJump").checkbox({
		onChecked: function (e,value) {
			$("#seqno").removeAttr("disabled")
		},
		onUnchecked: function (e,value) {
			$("#seqno").attr("disabled","disabled").val("");
		}
	})
	
	$("#i-save").click(function () {
		var id = ServerObj.psid;
		var sp = String.fromCharCode(1);
		var domId = $.trim($("#domId").val());
		var domName = $.trim($("#domName").val());
		var mustFill = $("#mustFill").checkbox("getValue")?"Y":"N";
		var seqno = $.trim($("#seqno").val());
		var domCss = $.trim($("#domCss").val());
		var note = $.trim($("#note").val());
		var domSelector = $.trim($("#domSelector").val());
		var supJump = $("#supJump").checkbox("getValue")?"Y":"N";
		var comType = $.trim($("#comType").val());
		
		if (domId == "") {
			$.messager.alert('��ʾ','����дԪ��ID��' , "info");
			return false;
		}
		if (domName == "") {
			$.messager.alert('��ʾ','����дԪ������' , "info");
			return false;
		}
		if (domSelector == "") {
			$.messager.alert('��ʾ','����дѡ������' , "info");
			return false;
		}
		
		var mList = id + sp + domId + sp + domName + sp + mustFill + sp + seqno + sp + domCss;
		mList = mList + sp + note + sp + domSelector + sp + comType + sp + supJump;
		
		var responseText = $.m({
			ClassName: "web.DHCDocPageDom",
			MethodName: "SavePS",
			mList: mList,
			mRef: ServerObj.psRef,
			mSP: sp
		},false);
		
		if (responseText == 0) {
			$.messager.alert('��ʾ','����ɹ���' , "info");
			parent.ps_Reload();
			parent.destroyDialog("psEditDiag");
			return false;
		} else if (responseText == "-1") {
			$.messager.alert('��ʾ','Dom�Ѵ��ڣ�' , "info");
			return false;
		} else {
			$.messager.alert('��ʾ','����ʧ�ܣ�'+ responseText , "info");
			return false;
		}

		
	})
}

