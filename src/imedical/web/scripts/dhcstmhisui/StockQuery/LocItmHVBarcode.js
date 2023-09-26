function HVBarcodeQuery(Incil){
	var FHVBarCodeInfoCm = [[{
			title: '条码ID',
			field: 'dhcit',
			width: 50,
			sortable: true,
			hidden: true
		}, {
			title: '条码',
			field: 'HVBarCode',
			width: 150
		}, {
			title: '批号',
			field: 'BatchNo',
			width: 150,
			sortable: true
		}, {
			title: '效期',
			field: 'ExpDate',
			width: 150
		}, {
			title: '入库日期',
			field: 'IngrDate',
			width: 150
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 150,
			align: 'left'
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 200
		}
	]];
	var FHVBarCodeInfoGrid = $UI.datagrid('#FHVBarCodeInfoGrid', {
		lazy:true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			MethodName: 'GetEnableBarcodes'
		},
		columns: FHVBarCodeInfoCm,
		showBar:true
	});
	$HUI.dialog('#HVBarcodeInfoWin',{
		onOpen: function(){
			FHVBarCodeInfoGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCItmTrack',
				MethodName: 'GetEnableBarcodes',
				incil:Incil
			});
		}
	}).open();
}

