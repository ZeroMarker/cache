/**
 * ��ѯ����
 */
function IncAliasEdit() {
	var Inci = $('#Inci').val();
	if (isEmpty(Inci)) {
		$UI.msg('alert', '����ѡ��Ҫά���Ŀ����!');
		return;
	}
	var Clear = function() {
		$UI.clear(IncAliasEditGrid);
	};
	
	$HUI.dialog('#IncAliasEdit').open();
	function IncAliasEditSave() {
		var Detail = IncAliasEditGrid.getChangesData();
		if (Detail === false) {	// δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Detail)) {	// ��ϸ����
			$UI.msg('alert', 'û����Ҫ�������ϸ!');
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INCALIAS',
			MethodName: 'jsSave',
			Inci: Inci,
			ListData: JSON.stringify(Detail)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				IncAliasEditGrid.commonReload();
				GetDetail(Inci);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var IncAliasEditCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '����',
			field: 'Alias',
			width: 250,
			editor: { type: 'validatebox', options: { required: true }}
		}
	]];
	
	var IncAliasEditGrid = $UI.datagrid('#IncAliasEditGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INCALIAS',
			QueryName: 'SelectAlias',
			query2JsonStrict: 1,
			rows: 99999,
			Inci: Inci
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.INCALIAS',
			MethodName: 'Delete'
		},
		lazy: false,
		pagination: false,
		toolbar: [{
			text: '����',
			iconCls: 'icon-save',
			handler: function() {
				IncAliasEditSave();
			} }],
		showAddDelItems: true,
		columns: IncAliasEditCm,
		onClickRow: function(index, row) {
			IncAliasEditGrid.commonClickRow(index, row);
		}
	});
	Clear();
}