/*
 * @Descripttion: 右键引用-电子病历
 * @Author: yaojining
 */

var GV = {
	code: 'Epr',
	groupID: 'groupEpr',
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
		queryParams: initParameter(config, ''),
		rownumbers: true,
		pagination: true,
		pageSize: page_list[0],
		pageList: page_list,
		singleSelect: false,
		nowrap: false,
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
	var HospitalID = GV.hospitalID;
	eval(config.paramsCommand);
	return config.queryParams;
}

/**
 * @description: 表格数据重载
 */
function reloadData() {
	$('#dataGrid').datagrid('reload', initParameter(GV.ConfigInfo[GV.code], ''));
}