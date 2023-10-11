/**
 * ҩ��ҩ�⹫�� - �ӿڵ�����־��ѯ
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
		placeholder: '����...',
		url: PHA_STORE.Pharmacy().url,
		onSelect: function(){
			QueryFaceLog();
		}
	});
	PHA.ComboBox('faceId', {
		panelWidth: 250,
		placeholder: '�ӿ�...',
		url: PHA_STORE.FaceDict().url,
		onSelect: function(){
			QueryFaceLog();
		}
	});
	PHA.ComboBox('logType', {
		placeholder: '��־���...',
		url: PHA_STORE.ComDictionaryAsCode('FaceLogType').url,
		onSelect: function(){
			QueryFaceLog();
		}
	});
	$HUI.validatebox('#QText', {
		placeholder: '���������ҵ�����...'
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
				title: '�ӿ��ֵ�id',
				hidden: true,
				width: 10
			}, {
				field: 'faceLogId',
				title: '�ӿ�id',
				hidden: true,
				width: 10
			}, {
				field: 'runAgain',
				title: '�ط�',
				width: 50,
				align: 'center',
				formatter: function(value, rowData, rowIndex){
					return LOG_COM.IconBtn('run.png', 'OpenRunFaceWin', rowIndex, '��������ط�����');
				}
			}, {
				field: 'logTypeDesc',
				title: '��־���',
				width: 120
			}, {
				field: 'faceCode',
				title: '�ӿڴ���',
				width: 80
			}, {
				field: 'faceDesc',
				title: '�ӿ�����',
				width: 150
			}, {
				field: 'faceLocDesc',
				title: '�ӿڿ���',
				width: 150
			}, {
				field: 'paramStr',
				title: '����',
				width: 200,
				formatter: function(value, rowData, rowIndex){
					return LOG_COM.IconBtn('search.png', 'OpenParamsFmtWin', rowIndex, '����鿴��ʽ������', value);
				}
			}, {
				field: 'retVal',
				title: '����ֵ',
				width: 200,
				formatter: function(value, rowData, rowIndex){
					var showStr = value || '';
					showStr = showStr.replace(new RegExp('&', 'gm'), '&amp;');
					showStr = showStr.replace(new RegExp('<', 'gm'), '&lt;');
					showStr = showStr.replace(new RegExp('>', 'gm'), '&gt;');
					showStr = showStr.replace(new RegExp("'", 'gm'), '&apos;');
					showStr = showStr.replace(new RegExp('"', 'gm'), '&quot;');
					showStr = showStr.replace(new RegExp(' ', 'gm'), '&nbsp;');
					return LOG_COM.IconBtn('search.png', 'OpenDataFmtWin', rowIndex, '����鷵��ֵ��ϸ', showStr);
				}
			}, {
				field: 'runSuccess',
				title: 'ִ�гɹ�',
				width: 80,
				align: 'center',
				formatter: FormatterCheck
			}, {
				field: 'begDT',
				title: '��ʼʱ��',
				width: 160,
				formatter: function(value, rowData, rowIndex){
					return rowData.begDate + ' ' + rowData.begTime;
				}
			}, {
				field: 'retDT',
				title: '����ʱ��',
				width: 160,
				formatter: function(value, rowData, rowIndex){
					return rowData.retDate + ' ' + rowData.retTime;
				}
			}, {
				field: 'runMethod',
				title: '�෽��',
				width: 200,
				formatter: function(value, rowData, rowIndex){
					return LOG_COM.FmtMethodStr(rowData.className, rowData.methodName, rowData.methodArg);
				}
			}, {
				field: 'runType',
				title: '��������',
				width: 80
			}, {
				field: 'relaLogId',
				title: '������־ID',
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

// ��ѯ
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

// �ط�
function OpenRunFaceWin(rowIndex){
	var rowsData = $('#gridFaceLog').datagrid('getRows');
	var rowData = rowsData[rowIndex];
	if (rowData == null) {
		return;
	}
	if (!rowData.faceRowId || rowData.faceRowId == '') {
		PHA.Popover({
			msg: '�ӿ�IDΪ�գ�',
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
		title: '�������нӿڷ���',
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

// ��ʽ������
function OpenParamsFmtWin(rowIndex){
	var rowsData = $('#gridFaceLog').datagrid('getRows');
	var rowData = rowsData[rowIndex];
	var paramStr = rowData.paramStr;
	
	LOG_COM.ParamsFmtWin({
		paramStr: paramStr
	});
}

// ��ʽ������
function OpenDataFmtWin(rowIndex){
	var rowsData = $('#gridFaceLog').datagrid('getRows');
	var rowData = rowsData[rowIndex];
	var retVal = rowData.retVal;
	
	LOG_COM.DataFmtWin({
		title: '�ӿڷ���ֵ',
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
 