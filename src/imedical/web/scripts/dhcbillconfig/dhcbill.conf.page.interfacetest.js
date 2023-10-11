/**
 * FileName: dhcbill.conf.page.interfacetest.js
 * Author: tangzf
 * Date: 2021-06-07
 * Description: 第三方接口测试
 */

$.extend($.fn.validatebox.defaults.rules, {
	checkCodeExist: {                        //校验代码是否存在
		validator: function (value, param) {
			var row = $("#edg").datagrid("getSelected");
			if (row && (row.ConCode == value)) {
				return true;
			}
			return $.inArray(value, GV.CfgCodeAry) == -1;
		},
		message: $g('接口代码已存在')
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
				   {title: '代码', field: 'ConCode', width: 120},
				   {title: '名称', field: 'ConDesc', width: 120},
				   {title: '入参', field: 'Coninfo', width: 400}
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
* 保存
*/
function saveClick() {
	if (!checkData()) {
		return;
	}
	var edgSelected = $('#edg').datagrid('getSelected');
	var selectRowId = "";
	var msg = '是否确认新增？';
	if (edgSelected) {
		selectRowId = edgSelected.confId;
		msg = '是否确认修改？';
	}
	var Code = getValueById('PortCode');
	if (Code == ""){
		$.messager.popover({msg: "接口代码不能为空", type: "info"});
		return;
	}
	var Desc = getValueById('PortDesc');
	if (Desc == ""){
		$.messager.popover({msg: "接口名称不能为空", type: "info"});
		return;
	}
	var Info = getValueById('PortInput');
	if (Info == "") {
		$.messager.popover({msg: "接口入参不能为空", type: "info"});
		return;
	}
	var hospital = getValueById("hospital");
	$.messager.confirm("确认", msg, function(r) {
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
				$.messager.popover({msg: "保存成功", type: "success"});
				loadEDG();
				clean();
				return;
			}
			$.messager.popover({msg: "保存失败：" + rtn, type: "error"});
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
* 删除
*/
function deleteClick() {
	var row = $('#edg').datagrid('getSelected');
	if (!row) {
		$.messager.popover({msg: "请选择需要删除的记录",type: "info"});
		return;
	}
	$.messager.confirm("确认", "确认删除?", function (r) {
		if (!r) {
			return;
		}
		$.cm({
			ClassName: "web.DHCBillPageConf",
			MethodName: "Delete",
			idStr: row.confId,
		}, function(rtn) {
			if (rtn.success == 0) {
				$.messager.popover({msg: "删除成功", type: "success"});
				loadEDG();
				clean();
				return;
			}
			$.messager.popover({msg: "删除失败：" + rtn.msg, type: "error"});
		});
	});
}

function clean() {
	setValueById('PortCode','');
	setValueById('PortDesc','');
	setValueById('PortInput','');
	$('#edg').datagrid('clearSelections');	
}