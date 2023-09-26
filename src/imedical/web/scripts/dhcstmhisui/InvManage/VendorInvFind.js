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

	var InvMainCm = [[{
				title: "RowId",
				field: 'RowId',
				width: 50,
				hidden: true
			}, {
				title: "组合单号",
				field: 'AssemNo',
				width: 200
			}, {
				title: "供应商",
				field: 'VendorDesc',
				width: 200
			}, {
				title: "制单人",
				field: 'CreateUser',
				width: 80
			}, {
				title: "制单日期",
				field: 'CreateDate',
				width: 100,
				align: 'right'
			}, {
				title: "制单时间",
				field: 'CreateTime',
				width: 80,
				align: 'right'
			}, {
				title: "组合进价",
				field: 'RpAmt',
				width: 100,
				align: 'right'
			}, {
				title: "完成状态",
				field: 'InvComp',
				width: 80
			}
		]];

	var InvMainGrid = $UI.datagrid('#InvMainGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				QueryName: 'DHCVendorInv'
			},
			columns: InvMainCm,
			onSelect: function (index, row) {
				InvDetailGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCVendorInv',
					QueryName: 'DHCVendorInvItm',
					Inv: row.RowId
				});
			},
			onDblClickRow: function (index, row) {
				Fn(row.RowId);
				$HUI.dialog('#FindWin').close();
			},
			onLoadSuccess: function (data) {
				if (data.rows.length > 0) {
					InvMainGrid.selectRow(0);
				}
			}
		});

	var InvDetailCm = [[{
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
				title: "IncId",
				field: 'IncId',
				width: 50,
				hidden: true
			}, {
				title: "代码",
				field: 'Code',
				width: 120
			}, {
				title: "描述",
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
				title: "类型",
				field: 'Type',
				align: 'center',
				formatter: function(value,row,index){
					if (value=="G"){
						return "入库";
					} else {
						return "退货";
					}
				}
			}
		]];

	var InvDetailGrid = $UI.datagrid('#InvDetailGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				QueryName: 'DHCVendorInvItm'
			},
			columns: InvDetailCm
		})

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
			$UI.clear(InvMainGrid);
			$UI.clear(InvDetailGrid);
			InvMainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				QueryName: 'DHCVendorInv',
				LocId: IngrLoc,
				Params: Params
			});
		}
	});
	
	$UI.linkbutton('#FSelectBT', {
		onClick: function () {
			var Row = InvMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要返回的发票组合单!');
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

	function Clear() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(InvMainGrid);
		$UI.clear(InvDetailGrid);
		var Dafult = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
		}
		$UI.fillBlock('#FindConditions', Dafult);
	}
	Clear();
}