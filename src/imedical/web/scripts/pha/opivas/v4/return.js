/**
 * ����:	 ������Һϵͳ-��Һ��ҩ
 * ��д��:	 yunhaibao
 * ��д����: 2019-06-18
 */
PHA_COM.App.Csp = 'pha.opivas.v4.return.csp';
RETURN_DEFAULT = [{
		conStDate: 't',
		conEdDate: 't'
	}
];
$(function () {
	InitDict();
	InitGridReq();
	InitGridReqItm();
	$('#btnFind').on('click', Query);
	$('#btnClean').on('click', Clean);
	$('#btnReturn').on('click', function () {
		PHA.Confirm('��ܰ��ʾ', '��ȷ����ҩ��?', function () {  // @translate
			Return();
		});
	});
	PHA.SetVals(RETURN_DEFAULT);
});

function InitDict() {
	PHA.DateBox('conStDate', {
		width: 150
	});
	PHA.DateBox('conEdDate', {
		width: 150
	});
	PHA_OPIVAS_COM.Bind.KeyDown.PatNo('conPatNo', Query);
}

function InitGridReq() {
	var columns = [
		[{
				field: 'patNo',
				title: '�ǼǺ�',
				width: 100
			}, {
				field: 'patName',
				title: '����',
				width: 80
			}, {
				field: 'reqDateTimeStr',
				title: '����ʱ��',
				width: 155
			}, {
				field: 'reqUserStr',
				title: '������',
				width: 100
			}, {
				field: 'prescNoStr',
				title: '������',
				width: 125
			}, {
				field: 'mOeori',
				title: '��ҽ��ID',
				width: 100
			}, {
				field: 'reqIdStr',
				title: '���뵥Id��',
				width: 75,
				hidden: true
			}
		]
	];
	var dataGridOption = {
		exportXls: false,
		url: $URL,
		queryParams: {
			ClassName: 'PHA.OPIVAS.Return.Query',
			QueryName: 'Request'
		},
		pagination: true,
		pageSize: 100,
		columns: columns,
		nowrap: false,
		singleSelect: true,
		toolbar: '#gridReqBar',
		onCheck: function (rowIndex, rowData) {},
		onUncheck: function (rowIndex, rowData) {},
		onSelect: function (rowIndex, rowData) {
			QueryItm();
		},
		onLoadSuccess: function (data) {
			QueryItm();
		},
		rowStyler: function (index, rowData) {
			return PHA_OPIVAS_COM.Grid.RowStyler.Person(index, rowData, 'patNo');
		}
	};
	PHA.Grid('gridReq', dataGridOption);
}

