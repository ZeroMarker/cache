/**
 * FileName: dhcbill.conf.page.interfacetest.js
 * Author: tangzf
 * Date: 2021-06-07
 * Description: �������ӿڲ���
 */

$.extend($.fn.validatebox.defaults.rules, {
	checkCodeExist: {                        //У������Ƿ����
		validator: function (value, param) {
			var row = $("#edg").datagrid("getSelected");
			if (row && (row.ConCode == value)) {
				return true;
			}
			return $.inArray(value, GV.CfgCodeAry) == -1;
		},
		message: $g('�ӿڴ����Ѵ���')
	}
});

$(function() {
	$("#btn-save").linkbutton({
		onClick: function () {
			saveClick();
		}
	});
	
	$("#btn-delete").linkbutton({
		onClick: function () {
			deleteClick();
		}
	});
	
	$("#btn-clear").linkbutton({
		onClick: function () {
			clean();
		}
	});
	
	initEDG();
	
	var tableName = "Bill_IP_Reg";
	var defHospId = $.m({
		ClassName: "web.DHCBL.BDP.BDPMappingHOSP",
		MethodName: "GetDefHospIdByTableName",
		tableName: tableName,
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID
	}, false);
	$("#hospital").combobox({
		panelHeight: 150,
		width: 350,
		url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=' + tableName,
		method: 'GET',
		valueField: 'HOSPRowId',
		textField: 'HOSPDesc',
		editable: false,
		blurValidValue: true,
		onLoadSuccess: function(data) {
			$(this).combobox('select', PUBLIC_CONSTANT.SESSION.HOSPID);
		},
		onChange: function(newValue, oldValue) {
			setValueById('PortCode', '');
			setValueById('PortDesc', '');
			setValueById('PortInput', '');
			loadEDG();
		}
	});
});

function initEDG(){
	$HUI.datagrid("#edg", {
		fit: true,
		border: false,
		singleSelect: true,
		displayMsg: '',
		loadMsg: '',
		pageSize: 99999999,
		columns: [[{title: 'confId', field: 'confId', hidden: true},
				   {title: '����', field: 'ConCode', width: 120},
				   {title: '����', field: 'ConDesc', width: 120},
				   {title: '���', field: 'Coninfo', width: 400}
			]],
		onLoadSuccess: function(data) {
			GV.CfgCodeAry = data.rows.filter(function(row) {
				return (row.ConCode != "");
			}).map(function(row) {
				return row.ConCode;
			});
		},
		onSelect: function(index, row) {
			selectRowHandle(index, row);
		}
	});
}

function selectRowHandle(index, row){
	setValueById('PortDesc', row.ConDesc);
	setValueById('PortCode', row.ConCode);
	setValueById('PortInput', row.Coninfo);
}

function loadEDG(){
	var queryParams = {
		ClassName: 'web.DHCBillPageConf',
		QueryName: 'FindInterfaceTest',
		pageId : GV.PageId,
		site: GV.Site,
		code: "",
		hospId: getValueById("hospital"),
		rows: 99999999
	}
	loadDataGridStore('edg', queryParams);
}

/**
* ����
*/
function saveClick() {
	if (!checkData()) {
		return;
	}
	var edgSelected = $('#edg').datagrid('getSelected');
	var selectRowId = "";
	var msg = '�Ƿ�ȷ��������';
	if (edgSelected) {
		selectRowId = edgSelected.confId;
		msg = '�Ƿ�ȷ���޸ģ�';
	}
	var Code = getValueById('PortCode');
	if (Code == ""){
		$.messager.popover({msg: "�ӿڴ��벻��Ϊ��", type: "info"});
		return;
	}
	var Desc = getValueById('PortDesc');
	if (Desc == ""){
		$.messager.popover({msg: "�ӿ����Ʋ���Ϊ��", type: "info"});
		return;
	}
	var Info = getValueById('PortInput');
	if (Info == "") {
		$.messager.popover({msg: "�ӿ���β���Ϊ��", type: "info"});
		return;
	}
	var hospital = getValueById("hospital");
	$.messager.confirm("ȷ��", msg, function(r) {
		if (!r) {
			return;
		}
		var confAry = [];
		var myObj = {};
		myObj.PCSite = GV.Site;
		myObj.PCSiteDR = hospital;
		myObj.PCCode = Code;
		myObj.PCValue = Info;
		myObj.PCDesc = Desc;
		myObj.PCRowID = selectRowId;
		confAry.push(JSON.stringify(myObj));	
		$.m({
			ClassName: "web.DHCBillPageConf",
			MethodName: "SaveConfInfo",
			pageId: GV.PageId,
			confList: confAry
		}, function(rtn) {
			if (rtn == 0) {
				$.messager.popover({msg: "����ɹ�", type: "success"});
				loadEDG();
				clean();
				return;
			}
			$.messager.popover({msg: "����ʧ�ܣ�" + rtn, type: "error"});
		});
	});
}

function checkData() {
	var bool = true;
	$(".validatebox-text").each(function() {
		if (!$(this).validatebox("isValid")) {
			bool = false;
			return false;
		}
	});
	return bool;
}

/**
* ɾ��
*/
function deleteClick() {
	var row = $('#edg').datagrid('getSelected');
	if (!row) {
		$.messager.popover({msg: "��ѡ����Ҫɾ���ļ�¼",type: "info"});
		return;
	}
	$.messager.confirm("ȷ��", "ȷ��ɾ��?", function (r) {
		if (!r) {
			return;
		}
		$.cm({
			ClassName: "web.DHCBillPageConf",
			MethodName: "Delete",
			idStr: row.confId,
		}, function(rtn) {
			if (rtn.success == 0) {
				$.messager.popover({msg: "ɾ���ɹ�", type: "success"});
				loadEDG();
				clean();
				return;
			}
			$.messager.popover({msg: "ɾ��ʧ�ܣ�" + rtn.msg, type: "error"});
		});
	});
}

function clean() {
	setValueById('PortCode','');
	setValueById('PortDesc','');
	setValueById('PortInput','');
	$('#edg').datagrid('clearSelections');	
}