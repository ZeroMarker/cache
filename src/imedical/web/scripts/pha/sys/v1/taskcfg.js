/**
 * description: ҩ��ҩ��������� - ͨ������ά��
 * creator:     Huxt 2022-08-08
 * csp:         pha.sys.v1.taskcfg.csp
 * js:          pha/sys/v1/taskcfg.js
 */
PHA_COM.App.ProCode = 'SYS';
PHA_COM.App.ProDesc = $g('ϵͳ����');
PHA_COM.App.Csp = 'pha.sys.v1.taskcfg.csp';
PHA_COM.App.Name = $g('ͨ������ά��');
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

// ��ʼ�� - �¼�
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

// ��ʼ�� - ��
function InitDict() {
}
function InitDictVal(){
}

// ��ʼ�� - ���
function InitGridSysTask() {
	var columns = [[{
				field: 'Name',
				title: 'ϵͳ��������',
				width: 150,
				formatter: function(value, rowData, index){
					return value;
				},
				editor: PHA_GridEditor.ValidateBox({})
			}, {
				field: 'Description',
				title: 'ϵͳ��������',
				width: 150,
				tipWidth: 180,
				formatter: function(value, rowData, index){
					return value;
				},
				editor: PHA_GridEditor.ValidateBox({})
			}, {
				field: 'DisplayRun',
				title: 'ϵͳ��������',
				width: 100,
				hidden: true
			}, {
				field: 'DisplayInterval',
				title: 'ʱ����',
				width: 100,
				hidden: true
			}, {
				field: 'btns',
				title: '�鿴',
				width: 100,
				fixed: true,
				align: 'center',
				hidden: true,
				formatter: function(value, rowData, rowIndex){
					var btnsHtml = '';
					btnsHtml += '<a style="border:0px;cursor:pointer;margin-right:5px;" onclick=TaskDetail("' + rowIndex + '")>' + $g('����') + '</a>';
					btnsHtml += '<label style="color:#e5e5e5;">|</label>';
					btnsHtml += '<a style="border:0px;cursor:pointer;margin-left:5px;" onclick=TaskHistory("' + rowIndex + '")>' + $g('��ʷ') + '</a>';
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

// ��ʼ�� - ���
function InitGridTask() {
	var columns = [[{
				field: 'code',
				title: '����',
				width: 80,
				formatter: function(value, rowData, index){
					return value;
				},
				editor: PHA_GridEditor.ValidateBox({
					required: true
				})
			}, {
				field: 'name',
				title: '����',
				width: 80,
				formatter: function(value, rowData, index){
					return value;
				},
				editor: PHA_GridEditor.ValidateBox({
					required: true
				})
			}, {
				field: 'exeCode',
				title: 'ִ�д���',
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
				title: '��ע',
				width: 80,
				formatter: function(value, rowData, index){
					return value;
				},
				editor: PHA_GridEditor.ValidateBox({})
			}, {
				field: 'activeFlag',
				title: '����',
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

// ��ѯϵͳ�����б�
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

// ��ѯҩ������
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

// ����
function HelpHandler(){
	
}

// ����ϵͳ����
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

// ����ϵͳ����
function SaveSysTask(){
	if (!PHA_GridEditor.EndCheck('gridSysTask')) {
		return;
	}
	PHA_GridEditor.End('gridSysTask');
	var changedRows = PHA_GridEditor.GetChanges('gridSysTask');
	if (!changedRows || changedRows.length == 0) {
		return PHA.Msg('alert', '����δ�����ı�');
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

// ɾ��ϵͳ����
function DeleteSysTask(){
	var $grid = $('#gridSysTask');
	var selectedData = $grid.datagrid('getSelected') || '';
	if (selectedData == '') {
		return PHA.Popover({
			msg: '��ѡ����Ҫɾ������!',
			type: 'alert'
		});
	}
	var dataRowId = selectedData.stId || '';
	
	PHA.Confirm('��ܰ��ʾ', '�Ƿ�ȷ��ɾ��?', function () {
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

// �������
function AddTask(){
	var selSysTask = $('#gridSysTask').datagrid('getSelected');
	if (!selSysTask) {
		return PHA.Msg('alert', '������ѡ��ϵͳ����');
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

// ��������
function SaveTask(){
	if (!PHA_GridEditor.EndCheck('gridTask')) {
		return;
	}
	PHA_GridEditor.End('gridTask');
	var changedRows = PHA_GridEditor.GetChanges('gridTask');
	if (!changedRows || changedRows.length == 0) {
		return PHA.Msg('alert', '����δ�����ı�');
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

// ɾ������
function DeleteTask(){
	var $grid = $('#gridTask');
	var selectedData = $grid.datagrid('getSelected') || '';
	if (selectedData == '') {
		return PHA.Popover({
			msg: '��ѡ����Ҫɾ������!',
			type: 'alert'
		});
	}
	var dataRowId = selectedData.pit || '';
	
	PHA.Confirm('��ܰ��ʾ', '�Ƿ�ȷ��ɾ��?', function () {
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

// �����ƶ�
function UpAndDownTask(e){
	if ($('#btnUpItm').prop('disabled') == 'disabled') {
		return PHA.Popover({
			msg: '�����̫��!',
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

// ��������ҳ��
function TaskDetail(e){
	if (!isNaN(parseInt(e))) {
		var selRow = $('#gridSysTask').datagrid('getRows')[e];
		if (!selRow) {
			return PHA.Popover({
				msg: '��ѡ��ϵͳ����!',
				type: 'alert'
			});
		}
		if (isNaN(parseInt(selRow._sysTaskId))) {
			return PHA.Popover({
				msg: '��������һ��ϵͳ�������ܲ鿴',
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
			title: 'ϵͳ������ϸ��Ϣ',
			data: PHA_TASK_COM.FmtDetail(retJson, 'SysTaskFields')
		});
	} else {
		var selRow = $('#gridTask').datagrid('getSelected');
		if (!selRow) {
			return PHA.Popover({
				msg: '��ѡ��������ϸ!',
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
			title: '������ϸ��Ϣ',
			data: PHA_TASK_COM.FmtDetail(retJson, 'TaskFields')
		});
	}
}

// ������ʷ����ҳ��
function TaskHistory(e){
	if (!isNaN(parseInt(e))) {
		var selRow = $('#gridSysTask').datagrid('getRows')[e];
		if (!selRow) {
			return PHA.Popover({
				msg: '��ѡ��ϵͳ����!',
				type: 'alert'
			});
		}
		if (isNaN(parseInt(selRow._sysTaskId))) {
			return PHA.Popover({
				msg: '��������һ��ϵͳ�������ܲ鿴',
				type: 'alert'
			});
		}
		var pUrl = 'pha.sys.v1.systaskhistory.csp?taskId=' + selRow._sysTaskId + '&taskDesc=' + selRow._sysTaskDescription + '&showTitle=N';
		if ('undefined' !== typeof websys_getMWToken){
			pUrl += "&MWToken=" + websys_getMWToken();
		}
		PHA_TASK_COM.HistoryWin({
			url: pUrl,
			title: 'ϵͳ����ִ����ʷ��ѯ'
		});
	} else {
		var selRow = $('#gridTask').datagrid('getSelected');
		if (!selRow) {
			return PHA.Popover({
				msg: '��ѡ��������ϸ!',
				type: 'alert'
			});
		}
		
		/*
		// UI����������д��
		var pUrl = 'pha.sys.v1.taskhistory.csp?taskId=' + selRow.pit + '&taskDesc=' + selRow.name + '&showTitle=N';
		if ('undefined' !== typeof websys_getMWToken){
			pUrl += "&MWToken=" + websys_getMWToken();
		}
		PHA_TASK_COM.HistoryWin({
			url: pUrl,
			title: '����ִ����ʷ��ѯ'
		});
		*/
		PHA_REQ_DATA['taskId'] = selRow.pit;
		PHA_REQ_DATA['taskQText'] = selRow.name;
		PHA_REQ_DATA['taskDesc'] = selRow.name;
		$('#history_win').dialog('open');
		onDOMContentLoaded();
	}
}

// ִ������
function RunTask(){
	var $grid = $('#gridTask');
	var selectedData = $grid.datagrid('getSelected') || '';
	if (selectedData == '') {
		return PHA.Popover({
			msg: '��ѡ����Ҫɾ������!',
			type: 'alert'
		});
	}
	var pit = selectedData.pit || '';
	if (pit == '') {
		return PHA.Popover({
			msg: '����û�б���!',
			type: 'alert'
		});
	}
	
	PHA.Confirm('��ܰ��ʾ', '�Ƿ�ȷ��ִ�д�����?', function () {
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