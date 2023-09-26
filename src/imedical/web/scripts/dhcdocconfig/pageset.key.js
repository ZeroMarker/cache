/**
 * pageset.message.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2019-07-16
 * 
 * 
 */
var PageLogicObj = {
	m_Key: ""
}

$(function() {
	//��ʼ��
	Init();
	
	//�¼���ʼ��
	InitEvent();
	
	//ҳ��Ԫ�س�ʼ��
	//PageHandle();
})


function Init(){
	
	PageLogicObj.m_Key = $HUI.combobox("#mKey", {
		url:$URL+"?ClassName=web.DHCDocPageDom&QueryName=QryKey&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		
	});
	
	InitData();
}

function InitData () {
	var sp = String.fromCharCode(1);
	
	if (ServerObj.keyid != "") {
		var responseText = $.m({
			ClassName: "web.DHCDocPageDom",
			MethodName: "GetKeyInfo",
			keyid: ServerObj.keyid,
			sp: sp
		},false);
		
		if (responseText != "") {
			var responseArr = responseText.split(sp);
			$("#mCode").val(responseArr[0]);
			//$("#mKey").val(responseArr[1]);
			PageLogicObj.m_Key.setValue(responseArr[1]);
			$("#mCallBack").val(responseArr[2]);
			$("#mDesc").val(responseArr[3]);
		}
	}
}



function InitEvent () {
	$("#i-save").click(function () {
		var id = ServerObj.keyid;
		var sp = String.fromCharCode(1);
		
		var mCode = $.trim($("#mCode").val());
		var mDesc = $.trim($("#mDesc").val());
		//var mKey = $.trim($("#mKey").val());
		var mKey = PageLogicObj.m_Key.getValue();
		var mCallBack = $.trim($("#mCallBack").val());
		
		if (mCode == "") {
			$.messager.alert('��ʾ','����дԪ��ID��' , "info");
			return false;
		}
		if (mDesc == "") {
			//$.messager.alert('��ʾ','����дԪ��������' , "info");
			//return false;
		}
		if (mKey == "") {
			$.messager.alert('��ʾ','����д��ݼ���' , "info");
			return false;
		}
		if (mCallBack == "") {
			$.messager.alert('��ʾ','����д���ú�����' , "info");
			return false;
		}
		
		var responseText = $.m({
			ClassName: "web.DHCDocPageDom",
			MethodName: "updateShortcutKey",
			ID: id,
			DOPRowId: ServerObj.psRef,
			ItemID: mCode,
			ItemShortcutKey: mKey,
			ShortcutKeyCallFun: mCallBack,
			ItemDesc:mDesc
		},false);
		if (responseText == 0) {
			$.messager.alert('��ʾ','����ɹ���' , "info", function () {
				parent.reloadKeyGrid();
				parent.destroyDialog("keyEditDiag");
			});
			
			return false;
		}  else {
			$.messager.alert('��ʾ','����ʧ�ܣ�' + responseText , "info");
			return false;
		}

		
	})
}

