var gFn;
var UnRegisterCleanFailedWin = function(Fn) {
	gFn = Fn;
	$HUI.dialog('#SelReqWin').open();
};
var initUnRegisterCleanFailedWin = function() {
	// 供应科室
	var ReqSupLocParams = JSON.stringify(addSessionParams({ Type: 'Login', BDPHospital: gHospId }));
	$HUI.combobox('#ReqSupLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params=' + ReqSupLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var SupLocId = record.RowId;
			var LineParams = JSON.stringify(addSessionParams({ SupLocId: SupLocId, BDPHospital: gHospId }));
			var Url = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetLine&ResultSetType=array&Params=' + LineParams;
			$('#SLineCode').combobox('reload', Url).combobox('clear');
		}
	});
	$UI.linkbutton('#SelReqQueryBT', {
		onClick: function() {
			SelReqQuery();
		}
	});
	function SelReqQuery() {
		$UI.clear(SelReqMasterGrid);
		$UI.clear(SelReqDetailGrid);
		var ParamsObj = $UI.loopBlock('#SelReqWin');
		SelReqMasterGrid.load({
			ClassName: 'web.CSSDHUI.Clean.CleanFailed',
			QueryName: 'Select',
			Params: JSON.stringify(ParamsObj)
		});
	}

	$UI.linkbutton('#SelReqCreateBT', {
		onClick: function() {
			SelReqCreate();
		}
	});

	function SelReqCreate() {
		SelReqDetailGrid.endEditing();
		var ItemRows = SelReqDetailGrid.getChecked();
		if (isEmpty(ItemRows)) {
			$UI.msg('alert', '请选择要登记的消毒包！');
			return;
		}
		var ItemRowObj = SelReqDetailGrid.getSelectedData();
		var Rows = SelReqMasterGrid.getSelected();
		var Params = JSON.stringify(addSessionParams({ CleanMainId: Rows.RowId }));
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.Clean.CleanFailed',
			MethodName: 'CleanFailedRegister',
			Params: Params,
			Details: JSON.stringify(ItemRowObj)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				$('#SelReqWin').window('close');
				gFn();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	var SelReqMasterCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: '清洗主表Id',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '清洗批号',
			field: 'CleanNum',
			width: 130
		}, {
			title: '清洗科室',
			field: 'SupLocDesc',
			width: 150
		}, {
			title: '清洗科室',
			field: 'SupLocId',
			width: 150,
			hidden: true
		}, {
			title: '单据状态',
			field: 'CheckResultDesc',
			width: 80
		}
		
	]];

	var SelReqMasterGrid = $UI.datagrid('#SelReqMasterGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanFailed',
			QueryName: 'Select'
		},
		columns: SelReqMasterCm,
		pagination: false,
		sortName: 'RowId',
		sortOrder: 'desc',
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#SelReqMasterGrid').datagrid('selectRow', 0);
			}
		},
		onSelect: function(index, row) {
			var Id = row.RowId;
			if (!isEmpty(Id)) {
				FindItemByF(Id);
			}
		}
	});

	var SelReqDetailCm = [[
		{
			title: '',
			field: 'ck',
			checkbox: true,
			width: 50
		}, {
			title: '消毒包DR',
			field: 'PkgId',
			width: 50,
			hidden: true
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			width: 150
		}, {
			title: '标牌',
			field: 'CodeDict',
			width: 150
		}, {
			title: '器械Id',
			field: 'ItmId',
			width: 50,
			hidden: true
		}, {
			title: '器械',
			field: 'ItmDesc',
			width: 150
		}, {
			title: '数量',
			field: 'PkgNum',
			width: 50
		}, {
			title: '器械规格',
			field: 'ItmSpec',
			width: 120
		}, {
			title: '不合格原因Dr',
			field: 'ReasonId',
			width: 50,
			hidden: true
		}, {
			title: '不合格原因',
			field: 'UnPassReasonDesc',
			width: 100
		}, {
			title: '包属性',
			field: 'AttributeIdDesc',
			width: 100,
			hidden: true
		}, {
			title: '清洗明细ID',
			field: 'CleanDetailId',
			width: 100,
			hidden: true
		}, {
			title: '消毒包数量',
			field: 'PkgMainQty',
			width: 100,
			hidden: true
		}
	]];

	var SelReqDetailGrid = $UI.datagrid('#SelReqDetailGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanFailItem',
			QueryName: 'GetCleanFailPackage'
		},
		columns: SelReqDetailCm,
		pagination: false,
		singleSelect: false,
		sortName: 'RowId',
		sortOrder: 'asc',
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#SelReqDetailGrid').datagrid('selectAll');
			}
		},
		onClickCell: function(index, field, value) {
			SelReqDetailGrid.commonClickCell(index, field);
		}
	});
	
	function FindItemByF(Id) {
		$UI.clear(SelReqDetailGrid);
		var Params = JSON.stringify(addSessionParams({ CleanMainId: Id, PrdoId: '', RegisterFlag: '1' }));
		SelReqDetailGrid.load({
			ClassName: 'web.CSSDHUI.Clean.CleanFailItem',
			QueryName: 'GetCleanFailPackage',
			Params: Params,
			rows: 9999
		});
	}
	
	$HUI.dialog('#SelReqWin', {
		width: gWinWidth,
		height: gWinHeight,
		onOpen: function() {
			$UI.clearBlock('#SelReqConditions');
			var LocId = $('#SupLoc').combobox('getValue');
			var LocDesc = $('#SupLoc').combobox('getText');
			var Default = {
				FStartDate: DefaultStDate(),
				FEndDate: DefaultEdDate(),
				FSupLoc: { RowId: LocId, Description: LocDesc }
			};
			$UI.fillBlock('#SelReqWin', Default);
			SelReqQuery();
		}
	});
};
$(initUnRegisterCleanFailedWin);