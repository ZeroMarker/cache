/*
 * FileName: dhcbill.ipbill.checkbasicdata.js
 * User: tangzf
 * Date: 2020-01-09
 * Function:
 * Description: 基础数据核查
 */

$(function () {
	// 检查项目
	init_CheckDesc();
	// table
	init_dg();
	$(".datebox-f").datebox("setValue", getDefStDate(0));
});

/*
 * 检查项目
 */
function init_CheckDesc() {
	$('#CheckDesc').combogrid({
		panelWidth: 550,
		panelHeight: 360,
		editable: false,
		fitColumns: true,
		idField: 'CheckMethod',
		textField: 'CheckDesc',
		fit: true,
		url: $URL,
		singleSelect: true,
		onBeforeLoad: function (param) {
			param.ClassName = 'web.DHCIPBillCheckDaily';
			param.QueryName = 'CheckClassMethod';
			param.ResultSetType = 'array';
			param.EpisodeID = '';
		},
		columns: [[{field: 'CheckDesc', title: '描述', width: 200},
		           {field: 'CheckMethod', title: '方法', width: 150}
			]]
	});
}

function init_dg() {
	var dgColumns = [[{field: 'TMemoDesc', title: '备注', width: 200},
	                  {field: 'TArcimDesc', title: '医嘱/收费项目', width: 200},
					  {field: 'TArcimCode', title: '代码', width: 200},
					  {field: 'TOrderPrice', title: '药品价格/计费数量', width: 250, align: 'right'},
					  {field: 'TDrugPrice', title: '药房调价价格/发药数量', width: 250, align: 'right'},
					  {field: 'HospDesc', title: '医院', width: 150},
					  {field: 'TRowid', title: 'OEOrdRowID', width: 150, hidden: true},
		]];
	$('#dg').datagrid({
		border: false,
		fit: true,
		striped: true,
		pagination: true,
		rownumbers: true,
		singleSelect: true,
		pageSize: 20,
		columns: dgColumns,
		data: []
	});
}

/*
 * dg
 */
function initLoadGrid() {
	var queryParams = {
		ClassName: 'web.DHCIPBillCheckDaily',
		QueryName: 'FindCheckDaily',
		StDate: getValueById('StDate'),
		EndDate: getValueById('EndDate'),
		CheckFunction: $('#CheckDesc').combogrid('getValue'),
		HOSPID:PUBLIC_CONSTANT.SESSION.HOSPID
	}
	loadDataGridStore('dg', queryParams);
}

/*
 * query
 */
$('#btn-query').bind('click', function () {
	initLoadGrid();
});

/*
 * check
 */
$('#btn-check').bind('click', function () {
	var StDate = getValueById('StDate');
	var EndDate = getValueById('EndDate');
	var CheckFunction = $('#CheckDesc').combogrid('getValue');
	if (!CheckFunction) {
		$.messager.alert('提示', "请选择核查的项目", 'info');
		return;
	}
	switch (CheckFunction) {
	case "GetRebillNum":
		if (checkDateNum()) {
			var RetCode = tkMakeServerCall("web.DHCIPBillCheckDaily", CheckFunction, StDate, EndDate,PUBLIC_CONSTANT.SESSION.HOSPID);
			if (RetCode != "") {
				$.messager.alert('提示', "检查完成: " + RetCode, 'info');
			}
		}
		break;
	case "GetCollectPriceDs":
		if (checkDateNum()) {
			var RetCode = tkMakeServerCall("web.DHCIPBillCheckDaily", CheckFunction, StDate, EndDate,PUBLIC_CONSTANT.SESSION.HOSPID);
			if (RetCode != "") {
				$.messager.alert('提示', "检查完成: " + RetCode, 'info');
			}
		}
		break;
	default:
		var RetCode = tkMakeServerCall("web.DHCIPBillCheckDaily", CheckFunction,PUBLIC_CONSTANT.SESSION.HOSPID);
		if (RetCode != "") {
			$.messager.alert('提示', "检查完成: " + RetCode, 'info');
		}
	}
});

/*
 * check date
 */
function checkDateNum() {
	var StDate = getValueById('StDate');
	var EndDate = getValueById('EndDate');
	var DateNumStr = tkMakeServerCall("web.DHCIPBillCheckDaily", "CheckDateNum", StDate, EndDate);
	var days = 0;
	var CheckDesc = $('#CheckDesc').combobox('getText');
	var CheckFunction = $('#CheckDesc').combobox('getValue');
	if (CheckFunction == 'GetRebillNum') {
		days = 30;
	}
	if (CheckFunction == 'GetCollectPriceDs') {
		days = 20;
	}
	if (!StDate || !EndDate) {
		$.messager.alert('提示', CheckDesc + ":核查的日期不能为空", 'info');
		CheckFunction = "";
		return false;
	}
	if (DateNumStr == "") {
		$.messager.alert('提示', CheckDesc + "获取日期信息失败", 'info');
		return false;
	}
	var DateNumStr1 = DateNumStr.split("^");
	var DateNum = DateNumStr1[0];
	if (isNaN(DateNum) || (DateNum == "")) {
		$.messager.alert('提示', CheckDesc + "获取日期信息失败", 'info');
		return false;
	}
	if (eval(DateNum) > days) {
		$.messager.alert('提示', CheckDesc + "核查日期不能大于" + days + "天", 'info');
		return false;
	}
	if ((eval(DateNum) < 0) && (CheckFunction == 'GetRebillNum')) {
		$.messager.alert('提示', CheckDesc + "核查日期不能小于今天", 'info');
		return false;
	}
	return true;
}
