/**
 * description: ҩ��ҩ��������� - ͨ��������ʷ��ѯ
 * creator:     Huxt 2022-08-11
 * csp:         pha.sys.v1.taskhistory.csp
 * js:          pha/sys/v1/taskhistory.js
 */
PHA_COM.App.ProCode = 'SYS';
PHA_COM.App.ProDesc = $g('ϵͳ����');
PHA_COM.App.Csp = 'pha.sys.v1.taskhistory.csp';
PHA_COM.App.Name = $g('ͨ��������ʷ��ѯ');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};

// ҳ��Ԫ�ؼ������
function onDOMContentLoaded() {
	PHA_REQ_DATA['taskQText'] = PHA_REQ_DATA['taskDesc'];
	if (PHA_COM.IsTabsMenu() || PHA_REQ_DATA['showTitle'] == 'N'){
		var pOpts = $('#panelMain').panel('options');
		$('#panelMain').panel($.extend(pOpts, {
			title: ''
		}));
	}
	
	InitDict_History();
	InitGridTaskHistory();
	InitEvents_History();
	
	QueryTaskHistory();
}
$(onDOMContentLoaded);

// ��ʼ�� - �¼�
function InitEvents_History() {
	$('#btnFind').on('click', QueryTaskHistory);
	$('#btnClean').on('click', Clean);
	$('#QText').on('keydown', function(e){
		if (e.keyCode == 13) {
			QueryTaskHistory();
		}
	});
}

// ��ʼ�� - ��
function InitDict_History() {
	PHA.ComboGrid('pit', {
		placeholder: '����...',
		idField: 'pit',
		textField: 'name',
		width: 181,
		panelWidth: 450,
		url: PHA.$URL + '&pClassName=PHA.SYS.TASK.Api&pMethodName=GetTask&pPlug=datagrid',
		columns: [[{
			field: 'pit',
			title: 'pit',
			width: 100,
			hidden: true
		}, {
			field: 'Description',
			title: 'ϵͳ����',
			width: 110
		}, {
			field: 'name',
			title: '������ϸ',
			width: 155
		}]],
		fitColumns: true,
		rownumbers: true,
		pagination: true,
		onBeforeLoad: function(param){
			var pJson = {};
			if (PHA_REQ_DATA['taskQText'] && PHA_REQ_DATA['taskQText'] != '') {
				pJson.QText = PHA_REQ_DATA['taskQText'];
			} else {
				pJson.QText = param.q;
			}
			param.pJsonStr = JSON.stringify(pJson);
			PHA_REQ_DATA['taskQText'] = '';
		}
	});
	PHA.ComboBox('runType', {
		placeholder: 'ִ�з�ʽ...',
		width: 181,
		data: [{
			RowId: 'SYS',
			Description: 'ϵͳ����'
		}, {
			RowId: 'USER',
			Description: '�û�ִ��'
		}]
	});
	InitDictVal();
}
function InitDictVal(){
	PHA.SetVals([{
		startDate: 't',
		endDate: 't',
		runType: 'SYS',
		QText: ''
	}]);
	$('#pit').combogrid('setValue', PHA_REQ_DATA['taskId']);
	$('#pit').combogrid('setText', PHA_REQ_DATA['taskDesc']);
}

