/**
 * FileName: dhcbill.conf.kpi.details.js
 * Anchor: ZhYW
 * Date: 2017-08-02
 * Description: 
 */
 
$(function () {
	$HUI.linkbutton("#winBtnSave", {
		onClick: function () {
			saveBillKPI();
		}
	});
	
	$HUI.linkbutton("#winBtnClose", {
		onClick: function () {
			closeWin();
		}
	});
	
	initWinCombo();

	GetBillKPIDetails();
});

function initWinCombo(){
	$('#winKPIType').combobox({
		panelHeight: 'auto',
		editable: false,
		valueField: 'value',
		textField: 'text',
		data: [
			{value:'I', text:'固有'},
			{value:'C', text:'自定义'}
		]
	});
	
	$('#winKPITaskType').combobox({
		panelHeight: 'auto',
		url: $URL + '?ClassName=BILL.CFG.COM.HospAuth&QueryName=FindKPITaskType&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		editable: false
	});
	
	$('#winDataStore').combobox({
		panelHeight: 'auto',
		valueField: 'value',
		textField: 'text',
		data: [
			{value:'T', text:'Table存储'},
			{value:'G', text:'Global存储'}
		],
		editable: false,
		onSelect: function(rec) {
			if (rec.value == "T") {
				setValueById("winKPIDataNode", "");
				setValueById("winKPIDataDimen", "");
				disableById("winKPIDataNode");
				disableById("winKPIDataDimen");
				enableById("winKPITableName");
			}else {
				setValueById("winKPITableName", "");
				disableById("winKPITableName");
				enableById("winKPIDataNode");
				enableById("winKPIDataDimen");
			}
		}
	});
	
	$('#winKPIActive').combobox({
		panelHeight: 'auto',
		multiple: false,
		valueField: 'value',
		textField: 'text',
		data: [
			{value:'Y', text:'启用'},
			{value:'N', text:'停用'}
		],
		editable: false,
		disabled: false,
		readonly: false
	});
}

function saveBillKPI(){
	var KPICode = getValueById("winKPICode");
	if (!$.trim(KPICode)) {
		$('#winKPICode').attr('placeholder', '请输入指标编码');
		return;
	}
	var KPIName = getValueById("winKPIName");
	if (!$.trim(KPIName)){
		$('#winKPIName').attr('placeholder', '请输入指标名称');
		return;
	}
	var KPIType = getValueById("winKPIType");
	if (!KPIType){
		$('#winKPIType').combobox({required: true});
		return;
	}
	var KPITaskType = getValueById("winKPITaskType");
	if (!KPITaskType) {
		$('#winKPITaskType').combobox({required: true});
		return;
	}
	var KPIClassName = getValueById("winKPIClassName");
	if (!$.trim(KPIClassName)){
		$('#winKPIClassName').attr('placeholder', '请输入执行类名');
		return;
	}
	var KPIMethodName = getValueById("winKPIMethodName");
	if (!$.trim(KPIMethodName)){
		$('#winKPIMethodName').attr('placeholder', '请输入执行方法名');
		return;
	}
	var KPIDataStore = getValueById("winDataStore");
	if (!KPIDataStore){
		$('#winDataStore').combobox({required: true});
		return;
	}
	var KPITableName = getValueById("winKPITableName");
	var KPIDataNode = getValueById("winKPIDataNode");
	if (KPIDataStore == 'T') {
		if (!$.trim(KPITableName)){
			$('#winKPITableName').attr('placeholder', '请输入表名');
			return;
		}
	}else {
		if (!$.trim(KPIDataNode)){
			$('#winKPIDataNode').attr('placeholder', '请输入节点名');
			return;
		}
	}
	var KPIDataDimen = getValueById("winKPIDataDimen");
	var KPIActive = getValueById("winKPIActive");
	if (!KPIActive) {
		$('#winKPIActive').combobox({required: true});
		return;
	}
	var KPICreator = getValueById("winKPICreator");
	var KPIReMark = getValueById("winKPIReMark");
	var KPIOrder = "";
	var KPICreatDate = "";
	var KPICreatTime = "";
	
	var KPIAry = [];
	KPIAry.push(GV.KPIID);
	KPIAry.push(KPITaskType);
	KPIAry.push(KPIType);
	KPIAry.push(KPICode);
	KPIAry.push(KPIName);
	KPIAry.push(KPIOrder);
	KPIAry.push(KPIClassName);
	
	KPIAry.push(KPIMethodName);
	KPIAry.push(KPIDataStore);
	KPIAry.push(KPITableName);
	KPIAry.push(KPIDataNode);
	KPIAry.push(KPIDataDimen);
	
	KPIAry.push(KPIActive);
	KPIAry.push(KPICreator);
	KPIAry.push(KPICreatDate);
	KPIAry.push(KPICreatTime);
	KPIAry.push(KPIReMark);
	
	var KPIStr = KPIAry.join('^');

	$.m({
		ClassName: "BILL.CFG.COM.HospAuth",
		MethodName: "SaveKPI",
		kpiInfo: KPIStr
	}, function (rtn) {
		if(rtn == 0){
			$.messager.alert('提示', '保存成功', 'success', function() {
				websys_showModal("options").callbackFunc();
				closeWin();
			});
		}else {
			$.messager.alert('提示', '保存失败，错误代码：' + rtn, 'error');
		}
	});
}

function closeWin() {
	websys_showModal("close");
}

function GetBillKPIDetails() {
	$.cm({
		ClassName: "web.DHCBillCommon",
		MethodName: "GetClsPropValById",
		clsName: "User.DHCBillKPISetting",
		id: GV.KPIID
	}, function (jsonObj) {
		setValueById("winKPITaskType", jsonObj.KPITaskType);
		setValueById("winKPIType", jsonObj.KPIType);
		setValueById("winKPICode", jsonObj.KPICode);
		setValueById("winKPIName", jsonObj.KPIName);
		setValueById("winKPIClassName", jsonObj.KPIClass);
		setValueById("winKPIMethodName", jsonObj.KPIMethod);
		setValueById("winDataStore", jsonObj.KPIStorageType);
		setValueById("winKPITableName", jsonObj.KPITableName);
		setValueById("winKPIDataNode", jsonObj.KPIDataNode);
		setValueById("winKPIDataDimen", jsonObj.KPIDataDimen);
		setValueById("winKPIActive", jsonObj.KPIActive);
		setValueById("winKPICreator", jsonObj.KPICreator);
		setValueById("winKPIReMark", jsonObj.KPIReMark);
	});
}