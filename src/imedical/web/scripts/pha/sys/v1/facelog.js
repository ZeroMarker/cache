/**
 * 药房药库公共 - 接口调用日志查询
 * csp: csp/pha.sys.v1.facelog.csp
 * js:  scripts/pha/sys/v1/facelog.js
 */
var Com_HospId = session['LOGON.HOSPID'];
$(function () {
	InitDict();
	InitFaceLogGrid();
	InitEvent();
	
	QueryFaceLog();
});

function InitDict() {
	PHA.ComboBox('faceLocId', {
		placeholder: '科室...',
		url: PHA_STORE.Pharmacy().url,
		onSelect: function(){
			QueryFaceLog();
		}
	});
	PHA.ComboBox('faceId', {
		panelWidth: 250,
		placeholder: '接口...',
		url: PHA_STORE.FaceDict().url,
		onSelect: function(){
			QueryFaceLog();
		}
	});
	PHA.ComboBox('logType', {
		placeholder: '日志类别...',
		url: PHA_STORE.ComDictionaryAsCode('FaceLogType').url,
		onSelect: function(){
			QueryFaceLog();
		}
	});
	$HUI.validatebox('#QText', {
		placeholder: '输入您想找的内容...'
	});
	
	InitDictVal();
}
function InitDictVal(){
	$('#startDate').datebox('setValue', 't');
	$('#endDate').datebox('setValue', 't');
}

function InitEvent() {
	$('#btnFind').on('click', QueryFaceLog);
	$('#btnClean').on('click', Clean);
	
	$('#QText').on('keydown', function(e){
		if (e.keyCode == 13) {
			QueryFaceLog();
		}
	});
}

