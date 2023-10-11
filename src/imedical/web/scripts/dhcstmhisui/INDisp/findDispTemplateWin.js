var findDispTemplateWin = function(Fn, HVFlag, FnCre) {
	if (HVFlag == undefined) {
		HVFlag = '';
	}
	$HUI.dialog('#TempWin', { width: gWinWidth, height: gWinHeight }).open();
	var LocParams = JSON.stringify(addSessionParams({
		Type: 'Login',
		Element: 'LocId',
		LoginLocType: 2
	}));
	var LocBox = $HUI.combobox('#TLocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	var TempMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '单号',
			field: 'IndsNo',
			width: 150
		}, {
			title: '接收科室',
			field: 'ReqLoc',
			width: 150
		}, {
			title: '领用人',
			field: 'RecUser',
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
			title: '发放类型',
			field: 'DispMode',
			width: 100,
			formatter: function(value, row, index) {
				if (value == 1) {
					return '个人';
				} else {
					return '专业组';
				}
			}
		}, {
			title: '单据备注',
			field: 'Remark',
			width: 100
		}
	]];
	var TempMainGrid = $UI.datagrid('#TempMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDisp',
			QueryName: 'DHCINDisp',
			query2JsonStrict: 1
		},
		columns: TempMainCm,
		onSelect: function(index, row) {
			$UI.clear(TempDetailGrid);
			TempDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINDispItm',
				QueryName: 'DHCINDispItm',
				query2JsonStrict: 1,
				Parref: row.RowId
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				TempMainGrid.selectRow(0);
			}
		}
	});

	var TempDetailCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: 'Inclb',
			field: 'Inclb',
			width: 50,
			hidden: true
		}, {
			title: 'InciId',
			field: 'InciId',
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
			title: '高值条码',
			field: 'HVBarCode',
			width: 200
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '批号',
			field: 'BatchNo',
			width: 100
		}, {
			title: '效期',
			field: 'ExpDate',
			width: 100
		}, {
			title: '发放数量',
			field: 'Qty',
			width: 80,
			align: 'right'
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 80
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
			title: '生产厂家',
			field: 'Manf',
			width: 200
		}, {
			title: '物品备注',
			field: 'Remark',
			width: 100
		}
	]];
	var TempDetailGrid = $UI.datagrid('#TempDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispItm',
			QueryName: 'DHCINDispItm',
			query2JsonStrict: 1
		},
		columns: TempDetailCm,
		singleSelect: false
	});

	$UI.linkbutton('#TQueryBT', {
		onClick: function() {
			TQuery();
		}
	});
	function TQuery() {
		var ParamsObj = $UI.loopBlock('#TempConditions');
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '起始日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.LocId)) {
			$UI.msg('alert', '请选择发放科室!');
			return;
		}
		var ParamsObject = $.extend(ParamsObj, { HVFlag: HVFlag }, { TempFlag: 'Y' });
		var Params = JSON.stringify(ParamsObject);
		$UI.clear(TempMainGrid);
		$UI.clear(TempDetailGrid);
		TempMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINDisp',
			QueryName: 'DHCINDisp',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#TClearBT', {
		onClick: function() {
			TClear();
		}
	});
	$UI.linkbutton('#TSelectBT', {
		onClick: function() {
			var Row = TempMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要返回的发放单!');
				return;
			}
			var DetailRows = TempDetailGrid.getSelections();
			if (isEmpty(DetailRows)) {
				$UI.msg('alert', '请选择需要制单的模板明细数据!');
				return;
			}
			var DispArr = [];
			$.each(DetailRows, function(index, row) {
				var DetailId = row['RowId'];
				DispArr.push(DetailId);
			});
			var DispDetailIdStr = DispArr.join('^');
			if (isEmpty(DispDetailIdStr)) {
				return false;
			}
			FnCre(Row.RowId, DispDetailIdStr);
			$HUI.dialog('#TempWin').close();
		}
	});

	function TClear() {
		$UI.clearBlock('#TempConditions');
		$UI.clear(TempMainGrid);
		$UI.clear(TempDetailGrid);
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			LocId: gLocId
		};
		$UI.fillBlock('TempConditions', DefaultData);
	}

	TClear();
	TQuery();
};