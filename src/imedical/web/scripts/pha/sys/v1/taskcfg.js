/**
 * description: 药房药库任务管理 - 通用任务维护
 * creator:     Huxt 2022-08-08
 * csp:         pha.sys.v1.taskcfg.csp
 * js:          pha/sys/v1/taskcfg.js
 */
PHA_COM.App.ProCode = 'SYS';
PHA_COM.App.ProDesc = $g('系统管理');
PHA_COM.App.Csp = 'pha.sys.v1.taskcfg.csp';
PHA_COM.App.Name = $g('通用任务维护');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};

$(function () {
	InitDict();
	InitGridSysTask();
	InitGridTask();
	InitEvents();
	QuerySysTask();
});

// 初始化 - 事件
function InitEvents() {
	$('#btnHelp').on('click', HelpHandler);
	$('#btnAddSysTask').on('click', AddSysTask);
	$('#btnSaveSysTask').on('click', SaveSysTask);
	$('#btnDeleteSysTask').on('click', DeleteSysTask);
	$('#btnFindSysTask').on('click', QuerySysTask);
	
	$('#btnAddTask').on('click', AddTask);
	$('#btnSaveTask').on('click', SaveTask);
	$('#btnDeleteTask').on("click", DeleteTask);
	$('#btnFindTask').on('click', QueryTask);
	$('#btnUpTask').on("click", UpAndDownTask);
	$('#btnDownTask').on('click', UpAndDownTask);
	$('#btnRunTask').on('click', RunTask);
	$('#btnTaskDetail').on('click', TaskDetail);
	$('#btnTaskHistory').on('click', TaskHistory);
}

// 初始化 - 表单
function InitDict() {
}
function InitDictVal(){
}

// 初始化 - 表格
function InitGridSysTask() {
	var columns = [[{
				field: 'Name',
				title: '系统任务名称',
				width: 150,
				formatter: function(value, rowData, index){
					return value;
				},
				editor: PHA_GridEditor.ValidateBox({})
			}, {
				field: 'Description',
				title: '系统任务描述',
				width: 150,
				tipWidth: 180,
				formatter: function(value, rowData, index){
					return value;
				},
				editor: PHA_GridEditor.ValidateBox({})
			}, {
				field: 'DisplayRun',
				title: '系统任务运行',
				width: 100,
				hidden: true
			}, {
				field: 'DisplayInterval',
				title: '时间间隔',
				width: 100,
				hidden: true
			}, {
				field: 'btns',
				title: '查看',
				width: 100,
				fixed: true,
				align: 'center',
				hidden: true,
				formatter: function(value, rowData, rowIndex){
					var btnsHtml = '';
					btnsHtml += '<a style="border:0px;cursor:pointer;margin-right:5px;" onclick=TaskDetail("' + rowIndex + '")>' + $g('详情') + '</a>';
					btnsHtml += '<label style="color:#e5e5e5;">|</label>';
					btnsHtml += '<a style="border:0px;cursor:pointer;margin-left:5px;" onclick=TaskHistory("' + rowIndex + '")>' + $g('历史') + '</a>';
					return btnsHtml;
				}
			}
		]
	];
	var dgOptions = {
		url: '',
		queryParams: {
			pClassName: 'PHA.SYS.TASK.Api',
			pQueryName: 'GetPHASysTask'
		},
		fitColumns: true,
		rownumbers: false,
		columns: columns,
		pagination: false,
		singleSelect: true,
		toolbar: '#gridSysTaskBar',
		onSelect: function (rowIndex, rowData) {
			QueryTask();
		},
		onLoadSuccess: function (data) {
			if (data && data.total > 0) {
				$(this).datagrid('selectRow', 0);
			} else {
				$('#gridTask').datagrid('loadData', []);
			}
		},
		onClickRow: function (rowIndex, rowData) {
			PHA_GridEditor.End('gridSysTask');
		},
		onDblClickCell: function (index, field, value) {
			PHA_GridEditor.Edit({
				gridID: 'gridSysTask',
				index: index,
				field: field
			});
		},
		gridSave: false
	};
	PHA.Grid('gridSysTask', dgOptions);
}

