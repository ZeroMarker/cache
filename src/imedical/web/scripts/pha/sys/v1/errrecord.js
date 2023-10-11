/**
 * 名称:	 药房公共-系统管理-错误日志查询
 * 编写人:	 yunhaibao
 * 编写日期: 2019-03-15~
 */
PHA_COM.App.Csp = 'pha.sys.v1.errrecord.csp';

$(function () {
	InitDict();
	InitGridErrRecord();
	InitEvents();
});

function InitDict() {
	PHA.ComboBox('fromType', {
		data: [{
				RowId: 'A',
				Description: '全部'
			}, {
				RowId: 'PC',
				Description: 'PC端'
			}, {
				RowId: 'MOB',
				Description: '移动端'
			}
		],
		editable: false,
		panelHeight: 'auto'
	});
	
	InitDictVal();
}

function InitDictVal(){
	PHA.DateBox('startDate', {
		value: tkMakeServerCall('PHA.SYS.Com.Util', 'GetDateValue', 't')
	});
	PHA.DateBox('endDate', {
		value: tkMakeServerCall('PHA.SYS.Com.Util', 'GetDateValue', 't')
	});
	$('#fromType').combobox('setValue', 'A');
}

// 表格 - 产品线
function InitGridErrRecord() {
	var columns = [
		[{
				field: 'errId',
				title: 'errId',
				width: 75,
				hidden: true
			}, {
				field: 'errDate',
				title: '日期',
				width: 95,
				sortable: true
			}, {
				field: 'errTime',
				title: '时间',
				width: 75,
				sortable: true
			}, {
				field: 'appName',
				title: '错误发生模块',
				width: 120
			}, {
				field: 'errInfo',
				title: '错误信息',
				width: 400,
				editor: {
					type: 'validatebox'
				}
			}, {
				field: 'keyValue',
				title: '错误数据',
				width: 140
			}, {
				field: 'errTrigger',
				title: '错误代码',
				width: 100
			}, {
				field: 'exceptionsStackDetail',
				title: '堆栈信息',
				width: 70,
				align: 'center',
				formatter: function (value, rowData, rowIndex) {
					return LOG_COM.IconBtn('search.png', 'OpenStackInfoWin', rowIndex, '点击查看堆栈详细信息');
				}
			}, {
				field: 'userName',
				title: '用户',
				width: 105
			}, {
				field: 'locDesc',
				title: '登录科室',
				width: 120
			}, {
				field: 'groupDesc',
				title: '登录安全组',
				width: 120
			}, {
				field: 'ip',
				title: 'IP地址',
				width: 130
			}, {
				field: 'browser',
				title: '浏览器信息',
				width: 300,
				editor: {
					type: 'validatebox'
				}
			}, {
				field: 'pageName',
				title: '页面信息',
				width: 120,
				editor: {
					type: 'validatebox'
				}
			}, {
				field: 'exceptionName',
				title: '异常名称',
				width: 100,
				editor: {
					type: 'validatebox'
				}
			}, {
				field: 'exceptionType',
				title: '异常类型',
				width: 100,
				editor: {
					type: 'validatebox'
				}
			}, {
				field: 'appVersion',
				title: 'app版本',
				width: 90,
				editor: {
					type: 'validatebox'
				}
			}, {
				field: 'OSVersion',
				title: 'OS版本',
				width: 90,
				editor: {
					type: 'validatebox'
				}
			}, {
				field: 'deviceModel',
				title: '设备Model',
				width: 100,
				editor: {
					type: 'validatebox'
				}
			}, {
				field: 'deviceID',
				title: '设备ID',
				width: 100,
				editor: {
					type: 'validatebox'
				}
			}, {
				field: 'netWorkType',
				title: '网络类型',
				width: 90,
				editor: {
					type: 'validatebox'
				}
			}, {
				field: 'memoryInfo',
				title: '内存信息',
				width: 100,
				editor: {
					type: 'validatebox'
				}
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			pClassName: 'PHA.SYS.LOG.Api',
			pMethodName: 'ErrorLog',
			pPlug: 'datagrid'
		},
		pagination: true,
		columns: columns,
		shrinkToFit: true,
		nowrap: true,
		toolbar: '#gridErrLogBar',
		onClickRow: function (rowIndex, rowData) {
			$(this).datagrid('endEditing');
			if ($(this).datagrid('options').editIndex === '') {}
		},
		onDblClickRow: function (rowIndex, rowData) {},
		onDblClickCell: function (index, field, value) {
			var fieldOpts = $(this).datagrid('getColumnOption', field);
			if (fieldOpts.editor) {
				$(this).datagrid('beginEditRow', {
					rowIndex: index,
					editField: field
				});
			}
		}
	};
	PHA.Grid('gridErrRecord', dataGridOption);
}

// 事件
function InitEvents() {
	$('#btnFind').on('click', Query);
	$('#btnClean').on('click', Clean);
	
	$('#QText').on('keydown', function(e){
		if (e.keyCode == 13) {
			Query();
		}
	});
}

// 查询
function Query() {
	var startDate = $('#startDate').datebox('getValue');
	var endDate = $('#endDate').datebox('getValue');
	var fromType = $('#fromType').combobox('getValue');
	var QText = $('#QText').val();
	
	$('#gridErrRecord').datagrid('options').url = PHA.$URL;
	$('#gridErrRecord').datagrid('load', {
		pClassName: 'PHA.SYS.LOG.Api',
		pMethodName: 'ErrorLog',
		pPlug: 'datagrid',
		pJsonStr: JSON.stringify({
			startDate: startDate,
			endDate: endDate,
			fromType: fromType,
			QText: QText
		})
	});
}

//  清屏
function Clean(){
	$('#startDate').datebox('setValue', '');
	$('#endDate').datebox('setValue', '');
	$('#fromType').combobox('setValue', '');
	$('#QText').val('');
	$('#gridErrRecord').datagrid('clear');
	InitDictVal();
}

// 堆栈信息弹窗
function OpenStackInfoWin(rowIndex) {
	var rowsData = $('#gridErrRecord').datagrid('getRows');
	var rowData = rowsData[rowIndex];

	LOG_COM.StackInfoWin({
		stackInfo: '[' + rowData.errInfo + ']; ' + rowData.exceptionsStackDetail
	});
}
