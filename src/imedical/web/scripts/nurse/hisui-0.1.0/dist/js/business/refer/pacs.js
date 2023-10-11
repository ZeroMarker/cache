/*
 * @Descripttion: �Ҽ�����-���
 * @Author: yaojining
 */

var GV = {
	code: 'Pacs',
	hospitalID: session['LOGON.HOSPID'],
	className: 'NurMp.Service.Refer.Handle',
	ConfigInfo: new Object(),
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
	if (JSON.parse(parent.GV.SwitchInfo.AllVisitFlag)) {
		$("#visitNo").combobox({
			valueField: 'id',
			textField: 'desc',
			value: EpisodeID,
			url: $URL + '?ClassName=' + GV.className + '&MethodName=getEpisodeIDs&EpisodeID=' + EpisodeID,
			defaultFilter: 4,
			onSelect: function (record) {
				EpisodeID = record.id;
				$('#btnSearch').click();
			}
		});
	}
}

/**
 * @description: ��ʼ�����ݱ��
 * @param {object} config
 */
function initData(config) {
	$HUI.datagrid('#dataGrid', {
		url: $URL,
		queryParams: initParameter(config, 'startDate', 'endDate'),
		rownumbers: true,
		singleSelect: true,
		loadMsg: '���ڼ�����Ϣ...',
		frozenColumns: config.frozenColumns,
		columns: config.columns,
		nowrap: config.gridProperty.nowrap == "true",
		rowStyler: function (rowIndex, rowData) {
			var existReport = rowData[config.paramsConfig.isResultCode];
			if (existReport.trim() != '') {
				return 'color:green;';
			}
		},
		loadFilter: filterData,
		onClickRow: function (rowIndex, rowData) {
			var result = rowData[config.paramsConfig.isResultCode];
			if (!result) {
				$('#textContent').removeClass('hasreport_textarea').addClass('noreport_textarea').val($g('��鱨��δ����'));
				return false;
			} else {
				if (!!config.resultParams) {
					initDataDetail(rowData);
				}
			}
		},
		onLoadSuccess: function(data) {
			$('#textContent').val($g('��ѡ��һ�������Ŀ��'));
		}
	});
}

/**
 * @description: ��ԭ���ݽ��мӹ��������ӿ����޸ģ���Ҫ�������⴦��
 * @param {object} data
 * @return {object} data
 */
function filterData(data) {
	$.each(data.rows, function(index, row) {
		var lx = row.BLOrJc == 1 ? $g('����') : $g('���');
		data.rows[index].lx = lx;
	});
	return data;
}

/**
 * @description: ��ʼ���������ϸ��Ϣ
 * @param {param}
 */
function initDataDetail(row) {
	var oeordId = $.isEmptyObject(row) ? '' : row[GV.ConfigInfo[GV.code].paramsConfig.isOrderIdCode];
	$m({
		ClassName: GV.ConfigInfo[GV.code].resultParams.ClassName,
		MethodName: GV.ConfigInfo[GV.code].resultParams.MethodName,
		OeordID: oeordId
	}, function (txtData) {
		$('#textContent').removeClass('noreport_textarea').addClass('hasreport_textarea').val(txtData)
	});
}

/**
 * @description: ��֯���
 */
function initParameter() {
	var config = arguments[0];
	var startDate = !!arguments[1] ? $('#' + arguments[1]).datebox('getValue') : '';
	var endDate = !!arguments[2] ? $('#' + arguments[2]).datebox('getValue') : '';
	eval(config.paramsCommand);
	return config.queryParams;
}

/**
 * @description: �����������
 */
function reloadData() {
	$('#dataGrid').datagrid('reload', initParameter(GV.ConfigInfo[GV.code], 'startDate', 'endDate'));
	$('#textContent').removeClass('noreport_textarea').addClass('hasreport_textarea').val($g('��ѡ��һ�������Ŀ��'));
}

