var FindWin = function (Fn) {
	$HUI.dialog('#FindWin').open();

	var LocParams = JSON.stringify(addSessionParams({
				Type: 'Login'
			}));
	var LocBox = $HUI.combobox('#FLocId', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
			valueField: 'RowId',
			textField: 'Description'
		});

	var MainCm = [[{
				title: "RowId",
				field: 'RowId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: "单号",
				field: 'DsrNo',
				width: 150
			}, {
				title: "科室",
				field: 'LocDesc',
				width: 200
			}, {
				title: "制单人",
				field: 'CreateUser',
				width: 100
			}, {
				title: "制单日期",
				field: 'CreateDate',
				width: 100
			}
		]];
	var MainGrid = $UI.datagrid('#FMainGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCINDispRet',
				QueryName: 'DHCINDispRet'
			},
			columns: MainCm,
			onSelect: function (index, row) {
				$UI.clear(DetailGrid);
				DetailGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCINDispRetItm',
					QueryName: 'DHCINDispRetItm',
					Parref: row.RowId
				});
			},
			onLoadSuccess: function (data) {
				if (data.rows.length > 0) {
					MainGrid.selectRow(0);
				}
			},
			onDblClickRow: function(index, row){
				Fn(row['RowId']);
				$HUI.dialog('#FindWin').close();
			}
		});

	var DetailCm = [[{
				title: "RowId",
				field: 'RowId',
				width: 50,
				hidden: true
			}, {
				title: "Inclb",
				field: 'Inclb',
				width: 50,
				hidden: true
			}, {
				title: "IncId",
				field: 'IncId',
				width: 50,
				hidden: true
			}, {
				title: "物资代码",
				field: 'InciCode',
				width: 150
			}, {
				title: "物资名称",
				field: 'InciDesc',
				width: 200
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
				width: 100
			}, {
				title: "退回数量",
				field: 'Qty',
				width: 80,
				align: 'right'
			}, {
				title: "单位",
				field: 'UomDesc',
				width: 80
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
				width: 200
			}
		]];
	var DetailGrid = $UI.datagrid('#FDetailGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCINDispRetItm',
				QueryName: 'DHCINDispRetItm'
			},
			columns: DetailCm
		});
	
	$UI.linkbutton('#FQueryBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#FConditions');
			if (isEmpty(ParamsObj.StartDate)) {
				$UI.msg('alert', '起始日期不能为空!');
				return;
			}
			if (isEmpty(ParamsObj.EndDate)) {
				$UI.msg('alert', '截止日期不能为空!');
				return;
			}
			if (isEmpty(ParamsObj.LocId)) {
				$UI.msg('alert', '科室不能为空!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			$UI.clear(MainGrid);
			$UI.clear(DetailGrid);
			MainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINDispRet',
				QueryName: 'DHCINDispRet',
				Params: Params
			});
		}
	});
	$UI.linkbutton('#FClearBT', {
		onClick: function () {
			Clear();
		}
	});
	$UI.linkbutton('#FSelectBT', {
		onClick: function () {
			var Row = MainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要返回的退回单!');
				return;
			}
			Fn(Row.RowId);
			$HUI.dialog('#FindWin').close();
		}
	});

	function Clear() {
		$UI.clearBlock('#FConditions');
		$UI.clear(MainGrid);
		$UI.clear(DetailGrid);
		var Dafult = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			LocId: gLocId
		}
		$UI.fillBlock('#FConditions', Dafult);
	}

	Clear();
}
