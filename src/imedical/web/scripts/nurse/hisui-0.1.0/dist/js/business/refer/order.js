/*
 * @Descripttion: 右键引用-医嘱
 * @Author: yaojining
 */

var GV = {
	code: 'Order',
	groupID: 'groupOrder',
	hospitalID: session['LOGON.HOSPID'],
	className: 'NurMp.Service.Refer.Handle',
	ConfigInfo: new Object(),
	OtherConfig: new Object(),
	checkFlag: 0,
};
/**
 * @description: 初始化界面
 */
$(function () {
	initConditions();
	requestConfig(initData);
	listenEvents();
});

/**
 * @description: 初始化查询条件
 */
function initCondition() {
	$("#orderType").combobox({
		valueField: 'key',
		textField: 'desc',
		value: 'A',
		data: [{ key: 'A', desc: $g("全部医嘱") }, { key: 'L', desc: $g("长期医嘱") }, { key: 'T', desc: $g("临时医嘱") }, { key: 'O', desc: $g("出院带药") }], defaultFilter: 4,
		defaultFilter: 4,
		onSelect: function (record) {
			selectOrderType(record);
			debugger;
			$('#btnSearch').click();
		}
	});
	$("#orderMeth").combobox({
		valueField: 'id',
		textField: 'desc',
		url: $URL + '?ClassName=' + GV.className + '&MethodName=getOrderMeths',
		defaultFilter: 4,
		onSelect: function (record) {
			debugger;
			$('#btnSearch').click();
		}
	});
	$("#orderStage").combobox({
		valueField: 'id',
		textField: 'desc',
		value: 'A',
		data: [
			{ id: 'A', desc: $g('全部') },
			{ id: 'PT', desc: $g('普通') },
			{ id: 'SQ', desc: $g('术前') },
			{ id: 'SZ', desc: $g('术中') },
			{ id: 'SH', desc: $g('术后') },
			{ id: 'CZ', desc: $g('产中') },
		],
		defaultFilter: 4,
		onSelect: function (record) {
			debugger;
			$('#btnSearch').click();
		}
	});
}

/**
 * @description: 初始化数据表格
 * @param {object} config
 */
function initData(config) {
	var page_list = pageList();
	$HUI.datagrid('#dataGrid', {
		url: $URL,
		queryParams: initParameter(config, 'startDate', 'endDate', 'orderType', 'orderMeth', 'medicineFlag', 'ckAllVisit', 'ckStoped', 'orderStage', 'modelId'),
		rownumbers: true,
		pagination: true,
		pageSize: page_list[0],
		pageList: page_list,
		frozenColumns: config.frozenColumns,
		columns: config.columns,
		nowrap: config.gridProperty.nowrap == "true",
		singleSelect: false,
		onSelect: function (index, data) {
			checkOrderRows(index, data);
		},
		onUnselect: function (index, data) {
			uncheckOrderRows(index, data);
		},
		onLoadSuccess: function (data) {
			GV.OtherConfig = config.otherConfig;
		}
	});
}

/**
 * @description: 选中行事件
 */
function checkOrderRows(index, data) {
	if (getCheckGroupValue() == true) {
		if (GV.checkFlag == 0) {
			var seqNo = data.SeqNo;
			var rows = $('#dataGrid').datagrid('getRows');
			for (var i = 0; i < rows.length; i++) {
				if (i == index) continue;
				var row = $('#dataGrid').datagrid('getData').rows[i];
				if (row.SeqNo == seqNo) {
					GV.checkFlag = 1;
					$('#dataGrid').datagrid('selectRow', i);
				}
			}
		}
		GV.checkFlag = 0;
	}
}
/**
 * @description: 撤销选中行事件
 */
function uncheckOrderRows(index, data) {
	if (getCheckGroupValue() == true) {
		if (GV.checkFlag == 0) {
			var seqNo = data.SeqNo;
			var rows = $('#dataGrid').datagrid('getRows');
			for (var i = 0; i < rows.length; i++) {
				if (i == index) continue;
				var row = $('#dataGrid').datagrid('getData').rows[i];
				if (row.SeqNo == seqNo) {
					GV.checkFlag = 1;
					$('#dataGrid').datagrid('unselectRow', i);
				}
			}
		}
		GV.checkFlag = 0;
	}
}
/**
 * @description: 是否成组引用
 */
function getCheckGroupValue() {
	var isGroup = $("#ckCheckGroup").radio('getValue');
	return isGroup;
}

/**
 * @description: 组织入参
 */
function initParameter() {
	var config = arguments[0];
	var startDate = !!arguments[1] ? $('#' + arguments[1]).datebox('getValue') : '';
	var endDate = !!arguments[2] ? $('#' + arguments[2]).datebox('getValue') : '';
	var orderType = !!arguments[3] ? $('#' + arguments[3]).combobox('getValue') : 'A';
	var orderMeth = !!arguments[4] ? $('#' + arguments[4]).combobox('getValue') : '';
	var medicineFlag = arguments[5];
	if (!!medicineFlag) {
		var isMedicine = $("#ckIsMedicine").radio('getValue');
		var notMedicine = $("#ckNotMedicine").radio('getValue');
		if (isMedicine && notMedicine) {
			medicineFlag = 'A';
		} else if (isMedicine && !notMedicine) {
			medicineFlag = 'R';
		} else if (!isMedicine && notMedicine) {
			medicineFlag = 'N';
		} else if (!isMedicine && !notMedicine) {
			medicineFlag = '';
		}
	}
	var allVisitFlag = !!arguments[6] ? $('#' + arguments[6]).radio('getValue') : '';
	var stopedFlag = !!arguments[7] ? $('#' + arguments[7]).radio('getValue') : '';
	var orderStage = !!arguments[8] ? $('#' + arguments[8]).combobox('getValue') : 'A';
	var modelId = !!arguments[9] ? ModelId : '';
	eval(config.paramsCommand);
	return config.queryParams;
}

/**
 * @description: 选择医嘱类型
 */
function selectOrderType(record) {
	if (record.key == 'L') {
		$('#tdOrdStoped').show();
	} else {
		$HUI.radio('#ckStoped').setValue(false);
		$('#tdOrdStoped').hide();
	}
}

/**
 * @description: 表格数据重载
 */
function reloadData() {
	$('#dataGrid').datagrid('reload', initParameter(GV.ConfigInfo[GV.code], 'startDate', 'endDate', 'orderType', 'orderMeth', 'medicineFlag', 'ckAllVisit', 'ckStoped', 'orderStage', 'modelId'));
}
