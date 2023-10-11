// 授权书维护界面
var ChainGrid;
var init = function() {
	$HUI.combobox('#Manf', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params='
			+ JSON.stringify(addSessionParams({ BDPHospital: gHospId }))
	});
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	$UI.linkbutton('#AddBT', {
		onClick: function() {
			ChainDetailWin('', Query);
		}
	});
	$UI.linkbutton('#UpdateBT', {
		onClick: function() {
			var RowData = ChainGrid.getSelected();
			if (isEmpty(RowData)) {
				$UI.msg('alert', '请选择需要修改的授权书!');
				return;
			}
			var RowId = RowData['RowId'];
			ChainDetailWin(RowId, Query);
		}
	});
	$UI.linkbutton('#LinkInciBT', {
		onClick: function() {
			var RowData = ChainGrid.getSelected();
			if (isEmpty(RowData)) {
				$UI.msg('alert', '请选择授权书!');
				return;
			}
			var RowId = RowData['RowId'];
			var ChainManfId = RowData['ManfId'];
			ChainItmWin(RowId, ChainManfId);
		}
	});
	function Query() {
		$UI.clear(ChainGrid);
		var ParamsObj = $UI.loopBlock('#MainConditions');
		var Params = JSON.stringify(ParamsObj);
		ChainGrid.load({
			ClassName: 'web.DHCSTMHUI.SupplyChain',
			QueryName: 'QueryChain',
			query2JsonStrict: 1,
			Params: Params
		});
	}

	var ChainGridCm = [[
		{
			title: '操作',
			field: 'Icon',
			width: 50,
			align: 'center',
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '<div onclick="ViewFile(' + index + ')" class="icon-img col-icon" title="编辑图片"></div>';
				return str;
			}
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '代码',
			field: 'ChainCode',
			width: 100
		}, {
			title: 'ManfId',
			field: 'ManfId',
			width: 80,
			hidden: true
		}, {
			title: '生产厂家',
			field: 'ManfDesc',
			width: 180
		}, {
			title: 'VendorId',
			field: 'VendorId',
			width: 80,
			hidden: true
		}, {
			title: '供应商',
			field: 'VendorDesc',
			width: 180
		}, {
			title: '授权级别',
			field: 'LevelCount',
			width: 80,
			align: 'center'
		}, {
			title: '授权信息',
			field: 'ChainInfo',
			width: 550
		}
	]];
	
	ChainGrid = $UI.datagrid('#ChainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.SupplyChain',
			QueryName: 'QueryChain',
			query2JsonStrict: 1
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.SupplyChain',
			MethodName: 'DeleteChain'
		},
		columns: ChainGridCm,
		nowrap: false,
		wordBreak: 'break-word',
		showBar: true,
		pagination: true,
		onDblClickRow: function(index, row) {
			var RowId = row['RowId'];
			ChainDetailWin(RowId);
		}
	});
	
	Query();
};
$(init);

function ViewFile(index) {
	var RowData = ChainGrid.getRows()[index];
	var SupplyChainId = RowData['RowId'];
	var OrgType = 'SupplyChain';
	var OrgId = SupplyChainId;
	var GrpType = '';
	var PointerType = '';
	var Pointer = '';
	var SubType = '';
	ViewFileWin(OrgType, OrgId, GrpType, PointerType, Pointer, SubType, gHospId);
}