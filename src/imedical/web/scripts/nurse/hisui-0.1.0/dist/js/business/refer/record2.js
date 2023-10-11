/*
 * @Descripttion: �Ҽ�����-�����¼
 * @Author: yaojining
 */

var GV = {
	code: 'Record2',
	hospitalID: session['LOGON.HOSPID'],
	className: 'NurMp.Service.Refer.Handle',
	ConfigInfo: new Object()
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
	$("#templates").lookup({
		width: 200,
		panelWidth: 500,
		panelHeight: 420,
		url: $URL + "?ClassName=NurMp.Service.Template.List&MethodName=GetTemplatesJson&HospitalID=" + GV.hospitalID + "&LocID=" + session['LOGON.CTLOCID'] + "&EpisodeID=" + EpisodeID,
		mode: 'remote',
		idField: 'Guid',
		textField: 'Text',
		columns: [[
			{ field: 'Text', title: '����', width: 200 },
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
 * @description: �����¼2ģ�����
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
			{ field: 'ElementLabel', title: 'Ԫ������', width: 150 },
			{ field: 'ItemKey', title: '�ؼ���', width: 100 },
			{ field: 'ElementCode', title: 'Ԫ�ش���', width: 200 },
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
 * @description: �����¼2���ݼ���
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
			{ field: 'Date', title: '����', width: 90 },
			{ field: 'Time', title: 'ʱ��', width: 70 },
			{ field: 'Value', title: 'ֵ', width: 120 },
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
 * @description: ѡ������,�����Ҳ�����Pannel
 */
function customWriteIn() {
	var result = '';
	var erows = $('#templateGrid').datagrid('getSelections');
	if (erows.length == 0) {
		$.messager.popover({ msg: $g('��ѡ��Ԫ�أ�'), type: 'alert' });
		return false;
	}
	var rows = $('#dataGrid').datagrid('getSelections');
	if (rows.length == 0) {
		$.messager.popover({ msg: $g('��ѡ�м�¼��'), type: 'alert' });
		return false;
	}
	var labelDesc = erows[0].ElementLabel;
	var lastChar = labelDesc.substr(labelDesc.length - 1);
	if ((lastChar == ':') || (lastChar == '��')) {
		labelDesc = labelDesc.substr(0, labelDesc.length - 1);
	}
	var result = rows[0].Value;
	if ((result.indexOf('CA') > -1) && (result.indexOf('*') > -1)) {
		result = result.replace('CA', '').split('*')[0];
	}
	writToPreview(result);
}

/**
 * @description: �����������
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
 * @description: �����������
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