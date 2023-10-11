function IncSpecEdit() {
	var Inci = $('#Inci').val();
	if (isEmpty(Inci)) {
		$UI.msg('alert', '请先选择要维护的库存项!');
		return;
	}
	var Clear = function() {
		$UI.clear(IncSpecEditGrid);
	};
	
	$HUI.dialog('#IncSpecEdit').open();
	function IncSpecEditSave() {
		var Detail = IncSpecEditGrid.getChangesData();
		if (Detail === false) {
			return;
		}
		if (isEmpty(Detail)) {
			$UI.msg('alert', '没有需要保存的明细!');
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INCALIAS',
			MethodName: 'jsSaveSpec',
			Inci: Inci,
			ListData: JSON.stringify(Detail)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				IncSpecEditGrid.commonReload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var IncSpecEditCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '具体规格',
			field: 'Spec',
			width: 250,
			editor: { type: 'validatebox', options: { required: true }}
		}
	]];
	
	var IncSpecEditGrid = $UI.datagrid('#IncSpecEditGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INCALIAS',
			QueryName: 'SelectSpec',
			query2JsonStrict: 1,
			Inci: Inci,
			rows: 999
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.INCALIAS',
			MethodName: 'DeleteSpec'
		},
		lazy: false,
		toolbar: [{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				IncSpecEditSave();
			}
		}],
		showAddDelItems: true,
		columns: IncSpecEditCm,
		pagination: false,
		onClickRow: function(index, row) {
			IncSpecEditGrid.commonClickRow(index, row);
		}
	});
	Clear();
}