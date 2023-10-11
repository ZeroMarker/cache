var init = function() {
	var IngrLocBox = $HUI.combobox('#IngrLoc', {
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='
			+ JSON.stringify(addSessionParams({
				Type: 'Login'
			})),
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$('#PayUser').combobox('clear');
			$('#PayUser').combobox('reload', $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=Array&Params='
			+ JSON.stringify({
				LocDr: LocId
			}));
		}
	});

	var UserBox = $HUI.combobox('#PayUser', {
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=Array&Params='
			+ JSON.stringify({
				LocDr: gLocId
			}),
		valueField: 'RowId',
		textField: 'Description'
	});

	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		$UI.clear(PayCoverGrid);
		$UI.clear(GRMainGrid);
		var ParamsObj = $UI.loopBlock('#MainConditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (isEmpty(ParamsObj.IngrLoc)) {
			$UI.msg('alert', '入库科室不能为空!');
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
		var Params = JSON.stringify(ParamsObj);
		PayCoverGrid.load({
			ClassName: 'web.DHCSTMHUI.PayCover',
			QueryName: 'DHCPayCover',
			query2JsonStrict: 1,
			Params: Params
		});
	}

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clearBlock('#MainConditions');
			$UI.clear(PayCoverGrid);
			$UI.clear(GRMainGrid);
			SetDefaValues();
		}
	});

	var PayCoverCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '付款封面单号',
			field: 'CoverNo',
			width: 200
		}, {
			title: '制单人',
			field: 'CreateUser',
			width: 150
		}, {
			title: '日期',
			field: 'CreateDate',
			width: 150
		}, {
			title: '月份',
			field: 'Month',
			width: 100
		}, {
			title: '票据张数',
			field: 'VoucherCount',
			width: 100,
			align: 'right'
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 150,
			align: 'right'
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width: 150,
			align: 'right'
		}
	]];

	var ToolBar = [
		{
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function() {
				Delete();
			}
		}, '-', {
			text: '打印(按库存分类)',
			iconCls: 'icon-print',
			handler: function() {
				var Rows = PayCoverGrid.getSelections();
				if (Rows.length <= 0) {
					$UI.msg('alert', '请选择要打印的单据!');
					return;
				}
				for (var i = 0; i < Rows.length; i++) {
					var record = Rows[i];
					PrintPayCoverByIncsc(record.RowId);
				}
			}
		}, {
			text: '打印(按供应商)',
			iconCls: 'icon-print',
			handler: function() {
				var Rows = PayCoverGrid.getSelections();
				if (Rows.length <= 0) {
					$UI.msg('alert', '请选择要打印的单据!');
					return;
				}
				for (var i = 0; i < Rows.length; i++) {
					var record = Rows[i];
					PrintPayCoverByVendor(record.RowId);
				}
			}
		}
	];

	var PayCoverGrid = $UI.datagrid('#PayCoverGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.PayCover',
			QueryName: 'DHCPayCover',
			query2JsonStrict: 1
		},
		toolbar: ToolBar,
		columns: PayCoverCm,
		fitColumns: true,
		showBar: true,
		singleSelect: false,
		onSelect: function(index, row) {
			GRMainGrid.load({
				ClassName: 'web.DHCSTMHUI.PayCoverItm',
				QueryName: 'QueryCoverRec',
				query2JsonStrict: 1,
				CoverId: row.RowId
			});
		},
		onLoadSuccess: function(data) {
			if ((data.rows.length > 0) && (CommParObj.IfSelFirstRow == 'Y')) {
				PayCoverGrid.selectRow(0);
			}
		}
	});

	var GRMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '入库退货单号',
			field: 'GRNo',
			width: 200
		}, {
			title: '类型',
			field: 'Type',
			width: 100,
			formatter: function(value, row, index) {
				if (value == 'G') {
					return '入库';
				} else {
					return '退货';
				}
			}
		}, {
			title: '供应商',
			field: 'VendorDesc',
			width: 200
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 150,
			align: 'right'
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width: 150,
			align: 'right'
		}
	]];

	var GRMainGrid = $UI.datagrid('#GRMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.PayCoverItm',
			QueryName: 'QueryCoverRec',
			query2JsonStrict: 1
		},
		columns: GRMainCm,
		fitColumns: true,
		showBar: true
	});
	function Delete() {
		var Rows = PayCoverGrid.getSelections();
		if (Rows.length <= 0) {
			$UI.msg('alert', '请选择要删除的单据!');
			return;
		}
		var Params = PayCoverGrid.getSelectedData();
		$.cm({
			ClassName: 'web.DHCSTMHUI.PayCover',
			MethodName: 'Delete',
			Params: JSON.stringify(Params)
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				$UI.clear(PayCoverGrid);
				$UI.clear(GRMainGrid);
				PayCoverGrid.commonReload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	SetDefaValues();
	Query();
};
$(init);