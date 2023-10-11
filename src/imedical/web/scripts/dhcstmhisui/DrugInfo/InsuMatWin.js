function GetInsuMatItm(Fn) {
	var Clear = function() {
		$UI.clearBlock('#InsuMatConditions');
		$UI.clear(InsuMatGrid);
	};
	$HUI.dialog('#InsuMatCodeWin').open();
	$UI.linkbutton('#InsuMatQueryBT', {
		onClick: function() {
			InsuMatSearch();
		}
	});
	
	function InsuMatSearch() {
		var ParamsObj = $UI.loopBlock('#InsuMatConditions');
		var Params = JSON.stringify(ParamsObj);
		InsuMatGrid.load({
			ClassName: 'web.DHCSTMHUI.InsuMatCode',
			QueryName: 'MatSpecDetail',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	var InsuMatCm = [[
		{
			title: 'goodid',
			field: 'goodid',
			width: 50,
			hidden: true
		}, {
			title: 'ҽ�úĲĴ���',
			field: 'insumatCode',
			width: 300
		}, {
			title: '��ˮ��',
			field: 'lsh',
			width: 120
		}, {
			title: 'ͨ����',
			field: 'GenericName',
			width: 300
		}, {
			title: '���',
			field: 'sspec',
			width: 130
		}, {
			title: 'ע��֤��',
			field: 'regDesc',
			width: 240
		}
	]];
	var InsuMatGrid = $UI.datagrid('#InsuMatGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.InsuMatCode',
			QueryName: 'MatSpecDetail',
			query2JsonStrict: 1
		},
		columns: InsuMatCm,
		onDblClickRow: function(index, row) {
			Fn(row.insumatCode);
			$HUI.dialog('#InsuMatCodeWin').close();
		}
	});
	Clear();
}