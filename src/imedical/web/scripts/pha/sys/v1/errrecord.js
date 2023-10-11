/**
 * ����:	 ҩ������-ϵͳ����-������־��ѯ
 * ��д��:	 yunhaibao
 * ��д����: 2019-03-15~
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
				Description: 'ȫ��'
			}, {
				RowId: 'PC',
				Description: 'PC��'
			}, {
				RowId: 'MOB',
				Description: '�ƶ���'
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

// ��� - ��Ʒ��
function InitGridErrRecord() {
	var columns = [
		[{
				field: 'errId',
				title: 'errId',
				width: 75,
				hidden: true
			}, {
				field: 'errDate',
				title: '����',
				width: 95,
				sortable: true
			}, {
				field: 'errTime',
				title: 'ʱ��',
				width: 75,
				sortable: true
			}, {
				field: 'appName',
				title: '������ģ��',
				width: 120
			}, {
				field: 'errInfo',
				title: '������Ϣ',
				width: 400,
				editor: {
					type: 'validatebox'
				}
			}, {
				field: 'keyValue',
				title: '��������',
				width: 140
			}, {
				field: 'errTrigger',
				title: '�������',
				width: 100
			}, {
				field: 'exceptionsStackDetail',
				title: '��ջ��Ϣ',
				width: 70,
				align: 'center',
				formatter: function (value, rowData, rowIndex) {
					return LOG_COM.IconBtn('search.png', 'OpenStackInfoWin', rowIndex, '����鿴��ջ��ϸ��Ϣ');
				}
			}, {
				field: 'userName',
				title: '�û�',
				width: 105
			}, {
				field: 'locDesc',
				title: '��¼����',
				width: 120
			}, {
				field: 'groupDesc',
				title: '��¼��ȫ��',
				width: 120
			}, {
				field: 'ip',
				title: 'IP��ַ',
				width: 130
			}, {
				field: 'browser',
				title: '�������Ϣ',
				width: 300,
				editor: {
					type: 'validatebox'
				}
			}, {
				field: 'pageName',
				title: 'ҳ����Ϣ',
				width: 120,
				editor: {
					type: 'validatebox'
				}
			}, {
				field: 'exceptionName',
				title: '�쳣����',
				width: 100,
				editor: {
					type: 'validatebox'
				}
			}, {
				field: 'exceptionType',
				title: '�쳣����',
				width: 100,
				editor: {
					type: 'validatebox'
				}
			}, {
				field: 'appVersion',
				title: 'app�汾',
				width: 90,
				editor: {
					type: 'validatebox'
				}
			}, {
				field: 'OSVersion',
				title: 'OS�汾',
				width: 90,
				editor: {
					type: 'validatebox'
				}
			}, {
				field: 'deviceModel',
				title: '�豸Model',
				width: 100,
				editor: {
					type: 'validatebox'
				}
			}, {
				field: 'deviceID',
				title: '�豸ID',
				width: 100,
				editor: {
					type: 'validatebox'
				}
			}, {
				field: 'netWorkType',
				title: '��������',
				width: 90,
				editor: {
					type: 'validatebox'
				}
			}, {
				field: 'memoryInfo',
				title: '�ڴ���Ϣ',
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

// �¼�
function InitEvents() {
	$('#btnFind').on('click', Query);
	$('#btnClean').on('click', Clean);
	
	$('#QText').on('keydown', function(e){
		if (e.keyCode == 13) {
			Query();
		}
	});
}

// ��ѯ
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

//  ����
function Clean(){
	$('#startDate').datebox('setValue', '');
	$('#endDate').datebox('setValue', '');
	$('#fromType').combobox('setValue', '');
	$('#QText').val('');
	$('#gridErrRecord').datagrid('clear');
	InitDictVal();
}

// ��ջ��Ϣ����
function OpenStackInfoWin(rowIndex) {
	var rowsData = $('#gridErrRecord').datagrid('getRows');
	var rowData = rowsData[rowIndex];

	LOG_COM.StackInfoWin({
		stackInfo: '[' + rowData.errInfo + ']; ' + rowData.exceptionsStackDetail
	});
}
