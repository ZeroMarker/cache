/**
 * ģ��: ҩ�� - ��ҩ����������Ƭת��ά��
 * csp:  csp/pha.in.v3.phcconvert.csp
 * js:   scripts/pha/in/v3/phcconvert.js
 * Huxt 2023-02-07
 */
var HospId = session['LOGON.HOSPID'];
$(function () {
	InitHospCombo(); // ����ҽԺ

	InitDict();
	InitEvent();
	InitGridPhcConvert();
});

/**
 * ��ʼ���¼�
 */
function InitEvent() {
	$('#btnFind').on('click', Query);
	$('#btnClear').on('click', Clear);

	$('#btnAdd').on('click', function () {
		BeforeEdit('add');
	});
	$('#btnUpdate').on('click', function () {
		BeforeEdit('update');
	});
	$('#btnDelete').on('click', Delete);
	$('#btnExport').on('click', Export);
	$('#btnImport').on('click', Import);
	$("#btn-transfer").linkbutton('enable');
}

/**
 * ��ʼ���ֵ�
 */
function InitDict() {
	// ��������Store
	var typeOpts = {
		url: PHA_STORE.Url + 'ClassName=PHA.IN.PhcConvert.Query&QueryName=CMPrescType',
		width: 240,
		onBeforeLoad: function (params) {
			params.pJsonStr = JSON.stringify({
				hospID: HospId
			})
		}
	}
	// ����ҩѧ��Store
	var phcOpts = {
		url: PHA_STORE.Url + 'ClassName=PHA.IN.PhcConvert.Query&QueryName=PHCDrgMast',
		idField: 'phcId',
		textField: 'phcDesc',
		width: 240,
		panelWidth: 420,
		mode: 'remote',
		columns: [[{
					field: 'phcId',
					title: 'phcId',
					width: 100,
					hidden: true
				}, {
					field: 'phcCode',
					title: '����',
					width: 120
				}, {
					field: 'phcDesc',
					title: '����',
					width: 300
				}
			]
		],
		fitColumns: true
	}

	// ��������
	PHA.ComboBox('prescType', $.extend({}, typeOpts, {
		onSelect: function (rowData, rowIndex) {
			Query();
		}
	}));

	// ҩѧ������
	PHA.ComboGrid('phcId', $.extend({}, phcOpts, {
		onSelect: function (rowData, rowIndex) {
			Query();
		},
		onBeforeLoad: function (params) {
			var prescTypeId = $('#prescType').combobox('getValue') || '';
			params.pJsonStr = JSON.stringify({
				hospID: HospId,
				prescTypeId: prescTypeId,
				alias: params.q
			})
		}
	}));

	// ���� - ����
	PHA.ComboBox('fromType', $.extend({}, typeOpts,{
		onSelect: function (rowData, rowIndex) {
			$("#fromPhcId").combogrid("clear")
		}
	}));
	
	// ���� - ҩƷ
	PHA.ComboGrid('fromPhcId', $.extend({}, phcOpts, {
		onBeforeLoad: function (params) {
			var prescTypeId = $('#fromType').combobox('getValue') || '';
			params.pJsonStr = JSON.stringify({
				hospID: HospId,
				prescTypeId: prescTypeId,
				alias: params.q,
				phcId: params.phcId || '',
			})
		},
		onShowPanel: function(){
			var cmg = $.data(this, 'combogrid');
			if (cmg) {
				$(cmg.grid).datagrid('load', {
					q: '',
					phcId: ($('#fromPhcId').combogrid('getValue') || '')
				});
			}
		}
	}));
	
	// ���� - ת������
	PHA.ComboBox('toType', $.extend({}, typeOpts,{
		onSelect: function (rowData, rowIndex) {
			$("#toPhcId").combogrid("clear")
		}
	}
	));
	
	// ���� - ת��ҩƷ
	PHA.ComboGrid('toPhcId', $.extend({}, phcOpts, {
		onBeforeLoad: function (params) {
			var prescTypeId = $('#toType').combobox('getValue') || '';
			params.pJsonStr = JSON.stringify({
				hospID: HospId,
				prescTypeId: prescTypeId,
				alias: params.q,
				phcId: params.phcId || '',
			})
		},
		onShowPanel: function() {
			var cmg = $.data(this, 'combogrid');
			if (cmg) {
				$(cmg.grid).datagrid('load', {
					q: '',
					phcId: ($('#toPhcId').combogrid('getValue') || '')
				});
			}
		}
	}));
}

