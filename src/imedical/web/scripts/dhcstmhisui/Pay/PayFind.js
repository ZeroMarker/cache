var FindWin = function (IngrLoc, Fn) {
	$HUI.dialog('#FindWin').open();

	var FVendorParams = JSON.stringify(addSessionParams({
				APCType: "M",
				RcFlag: "Y"
			}));
	var FVendorBox = $HUI.combobox('#FVendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FVendorParams,
			valueField: 'RowId',
			textField: 'Description'
		});

	$UI.linkbutton('#FQueryBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#FindConditions');
			if (isEmpty(ParamsObj.StartDate)) {
				$UI.msg('alert', '起始日期不能为空!');
				return;
			}
			if (isEmpty(ParamsObj.EndDate)) {
				$UI.msg('alert', '截止日期不能为空!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			$UI.clear(PayMainGrid);
			$UI.clear(PayDetailGrid);
			PayMainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCPay',
				QueryName: 'DHCPay',
				LocId: IngrLoc,
				Params: Params
			});
		}
	});
	$UI.linkbutton('#FSelectBT', {
		onClick: function () {
			var Row = PayMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要返回的付款单!');
				return;
			}
			Fn(Row.RowId);
			$HUI.dialog('#FindWin').close();
		}
	});
	$UI.linkbutton('#FClearBT', {
		onClick: function () {
			Clear();
		}
	});

	var PayMainCm = [[{
				title: "RowId",
				field: 'RowId',
				width: 50,
				hidden: true
			}, {
				title: "付款单号",
				field: 'PayNo',
				width: 150
			}, {
				title: "采购部门",
				field: 'LocDesc',
				width: 150
			}, {
				title: "供应商",
				field: 'VendorDesc',
				width: 100
			}, {
				title: "制单人",
				field: 'UserName',
				width: 70
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
				title: "付款金额",
				field: 'PayAmt',
				width: 100,
				align: 'right'
			}, {
				title: "采购确认",
				field: 'PurConfirm',
				width: 60
			}, {
				title: "会计确认",
				field: 'AccConfirm',
				width: 60
			}, {
				title: "完成状态",
				field: 'Complete',
				width: 60
			}, {
				title: "支付方式",
				field: 'PayMode',
				width: 80
			}, {
				title: "支付票据号",
				field: 'CheckNo',
				width: 80
			}, {
				title: "票据日期",
				field: 'CheckDate',
				width: 90,
				align: 'right'
			}, {
				title: "票据金额",
				field: 'CheckAmt',
				width: 100,
				align: 'right'
			}
		]];

	var PayMainGrid = $UI.datagrid('#PayMainGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCPay',
				QueryName: 'DHCPay'
			},
			columns: PayMainCm,
			onSelect: function (index, row) {
				PayDetailGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCPayItm',
					QueryName: 'DHCPayItm',
					Pay: row.RowId
				});
			},
			onLoadSuccess: function (data) {
				if (data.rows.length > 0) {
					PayMainGrid.selectRow(0);
				}
			},
			onDblClickRow: function (index, row) {
				Fn(row.RowId);
				$HUI.dialog('#FindWin').close();
			}
		});

	var PayDetailCm = [[{
				title: "RowId",
				field: 'RowId',
				width: 50,
				hidden: true
			}, {
				title: "Pointer",
				field: 'Pointer',
				width: 50,
				hidden: true
			}, {
				title: "Inclb",
				field: 'Inclb',
				width: 50,
				hidden: true
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
				align: 'right'
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
				title: "结清标志",
				field: 'OverFlag',
				width: 60
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
				title: "批号",
				field: 'BatNo',
				width: 100
			}, {
				title: "效期",
				field: 'ExpDate',
				width: 100
			}, {
				header: "类型",
				dataIndex: 'TransType',
				align: 'center',
				formatter: function (value, row, index) {
					if (value == "G") {
						return "入库";
					} else {
						return "退货";
					}
				}
			}
		]];

	var PayDetailGrid = $UI.datagrid('#PayDetailGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCPayItm',
				QueryName: 'DHCPayItm'
			},
			columns: PayDetailCm
		})

	function Clear() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(PayMainGrid);
		$UI.clear(PayDetailGrid);
		var Dafult = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
		}
		$UI.fillBlock('#FindConditions', Dafult)
	}
	Clear();
}