// 初始化 - 表格
function InitGridTask() {
	var columns = [[{
				field: 'code',
				title: '代码',
				width: 80,
				formatter: function(value, rowData, index){
					return value;
				},
				editor: PHA_GridEditor.ValidateBox({
					required: true
				})
			}, {
				field: 'name',
				title: '描述',
				width: 80,
				formatter: function(value, rowData, index){
					return value;
				},
				editor: PHA_GridEditor.ValidateBox({
					required: true
				})
			}, {
				field: 'exeCode',
				title: '执行代码',
				width: 150,
				formatter: function(value, rowData, index){
					return value;
				},
				editor: PHA_GridEditor.ValidateBox({
					required: true,
					onBlur: function (val, gridRowData, gridRowIndex) {}
				})
			}, {
				field: 'remarks',
				title: '备注',
				width: 80,
				formatter: function(value, rowData, index){
					return value;
				},
				editor: PHA_GridEditor.ValidateBox({})
			}, {
				field: 'activeFlag',
				title: '可用',
				width: 60,
				align: 'center',
				fixed: true,
				formatter: PHA_GridEditor.CheckBoxFormatter,
				editor: PHA_GridEditor.CheckBox({})
			}
		]
	];
	var dgOptions = {
		url: '',
		queryParams: {
			pClassName: 'PHA.SYS.TASK.Api',
			pMethodName: 'GetTask'
		},
		fitColumns: true,
		rownumbers: false,
		columns: columns,
		pagination: false,
		singleSelect: true,
		toolbar: '#gridTaskBar',
		onSelect: function (rowIndex, rowData) {
			$(this).datagrid('options').selectedRowIndex = rowIndex;
		},
		onLoadSuccess: function (data) {
			$('#btnUpTask').prop('disabled', '');
			$('#btnDownTask').prop('disabled', '');
			var selectedRowIndex = $(this).datagrid('options').selectedRowIndex;
			if (selectedRowIndex >= 0 && data.total > selectedRowIndex) {
				$(this).datagrid('selectRow', selectedRowIndex);
			} else if (data.total > 0) {
				$(this).datagrid('selectRow', 0);
			}
		},
		onClickRow: function (rowIndex, rowData) {
			PHA_GridEditor.End('gridTask');
		},
		onDblClickCell: function (index, field, value) {
			PHA_GridEditor.Edit({
				gridID: 'gridTask',
				index: index,
				field: field
			});
		},
		gridSave: false
	};
	PHA.Grid('gridTask', dgOptions);
}

// 查询系统任务列表
function QuerySysTask() {
	var pJson = {};
	var pJsonStr = JSON.stringify(pJson);
	
	$('#gridSysTask').datagrid('options').url = PHA.$URL;
	$('#gridSysTask').datagrid('load', {
		pClassName: 'PHA.SYS.TASK.Api',
		pMethodName: 'GetPHASysTask',
		pPlug: 'datagrid',
		pJsonStr: pJsonStr
	});
}

// 查询药房任务
function QueryTask(){
	var selRow = $('#gridSysTask').datagrid('getSelected');
	if (selRow == null) {
		return;
	}
	var pJsonStr = JSON.stringify(selRow);
	
	$('#gridTask').datagrid('options').url = PHA.$URL;
	$('#gridTask').datagrid('load', {
		pClassName: 'PHA.SYS.TASK.Api',
		pMethodName: 'GetTask',
		pPlug: 'datagrid',
		pJsonStr: pJsonStr
	});
}

// 帮助
function HelpHandler(){
	
}

// 新增系统任务
function AddSysTask(){
	PHA_GridEditor.Add({
		gridID: 'gridSysTask',
		field: 'Name',
		rowData: {
			Name: '',
			Description: ''
		},
		checkRow: true
	}, 1);
}

// 保存系统任务
function SaveSysTask(){
	if (!PHA_GridEditor.EndCheck('gridSysTask')) {
		return;
	}
	PHA_GridEditor.End('gridSysTask');
	var changedRows = PHA_GridEditor.GetChanges('gridSysTask');
	if (!changedRows || changedRows.length == 0) {
		return PHA.Msg('alert', '数据未发生改变');
	}
	var pJson = [];
	for (var i = 0; i < changedRows.length; i++) {
		var iRow = changedRows[i];
		var tRow = $.extend({}, iRow);
		pJson.push(tRow);
	}
	var pJsonStr = JSON.stringify(pJson);
	
	var retJson = PHA.CM({
		pClassName: 'PHA.SYS.TASK.Api',
		pMethodName: 'SavePHASysTaskMulti',
		pJsonStr: pJsonStr
	}, false);
	if (!PHA.Ret(retJson)) {
		return;
	}
	QuerySysTask();
}

