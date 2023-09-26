/**
 * poison.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2019-07-16
 * 
 * 
 */
 
$(function() {
	Init();
	InitEvent();
})


function Init(){
	InitCombox();
	
}

function InitEvent () {
	$("#i-save").click(save);
}

function InitCombox() {
	/* PLObject.m_Hosp = $HUI.combobox("#i-hosp", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.Authority&QueryName=QryHosp&ResultSetType=array",
		valueField:'id',
		textField:'text',
		value:ServerObj.InHosp,
		blurValidValue:true
	});	 */
	
	PLObject.m_Hosp = GenHospComp("Ant_Config_Func_PoisonSet");
	PLObject.m_Hosp.setValue(ServerObj.InHosp)
	
	PLObject.m_Phpo = $HUI.combobox("#i-phpo", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.PoisonSet&QueryName=QryPhpo&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		value: ServerObj.phpo,
		blurValidValue:true
	});	
	
}

function save () {
	var hosp = PLObject.m_Hosp.getValue()||"";
	var phpo = PLObject.m_Phpo.getValue()||"";
	var active = "Y";
	var mList = ServerObj.pid + "^" + hosp + "^" + phpo + "^" + active;
	if (hosp == "") {
		$.messager.alert("��ʾ", "��ѡ������Ժ����", "info");
		return false;
	}
	if (phpo == "") {
		$.messager.alert("��ʾ", "��ѡ����Ʒ��࣡", "info");
		return false;
	}
	$m({
		ClassName:"DHCAnt.KSS.Config.PoisonSet",
		MethodName:"Save",
		inPara:mList
	}, function(result){
		if (result == 0) {
			$.messager.alert("��ʾ", "����ɹ���", "info");
			websys_showModal("hide");
			websys_showModal('options').CallBackFunc();
			websys_showModal("close");	
		} else if (result == "-1") {
			$.messager.alert("��ʾ", "�����Ѿ����ڣ�", "info");
			return false;
		} else {
			$.messager.alert("��ʾ", "����ʧ�ܣ�" + result , "info");
			return false;
		}
	});
	
}

