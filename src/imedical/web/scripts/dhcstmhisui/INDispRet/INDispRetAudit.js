var init = function() {
	var LocParams = JSON.stringify(addSessionParams({
		Type: 'Login',
		Element: 'LocId',
		LoginLocType: 2
	}));
	var LocBox = $HUI.combobox('#LocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	var MainCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '单号',
			field: 'DsrNo',
			width: 150
		}, {
			title: '科室',
			field: 'LocDesc',
			width: 200
		}, {
			title: '制单人',
			field: 'CreateUser',
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
			title: '审核人',
			field: 'AuditUser',
			width: 100
		}, {
			title: '审核日期',
			field: 'AuditDate',
			width: 100
		}, {
			title: '审核时间',
			field: 'AuditTime',
			width: 100
		}
	]];

	var MainGrid = $UI.datagrid('#MainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispRet',
			QueryName: 'DHCINDispRet',
			query2JsonStrict: 1
		},
		singleSelect: false,
		columns: MainCm,
		showBar: true,
		fitColumns: true,
		onSelect: function(index, row) {
			$UI.clear(DetailGrid);
			DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINDispRetItm',
				QueryName: 'DHCINDispRetItm',
				query2JsonStrict: 1,
				Parref: row.RowId,
				rows: 99999
			});
		},
		onLoadSuccess: function(data) {
			if ((data.rows.length > 0) && (CommParObj.IfSelFirstRow == 'Y')) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});

	var DetailCm = [[
		{
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
			title: '有效期',
			field: 'ExpDate',
			width: 100
		}, {
			title: '退回数量',
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
			title: '发放单号',
			field: 'IndsNo',
			width: 200
		}, {
			title: '请领单号',
			field: 'DsrqNo',
			width: 200
		}
	]];

	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispRetItm',
			QueryName: 'DHCINDispRetItm',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		columns: DetailCm,
		showBar: true
	});

	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('#MainConditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (isEmpty(ParamsObj.LocId)) {
			$UI.msg('alert', '科室不能为空!');
			return;
		}
		if (isEmpty(StartDate)) {
			$UI.msg('alert', '开始日期不能为空!');
			return;
		}
		if (isEmpty(EndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		if (compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '截止日期不能小于开始日期!');
			return;
		}
		ParamsObj.CompFlag = 'Y';
		var Params = JSON.stringify(ParamsObj);
		MainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINDispRet',
			QueryName: 'DHCINDispRet',
			query2JsonStrict: 1,
			Params: Params
		});
	}

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clearBlock('#MainConditions');
			$UI.clear(MainGrid);
			$UI.clear(DetailGrid);
			SetDefaValues();
		}
	});

	$UI.linkbutton('#AuditBT', {
		onClick: function() {
			var Rows = MainGrid.getSelections();
			if (Rows.length <= 0) {
				$UI.msg('alert', '请选择要审核的单据!');
				return;
			}
			var ParamsObj = $UI.loopBlock('#MainConditions');
			var Main = JSON.stringify(ParamsObj);
			var Detail = MainGrid.getSelectedData();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINDispRet',
				MethodName: 'jsAudit',
				Main: Main,
				Detail: JSON.stringify(Detail)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					$UI.clear(MainGrid);
					$UI.clear(DetailGrid);
					MainGrid.commonReload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var Rows = MainGrid.getSelections();
			if (Rows.length <= 0) {
				$UI.msg('alert', '请选择要打印的单据!');
				return;
			}
			for (var i = 0; i < Rows.length; i++) {
				var record = Rows[i];
				PrintINDispRet(record.RowId);
			}
		}
	});
	
	SetDefaValues();
	Query();
};
$(init);