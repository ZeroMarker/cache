/**
 * description: ҩ��ҩ����־ - �û�������־��ѯ
 * creator:     Huxt 2022-05-06
 * csp:         pha.sys.v1.operatelog.csp
 * js:          pha/sys/v1/operatelog.js
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = $g('ҩ��');
PHA_COM.App.Csp = 'pha.sys.v1.operatelog.csp';
PHA_COM.App.Name = $g('�û�������־��ѯ');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};

$(function () {
	$('#panelMain').panel({
		title: PHA_COM.IsTabsMenu() !== true ? $g('�û�������־��ѯ') : '',
		headerCls: 'panel-header-gray',
		iconCls: 'icon-paper',
		fit: true,
		bodyCls: 'panel-body-gray'
	});
	
	InitDict();
	InitGridOperateLog();
	InitEvents();
	
	QueryOperateLog();
});

// ��ʼ�� - �¼�
function InitEvents() {
	$('#btnFind').on('click', QueryOperateLog);
	$('#btnClean').on('click', Clean);
	
	$('#QText').on('keydown', function (e) {
		if (e.keyCode == 13) {
			QueryOperateLog();
		}
	});
}

// ��ʼ�� - ��
function InitDict() {
	PHA.ComboBox('userID', {
		placeholder: '������...',
		url: PHA_STORE.SSUser().url,
		onSelect: function(rowData){
			QueryOperateLog();
		}
	});
	PHA.ComboBox('operate', {
		placeholder: '��������...',
		url: PHA_STORE.ComDictionaryAsCode('OperateLogType').url,
		onSelect: function(rowData){
			QueryOperateLog();
		}
	});
	InitDictVal();
}
function InitDictVal(){
	PHA.SetVals([{
		startDate: 't',
		endDate: 't'
	}]);
}

// ��ʼ�� - ���
function InitGridOperateLog() {
	var columns = [[{
				field: 'piol',
				title: 'piol',
				width: 100,
				hidden: true
			}, {
				field: 'userID',
				title: '������ID',
				width: 100,
				hidden: true
			}, {
				field: 'userName',
				title: '������',
				width: 100
			}, {
				field: 'logDT',
				title: '����ʱ��',
				width: 155,
				align: 'center'
			}, {
				field: 'operateDesc',
				title: '��������',
				width: 100,
				align: 'center',
				formatter: function(value, rowData, rowIndex){
					var colorData = {
						Q: '#339eff',
						P: '#00d5ee',
						E: '#8a24ff',
						A: '#21ba45',
						U: '#f1c516',
						D: '#f16e57',
						O: '#ececec'
					};
					return '<font color="' + colorData[rowData.operate] + '">' + value + '</font>';
				}
			}, {
				field: 'logInput',
				title: '�������',
				width: 240,
				formatter: function(value, rowData, rowIndex){
					return LOG_COM.IconBtn('search.png', 'OpenParamsFmtWin', rowIndex, '����鿴��ʽ������', value);
				}
			}, {
				field: 'serverIP',
				title: '������IP',
				width: 130
			}, {
				field: 'clientIP',
				title: '�ͻ���IP',
				width: 130
			}, {
				field: 'clientMAC',
				title: 'MAC��ַ',
				width: 140
			}, {
				field: 'remarks',
				title: '��ע��Ϣ',
				width: 150
			}, {
				field: 'sessionInfoBtn',
				title: '��¼��Ϣ',
				width: 70,
				align: 'center',
				formatter: function(value, rowData, rowIndex){
					return LOG_COM.IconBtn('search.png', 'OpenSessionWin', rowIndex, '����鿴����ʱ��ϸ��Session��Ϣ');
				}
			}, {
				field: 'type',
				title: '��������',
				width: 200
			}, {
				field: 'pointer',
				title: '����ID',
				width: 100
			}, {
				field: 'origData',
				title: '����ʱ����',
				width: 150
			}
		]
	];
	var dgOptions = {
		url: '',
		queryParams: {
			pClassName: 'PHA.SYS.LOG.Api',
			pMethodName: 'OperateLog',
			pPlug: 'datagrid'
		},
		fitColumns: false,
		rownumbers: true,
		columns: columns,
		pagination: true,
		singleSelect: true,
		toolbar: '#gridOperateLogBar',
		gridSave: true,
		onSelect: function (rowIndex, rowData) {},
		onLoadSuccess: function (data) {},
		onDblClickRow: function(rowIndex, rowData){}
	};
	PHA.Grid('gridOperateLog', dgOptions);
}

// ��ѯ
function QueryOperateLog() {
	var pJson = PHA.DomData('#gridOperateLogBar', {
		doType: 'query',
		retType: 'Json'
	});
	var pJsonStr = JSON.stringify(pJson[0]);
	
	$('#gridOperateLog').datagrid('options').url = PHA.$URL;
	$('#gridOperateLog').datagrid('load', {
		pClassName: 'PHA.SYS.LOG.Api',
		pMethodName: 'OperateLog',
		pPlug: 'datagrid',
		pJsonStr: pJsonStr
	});
}

// ����
function Clean(){
	PHA.DomData('#gridOperateLogBar', {
		doType: 'clear'
	});
	$('#gridOperateLog').datagrid('loadData', []);
	InitDictVal();
}

// ��¼session��Ϣ
function OpenSessionWin(rowIndex){
	var rowsData = $("#gridOperateLog").datagrid("getRows");
	var rowData = rowsData[rowIndex];
	var sessionJson = JSON.parse(rowData.sessionInfo == '' ? '{}' : rowData.sessionInfo);
	
	LOG_COM.SessionWin({
		sessionJson: sessionJson
	});
}

// ��ʽ������
function OpenParamsFmtWin(rowIndex){
	var rowsData = $("#gridOperateLog").datagrid("getRows");
	var rowData = rowsData[rowIndex];
	var logInput = rowData.logInput;
	
	LOG_COM.ParamsFmtWin({
		paramStr: logInput
	});
}