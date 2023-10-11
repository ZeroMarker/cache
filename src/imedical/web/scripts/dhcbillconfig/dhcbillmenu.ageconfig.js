/**
 * FileName: dhcbillmenu.ageconfig.js
 * Author: ZhYW
 * Date: 2019-10-08
 * Description: 年龄配置
 */

var GV = {};

$(function () {
	initMenu();
	initConfigList();
});

function initMenu() {
	$HUI.linkbutton("#btn-add", {
		onClick: function () {
			addClick();
		}
	});
	
	$HUI.linkbutton("#btn-update", {
		onClick: function () {
			updateClick();
		}
	});
	
	$HUI.linkbutton("#btn-delete", {
		onClick: function () {
			deleteClick();
		}
	});
	
	$HUI.linkbutton("#btn-reload", {
		onClick: function () {
			reloadClick();
		}
	});
	
	$HUI.combobox("#dispUom, #stUom, #endUom", {
		panelHeight: 180,
		method: 'GET',
		valueField: 'ID',
		textField: 'Desc',
		blurValidValue: true,
		defaultFilter: 5
	});
	
	$.cm({
		ClassName: "web.DHCJFUOMSET",
		QueryName: "QueryUom",
		ResultSetType: "array",
		type: "GET"
	}, function(data) {
		$("#dispUom, #stUom, #endUom").combobox("loadData", data);
	});
	
	var tableName = "Bill_Com_AgeCfg";
	var defHospId = $.m({
		ClassName: "web.DHCBL.BDP.BDPMappingHOSP",
		MethodName: "GetDefHospIdByTableName",
		tableName: tableName,
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID
	}, false);
	$("#hospital").combobox({
		panelHeight: 150,
		width: 300,
		url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=' + tableName,
		method: 'GET',
		valueField: 'HOSPRowId',
		textField: 'HOSPDesc',
		editable: false,
		blurValidValue: true,
		onLoadSuccess: function(data) {
			$(this).combobox('select', defHospId);
		},
		onChange: function(newValue, oldValue) {
			getLastValStr();
			loadCfgList();
		}
	});
}

function getLastValStr() {
	$.m({
		ClassName: "web.UDHCJFAgeConfig",
		MethodName: "GetLastValStr",
		hospId: getValueById("hospital")
	}, function(rtn) {
		var myAry = rtn.split("^");
		if (myAry[0] != 0) {
			$.messager.popover({msg: "初始化失败：" + myAry[0], type: "error"});
			return;
		}
		var stVal = myAry[1];
		var stUomId = myAry[2];
		setValueById("stVal", stVal);
		setValueById("stUom", stUomId);
	});
}

function initConfigList() {
	var selectRowIndex = undefined;
	GV.ConfigList = $HUI.datagrid("#configList", {
		fit: true,
		border: false,
		singleSelect: true,
		striped: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		toolbar: '#tToolBar',
		columns: [[{title: '开始操作符', field: 'Toperator1', width: 120},
				   {title: '开始数值', field: 'TstartVal', width: 120},
				   {title: 'TstUomDR', field: 'TstUomDR', hidden: true},
				   {title: '开始单位', field: 'TstartUom', width: 120},
				   {title: '结束操作符', field: 'Toperator2', width: 120},
				   {title: '结束数值', field: 'TendVal', width: 120},
				   {title: 'TendUomDR', field: 'TendUomDR', hidden: true},
				   {title: '结束单位', field: 'TendUom', width: 120},
				   {title: 'TdispUomDR', field: 'TdispUomDR', hidden: true},
				   {title: '显示值', field: 'TdisplayVal', width: 120},
				   {title: '语义', field: 'TSemantics', width: 280},
				   {title: 'TrowId', field: 'TrowId', hidden: true}
			]],
		onLoadSuccess: function(data) {
			selectRowIndex = undefined;
		},
		onSelect: function(index, row) {
			if (selectRowIndex == index) {
				GV.ConfigList.unselectRow(index);
				return;
			}
			selectRowIndex = index;
			selectRowHandler(row);
		},
		onUnselect: function(index, row) {
			selectRowIndex = undefined;
			unSelectRowHandler();
		}
	});
}

function loadCfgList() {
	var queryParams = {
		ClassName: "web.UDHCJFAgeConfig",
		QueryName: "GetAgeConfig",
		hospId: getValueById("hospital")
	}
	loadDataGridStore("configList", queryParams);
}

function selectRowHandler(row) {
	setValueById("stVal", row.TstartVal);
	setValueById("stUom", row.TstUomDR);
	setValueById("endVal", row.TendVal);
	setValueById("endUom", row.TendUomDR);
	setValueById("dispUom", row.TdispUomDR);
}

function unSelectRowHandler() {
	setValueById("endVal", "");
	setValueById("endUom", "");
	setValueById("dispUom", "");
	getLastValStr();
}

function addClick() {
	var row = GV.ConfigList.getSelected();
	if (row) {
		$.messager.popover({msg: "不能添加相同值的数据", type: "info"});
		return;
	}
	if (!checkData()) {
		return;
	}
	var stValStrs = getValueById("stOperator") + "^" + getValueById("stVal") + "^" + getValueById("stUom");
	var endValStrs = getValueById("endOperator") + "^" + getValueById("endVal") + "^" + getValueById("endUom");
	var dispValStrs = getValueById("dispUom");
	if (!validateParamStr(stValStrs, endValStrs)) {
		return;
	}
	$.messager.confirm("确认", "确认保存？", function(r) {
		if (!r) {
			return;
		}
		$.m({
			ClassName: "web.UDHCJFAgeConfig",
			MethodName: "INSERT",
			stValStr: stValStrs,
			endValStr: endValStrs,
			dispStr: dispValStrs,
			guser: PUBLIC_CONSTANT.SESSION.USERID,
			hospId: getValueById("hospital")
		}, function(rtn) {
			switch(rtn) {
			case "0":
				$.messager.popover({msg: "保存成功", type: "success"});
				reloadDoc();
				break;
			case "-104":
				$.messager.popover({msg: "结束数值过大", type: "error"});
				break;
			default:
				$.messager.popover({msg: "保存失败：" + rtn, type: "error"});
			}
		});
	});
}

