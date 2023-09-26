function DirtyQtyQuery(Inclb){
	var DirtyQtyCm = [[{
			title: 'Rowid',
			field: 'Rowid',
			width: 50,
			sortable: true,
			hidden: true
		}, {
			title: '单号',
			field: 'No',
			width: 150
		}, {
			title: '数量',
			field: 'Qty',
			width: 150,
			align: 'right'
		}, {
			title: '单位',
			field: 'Uom',
			width: 150
		}, {
			title: '单据日期',
			field: 'Date',
			width: 150
		}, {
			title: '单据类型',
			field: 'Type',
			width: 150,
			formatter: function (value, row, index) {
				if(value=='T'){
					return '出库单';
				}else if(value=='R'){
					return '退货单';
				}else if(value=='C'){
					return '科室发放单';
				}
			}
		}
	]];
	var DirtyQtyGrid = $UI.datagrid('#DirtyQtyGrid', {
		lazy:true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmStk',
			MethodName: 'GetDirtyQtyInfo'
		},
		columns: DirtyQtyCm,
		showBar:true
	});
	$HUI.dialog('#DirtyQtyInfoWin',{
		onOpen: function(){
			DirtyQtyGrid.load({
				ClassName: 'web.DHCSTMHUI.LocItmStk',
				MethodName: 'GetDirtyQtyInfo',
				Inclb:Inclb
			});
		}
	}).open();
}