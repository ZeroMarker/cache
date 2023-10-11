/**
 * description: ϵͳ���� - ��ӡ��־��ѯ
 * creator:     Huxt 2022-04-29
 * csp:         pha.sys.v1.printlog.csp
 * js:          pha/sys/v1/printlog.js
 */
PHA_COM.App.ProCode = 'SYS';
PHA_COM.App.ProDesc = $g('ϵͳ����');
PHA_COM.App.Csp = 'pha.sys.v1.printlog.csp';
PHA_COM.App.Name = $g('��ӡ��־��ѯ');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};

$(function () {
	$('#panelMain').panel({
		title: PHA_COM.IsTabsMenu() !== true ? $g('��ӡ��־��ѯ') : '',
		headerCls: 'panel-header-gray',
		iconCls: 'icon-paper',
		fit: true,
		bodyCls: 'panel-body-gray'
	});
	
	InitDict();
	InitGridPrintLog();
	InitEvents();
});

// ��ʼ�� - �¼�
function InitEvents() {
	$('#btnFind').on('click', QueryPrintLog);
	$('#btnClean').on('click', Clean);
	$('#QText').on('keydown', function (e) {
		if (e.keyCode == 13) {
			QueryPrintLog();
		}
	});
}

// ��ʼ�� - ��
function InitDict() {
	PHA.ComboBox('logType', {
		placeholder: $g('��������') + '...',
		url: PHA_STORE.ComDictionaryAsCode('PrintLogType').url
	});
	PHA.ComboBox('userId', {
		placeholder: $g('������') + '...',
		url: PHA_STORE.SSUser().url
	});
	InitDictVal();
}
function InitDictVal() {
	PHA.SetVals([{
		startDate: PHA_UTIL.SysDate('t'),
		endDate: PHA_UTIL.SysDate('t'),
	}]);
}

// ��ʼ�� - ���
function InitGridPrintLog() {
	var columns = [[{
				field: 'ppl',
				title: 'ppl',
				width: 80,
				hidden: true
			}, {
				field: 'pplDate',
				title: '��ӡ����',
				width: 95
			}, {
				field: 'pplTime',
				title: '��ӡʱ��',
				width: 90
			}, {
				field: 'pplUser',
				title: '������',
				width: 150,
				formatter: function(val, rowData, rowIndex){
					if (rowData.pplUserCode == '') {
						return rowData.pplUserName;
					}
					return rowData.pplUserName + ' (' + rowData.pplUserCode + ')';
				}
			}, {
				field: 'pplTypeDesc',
				title: '��������',
				width: 140
			}, {
				field: 'pplPointer',
				title: '����ID',
				width: 120
			}, {
				field: 'pplTimes',
				title: '��ӡ����',
				width: 80,
				align: 'center'
			}, {
				field: 'pplMacAdd',
				title: 'MAC��ַ',
				width: 170
			}, {
				field: 'pplIpAdd',
				title: 'IP��ַ',
				width: 170
			}, {
				field: 'pplRemark',
				title: '��ע��Ϣ',
				width: 250
			}
		]
	];
	var dgOptions = {
		url: '',
		queryParams: {
			pClassName: 'PHA.SYS.LOG.Api',
			pMethodName: 'PrintLog',
			pPlug: 'datagrid'
		},
		fitColumns: false,
		rownumbers: false,
		columns: columns,
		pagination: true,
		singleSelect: true,
		pageSize: 100,
		toolbar: '#gridPrintLogBar',
		onSelect: function (rowIndex, rowData) {},
		onLoadSuccess: function (data) {}
	};
	PHA.Grid('gridPrintLog', dgOptions);
}

// ��ѯ
function QueryPrintLog() {
	var pJsonArr = PHA.DomData('#gridPrintLogBar', {
		doType: 'query',
		retType: 'Json'
	});
	if (pJsonArr.length == 0) {
		return;
	}
	var pJsonStr = JSON.stringify(pJsonArr[0]);
	
	$('#gridPrintLog').datagrid('options').url = PHA.$URL;
	$('#gridPrintLog').datagrid('load', {
		pClassName: 'PHA.SYS.LOG.Api',
		pMethodName: 'PrintLog',
		pPlug: 'datagrid',
		pJsonStr: pJsonStr
	});
}

// ����
function Clean(){
	PHA.DomData('gridPrintLogBar', {
		doType: 'clear'
	});
	$('#gridPrintLog').datagrid('loadData', []);
	InitDictVal();
}
