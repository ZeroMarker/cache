/*
点评日志查询
*/
var ComLogSearch = function(DetailId) {
	$HUI.dialog('#LogWin', { width: gWinWidth, height: gWinHeight }).open();
	var ComLogCm = [[
		{
			title: '点评日志明细id',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '点评单号',
			field: 'ComNo',
			width: 180
		}, {
			title: '医嘱名称',
			field: 'Arcim',
			width: 180
		}, {
			title: '点评结果',
			field: 'ComResult',
			width: 100,
			formatter: function(value, row, index) {
				if (row.ComResult == 'N') {
					return '不合理';
				} else if (row.ComResult == 'Y') {
					return '合理';
				} else {
					return '';
				}
			}
		}, {
			title: '点评人',
			field: 'ComUser',
			width: 100
		}, {
			title: '点评日期',
			field: 'ComDate',
			width: 100
		}, {
			title: '点评时间',
			field: 'ComTime',
			width: 100
		}, {
			title: '不合格原因',
			field: 'ComReason',
			width: 150
		}, {
			title: '点评建议',
			field: 'ComAdvice',
			width: 180
		}
	]];
	
	var ComLogGrid = $UI.datagrid('#ComLogGrid', {
		lazy: false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.CommentComPlain',
			QueryName: 'QueryLog',
			query2JsonStrict: 1,
			DetailId: DetailId
		},
		onClickRow: function(index, row) {
			ComLogGrid.commonClickRow(index, row);
		},
		columns: ComLogCm,
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
};