/*
������־��ѯ
*/
var ComLogSearch = function(DetailId) {
	$HUI.dialog('#LogWin', { width: gWinWidth, height: gWinHeight }).open();
	var ComLogCm = [[
		{
			title: '������־��ϸid',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '��������',
			field: 'ComNo',
			width: 180
		}, {
			title: 'ҽ������',
			field: 'Arcim',
			width: 180
		}, {
			title: '�������',
			field: 'ComResult',
			width: 100,
			formatter: function(value, row, index) {
				if (row.ComResult == 'N') {
					return '������';
				} else if (row.ComResult == 'Y') {
					return '����';
				} else {
					return '';
				}
			}
		}, {
			title: '������',
			field: 'ComUser',
			width: 100
		}, {
			title: '��������',
			field: 'ComDate',
			width: 100
		}, {
			title: '����ʱ��',
			field: 'ComTime',
			width: 100
		}, {
			title: '���ϸ�ԭ��',
			field: 'ComReason',
			width: 150
		}, {
			title: '��������',
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