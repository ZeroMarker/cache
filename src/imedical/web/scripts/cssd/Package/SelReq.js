// 另存明细弹框
var gPkgId, gOthers;
var SelReq = function(PkgId, Others) {
	gPkgId = PkgId;
	gOthers = Others;
	$HUI.dialog('#SelReqWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
};
var initSelReq = function() {
	$UI.linkbutton('#SelReqQueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var Params = JSON.stringify($UI.loopBlock('#SelReqWin'));
		$UI.clear(PkgGrid);
		PkgGrid.load({
			ClassName: 'web.CSSDHUI.PackageInfo.Package',
			QueryName: 'QueryPkgInfo',
			Params: Params,
			Others: gOthers
		});
	}
	
	$UI.linkbutton('#SelReqAddBT', {
		onClick: function() {
			SelReqAdd();
		}
	});
	
	function SelReqAdd() {
		var Row = PkgGrid.getSelected();
		if (isEmpty(Row)) {
			$UI.msg('alert', '请选择消毒包!');
			return;
		}
		$.cm({
			ClassName: 'web.CSSDHUI.PackageInfo.Package',
			MethodName: 'JsSaveItmByPkg',
			NewPkgId: gPkgId,
			ByPkgId: Row.RowId
		}, function(jsonData) {
			if (jsonData.success !== 0) {
				$UI.msg('error', jsonData.msg);
			} else {
				$UI.msg('success', jsonData.msg);
				$('#ItemList').datagrid('reload');
			}
		});
		$HUI.dialog('#SelReqWin').close();
	}
	// /消毒包单位    
	var UomData = $.cm({
		ClassName: 'web.CSSDHUI.Common.Dicts',
		QueryName: 'GetCTUom',
		ResultSetType: 'array'
	}, false);
	var UomCombox = {
		type: 'combobox',
		options: {
			data: UomData,
			valueField: 'RowId',
			textField: 'Description'
		}
	};

	$HUI.combobox('#SelReqPkgClassId', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackageClass&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var PkgCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			align: 'left',
			width: 100,
			hidden: true
		}, {
			title: '代码',
			field: 'PkgCode',
			align: 'left',
			width: 50,
			sortable: true
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			align: 'left',
			width: 200,
			sortable: true
		}, {
			title: '别名',
			field: 'PkgAlias',
			align: 'left',
			width: 100,
			sortable: true
		}, {
			title: '单位',
			field: 'UomId',
			align: 'left',
			width: 120,
			sortable: true,
			formatter: CommonFormatter(UomCombox, 'UomId', 'UomDesc')
		}
	]];

	// 模板主单据
	var PkgGrid = $UI.datagrid('#PackageGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.Package',
			QueryName: 'QueryPkgInfo',
			Params: JSON.stringify($UI.loopBlock('#SelReqConditions'))
		},
		columns: PkgCm,
		pagination: true,
		singleSelect: true,
		fitColumns: true,
		onSelect: function(index, row) {
			var PkgId = row['RowId'];
			if (!isEmpty(PkgId)) {
				FindItemByF(PkgId);
			}
		}
	});
	var ItmCm = [[
		{
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
			width: 120
		}, {
			title: '器械规格',
			field: 'ItmSpec',
			width: 130
		}, {
			title: '数量',
			field: 'Qty',
			align: 'right',
			width: 80
		}, {
			title: '备注',
			field: 'ItmRemark',
			align: 'right',
			width: 100
		}, {
			title: '是否启用',
			field: 'UseFlag',
			align: 'center',
			width: 80
		}
	]];
	
	var ItmGrid = $UI.datagrid('#ItemGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
			QueryName: 'SelectByF',
			rows: 99999
		},
		columns: ItmCm,
		pagination: false,
		singleSelect: false,
		fitColumns: true
	});
	function FindItemByF(PkgId) {
		ItmGrid.load({
			ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
			QueryName: 'SelectByF',
			PkgId: PkgId,
			rows: 99999
		});
	}
	function Default() {
		$UI.clearBlock('#SelReqConditions');
	}
	$HUI.dialog('#SelReqWin', {
		onOpen: function() {
			Default();
			Query();
		}
	});
};
$(initSelReq);