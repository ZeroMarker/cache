/*
 * @Descripttion: 右键引用-诊断
 * @Author: yaojining
 */

var GV = {
	code: 'Diag',
	groupID: 'groupDiag',
	hospitalID: session['LOGON.HOSPID'],
	className: 'NurMp.Service.Refer.Handle',
	ConfigInfo: new Object(),
	OtherConfig: new Object()
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
 * @description: 初始化数据表格
 * @param {object} config
 */
function initData(config) {
	var page_list = pageList();
	$HUI.datagrid('#dataGrid', {
		url: $URL,
		queryParams: initParameter(config, 'ckAllVisit'),
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
 * @description: 组织入参
 */
function initParameter() {
	var config = arguments[0];
	var allVisitFlag = !!arguments[1] ? $('#' + arguments[1]).radio('getValue') : '';
	var groupId = session['LOGON.GROUPID'];
	eval(config.paramsCommand);
	return config.queryParams;
}

/**
 * @description: 表格数据重载
 */
function reloadData() {
	$('#dataGrid').datagrid('reload', initParameter(GV.ConfigInfo[GV.code], 'ckAllVisit'));
}
