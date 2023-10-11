/*
 * 名称:	 毒麻药品管理 - 科室基数台账查询
 * 编写人:	 Huxt
 * 编写日期: 2021-08-10
 * csp:      pha.in.v1.narcbaselog.csp
 * js:       pha/in/v1/narcbaselog.js
 */

PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = '药库';
PHA_COM.App.Csp = 'pha.in.v1.narcbaselog.csp';
PHA_COM.App.Name = $g('科室库存基数台账');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = false;
PHA_COM.VAR = {
	hospId: session['LOGON.HOSPID'],
	groupId: session['LOGON.GROUPID'],
	userId: session['LOGON.USERID'],
	locId: session['LOGON.CTLOCID']
};

$(function () {
	PHA_COM.ResizePanel({
		layoutId: 'layout-main',
		region: 'north',
		height: 0.54
	});
	if (!PHA_COM.IsTabsMenu()){
		var pOpts = $('#panelBaseLogTotal').panel('options');
		$('#panelBaseLogTotal').panel('setTitle', PHA_COM.App.Name + ' - ' + pOpts.title);
	}
	
	InitDict();
	InitGridBaseLogTotal();
	InitGridBaseLogDetail();
	InitEvents();
	InitConfig();
});

function InitEvents(){
	$('#btnFind').on('click', QueryBaseLogTotal);
	$('#btnClear').on('click', Clear);
}

function InitDict(){
	$('#startTime').timespinner({
	    showSeconds: true
	});
	$('#endTime').timespinner({
	    showSeconds: true
	});
	PHA.ComboBox('locId', {
		placeholder: '科室...',
		disabled: true,
		width: 200,
		url: PHA_STORE.CTLoc().url
	});
	PHA.ComboBox("poisonIdStr", {
		placeholder: '管制分类...',
		width: 230,
		url: PHA_STORE.PHCPoison().url,
		multiple: true,
		rowStyle: 'checkbox',
		selectOnNavigation: false
	});
	PHA.ComboBox("qtyStatus", {
		placeholder: '业务量...',
		width: 230,
		data: [
			{RowId:'0', Description: $g('等于0')},
			{RowId:'1', Description: $g('不等于0')},
			{RowId:'2', Description: $g('大于0')},
			{RowId:'3', Description: $g('小于0')}
		],
		editable: true,
		panelHeight: 'auto'
	});
	PHA.ComboGrid('inci', {
		width: 200,
		panelWidth: 450,
		placeholder: '药品...',
		url: $URL + '?ClassName=PHA.IN.Narc.Com&QueryName=INCItm&HospId=' + session['LOGON.HOSPID'],
		idField: 'inci',
		textField: 'inciDesc',
		columns: [[{
					field: 'inci',
					title: '库存项Id',
					width: 60,
					hidden: true
				}, {
					field: 'inciCode',
					title: '代码',
					width: 120
				}, {
					field: 'inciDesc',
					title: '名称',
					width: 200
				}, {
					field: 'inciSpec',
					title: '规格',
					width: 100
				}
			]
		],
		onLoadSuccess: function () {
			return false;
		}
	});
	
	InitDictVal();
}
function InitDictVal(){
	$('#startTime').timespinner('setValue', '00:00:00');
	$('#endTime').timespinner('setValue', '23:59:59');
	PHA.SetComboVal('locId', PHA_COM.VAR.locId);
}

