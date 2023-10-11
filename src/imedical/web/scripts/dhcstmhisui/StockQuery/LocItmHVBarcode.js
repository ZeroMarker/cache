function HVBarcodeQuery(Incil) {
	var FHVBarCodeInfoCm = [[
		{
			title: '条码ID',
			field: 'dhcit',
			width: 50,
			sortable: true,
			hidden: true
		}, {
			title: '条码',
			field: 'HVBarCode',
			width: 200
		}, {
			title: '批号',
			field: 'BatchNo',
			width: 120,
			sortable: true
		}, {
			title: '效期',
			field: 'ExpDate',
			width: 100
		}, {
			title: '入库日期',
			field: 'IngrDate',
			width: 100
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 120,
			align: 'left'
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 200
		}
	]];
	var FHVBarCodeInfoGrid = $UI.datagrid('#FHVBarCodeInfoGrid', {
		lazy: true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			MethodName: 'GetEnableBarcodes'
		},
		columns: FHVBarCodeInfoCm,
		fitColumns: true,
		showBar: true,
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	$HUI.dialog('#HVBarcodeInfoWin', {
		height: gWinHeight,
		width: gWinWidth,
		onOpen: function() {
			FHVBarCodeInfoGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCItmTrack',
				MethodName: 'GetEnableBarcodes',
				incil: Incil
			});
		}
	}).open();
}