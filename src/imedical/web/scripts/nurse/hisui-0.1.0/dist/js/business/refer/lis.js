/*
 * @Descripttion: �Ҽ�����-����
 * @Author: yaojining
 */

var GV = {
	code: 'Lis',
	groupID: 'groupLisSub',
	hospitalID: session['LOGON.HOSPID'],
	className: 'NurMp.Service.Refer.Handle',
	ConfigInfo: new Array(),
	OtherConfig: new Object()

};

/**
 * @description: ��ʼ������
 */
$(function () {
	initConditions();
	requestConfig(initData, false);
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
			var existReport = rowData[config.paramsConfig.isResultCode] || '';
			if (!!existReport) {
				return 'color:green;';
			}
		},
		onClickRow: function (rowIndex, rowData) {
			var param1 = rowData[config.paramsConfig.isOrderIdCode] || '';
			var param2 = rowData[config.paramsConfig.isItemNoCode] || '';    //Ϊ�˼��ݲ�ͬ�ӿ���Σ����Ӽ����
			var param3 = rowData[config.paramsConfig.isResultCode] || '';    //Ϊ�˼��ݲ�ͬ�ӿ���Σ����ӱ���ID
			initDataDetail(param1, param2, param3);
		},
		onLoadSuccess: function (data) {
			GV.OtherConfig = config.otherConfig;
			initDataDetail('','','');
		}
	});
}
/**
 * @description: ��ʼ����������ϸ��Ϣ
 * @param {param1,param2,param3}
 */
function initDataDetail(param1, param2, param3) {
	requestConfig(function(config){
		$HUI.datagrid('#dataSubGrid', {
			url: $URL,
			queryParams: initParameter(config, 'startDate', 'endDate', param1, param2, param3),
			rownumbers: true,
			frozenColumns: config.frozenColumns,
			columns: config.columns,
			rowStyler: function (rowIndex, rowData) {
				var abFlag = rowData[config.paramsConfig.isAbnormalCode];
				if (abFlag == 'H') {
					setTimeout(function () {
						$('#dataSubGrid').datagrid('selectRow', rowIndex);
					}, 200);
					return 'color:red;';
				} else if (abFlag == 'L') {
					setTimeout(function () {
						$('#dataSubGrid').datagrid('selectRow', rowIndex);
					}, 200);
					return 'color:blue;';
				}
			}
		});
	}, true, 'Lis-Detail');
}

/**
 * @description: ��֯���
 */
function initParameter() {
	var config = arguments[0];
	var startDate = !!arguments[1] ? $('#' + arguments[1]).datebox('getValue') : '';
	var endDate = !!arguments[2] ? $('#' + arguments[2]).datebox('getValue') : '';
	var oeoreId = arguments[3];
	var labNo = arguments[4];
	var reportId = arguments[5];
	eval(config.paramsCommand);
	return config.queryParams;
}

/**
 * @description: �����������
 */
function reloadData() {
	$('#dataGrid').datagrid('reload', initParameter(GV.ConfigInfo[GV.code], 'startDate', 'endDate'));
}