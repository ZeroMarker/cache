/**
 * description: ҩ��ҩ����־ - ����������־��ѯ
 * creator:     Huxt 2022-05-06
 * csp:         pha.sys.v1.runlog.csp
 * js:          pha/sys/v1/runlog.js
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = $g('ҩ��');
PHA_COM.App.Csp = 'pha.sys.v1.runlog.csp';
PHA_COM.App.Name = $g('����������־��ѯ');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};

$(function () {
	$('#panelMain').panel({
		title: PHA_COM.IsTabsMenu() !== true ? $g('����������־��ѯ') : '',
		headerCls: 'panel-header-gray',
		iconCls: 'icon-paper',
		fit: true,
		bodyCls: 'panel-body-gray'
	});
	
	InitDict();
	InitGridRunLog();
	InitEvents();
	
	QueryRunLog();
});

// ��ʼ�� - �¼�
function InitEvents() {
	$('#btnFind').on('click', QueryRunLog);
	$('#btnClean').on('click', Clean);
	
	$('#QText').on('keydown', function (e) {
		if (e.keyCode == 13) {
			QueryRunLog();
		}
	});
}

// ��ʼ�� - ��
function InitDict() {
	PHA.ComboBox('keyInfo', {
		placeholder: '�����ʶ...',
		url: $URL + '?ClassName=PHA.SYS.LOG.Api&MethodName=RunKeyInfoList&pJsonStr={}&retType=string',
		onSelect: function(rowData){
			QueryRunLog();
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
function InitGridRunLog() {
	var columns = [[{
				field: 'pirl',
				title: 'pirl',
				width: 100,
				hidden: true
			}, {
				field: 'description',
				title: '��������',
				width: 100,
				align: 'center'
			}, {
				field: 'keyInfo',
				title: '�����ʶ',
				width: 80
			}, {
				field: 'logDT',
				title: '����ʱ��',
				width: 155,
				align: 'center'
			}, {
				field: 'runInfo',
				title: '����������Ϣ',
				width: 500,
				formatter: function(value, rowData, rowIndex){
					try {
						var runData = JSON.parse(value);
						var retParam = '', tmpValue = '';
						var isFirst = true;
						for (var k in runData) {
							if (['className', 'methodName'].indexOf(k) >= 0) {
								continue;
							}
							tmpValue = "\"" + runData[k] + "\"";
							retParam += (isFirst == true) ? tmpValue : ',' + tmpValue;
							isFirst = false;
						}
						return LOG_COM.FmtMethodStr(runData.className, runData.methodName, retParam);
					} catch(e){
						return value;
					}
					
				}
			}, {
				field: 'remarks',
				title: '��ע��Ϣ',
				width: 160,
				align: 'center'
			}, {
				field: 'stackInfo',
				title: '��ջ��Ϣ',
				width: 70,
				align: 'center',
				formatter: function(value, rowData, rowIndex){
					return LOG_COM.IconBtn('search.png', 'OpenStackInfoWin', rowIndex, '����鿴��ϸ��ջ��Ϣ');
				}
			}, {
				field: 'sessionInfoBtn',
				title: '��¼��Ϣ',
				width: 70,
				align: 'center',
				formatter: function(value, rowData, rowIndex){
					return LOG_COM.IconBtn('search.png', 'OpenSessionWin', rowIndex, '����鿴����ʱ��ϸ��Session��Ϣ');
				}
			}
		]
	];
	var dgOptions = {
		url: '',
		queryParams: {
			pClassName: 'PHA.SYS.LOG.Api',
			pMethodName: 'RunLog',
			pPlug: 'datagrid'
		},
		fitColumns: false,
		rownumbers: true,
		columns: columns,
		pagination: true,
		singleSelect: true,
		toolbar: '#gridRunLogBar',
		gridSave: false,
		onSelect: function (rowIndex, rowData) {},
		onLoadSuccess: function (data) {},
		onDblClickRow: function(rowIndex, rowData){}
	};
	PHA.Grid('gridRunLog', dgOptions);
}

// ��ѯ
function QueryRunLog() {
	var pJson = PHA.DomData('#gridRunLogBar', {
		doType: 'query',
		retType: 'Json'
	});
	var pJsonStr = JSON.stringify(pJson[0]);
	
	$('#gridRunLog').datagrid('options').url = PHA.$URL;
	$('#gridRunLog').datagrid('load', {
		pClassName: 'PHA.SYS.LOG.Api',
		pMethodName: 'RunLog',
		pPlug: 'datagrid',
		pJsonStr: pJsonStr
	});
}

// ����
function Clean(){
	PHA.DomData('#gridRunLogBar', {
		doType: 'clear'
	});
	$('#gridRunLog').datagrid('loadData', []);
	InitDictVal();
}

// ��¼session��Ϣ
function OpenSessionWin(rowIndex){
	var rowsData = $("#gridRunLog").datagrid("getRows");
	var rowData = rowsData[rowIndex];
	var sessionJson = JSON.parse(rowData.sessionInfo == '' ? '{}' : rowData.sessionInfo);
	
	LOG_COM.SessionWin({
		sessionJson: sessionJson
	});
}

// ��ջ��Ϣ����
function OpenStackInfoWin(rowIndex){
	var rowsData = $("#gridRunLog").datagrid("getRows");
	var rowData = rowsData[rowIndex];
	
	LOG_COM.StackInfoWin({
		stackInfo: rowData.stackInfo
	});
}