// ��ʼ�� - ���
function InitGridTaskHistory() {
	var columns = [[{
				field: 'pith',
				title: '������ʷID',
				width: 100,
				hidden: true
			}, {
				field: 'taskDR',
				title: '����ID',
				width: 100,
				hidden: true
			}, {
				field: 'sysTaskHisDR',
				title: '����ϵͳ������ʷID',
				width: 100,
				hidden: true
			}, {
				field: 'taskDetail',
				title: '��������',
				width: 75,
				align: 'center',
				formatter: function(value, rowData, rowIndex){
					var mSpace = '';
					if (!PHA_COM.IsLiteCss) {
						mSpace = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
					}
					return '<span class="icon icon-search" style="border:0px;cursor:pointer;text-align:center;" onclick=TaskDetail_History("' + rowIndex + '")>' + mSpace + '</span>';
					return '<a style="border:0px;cursor:pointer" onclick=TaskDetail_History("' + rowIndex + '")>�鿴</a>';
				}
			}, {
				field: 'jobID',
				title: '����ID',
				width: 80
			}, {
				field: 'taskName',
				title: '������',
				width: 140
			}, {
				field: 'startDateTime',
				title: 'ִ�п�ʼʱ��',
				width: 155,
				formatter: function(value, rowData, index){
					return rowData.startDate + ' ' + rowData.startTime;
				}
			}, {
				field: 'endDateTime',
				title: 'ִ�н���ʱ��',
				width: 155,
				formatter: function(value, rowData, index){
					return rowData.endDate + ' ' + rowData.endTime;
				}
			}, {
				field: 'duration',
				title: '����ִ��ʱ��(��)',
				width: 120,
				align: 'right'
			}, {
				field: 'runTypeDesc',
				title: 'ִ�з�ʽ',
				width: 80
			}, {
				field: 'exeCode',
				title: 'ִ�д���',
				width: 380
			}, {
				field: 'retVal',
				title: 'ִ�д��뷵��ֵ',
				width: 150
			}, {
				field: 'errInfo',
				title: '������Ϣ',
				width: 150
			}, {
				field: 'isRun',
				title: '�Ƿ���ִ��',
				width: 85,
				align: 'center',
				formatter: PHA_GridEditor.CheckBoxFormatter,
			}, {
				field: 'rerunHisDR',
				title: '�������й���ID',
				width: 110
			}, {
				field: 'sessionInfo',
				title: '��¼��Ϣ',
				width: 75,
				align: 'center',
				formatter: function(value, rowData, rowIndex){
					if (rowData.runType == 'USER') {
						return '<a style="border:0px;cursor:pointer" onclick=SessionDetail("' + rowIndex + '")>�鿴</a>';
					}
				}
			}
		]
	];
	var dgOptions = {
		url: '',
		queryParams: {
			pClassName: 'PHA.SYS.TASK.Api',
			pMethodName: 'GetTaskHistory'
		},
		fitColumns: false,
		rownumbers: false,
		columns: columns,
		pagination: true,
		singleSelect: true,
		toolbar: '#gridTaskHistoryBar',
		onSelect: function (rowIndex, rowData) {},
		onLoadSuccess: function () {},
		gridSave: false
	};
	PHA.Grid('gridTaskHistory', dgOptions);
}

// ��ѯ
function QueryTaskHistory() {
	var pJson = PHA.DomData('#gridTaskHistoryBar', {
		doType: 'query',
		retType: 'Json'
	});
	if (pJson.length == 0) {
		return;
	}
	var pJsonStr = JSON.stringify(pJson[0]);
	
	$('#gridTaskHistory').datagrid('options').url = PHA.$URL;
	$('#gridTaskHistory').datagrid('load', {
		pClassName: 'PHA.SYS.TASK.Api',
		pMethodName: 'GetTaskHistory',
		pPlug: 'datagrid',
		pJsonStr: pJsonStr
	});
}

// ����
function Clean(){
	PHA.DomData('#gridTaskHistoryBar', {
		doType: 'clear'
	});
	InitDictVal();
	$('#gridTaskHistory').datagrid('loadData', []);
}

// ��������ҳ��
function TaskDetail_History(rowIndex){
	var rowsData = $('#gridTaskHistory').datagrid('getRows');
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
		pMethodName: 'GetRowTask',
		pJsonStr: JSON.stringify({
			taskId: rowData.taskDR
		})
	}, false);
	PHA_TASK_COM.DetailWin({
		title: '������ϸ��Ϣ',
		data: PHA_TASK_COM.FmtDetail(retJson, 'TaskFields')
	});
}

// session
function SessionDetail(rowIndex){
	var rowsData = $('#gridTaskHistory').datagrid('getRows');
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
	var sessionInfo = rowData.sessionInfo;
	var sessionObj = {};
	try {
		sessionObj = JSON.parse(sessionInfo)
	} catch(e){
		sessionObj = {};
	}
	PHA_TASK_COM.DetailWin({
		title: '�û���¼��Ϣ',
		data: PHA_TASK_COM.FmtDetail(sessionObj)
	});
}
