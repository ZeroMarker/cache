/**
 * FileName: scripts/dhcbillconfig/dhcbill.conf.general.proModule.js
 * Author: wzh
 * Date: 2022-10-12
 * Description: ͨ�����ò�Ʒά��-��������
 */
// ��ʼ��
$(function() {
	initData();
});

// ��ʼ������
function initData(){
	if (CV.DataType == "query"){
		var _dataJson = getPersistClsObj(CV.UrlCLs, CV.ID);
		for(key in _dataJson){
	    	setValueById(key, _dataJson[key]);
	    	disableById(key);
		}
		disableById("btn-save");
		setParentData(_dataJson[CV.PDr])
	}else if (CV.DataType == "add"){
		if(CV.ParentCls != ""){
			setParentData(CV.ParentID)
		}
	}else if (CV.DataType == "update"){
		var _dataJson = getPersistClsObj(CV.UrlCLs, CV.ID);
		for(key in _dataJson){
	    	setValueById(key, _dataJson[key]);
		}
		setParentData(_dataJson[CV.PDr]);
		// �޸�ʱ���벻���޸�
		disableById("PLCode");
		disableById("PMCode");
	}else if (CV.DataType == "addChild"){
		setParentData(CV.ParentID);
	}
}

function setParentData(parentID){
	if(CV.ParentCls != ""){
		var json = getPersistClsObj(CV.ParentCls, parentID);
	}else{
		return;
	}
	
	switch(CV.UrlType){
		case "Mod":
			setValueById("ProLineCode", json[CV.PCode]);
			setValueById("ProLineName", json[CV.PName]);
			break
		case "Func":
			break
		default:
	}
}
// ���淽��
function save(){
	//����У��
	var bool = true;
	$("#data .validatebox-text").each(function(index, item) {
		if (!$(this).validatebox("isValid")) {
			$.messager.popover({msg: "<font color=red>" + $(this).parents("td:first").prev().text() + "</font>" + "��֤��ͨ��", type: "info"});
			bool = false;
			return false;
		}
	});
	if (!bool) {
		return;
	}
	//У�����
	
	// ��ȡ�����������
	var json = {};
	$('#dataTab').find('tbody').each(function (i) {
		$(this).find('tr').each(function (j) {
			$(this).find('td').each(function (h) {
				if ($(this).context.className !== "r-label"){
					json[$(this).context.firstElementChild.id] = getValueById($(this).context.firstElementChild.id)
					//$(this).context.firstElementChild.value;
				}
			});
		});
	});
	json.ID = CV.ID;
	json.Type = CV.UrlType;
	
	$.m({
		ClassName: "BILL.CFG.COM.GeneralPro",
		MethodName: "Save",
		jsonStr: JSON.stringify(json)
	}, function(rtn) {
		var myAry = rtn.split("^");
		if (myAry[0] != 0) {
			$.messager.popover({msg: "����ʧ�ܣ�" + (myAry[1] || myAry[0]), type: "error"});
			return;
		}else{
			$.messager.popover({msg: "����ɹ���", type: "info"});
			
		}
		
	});
}