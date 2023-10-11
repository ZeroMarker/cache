/*
 * @Descripttion: �Ҽ�����-���Ӳ���
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
 * @description: ��ʼ������
 */
$(function () {
	initConditions();
	requestConfig(initData);
	listenEvents();
});

/**
 * @description: ��ʼ�����ݱ��
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
 * @description: ��֯���
 */
function initParameter() {
	var config = arguments[0];
	var HospitalID = GV.hospitalID;
	eval(config.paramsCommand);
	return config.queryParams;
}

/**
 * @description: �����������
 */
function reloadData() {
	$('#dataGrid').datagrid('reload', initParameter(GV.ConfigInfo[GV.code], ''));
}