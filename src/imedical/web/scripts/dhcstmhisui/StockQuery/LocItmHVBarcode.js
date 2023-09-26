function HVBarcodeQuery(Incil){
	var FHVBarCodeInfoCm = [[{
			title: '����ID',
			field: 'dhcit',
			width: 50,
			sortable: true,
			hidden: true
		}, {
			title: '����',
			field: 'HVBarCode',
			width: 150
		}, {
			title: '����',
			field: 'BatchNo',
			width: 150,
			sortable: true
		}, {
			title: 'Ч��',
			field: 'ExpDate',
			width: 150
		}, {
			title: '�������',
			field: 'IngrDate',
			width: 150
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 150,
			align: 'left'
		}, {
			title: '��������',
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

