function ReservedQtyQuery(Incil) {
	var ReservedQtyCm = [[
		{
			title: '类型',
			field: 'Type',
			width: 100,
			formatter: function(value, row, index) {
				var TypeDesc = value;
				if (value == 'DspBatch') {
					TypeDesc = '医嘱-批次在途';
				} else if (value == 'Oeori') {
					TypeDesc = '医嘱在途';
				} else if (value == 'Inrqi') {
					TypeDesc = '请求在途';
				}
				return TypeDesc;
			}
		}, {
			title: 'Pointer',
			field: 'Oeori',
			width: 100,
			sortable: true,
			hidden: true
		}, {
			title: '登记号',
			field: 'PatNo',
			width: 150
		}, {
			title: '姓名',
			field: 'PatName',
			width: 150
		}, {
			title: '医嘱科室',
			field: 'OrdLocDesc',
			width: 150
		}, {
			title: '数量',
			field: 'Qty',
			width: 60,
			align: 'right'
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 60
		}, {
			title: '日期',
			field: 'OrdDate',
			width: 100
		}, {
			title: '时间',
			field: 'OrdTime',
			width: 100
		}
	]];
	var RefreshReservedInfo = {
		text: '刷新',
		iconCls: 'icon-reload',
		handler: function() {
			ReservedQtyGrid.reload();
		}
	};
	var ReservedQtyGrid = $UI.datagrid('#ReservedQtyGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmStk',
			QueryName: 'GetReservedQtyInfo',
			query2JsonStrict: 1
		},
		columns: ReservedQtyCm,
		fitColumns: true,
		showBar: true,
		toolbar: [RefreshReservedInfo],
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	$HUI.dialog('#ReservedQtyInfoWin', {
		width: gWinWidth,
		height: gWinHeight,
		onOpen: function() {
			ReservedQtyGrid.load({
				ClassName: 'web.DHCSTMHUI.LocItmStk',
				QueryName: 'GetReservedQtyInfo',
				query2JsonStrict: 1,
				Incil: Incil
			});
		}
	}).open();
}