// 删除系统任务
function DeleteSysTask(){
	var $grid = $('#gridSysTask');
	var selectedData = $grid.datagrid('getSelected') || '';
	if (selectedData == '') {
		return PHA.Popover({
			msg: '请选择需要删除的行!',
			type: 'alert'
		});
	}
	var dataRowId = selectedData.stId || '';
	
	PHA.Confirm('温馨提示', '是否确定删除?', function () {
		if (dataRowId != '') {
			var retJson = PHA.CM({
				pClassName: 'PHA.SYS.TASK.Api',
				pMethodName: 'DeletePHASysTaskMulti',
				pJsonStr: JSON.stringify([selectedData])
			}, false);
			if (!PHA.Ret(retJson)) {
				return;
			}
		}
		var rowIndex = $grid.datagrid('getRowIndex', selectedData);
		$grid.datagrid('deleteRow', rowIndex);
		$('#gridTask').datagrid('loadData', []);
	});
}

// 添加任务
function AddTask(){
	var selSysTask = $('#gridSysTask').datagrid('getSelected');
	if (!selSysTask) {
		return PHA.Msg('alert', '请输先选择系统任务');
	}
	var stId = selSysTask.stId || '';
	
	PHA_GridEditor.Add({
		gridID: 'gridTask',
		field: 'code',
		rowData: {
			code: '',
			name: '',
			exeCode: '',
			remarks: '',
			sysTaskDR: stId,
			activeFlag: 'Y'
		},
		checkRow: true
	}, 1);
}

// 保存任务
function SaveTask(){
	if (!PHA_GridEditor.EndCheck('gridTask')) {
		return;
	}
	PHA_GridEditor.End('gridTask');
	var changedRows = PHA_GridEditor.GetChanges('gridTask');
	if (!changedRows || changedRows.length == 0) {
		return PHA.Msg('alert', '数据未发生改变');
	}
	var pJson = [];
	for (var i = 0; i < changedRows.length; i++) {
		var iRow = changedRows[i];
		var tRow = $.extend({}, iRow);
		tRow.addUser = session['LOGON.USERID'];
		tRow.updUser = session['LOGON.USERID'];
		pJson.push(tRow);
	}
	var pJsonStr = JSON.stringify(pJson);
	
	var retJson = PHA.CM({
		pClassName: 'PHA.SYS.TASK.Api',
		pMethodName: 'SaveTaskMulti',
		pJsonStr: pJsonStr
	}, false);
	if (!PHA.Ret(retJson)) {
		return;
	}
	QueryTask();
}

// 删除任务
function DeleteTask(){
	var $grid = $('#gridTask');
	var selectedData = $grid.datagrid('getSelected') || '';
	if (selectedData == '') {
		return PHA.Popover({
			msg: '请选择需要删除的行!',
			type: 'alert'
		});
	}
	var dataRowId = selectedData.pit || '';
	
	PHA.Confirm('温馨提示', '是否确定删除?', function () {
		if (dataRowId != '') {
			var retJson = PHA.CM({
				pClassName: 'PHA.SYS.TASK.Api',
				pMethodName: 'DeleteTaskMulti',
				pJsonStr: JSON.stringify([selectedData])
			}, false);
			if (!PHA.Ret(retJson)) {
				return;
			}
		}
		var rowIndex = $grid.datagrid('getRowIndex', selectedData);
		$grid.datagrid('deleteRow', rowIndex);
	});
}

// 上下移动
function UpAndDownTask(e){
	if ($('#btnUpItm').prop('disabled') == 'disabled') {
		return PHA.Popover({
			msg: '您点击太快!',
			type: 'alert'
		});
	}
	var ret = PHA_GridEditor.__UpAndDown_Exchange({
		gridID: 'gridTask',
		ifUp: (e.currentTarget.id.indexOf('Up') > 0 ? true : false)
	});
	if (!ret) {
		return;
	}
	
	var selectedRow = $('#gridTask').datagrid('getSelected');
	var selectedRowIndex = $('#gridTask').datagrid('getRowIndex', selectedRow);
	$('#gridTask').datagrid('options').selectedRowIndex = selectedRowIndex;
	
	$('#btnUpTask').prop('disabled', 'disabled');
	$('#btnDownTask').prop('disabled', 'disabled');
	var saveData = [];
	var rowsData = $('#gridTask').datagrid('getRows');
	for (var i = 0; i < rowsData.length; i++) {
		var iData = rowsData[i];
		var tData = $.extend({}, iData);
		tData.sortNum = i + 1;
		saveData.push(tData);
	}
	var pJsonStr = JSON.stringify(saveData);
	
	var retJson = PHA.CM({
		pClassName: 'PHA.SYS.TASK.Api',
		pMethodName: 'SaveTaskMulti',
		pJsonStr: pJsonStr
	}, false);
	if (!PHA.Ret(retJson)) {
		return;
	}
	QueryTask();
}

