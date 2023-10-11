var gFn;
var ReturnPkg = function(Fn) {
	gFn = Fn;
	$HUI.dialog('#SelReturnWin').open();
};

var initReturnPkg = function() {
	// 选取归还单
	$UI.linkbutton('#SelReturnBT', {
		onClick: function() {
			ReturnCreate();
		}
	});

	function ReturnCreate() {
		var MainRow = $('#ReturnGrid').datagrid('getSelected');
		if (isEmpty(MainRow)) {
			$UI.msg('alert', '请选择需要生成的借包单据！');
			return;
		}
		var flag = false;
		var MainId = MainRow.RowId;
		var Params = JSON.stringify(addSessionParams({ MainId: MainId }));
		var DetailRows = ReturnDetailGrid.getSelectedData();
		if (isEmpty(DetailRows)) {
			$UI.msg('alert', '请选择单据明细！');
			return;
		}
		$.each(DetailRows, function(index, item) {
			var DispQty = item.DispQty;		// 申请后供应室发放数量
			var CheckBackQty = item.CheckBackQty;
			var ApplyBackQty = item.ApplyBackQty;
			var AllowMaxQty = DispQty - CheckBackQty - ApplyBackQty;
			var ReturnQty = item.ReturnQty;	// 待归还数
			if ((ReturnQty <= 0) || (ReturnQty > AllowMaxQty)) {
				flag = true;
			}
		});
		if (flag) {
			$UI.msg('alert', '存在已归还完毕的消毒包或归还数量超出待归还数，不能生成归还单！');
			return;
		}
		$.cm({
			ClassName: 'web.CSSDHUI.Apply.ReturnPackage',
			MethodName: 'jsCreateReturnPkg',
			DetailRows: JSON.stringify(DetailRows),
			Params: Params
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				$('#SelReturnWin').window('close');
				var ApplyId = jsonData.rowid;
				gFn(ApplyId);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	var ReturnCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '借包单号',
			field: 'ApplyNo',
			width: 120
		}, {
			title: '申请科室DR',
			field: 'ApplyLocDr',
			width: 100,
			hidden: true
		}, {
			title: '申请科室',
			field: 'ApplyLocDesc',
			width: 130
		}, {
			title: '申请人DR',
			field: 'ApplyUserDr',
			width: 100,
			hidden: true
		}, {
			title: '申请人',
			field: 'ApplyUserName',
			width: 80
		}, {
			title: '单据类型',
			field: 'ReqType',
			width: 60,
			hidden: true
		}, {
			title: '单据类型',
			field: 'ReqTypeDesc',
			width: 80
		}, {
			title: '紧急',
			field: 'ReqLevel',
			width: 60,
			hidden: true
		}, {
			title: '紧急',
			field: 'ReqLevelDesc',
			width: 80
		}, {
			title: '提交日期',
			field: 'ApplyDateTime',
			width: 150
		}
	]];

	// 借包单主单据
	var ReturnGrid = $UI.datagrid('#ReturnGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Apply.ReturnPackage',
			QueryName: 'SelectAll'
		},
		columns: ReturnCm,
		pagination: false,
		singleSelect: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#ReturnGrid').datagrid('selectRow', 0);
			}
		},
		onSelect: function(index, row) {
			var Id = row.RowId;
			ReturnDetailGrid.load({
				ClassName: 'web.CSSDHUI.Apply.ReturnPackage',
				QueryName: 'SelectDetail',
				MainId: Id,
				rows: 9999
			});
		},
		onDblClickRow: function(rowIndex) {
			ReturnCreate();
		}
	});

	var ReturnDetailCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '消毒包ID',
			field: 'PackageDr',
			width: 60,
			hidden: true
		}, {
			title: '消毒包',
			field: 'PackageDesc',
			width: 120
		}, {
			title: '标牌',
			field: 'CodeDict',
			width: 100
		}, {
			title: '借包数',
			align: 'right',
			field: 'ReqQty',
			width: 60,
			hidden: true
		}, {
			title: '发放数',
			align: 'right',
			field: 'DispQty',
			width: 60
		}, {
			title: '已归还',
			align: 'right',
			field: 'CheckBackQty',
			width: 60
		}, {
			title: '待回收',
			align: 'right',
			field: 'ApplyBackQty',
			width: 60
		}, {
			title: '待归还',
			align: 'right',
			field: 'ReturnQty',
			width: 60,
			editor: { type: 'numberbox', options: { required: true, min: 0 }}
		}, {
			title: '包装材料DR',
			field: 'MaterialDr',
			width: 60,
			hidden: true
		}, {
			title: '包装材料',
			field: 'MaterialName',
			width: 120
		}
	]];
	// 借包单明细
	var ReturnDetailGrid = $UI.datagrid('#ReturnDetailGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Apply.ReturnPackage',
			QueryName: 'SelectDetail'
		},
		columns: ReturnDetailCm,
		pagination: false,
		singleSelect: false,
		fitColumns: true,
		onClickCell: function(index, field, value) {
			ReturnDetailGrid.commonClickCell(index, field);
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#ReturnDetailGrid').datagrid('selectAll');
			}
		}
	});

	$HUI.dialog('#SelReturnWin', {
		width: gWinWidth,
		height: gWinHeight,
		onOpen: function() {
			$UI.clearBlock('#SelReturnConditions');
			Query();
		}
	});
	function Query() {
		$UI.clear(ReturnGrid);
		$UI.clear(ReturnDetailGrid);
		var LocId = $('#ReqLoc').combobox('getValue');
		var Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId, FReqLoc: LocId }));
		ReturnGrid.load({
			ClassName: 'web.CSSDHUI.Apply.ReturnPackage',
			QueryName: 'SelectAll',
			Params: Params
		});
	}
};
$(initReturnPkg);