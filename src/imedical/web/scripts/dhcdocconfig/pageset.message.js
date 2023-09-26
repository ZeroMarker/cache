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
	m_MustFillBox: ""
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
	InitData();
}

function InitData () {
	var sp = String.fromCharCode(1);
	
	if (ServerObj.msid != "") {
		var responseText = $.m({
			ClassName: "web.DHCDocPageDom",
			MethodName: "GetMessageInfo",
			msid: ServerObj.msid,
			sp: sp
		},false);
		
		if (responseText != "") {
			var responseArr = responseText.split(sp);
			$("#mCdoe").val(responseArr[0]);
			$("#mDesc").val(responseArr[1]);
			$("#mOther").val(responseArr[2]);
		}
	}
}



function InitEvent () {
	$("#i-save").click(function () {
		var id = ServerObj.msid;
		var sp = String.fromCharCode(1);
		
		var mCdoe = $.trim($("#mCdoe").val());
		var mDesc = $.trim($("#mDesc").val());
		var mOther = $.trim($("#mOther").val());
		
		if (mCdoe == "") {
			$.messager.alert('��ʾ','����д��Ϣ��ʾ���룡' , "info");
			return false;
		}
		if (mDesc == "") {
			$.messager.alert('��ʾ','����д��Ϣ��ʾ������' , "info");
			return false;
		}
		var responseText = $.m({
			ClassName: "web.DHCDocOrderListCommon",
			MethodName: "UpdateMessage",
			ID: id,
			DOPRowId: ServerObj.psRef,
			Code: mCdoe,
			Desc: mDesc,
			OtherDesc: mOther
		},false);
		if (responseText == 0) {
			$.messager.alert('��ʾ','����ɹ���' , "info", function () {
				parent.reloadMessageGrid();
				parent.destroyDialog("msEditDiag");
			});
			
			return false;
		}  else {
			$.messager.alert('��ʾ','����ʧ�ܣ�' + responseText , "info");
			return false;
		}

		
	})
}

