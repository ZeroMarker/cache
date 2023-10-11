var FindWin = function(Fn) {
	$HUI.dialog('#FindWin', { width: gWinWidth, height: gWinHeight }).open();
	var LocParams = JSON.stringify(addSessionParams({
		Type: 'Login'
	}));
	var LocBox = $HUI.combobox('#FLocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description',
		onChange: function(e) {
			INDispLoc(e);
		}
	});
	// 专业组
	function INDispLoc(LocId) {
		var UserGrpParams = JSON.stringify(addSessionParams({
			User: gUserId,
			SubLoc: LocId,
			ReqFlag: ''
		}));
		var UserGrpBox = $HUI.combobox('#FUserGrp', {
			url: $URL + '?ClassName=web.DHCSTMHUI.DHCSubLocUserGroup&QueryName=GetUserGrp&ResultSetType=array&Params=' + UserGrpParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	}
	var MainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '单号',
			field: 'DsrqNo',
			width: 150
		}, {
			title: '请领人',
			field: 'ReqUser',
			width: 100
		}, {
			title: '专业组',
			field: 'GrpDesc',
			width: 100
		}, {
			title: '制单日期',
			field: 'CreateDate',
			width: 100
		}, {
			title: '制单时间',
			field: 'CreateTime',
			width: 100
		}, {
			title: '状态',
			field: 'Status',
			width: 100,
			formatter: function(value, row, index) {
				if (value == 'O') {
					return '待处理';
				} else if (value == 'C') {
					return '已处理';
				} else if (value == 'X') {
					return '已作废';
				} else if (value == 'R') {
					return '已拒绝';
				}
			}
		}, {
			title: '备注',
			field: 'Remark',
			width: 100
		}
	]];
	var MainGrid = $UI.datagrid('#FMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispReq',
			QueryName: 'DHCINDispReq',
			query2JsonStrict: 1
		},
		columns: MainCm,
		onSelect: function(index, row) {
			$UI.clear(DetailGrid);
			DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINDispReqItm',
				QueryName: 'DHCINDispReqItm',
				query2JsonStrict: 1,
				Parref: row.RowId
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				MainGrid.selectRow(0);
			}
		},
		onDblClickRow: function(index, row) {
			Fn(row['RowId']);
			$HUI.dialog('#FindWin').close();
		}
	});

	var DetailCm = [[
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
			field: 'InciCode',
			width: 150
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 200
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '数量',
			field: 'Qty',
			width: 80,
			align: 'right'
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 80
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
			title: '备注',
			field: 'Remark',
			width: 100
		}
	]];
	var DetailGrid = $UI.datagrid('#FDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispReqItm',
			QueryName: 'DHCINDispReqItm',
			query2JsonStrict: 1
		},
		columns: DetailCm
	});

	$UI.linkbutton('#FQueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
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
			$UI.msg('alert', '请选择科室!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(MainGrid);
		$UI.clear(DetailGrid);
		MainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINDispReq',
			QueryName: 'DHCINDispReq',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#FClearBT', {
		onClick: function() {
			Clear();
		}
	});
	$UI.linkbutton('#FSelectBT', {
		onClick: function() {
			var Row = MainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要返回的请领单!');
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
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			LocId: gLocId,
			NotDisp: 0
		};
		$UI.fillBlock('#FConditions', DefaultData);
	}

	Clear();
	Query();
};