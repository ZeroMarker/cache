
function UnTrfInWin() {
	$HUI.dialog('#UnTrfInWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
}

var initUnTrfInWin = function() {
	function Query() {
		var ConditonObj = $UI.loopBlock('#MainCondition');
		var ParamsObj = {};
		ParamsObj.fromLocDr = ConditonObj.fromLocDr;
		ParamsObj.FStartDate = ConditonObj.FStartDate;
		ParamsObj.FEndDate = ConditonObj.FEndDate;
		ParamsObj.FComplateFlag = 'Y';
		ParamsObj.DocType = 1;
		ParamsObj.FStatu = 'N';
		UnTrfInMainGrid.load({
			ClassName: 'web.CSSDHUI.PackageDisp.DispScan',
			QueryName: 'SelectAll',
			Params: JSON.stringify(ParamsObj)
		});
	}
	
	var UnTrfInMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '调拨单号',
			field: 'No',
			width: 120
		}, {
			title: '调拨科室',
			field: 'FromLocDesc',
			width: 100
		}, {
			title: '接收科室',
			field: 'ToLocDesc',
			width: 100
		}, {
			title: '调拨人',
			field: 'FromUserDesc',
			width: 100
		}, {
			title: '制单时间',
			field: 'DispDate',
			width: 150
		}, {
			title: '提交人',
			field: 'DispCHKUserDesc',
			width: 100
		}, {
			title: '提交时间',
			field: 'DispCHKDate',
			width: 150
		}, {
			title: '完成标志',
			field: 'ComplateFlag',
			width: 100
		}, {
			title: '紧急状态',
			field: 'LevelFlag',
			width: 50,
			hidden: true
		}
	]];
	
	var UnTrfInMainGrid = $UI.datagrid('#UnTrfInMainGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.DispScan',
			QueryName: 'SelectAll'
		},
		columns: UnTrfInMainCm,
		sortOrder: 'desc',
		sortName: 'RowId',
		onLoadSuccess: function(data) {
			$UI.clear(UnTrfInItmGrid);
			if (data.rows.length > 0) {
				$('#UnTrfInMainGrid').datagrid('selectRow', 0);
			}
		},
		onSelect: function(index, rowData) {
			var RowId = rowData.RowId;
			UnTrfInItmGrid.load({
				ClassName: 'web.CSSDHUI.PackageDisp.DispItm',
				QueryName: 'SelectByF',
				MainId: RowId,
				sort: 'RowId',
				order: 'desc',
				rows: 9999
			});
		}
	});
	
	var UnTrfInItmCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '标签',
			field: 'Label',
			width: 180
		}, {
			title: '消毒包',
			field: 'PackageName',
			width: 150,
			showTip: true,
			tipWidth: 200
		}, {
			title: '数量',
			field: 'Qty',
			align: 'right',
			width: 50,
			hidden: true
		}, {
			title: '紧急状态',
			field: 'LevelFlag',
			width: 100,
			hidden: true
		}, {
			title: 'DispDetailId',
			field: 'DispDetailId',
			width: 100,
			hidden: true
		}, {
			title: '包DR',
			field: 'PackageDR',
			width: 100,
			hidden: true
		}
	]];
	var UnTrfInItmGrid = $UI.datagrid('#UnTrfInItmGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.DispItm',
			MethodName: 'SelectByF'
		},
		columns: UnTrfInItmCm,
		pagination: false,
		fitColumns: true
	});
	
	$HUI.dialog('#UnTrfInWin', {
		onOpen: function() {
			Query();
		}
	});
};
$(initUnTrfInWin);