// 任务详情页面
function TaskDetail(e){
	if (!isNaN(parseInt(e))) {
		var selRow = $('#gridSysTask').datagrid('getRows')[e];
		if (!selRow) {
			return PHA.Popover({
				msg: '请选择系统任务!',
				type: 'alert'
			});
		}
		if (isNaN(parseInt(selRow._sysTaskId))) {
			return PHA.Popover({
				msg: '至少运行一次系统任务后才能查看',
				type: 'alert'
			});
		}
		var retJson = PHA.CM({
			pClassName: 'PHA.SYS.TASK.Api',
			pMethodName: 'GetRowSysTask',
			pJsonStr: JSON.stringify({
				taskId: selRow._sysTaskId
			})
		}, false);
		PHA_TASK_COM.DetailWin({
			title: '系统任务详细信息',
			data: PHA_TASK_COM.FmtDetail(retJson, 'SysTaskFields')
		});
	} else {
		var selRow = $('#gridTask').datagrid('getSelected');
		if (!selRow) {
			return PHA.Popover({
				msg: '请选择任务明细!',
				type: 'alert'
			});
		}
		var retJson = PHA.CM({
			pClassName: 'PHA.SYS.TASK.Api',
			pMethodName: 'GetRowTask',
			pJsonStr: JSON.stringify({
				taskId: selRow.pit
			})
		}, false);
		PHA_TASK_COM.DetailWin({
			title: '任务详细信息',
			data: PHA_TASK_COM.FmtDetail(retJson, 'TaskFields')
		});
	}
}

// 任务历史详情页面
function TaskHistory(e){
	if (!isNaN(parseInt(e))) {
		var selRow = $('#gridSysTask').datagrid('getRows')[e];
		if (!selRow) {
			return PHA.Popover({
				msg: '请选择系统任务!',
				type: 'alert'
			});
		}
		if (isNaN(parseInt(selRow._sysTaskId))) {
			return PHA.Popover({
				msg: '至少运行一次系统任务后才能查看',
				type: 'alert'
			});
		}
		var pUrl = 'pha.sys.v1.systaskhistory.csp?taskId=' + selRow._sysTaskId + '&taskDesc=' + selRow._sysTaskDescription + '&showTitle=N';
		if ('undefined' !== typeof websys_getMWToken){
			pUrl += "&MWToken=" + websys_getMWToken();
		}
		PHA_TASK_COM.HistoryWin({
			url: pUrl,
			title: '系统任务执行历史查询'
		});
	} else {
		var selRow = $('#gridTask').datagrid('getSelected');
		if (!selRow) {
			return PHA.Popover({
				msg: '请选择任务明细!',
				type: 'alert'
			});
		}
		
		/*
		// UI看不惯这种写法
		var pUrl = 'pha.sys.v1.taskhistory.csp?taskId=' + selRow.pit + '&taskDesc=' + selRow.name + '&showTitle=N';
		if ('undefined' !== typeof websys_getMWToken){
			pUrl += "&MWToken=" + websys_getMWToken();
		}
		PHA_TASK_COM.HistoryWin({
			url: pUrl,
			title: '任务执行历史查询'
		});
		*/
		PHA_REQ_DATA['taskId'] = selRow.pit;
		PHA_REQ_DATA['taskQText'] = selRow.name;
		PHA_REQ_DATA['taskDesc'] = selRow.name;
		$('#history_win').dialog('open');
		onDOMContentLoaded();
	}
}

// 执行任务
function RunTask(){
	var $grid = $('#gridTask');
	var selectedData = $grid.datagrid('getSelected') || '';
	if (selectedData == '') {
		return PHA.Popover({
			msg: '请选择需要删除的行!',
			type: 'alert'
		});
	}
	var pit = selectedData.pit || '';
	if (pit == '') {
		return PHA.Popover({
			msg: '任务没有保存!',
			type: 'alert'
		});
	}
	
	PHA.Confirm('温馨提示', '是否确定执行此任务?', function () {
		var retJson = PHA.CM({
			pClassName: 'PHA.SYS.TASK.Api',
			pMethodName: 'JsRunTask',
			pJsonStr: JSON.stringify({
				pit: pit
			})
		}, false);
		if (!PHA.Ret(retJson)) {
			return;
		}
	});
}