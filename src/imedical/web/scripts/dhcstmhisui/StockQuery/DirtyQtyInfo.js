function DirtyQtyQuery(Inclb) {
	var DirtyQtyCm = [[
		{
			title: 'Rowid',
			field: 'Rowid',
			width: 50,
			sortable: true,
			hidden: true
		}, {
			title: '����',
			field: 'No',
			width: 150
		}, {
			title: '����',
			field: 'Qty',
			width: 150,
			align: 'right'
		}, {
			title: '��λ',
			field: 'Uom',
			width: 150
		}, {
			title: '��������',
			field: 'Date',
			width: 150
		}, {
			title: '��������',
			field: 'Type',
			width: 150,
			formatter: function(value, row, index) {
				if (value == 'T') {
					return '���ⵥ';
				} else if (value == 'R') {
					return '�˻���';
				} else if (value == 'C') {
					return '���ҷ��ŵ�';
				} else if (value == 'D') {
					return '����';
				}
			}
		}
	]];
	var DirtyQtyGrid = $UI.datagrid('#DirtyQtyGrid', {
		lazy: true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmStk',
			MethodName: 'GetDirtyQtyInfo'
		},
		columns: DirtyQtyCm,
		showBar: true,
		navigatingWithKey: true,
		fitColumns: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	$HUI.dialog('#DirtyQtyInfoWin', {
		height: gWinHeight,
		width: gWinWidth,
		onOpen: function() {
			DirtyQtyGrid.load({
				ClassName: 'web.DHCSTMHUI.LocItmStk',
				MethodName: 'GetDirtyQtyInfo',
				Inclb: Inclb
			});
		}
	}).open();
}