// 初始化 - 表格
function InitGridBaseLogTotal() {
	var columns = [[{
				field: 'inci',
				title: '库存项Id',
				width: 100,
				hidden: true
			}, {
				field: 'inciCode',
				title: '药品代码',
				width: 140
			}, {
				field: 'inciDesc',
				title: '药品名称',
				width: 200
			}, {
				field: 'inciSpec',
				title: '规格',
				width: 100
			}, {
				field: 'phcpoDesc',
				title: '管制分类',
				width: 100
			}, {
				field: 'startQty',
				title: '期初数量',
				width: 90,
				align: 'right'
			}, {
				field: 'plusQty',
				title: '增加数量',
				width: 90,
				align: 'right',
				formatter: function (value, rowData, rowIndex) {
					return '<label style="color:green;">' + value + '</label>';
				}
			}, {
				field: 'minusQty',
				title: '减少数量',
				width: 90,
				align: 'right',
				formatter: function (value, rowData, rowIndex) {
					return '<label style="color:red;">' + value + '</label>';
				}
			}, {
				field: 'endQty',
				title: '结余数量',
				width: 90,
				align: 'right'
			}, {
				field: 'displayUomDesc',
				title: '单位',
				width: 90
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			ClassName: 'PHA.IN.NarcBaseLog.Query',
			QueryName: 'BaseLogTotal'
		},
		fitColumns: false,
		border: false,
		rownumbers: false,
		columns: columns,
		pagination: true,
		singleSelect: true,
		toolbar: '#gridBaseLogTotalBar',
		onSelect: function (rowIndex, rowData) {
			QueryBaseLogDetail();
		},
		onLoadSuccess: function (data) {
			$('#gridBaseLogDetail').datagrid('loadData', []);
		}
	};
	PHA.Grid('gridBaseLogTotal', dataGridOption);
}

// 初始化 - 表格
function InitGridBaseLogDetail() {
	var columns = [[{
				field: 'incib',
				title: '批次Id',
				width: 100,
				hidden: true
			}, {
				field: 'pinbl',
				title: '操作Id',
				width: 100,
				hidden: true
			}, {
				field: 'operDate',
				title: '操作日期',
				width: 95
			}, {
				field: 'operTime',
				title: '操作时间',
				width: 75
			}, {
				field: 'operUser',
				title: '操作人',
				width: 100
			}, {
				field: 'inciDesc',
				title: '药品名称',
				width: 195
			}, {
				field: 'batNo',
				title: '批号',
				width: 90
			}, {
				field: 'expDate',
				title: '效期',
				width: 90
			}, {
				field: 'preQty',
				title: '期初数量(批)',
				width: 95,
				align: 'right'
			}, {
				field: 'preSumQty',
				title: '期初数量(总)',
				width: 95,
				align: 'right'
			}, {
				field: 'preUom',
				title: '单位',
				width: 60
			}, {
				field: 'qty',
				title: '业务数量',
				width: 80,
				align: 'right',
				formatter: function (value, rowData, rowIndex) {
					if (value < 0) {
						return '<label style="color:red;">' + value + '</label>';
					} else {
						return '<label style="color:green;">' + value + '</label>';
					}
				}
			}, {
				field: 'uom',
				title: '单位',
				width: 60
			}, {
				field: 'retQty',
				title: '结余数量(批)',
				width: 95,
				align: 'right'
			}, {
				field: 'retSumQty',
				title: '结余数量(总)',
				width: 95,
				align: 'right'
			}, {
				field: 'retUom',
				title: '单位',
				width: 60
			}, {
				field: 'note',
				title: '备注',
				width: 120
			}, {
				field: 'vendDesc',
				title: '经营企业',
				width: 140
			}, {
				field: 'manfName',
				title: '生产企业',
				width: 140
			}, {
				field: 'type',
				title: '业务类型',
				width: 80,
				hidden: true
			}, {
				field: 'pointer',
				title: '业务ID',
				width: 80,
				hidden: true
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			ClassName: 'PHA.IN.NarcBaseLog.Query',
			QueryName: 'BaseLogDetail'
		},
		fitColumns: false,
		border: false,
		rownumbers: false,
		columns: columns,
		pagination: true,
		singleSelect: true,
		toolbar: [],
		onSelect: function (rowIndex, rowData) {},
		onLoadSuccess: function (data) {}
	};
	PHA.Grid('gridBaseLogDetail', dataGridOption);
}

function QueryBaseLogTotal(){
	var formDataArr = PHA.DomData("#gridBaseLogTotalBar", {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return null;
	}
	var formData = formDataArr[0];
	
	$('#gridBaseLogTotal').datagrid('options').url = $URL;
	$('#gridBaseLogTotal').datagrid('query', {
		pJsonStr: JSON.stringify(formData)
	});
}

function QueryBaseLogDetail(){
	var selRow = $('#gridBaseLogTotal').datagrid('getSelected');
	if (selRow == null) {
		return;
	}
	var inci = selRow.inci;
	var formDataArr = PHA.DomData("#gridBaseLogTotalBar", {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return null;
	}
	var formData = formDataArr[0];
	formData.inci = inci;
	
	$('#gridBaseLogDetail').datagrid('options').url = $URL;
	$('#gridBaseLogDetail').datagrid('query', {
		pJsonStr: JSON.stringify(formData)
	});
}

function Clear(){
	var formDataArr = PHA.DomData("#gridBaseLogTotalBar", {
		doType: 'clear'
	});
	$('#startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Com.StDate']));
	$('#endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Com.EdDate']));
	PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
	$('#gridBaseLogTotal').datagrid('loadData', []);
	$('#gridBaseLogDetail').datagrid('loadData', []);
	InitDictVal();
}

function InitConfig() {
	$.cm({
		ClassName: "PHA.IN.Narc.Com",
		MethodName: "GetConfigParams",
		InputStr: PHA_COM.Session.ALL
	}, function(retJson) {
		// 传递给全局
		PHA_COM.VAR.CONFIG = retJson;
		$('#startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Com.StDate']));
		$('#endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Com.EdDate']));
		PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
	}, function(error){
		console.dir(error);
		alert(error.responseText);
	});
}