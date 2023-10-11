/**
 * description: ҩ��ҩ��������� - ϵͳ������ʷ��ѯ
 * creator:     Huxt 2022-08-11
 * csp:         pha.sys.v1.systaskhistory.csp
 * js:          pha/sys/v1/systaskhistory.js
 */
PHA_COM.App.ProCode = 'SYS';
PHA_COM.App.ProDesc = $g('ϵͳ����');
PHA_COM.App.Csp = 'pha.sys.v1.systaskhistory.csp';
PHA_COM.App.Name = $g('ϵͳ������ʷ��ѯ');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};

$(function () {
	PHA_REQ_DATA['taskQText'] = PHA_REQ_DATA['taskDesc'];
	if (PHA_COM.IsTabsMenu() || PHA_REQ_DATA['showTitle'] == 'N'){
		var pOpts = $('#panelMain').panel('options');
		$('#panelMain').panel($.extend(pOpts, {
			title: ''
		}));
	}
	
	InitDict();
	InitGridSysTaskHistory();
	InitEvents();
	
	QuerySysTaskHistory();
});

// ��ʼ�� - �¼�
function InitEvents() {
	$('#btnFind').on('click', QuerySysTaskHistory);
	$('#btnClean').on('click', Clean);
	$('#QText').on('keydown', function(e){
		if (e.keyCode == 13) {
			QuerySysTaskHistory();
		}
	});
}

// ��ʼ�� - ��
function InitDict() {
	PHA.ComboGrid('taskId', {
		placeholder: '����...',
		idField: 'stId',
		textField: 'Description',
		panelWidth: 450,
		url: PHA.$URL + '&pClassName=PHA.SYS.TASK.Api&pMethodName=GetSysTask&pPlug=datagrid',
		columns: [[{
			field: 'stId',
			title: 'stId',
			width: 100,
			hidden: true
		}, {
			field: 'Name',
			title: 'ϵͳ��������',
			width: 155
		}, {
			field: 'Description',
			title: 'ϵͳ��������',
			width: 110
		}]],
		fitColumns: true,
		rownumbers: true,
		pagination: true,
		onBeforeLoad: function(param){
			var pJson = {};
			pJson.findAll = 'Y';
			if (PHA_REQ_DATA['taskQText'] && PHA_REQ_DATA['taskQText'] != '') {
				pJson.QText = PHA_REQ_DATA['taskQText'];
			} else {
				pJson.QText = param.q;
			}
			param.pJsonStr = JSON.stringify(pJson);
			PHA_REQ_DATA['taskQText'] = '';
		}
	});
	
	InitDictVal();
}
function InitDictVal(){
	PHA.SetVals([{
		startDate: 't',
		endDate: 't',
		QText: ''
	}]);
	$('#taskId').combogrid('setValue', PHA_REQ_DATA['taskId']);
	$('#taskId').combogrid('setText', PHA_REQ_DATA['taskDesc']);
}

// ��ʼ�� - ���
function InitGridSysTaskHistory() {
	var columns = [[{
				field: 'taskId',
				title: '����ID',
				width: 70,
				align: 'center',
				formatter: function(value, rowData, rowIndex){
					return '<a style="border:0px;cursor:pointer" onclick=SysTaskDetail("' + rowIndex + '")>' + value + '</a>';
				}
			}, {
				field: 'LastStarted',
				title: '�ϴ�����',
				width: 155
			}, {
				field: 'LastFinished',
				title: '�ϴ����',
				width: 155
			}, {
				field: 'taskName',
				title: '��������',
				width: 155
			}, {
				field: 'taskDesc',
				title: '��������',
				width: 155
			}, {
				field: 'DisplayStatus',
				title: '״̬',
				width: 110
			}, {
				field: 'Error',
				title: '���',
				width: 210
			}, {
				field: 'NameSpace',
				title: '�����ռ�',
				width: 95
			}, {
				field: 'ExecuteCode',
				title: '��������',
				width: 240
			}, {
				field: 'RunningJobNumber',
				title: '����ID',
				width: 100
			}, {
				field: 'DisplayErrorDate',
				title: 'ER����',
				width: 95
			}, {
				field: 'ER',
				title: 'ER����',
				width: 110,
				formatter: function(value, rowData, rowIndex){
					return '<label style="color:red;">' + value + '</label>';
				}
			}, {
				field: 'Username',
				title: '�û�',
				width: 155
			}, {
				field: 'LogDate',
				title: '��־����',
				width: 95
			}, {
				field: 'LogTime',
				title: '��־ʱ��',
				width: 80
			}
		]
	];
	var dgOptions = {
		url: '',
		queryParams: {
			pClassName: 'PHA.SYS.TASK.Api',
			pMethodName: 'GetSysTaskHistory'
		},
		fitColumns: false,
		rownumbers: false,
		columns: columns,
		pagination: true,
		singleSelect: true,
		toolbar: '#gridSysTaskHistoryBar',
		onSelect: function (rowIndex, rowData) {},
		onLoadSuccess: function () {},
		gridSave: false,
		rowStyler: function(rowIndex, rowData){
			if (rowData.ER != ''){
				return 'background-color:#FFB6C1;';
			}
		}

	};
	PHA.Grid('gridSysTaskHistory', dgOptions);
}

// ��ѯ
function QuerySysTaskHistory() {
	var pJson = PHA.DomData('#gridSysTaskHistoryBar', {
		doType: 'query',
		retType: 'Json'
	});
	if (pJson.length == 0) {
		return;
	}
	var pJsonStr = JSON.stringify(pJson[0]);
	
	$('#gridSysTaskHistory').datagrid('options').url = PHA.$URL;
	$('#gridSysTaskHistory').datagrid('load', {
		pClassName: 'PHA.SYS.TASK.Api',
		pMethodName: 'GetSysTaskHistory',
		pPlug: 'datagrid',
		pJsonStr: pJsonStr
	});
}

// ����
function Clean(){
	PHA.DomData('#gridSysTaskHistoryBar', {
		doType: 'clear'
	});
	InitDictVal();
	$('#gridSysTaskHistory').datagrid('loadData', []);
}


// ��������ҳ��
function SysTaskDetail(rowIndex){
	var rowsData = $('#gridSysTaskHistory').datagrid('getRows');
	if (!rowsData) {
		return PHA.Popover({
			msg: '��ѡ��һ������!',
			type: 'alert'
		});
	}
	var rowData = rowsData[rowIndex];
	if (!rowData) {
		return PHA.Popover({
			msg: '��ѡ��һ������!',
			type: 'alert'
		});
	}
	var retJson = PHA.CM({
		pClassName: 'PHA.SYS.TASK.Api',
		pMethodName: 'GetRowSysTask',
		pJsonStr: JSON.stringify({
			taskId: rowData.taskId
		})
	}, false);
	PHA_TASK_COM.DetailWin({
		title: 'ϵͳ������ϸ��Ϣ',
		data: PHA_TASK_COM.FmtDetail(retJson, 'SysTaskFields')
	});
}
