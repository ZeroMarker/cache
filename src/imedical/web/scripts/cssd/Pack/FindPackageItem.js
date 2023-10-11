var gPkgId, gCleanDRowId;
var FindPackageItem = function(PkgId, CleanDRowId) {
	gPkgId = PkgId;
	gCleanDRowId = CleanDRowId;
	$HUI.dialog('#PackageItemWin', {
		width: (gWinWidth * 0.5),
		height: gWinHeight * 0.6
	}).open();
};

var initPackageItemWin = function() {
	function SelReqQuery() {
		ItemsGrid.load({
			ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
			QueryName: 'SelectByF',
			PkgId: gPkgId,
			CleanDRowId: gCleanDRowId,
			rows: 99999
		});
	}

	var FindItemCm = [[
		{
			title: '序号',
			field: 'SerialNo',
			align: 'right',
			width: 70,
			hidden: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '器械Id',
			field: 'ItmId',
			width: 150,
			hidden: true
		}, {
			title: '器械',
			field: 'ItmDesc',
			width: 200
		}, {
			title: '器械规格',
			field: 'ItmSpec',
			width: 200
		}, {
			title: '数量',
			field: 'Qty',
			align: 'right',
			width: 100
		}, {
			title: '备注',
			field: 'ItmRemark',
			align: 'left',
			width: 100
		}, {
			title: '是否启用',
			field: 'UseFlag',
			align: 'center',
			width: 100,
			hidden: true
		}
	]];
	var ItemsGrid = $UI.datagrid('#FindPackageItem', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
			QueryName: 'SelectByF',
			PkgId: gPkgId,
			rows: 99999
		},
		columns: FindItemCm,
		fitColumns: true,
		pagination: false,
		singleSelect: false,
		onClickRow: function(index, row) {
			ItemsGrid.commonClickRow(index, row);
		}
	});
	$HUI.dialog('#PackageItemWin', {
		onOpen: function() {
			SelReqQuery();
		}
	});
};
$(initPackageItemWin);