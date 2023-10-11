/**
 * 名称:	 毒麻药品管理 - 交接班查询
 * 编写人:	 Huxt
 * 编写日期: 2021-08-10
 * csp:      pha.in.v1.narchandfind.csp
 * js:       pha/in/v1/narchandfind.js
 */

PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = '药库';
PHA_COM.App.Csp = 'pha.in.v1.narchandfind.csp';
PHA_COM.App.Name = $g('交接班查询');
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
		height: 0.55
	});
	if (!PHA_COM.IsTabsMenu()){
		var pOpts = $('#panelNarcHand').panel('options');
		$('#panelNarcHand').panel('setTitle', PHA_COM.App.Name + ' - ' + pOpts.title);
	}
	
	InitDict();
	InitGridNarcHand();
	InitGridNarcHandItm();
	InitEvents();
	InitConfig();
});

function InitEvents(){
	$('#btnFind').on('click', QueryNarcHand);
	$('#btnClear').on('click', Clear);
}

function InitDict(){
	PHA.ComboBox('locId', {
		placeholder: '科室...',
		disabled: true,
		url: PHA_STORE.CTLoc().url
	});
	PHA.ComboBox("status", {
		placeholder: '交接单状态...',
		data: [
			{RowId:'10', Description: $g('保存')},
			{RowId:'20', Description: $g('完成')}
		],
		editable: true,
		panelHeight: 'auto'
	});
	InitDictVal();
}
function InitDictVal(){
	PHA.SetComboVal('locId', PHA_COM.VAR.locId);
}

// 初始化 - 表格
function InitGridNarcHand() {
	var columns = [[{
				field: "pinh",
				title: 'pinh',
				width: 80,
				hidden: true
			}, {
				field: 'handNo',
				title: '交接单号',
				width: 185
			}, {
				field: "stTime",
				title: '开始时间',
				width: 150,
				formatter: function(value ,rowData, rowIndex){
					return rowData.startDate + ' ' + rowData.startTime;
				}
			}, {
				field: "edTime",
				title: '截止时间',
				width: 150,
				formatter: function(value ,rowData, rowIndex){
					return rowData.endDate + ' ' + rowData.endTime;
				}
			}, {
				field: "ctTime",
				title: '创建时间',
				width: 150,
				formatter: function(value ,rowData, rowIndex){
					return rowData.createDate + ' ' + rowData.createTime;
				}
			}, {
				field: "createUserName",
				title: '创建人',
				width: 100
			}, {
				field: 'locDesc',
				title: '科室',
				width: 100
			}, {
				field: 'remarks',
				title: '备注',
				width: 110
			}, {
				field: 'statusDesc',
				title: '状态',
				width: 60
			}, {
				field: 'fromUserName',
				title: '交班人',
				width: 80
			}, {
				field: 'toUserName',
				title: '接班人',
				width: 80
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			ClassName: 'PHA.IN.NarcHand.Query',
			QueryName: 'NarcHand'
		},
		fitColumns: false,
		border: false,
		rownumbers: false,
		columns: columns,
		pagination: true,
		singleSelect: true,
		toolbar: '#gridNarcHandBar',
		onSelect: function (rowIndex, rowData) {
			QueryNarcHandItm();
		},
		onLoadSuccess: function (data) {
			$('#gridNarcHandItm').datagrid('loadData', []);
		}
	};
	PHA.Grid('gridNarcHand', dataGridOption);
}

// 初始化 - 表格
function InitGridNarcHandItm() {
	var columns = [[{
				field: "incib",
				title: 'incib',
				width: 80,
				hidden: true
			}, {
				field: "locId",
				title: 'locId',
				width: 80,
				hidden: true
			}, {
				field: 'inciCode',
				title: '药品代码',
				width: 120
			}, {
				field: "inciDesc",
				title: '药品名称',
				width: 180
			}, {
				field: "inciSpec",
				title: '规格',
				width: 100
			}, {
				field: 'batNo',
				title: '批号',
				width: 110
			}, {
				field: 'uomId',
				title: '单位ID',
				width: 60,
				hidden:true
			}, {
				field: 'uomDesc',
				title: '单位',
				width: 60
			}, {
				field: 'lastEdQty',
				title: '上次交接数量',
				width: 100,
				align: 'right'
			}, {
				field: 'startQty',
				title: '初始库存',
				width: 80,
				align: 'right'
			}, {
				field: 'plusQty',
				title: '增加数量',
				width: 80,
				align: 'right',
				formatter: function (value, rowData, rowIndex) {
					return '<label style="color:green;">' + value + '</label>';
				}
			}, {
				field: 'minusQty',
				title: '减少数量',
				width: 80,
				align: 'right',
				formatter: function (value, rowData, rowIndex) {
					return '<label style="color:red;">' + value + '</label>';
				}
			}, {
				field: 'endQty',
				title: '当前库存',
				width: 80,
				align: 'right'
			}, {
				field: 'fromUserName',
				title: '交班人',
				width: 110
			}, {
				field: 'toUserName',
				title: '接班人',
				width: 110
			}, {
				field: 'remarks',
				title: '备注',
				width: 180
			}, {
				field: 'manfName',
				title: '生产企业',
				width: 180
			}, {
				field: 'vendDesc',
				title: '经营企业',
				width: 180
			}, {
				field: 'expDate',
				title: '效期',
				width: 90
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			ClassName: 'PHA.IN.NarcHand.Query',
			QueryName: 'NarcHandItm'
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
	PHA.Grid('gridNarcHandItm', dataGridOption);
}

function QueryNarcHand(){
	var formDataArr = PHA.DomData("#gridNarcHandBar", {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return null;
	}
	var formData = formDataArr[0];
	
	$('#gridNarcHand').datagrid('options').url = $URL;
	$('#gridNarcHand').datagrid('query', {
		pJsonStr: JSON.stringify(formData)
	});
}

function QueryNarcHandItm(){
	var selRow = $('#gridNarcHand').datagrid('getSelected');
	if (selRow == null) {
		return;
	}
	
	$('#gridNarcHandItm').datagrid('options').url = $URL;
	$('#gridNarcHandItm').datagrid('query', {
		pJsonStr: JSON.stringify(selRow)
	});
}

function Clear(){
	var formDataArr = PHA.DomData("#gridNarcHandBar", {
		doType: 'clear'
	});
	$('#startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Hand.StDate']));
	$('#endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Hand.EdDate']));
	$('#gridNarcHand').datagrid('loadData', []);
	$('#gridNarcHandItm').datagrid('loadData', []);
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
		$('#startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Hand.StDate']));
		$('#endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Hand.EdDate']));
		PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
	}, function(error) {
		console.dir(error);
		alert(error.responseText);
	});
}