/*
订单查询
*/
var ImportPoSearch = function(Fn, LocObj) {
	$HUI.dialog('#ImportByPo', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
	
	var Clear = function() {
		$UI.clearBlock('#ImportByPoConditions');
		$UI.clear(PoMainGrid);
		$UI.clear(PoDetailGrid);
		
		var DefaPoData = {
			PoStartDate: TrackDefaultStDate(),
			PoEndDate: TrackDefaultEdDate(),
			PoRecLoc: LocObj
		};
		$UI.fillBlock('#ImportByPoConditions', DefaPoData);
	};
	
	var PRecLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var PRecLocBox = $HUI.combobox('#PoRecLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PRecLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var PVendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var VendorBox = $HUI.combobox('#PoVendorBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + PVendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#PoQueryBT', {
		onClick: function() {
			PoQuery();
		}
	});
	function PoQuery() {
		$UI.clear(PoMainGrid);
		$UI.clear(PoDetailGrid);
		var ParamsObj = $CommonUI.loopBlock('#ImportByPoConditions');
		var StartDate = ParamsObj.PoStartDate;
		var EndDate = ParamsObj.PoEndDate;
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
		PoMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'QueryPo',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	$UI.linkbutton('#PoClearBT', {
		onClick: function() {
			Clear();
		}
	});
	function ReturnPo() {
		var Row = PoMainGrid.getSelected();
		if (isEmpty(Row)) {
			$UI.msg('alert', '请选择要返回的订单!');
			return;
		}
		var VendorId = Row.VendorId;
		var VendorDesc = Row.VendorDesc;
		var rowsData = PoDetailGrid.getRowsData();	// 取grid所有记录
		Fn(rowsData, VendorId, VendorDesc);
		$HUI.dialog('#ImportByPo').close();
	}
	$UI.linkbutton('#PoReturnBT', {
		onClick: function() {
			ReturnPo();
		}
	});
	var PoMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '订单单号',
			field: 'PoNo',
			width: 120
		}, {
			title: '供应商id',
			field: 'VendorId',
			width: 50,
			hidden: true
		}, {
			title: '供应商',
			field: 'VendorDesc',
			width: 150
		}, {
			title: '订购科室',
			field: 'PoLocDesc',
			width: 150
		}, {
			title: '申购科室',
			field: 'ReqLocDesc',
			width: 150
		}, {
			title: '订单日期',
			field: 'PoDate',
			width: 90
		}
	]];
	
	var PoMainGrid = $UI.datagrid('#PoMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'QueryPo',
			query2JsonStrict: 1
		},
		columns: PoMainCm,
		onSelect: function(index, row) {
			PoDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCItmTrack',
				QueryName: 'INPOItmQuery',
				query2JsonStrict: 1,
				Parref: row.RowId
			});
		},
		onDblClickRow: function(index, row) {
			ReturnPo();
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				PoMainGrid.selectRow(0);
			}
		}
	});
	
	var PoDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '物资id',
			field: 'InciId',
			hidden: true,
			width: 80
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 80
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 200
		}, {
			title: '规格',
			field: 'Spec',
			width: 80
		}, {
			title: '数量',
			field: 'AvaQty',
			align: 'right',
			width: 60
		}, {
			title: '进价',
			field: 'Rp',
			align: 'right',
			width: 60
		}, {
			title: '单位id',
			field: 'UomId',
			width: 50,
			hidden: true
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 50
		}, {
			title: '订购数量',
			field: 'PurQty',
			align: 'right',
			width: 90
		}, {
			title: '已入库数量',
			field: 'ImpQty',
			align: 'right',
			width: 90
		}, {
			title: '注册证号码',
			field: 'CertNo',
			width: 90
		}, {
			title: '注册证效期',
			field: 'CertExpDate',
			width: 90
		}, {
			title: '生产厂家id',
			field: 'ManfId',
			width: 90,
			hidden: true
		}, {
			title: '生产厂家',
			field: 'ManfDesc',
			width: 90
		}, {
			title: '批次码标志',
			field: 'BatchCodeFlag',
			width: 100,
			hidden: false,
			align: 'center'
		}
	]];
	
	var PoDetailGrid = $UI.datagrid('#PoDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'INPOItmQuery',
			query2JsonStrict: 1
		},
		columns: PoDetailCm
	});
	Clear();
	PoQuery();
};