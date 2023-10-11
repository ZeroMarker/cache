var InvDetailWin = function(InvId, IngrLoc, VendorId, Fn) {
	$HUI.dialog('#InvDetailWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();

	var FVVendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var FVVendorBox = $HUI.combobox('#FVVendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FVVendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	var GRMainCm = [[
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
		}
	]];

	var GRMainGrid = $UI.datagrid('#GRMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			QueryName: 'GetIngdRec',
			query2JsonStrict: 1
		},
		columns: GRMainCm,
		showBar: true,
		singleSelect: false,
		onSelectChangeFn: function() {
			Select();
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				GRMainGrid.selectRow(0);
				// Select();
			}
		}
	});

	var GRDetailCm = [[
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

	var GRDetailGrid = $UI.datagrid('#GRDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			QueryName: 'GetIngdRecItm',
			query2JsonStrict: 1
		},
		columns: GRDetailCm,
		showBar: true,
		singleSelect: false,
		pagination: false,
		onCheck: function(index, row) {
			TotalAmt();
		},
		onUncheck: function(index, Row) {
			TotalAmt();
		},
		onCheckAll: function(rows) {
			TotalAmt();
		},
		onUncheckAll: function(rows) {
			TotalAmt();
		}
	});

	$UI.linkbutton('#FVQueryBT', {
		onClick: function() {
			FQuery();
		}
	});
	function FQuery() {
		var ParamsObj = $UI.loopBlock('#FVConditions');
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
		ParamsObj.LocId = IngrLoc;
		ParamsObj.Vendor = VendorId;
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(GRMainGrid);
		$UI.clear(GRDetailGrid);
		GRMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			QueryName: 'GetIngdRec',
			query2JsonStrict: 1,
			Params: Params
		});
	}

	$UI.linkbutton('#FVSaveBT', {
		onClick: function() {
			var MainRows = GRMainGrid.getSelections();
			if (MainRows.length <= 0) {
				$UI.msg('alert', '请选择要组合的入库退货单!');
				return;
			}
			var DetailRows = GRDetailGrid.getSelections();
			if (DetailRows.length <= 0) {
				$UI.confirm('未选择明细，是否按照单据绑定?', '', '', Save);
			} else {
				var TotalAmt = $('#TotalRpAmt').val();
				if (TotalAmt == '' || TotalAmt == 0) {
					$UI.msg('alert', '组合的入库退货单进价总额为零!');
					return;
				}
				Save(DetailRows);
			}
		}
	});
	function Save(DetailRows) {
		if (isEmpty(DetailRows)) {
			DetailRows = GRDetailGrid.getRows();
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
		var jsonData = $.cm({
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			MethodName: 'SelectInvInfo',
			RowId: InvId
		}, false);
		var InvAmt = jsonData.InvAmt;
		var AlreadyAmt = jsonData.RpAmt;
		var LeftAmt = accSub(Number(InvAmt), Number(AlreadyAmt));
		if ((Number(InvAmt) > 0) && ((LeftAmt <= 0) || (TotalAmt > LeftAmt))) {
			// 未维护发票金额的,暂不做控制
			$UI.msg('alert', '当前绑定已超出发票金额，不能再进行绑定!');
			return;
		}
		
		var Detail = JSON.stringify(DetailRows);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			MethodName: 'jsSaveByItm',
			InvId: InvId,
			LocId: IngrLoc,
			Detail: Detail
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				$HUI.dialog('#InvDetailWin').close();
				Fn(InvId);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	$UI.linkbutton('#FVClearBT', {
		onClick: function() {
			Clear();
		}
	});
	
	function Select() {
		var Rows = GRMainGrid.getSelections();
		if (Rows.length <= 0) {
			$UI.clear(GRDetailGrid);
			return;
		}
		GRDetailGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			QueryName: 'GetIngdRecItm',
			query2JsonStrict: 1,
			Params: JSON.stringify(Rows),
			rows: 9999
		});
	}
	
	function Clear() {
		$UI.clearBlock('#FVConditions');
		$UI.clear(GRMainGrid);
		$UI.clear(GRDetailGrid);
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate()
		};
		$UI.fillBlock('#FVConditions', DefaultData);
	}
	
	function TotalAmt() {
		var TotalAmt = '';
		var Rows = GRDetailGrid.getChecked();
		for (var i = 0; i < Rows.length; i++) {
			var RpAmt = Rows[i].RpAmt;
			TotalAmt = accAdd(Number(TotalAmt), Number(RpAmt));
		}
		$('#TotalRpAmt').val(TotalAmt);
	}
	
	Clear();
	FQuery();
};