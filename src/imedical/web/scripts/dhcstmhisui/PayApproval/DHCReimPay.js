var GRToolBar, GRCm, GRGrid, ToolBar, ReimPayCm, ReimPayGrid;
var init = function() {
	var IngrLocParams = JSON.stringify(addSessionParams({
		Type: 'Login'
	}));
	var IngrLocBox = $HUI.combobox('#IngrLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + IngrLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$('#IngrLoc').combobox('setValue', gLocId);

	GRToolBar = [{
		text: '加入报支单',
		iconCls: 'icon-add',
		handler: function() {
			var ParamsObj = $UI.loopBlock('#PayConditions');
			var Main = JSON.stringify(ParamsObj);
			var Detail = GRGrid.getRowsData();
			if (Detail == '') {
				$UI.msg('error', '无入库退货单发票明细!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCReimPay',
				MethodName: 'Save',
				Main: Main,
				Detail: JSON.stringify(Detail)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.clearBlock('#PayConditions');
					$UI.clear(ReimPayGrid);
					$.cm({
						ClassName: 'web.DHCSTMHUI.DHCReimPay',
						MethodName: 'Select',
						RowId: jsonData.rowid
					}, function(jsonData) {
						$UI.fillBlock('#PayConditions', jsonData);
						Select();
						Clear();
					});
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	}
	];

	GRCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '入库(退货)RowId',
			field: 'Ingri',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '单号',
			field: 'GRNo',
			width: 200
		}, {
			title: '类型',
			field: 'Type',
			width: 80,
			saveCol: true,
			formatter: function(value, row, index) {
				if (value == 'G') {
					return '入库';
				} else {
					return '退货';
				}
			}
		}, {
			title: '物资RowId',
			field: 'Inci',
			width: 50,
			hidden: true
		}, {
			title: '代码',
			field: 'InciCode',
			width: 150
		}, {
			title: '描述',
			field: 'InciDesc',
			width: 200
		}, {
			title: '发票号',
			field: 'InvNo',
			saveCol: true,
			width: 100
		}, {
			title: '金额',
			field: 'RpAmt',
			width: 100,
			saveCol: true,
			align: 'right'
		}, {
			title: '供应商',
			field: 'VendorDesc',
			width: 200
		}
	]];

	GRGrid = $UI.datagrid('#GRGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCReimPay',
			QueryName: 'DHCING',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		toolbar: GRToolBar,
		columns: GRCm,
		showBar: true
	});

	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var Data = ReimPayGrid.getChangesData();
			if (Data === false) {	// 未完成编辑或明细为空
				return;
			}
			if (isEmpty(Data)) {	// 明细不变
				$UI.msg('alert', '没有需要保存的明细!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCReimPayInv',
				MethodName: 'Update',
				Data: JSON.stringify(Data)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					Select();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#DelBT', {
		onClick: function() {
			var Rows = ReimPayGrid.getSelections();
			if (Rows.length <= 0) {
				$UI.msg('alert', '请选择要删除的信息!');
				return;
			}
			var Data = ReimPayGrid.getSelectedData();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCReimPayInv',
				MethodName: 'Delete',
				Data: JSON.stringify(Data)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					Select();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	// 生成凭证
	$UI.linkbutton('#AcctVoucherNoBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#PayConditions');
			var Params = JSON.stringify(ParamsObj);
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCReimPay',
				MethodName: 'AcctVoucherNo',
				Params: Params
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					$('#Completed').val(jsonData.rowid);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	// 打印报支单
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			Print();
		}
	});
	// 打印凭证
	$UI.linkbutton('#PrintVoucherBT', {
		onClick: function() {
			PrintVoucher();
		}
	});
	ReimPayCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '发票号',
			field: 'InvNo',
			width: 100
		}, {
			title: '发票金额',
			field: 'InvAmt',
			width: 100,
			align: 'right'
		}, {
			title: '扣款金额',
			field: 'UnPayAmt',
			width: 100,
			align: 'right',
			saveCol: true,
			editor: {
				type: 'numberbox',
				options: {
					precision: GetFmtNum('FmtRA')
				}
			}
		}, {
			title: '实付金额',
			field: 'PayAmt',
			width: 100,
			align: 'right'
		}, {
			title: '供应商',
			field: 'VendorDesc',
			width: 200
		}
	]];

	ReimPayGrid = $UI.datagrid('#ReimPayGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCReimPayInv',
			QueryName: 'DHCReimPayInv',
			query2JsonStrict: 1,
			rows: 99999
		},
		toolbar: '#ReimPayTB',
		columns: ReimPayCm,
		showBar: true,
		singleSelect: false,
		pagination: false,
		onClickRow: function(index, row) {
			ReimPayGrid.commonClickRow(index, row);
		}
	});

	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#MainConditions');
			if (isEmpty(ParamsObj.IngrLoc)) {
				$UI.msg('alert', '请选择入库科室!');
				return;
			}
			if (isEmpty(ParamsObj.InvNo)) {
				$UI.msg('alert', '请输入发票号!');
				return;
			}
			var ReimPayFlag = tkMakeServerCall('web.DHCSTMHUI.DHCReimPay', 'CheckLocInv', ParamsObj.IngrLoc, ParamsObj.InvNo);
			if (ReimPayFlag == -1) {
				$UI.msg('alert', '该发票号存在未审核的单据!');
				return;
			}
			if (ReimPayFlag == -2) {
				$UI.msg('alert', '该发票号没有需要处理的单据!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			GRGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCReimPay',
				QueryName: 'DHCING',
				query2JsonStrict: 1,
				Params: Params,
				rows: 99999
			});
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});

	$UI.linkbutton('#QueryPayBT', {
		onClick: function() {
			Select();
		}
	});

	$UI.linkbutton('#ClearPayBT', {
		onClick: function() {
			$UI.clearBlock('#PayConditions');
			$UI.clear(ReimPayGrid);
		}
	});
};
$(init);
function Clear() {
	$UI.clearBlock('#MainConditions');
	$UI.clear(GRGrid);
	$('#IngrLoc').combobox('setValue', gLocId);
}

