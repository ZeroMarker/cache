var GRMainGrid, GRDetailGrid;
var GRMainCm, GRDetailCm, ToolBar;
var init = function() {
	var IngrLocParams = JSON.stringify(addSessionParams({
		Type: 'Login',
		Element: 'IngrLoc'
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

	var ReqLocParams = JSON.stringify(addSessionParams({
		Type: 'All',
		Element: 'ReqLoc'
	}));
	var ReqLocBox = $HUI.combobox('#ReqLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var VoucherMonthBox = $HUI.combobox('#VoucherMonthBox', {
		data: [
			{
				'RowId': '1',
				'Description': '1月'
			}, {
				'RowId': '2',
				'Description': '2月'
			}, {
				'RowId': '3',
				'Description': '3月'
			}, {
				'RowId': '4',
				'Description': '4月'
			}, {
				'RowId': '5',
				'Description': '5月'
			}, {
				'RowId': '6',
				'Description': '6月'
			}, {
				'RowId': '7',
				'Description': '7月'
			}, {
				'RowId': '8',
				'Description': '8月'
			}, {
				'RowId': '9',
				'Description': '9月'
			}, {
				'RowId': '10',
				'Description': '10月'
			}, {
				'RowId': '11',
				'Description': '11月'
			}, {
				'RowId': '12',
				'Description': '12月'
			}],
		valueField: 'RowId',
		textField: 'Description'
	});
	GRMainCm = [[
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
			title: '供应商',
			field: 'VendorDesc',
			width: 150
		}, {
			title: '接收科室',
			field: 'ReqLocDesc',
			width: 150
		}, {
			title: '单号',
			field: 'GRNo',
			width: 200
		}, {
			title: '类型',
			field: 'Type',
			saveCol: true,
			width: 80,
			formatter: function(value, row, index) {
				if (value == 'G') {
					return '入库';
				} else {
					return '退货';
				}
			}
		}, {
			title: '类组',
			field: 'ScgDesc',
			width: 100
		}, {
			title: '数量',
			field: 'Qty',
			width: 80,
			align: 'right'
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 80,
			saveCol: true,
			align: 'right'
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width: 80,
			saveCol: true,
			align: 'right'
		}, {
			title: '审核标志',
			field: 'AuditFlag',
			width: 80
		}, {
			title: '付清标志',
			field: 'PayedFlag',
			width: 80
		}, {
			title: '制单人',
			field: 'CreateUser',
			width: 80
		}, {
			title: '制单日期',
			field: 'CreateDate',
			width: 100
		}, {
			title: '审核人',
			field: 'AuditUser',
			width: 80
		}, {
			title: '审核日期',
			field: 'AuditDate',
			width: 100
		}, {
			title: '审核时间',
			field: 'AuditTime',
			width: 80
		}
	]];

	ToolBar = [
		{
			text: '审核',
			iconCls: 'icon-stamp',
			handler: function() {
				var Rows = GRMainGrid.getSelections();
				if (Rows.length <= 0) {
					$UI.msg('alert', '请选择要审核的单据!');
					return;
				}
				var ParamsObj = $UI.loopBlock('#MainConditions');
				var Main = JSON.stringify(ParamsObj);
				var Detail = GRMainGrid.getSelectedData();
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCINGdRecPaymentApproval',
					MethodName: 'Audit',
					Main: Main,
					Detail: JSON.stringify(Detail)
				}, function(jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						Select();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}, {
			text: '取消审核',
			iconCls: 'icon-stamp-cancel',
			handler: function() {
				var Rows = GRMainGrid.getSelections();
				if (Rows.length <= 0) {
					$UI.msg('alert', '请选择要取消审核的单据!');
					return;
				}
				var Detail = GRMainGrid.getSelectedData();
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCINGdRecPaymentApproval',
					MethodName: 'CanAudit',
					Detail: JSON.stringify(Detail)
				}, function(jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						Select();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}
	];
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#MainConditions');
			var SaveParamsObj = $UI.loopBlock('#SaveConditions');
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
			var VoucherMonth = SaveParamsObj.VoucherMonthBox;
			if (VoucherMonth == '' || VoucherMonth == null) {
				$UI.msg('alert', '请选择凭证月份!');
				return;
			}
			var Rows = GRMainGrid.getSelections();
			if (Rows.length <= 0) {
				$UI.msg('alert', '请选择要生成凭证的单据!');
				return;
			}
			var ParamsObj = jQuery.extend(true, ParamsObj, SaveParamsObj);
			var Params = JSON.stringify(ParamsObj);
			var Detail = GRMainGrid.getSelectedData();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINGdRecPaymentApproval',
				MethodName: 'CreateVoucher',
				Main: Params,
				Detail: JSON.stringify(Detail),
				VoucherMonth: VoucherMonth
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	GRMainGrid = $UI.datagrid('#GRMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecPaymentApproval',
			QueryName: 'DHCGRApproval',
			query2JsonStrict: 1
		},
		toolbar: ToolBar,
		singleSelect: false,
		columns: GRMainCm,
		onCheck: function(index, row) {
			SelectDetail();
		},
		onUncheck: function(index, Row) {
			SelectDetail();
		},
		onCheckAll: function(rows) {
			SelectDetail();
		},
		onUncheckAll: function(rows) {
			$UI.clear(GRDetailGrid);
		},
		onSelect: function(index, row) {
			SelectDetail();
		},
		onLoadSuccess: function(data) {
			if ((data.rows.length > 0) && (CommParObj.IfSelFirstRow == 'Y')) {
				GRMainGrid.checkRow(0);
				SelectDetail();
			}
		}
	});

	GRDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: 'IncId',
			field: 'IncId',
			width: 50,
			hidden: true
		}, {
			title: '物资代码',
			field: 'Code',
			width: 150
		}, {
			title: '物资名称',
			field: 'Description',
			width: 150
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '批号',
			field: 'BatchNo',
			width: 100
		}, {
			title: '有效期',
			field: 'ExpDate',
			width: 70
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 90
		}, {
			title: '数量',
			field: 'Qty',
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
			width: 100
		}, {
			title: '发票号',
			field: 'InvNo',
			width: 60
		}, {
			title: '发票日期',
			field: 'InvDate',
			width: 60
		}, {
			title: '发票金额',
			field: 'InvAmt',
			width: 80,
			align: 'right'
		}, {
			title: '随行单号',
			field: 'SxNo',
			width: 80
		}
	]];

	GRDetailGrid = $UI.datagrid('#GRDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecPaymentApproval',
			QueryName: 'QueryDetails',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		columns: GRDetailCm,
		showFooter: true
	});

	$UI.linkbutton('#QueryBT', {
		onClick: function() {
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
		$UI.clear(GRMainGrid);
		$UI.clear(GRDetailGrid);
		GRMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINGdRecPaymentApproval',
			QueryName: 'DHCGRApproval',
			query2JsonStrict: 1,
			Params: Params
		});
	}

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clearBlock('#MainConditions');
			$UI.clearBlock('#SaveConditions');
			$UI.clear(GRMainGrid);
			$UI.clear(GRDetailGrid);
			SetDefaValues();
		}
	});

	SetDefaValues();
	Query();
	$.parser.parse('#VoucherMonthBox');
};
$(init);
function Select() {
	$UI.clear(GRMainGrid);
	$UI.clear(GRDetailGrid);
	GRMainGrid.commonReload();
}
function SelectDetail() {
	var Rows = GRMainGrid.getSelections();
	if (Rows.length <= 0) {
		$UI.clear(GRDetailGrid);
		return;
	}
	var Params = GRMainGrid.getSelectedData();
	GRDetailGrid.load({
		ClassName: 'web.DHCSTMHUI.DHCINGdRecPaymentApproval',
		QueryName: 'QueryDetails',
		query2JsonStrict: 1,
		Params: JSON.stringify(Params),
		rows: 99999,
		totalFooter: '"Code":"合计"',
		totalFields: 'RpAmt'
	});
}