/*
 * @Descripttion: 右键引用-检查
 * @Author: yaojining
 */

var GV = {
	code: 'Pacs',
	hospitalID: session['LOGON.HOSPID'],
	className: 'NurMp.Service.Refer.Handle',
	ConfigInfo: new Object(),
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
 * @description: 初始化数据表格
 * @param {object} config
 */
function initData(config) {
	$HUI.datagrid('#dataGrid', {
		url: $URL,
		queryParams: initParameter(config, 'startDate', 'endDate'),
		rownumbers: true,
		singleSelect: true,
		loadMsg: '正在加载信息...',
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
				$('#textContent').removeClass('hasreport_textarea').addClass('noreport_textarea').val($g('检查报告未出！'));
				return false;
			} else {
				if (!!config.resultParams) {
					initDataDetail(rowData);
				}
			}
		},
		onLoadSuccess: function(data) {
			$('#textContent').val($g('请选择一条检查项目！'));
		}
	});
}

/**
 * @description: 对原数据进行加工（标版检查接口有修改，需要做此特殊处理）
 * @param {object} data
 * @return {object} data
 */
function filterData(data) {
	$.each(data.rows, function(index, row) {
		var lx = row.BLOrJc == 1 ? $g('病理') : $g('检查');
		data.rows[index].lx = lx;
	});
	return data;
}

/**
 * @description: 初始化检查结果详细信息
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
 * @description: 组织入参
 */
function initParameter() {
	var config = arguments[0];
	var startDate = !!arguments[1] ? $('#' + arguments[1]).datebox('getValue') : '';
	var endDate = !!arguments[2] ? $('#' + arguments[2]).datebox('getValue') : '';
	eval(config.paramsCommand);
	return config.queryParams;
}

/**
 * @description: 表格数据重载
 */
function reloadData() {
	$('#dataGrid').datagrid('reload', initParameter(GV.ConfigInfo[GV.code], 'startDate', 'endDate'));
	$('#textContent').removeClass('noreport_textarea').addClass('hasreport_textarea').val($g('请选择一条检查项目！'));
}

