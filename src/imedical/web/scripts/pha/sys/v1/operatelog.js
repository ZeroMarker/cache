/**
 * description: 药房药库日志 - 用户操作日志查询
 * creator:     Huxt 2022-05-06
 * csp:         pha.sys.v1.operatelog.csp
 * js:          pha/sys/v1/operatelog.js
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = $g('药库');
PHA_COM.App.Csp = 'pha.sys.v1.operatelog.csp';
PHA_COM.App.Name = $g('用户操作日志查询');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};

$(function () {
	$('#panelMain').panel({
		title: PHA_COM.IsTabsMenu() !== true ? $g('用户操作日志查询') : '',
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

// 初始化 - 事件
function InitEvents() {
	$('#btnFind').on('click', QueryOperateLog);
	$('#btnClean').on('click', Clean);
	
	$('#QText').on('keydown', function (e) {
		if (e.keyCode == 13) {
			QueryOperateLog();
		}
	});
}

// 初始化 - 表单
function InitDict() {
	PHA.ComboBox('userID', {
		placeholder: '操作人...',
		url: PHA_STORE.SSUser().url,
		onSelect: function(rowData){
			QueryOperateLog();
		}
	});
	PHA.ComboBox('operate', {
		placeholder: '操作类型...',
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

// 初始化 - 表格
function InitGridOperateLog() {
	var columns = [[{
				field: 'piol',
				title: 'piol',
				width: 100,
				hidden: true
			}, {
				field: 'userID',
				title: '操作人ID',
				width: 100,
				hidden: true
			}, {
				field: 'userName',
				title: '操作人',
				width: 100
			}, {
				field: 'logDT',
				title: '操作时间',
				width: 155,
				align: 'center'
			}, {
				field: 'operateDesc',
				title: '操作类型',
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
				title: '操作入参',
				width: 240,
				formatter: function(value, rowData, rowIndex){
					return LOG_COM.IconBtn('search.png', 'OpenParamsFmtWin', rowIndex, '点击查看格式化参数', value);
				}
			}, {
				field: 'serverIP',
				title: '服务器IP',
				width: 130
			}, {
				field: 'clientIP',
				title: '客户端IP',
				width: 130
			}, {
				field: 'clientMAC',
				title: 'MAC地址',
				width: 140
			}, {
				field: 'remarks',
				title: '备注信息',
				width: 150
			}, {
				field: 'sessionInfoBtn',
				title: '登录信息',
				width: 70,
				align: 'center',
				formatter: function(value, rowData, rowIndex){
					return LOG_COM.IconBtn('search.png', 'OpenSessionWin', rowIndex, '点击查看操作时详细的Session信息');
				}
			}, {
				field: 'type',
				title: '数据类型',
				width: 200
			}, {
				field: 'pointer',
				title: '数据ID',
				width: 100
			}, {
				field: 'origData',
				title: '操作时数据',
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

// 查询
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

// 清屏
function Clean(){
	PHA.DomData('#gridOperateLogBar', {
		doType: 'clear'
	});
	$('#gridOperateLog').datagrid('loadData', []);
	InitDictVal();
}

// 登录session信息
function OpenSessionWin(rowIndex){
	var rowsData = $("#gridOperateLog").datagrid("getRows");
	var rowData = rowsData[rowIndex];
	var sessionJson = JSON.parse(rowData.sessionInfo == '' ? '{}' : rowData.sessionInfo);
	
	LOG_COM.SessionWin({
		sessionJson: sessionJson
	});
}

// 格式化参数
function OpenParamsFmtWin(rowIndex){
	var rowsData = $("#gridOperateLog").datagrid("getRows");
	var rowData = rowsData[rowIndex];
	var logInput = rowData.logInput;
	
	LOG_COM.ParamsFmtWin({
		paramStr: logInput
	});
}