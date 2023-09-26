var FindPayWin = function (IngrLoc, PayId, Fn) {
	$HUI.dialog('#FindPayWin').open();
	var FPVendorParams = JSON.stringify(addSessionParams({
				APCType: "M",
				RcFlag: "Y"
			}));
	var FPVendorBox = $HUI.combobox('#FPVendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FPVendorParams,
			valueField: 'RowId',
			textField: 'Description'
		});

	var PayModeBox = $HUI.combobox('#PayMode', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPayMode&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description'
		});

	$UI.linkbutton('#FPQueryBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#FindPayConditions');
			if (isEmpty(ParamsObj.FPStartDate)) {
				$UI.msg('alert', '起始日期不能为空!');
				return;
			}
			if (isEmpty(ParamsObj.FPEndDate)) {
				$UI.msg('alert', '截止日期不能为空!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			$UI.clear(VendorGrid);
			$UI.clear(ToPayGrid);
			VendorGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCPay',
				QueryName: 'VendorListToPay',
				LocId: IngrLoc,
				Params: Params
			});
		}
	});

	$UI.linkbutton('#FPSaveBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#FindPayConditions');
			var Rows = ToPayGrid.getSelections();
			if (Rows.length <= 0) {
				$UI.msg('alert', '请选择要保存的应付单据!');
				return;
			}
			var Vendor = VendorGrid.getSelected().RowId;
			var Main = JSON.stringify(ParamsObj);
			var Detail = ToPayGrid.getSelectedData();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCPay',
				MethodName: 'Save',
				PayId: PayId,
				LocId: IngrLoc,
				Vendor: Vendor,
				Main: Main,
				Detail: JSON.stringify(Detail)
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					$HUI.dialog('#FindPayWin').close();
					Fn(jsonData.rowid);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	$UI.linkbutton('#FPClearBT', {
		onClick: function () {
			Clear();
		}
	});

	var VendorCm = [[{
				title: 'RowId',
				field: 'RowId',
				width: 50,
				hidden: true
			}, {
				title: '供应商',
				field: 'VendorDesc',
				width: 150
			}
		]];
	var VendorGrid = $UI.datagrid('#VendorGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCPay',
				QueryName: 'VendorListToPay'
			},
			columns: VendorCm,
			pagination: false,
			onSelect: function (Index, Row) {
				$('#TotalAmt').val("");
				var ParamsObj = $UI.loopBlock('#FindPayConditions');
				var Params = JSON.stringify(ParamsObj);
				ToPayGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCPay',
					QueryName: 'GetItmToPay',
					LocId: IngrLoc,
					Vendor: Row.RowId,
					Params: Params,
					rows: 9999
				});
				ToPayGrid.clearChecked();
			},
			onLoadSuccess: function (data) {
				if (data.rows.length > 0) {
					VendorGrid.selectRow(0);
				}
			}
		});

	var ToPayCm = [[{
				field: 'ck',
				checkbox: true
			}, {
				title: "RowId",
				field: 'RowId',
				width: 50,
				hidden: true,
				saveCol: true
			}, {
				title: "单号",
				field: 'No',
				width: 100
			}, {
				title: "类型",
				field: 'Type',
				width: 50,
				saveCol: true,
				formatter: function (value, row, index) {
					if (value == "G") {
						return "入库";
					} else {
						return "退货";
					}
				}
			}, {
				title: "付款金额",
				field: 'PayAmt',
				width: 100,
				align: 'right',
				saveCol: true,
				editor: {
					type: 'numberbox'
				}
			}, {
				title: "日期",
				field: 'Date',
				width: 90,
				align: 'right'
			}, {
				title: "时间",
				field: 'Time',
				width: 80,
				align: 'right'
			}, {
				title: "审核人",
				field: 'UserName',
				width: 70
			}, {
				title: "Inci",
				field: 'Inci',
				width: 50,
				hidden: true,
				saveCol: true
			}, {
				title: "物资代码",
				field: 'Code',
				width: 120
			}, {
				title: "物资名称",
				field: 'Description',
				width: 150
			}, {
				title: "规格",
				field: 'Spec',
				width: 100
			}, {
				title: "数量",
				field: 'Qty',
				width: 100,
				align: 'right'
			}, {
				title: "单位",
				field: 'UomDesc',
				width: 80
			}, {
				title: "进价",
				field: 'Rp',
				width: 100,
				align: 'right'
			}, {
				title: "进价金额",
				field: 'RpAmt',
				width: 100,
				align: 'right',
				saveCol: true
			}, {
				title: "售价",
				field: 'Sp',
				width: 100,
				align: 'right'
			}, {
				title: "售价金额",
				field: 'SpAmt',
				width: 100,
				align: 'right'
			}, {
				title: "厂商",
				field: 'Manf',
				width: 100
			}, {
				title: "已付金额",
				field: 'PayedAmt',
				width: 100,
				align: 'right'
			}, {
				title: "待付金额",
				field: 'RestAmt',
				width: 100,
				align: 'right'
			}, {
				title: "发票号",
				field: 'InvNo',
				width: 100
			}, {
				title: "发票日期",
				field: 'InvDate',
				width: 100
			}, {
				title: "发票金额",
				field: 'InvAmt',
				width: 100,
				align: 'right'
			}, {
				title: "随行单号",
				field: 'InsxNo',
				width: 100
			}, {
				title: "批号",
				field: 'BatNo',
				width: 100
			}, {
				title: "效期",
				field: 'ExpDate',
				width: 100
			}
		]];

	var ToPayGrid = $UI.datagrid('#ToPayGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCPay',
				QueryName: 'GetItmToPay'
			},
			columns: ToPayCm,
			singleSelect: false,
			onClickCell: function (index, filed, value) {
				ToPayGrid.commonClickCell(index, filed)
			},
			onCheck: function (Index, Row) {
				TotalAmt();
			},
			onUncheck: function (Index, Row) {
				TotalAmt();
			},
			onCheckAll: function (rows) {
				TotalAmt();
			},
			onUncheckAll: function (rows) {
				$('#TotalAmt').val('');
			}
		});

	function Clear() {
		$('#TotalAmt').val("");
		$UI.clearBlock('#FindPayConditions');
		$UI.clear(VendorGrid);
		$UI.clear(ToPayGrid);
		var Dafult = {
			FPStartDate: DefaultStDate(),
			FPEndDate: DefaultEdDate(),
		}
		$UI.fillBlock('#FindPayConditions', Dafult)
	}

	function TotalAmt() {
		var PayRatio = $('#PayRatio').val();
		if ((Number(PayRatio) > 1) || (Number(PayRatio) < 0)) {
			$UI.msg('alert', '预付比例需大于0小于等于1!')
			return;
		}
		if ((Number(PayRatio) <= 1) && (Number(PayRatio) > 0)) {
			PayRatio = Number(PayRatio);
		} else {
			PayRatio = 1;
		}
		var TotalAmt = 0;
		var Rows = ToPayGrid.getChecked();
		for (var i = 0; i < Rows.length; i++) {
			var PayAmt = Rows[i].PayAmt;
			PayAmt = Number(PayAmt) * PayRatio;
			TotalAmt = Number(TotalAmt) + PayAmt;
		}
		$('#TotalAmt').val(TotalAmt);
	}
	$('#PayRatio').keydown(function (e) {
		if (e.keyCode == 13) {
			var PayRatio = $('#PayRatio').val();
			if (PayRatio == null || PayRatio == "") {
				$UI.msg('alert', '预付比例为空!')
				return;
			}
			TotalAmt();
		}
	});

	Clear();
}
