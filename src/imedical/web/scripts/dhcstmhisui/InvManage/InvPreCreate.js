var InvVenId = '';
var CreateWin = function(Fn) {
	$HUI.dialog('#CreateWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();

	var CVendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var CVendorBox = $HUI.combobox('#CVendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + CVendorParams,
		valueField: 'RowId',
		textField: 'Description',
		onChange: function(newValue, oldValue) {
			InvVenId = newValue;
		}
	});
	var CLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	$HUI.combobox('#CLocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + CLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var CGRMainCm = [[
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
			field: 'GRNo',
			width: 150
		}, {
			title: '供应商',
			field: 'VendorDesc',
			width: 100
		}, {
			title: '类型',
			field: 'Type',
			width: 70,
			saveCol: true,
			formatter: function(value, row, index) {
				if (value == 'G') {
					return '入库';
				} else {
					return '退货';
				}
			}
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width: 100,
			align: 'right'
		}, {
			title: 'Vendor',
			field: 'Vendor',
			width: 100,
			saveCol: true,
			hidden: true
		}
	]];

	var CGRMainGrid = $UI.datagrid('#CGRMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			QueryName: 'GetIngdRec',
			query2JsonStrict: 1
		},
		columns: CGRMainCm,
		showBar: true,
		singleSelect: false,
		checkOnSelect: true,
		onBeforeCheck: function(index, row) {
			var RowVendorId = row['Vendor'];
			if (!isEmpty(InvVenId) && !isEmpty(RowVendorId) && InvVenId != RowVendorId) {
				$UI.msg('alert', '第' + (index + 1) + '行供应商与发票供应商不一致,请核实!');
				return false;
			}
		},
		onCheck: function(index, row) {
			var RowVendorId = row['Vendor'];
			var RowVendorDesc = row['VendorDesc'];
			if (isEmpty(InvVenId) && !isEmpty(RowVendorId)) {
				AddComboData($('#CVendor'), RowVendorId, RowVendorDesc);
				$('#CVendor').combobox('setValue', RowVendorId);
			}
			CSelect();
		},
		onUncheck: function(index, Row) {
			if (isEmpty($(this).datagrid('getChecked'))) {
				$('#CVendor').combobox('setValue', '');
			}
			CSelect();
		},
		onCheckAll: function(rows) {
			var RowVendorId = rows[0].Vendor;
			var RowVendorDesc = rows[0].VendorDesc;
			if (isEmpty(InvVenId) && !isEmpty(RowVendorId)) {
				AddComboData($('#CVendor'), RowVendorId, RowVendorDesc);
				$('#CVendor').combobox('setValue', RowVendorId);
			}
			var NullInfo = '', NullInfoArr = [];
			var vendor = $('#CVendor').combobox('getValue');
			for (var i = 0, Len = rows.length; i < Len; i++) {
				var RowData = rows[i];
				if (!isEmpty(RowData['Vendor']) && RowData['Vendor'] != vendor) {
					NullInfoArr.push(i + 1);
				}
				if (!isEmpty(NullInfoArr)) {
					NullInfo = NullInfoArr.join('、');
				}
			}
			if (!isEmpty(NullInfo)) {
				var MsgStr = '第' + NullInfo + '行供应商与发票供应商不同';
				$UI.msg('error', MsgStr);
				return false;
			}
			CSelect();
		},
		onUncheckAll: function(rows) {
			if (isEmpty($(this).datagrid('getChecked'))) {
				$('#CVendor').combobox('setValue', '');
			}
			$UI.clear(CGRDetailGrid);
		}
	});

	var CGRDetailCm = [[
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
			title: 'IncId',
			field: 'IncId',
			width: 50,
			hidden: true
		}, {
			title: '代码',
			field: 'Code',
			width: 120
		}, {
			title: '描述',
			field: 'Description',
			width: 150
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '数量',
			field: 'Qty',
			width: 100,
			align: 'right'
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 80
		}, {
			title: '进价',
			field: 'Rp',
			width: 100,
			align: 'right'
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 100,
			saveCol: true,
			align: 'right'
		}, {
			title: '售价',
			field: 'Sp',
			width: 100,
			align: 'right'
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width: 100,
			saveCol: true,
			align: 'right'
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 100
		}, {
			title: '类型',
			field: 'Type',
			align: 'center',
			saveCol: true,
			formatter: function(value, row, index) {
				if (value == 'G') {
					return '入库';
				} else {
					return '退货';
				}
			}
		}
	]];

	var CGRDetailGrid = $UI.datagrid('#CGRDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			QueryName: 'GetIngdRecItm',
			query2JsonStrict: 1
		},
		columns: CGRDetailCm,
		showBar: true,
		singleSelect: false,
		pagination: false,
		onCheck: function(index, row) {
			ComTotalAmt();
		},
		onUncheck: function(index, Row) {
			ComTotalAmt();
		},
		onCheckAll: function(rows) {
			ComTotalAmt();
		},
		onUncheckAll: function(rows) {
			ComTotalAmt();
		}
	});

	$UI.linkbutton('#CQueryBT', {
		onClick: function() {
			CQuery();
		}
	});
	function CQuery() {
		var ParamsObj = $UI.loopBlock('#CConditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
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
		$UI.clear(CGRMainGrid);
		$UI.clear(CGRDetailGrid);
		CGRMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			QueryName: 'GetIngdRec',
			query2JsonStrict: 1,
			Params: Params
		});
	}

	$UI.linkbutton('#CSaveBT', {
		onClick: function() {
			var MainRows = CGRMainGrid.getSelections();
			if (MainRows.length <= 0) {
				$UI.msg('alert', '请选择要组合的入库退货单!');
				return;
			}
			var DetailRows = CGRDetailGrid.getSelections();
			if (DetailRows.length <= 0) {
				$UI.confirm('未选择明细，是否按照单据绑定?', '', '', CSave);
			} else {
				var TotalAmt = $('#CTotalRpAmt').val();
				if (TotalAmt == '' || TotalAmt == 0) {
					$UI.msg('alert', '组合的入库退货单进价总额为零!');
					return;
				}
				CSave(DetailRows);
			}
		}
	});
	function CSave(DetailRows) {
		var ParamsObj = $UI.loopBlock('#CConditions');
		var LocId = ParamsObj.LocId;
		var Vendor = ParamsObj.Vendor;
		if (isEmpty(Vendor)) {
			$UI.msg('alert', '供应商不能为空!');
			return;
		}
		if (isEmpty(LocId)) {
			$UI.msg('alert', '科室不能为空!');
			return;
		}
		var Params = JSON.stringify(addSessionParams(ParamsObj));
		if (isEmpty(DetailRows)) {
			DetailRows = CGRDetailGrid.getRows();
		}
		var TotalAmt = 0;
		for (var i = 0; i < DetailRows.length; i++) {
			var RpAmt = DetailRows[i].RpAmt;
			TotalAmt = accAdd(Number(TotalAmt), Number(RpAmt));
		}
		if (TotalAmt == '' || TotalAmt == 0) {
			$UI.msg('alert', '组合的入库退货单进价总额为零!');
			return;
		}
		var Detail = JSON.stringify(DetailRows);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			MethodName: 'jsSaveByItm',
			InvId: '',
			LocId: LocId,
			Detail: Detail,
			Params: Params
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				var InvId = jsonData.rowid;
				$HUI.dialog('#CreateWin').close();
				InvVenId = '';
				Fn(InvId);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	$UI.linkbutton('#CClearBT', {
		onClick: function() {
			CClear();
		}
	});
	
	function CSelect() {
		var Rows = CGRMainGrid.getChecked();
		if (Rows.length <= 0) {
			$UI.clear(CGRDetailGrid);
			return;
		}
		var Params = CGRMainGrid.getSelectedData();
		CGRDetailGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			QueryName: 'GetIngdRecItm',
			query2JsonStrict: 1,
			Params: JSON.stringify(Params),
			rows: 9999
		});
	}
	
	function CClear() {
		$UI.clearBlock('#CConditions');
		$UI.clear(CGRMainGrid);
		$UI.clear(CGRDetailGrid);
		var LocId = $('#IngrLoc').combobox('getValue');
		var LocDesc = $('#IngrLoc').combobox('getText');
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			LocId: { RowId: LocId, Description: LocDesc }
		};
		$UI.fillBlock('#CConditions', DefaultData);
		InvVenId = '';
	}
	
	function ComTotalAmt() {
		var TotalAmt = '';
		var Rows = CGRDetailGrid.getChecked();
		for (var i = 0; i < Rows.length; i++) {
			var RpAmt = Rows[i].RpAmt;
			TotalAmt = accAdd(Number(TotalAmt), Number(RpAmt));
		}
		$('#CTotalRpAmt').val(TotalAmt);
	}
	
	CClear();
	CQuery();
};