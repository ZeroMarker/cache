/**
 * 查询界面
 */
function OrdAliasEdit() {
	var Arc = $('#Arc').val();
	var Inci = $('#Inci').val();
	if (isEmpty(Arc)) {
		$UI.msg('alert', '请先选择要维护的医嘱项!');
		return;
	}
	var Clear = function() {
		$UI.clear(ArcAliasEditGrid);
	};
	
	$HUI.dialog('#ArcAliasEdit').open();
	function ArcAliasEditSave() {
		var Detail = ArcAliasEditGrid.getChangesData();
		if (Detail === false) {	// 未完成编辑或明细为空
			return;
		}
		if (isEmpty(Detail)) {	// 明细不变
			$UI.msg('alert', '没有需要保存的明细!');
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.ARCALIAS',
			MethodName: 'jsSave',
			ArcimId: Arc,
			ListData: JSON.stringify(Detail)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				ArcAliasEditGrid.commonReload();
				GetDetail(Inci);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var ArcAliasEditCm = [[
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
	
	var ArcAliasEditGrid = $UI.datagrid('#ArcAliasEditGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ARCALIAS',
			QueryName: 'SelectAlias',
			query2JsonStrict: 1,
			rows: 99999,
			ArcimId: Arc
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.ARCALIAS',
			MethodName: 'Delete'
		},
		lazy: false,
		pagination: false,
		toolbar: [{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				ArcAliasEditSave();
			} }],
		showAddDelItems: true,
		columns: ArcAliasEditCm,
		onClickRow: function(index, row) {
			ArcAliasEditGrid.commonClickRow(index, row);
		}
	});
	Clear();
}