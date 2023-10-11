// 消毒包基数维护JS
var init = function() {
	var LocParams = JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: gHospId }));
	$HUI.combobox('#PhaLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var PkgParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, TypeDetail: '1,2,7' }));
	$HUI.combobox('#Package', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + PkgParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clearBlock('PackageTB');
			$UI.clear(PackageStoreGrid);
		}
	});
	
	function Query() {
		$UI.clear(PackageStoreGrid);
		var Params = JSON.stringify($UI.loopBlock('PackageTB'));
		PackageStoreGrid.load({
			ClassName: 'web.CSSDHUI.System.LocPackageStock',
			QueryName: 'GetLocPackageStock',
			Params: Params,
			rows: 999999999
		});
	}
	
	// 下拉科室名称固定位当前登录科室
	var LocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect: function(record) {
				var rows = PackageStoreGrid.getRows();
				var row = rows[PackageStoreGrid.editIndex];
				row.LocDesc = record.Description;
			}
		}
	};
	var PackageCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + PkgParams,
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect: function(record) {
				var rows = PackageStoreGrid.getRows();
				var row = rows[PackageStoreGrid.editIndex];
				row.PkgDesc = record.Description;
			}
		}
	};

	var PackageStoreGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '科室名称',
			field: 'LocId',
			width: 200,
			formatter: CommonFormatter(LocCombox, 'LocId', 'LocDesc'),
			editor: LocCombox
		}, {
			title: '消毒包',
			field: 'PkgId',
			width: 250,
			formatter: CommonFormatter(PackageCombox, 'PkgId', 'PkgDesc'),
			editor: PackageCombox
		}, {
			title: '每日请领量',
			align: 'right',
			field: 'NormQty',
			width: 120,
			editor: { type: 'numberbox', options: { min: 0 }}
		}, {
			title: '现有库存',
			align: 'right',
			field: 'CurQty',
			width: 100,
			editor: { type: 'numberbox', options: { min: 0 }}
		}
	]];
	
	var PackageStoreGrid = $UI.datagrid('#PackageStoreGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.LocPackageStock',
			QueryName: 'GetLocPackageStock'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.System.LocPackageStock',
			MethodName: 'jsDelete'
		},
		checkField: 'PkgId',
		columns: PackageStoreGridCm,
		showAddSaveItems: true,
		fitColumns: true,
		onClickRow: function(index, row) {
			PackageStoreGrid.commonClickRow(index, row);
		},
		beforeAddFn: function() {
			var DefLocId = $('#PhaLoc').combobox('getValue');
			var DefLocDesc = $('#PhaLoc').combobox('getText');
			if (isEmpty(DefLocId)) { return; }
			var DefaultData = { LocId: DefLocId, LocDesc: DefLocDesc };
			return DefaultData;
		},
		saveDataFn: function() {
			var Rows = PackageStoreGrid.getChangesData();
			if (isEmpty(Rows)) {
				return;
			}
			if (Rows === false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			var Len = Rows.length;
			for (var i = 0; i < Len; i++) {
				var RowData = Rows[i];
				var NormQty = RowData['NormQty'];
				var CurQty = RowData['CurQty'];
				if (isEmpty(NormQty) && isEmpty(CurQty)) {
					$UI.msg('alert', '每日请领量与库存不能同时为空!');
					return;
				} else if ((Number(NormQty) < 0) || (Number(NormQty) < 0)) {
					$UI.msg('alert', '每日请领量与库存不能小于零!');
					return;
				}
			}
			showMask();
			$.cm({
				ClassName: 'web.CSSDHUI.System.LocPackageStock',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				hideMask();
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					PackageStoreGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	Query();
};
$(init);