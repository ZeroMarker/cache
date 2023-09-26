/**
 * FileName: dhcbillreportskpi.details.js
 * Anchor: ZhYW
 * Date: 2017-08-02
 * Description: 
 */

var WINPUBLIC_CONSTANT = {
	WINSESSION:{
		WINGROUP_ROWID: session['LOGON.GROUPID'],
        WINGROUP_DESC: session['LOGON.GROUPDESC'],
        WINGUSER_ROWID: session['LOGON.USERID'],
        WINGUSER_NAME: session['LOGON.USERNAME'],
        WINGUSER_CODE: session['LOGON.USERCODE']
	},
	WINURL:{
		WINQUERY_COMBO_URL: "./dhcbill.query.combo.easyui.csp",
		WINMETHOD_URL: "./dhc.method.easyui.csp",
	},
	WINMETHOD: {
		WINCLS : "web.DHCIPBillCostMonitorConfig",
		WINGETMONITORPOINT : "GetBillMonitorPoint",
		WINSAVE : "SaveMonitorPoint"
	}
};

$(document).ready(function(){
	$('#winBtnSave').on('click', function(e){
		saveMonitorPoint();
	});
	$('#winBtnClose').on('click', function(e){
		closeWin();
	});	
	initPointCombo();
	var selectedRow = $('#tbMonitorPoint').datagrid('getSelected');   //获取父窗体datagrid选择数据
	if (selectedRow){
		GetMonitorPointDetails(selectedRow);
	}
});

function initPointCombo(){
	initPointTypeCombo();
	initPointActiveCombo();
}

function initPointTypeCombo(){
	//Inherent, Custom
	$('#winTypeCombo').combobox({
		panelHeight: 'auto',
		multiple: false,
		valueField: 'value',
		textField: 'text',
		data: [
			{value:'I', text:'固有'},
			{value:'C', text:'自定义'}
		],
		editable: false,
		disabled: false,
		readonly: false
	});
}

function initPointActiveCombo(){
	$('#winActiveCombo').combobox({
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

function saveMonitorPoint(){
	var selectedRow = $('#tbMonitorPoint').datagrid('getSelected');
	var id = '';
	if (selectedRow){
		id = selectedRow.id;
	}
	var code = $('#winCode').val();
	if ($.trim(code) == ""){
		$('#winCode').attr('placeholder', '请输入监控点编码');
		return;
	}
	var desc = $('#winDesc').val();
	if ($.trim(desc) == ""){
		$('#winDesc').attr('placeholder', '请输入监控点名称');
		return;
	}
	var active = $('#winActiveCombo').combobox('getValue');
	if (active == ""){
		$('#winActiveCombo').combobox({required: true});
		return;
	}
	var explain = $('#winAreaExplain').val();
	
	var type = $('#winTypeCombo').combobox('getValue');
	if (type == ""){
		$('#winTypeCombo').combobox({required: true});
		return;
	}
	var monitorPointStr = id + '#' + code + '#' + desc + '#' + explain + '#' + active + '#' + type;
	var monitorPointAry = monitorPointStr.split('#');
	if (monitorPointAry.length > 6){
		$.messager.alert('消息', '内容不能包含 # 号');
		return;
	}
	$.dhc.util.runServerMethod(WINPUBLIC_CONSTANT.WINMETHOD.WINCLS,WINPUBLIC_CONSTANT.WINMETHOD.WINSAVE, false, function save(value){
		if(value == 0){
			$.messager.alert('消息', '保存成功.');
			initMonitorPointGrid();
			closeWin();
			return;
		}else {
			$.messager.alert('消息', '保存失败,错误代码:' + value);
		}
	}, "", "", monitorPointStr);
}

function closeWin(){
	$('#winMonitorPoint').window('close');
}

function GetMonitorPointDetails(selectedRow){
	if ((!selectedRow) || (selectedRow.id == undefined)){
		return;
	}
	var id = selectedRow.id;
	$.dhc.util.runServerMethod(WINPUBLIC_CONSTANT.WINMETHOD.WINCLS, WINPUBLIC_CONSTANT.WINMETHOD.WINGETMONITORPOINT, false, function getMonitorPoint(value){
		if(value == ""){
			return;
		}
		var rtnAry = value.split('#');
		$('#winCode').val(rtnAry[0]);
		$('#winDesc').val(rtnAry[1]);
		$('#winAreaExplain').val(rtnAry[2]);
		$('#winActiveCombo').combobox('setValue', rtnAry[3]);
		$('#winTypeCombo').combobox('setValue', rtnAry[4]);
	},"", "", id);
}
