var FindWin = function(Fn) {
	$HUI.dialog('#FindWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
	
	var Clear = function() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(RetMainGrid);
		$UI.clear(RetDetailGrid);
		var LocId = $('#RetLoc').combobox('getValue');
		var LocDesc = $('#RetLoc').combobox('getText');
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			RetLoc: { RowId: LocId, Description: LocDesc },
			AuditFlag: 'N',
			HvFlag: gHVInRet ? 'Y' : 'N'
		};
		$UI.fillBlock('#FindConditions', DefaultData);
	};
	$UI.linkbutton('#FQueryBT', {
		onClick: function() {
			FQuery();
		}
	});
	function FQuery() {
		$UI.clear(RetDetailGrid);
		var ParamsObj = $UI.loopBlock('#FindConditions');
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '开始日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.RetLoc)) {
			$UI.msg('alert', '退货科室不能为空!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		RetMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINGdRet',
			QueryName: 'DHCINGdRet',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#FComBT', {
		onClick: function() {
			var Row = RetMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要返回的退货单!');
				return;
			}
			Fn(Row.RowId);
			$HUI.dialog('#FindWin').close();
		}
	});
	$UI.linkbutton('#FClearBT', {
		onClick: function() {
			Clear();
		}
	});

	var FRetLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var FRetLocBox = $HUI.combobox('#FRetLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FRetLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			if (CommParObj.ApcScg == 'L') {
				FVendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M', LocId: LocId }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
				FVendorBox.reload(url);
			}
		}
	});
	var FVendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var FVendorBox = $HUI.combobox('#FVendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FVendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var RetMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '退货单号',
			field: 'RetNo',
			width: 150
		}, {
			title: '供应商',
			field: 'VendorName',
			width: 150
		}, {
			title: '退货科室',
			field: 'RetLocDesc',
			width: 150
		}, {
			title: '制单人',
			field: 'RetUserName',
			width: 70
		}, {
			title: '制单日期',
			field: 'RetDate',
			width: 90
		}, {
			title: '制单时间',
			field: 'RetTime',
			width: 80
		}, {
			title: '完成状态',
			field: 'Completed',
			width: 80,
			formatter: BoolFormatter
		}, {
			title: '备注',
			field: 'Remark',
			width: 100
		}
	]];
	
	var RetMainGrid = $UI.datagrid('#RetMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRet',
			QueryName: 'DHCINGdRet',
			query2JsonStrict: 1
		},
		columns: RetMainCm,
		showBar: true,
		onSelect: function(index, row) {
			var ParamsObj = { RefuseFlag: 1 };
			var Params = JSON.stringify(ParamsObj);
			RetDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGrtItm',
				QueryName: 'DHCINGdRetItm',
				query2JsonStrict: 1,
				RetId: row.RowId
			});
		},
		onDblClickRow: function(index, row) {
			Fn(row.RowId);
			$HUI.dialog('#FindWin').close();
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	
	var RetDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: 'Ingri',
			field: 'Ingri',
			width: 100,
			hidden: true
		}, {
			title: 'Inci',
			field: 'Inci',
			width: 100,
			hidden: true
		}, {
			title: 'Inclb',
			field: 'Inclb',
			width: 100,
			hidden: true
		}, {
			title: '物资代码',
			field: 'Code',
			width: 100
		}, {
			title: '物资名称',
			field: 'Description',
			width: 150
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 150
		}, {
			title: '批号',
			field: 'BatNo',
			width: 100
		}, {
			title: '效期',
			field: 'ExpDate',
			width: 120
		}, {
			title: '批次库存',
			field: 'StkQty',
			width: 100,
			align: 'right'
		}, {
			title: '退货数量',
			field: 'Qty',
			width: 100,
			align: 'right'
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 100
		}, {
			title: '退货原因',
			field: 'Reason',
			width: 100
		}, {
			title: '退货进价',
			field: 'Rp',
			width: 100,
			align: 'right'
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '发票号',
			field: 'InvNo',
			width: 100,
			align: 'left'
		}, {
			title: '发票日期',
			field: 'InvDate',
			width: 100,
			align: 'left'
		}, {
			title: '发票金额',
			field: 'InvAmt',
			width: 100,
			align: 'right'
		}, {
			title: '零售单价',
			field: 'Sp',
			width: 100,
			align: 'right'
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '备注',
			field: 'Remark',
			width: 200,
			align: 'left'
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			width: 100,
			align: 'left',
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: '高值标志',
			field: 'HvFlag',
			width: 80,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: '随行单号',
			field: 'SxNo',
			width: 200,
			align: 'left'
		}
	]];
	var RetDetailGrid = $UI.datagrid('#RetDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGrtItm',
			QueryName: 'DHCINGdRetItm',
			query2JsonStrict: 1
		},
		columns: RetDetailCm,
		showBar: true
	});
	Clear();
	FQuery();
};