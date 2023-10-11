/**
 * description: 药房药库任务管理 - 通用任务历史查询
 * creator:     Huxt 2022-08-11
 * csp:         pha.sys.v1.taskhistory.csp
 * js:          pha/sys/v1/taskhistory.js
 */
PHA_COM.App.ProCode = 'SYS';
PHA_COM.App.ProDesc = $g('系统管理');
PHA_COM.App.Csp = 'pha.sys.v1.taskhistory.csp';
PHA_COM.App.Name = $g('通用任务历史查询');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};

// 页面元素加载完成
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

// 初始化 - 事件
function InitEvents_History() {
	$('#btnFind').on('click', QueryTaskHistory);
	$('#btnClean').on('click', Clean);
	$('#QText').on('keydown', function(e){
		if (e.keyCode == 13) {
			QueryTaskHistory();
		}
	});
}

// 初始化 - 表单
function InitDict_History() {
	PHA.ComboGrid('pit', {
		placeholder: '任务...',
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
			title: '系统任务',
			width: 110
		}, {
			field: 'name',
			title: '任务明细',
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
		placeholder: '执行方式...',
		width: 181,
		data: [{
			RowId: 'SYS',
			Description: '系统任务'
		}, {
			RowId: 'USER',
			Description: '用户执行'
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

// 初始化 - 表格
function InitGridTaskHistory() {
	var columns = [[{
				field: 'pith',
				title: '任务历史ID',
				width: 100,
				hidden: true
			}, {
				field: 'taskDR',
				title: '任务ID',
				width: 100,
				hidden: true
			}, {
				field: 'sysTaskHisDR',
				title: '关联系统任务历史ID',
				width: 100,
				hidden: true
			}, {
				field: 'taskDetail',
				title: '任务详情',
				width: 75,
				align: 'center',
				formatter: function(value, rowData, rowIndex){
					var mSpace = '';
					if (!PHA_COM.IsLiteCss) {
						mSpace = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
					}
					return '<span class="icon icon-search" style="border:0px;cursor:pointer;text-align:center;" onclick=TaskDetail_History("' + rowIndex + '")>' + mSpace + '</span>';
					return '<a style="border:0px;cursor:pointer" onclick=TaskDetail_History("' + rowIndex + '")>查看</a>';
				}
			}, {
				field: 'jobID',
				title: '进程ID',
				width: 80
			}, {
				field: 'taskName',
				title: '任务名',
				width: 140
			}, {
				field: 'startDateTime',
				title: '执行开始时间',
				width: 155,
				formatter: function(value, rowData, index){
					return rowData.startDate + ' ' + rowData.startTime;
				}
			}, {
				field: 'endDateTime',
				title: '执行结束时间',
				width: 155,
				formatter: function(value, rowData, index){
					return rowData.endDate + ' ' + rowData.endTime;
				}
			}, {
				field: 'duration',
				title: '任务执行时长(秒)',
				width: 120,
				align: 'right'
			}, {
				field: 'runTypeDesc',
				title: '执行方式',
				width: 80
			}, {
				field: 'exeCode',
				title: '执行代码',
				width: 380
			}, {
				field: 'retVal',
				title: '执行代码返回值',
				width: 150
			}, {
				field: 'errInfo',
				title: '错误信息',
				width: 150
			}, {
				field: 'isRun',
				title: '是否已执行',
				width: 85,
				align: 'center',
				formatter: PHA_GridEditor.CheckBoxFormatter,
			}, {
				field: 'rerunHisDR',
				title: '重新运行关联ID',
				width: 110
			}, {
				field: 'sessionInfo',
				title: '登录信息',
				width: 75,
				align: 'center',
				formatter: function(value, rowData, rowIndex){
					if (rowData.runType == 'USER') {
						return '<a style="border:0px;cursor:pointer" onclick=SessionDetail("' + rowIndex + '")>查看</a>';
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

// 查询
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

// 清屏
function Clean(){
	PHA.DomData('#gridTaskHistoryBar', {
		doType: 'clear'
	});
	InitDictVal();
	$('#gridTaskHistory').datagrid('loadData', []);
}

// 任务详情页面
function TaskDetail_History(rowIndex){
	var rowsData = $('#gridTaskHistory').datagrid('getRows');
	if (!rowsData) {
		return PHA.Popover({
			msg: '请选择一条数据!',
			type: 'alert'
		});
	}
	var rowData = rowsData[rowIndex];
	if (!rowData) {
		return PHA.Popover({
			msg: '请选择一条数据!',
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
		title: '任务详细信息',
		data: PHA_TASK_COM.FmtDetail(retJson, 'TaskFields')
	});
}

// session
function SessionDetail(rowIndex){
	var rowsData = $('#gridTaskHistory').datagrid('getRows');
	if (!rowsData) {
		return PHA.Popover({
			msg: '请选择一条数据!',
			type: 'alert'
		});
	}
	var rowData = rowsData[rowIndex];
	if (!rowData) {
		return PHA.Popover({
			msg: '请选择一条数据!',
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
		title: '用户登录信息',
		data: PHA_TASK_COM.FmtDetail(sessionObj)
	});
}
