/*
 * @Descripttion: 页面介绍
 * @Author: yaojining
 */
/*
 * @Descripttion: 右键引用-会诊
 * @Author: yaojining
 */

var GV = {
	code: 'Consult',
	groupID: 'groupConsult',
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
		queryParams: initParameter(config, 'startDate', 'endDate'),
		rownumbers: true,
		singleSelect: true,
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
	var startDate = !!arguments[1] ? $('#' + arguments[1]).datebox('getValue') : '';
	var endDate = !!arguments[2] ? $('#' + arguments[2]).datebox('getValue') : '';
	var HospitalID = GV.hospitalID;
	eval(config.paramsCommand);
	return config.queryParams;
}

/**
 * @description: 表格数据重载
 */
function reloadData() {
	$('#dataGrid').datagrid('reload', initParameter(GV.ConfigInfo[GV.code], 'startDate', 'endDate'));
}