function InitFaceLogGrid() {
	var columns = [[{
				field: 'faceRowId',
				title: '接口字典id',
				hidden: true,
				width: 10
			}, {
				field: 'faceLogId',
				title: '接口id',
				hidden: true,
				width: 10
			}, {
				field: 'runAgain',
				title: '重发',
				width: 50,
				align: 'center',
				formatter: function(value, rowData, rowIndex){
					return LOG_COM.IconBtn('run.png', 'OpenRunFaceWin', rowIndex, '点击弹出重发窗口');
				}
			}, {
				field: 'logTypeDesc',
				title: '日志类别',
				width: 120
			}, {
				field: 'faceCode',
				title: '接口代码',
				width: 80
			}, {
				field: 'faceDesc',
				title: '接口描述',
				width: 150
			}, {
				field: 'faceLocDesc',
				title: '接口科室',
				width: 150
			}, {
				field: 'paramStr',
				title: '参数',
				width: 200,
				formatter: function(value, rowData, rowIndex){
					return LOG_COM.IconBtn('search.png', 'OpenParamsFmtWin', rowIndex, '点击查看格式化参数', value);
				}
			}, {
				field: 'retVal',
				title: '返回值',
				width: 200,
				formatter: function(value, rowData, rowIndex){
					var showStr = value || '';
					showStr = showStr.replace(new RegExp('&', 'gm'), '&amp;');
					showStr = showStr.replace(new RegExp('<', 'gm'), '&lt;');
					showStr = showStr.replace(new RegExp('>', 'gm'), '&gt;');
					showStr = showStr.replace(new RegExp("'", 'gm'), '&apos;');
					showStr = showStr.replace(new RegExp('"', 'gm'), '&quot;');
					showStr = showStr.replace(new RegExp(' ', 'gm'), '&nbsp;');
					return LOG_COM.IconBtn('search.png', 'OpenDataFmtWin', rowIndex, '点击查返回值明细', showStr);
				}
			}, {
				field: 'runSuccess',
				title: '执行成功',
				width: 80,
				align: 'center',
				formatter: FormatterCheck
			}, {
				field: 'begDT',
				title: '开始时间',
				width: 160,
				formatter: function(value, rowData, rowIndex){
					return rowData.begDate + ' ' + rowData.begTime;
				}
			}, {
				field: 'retDT',
				title: '结束时间',
				width: 160,
				formatter: function(value, rowData, rowIndex){
					return rowData.retDate + ' ' + rowData.retTime;
				}
			}, {
				field: 'runMethod',
				title: '类方法',
				width: 200,
				formatter: function(value, rowData, rowIndex){
					return LOG_COM.FmtMethodStr(rowData.className, rowData.methodName, rowData.methodArg);
				}
			}, {
				field: 'runType',
				title: '运行类型',
				width: 80
			}, {
				field: 'relaLogId',
				title: '关联日志ID',
				width: 90
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			pClassName: 'PHA.SYS.LOG.Api',
			pMethodName: 'FaceLog',
			pPlug: 'datagrid'
		},
		pagination: true,
		columns: columns,
		toolbar: '#gridFaceLogBar',
		fitColumns: false,
		rownumbers: true,
		nowrap: true,
		gridSave: true,
		onRowContextMenu: function(){},
		onHeaderContextMenu: function(e, field){},
		onClickRow: function (rowIndex, rowData) {},
		onDblClickRow: function (rowIndex, rowData) {
			if (rowData) {}
		},
		onLoadSuccess: function (data) {
			$(this).datagrid('autoSizeColumn', 'runMethod');
		}
	};
	PHA.Grid('gridFaceLog', dataGridOption);
}

// 查询
function QueryFaceLog() {
	var pJson = PHA.DomData('#gridFaceLogBar', {
		doType: 'query',
		retType: 'Json'
	});
	pJson[0].hospId = Com_HospId;
	var pJsonStr = JSON.stringify(pJson[0]);
	
	$('#gridFaceLog').datagrid('options').url = PHA.$URL;
	$('#gridFaceLog').datagrid('load', {
		pClassName: 'PHA.SYS.LOG.Api',
		pMethodName: 'FaceLog',
		pPlug: 'datagrid',
		pJsonStr: pJsonStr
	});
}

function Clean(){
	PHA.DomData('#gridFaceLogBar', {
		doType: 'clear'
	});
	$('#gridFaceLog').datagrid('loadData', []);
	InitDictVal();
}

// 重发
function OpenRunFaceWin(rowIndex){
	var rowsData = $('#gridFaceLog').datagrid('getRows');
	var rowData = rowsData[rowIndex];
	if (rowData == null) {
		return;
	}
	if (!rowData.faceRowId || rowData.faceRowId == '') {
		PHA.Popover({
			msg: '接口ID为空！',
			type: 'alert',
			timeout: 1000
		});
		return;
	}
	var methodParams = {};
	var paramStr = rowData.paramStr;
	try {
		methodParams = JSON.parse(paramStr);
	} catch(e){}
	LOG_COM.RunFaceWin({
		title: '重新运行接口方法',
		editParam: false,
		ClassName: rowData.className,
		MethodName: rowData.methodName,
		MethodParams: methodParams,
		faceLoc: rowData.faceLocId,
		faceCode: rowData.faceCode,
		runType: 'Rerun',
		relaLogId: rowData.faceLogId,
		runRet: '' // rowData.retVal
	});
}

// 格式化参数
function OpenParamsFmtWin(rowIndex){
	var rowsData = $('#gridFaceLog').datagrid('getRows');
	var rowData = rowsData[rowIndex];
	var paramStr = rowData.paramStr;
	
	LOG_COM.ParamsFmtWin({
		paramStr: paramStr
	});
}

// 格式化参数
function OpenDataFmtWin(rowIndex){
	var rowsData = $('#gridFaceLog').datagrid('getRows');
	var rowData = rowsData[rowIndex];
	var retVal = rowData.retVal;
	
	LOG_COM.DataFmtWin({
		title: '接口返回值',
		dataStr: retVal
	});
}

function FormatterCheck(value, row, index) {
	if (value === 'Y' || value === '1') {
		return PHA_COM.Fmt.Grid.Yes.Chinese;
	} else {
		return PHA_COM.Fmt.Grid.No.Chinese;
	}
}
 