function InitGridReqItm() {
	var columns = [
		[{
				field: 'oeoreChk',
				checkbox: true
			}, {
				field: 'packFlag',
				title: '���',
				width: 45,
				align: 'center',
				formatter: PHA_OPIVAS_COM.Grid.Formatter.YesNo,
				styler: PHA_OPIVAS_COM.Grid.Styler.Pack
			}, {
				field: 'doseDateTime',
				title: '��ҩʱ��',
				width: 160
			}, {
				field: 'oeoriSign',
				title: '��',
				width: 30,
				formatter: PHA_OPIVAS_COM.Grid.Formatter.OeoriSign
			}, {
				field: 'inciDesc',
				// width: 200, // UI����Ҫ��̶� TODO
				title: '<div style="width:200px">' + $g('ҽ������') + '</div>'
			}, {
				field: 'reqQty',
				title: '����',
				width: 50
			}, {
				field: 'uomDesc',
				title: '��λ',
				width: 50
			}, {
				field: 'retReasonDesc',
				title: '��ҩԭ��',
				width: 100
			}, {
				field: 'mDspId',
				title: 'mDspId',
				width: 100,
				hidden: true
			}, {
				field: 'phdItmLbId',
				title: '��ҩ���ID',
				width: 100,
				hidden: true
			}, {
				field: 'dspSubId',
				title: '����ӱ�ID',
				width: 100,
				hidden: true
			}, {
				field: 'reqItmId',
				title: '������ϸID',
				width: 80,
				hidden: false
			}, {
				field: 'retQty',
				title: '��������',
				width: 80
			}, {
				field: 'canRetFlag',
				title: '������ҩ',
				width: 80,
				align: 'center',
				formatter: PHA_OPIVAS_COM.Grid.Formatter.YesNo
			}
		]
	];
	var dataGridOption = {
		exportXls: false,
		url: 'pha.opivas.v4.broker.csp',
		queryParams: {
			ClassName: 'PHA.OPIVAS.Return.Query',
			QueryName: 'RequestItm',
			GrpField: 'mDspId'
		},
		pagination: true,
		pageSize: 100,
		columns: columns,
		nowrap: true,
		singleSelect: false,
		checkOnSelect: false,
		gridSave: false,
		toolbar: '#gridReqItmBar',
		onCheck: function (rowIndex, rowData) {
			if ($(this).datagrid('options').checking == true) {
				return;
			}
			$(this).datagrid('options').checking = true;
			PHA_OPIVAS_COM.Grid.LinkCheck.Do({
				CurRowIndex: rowIndex,
				GridId: 'gridReqItm',
				Field: 'mDspId',
				Check: true,
				Value: rowData.mDspId
			});
			$(this).datagrid('options').checking = '';
		},
		onUncheck: function (rowIndex, rowData) {
			if ($(this).datagrid('options').checking == true) {
				return;
			}
			$(this).datagrid('options').checking = true;
			PHA_OPIVAS_COM.Grid.LinkCheck.Do({
				CurRowIndex: rowIndex,
				GridId: 'gridReqItm',
				Field: 'mDspId',
				Check: false,
				Value: rowData.mDspId
			});
			$(this).datagrid('options').checking = '';
		},
		onCheckAll: function (rows) {
			$.each(rows, function (index, row) {
				if (row.canRetFlag == 'N') {
					$('#gridReqItm').datagrid('uncheckRow', index);
				}
			});
		},
		onLoadSuccess: function (data) {
			$('#gridReqItm').datagrid('uncheckAll');
			$.each(data.rows, function (index, row) {
				var canRetFlag = row.canRetFlag;
				if (canRetFlag == 'N') {
					$('.datagrid-row[datagrid-row-index=' + index + "] input:checkbox[name='oeoreChk']")[0].disabled = true;
				}
			});
		},
		rowStyler: function (index, rowData) {
			return PHA_OPIVAS_COM.Grid.RowStyler.Person(index, rowData, 'mOeori');
		}
	};
	PHA.Grid('gridReqItm', dataGridOption);
}

/*****************************************************************/
function Query() {
	var valsStr = PHA_OPIVAS_COM.DomData('#qCondition', {
		doType: 'query',
		needId: 'Y'
	});
	if ($('#conPatNo').val() == '') {
		PHA.Popover({
			msg: '�����롾�ǼǺš����ѯ',  // @translate
			type: 'alert'
		});
		return;
	}
	$('#gridReq').datagrid('query', {
		InputStr: valsStr,
		Pid: ''
	});
}

function Return() {
	var chkDatas = $('#gridReqItm').datagrid('getChecked');
	if (chkDatas == '') {
		PHA.Popover({
			msg: '����ѡ���¼',  // @translate
			type: 'alert'
		});
		return;
	}
	PHA.Loading('Show');
	var reqItmIdArr = [];
	var dataLen = chkDatas.length;
	for (var i = 0; i < dataLen; i++) {
		var rowData = chkDatas[i];
		reqItmIdArr.push(rowData.reqItmId);
	}
	$.cm({
		ClassName: 'PHA.OPIVAS.Return.Save',
		MethodName: 'ExeRetReqMulti',
		ReqItmIdStr: reqItmIdArr.join('^'),
		LogonStr: PHA_COM.Session.ALL,
		dataType: 'text'
	}, function (saveRet) {
		PHA.Loading('Hide');
		var saveArr = saveRet.split('^');
		var saveVal = saveArr[0];
		var saveInfo = saveArr[1];
		if (saveVal < 0) {
			PHA.Alert('��ʾ', saveInfo, 'warning');
		} else {
			PHA.Popover({
				msg: '��ҩ�ɹ�,�˷Ѻ󽫲����ٴ���ҩ',  // @translate
				type: 'success'
			});
		}
		Query();
	});
}
/**
 *  ����
 */
function Clean() {
	PHA.DomData('#qCondition', {
		doType: 'clear'
	});
	$('#gridReq').datagrid('clear');
	$('#gridReqItm').datagrid('clear');
	PHA.SetVals(RETURN_DEFAULT);
}

function QueryItm() {
	var gridSelect = $('#gridReq').datagrid('getSelected') || '';
	var reqIdStr = '';
	if (gridSelect) {
		reqIdStr = $('#gridReq').datagrid('getSelected').reqIdStr;
	}
	$('#gridReqItm').datagrid('query', {
		ReqIdStr: reqIdStr
	});
}