function checkData() {
	var bool = true;
	var id = "";
	$("#configList").parents(".layout-panel-center").prev(".layout-panel-north").find("input[id]").each(function(index, item) {
		id = $(this)[0].id;
		if (!getValueById(id)) {
			bool = false;
			focusById(id);
			$.messager.popover({msg: "请输入<font color=red>" + $(this).parent().prev().text() + "</font>", type: "info"});
			return false;
		}
	});
	if (!bool) {
		return false;
	}
	
	var stVal = getValueById("stVal");
	if (stVal > 365) {
		$.messager.popover({msg: "开始值请输入有效数字", type: "info"});
		focusById("stVal");
		return false;
	}
	
	var endVal = getValueById("endVal");
	if (endVal > 365) {
		$.messager.popover({msg: "结束值请输入有效数字", type: "info"});
		focusById("endVal");
		return false;
	}
	
	return bool;
}

/**
* 新增
*/
function validateParamStr(stValStrs, endValStrs) {
	var bool = true;
	var rtn = $.m({ClassName: "web.UDHCJFAgeConfig", MethodName: "Judge", stValStr: stValStrs, endValStr: endValStrs}, false);
	switch (rtn) {
	case "-100":
		$.messager.popover({msg: "选择的单位不存在", type: "info"});
		bool = false;
		break;
	case "-101":
		$.messager.popover({msg: "选择的单位不存在", type: "info"});
		bool = false;
		break;
	case "-102":
		$.messager.popover({msg: "开始值大于结束值", type: "info"});
		bool = false;
		break;
	case "-103":
		$.messager.popover({msg: "单位错误", type: "info"});
		bool = false;
		break;
	default:
	}
	return bool;
}

/**
* 修改
*/
function updateClick() {
	var row = GV.ConfigList.getSelected();
	if (!row) {
		$.messager.popover({msg: "请选择需要修改的记录", type: "info"});
		return;
	}
	var rowId = row.TrowId;
	if (!rowId) {
		return;
	}
	if (!checkData()) {
		return;
	}
	var stValStrs = getValueById("stOperator") + "^" + getValueById("stVal") + "^" + getValueById("stUom");
	var endValStrs = getValueById("endOperator") + "^" + getValueById("endVal") + "^" + getValueById("endUom");
	var dispValStrs = getValueById("dispUom");
	if (!validateParamStr(stValStrs, endValStrs)) {
		return;
	}
	$.messager.confirm("确认", "确认修改？", function(r) {
		if (!r) {
			return;
		}
		$.m({
			ClassName: "web.UDHCJFAgeConfig",
			MethodName: "UpdateConfig",
			stValStr: stValStrs,
			endValStr: endValStrs,
			dispStr: dispValStrs,
			rowId: rowId,
			guser: PUBLIC_CONSTANT.SESSION.USERID,
			hospId: getValueById("hospital")
		}, function(rtn) {
			switch(rtn) {
			case "0":
				$.messager.popover({msg: "修改成功", type: "success"});
				reloadDoc();
				break;
			case "-104":
				$.messager.popover({msg: "结束数值过大", type: "error"});
				break;
			case "-501":
				$.messager.popover({msg: "ID不存在", type: "error"});
				break;
			case "-102":
				$.messager.popover({msg: "结束值大于下一个结束值，修改失败", type: "error"});
				break;
			default:
				$.messager.popover({msg: "修改失败：" + rtn, type: "error"});
			}
		});
	});
}

/**
* 删除
*/
function deleteClick() {
	var row = GV.ConfigList.getSelected();
	if (!row) {
		$.messager.popover({msg: "请选择需要删除的记录", type: "info"});
		return;
	}
	var rowId = row.TrowId;
	if (!rowId) {
		return;
	}
	if (!checkData()) {
		return;
	}
	var stValStrs = getValueById("stOperator") + "^" + getValueById("stVal") + "^" + getValueById("stUom");
	var endValStrs = getValueById("endOperator") + "^" + getValueById("endVal") + "^" + getValueById("endUom");
	var dispValStrs = getValueById("dispUom");
	if (!validateParamStr(stValStrs, endValStrs)) {
		return;
	}
	$.messager.confirm("确认", "确认删除？", function(r) {
		if (!r) {
			return;
		}
		$.m({
			ClassName: "web.UDHCJFAgeConfig",
			MethodName: "DeleteConfig",
			stValStr: stValStrs,
			endValStr: endValStrs,
			dispStr: dispValStrs,
			rowId: rowId,
			guser: PUBLIC_CONSTANT.SESSION.USERID,
			hospId: getValueById("hospital")
		}, function(rtn) {
			switch(rtn) {
			case "0":
				$.messager.popover({msg: "删除成功", type: "success"});
				reloadDoc();
				break;
			case "-104":
				$.messager.popover({msg: "结束数值过大", type: "error"});
				break;
			case "-501":
				$.messager.popover({msg: "ID不存在", type: "error"});
				break;
			default:
				$.messager.popover({msg: "删除失败：" + rtn, type: "error"});
			}
		});
	});
}

function reloadClick() {
	GV.ConfigList.load();
}

function reloadDoc() {
	setValueById("endVal", "");
	setValueById("endUom", "");
	setValueById("dispUom", "");
	getLastValStr();
	GV.ConfigList.reload();
}