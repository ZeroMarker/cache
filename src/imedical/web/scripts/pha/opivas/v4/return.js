/**
 * 名称:	 门诊配液系统-配液退药
 * 编写人:	 yunhaibao
 * 编写日期: 2019-06-18
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
		PHA.Confirm('温馨提示', '您确认退药吗?', function () {  // @translate
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
				title: '登记号',
				width: 100
			}, {
				field: 'patName',
				title: '姓名',
				width: 80
			}, {
				field: 'reqDateTimeStr',
				title: '申请时间',
				width: 155
			}, {
				field: 'reqUserStr',
				title: '申请人',
				width: 100
			}, {
				field: 'prescNoStr',
				title: '处方号',
				width: 125
			}, {
				field: 'mOeori',
				title: '主医嘱ID',
				width: 100
			}, {
				field: 'reqIdStr',
				title: '申请单Id串',
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
				title: '打包',
				width: 45,
				align: 'center',
				formatter: PHA_OPIVAS_COM.Grid.Formatter.YesNo,
				styler: PHA_OPIVAS_COM.Grid.Styler.Pack
			}, {
				field: 'doseDateTime',
				title: '用药时间',
				width: 160
			}, {
				field: 'oeoriSign',
				title: '组',
				width: 30,
				formatter: PHA_OPIVAS_COM.Grid.Formatter.OeoriSign
			}, {
				field: 'inciDesc',
				// width: 200, // UI评审要求固定 TODO
				title: '<div style="width:200px">' + $g('医嘱名称') + '</div>'
			}, {
				field: 'reqQty',
				title: '数量',
				width: 50
			}, {
				field: 'uomDesc',
				title: '单位',
				width: 50
			}, {
				field: 'retReasonDesc',
				title: '退药原因',
				width: 100
			}, {
				field: 'mDspId',
				title: 'mDspId',
				width: 100,
				hidden: true
			}, {
				field: 'phdItmLbId',
				title: '发药孙表ID',
				width: 100,
				hidden: true
			}, {
				field: 'dspSubId',
				title: '打包子表ID',
				width: 100,
				hidden: true
			}, {
				field: 'reqItmId',
				title: '申请明细ID',
				width: 80,
				hidden: false
			}, {
				field: 'retQty',
				title: '已退数量',
				width: 80
			}, {
				field: 'canRetFlag',
				title: '允许退药',
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
			msg: '请输入【登记号】后查询',  // @translate
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
			msg: '请先选择记录',  // @translate
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
			PHA.Alert('提示', saveInfo, 'warning');
		} else {
			PHA.Popover({
				msg: '退药成功,退费后将不能再次退药',  // @translate
				type: 'success'
			});
		}
		Query();
	});
}
/**
 *  清屏
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
