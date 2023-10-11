/*
 * @Descripttion: 右键引用-护理记录
 * @Author: yaojining
 */

var GV = {
	code: 'Record2',
	hospitalID: session['LOGON.HOSPID'],
	className: 'NurMp.Service.Refer.Handle',
	ConfigInfo: new Object()
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
	$("#templates").lookup({
		width: 200,
		panelWidth: 500,
		panelHeight: 420,
		url: $URL + "?ClassName=NurMp.Service.Template.List&MethodName=GetTemplatesJson&HospitalID=" + GV.hospitalID + "&LocID=" + session['LOGON.CTLOCID'] + "&EpisodeID=" + EpisodeID,
		mode: 'remote',
		idField: 'Guid',
		textField: 'Text',
		columns: [[
			{ field: 'Text', title: '名称', width: 200 },
			{ field: 'Guid', title: 'GUID', width: 200 },
			{ field: 'Id', title: 'ID', width: 50 }
		]],
		pagination: true,
		pageSize: 10,
		pageList: [10],
		onSelect: reloadData,
		onBeforeLoad: function (param) {
			param.SearchInfo = param.q;
			return true;
		},
		isCombo: true,
		enableNumberEvent: true,
		minQueryLen: 3
	});
}

/**
 * @description: 护理记录2模板加载
 * @param {object} config
 */
function initData(config) {
	var page_list = pageList('templateGrid');
	$HUI.datagrid('#templateGrid', {
		url: $URL,
		queryParams: {
			ClassName: config.queryParams.ClassName,
			QueryName: config.queryParams.QueryName,
			Guid: $("#templates").lookup('getValue'),
			HospitalID: GV.hospitalID,
			LocID: session['LOGON.CTLOCID'],
			LRFlag: '1'
		},
		columns: [[
			{ field: 'ElementLabel', title: '元素描述', width: 150 },
			{ field: 'ItemKey', title: '关键字', width: 100 },
			{ field: 'ElementCode', title: '元素代码', width: 200 },
			{ field: 'Guid', title: 'GUID', width: 250 }
		]],
		rownumbers: true,
		singleSelect: true,
		pagination: true,
		pageSize: page_list[0],
		pageList: page_list,
		displayMsg: '',
		onClickRow: reloadDataSub,
		onLoadSuccess: initDataDetail
	});
}

/**
 * @description: 护理记录2内容加载
 */
function initDataDetail() {
	var page_list = pageList();
	$HUI.datagrid('#dataGrid', {
		url: $URL,
		queryParams: {
			ClassName: GV.ConfigInfo[GV.code].resultParams.ClassName,
			QueryName: GV.ConfigInfo[GV.code].resultParams.QueryName,
			EpisodeID: EpisodeID,
			Guid: '',
			ItemKey: '',
			Sort: GV.ConfigInfo[GV.code].gridProperty.isRever == "true" ? -1 : 1
		},
		columns: [[
			{ field: 'Date', title: '日期', width: 90 },
			{ field: 'Time', title: '时间', width: 70 },
			{ field: 'Value', title: '值', width: 120 },
			{ field: 'Id', title: 'ID', width: 60 }
		]],
		rownumbers: true,
		singleSelect: true,
		pagination: true,
		pageSize: page_list[0],
		pageList: page_list,
		displayMsg: ''
	});
}

/**
 * @description: 选中内容,带入右侧内容Pannel
 */
function customWriteIn() {
	var result = '';
	var erows = $('#templateGrid').datagrid('getSelections');
	if (erows.length == 0) {
		$.messager.popover({ msg: $g('请选中元素！'), type: 'alert' });
		return false;
	}
	var rows = $('#dataGrid').datagrid('getSelections');
	if (rows.length == 0) {
		$.messager.popover({ msg: $g('请选中记录！'), type: 'alert' });
		return false;
	}
	var labelDesc = erows[0].ElementLabel;
	var lastChar = labelDesc.substr(labelDesc.length - 1);
	if ((lastChar == ':') || (lastChar == '：')) {
		labelDesc = labelDesc.substr(0, labelDesc.length - 1);
	}
	var result = rows[0].Value;
	if ((result.indexOf('CA') > -1) && (result.indexOf('*') > -1)) {
		result = result.replace('CA', '').split('*')[0];
	}
	writToPreview(result);
}

/**
 * @description: 表格数据重载
 */
function reloadData() {
	var guid = $('#templates').lookup('getValue');
	var text = $('#templates').lookup('getText');
	if (!text) {
		guid = '';
	}
	$('#templateGrid').datagrid('reload', {
		ClassName: GV.ConfigInfo[GV.code].queryParams.ClassName,
		QueryName: GV.ConfigInfo[GV.code].queryParams.QueryName,
		Guid: guid,
		HospitalID: GV.hospitalID,
		LocID: session['LOGON.CTLOCID'],
		LRFlag: '1'
	});
}

/**
 * @description: 表格数据重载
 */
function reloadDataSub() {
	var rows = $('#templateGrid').datagrid('getSelections');
	if (rows.length == 1) {
		$('#dataGrid').datagrid('reload', {
			ClassName: GV.ConfigInfo[GV.code].resultParams.ClassName,
			QueryName: GV.ConfigInfo[GV.code].resultParams.QueryName,
			EpisodeID: EpisodeID,
			Guid: rows[0].Guid,
			ItemKey: rows[0].ItemKey,
			Sort: GV.ConfigInfo[GV.code].gridProperty.isRever == "true" ? -1 : 1
		});
	}
}