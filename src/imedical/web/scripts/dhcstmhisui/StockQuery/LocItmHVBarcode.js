function HVBarcodeQuery(Incil) {
	var FHVBarCodeInfoCm = [[
		{
			title: '����ID',
			field: 'dhcit',
			width: 50,
			sortable: true,
			hidden: true
		}, {
			title: '����',
			field: 'HVBarCode',
			width: 200
		}, {
			title: '����',
			field: 'BatchNo',
			width: 120,
			sortable: true
		}, {
			title: 'Ч��',
			field: 'ExpDate',
			width: 100
		}, {
			title: '�������',
			field: 'IngrDate',
			width: 100
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 120,
			align: 'left'
		}, {
			title: '��������',
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