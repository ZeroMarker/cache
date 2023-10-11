var init = function() {
	$HUI.combobox('#CardType', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCardType&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function() { // 数据加载完毕事件
			var data = $('#CardType').combobox('getData');
			var Default = '';
			if (data.length > 0) {
				for (i = 0; i <= data.length; i++) {
					Default = data[i].Default;
					if (Default == 'Y') {
						$('#CardType').combobox('select', data[i].RowId);
						return;
					}
				}
			}
		},
		onSelect: function(record) {
			
		}
	});
	
	$('#PatNo').bind('keydown', function(event) {
		if (event.keyCode == 13) {
			var PatNo = $(this).val();
			if (isEmpty(PatNo)) {
				$UI.msg('alert', '请输入登记号!');
				return false;
			}
			try {
				var patinfostr = tkMakeServerCall('web.DHCSTMHUI.HVMatOrdItm', 'Pa', PatNo);
				var patinfoarr = patinfostr.split('^');
				var newPaAdmNo = patinfoarr[0];
				$('#PatNo').val(newPaAdmNo);
			} catch (e) {}
		}
	});
	
	$('#CardNo').bind('keydown', function(event) {
		if (event.keyCode == 13) {
			var CardType = $('#CardType').combobox('getValue');
			BtnReadCardHandler(CardType, 'CardNo', 'PatNo');
		}
	});
	
	$UI.linkbutton('#ReadCardBT', {
		onClick: function() {
			var CardType = $('#CardType').combobox('getValue');
			BtnReadCardHandler(CardType, 'CardNo', 'PatNo');
		}
	});
	
	$UI.linkbutton('#AlQueryBT', {
		onClick: function() {
			FindRetWin();
		}
	});
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		$UI.clear(ReturnMainGrid);
		$UI.clear(ReturnDetailGrid);
		var ParamsObj = $UI.loopBlock('#MainConditions');
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
		ReturnMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCMatReturn',
			QueryName: 'QueryMatReturn',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	function DefaultClear() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(ReturnDetailGrid);
		$UI.clear(ReturnMainGrid);
		Default();
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			DefaultClear();
		}
	});
	
	$UI.linkbutton('#ReturnBT', {
		onClick: function() {
			if (CheckBeforeReturn()) {
				Return();
			}
		}
	});
	
	function CheckBeforeReturn() {
		if (!ReturnDetailGrid.endEditing()) {
			return false;
		}
		var DetailRowsData = ReturnDetailGrid.getRows();
		if (DetailRowsData.length == 0) {
			$UI.msg('alert', '请选择要退回的明细！');
			return false;
		}
		var count = 0;
		for (var i = 0; i < DetailRowsData.length; i++) {
			var Qty = Number(DetailRowsData[i].Qty);
			var LeftQty = Number(DetailRowsData[i].LeftQty);
			var ReqQty = Number(DetailRowsData[i].ReqQty);
			var ReqFalg = DetailRowsData[i].ReqFalg;
			if (!isEmpty(Qty) && (Qty != 0)) {
				if (Qty < 0) {
					$UI.msg('alert', '退回数量不能小于0');
					return false;
				}
				if (Qty > LeftQty) {
					$UI.msg('alert', '退回数量不能超过可退回数量');
					return false;
				}
				if ((ReqFalg == 'Y') && (Qty > ReqQty)) {
					$UI.msg('alert', '退回数量不能超过申请退回数量');
					return false;
				}
				count = count + 1;
			}
		}
		if (count == 0) {
			$UI.msg('alert', '没有需要退回的明细');
			return false;
		}
		return true;
	}
	
	function Return() {
		var DetailRowsData = ReturnDetailGrid.getRows();
		var Main = JSON.stringify(sessionObj);
		var Detail = JSON.stringify(DetailRowsData);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCMatReturn',
			MethodName: 'jsMatReturn',
			Main: Main,
			Detail: Detail
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	/* --Grid--*/
	// /退回列表
	var ReturnMainGridCm = [[
		{
			title: 'DispId',
			field: 'DispId',
			width: 60,
			hidden: true
		}, {
			title: '病人id',
			field: 'PatId',
			width: 80,
			hidden: true
		}, {
			title: '姓名',
			field: 'PatName',
			width: 80
		}, {
			title: '登记号',
			field: 'PatNo',
			width: 100
		}, {
			title: '申请人',
			field: 'ReqUserName',
			width: 100
		}, {
			title: '申请日期',
			field: 'ReqDate',
			width: 100
		}, {
			title: '申请时间',
			field: 'ReqTime',
			width: 100
		}
	]];

	var ReturnMainGrid = $UI.datagrid('#ReturnMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCMatReturn',
			QueryName: 'QueryMatReturn',
			query2JsonStrict: 1
		},
		showBar: true,
		singleSelect: true,
		columns: ReturnMainGridCm,
		onClickRow: function(index, row) {
			ReturnMainGrid.commonClickRow(index, row);
		},
		onSelect: function(index, row) {
			var Params = JSON.stringify(addSessionParams({ DispId: row.DispId }));
			ReturnDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCMatReturn',
				QueryName: 'QueryMatReturnDetail',
				query2JsonStrict: 1,
				Params: Params,
				rows: 99999
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				ReturnMainGrid.selectRow(0);
			}
		}
	});
	
	// /发放列表明细
	var ReturnDetailGridCm = [[
		{
			title: 'DispDetailId',
			field: 'DispDetailId',
			width: 60,
			hidden: true
		}, {
			title: '就诊id',
			field: 'Adm',
			width: 80,
			hidden: true
		}, {
			title: '医嘱明细id',
			field: 'Oeori',
			width: 80,
			hidden: true
		}, {
			title: '库存项id',
			field: 'InciId',
			width: 100,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 100
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 150
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 80
		}, {
			title: '单价',
			field: 'Sp',
			width: 80,
			align: 'right'
		}, {
			title: '退回数量',
			field: 'Qty',
			width: 100,
			align: 'right',
			necessary: true,
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: GetFmtNum('FmtQTY')
				}
			}
		}, {
			title: '可退回数量',
			field: 'LeftQty',
			width: 100,
			align: 'right'
		}, {
			title: '申请退回数量',
			field: 'ReqQty',
			width: 100,
			align: 'right'
		}, {
			title: '可退回金额',
			field: 'LeftSpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '申请退回金额',
			field: 'ReqSpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '批号',
			field: 'BatNo',
			width: 100
		}, {
			title: '单位',
			field: 'UomId',
			width: 100,
			hidden: true
		}, {
			title: '高值条码',
			field: 'Barcode',
			width: 100
		}, {
			title: '退费申请标志',
			field: 'ReqFalg',
			width: 100
		}
	]];

	var ReturnDetailGrid = $UI.datagrid('#ReturnDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCMatReturn',
			QueryName: 'QueryMatReturnDetail',
			query2JsonStrict: 1,
			rows: 99999
		},
		showBar: true,
		columns: ReturnDetailGridCm,
		pagination: false,
		onClickRow: function(index, row) {
			ReturnDetailGrid.commonClickRow(index, row);
		},
		onEndEdit: function(index, row, changes) {
			if (changes.hasOwnProperty('Qty')) {
				var Qty = row.Qty;
				if (!isEmpty(Qty)) {
					if (Qty < 0) {
						$UI.msg('alert', '退回数量不能小于0!');
						return false;
					}
				}
			}
		}
	});
	
	/* --设置初始值--*/
	var Default = function() {
		// /设置初始值 考虑使用配置
		var DefaultValue = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date())
		};
		$UI.fillBlock('#MainConditions', DefaultValue);
	};
	Default();
	Query();
};
$(init);
	