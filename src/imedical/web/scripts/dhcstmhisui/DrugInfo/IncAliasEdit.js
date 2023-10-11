/**
 * 查询界面
 */
function IncAliasEdit() {
	var Inci = $('#Inci').val();
	if (isEmpty(Inci)) {
		$UI.msg('alert', '请先选择要维护的库存项!');
		return;
	}
	var Clear = function() {
		$UI.clear(IncAliasEditGrid);
	};
	
	$HUI.dialog('#IncAliasEdit').open();
	function IncAliasEditSave() {
		var Detail = IncAliasEditGrid.getChangesData();
		if (Detail === false) {	// 未完成编辑或明细为空
			return;
		}
		if (isEmpty(Detail)) {	// 明细不变
			$UI.msg('alert', '没有需要保存的明细!');
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
			title: '别名',
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
			text: '保存',
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