/**
 * ��ʼ�����
 */
function InitGridPhcConvert() {
	var columns = [[{
				field: 'pcId',
				title: 'pcId',
				width: 100,
				hidden: true
			}, {
				field: 'fromTypeDesc',
				title: '����',
				width: 100
			}, {
				field: 'fromPhcCode',
				title: 'ҩƷ����',
				width: 120
			}, {
				field: 'fromPhcDesc',
				title: 'ҩƷ����',
				width: 300
			}, {
				field: 'fromNum',
				title: '����',
				width: 100,
				align: 'right'
			}, {
				field: 'toTypeDesc',
				title: 'ת������',
				width: 100
			}, {
				field: 'toPhcCode',
				title: 'ת��ҩƷ����',
				width: 120
			}, {
				field: 'toPhcDesc',
				title: 'ת��ҩƷ����',
				width: 300
			}, {
				field: 'toNum',
				title: 'ת������',
				align: 'right',
				width: 100
			}
		]
	];
	var gridOptions = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.PhcConvert.Query',
			QueryName: 'PhcConvert',
			pJsonStr: JSON.stringify({
				hospID: HospId
			})
		},
		toolbar: '#gridPhcConvertBar',
		columns: columns,
		rownumbers: false,
		singleSelect: true,
		onDblClickRow: function (rowIndex, rowData) {
			BeforeEdit('update');
		},
		onSelect: function (rowIndex, rowData) {
			$(this).datagrid('options').seletedIndex = rowIndex;
		},
		onLoadSuccess: function(data) {
			if (data && data.total > 0) {
				var seletedIndex = $(this).datagrid('options').seletedIndex;
				if (seletedIndex >= 0) {
					$(this).datagrid('selectRow', seletedIndex);
				} else {
					$(this).datagrid('selectRow', 0);
				}
			}
		}
	}
	PHA.Grid('gridPhcConvert', gridOptions);
}

/**
 * ��ѯ���
 */
function Query() {
	var prescType = $('#prescType').combobox('getValue') || '';
	var phcId = $('#phcId').combobox('getValue') || '';
	$('#gridPhcConvert').datagrid('query', {
		ClassName: 'PHA.IN.PhcConvert.Query',
		QueryName: 'PhcConvert',
		pJsonStr: JSON.stringify({
			hospID: HospId,
			prescType: prescType,
			phcId: phcId,
			pcId: ''
		})
	});
}

/**
 * ά��������
 */
function BeforeEdit(action) {
	if (action == 'update') {
		var seletctedRow = $('#gridPhcConvert').datagrid('getSelected');
		if (seletctedRow == null) {
			PHA.Popover({
				type: 'alert',
				msg: '��ѡ����Ҫ�޸ĵ���'
			});
			return;
		}
	}

	EditShow({
		title: $g('��ҩ��������ת��ϵ��') + (action == 'update' ? $g('�޸�') : $g('����')),
		iconCls: action == 'update' ? 'icon-w-edit' : 'icon-w-add',
		action: action
	});
}

/**
 * �༭����
 */
function EditShow(_options) {
	$('#maintainWin').dialog($.extend({}, {
		title: 'ά��',
		width: 715,
		// height: 200,
		modal: true,
		closed: true,
		minimizable: false,
		maximizable: false,
		collapsible: false,
		onBeforeClose: function () {
			ClearWin();
		},
		buttons: [
			{
				text: '����',
				handler: function () {
					Save();
				}
			}, {
				text: '�ر�',
				handler: function () {
					$('#maintainWin').dialog('close');
				}
			}
		]
	}, _options)).dialog('open');

	if (_options.action == 'update') {
		var gridSelected = $('#gridPhcConvert').datagrid('getSelected');
		var pcId = gridSelected.pcId;

		$.cm({
			ClassName: 'PHA.IN.PhcConvert.Query',
			QueryName: 'PhcConvert',
			pJsonStr: JSON.stringify({
				hospID: HospId,
				pcId: pcId
			}),
			ResultSetType: 'Array'
		}, function (retJson) {
			retJson[0].fromPhcId = {
				phcId: retJson[0].fromPhcId,
				phcDesc: retJson[0].fromPhcDesc
			}
			retJson[0].toPhcId = {
				phcId: retJson[0].toPhcId,
				phcDesc: retJson[0].toPhcDesc
			}
			PHA.SetVals(retJson);
		});
	} else {
		ClearWin();
	}
}

