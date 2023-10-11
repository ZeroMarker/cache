var FindWin = function(Fn, HvFlag) {
	if (HvFlag === typeof (undefined)) {
		HvFlag = '';
	}
	$HUI.dialog('#FindWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
	$UI.linkbutton('#FQueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		$UI.clear(INScrapMainGrid);
		$UI.clear(INScrapDetailGrid);
		var ParamsObj = $UI.loopBlock('#FindConditions');
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '开始日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.SupLoc)) {
			$UI.msg('alert', '科室不能为空!');
			return;
		}
		ParamsObj.HvFlag = HvFlag;
		var Params = JSON.stringify(ParamsObj);
		INScrapMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINScrap',
			QueryName: 'DHCINSpM',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#FComBT', {
		onClick: function() {
			var Row = INScrapMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要返回的报损单!');
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
	var FSupLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	if (InScrapParamObj.AllowSrapAllLoc == 'Y') {
		FSupLocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	}
	var FSupLocBox = $HUI.combobox('#FSupLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FSupLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var INScrapMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '报损单号',
			field: 'No',
			width: 150
		}, {
			title: '科室',
			field: 'LocDesc',
			width: 150
		}, {
			title: '报损日期',
			field: 'Date',
			width: 150
		}, {
			title: '原因',
			field: 'ReasonDesc',
			width: 150
		}, {
			title: '完成状态',
			field: 'Completed',
			width: 100,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: '审核状态',
			field: 'ChkFlag',
			width: 100,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: '备注',
			field: 'Remark',
			width: 200
		}
	]];
	var INScrapMainGrid = $UI.datagrid('#INScrapMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINScrap',
			QueryName: 'DHCINSpM',
			query2JsonStrict: 1
		},
		columns: INScrapMainCm,
		showBar: true,
		onSelect: function(index, row) {
			INScrapDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINScrapItm',
				QueryName: 'DHCINSpD',
				query2JsonStrict: 1,
				Inscrap: row.RowId
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				INScrapMainGrid.selectRow(0);
			}
		},
		onDblClickRow: function(index, row) {
			Fn(row.RowId);
			$HUI.dialog('#FindWin').close();
		}
	});

	var INScrapDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 80
		}, {
			title: '批次RowId',
			field: 'Inclb',
			width: 150,
			hidden: true
		}, {
			title: '物资RowId',
			field: 'Incil',
			width: 150,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 72
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 140
		}, {
			title: '规格',
			field: 'Spec',
			width: 80
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			width: 80,
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: '高值条码',
			field: 'HVBarCode',
			width: 150
		}, {
			title: '批次~效期',
			field: 'BatExp',
			width: 150
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 150
		}, {
			title: '报损数量',
			field: 'Qty',
			width: 72
		}, {
			title: '单位',
			field: 'PurUomDesc',
			width: 80
		}, {
			title: '进价',
			field: 'Rp',
			width: 80
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 80
		}, {
			title: '售价',
			field: 'Sp',
			width: 80
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width: 80
		}, {
			title: '批次可用库存',
			field: 'AvaQty',
			width: 80
		}
	]];

	var INScrapDetailGrid = $UI.datagrid('#INScrapDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINScrapItm',
			QueryName: 'DHCINSpD',
			query2JsonStrict: 1
		},
		columns: INScrapDetailCm,
		showBar: true
	});
	
	var DefaultData = function() {
		var StDate = DateAdd(new Date(), 'd', parseInt(-7));
		$UI.clearBlock('#FindConditions');
		$UI.clear(INScrapMainGrid);
		$UI.clear(INScrapDetailGrid);
		
		var LocId = $('#SupLoc').combobox('getValue');
		var LocDesc = $('#SupLoc').combobox('getText');
		// /设置初始值 考虑使用配置
		var DefaultDataValue = {
			StartDate: DateFormatter(StDate),
			EndDate: DateFormatter(new Date()),
			SupLoc: { RowId: LocId, Description: LocDesc },
			Audit: 'N'
		};
		$UI.fillBlock('#FindConditions', DefaultDataValue);
	};
	DefaultData();
	Query();
};