function Select() {
	var ParamsObj = $UI.loopBlock('#PayConditions');
	var ReimPayNo = ParamsObj.ReimPayNo;
	if (isEmpty(ReimPayNo) && isEmpty(ParamsObj.InvNo)) {
		$UI.msg('alert', '请输入报支单号或发票号!');
		return;
	}
	if (ParamsObj.InvNo != '') {
		ReimPayNo = tkMakeServerCall('web.DHCSTMHUI.DHCReimPayInv', 'GetRPNoByInvNo', ParamsObj.InvNo);
		$('#ReimPayNo').val(ReimPayNo);
	}
	var Completed = tkMakeServerCall('web.DHCSTMHUI.DHCReimPayInv', 'GetCompByReimPayNo', ReimPayNo);
	$('#Completed').val(Completed);
	ReimPayGrid.load({
		ClassName: 'web.DHCSTMHUI.DHCReimPayInv',
		QueryName: 'DHCReimPayInv',
		query2JsonStrict: 1,
		ReimPayNo: ReimPayNo,
		rows: 99999
	});
}
function Print() {
	var ParamsObj = $UI.loopBlock('#PayConditions');
	var ReimPayNo = ParamsObj.ReimPayNo;
	if (isEmpty(ReimPayNo)) {
		$UI.msg('alert', '请填写需要打印的报支单号!');
		return;
	}
	var RaqName = 'DHCSTM_HUI_ReimPay.raq';
	var DirectPrintStr = '{' + RaqName + '(ReimPayNo=' + ReimPayNo + ')}';
	DHCCPM_RQDirectPrint(DirectPrintStr);
}
function PrintVoucher() {
	var ParamsObj = $UI.loopBlock('#PayConditions');
	var ReimPayNo = ParamsObj.ReimPayNo;
	if (isEmpty(ReimPayNo)) {
		$UI.msg('alert', '请填写需要打印的报支单号!');
		return;
	}
	var Compflag = ParamsObj.Completed;
	if (Compflag != 'Y') {
		$UI.msg('alert', '未生成凭证，不能打印!');
		return;
	}
	var RaqName = 'DHCSTM_HUI_ReimPayPZ.raq';
	var DirectPrintStr = '{' + RaqName + '(ReimPayNo=' + ReimPayNo + ')}';
	DHCCPM_RQDirectPrint(DirectPrintStr);
}