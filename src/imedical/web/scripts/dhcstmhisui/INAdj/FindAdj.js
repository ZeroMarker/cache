var FindWin = function(Fn, HvFlag) {
	$HUI.dialog('#FindWin', { width: gWinWidth, height: gWinHeight }).open();
	$UI.linkbutton('#FQueryBT', {
		onClick: function() {
			FindQuery();
		}
	});
	if (HvFlag == undefined) {
		HvFlag = '';
	}
	function FindQuery() {
		var ParamsObj = $UI.loopBlock('#FindConditions');
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '开始日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.AdjLoc)) {
			$UI.msg('alert', '科室不能为空!');
			return;
		}
		ParamsObj.HVFlag = HvFlag;
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(INAdjDetailGrid);
		INAdjMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINAdj',
			QueryName: 'DHCINAdjM',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#FComBT', {
		onClick: function() {
			var Row = INAdjMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要返回的调整单!');
				return;
			}
			Fn(Row.RowId);
			$HUI.dialog('#FindWin').close();
		}
	});
	$UI.linkbutton('#FClearBT', {
		onClick: function() {
			DefaultData();
		}
	});
	var AdjLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	if (InAdjParamObj.AllowAdjAllLoc == 'Y') {
		AdjLocParams = JSON.stringify(addSessionParams({
			Type: 'All'
		}));
	}
	var FAdjLocBox = $HUI.combobox('#FAdjLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + AdjLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var INAdjMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '调整单号',
			field: 'No',
			width: 150
		}, {
			title: '科室',
			field: 'AdjLocDesc',
			width: 150
		}, {
			title: '调整日期',
			field: 'AdjDate',
			width: 150
		}, {
			title: '调整原因',
			field: 'ReasonDesc',
			width: 150
		}, {
			title: '完成状态',
			field: 'Completed',
			width: 100
		}, {
			title: '审核状态',
			field: 'chkFlag',
			width: 100
		}, {
			title: '备注',
			field: 'remarks',
			width: 200
		}
	
	]];
	var INAdjMainGrid = $UI.datagrid('#INAdjMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINAdj',
			QueryName: 'jsSelect',
			query2JsonStrict: 1
		},
		columns: INAdjMainCm,
		showBar: true,
		onSelect: function(index, row) {
			var Adjrowid = row['RowId'];
			var ParamsObj = { InAdj: Adjrowid };
			INAdjDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINAdjItm',
				QueryName: 'DHCINAdjD',
				query2JsonStrict: 1,
				Params: JSON.stringify(ParamsObj)
			});
		},
		onDblClickRow: function(index, row) {
			Fn(row.RowId);
			$HUI.dialog('#FindWin').close();
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				INAdjMainGrid.selectRow(0);
			}
		}
	});

	var INAdjDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 80
		}, {
			title: 'Inclb',
			field: 'Inclb',
			width: 150,
			hidden: true
		}, {
			title: 'InciId',
			field: 'InciId',
			width: 150,
			hidden: true
		}, {
			title: '物资代码',
			field: 'Code',
			width: 72
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 140
		}, {
			title: '批次~效期',
			field: 'BatExp',
			width: 140
		}, {
			title: '调整数量',
			field: 'Qty',
			align: 'right',
			width: 70
		}, {
			title: '单位',
			field: 'uomDesc',
			width: 80
		}, {
			title: '进价',
			field: 'Rp',
			align: 'right',
			width: 80
		}, {
			title: '进价金额',
			field: 'RpAmt',
			align: 'right',
			width: 80
		}, {
			title: '生产厂家',
			field: 'ManfDesc',
			width: 150
		}, {
			title: '规格',
			field: 'Spec',
			width: 80
		}, {
			title: '售价',
			field: 'Sp',
			align: 'right',
			width: 80
		}, {
			title: '售价金额',
			field: 'SpAmt',
			align: 'right',
			width: 80
		}, {
			title: '批次可用库存',
			field: 'AvaQty',
			align: 'right',
			width: 100
		}
	]];

	var INAdjDetailGrid = $UI.datagrid('#INAdjDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINAdjItm',
			QueryName: 'DHCINAdjD',
			query2JsonStrict: 1
		},
		columns: INAdjDetailCm,
		showBar: true,
		remoteSort: false
	});
	/* --设置初始值--*/
	var DefaultData = function() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(INAdjMainGrid);
		$UI.clear(INAdjDetailGrid);
		var DefaultDataValue = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date()),
			AdjLoc: gLocObj,
			CompleteFlag: 'N',
			Audit: 'N'
		};
		$UI.fillBlock('#FindConditions', DefaultDataValue);
	};
	DefaultData();
	FindQuery();
};