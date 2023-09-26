var VoucherGrid, GRMainGrid, GRDetailGrid;
var VoucherCm, GRMainCm, GRDetailCm;
var IsOneRow = 1;
var init = function () {
	var IngrLocParams = JSON.stringify(addSessionParams({
				Type: 'Login'
			}));
	var IngrLocBox = $HUI.combobox('#IngrLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + IngrLocParams,
			valueField: 'RowId',
			textField: 'Description'
		});

	var VendorParams = JSON.stringify(addSessionParams({
				APCType: "M",
				RcFlag: "Y"
			}));
	var VendorBox = $HUI.combobox('#Vendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
			valueField: 'RowId',
			textField: 'Description'
		});

	VoucherCm = [[{
				title: "RowId",
				field: 'RowId',
				width: 50,
				hidden: true,
				saveCol: true
			}, {
				title: "操作",
				field: 'Icon',
				width: 100,
				align: 'center',
				formatter: function (value, row, index) {
					var str = "<a href='#' onclick='DeleteVoucher(" + row.RowId + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/edit_remove.png' title='删除' border='0'></a>&nbsp;&nbsp;&nbsp;" +
						"<a href='#' onclick='PrintVoucher(" + row.RowId + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/print.png' title='打印' border='0'></a>";
					return str;
				}
			}, {
				title: "凭证号",
				field: 'VoucherNo',
				width: 150
			}, {
				title: "月份",
				field: 'Month',
				width: 80
			}, {
				title: "供应商",
				field: 'VendorDesc',
				width: 200
			}, {
				title: "类型",
				field: 'Type',
				width: 80,
				formatter: function (value, row, index) {
					if (value == "G") {
						return "入库";
					} else {
						return "退货";
					}
				}
			}, {
				title: "开始日期",
				field: 'StartDate',
				width: 100
			}, {
				title: "结算日期",
				field: 'SvcDate',
				width: 100
			}, {
				title: "进价金额",
				field: 'RpAmt',
				width: 100,
				align: 'right'
			}, {
				title: "售价金额",
				field: 'SpAmt',
				width: 100,
				align: 'right'
			}
		]];

	VoucherGrid = $UI.datagrid('#VoucherGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCPayVoucher',
				QueryName: 'QueryVoucher'
			},
			columns: VoucherCm,
			onSelect: function (index, row) {
				if (IsOneRow == 1) {
					$UI.clear(GRMainGrid);
					$UI.clear(GRDetailGrid);
					GRMainGrid.load({
						ClassName: 'web.DHCSTMHUI.DHCPayVoucher',
						QueryName: 'QueryRecByVoucher',
						Svc: row.RowId
					});
				} else {
					IsOneRow = 1;
				}
			},
			onLoadSuccess: function (data) {
				if (data.rows.length > 0) {
					VoucherGrid.selectRow(0);
				}
			}
		});

	GRMainCm = [[{
				title: "RowId",
				field: 'RowId',
				width: 50,
				hidden: true
			}, {
				title: "单号",
				field: 'GRNo',
				width: 150
			}, {
				title: "类型",
				field: 'Type',
				width: 60,
				formatter: function (value, row, index) {
					if (value == "G") {
						return "入库";
					} else {
						return "退货";
					}
				}
			}, {
				title: "类组",
				field: 'ScgDesc',
				width: 80
			}, {
				title: "数量",
				field: 'QtyAmt',
				width: 80,
				align: 'right'
			}, {
				title: "进价金额",
				field: 'RpAmt',
				width: 80,
				align: 'right'
			}, {
				title: "结清标志",
				field: 'OverFlag',
				width: 80
			}, {
				title: "制单人",
				field: 'CreateUser',
				width: 80
			}, {
				title: "制单日期",
				field: 'CreateDate',
				width: 100
			}, {
				title: "审核人",
				field: 'AuditUser',
				width: 80
			}, {
				title: "审核日期",
				field: 'AuditDate',
				width: 100
			}
		]];

	GRMainGrid = $UI.datagrid('#GRMainGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCPayVoucher',
				QueryName: 'QueryRecByVoucher'
			},
			columns: GRMainCm,
			onSelect: function (index, row) {
				GRDetailGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCINGdRecPaymentApproval',
					QueryName: 'QueryDetail',
					Parref: row.RowId,
					Type: row.Type
				});
			},
			onLoadSuccess: function (data) {
				if (data.rows.length > 0) {
					GRMainGrid.selectRow(0);
				}
			}
		});

	GRDetailCm = [[{
				title: "RowId",
				field: 'RowId',
				width: 50,
				hidden: true
			}, {
				title: "Inci",
				field: 'Inci',
				width: 50,
				hidden: true
			}, {
				title: "代码",
				field: 'Code',
				width: 150
			}, {
				title: "名称",
				field: 'Description',
				width: 150
			}, {
				title: "规格",
				field: 'Spec',
				width: 100
			}, {
				title: "批号",
				field: 'BatchNo',
				width: 100
			}, {
				title: "有效期",
				field: 'ExpDate',
				width: 80
			}, {
				title: "单位",
				field: 'UomDesc',
				width: 80
			}, {
				title: "数量",
				field: 'Qty',
				width: 80,
				align: 'right'
			}, {
				title: "进价",
				field: 'Rp',
				width: 80,
				align: 'right'
			}, {
				title: "进价金额",
				field: 'RpAmt',
				width: 80,
				align: 'right'
			}, {
				title: "售价",
				field: 'Sp',
				width: 80,
				align: 'right'
			}, {
				title: "售价金额",
				field: 'SpAmt',
				width: 80,
				align: 'right'
			}, {
				title: "厂商",
				field: 'Manf',
				width: 100
			}, {
				title: "发票号",
				field: 'InvNo',
				width: 80
			}, {
				title: "发票日期",
				field: 'InvDate',
				width: 80
			}, {
				title: "发票金额",
				field: 'InvAmt',
				width: 80,
				align: 'right'
			}, {
				title: "随行单号",
				field: 'SxNo',
				width: 100
			}
		]];

	GRDetailGrid = $UI.datagrid('#GRDetailGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCINGdRecPaymentApproval',
				QueryName: 'QueryDetail'
			},
			columns: GRDetailCm
		});

	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#MainConditions');
			if (isEmpty(ParamsObj.StartDate)) {
				$UI.msg('alert', '起始日期不能为空!');
				return;
			}
			if (isEmpty(ParamsObj.EndDate)) {
				$UI.msg('alert', '截止日期不能为空!');
				return;
			}
			if (isEmpty(ParamsObj.IngrLoc)) {
				$UI.msg('alert', '入库科室不能为空!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			$UI.clear(VoucherGrid);
			$UI.clear(GRMainGrid);
			$UI.clear(GRDetailGrid);
			VoucherGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCPayVoucher',
				QueryName: 'QueryVoucher',
				Params: Params
			});
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			$UI.clearBlock('#MainConditions');
			$UI.clear(VoucherGrid);
			$UI.clear(GRMainGrid);
			$UI.clear(GRDetailGrid);
			SetDefaValues();
		}
	});

	SetDefaValues();
}
$(init);
function Select() {
	$UI.clear(VoucherGrid);
	$UI.clear(GRMainGrid);
	$UI.clear(GRDetailGrid);
	VoucherGrid.commonReload();
}
function SetDefaValues() {
	$('#IngrLoc').combobox('setValue', gLocId);
	$('#StartDate').datebox('setValue', DateFormatter(new Date()));
	$('#EndDate').datebox('setValue', DateFormatter(new Date()));
}
function DeleteVoucher(RowId) {
	IsOneRow = 0;
	$.cm({
		ClassName: 'web.DHCSTMHUI.DHCPayVoucher',
		MethodName: 'DeleteVoucher',
		Svc: RowId
	}, function (jsonData) {
		if (jsonData.success == 0) {
			$UI.msg('success', jsonData.msg);
			Select();
		} else {
			$UI.msg('error', jsonData.msg);
		}
	});
}
function PrintVoucher(Params) {
	IsOneRow = 0;
	if (Params == null || Params == '') {
		return;
	}
	var RaqName = "DHCSTM_HUI_PayVoucher_Common.raq";
	var DirectPrintStr = '{' + RaqName + '(Params=' + Params + ')}';
	var RQPrintStr = TranslateRQStr(DirectPrintStr);
	var IndirPrint = "Y";
	if (IndirPrint != 'N') {
		DHCSTM_DHCCPM_RQPrint(RQPrintStr);
	} else {
		DHCCPM_RQDirectPrint(DirectPrintStr);
	}
}