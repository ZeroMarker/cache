/**
 * description: 药房药库日志 - 业务数据日志查询
 * creator:     Huxt 2022-05-06
 * csp:         pha.sys.v1.datalog.csp
 * js:          pha/sys/v1/datalog.js
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = $g('药库');
PHA_COM.App.Csp = 'pha.sys.v1.datalog.csp';
PHA_COM.App.Name = $g('业务数据日志查询');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};

$(function () {
	$('#panelMain').panel({
		title: PHA_COM.IsTabsMenu() !== true ? $g('业务数据日志查询') : '',
		headerCls: 'panel-header-gray',
		iconCls: 'icon-paper',
		fit: true,
		bodyCls: 'panel-body-gray'
	});
	
	InitDict();
	InitGridDataLog();
	InitEvents();
	
	QueryDataLog();
});

// 初始化 - 事件
function InitEvents() {
	$('#btnFind').on('click', QueryDataLog);
	$('#btnClean').on('click', Clean);
	
	$('#dataDesc').on('keydown', function (e) {
		if (e.keyCode == 13) {
			QueryDataLog();
		}
	});
	$('#QText').on('keydown', function (e) {
		if (e.keyCode == 13) {
			QueryDataLog();
		}
	});
}

// 初始化 - 表单
function InitDict() {
	PHA.ComboBox('userID', {
		placeholder: '操作人...',
		url: PHA_STORE.SSUser().url,
		onSelect: function(rowData){
			QueryDataLog();
		}
	});
	PHA.ComboBox('logType', {
		panelHeight: 'auto',
		placeholder: '操作类型...',
		data: [{
			RowId: 'U',
			Description: '修改'
		}, {
			RowId: 'A',
			Description: '新增'
		}, {
			RowId: 'D',
			Description: '删除'
		}],
		onSelect: function(rowData){
			QueryDataLog();
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
function InitGridDataLog() {
	var columns = [[{
				field: 'pidl',
				title: 'pidl',
				width: 100,
				hidden: true
			}, {
				field: 'logTypeDesc',
				title: '操作类型',
				width: 100,
				align: 'center',
				formatter: function(value, rowData, rowIndex){
					if (rowData.logType == 'A') {
				        return '<font color="#21ba45">'+$g("新建")+'</font>';
				    } else if (rowData.logType == 'U'){
				        return '<font color="#f1c516">'+$g("修改")+'</font>';
				    } else if (rowData.logType == 'D'){
				        return '<font color="#f16e57">'+$g("删除")+'</font>';
				    } else {
					    return value;
				    }
				    /*
				    // 不符合UI要求
					var vHtml = '<div style="font-size:12px;padding-left:4px;padding-right:4px;border-radius:2px';
					if (rowData.logType == 'A') {
						vHtml += ';background-color:rgb(228,247,210);color:rgb(19,82,0);">' + value + '</div>';
					} else if(rowData.logType == 'U') {
						vHtml += ';background-color:rgb(255,248,189);color:rgb(97,71,0);">' + value + '</div>';
					} else if (rowData.logType == 'D') {
						vHtml += ';background-color:rgb(255,232,230);color:rgb(130,0,20);">' + value + '</div>';
					} else {
						vHtml += '>' + value + '</div>';
					}
					return vHtml;
					*/
				}
			}, {
				field: 'classDesc',
				title: '操作表描述',
				width: 140
			}, {
				field: 'dataRowId',
				title: '数据ID',
				width: 100
			}, {
				field: 'dataDesc',
				title: '数据描述',
				width: 160
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
				field: 'logGroup',
				title: '组号',
				width: 80
			}, {
				field: 'clientIP',
				title: '客户端IP',
				width: 170
			}, {
				field: 'serverIP',
				title: '服务器IP',
				width: 170
			}, {
				field: 'logDataDetail',
				title: '数据明细',
				width: 70,
				align: 'center',
				formatter: function(value, rowData, rowIndex){
					return LOG_COM.IconBtn('search.png', 'OpenDataDetailWin', rowIndex, '点击查看数据操作明细');
				}
			}, {
				field: 'sessionInfoBtn',
				title: '登录信息',
				width: 70,
				align: 'center',
				formatter: function(value, rowData, rowIndex){
					return LOG_COM.IconBtn('search.png', 'OpenSessionWin', rowIndex, '点击查看操作时详细的Session信息');
				}
			}
		]
	];
	var dgOptions = {
		url: '',
		queryParams: {
			pClassName: 'PHA.SYS.LOG.Api',
			pMethodName: 'DataLog',
			pPlug: 'datagrid'
		},
		fitColumns: false,
		rownumbers: true,
		columns: columns,
		pagination: true,
		singleSelect: true,
		toolbar: '#gridDataLogBar',
		gridSave: false,
		onSelect: function (rowIndex, rowData) {},
		onLoadSuccess: function (data) {},
		onDblClickRow: function(rowIndex, rowData){
			OpenDataDetailWin(rowIndex);
		}
	};
	PHA.Grid('gridDataLog', dgOptions);
}

// 查询
function QueryDataLog() {
	var pJson = PHA.DomData('#gridDataLogBar', {
		doType: 'query',
		retType: 'Json'
	});
	var pJsonStr = JSON.stringify(pJson[0]);
	
	$('#gridDataLog').datagrid('options').url = PHA.$URL;
	$('#gridDataLog').datagrid('load', {
		pClassName: 'PHA.SYS.LOG.Api',
		pMethodName: 'DataLog',
		pPlug: 'datagrid',
		pJsonStr: pJsonStr
	});
}

// 清屏
function Clean(){
	PHA.DomData('#gridDataLogBar', {
		doType: 'clear'
	});
	$('#gridDataLog').datagrid('loadData', []);
	InitDictVal();
}

// 数据明细
function OpenDataDetailWin(rowIndex){
	var rowsData = $("#gridDataLog").datagrid("getRows");
	var rowData = rowsData[rowIndex];
	var detailData = PHA.CM({
		pClassName: 'PHA.SYS.LOG.Api',
		pMethodName: 'DataLogDetail',
		pJsonStr: JSON.stringify({
			pidl: rowData.pidl
		})
	}, false);
	if (detailData.success == 0) {
		PHA.Msg('error', detailData.msg);
		return;
	}
	var main = detailData.main;
	var detail = detailData.detail;
	var mainHtml = '<div style="padding:10px;"><label style="font-weight:bold;">' + main.userName + ' / ' + main.logDT + ' / ' + main.clientIP + ' / ' + main.logTypeDesc + ' / ' + main.tableName + '</label></div>';
	var detailRows = detail;
	
	LOG_COM.DataDetailWin({
		main: main,
		detail: detail,
		mainHtml: mainHtml
	});
}

// 登录session信息
function OpenSessionWin(rowIndex){
	var rowsData = $("#gridDataLog").datagrid("getRows");
	var rowData = rowsData[rowIndex];
	var sessionJson = JSON.parse(rowData.sessionInfo == '' ? '{}' : rowData.sessionInfo);
	
	LOG_COM.SessionWin({
		sessionJson: sessionJson
	});
}
