/*
 * @Descripttion: �Ҽ�����-ҽ��
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
		data: [{ key: 'A', desc: $g("ȫ��ҽ��") }, { key: 'L', desc: $g("����ҽ��") }, { key: 'T', desc: $g("��ʱҽ��") }, { key: 'O', desc: $g("��Ժ��ҩ") }], defaultFilter: 4,
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
			{ id: 'A', desc: $g('ȫ��') },
			{ id: 'PT', desc: $g('��ͨ') },
			{ id: 'SQ', desc: $g('��ǰ') },
			{ id: 'SZ', desc: $g('����') },
			{ id: 'SH', desc: $g('����') },
			{ id: 'CZ', desc: $g('����') },
		],
		defaultFilter: 4,
		onSelect: function (record) {
			debugger;
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
 * @description: ѡ�����¼�
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
 * @description: ����ѡ�����¼�
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
 * @description: �Ƿ��������
 */
function getCheckGroupValue() {
	var isGroup = $("#ckCheckGroup").radio('getValue');
	return isGroup;
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
	var allVisitFlag = !!arguments[6] ? $('#' + arguments[6]).radio('getValue') : '';
	var stopedFlag = !!arguments[7] ? $('#' + arguments[7]).radio('getValue') : '';
	var orderStage = !!arguments[8] ? $('#' + arguments[8]).combobox('getValue') : 'A';
	var modelId = !!arguments[9] ? ModelId : '';
	eval(config.paramsCommand);
	return config.queryParams;
}

/**
 * @description: ѡ��ҽ������
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
 * @description: �����������
 */
function reloadData() {
	$('#dataGrid').datagrid('reload', initParameter(GV.ConfigInfo[GV.code], 'startDate', 'endDate', 'orderType', 'orderMeth', 'medicineFlag', 'ckAllVisit', 'ckStoped', 'orderStage', 'modelId'));
}
