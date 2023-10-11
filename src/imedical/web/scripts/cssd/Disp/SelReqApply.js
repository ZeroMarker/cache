// 临床包发放中的非循环包、借包弹框
var gFn, gApplyType;
function SelReqApply(Fn, ApplyType) {
	gFn = Fn;
	gApplyType = ApplyType;
	$HUI.dialog('#SelReqWinBorrow', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
}

var initSelReqApply = function() {
	$UI.clearBlock('#SelReqConditionsBro');
	var ReqLocParams = JSON.stringify(addSessionParams({ Type: 'RecLoc', BDPHospital: gHospId }));
	$HUI.combobox('#SelReqLocB', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId, SupLocId: record.RowId }));
			var Url = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetLine&ResultSetType=array&Params=' + Params;
			$('#BroLineCode').combobox('reload', Url).combobox('clear');
		}
	});
	
	var LineParams = JSON.stringify(addSessionParams({ SupLocId: gLocId, BDPHospital: gHospId }));
	$HUI.combobox('#BroLineCode', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetLine&ResultSetType=array&Params=' + LineParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	$UI.linkbutton('#SelReqQueryBTBro', {
		onClick: function() {
			SelReqQuery();
		}
	});
	function SelReqQuery() {
		var ParamsObj = $UI.loopBlock('#SelReqWinBorrow');
		ParamsObj['ApplyType'] = gApplyType;
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(SelReqMasterGrid);
		$UI.clear(SelReqDetailGrid);
		SelReqMasterGrid.load({
			ClassName: 'web.CSSDHUI.PackageDisp.CreateDispByApply',
			QueryName: 'SelectDispForCallBack',
			Params: Params,
			rows: 9999
		});
	}
	$UI.linkbutton('#SelReqCreateBTBro', {
		onClick: function() {
			SelReqCreate();
		}
	});
	function SelReqCreate() {
		SelReqDetailGrid.endEditing();
		var ItemRows = SelReqDetailGrid.getChecked();
		if (isEmpty(ItemRows)) {
			$UI.msg('alert', '请选择需要发放的消毒包');
			return;
		}
		var ItemRowObj = SelReqDetailGrid.getSelectedData();
		var Params = JSON.stringify(addSessionParams());
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.PackageDisp.Disp',
			MethodName: 'jsCreateDispByCallBack',
			Params: Params,
			ItemRow: JSON.stringify(ItemRowObj)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				$('#SelReqWinBorrow').window('close');
				var MainIdStr = jsonData.rowid;
				gFn(MainIdStr);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	function SelReqDefa() {
		$UI.clearBlock('#SelReqConditionsBro');
		var Default = {
			StartDate: $UI.loopBlock('#MainCondition').FStartDate,
			EndDate: $UI.loopBlock('#MainCondition').FEndDate
		};
		$UI.fillBlock('#SelReqConditionsBro', Default);
	}
	var SelReqMasterCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			align: 'center',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			field: 'operate',
			title: '标识',
			align: 'center',
			width: 60,
			formatter: function(value, row, index) {
				var str = '';
				if (row.ReqLevel == '1') {
					str = '<div class="col-icon icon-emergency" href="#" title="紧急"></div>';
				}
				return str;
			}
		}, {
			title: '单号',
			align: 'left',
			field: 'ApplyNo',
			width: 110
		}, {
			title: '单据类型',
			align: 'left',
			field: 'ApplyTypeDesc',
			width: 100
		}, {
			title: '申请科室',
			align: 'left',
			field: 'ReqLocDesc',
			width: 100
		}, {
			title: '申请日期',
			align: 'left',
			field: 'ApplyDate',
			width: 160
		}, {
			title: '申请人',
			align: 'left',
			field: 'ApplyUserDesc',
			width: 100
		}, {
			title: '已全部生成发放单',
			align: 'center',
			field: 'AllCreateFlag',
			width: 120
		}
	]];

	var SelReqMasterGrid = $UI.datagrid('#SelReqMasterGridBro', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.CreateDispByApply',
			QueryName: 'SelectDispForCallBack'
		},
		columns: SelReqMasterCm,
		singleSelect: false,
		pagination: false,
		sortOrder: 'desc',
		sortName: 'RowId',
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#SelReqMasterGridBro').datagrid('selectRow', 0);
			}
		},
		onClickRow: function(index, row) {
			SelReqMasterGrid.commonClickRow(index, row);
		},
		onSelect: function(index, rowData) {
			FindItemByF();
		},
		onDblClickRow: function(rowIndex) {
			$('#SelReqMasterGridBro').datagrid('selectRow', rowIndex);
			SelReqCreate();
		},
		onUnselect: function(index, row) {
			FindItemByF();
		},
		onSelectAll: function(rows) {
			FindItemByF();
		},
		onUnselectAll: function(rows) {
			$UI.clear(SelReqDetailGrid);
		}
	});

	var SelReqDetailCm = [[
		{
			title: '',
			id: 'selectAll',
			field: 'ck',
			checked: true,
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			field: 'operate',
			title: '标识',
			align: 'center',
			width: 60,
			formatter: function(value, row, index) {
				var str = '';
				if (row.LevelFlag == '1') {
					str = '<div class="col-icon icon-emergency" href="#" title="紧急"></div>';
				}
				return str;
			}
		}, {
			title: '消毒包',
			align: 'left',
			field: 'PkgDesc',
			width: 160
		}, {
			title: '申请数',
			align: 'right',
			field: 'BackQty',
			width: 60
		}, {
			title: '发放数',
			align: 'right',
			field: 'DispQty',
			width: 60
		}, {
			title: '要发放数',
			align: 'right',
			field: 'PreDispQty',
			width: 70,
			editor: { type: 'numberbox' }
		}, {
			title: '紧急状态',
			field: 'LevelFlag',
			width: 100,
			hidden: true
		}, {
			title: 'PkgId',
			field: 'PkgId',
			width: 100,
			hidden: true
		}, {
			title: 'Material',
			field: 'Material',
			width: 100,
			hidden: true
		}
	]];

	var IsCheckFlag = true;
	var SelReqDetailGrid = $UI.datagrid('#SelReqDetailGridBro', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.CreateDispByApply',
			QueryName: 'SelectByF'
		},
		columns: SelReqDetailCm,
		fitColumns: true,
		pagination: false,
		singleSelect: false,
		sortOrder: 'desc',
		sortName: 'RowId',
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#SelReqDetailGridBro').datagrid('selectAll');
			}
		},
		onClickCell: function(index, field, value) {
			SelReqDetailGrid.commonClickCell(index, field);
			IsCheckFlag = false;
		},
		onSelect: function(index, rowData) {
			if (!IsCheckFlag) {
				IsCheckFlag = true;
				$('#SelReqDetailGridBro').datagrid('unselectRow', index);
			}
		},
		onUnselect: function(index, row) {
			if (!IsCheckFlag) {
				IsCheckFlag = true;
				$('#SelReqDetailGridBro').datagrid('selectRow', index);
			}
		}
	});
	
	function FindItemByF() {
		$UI.clear(SelReqDetailGrid);
		var ApplyIdStr = '';
		var Sels = SelReqMasterGrid.getSelections();
		for (var i = 0, Len = Sels.length; i < Len; i++) {
			var ApplyId = Sels[i]['RowId'];
			if (ApplyIdStr === '') {
				ApplyIdStr = ApplyId;
			} else {
				ApplyIdStr = ApplyIdStr + ',' + ApplyId;
			}
		}
		if (ApplyIdStr === '') {
			return;
		}
		SelReqDetailGrid.load({
			ClassName: 'web.CSSDHUI.PackageDisp.CreateDispByApply',
			QueryName: 'SelectByF',
			ApplyId: ApplyIdStr,
			rows: 9999
		});
	}
	
	$HUI.dialog('#SelReqWinBorrow', {
		onOpen: function() {
			SelReqDefa();
			SelReqQuery();
		}
	});
};
$(initSelReqApply);