/**
 * ����:	 ����ҩƷ���� - ���Ӱ��ѯ
 * ��д��:	 Huxt
 * ��д����: 2021-08-10
 * csp:      pha.in.v1.narchandfind.csp
 * js:       pha/in/v1/narchandfind.js
 */

PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = 'ҩ��';
PHA_COM.App.Csp = 'pha.in.v1.narchandfind.csp';
PHA_COM.App.Name = $g('���Ӱ��ѯ');
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
		placeholder: '����...',
		disabled: true,
		url: PHA_STORE.CTLoc().url
	});
	PHA.ComboBox("status", {
		placeholder: '���ӵ�״̬...',
		data: [
			{RowId:'10', Description: $g('����')},
			{RowId:'20', Description: $g('���')}
		],
		editable: true,
		panelHeight: 'auto'
	});
	InitDictVal();
}
function InitDictVal(){
	PHA.SetComboVal('locId', PHA_COM.VAR.locId);
}

// ��ʼ�� - ���
function InitGridNarcHand() {
	var columns = [[{
				field: "pinh",
				title: 'pinh',
				width: 80,
				hidden: true
			}, {
				field: 'handNo',
				title: '���ӵ���',
				width: 185
			}, {
				field: "stTime",
				title: '��ʼʱ��',
				width: 150,
				formatter: function(value ,rowData, rowIndex){
					return rowData.startDate + ' ' + rowData.startTime;
				}
			}, {
				field: "edTime",
				title: '��ֹʱ��',
				width: 150,
				formatter: function(value ,rowData, rowIndex){
					return rowData.endDate + ' ' + rowData.endTime;
				}
			}, {
				field: "ctTime",
				title: '����ʱ��',
				width: 150,
				formatter: function(value ,rowData, rowIndex){
					return rowData.createDate + ' ' + rowData.createTime;
				}
			}, {
				field: "createUserName",
				title: '������',
				width: 100
			}, {
				field: 'locDesc',
				title: '����',
				width: 100
			}, {
				field: 'remarks',
				title: '��ע',
				width: 110
			}, {
				field: 'statusDesc',
				title: '״̬',
				width: 60
			}, {
				field: 'fromUserName',
				title: '������',
				width: 80
			}, {
				field: 'toUserName',
				title: '�Ӱ���',
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

// ��ʼ�� - ���
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
				title: 'ҩƷ����',
				width: 120
			}, {
				field: "inciDesc",
				title: 'ҩƷ����',
				width: 180
			}, {
				field: "inciSpec",
				title: '���',
				width: 100
			}, {
				field: 'batNo',
				title: '����',
				width: 110
			}, {
				field: 'uomId',
				title: '��λID',
				width: 60,
				hidden:true
			}, {
				field: 'uomDesc',
				title: '��λ',
				width: 60
			}, {
				field: 'lastEdQty',
				title: '�ϴν�������',
				width: 100,
				align: 'right'
			}, {
				field: 'startQty',
				title: '��ʼ���',
				width: 80,
				align: 'right'
			}, {
				field: 'plusQty',
				title: '��������',
				width: 80,
				align: 'right',
				formatter: function (value, rowData, rowIndex) {
					return '<label style="color:green;">' + value + '</label>';
				}
			}, {
				field: 'minusQty',
				title: '��������',
				width: 80,
				align: 'right',
				formatter: function (value, rowData, rowIndex) {
					return '<label style="color:red;">' + value + '</label>';
				}
			}, {
				field: 'endQty',
				title: '��ǰ���',
				width: 80,
				align: 'right'
			}, {
				field: 'fromUserName',
				title: '������',
				width: 110
			}, {
				field: 'toUserName',
				title: '�Ӱ���',
				width: 110
			}, {
				field: 'remarks',
				title: '��ע',
				width: 180
			}, {
				field: 'manfName',
				title: '������ҵ',
				width: 180
			}, {
				field: 'vendDesc',
				title: '��Ӫ��ҵ',
				width: 180
			}, {
				field: 'expDate',
				title: 'Ч��',
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
		// ���ݸ�ȫ��
		PHA_COM.VAR.CONFIG = retJson;
		$('#startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Hand.StDate']));
		$('#endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Hand.EdDate']));
		PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
	}, function(error) {
		console.dir(error);
		alert(error.responseText);
	});
}