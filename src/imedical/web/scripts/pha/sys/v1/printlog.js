/**
 * description: 系统管理 - 打印日志查询
 * creator:     Huxt 2022-04-29
 * csp:         pha.sys.v1.printlog.csp
 * js:          pha/sys/v1/printlog.js
 */
PHA_COM.App.ProCode = 'SYS';
PHA_COM.App.ProDesc = $g('系统管理');
PHA_COM.App.Csp = 'pha.sys.v1.printlog.csp';
PHA_COM.App.Name = $g('打印日志查询');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};

$(function () {
	$('#panelMain').panel({
		title: PHA_COM.IsTabsMenu() !== true ? $g('打印日志查询') : '',
		headerCls: 'panel-header-gray',
		iconCls: 'icon-paper',
		fit: true,
		bodyCls: 'panel-body-gray'
	});
	
	InitDict();
	InitGridPrintLog();
	InitEvents();
});

// 初始化 - 事件
function InitEvents() {
	$('#btnFind').on('click', QueryPrintLog);
	$('#btnClean').on('click', Clean);
	$('#QText').on('keydown', function (e) {
		if (e.keyCode == 13) {
			QueryPrintLog();
		}
	});
}

// 初始化 - 表单
function InitDict() {
	PHA.ComboBox('logType', {
		placeholder: $g('单据类型') + '...',
		url: PHA_STORE.ComDictionaryAsCode('PrintLogType').url
	});
	PHA.ComboBox('userId', {
		placeholder: $g('操作人') + '...',
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

// 初始化 - 表格
function InitGridPrintLog() {
	var columns = [[{
				field: 'ppl',
				title: 'ppl',
				width: 80,
				hidden: true
			}, {
				field: 'pplDate',
				title: '打印日期',
				width: 95
			}, {
				field: 'pplTime',
				title: '打印时间',
				width: 90
			}, {
				field: 'pplUser',
				title: '操作人',
				width: 150,
				formatter: function(val, rowData, rowIndex){
					if (rowData.pplUserCode == '') {
						return rowData.pplUserName;
					}
					return rowData.pplUserName + ' (' + rowData.pplUserCode + ')';
				}
			}, {
				field: 'pplTypeDesc',
				title: '单据类型',
				width: 140
			}, {
				field: 'pplPointer',
				title: '单据ID',
				width: 120
			}, {
				field: 'pplTimes',
				title: '打印次数',
				width: 80,
				align: 'center'
			}, {
				field: 'pplMacAdd',
				title: 'MAC地址',
				width: 170
			}, {
				field: 'pplIpAdd',
				title: 'IP地址',
				width: 170
			}, {
				field: 'pplRemark',
				title: '备注信息',
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

// 查询
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

// 清屏
function Clean(){
	PHA.DomData('gridPrintLogBar', {
		doType: 'clear'
	});
	$('#gridPrintLog').datagrid('loadData', []);
	InitDictVal();
}
