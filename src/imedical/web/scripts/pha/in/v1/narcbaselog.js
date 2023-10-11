/*
 * ����:	 ����ҩƷ���� - ���һ���̨�˲�ѯ
 * ��д��:	 Huxt
 * ��д����: 2021-08-10
 * csp:      pha.in.v1.narcbaselog.csp
 * js:       pha/in/v1/narcbaselog.js
 */

PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = 'ҩ��';
PHA_COM.App.Csp = 'pha.in.v1.narcbaselog.csp';
PHA_COM.App.Name = $g('���ҿ�����̨��');
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
		placeholder: '����...',
		disabled: true,
		width: 200,
		url: PHA_STORE.CTLoc().url
	});
	PHA.ComboBox("poisonIdStr", {
		placeholder: '���Ʒ���...',
		width: 230,
		url: PHA_STORE.PHCPoison().url,
		multiple: true,
		rowStyle: 'checkbox',
		selectOnNavigation: false
	});
	PHA.ComboBox("qtyStatus", {
		placeholder: 'ҵ����...',
		width: 230,
		data: [
			{RowId:'0', Description: $g('����0')},
			{RowId:'1', Description: $g('������0')},
			{RowId:'2', Description: $g('����0')},
			{RowId:'3', Description: $g('С��0')}
		],
		editable: true,
		panelHeight: 'auto'
	});
	PHA.ComboGrid('inci', {
		width: 200,
		panelWidth: 450,
		placeholder: 'ҩƷ...',
		url: $URL + '?ClassName=PHA.IN.Narc.Com&QueryName=INCItm&HospId=' + session['LOGON.HOSPID'],
		idField: 'inci',
		textField: 'inciDesc',
		columns: [[{
					field: 'inci',
					title: '�����Id',
					width: 60,
					hidden: true
				}, {
					field: 'inciCode',
					title: '����',
					width: 120
				}, {
					field: 'inciDesc',
					title: '����',
					width: 200
				}, {
					field: 'inciSpec',
					title: '���',
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

// ��ʼ�� - ���
function InitGridBaseLogTotal() {
	var columns = [[{
				field: 'inci',
				title: '�����Id',
				width: 100,
				hidden: true
			}, {
				field: 'inciCode',
				title: 'ҩƷ����',
				width: 140
			}, {
				field: 'inciDesc',
				title: 'ҩƷ����',
				width: 200
			}, {
				field: 'inciSpec',
				title: '���',
				width: 100
			}, {
				field: 'phcpoDesc',
				title: '���Ʒ���',
				width: 100
			}, {
				field: 'startQty',
				title: '�ڳ�����',
				width: 90,
				align: 'right'
			}, {
				field: 'plusQty',
				title: '��������',
				width: 90,
				align: 'right',
				formatter: function (value, rowData, rowIndex) {
					return '<label style="color:green;">' + value + '</label>';
				}
			}, {
				field: 'minusQty',
				title: '��������',
				width: 90,
				align: 'right',
				formatter: function (value, rowData, rowIndex) {
					return '<label style="color:red;">' + value + '</label>';
				}
			}, {
				field: 'endQty',
				title: '��������',
				width: 90,
				align: 'right'
			}, {
				field: 'displayUomDesc',
				title: '��λ',
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

// ��ʼ�� - ���
function InitGridBaseLogDetail() {
	var columns = [[{
				field: 'incib',
				title: '����Id',
				width: 100,
				hidden: true
			}, {
				field: 'pinbl',
				title: '����Id',
				width: 100,
				hidden: true
			}, {
				field: 'operDate',
				title: '��������',
				width: 95
			}, {
				field: 'operTime',
				title: '����ʱ��',
				width: 75
			}, {
				field: 'operUser',
				title: '������',
				width: 100
			}, {
				field: 'inciDesc',
				title: 'ҩƷ����',
				width: 195
			}, {
				field: 'batNo',
				title: '����',
				width: 90
			}, {
				field: 'expDate',
				title: 'Ч��',
				width: 90
			}, {
				field: 'preQty',
				title: '�ڳ�����(��)',
				width: 95,
				align: 'right'
			}, {
				field: 'preSumQty',
				title: '�ڳ�����(��)',
				width: 95,
				align: 'right'
			}, {
				field: 'preUom',
				title: '��λ',
				width: 60
			}, {
				field: 'qty',
				title: 'ҵ������',
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
				title: '��λ',
				width: 60
			}, {
				field: 'retQty',
				title: '��������(��)',
				width: 95,
				align: 'right'
			}, {
				field: 'retSumQty',
				title: '��������(��)',
				width: 95,
				align: 'right'
			}, {
				field: 'retUom',
				title: '��λ',
				width: 60
			}, {
				field: 'note',
				title: '��ע',
				width: 120
			}, {
				field: 'vendDesc',
				title: '��Ӫ��ҵ',
				width: 140
			}, {
				field: 'manfName',
				title: '������ҵ',
				width: 140
			}, {
				field: 'type',
				title: 'ҵ������',
				width: 80,
				hidden: true
			}, {
				field: 'pointer',
				title: 'ҵ��ID',
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
		// ���ݸ�ȫ��
		PHA_COM.VAR.CONFIG = retJson;
		$('#startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Com.StDate']));
		$('#endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Com.EdDate']));
		PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
	}, function(error){
		console.dir(error);
		alert(error.responseText);
	});
}