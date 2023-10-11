/*
 * @Descripttion: �Ҽ�����-ִ�м�¼
 * @Author: yaojining
 */

var GV = {
	code: 'Exec',
	groupID: 'groupExec',
	hospitalID: session['LOGON.HOSPID'],
	className: 'NurMp.Service.Refer.Handle',
	ConfigInfo: new Object(),
	OtherConfig: new Object()
};

/**
 * @description: ��ʼ������
 */
$(function () {
	initConditions();
	requestConfig(initData);
	listenEvents();
});

/**
 * @description: ��ʼ����ѯ����
 */
function initCondition() {
	$("#orderType").combobox({
		valueField: 'key',
		textField: 'desc',
		value: 'A',
		data: [{ key: 'A', desc: "ȫ��ҽ��" }, { key: 'L', desc: "����ҽ��" }, { key: 'T', desc: "��ʱҽ��" }, { key: 'O', desc: "��Ժ��ҩ" }],
		defaultFilter: 4,
		onSelect: function (record) {
			$('#btnSearch').click();
		}
	});
	$("#orderMeth").combobox({
		valueField: 'id',
		textField: 'desc',
		url: $URL + '?ClassName=' + GV.className + '&MethodName=getOrderMeths',
		defaultFilter: 4,
		onSelect: function (record) {
			$('#btnSearch').click();
		}
	});
}
/**
 * @description: ��ʼ�����ݱ��
 * @param {object} config
 */
function initData(config) {
	var page_list = pageList();
	$HUI.datagrid('#dataGrid', {
		url: $URL,
		queryParams: initParameter(config, 'startDate', 'endDate', 'orderType', 'orderMeth', 'medicineFlag'),
		rownumbers: true,
		singleSelect: false,
		pagination: true,
		pageSize: page_list[0],
		pageList: page_list,
		frozenColumns: config.frozenColumns,
		columns: config.columns,
		nowrap: config.gridProperty.nowrap == "true",
		onLoadSuccess: function (data) {
			GV.OtherConfig = config.otherConfig;
		}
	});
}

/**
 * @description: ��֯���
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
	var modelId = !!arguments[6] ? ModelId : '';
	eval(config.paramsCommand);
	return config.queryParams;
}

/**
 * @description: �����������
 */
function reloadData() {
	$('#dataGrid').datagrid('reload', initParameter(GV.ConfigInfo[GV.code], 'startDate', 'endDate', 'orderType', 'orderMeth', 'medicineFlag'));
}