/**
 * ��������
 */
function Save() {
	// ��ȡ����
	var selectedRow = $('#gridPhcConvert').datagrid('getSelected');
	var pcId = '';
	if ($('#maintainWin').dialog('options').action == 'update') {
		pcId = selectedRow.pcId;
	} else {
		pcId = '';
	}
	var pJsonArr = PHA.GetVals([
		'fromType',
		'fromPhcId',
		'fromNum',
		'toType',
		'toPhcId',
		'toNum'
	], 'Json');
	if (!pJsonArr || pJsonArr.length == 0) {
		return;
	}
	var pJson = pJsonArr[0];
	pJson.hospID = HospId;
	pJson.pcId = pcId;

	// ��֤����
	if (parseFloat(pJson.fromNum) <= 0) {
		PHA.Popover({
			type: 'alert',
			msg: '��������С�ڻ����0'
		});
		return;
	}
	if (parseFloat(pJson.toNum) <= 0) {
		PHA.Popover({
			type: 'alert',
			msg: 'ת����������С�ڻ����0'
		});
		return;
	}
	if (pJson.fromPhcId == $('#fromPhcId').combogrid('getText')) {
		PHA.Popover({
			type: 'alert',
			msg: '��ѡ��ҩƷ'
		});
		return;
	}
	if (pJson.toPhcId == $('#toPhcId').combogrid('getText')) {
		PHA.Popover({
			type: 'alert',
			msg: '��ѡ��ת��ҩƷ'
		});
		return;
	}

	// ��������
	$.m({
		ClassName: 'PHA.IN.PhcConvert.Save',
		MethodName: 'SavePhcConvert',
		pJsonStr: JSON.stringify(pJson),
		hospID: HospId
	}, function (retStr) {
		var retArr = retStr.split('^');
		if (retArr[0] > 0) {
			PHA.Popover({
				type: 'success',
				msg: '����ɹ�'
			});
			$('#maintainWin').dialog('close');
			Query();
		} else {
			PHA.Alert('��ܰ��ʾ', '����ʧ��: ' + retStr, 'error');
		}
	});
}

/**
 * ɾ��
 */
function Delete() {
	var seletctedRow = $('#gridPhcConvert').datagrid('getSelected');
	if (seletctedRow == null) {
		PHA.Popover({
			type: 'alert',
			msg: '��ѡ����Ҫɾ������'
		});
		return;
	}
	PHA.Confirm('��ܰ��ʾ', '��ȷ��ɾ����?', function () {
		var pcId = seletctedRow.pcId;
		$.m({
			ClassName: 'PHA.IN.PhcConvert.Save',
			MethodName: 'DeleteDHCPhcConvert',
			pcId: pcId,
			hospID: HospId
		}, function (retText) {
			if (retText == 0) {
				PHA.Popover({
					type: 'success',
					msg: 'ɾ���ɹ�'
				});
				Query();
			} else {
				PHA.Alert('��ܰ��ʾ', 'ɾ��ʧ��', 'error');
			}
		});
	});
}

/**
 * ����
 */
function Clear() {
	PHA.ClearVals([
		'prescType',
		'phcId'
	]);
	Query();
}
function ClearWin() {
	PHA.ClearVals([
		'fromType',
		'fromPhcId',
		'fromNum',
		'toType',
		'toPhcId',
		'toNum'
	]);
}

/**
 * ����
 */
function Export(){
	PHA_COM.ExportGrid('gridPhcConvert');
}

/**
 * ����
 */
function Import(){
	PHA_COM.ImportFile({
		suffixReg: /^(.xls)|(.xlsx)$/
	}, function(data){
		console.log(data);
	});
}

/**
 * ��Ժ��
 */
function InitHospCombo() {
	var genHospObj = PHA_COM.GenHospCombo({
		tableName: 'DHC_PhcConvert'
	});
	if (typeof genHospObj === 'object') {
		$('#_HospList').combogrid('options').onSelect = function (index, record) {
			NewHospId = record.HOSPRowId;
			if (NewHospId != HospId) {
				HospId = NewHospId;
				Clear();
				ClearWin();
				Query();
				InitDict();
			}
		};
	}
}
