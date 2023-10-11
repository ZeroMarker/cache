var PayMainCm, PayDetailCm, ToolBar;
var PayMainGrid, PayDetailGrid;
var init = function() {
	var IngrLocParams = JSON.stringify(addSessionParams({
		Type: 'Login'
	}));
	var IngrLocBox = $HUI.combobox('#IngrLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + IngrLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			if (CommParObj.ApcScg == 'L') {
				VendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M', LocId: LocId }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
				VendorBox.reload(url);
			}
		}
	});

	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	var PayModeBox = $HUI.combobox('#PayMode', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPayMode&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});

	ToolBar = [
		{
			text: '采购确认',
			iconCls: 'icon-shopping-cart-ok',
			handler: function() {
				var RowData = PayMainGrid.getSelections();
				var PayIdStr = '';
				for (var i = 0; i < RowData.length; i++) {
					var PayId = RowData[i].RowId;
					if (PayIdStr == '') {
						PayIdStr = PayId;
					} else {
						PayIdStr = PayIdStr + '^' + PayId;
					}
				}
				if (PayIdStr == '') {
					$UI.msg('alert', '没有需要确认的单据!');
					return false;
				}
				var Params = JSON.stringify(sessionObj);
				showMask();
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCPayQuery',
					MethodName: 'jsPurConfirm',
					PayIdStr: PayIdStr,
					Params: Params
				}, function(jsonData) {
					hideMask();
					if (jsonData.success == 0) {
						Select();
						var info = jsonData.msg;
						var infoArr = info.split('@');
						var Allcnt = infoArr[0];
						var Succnt = infoArr[1];
						var failcnt = Allcnt - Succnt;
						var ErrInfo = infoArr[2];
						$UI.msg('success', '共:' + Allcnt + '记录,成功:' + Succnt + '条');
						if (failcnt > 0) {
							$UI.msg('error', '失败:' + failcnt + '条;' + ErrInfo);
						}
					}
				});
			}
		}, {
			text: '会计确认',
			iconCls: 'icon-person-ok',
			handler: function() {
				var Row = PayMainGrid.getSelected();
				if (isEmpty(Row)) {
					$UI.msg('alert', '请选择付款单!');
					return;
				}
				if (Row.AccConfirm == 'Y') {
					$UI.msg('alert', '此付款单已会计确认!');
					return;
				}
				AccAckWin(Row, Select);
			}
		}, {
			text: '财务确认',
			iconCls: 'icon-mnypaper-ok',
			handler: function() {
				var RowData = PayMainGrid.getSelections();
				var PayIdStr = '';
				for (var i = 0; i < RowData.length; i++) {
					var PayId = RowData[i].RowId;
					if (PayIdStr == '') {
						PayIdStr = PayId;
					} else {
						PayIdStr = PayIdStr + '^' + PayId;
					}
				}
				if (PayIdStr == '') {
					$UI.msg('alert', '没有需要确认的单据!');
					return false;
				}
				var Params = JSON.stringify(sessionObj);
				showMask();
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCPayQuery',
					MethodName: 'jsFinConfirm',
					PayIdStr: PayIdStr,
					Params: Params
				}, function(jsonData) {
					hideMask();
					if (jsonData.success == 0) {
						Select();
						var info = jsonData.msg;
						var infoArr = info.split('@');
						var Allcnt = infoArr[0];
						var Succnt = infoArr[1];
						var failcnt = Allcnt - Succnt;
						var ErrInfo = infoArr[2];
						$UI.msg('success', '共:' + Allcnt + '记录,成功:' + Succnt + '条');
						if (failcnt > 0) {
							$UI.msg('error', '失败:' + failcnt + '条;' + ErrInfo);
						}
					}
				});
			}
		}, '-', {
			text: '打印',
			iconCls: 'icon-print',
			handler: function() {
				var Row = PayMainGrid.getSelected();
				if (isEmpty(Row)) {
					$UI.msg('alert', '请选择付款单!');
					return;
				}
				PrintPay(Row.RowId);
			}
		}
	];

	PayMainCm = [[
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
			title: 'Vendor',
			field: 'Vendor',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '付款单号',
			field: 'PayNo',
			width: 200
		}, {
			title: '供应商',
			field: 'VendorDesc',
			width: 200
		}, {
			title: '制单人',
			field: 'UserName',
			width: 80
		}, {
			title: '制单日期',
			field: 'Date',
			width: 100
		}, {
			title: '制单时间',
			field: 'Time',
			width: 80
		}, {
			title: '付款金额',
			field: 'PayAmt',
			width: 100,
			align: 'right'
		}, {
			title: '采购确认',
			field: 'PurConfirm',
			width: 80
		}, {
			title: '采购确认人',
			field: 'PurConfirmUser',
			width: 100
		}, {
			title: '采购确认日期',
			field: 'PurConfirmDate',
			saveCol: true,
			width: 100
		}, {
			title: '会计确认',
			field: 'AccConfirm',
			width: 80
		}, {
			title: '会计确认人',
			field: 'AccConfirmUser',
			width: 100
		}, {
			title: '会计确认日期',
			field: 'AccConfirmDate',
			saveCol: true,
			width: 100
		}, {
			title: '财务确认',
			field: 'FinConfirm',
			width: 80
		}, {
			title: '财务确认人',
			field: 'FinConfirmUser',
			width: 100
		}, {
			title: '财务确认日期',
			field: 'FinConfirmDate',
			saveCol: true,
			width: 100
		}, {
			title: '支付方式',
			field: 'PayModeId',
			width: 80,
			hidden: true
		}, {
			title: '支付方式',
			field: 'PayMode',
			width: 80
		}, {
			title: '支付单号',
			field: 'CheckNo',
			width: 100
		}, {
			title: '支付金额',
			field: 'CheckAmt',
			width: 100,
			align: 'right'
		}
	]];

	PayMainGrid = $UI.datagrid('#PayMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCPay',
			QueryName: 'DHCPay',
			query2JsonStrict: 1
		},
		toolbar: ToolBar,
		columns: PayMainCm,
		showBar: true,
		singleSelect: false,
		onSelect: function(index, row) {
			PayDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCPayItm',
				QueryName: 'DHCPayItm',
				query2JsonStrict: 1,
				Pay: row.RowId,
				rows: 99999
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				PayMainGrid.selectRow(0);
			}
		}
	});

	PayDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '入库退货Id',
			field: 'Pointer',
			width: 50,
			hidden: true
		}, {
			title: 'Inci',
			field: 'Inci',
			width: 50,
			hidden: true
		}, {
			title: '物资代码',
			field: 'Code',
			width: 150
		}, {
			title: '物资名称',
			field: 'Description',
			width: 200
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '批号',
			field: 'BatNo',
			width: 100
		}, {
			title: '有效期',
			field: 'ExpDate',
			width: 100
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 80
		}, {
			title: '数量',
			field: 'Qty',
			width: 80,
			align: 'right'
		}, {
			title: '付款金额',
			field: 'PayAmt',
			width: 80,
			align: 'right'
		}, {
			title: '进价',
			field: 'Rp',
			width: 80,
			align: 'right'
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '售价',
			field: 'Sp',
			width: 80,
			align: 'right'
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 200
		}, {
			title: '发票号',
			field: 'InvNo',
			width: 80
		}, {
			title: '发票日期',
			field: 'InvDate',
			width: 100
		}, {
			title: '发票金额',
			field: 'InvAmt',
			width: 80,
			align: 'right'
		}, {
			title: '结清标志',
			field: 'OverFlag',
			width: 80
		}, {
			title: '业务单号',
			field: 'GRNo',
			width: 200
		}, {
			title: '类型',
			field: 'TransType',
			width: 80,
			formatter: function(value, row, index) {
				if (value == 'G') {
					return '入库';
				} else {
					return '退货';
				}
			}
		}
	]];

	PayDetailGrid = $UI.datagrid('#PayDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecPaymentApproval',
			QueryName: 'QueryDetail',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		columns: PayDetailCm,
		showBar: true
	});

	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			$UI.clear(PayDetailGrid);
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('#MainConditions');
		
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (isEmpty(ParamsObj.IngrLoc)) {
			$UI.msg('alert', '入库科室不能为空!');
			return;
		}
		if (isEmpty(StartDate)) {
			$UI.msg('alert', '开始日期不能为空!');
			return;
		}
		if (isEmpty(EndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		if (compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '截止日期不能小于开始日期!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		PayMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCPay',
			QueryName: 'DHCPay',
			query2JsonStrict: 1,
			LocId: ParamsObj.IngrLoc,
			Params: Params
		});
	}

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clearBlock('#MainConditions');
			$UI.clear(PayMainGrid);
			$UI.clear(PayDetailGrid);
			SetDefaValues();
		}
	});

	SetDefaValues();
	Query();
};
$(init);
function Select() {
	$UI.clear(PayMainGrid);
	$UI.clear(PayDetailGrid);
	PayMainGrid.commonReload();
}