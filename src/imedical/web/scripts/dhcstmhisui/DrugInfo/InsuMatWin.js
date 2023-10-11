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
			title: '医用耗材代码',
			field: 'insumatCode',
			width: 300
		}, {
			title: '流水号',
			field: 'lsh',
			width: 120
		}, {
			title: '通用名',
			field: 'GenericName',
			width: 300
		}, {
			title: '规格',
			field: 'sspec',
			width: 130
		}, {
			title: '注册证号',
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