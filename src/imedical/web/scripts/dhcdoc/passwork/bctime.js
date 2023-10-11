/**
 * bcpattype.js
 * 
 * Copyright (c) 2020-2090 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-09-02
 * 
 * 
 */

var PageLogicObj = {
	m_nextday:""
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

function InitCombox() {
	PageLogicObj.m_nextday = $HUI.combobox("#i-diag-nextday",{
		valueField:'id',
		textField:'text',
		multiple:false,
		//rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'0',text:'������'},{id:'1',text:'��������'},{id:'2',text:'�����������'}
		]
	});	
}

function InitData() {
	if (ServerObj.ID!="") {
		$cm({
			ClassName:"DHCDoc.PW.Model.BCTime",
			MethodName:"GetInfo",
			id: ServerObj.ID
		},function(MObj){
			$("#i-diag-code").val(MObj.BCCode);
			$("#i-diag-name").val(MObj.BCName);
			$("#i-diag-seqno").numberbox("setValue",MObj.BCSeqno)
			$("#i-diag-stime").timespinner("setValue", MObj.BCSTime);
			$("#i-diag-etime").timespinner("setValue", MObj.BCETime);
			//if (selected.nextDay == 1) $("#i-diag-nextday").checkbox("check")
			//else $("#i-diag-nextday").checkbox("uncheck")
			PageLogicObj.m_nextday.setValue(MObj.BCIsNextDay)
			if (MObj.BCActive == 1) $("#i-diag-active").checkbox("check")
			else $("#i-diag-active").checkbox("uncheck");
			$("#i-diag-note").val(MObj.BCNote);
			ValidateForm();
		});
	} else {
		ValidateForm();
	}


}

function ValidateForm () {
	$("#i-diag-code").validatebox("validate");
	$("#i-diag-name").validatebox("validate");
	$("#i-diag-seqno").numberbox("validate");	
	$("#i-diag-stime").timespinner("validate");
	$("#i-diag-etime").timespinner("validate");
}

function InitEvent () {
	$("#Save").click(SaveHandler)
}

function PageHandle() {
	
}

function SaveHandler() {
    var code = $.trim($("#i-diag-code").val());
    var name = $.trim($("#i-diag-name").val());
    var stime = $("#i-diag-stime").timespinner("getValue")||"";
    var etime = $("#i-diag-etime").timespinner("getValue")||"";
    var nextday = PageLogicObj.m_nextday.getValue()||"";
    var active = $("#i-diag-active").checkbox("getValue")?1:0;
    var note = $.trim($("#i-diag-note").val());
    var seqno = $.trim($("#i-diag-seqno").val());
	var inPara = ServerObj.MID + "^" + code + "^" + name + "^" + stime + "^" + etime + "^" + nextday + "^" + active;
	inPara = inPara + "^" + note + "^" + seqno;
	if (code == "") {
		$.messager.alert('��ʾ','��δ��벻��Ϊ��!',"info");
		return false;
	}
	if (name == "") {
		$.messager.alert('��ʾ','������Ʋ���Ϊ��!',"info");
		return false;
    }
	if (stime == "") {
		$.messager.alert('��ʾ','��ʼʱ�䲻��Ϊ��!',"info");
		return false;
    }
    if (etime == "") {
		$.messager.alert('��ʾ','����ʱ�䲻��Ϊ��!',"info");
		return false;
    }
    if (seqno == "") {
		$.messager.alert('��ʾ','�ڼ���β���Ϊ��!',"info");
		return false;
    }
    if (nextday == "") {
		$.messager.alert('��ʾ','���ձ�־����Ϊ��!',"info");
		return false;
    }
    
    $.m({
        ClassName:"DHCDoc.PW.CFG.BCTime",
        MethodName:"Save",
        ID:ServerObj.ID,
        inPara:inPara
    },function (responseText){
	    var responseText = responseText.split("^")
        if(responseText[0] > 0) {
            $.messager.alert("��ʾ", "����ɹ���", "info", function () {
				parent.websys_showModal("hide");
				parent.websys_showModal('options').CallBackFunc();
				parent.websys_showModal("close");	
			});
        } else {
            $.messager.alert("��ʾ", "����ʧ�ܣ�"+responseText[1] , "info");
			return false;
        }	
    })
}



