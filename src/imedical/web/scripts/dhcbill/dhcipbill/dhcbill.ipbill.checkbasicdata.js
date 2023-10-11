/*
 * FileName: dhcbill.ipbill.checkbasicdata.js
 * Author: tangzf
 * Date: 2020-01-09
 * Description: 基础数据核查
 */

$(function () {
	// 检查项目
	init_CheckDesc();
	// table
	init_dg();
	
	$(".datebox-f").datebox("setValue", CV.DefDate);
});

/*
 * 检查项目
 */
function init_CheckDesc() {
	$("#CheckDesc").combogrid({
		panelWidth: 550,
		panelHeight: 350,
		editable: false,
		fitColumns: true,
		pagination: true,
		pageSize: 10,
		singleSelect: true,
		idField: 'CheckMethod',
		textField: 'CheckDesc',
		url: $URL + '?ClassName=web.DHCIPBillCheckDaily&QueryName=CheckClassMethod',
		columns: [[{field: 'CheckDesc', title: '描述', width: 200},
		           {field: 'CheckMethod', title: '方法', width: 150}
			]]
	});
}

function init_dg() {
	$("#dg").datagrid({
		fit: true,
		border: false,
		striped: true,
		pagination: true,
		rownumbers: true,
		singleSelect: true,
		pageSize: 20,
		className: "web.DHCIPBillCheckDaily",
		queryName: "FindCheckDaily",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TRowid"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (!cm[i].width) {
					cm[i].width = 100;
				}
			}
		}
	});
}

/**
 * dg
 */
function initLoadGrid() {
	var queryParams = {
		ClassName: "web.DHCIPBillCheckDaily",
		QueryName: "FindCheckDaily",
		StDate: getValueById("StDate"),
		EndDate: getValueById("EndDate"),
		CheckFunction: $("#CheckDesc").combogrid("getValue"),
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}
	loadDataGridStore("dg", queryParams);
}

/**
 * query
 */
$("#btn-query").bind("click", function () {
	initLoadGrid();
});

/**
 * check
 */
$("#btn-check").bind("click", function () {
	var StDate = getValueById("StDate");
	var EndDate = getValueById("EndDate");
	var CheckFunction = $("#CheckDesc").combogrid("getValue");
	if (!CheckFunction) {
		$.messager.alert("提示", "请选择核查的项目", "info");
		return;
	}
	switch (CheckFunction) {
	case "GetRebillNum":
		if (checkDateNum()) {
			var RetCode = tkMakeServerCall("web.DHCIPBillCheckDaily", CheckFunction, StDate, EndDate, PUBLIC_CONSTANT.SESSION.HOSPID);
			if (RetCode != "") {
				$.messager.alert("提示", "检查完成: " + RetCode, "info");
			}
		}
		break;
	case "GetCollectPriceDs":
		if (checkDateNum()) {
			var RetCode = tkMakeServerCall("web.DHCIPBillCheckDaily", CheckFunction, StDate, EndDate, PUBLIC_CONSTANT.SESSION.HOSPID);
			if (RetCode != "") {
				$.messager.alert("提示", "检查完成: " + RetCode, "info");
			}
		}
		break;
	default:
		var RetCode = tkMakeServerCall("web.DHCIPBillCheckDaily", CheckFunction, PUBLIC_CONSTANT.SESSION.HOSPID);
		if (RetCode != "") {
			$.messager.alert("提示", "检查完成: " + RetCode, "info");
		}
	}
});

/**
 * check date
 */
function checkDateNum() {
	var StDate = getValueById("StDate");
	var EndDate = getValueById("EndDate");
	var CheckDesc = $("#CheckDesc").combobox("getText");
	if (!StDate || !EndDate) {
		$.messager.popover({msg: (CheckDesc + ":核查的日期不能为空"), type: "info"});
		return false;
	}
	var DateNumStr = tkMakeServerCall("web.DHCIPBillCheckDaily", "CheckDateNum", StDate, EndDate);
	var days = 0;
	var CheckFunction = $("#CheckDesc").combobox("getValue");
	if (CheckFunction == "GetRebillNum") {
		days = 30;
	}
	if (CheckFunction == "GetCollectPriceDs") {
		days = 20;
	}
	if (DateNumStr == "") {
		$.messager.popover({msg: (CheckDesc + "获取日期信息失败"), type: "info"});
		return false;
	}
	var DateNumStr1 = DateNumStr.split("^");
	var DateNum = DateNumStr1[0];
	if (isNaN(DateNum)) {
		$.messager.popover({msg: (CheckDesc + "获取日期信息失败"), type: "info"});
		return false;
	}
	if (DateNum > days) {
		$.messager.popover({msg: (CheckDesc + "核查日期不能大于" + days + "天"), type: "info"});
		return false;
	}
	if ((DateNum < 0) && (CheckFunction == "GetRebillNum")) {
		$.messager.popover({msg: (CheckDesc + "核查日期不能小于今天"), type: "info"});
		return false;
	}
	return true;
}