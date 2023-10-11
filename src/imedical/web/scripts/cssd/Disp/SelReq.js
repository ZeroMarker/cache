// 临床包发放中的查看回收单弹框
var gFn, gExcludeExt;
function SelReq(Fn, ExcludeExt) {
	gFn = Fn;
	gExcludeExt = ExcludeExt;
	$HUI.dialog('#SelReqWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
}
var initSelReq = function() {
	$UI.clearBlock('#SelReqConditions');
	var ReqLocParams = JSON.stringify(addSessionParams({ Type: 'RecLoc', BDPHospital: gHospId }));
	$HUI.combobox('#CReqLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId, SupLocId: record.RowId }));
			var PUrl = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetLine&ResultSetType=array&Params=' + Params;
			$('#CLineCode').combobox('reload', PUrl).combobox('clear');
		}
	});
	var LineParams = JSON.stringify(addSessionParams({ SupLocId: gLocId, BDPHospital: gHospId }));
	$HUI.combobox('#CLineCode', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetLine&ResultSetType=array&Params=' + LineParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	// 扫码动作
	$('#CBBarCode').keyup(function(event) {
		if (event.which == 13) {
			SelReqQuery();
		}
	}).focus(function(event) {
		$('#CBBarCode').val('');
		$('#CBBarCodeHidden').val('');
		var ReadOnly = $('#CBBarCode').attr('readonly');
		if (ReadOnly == 'readonly') {
			$('#CBBarCodeHidden').focus();
		}
		InitScanIcon();
	}).blur(function(event) {
		InitScanIcon();
	});
	$('#CBBarCodeHidden').keyup(function(event) {
		if (event.which == 13) {
			var HiddenVal = $('#CBBarCodeHidden').val();
			$('#CBBarCode').val(HiddenVal);
			$('#CBBarCodeHidden').val('');
			SelReqQuery();
		}
	}).focus(function(enent) {
		InitScanIcon();
	}).blur(function(event) {
		InitScanIcon();
	});
	// 控制标签是否允许编辑
	$('#CBBarCodeSwitchBT').linkbutton({
		iconCls: 'icon-w-switch',
		// plain: true,
		// iconCls: 'icon-key-switch',
		onClick: function() {
			var ReadOnly = $('#CBBarCode').attr('readonly');		// 只读时,此值为'readonly'
			if (ReadOnly == 'readonly') {
				$('#CBBarCode').attr({ readonly: false });
				SetLocalStorage('CBBarCodeHidden', '');
			} else {
				$('#CBBarCode').attr({ readonly: true });
				SetLocalStorage('CBBarCodeHidden', 'Y');
			}
			$('#CBBarCode').focus();
		}
	});
	// 控制扫码图标
	function InitScanIcon() {
		var ElementId = document.activeElement.id;
		var ReadOnly = $('#CBBarCode').attr('readonly');
		if (ElementId == 'CBBarCodeHidden') {
			// 扫描icon
			$('#CBBarCodeBT').linkbutton({ iconCls: 'icon-scanning' });
		} else if (ReadOnly == 'readonly') {
			// 只读icon
			$('#CBBarCodeBT').linkbutton({ iconCls: 'icon-gray-edit' });
		} else {
			// 可编辑icon
			$('#CBBarCodeBT').linkbutton({ iconCls: 'icon-blue-edit' });
		}
	}
	if (GetLocalStorage('CBBarCodeHidden') == 'Y') {
		$('#CBBarCode').attr({ 'readonly': true });
	} else {
		$('#CBBarCode').attr({ 'readonly': false });
	}
	InitScanIcon();

	$UI.linkbutton('#SelReqQueryBT', {
		onClick: function() {
			SelReqQuery();
		}
	});
	function SelReqQuery() {
		var ParamsObj = $UI.loopBlock('#SelReqWin');
		ParamsObj['ApplyType'] = '0,5';
		ParamsObj['ExcludeExt'] = gExcludeExt;
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
	
	$UI.linkbutton('#SelReqCreateBT', {
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
				$('#SelReqWin').window('close');
				var MainIdStr = jsonData.rowid;
				gFn(MainIdStr);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	function SelReqDefa() {
		$UI.clearBlock('#SelReqConditions');
		var Default = {
			StartDate: $UI.loopBlock('#MainCondition').FStartDate,
			EndDate: $UI.loopBlock('#MainCondition').FEndDate
		};
		$UI.fillBlock('#SelReqConditions', Default);
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
				if (row.ReqLevel === '1') {
					str = '<div class="col-icon icon-emergency" href="#" title="紧急"></div>';
				}
				return str;
			}
		}, {
			title: '单号',
			align: 'left',
			field: 'No',
			width: 110
		}, {
			title: '回收科室',
			align: 'left',
			field: 'ReqLocDesc',
			width: 100
		}, {
			title: '回收日期',
			align: 'left',
			field: 'AckDate',
			width: 180
		}, {
			title: '回收人',
			align: 'left',
			field: 'AckUserDesc',
			width: 100
		}, {
			title: '已全部生成发放单',
			align: 'center',
			field: 'AllCreateFlag',
			width: 120
		}
	]];
	var SelReqMasterGrid = $UI.datagrid('#SelReqMasterGrid', {
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
				$('#SelReqMasterGrid').datagrid('selectRow', 0);
			}
		},
		onSelect: function(index, rowData) {
			FindItemByF();
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
			title: 'MainId',
			field: 'MainId',
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
			width: 200
		}, {
			title: '标牌',
			field: 'CodeDict',
			width: 110
		}, {
			title: '标签',
			field: 'Label',
			width: 160
		}, {
			title: '标签状态',
			field: 'Status',
			width: 160
		}, {
			title: '已回收数',
			align: 'right',
			field: 'BackQty',
			width: 90
		}, {
			title: '发放数',
			align: 'right',
			field: 'DispQty',
			width: 90
		}, {
			title: '要发放数',
			align: 'right',
			field: 'PreDispQty',
			width: 90,
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
	var SelReqDetailGrid = $UI.datagrid('#SelReqDetailGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.CreateDispByApply',
			QueryName: 'SelectByF'
		},
		columns: SelReqDetailCm,
		pagination: false,
		singleSelect: false,
		sortName: 'RowId',
		sortOrder: 'desc',
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$.each(data.rows, function(index, row) {
					if (row.PreDispQty > 0) {
						SelReqDetailGrid.checkRow(index);
					}
				});
			}
		},
		onBeforeCheck: function(index, row) {
			if (row.PreDispQty == 0) {
				$UI.msg('alert', '要发放数为0!');
				return false;
			}
		},
		onClickCell: function(index, field, value) {
			if (!isEmpty(SelReqDetailGrid.getRows()[index].Label)) {
				return false;
			}
			SelReqDetailGrid.commonClickCell(index, field);
			IsCheckFlag = false;
		},
		onSelect: function(index, rowData) {
			if (!IsCheckFlag) {
				IsCheckFlag = true;
				$('#SelReqDetailGrid').datagrid('unselectRow', index);
			}
		},
		onUnselect: function(index, row) {
			if (!IsCheckFlag) {
				IsCheckFlag = true;
				$('#SelReqDetailGrid').datagrid('selectRow', index);
			}
		}
	});
	
	function FindItemByF() {
		$UI.clear(SelReqDetailGrid);
		var FormObj = $UI.loopBlock('#SelReqWin');
		var ParamsObj = { ExcludeExt: gExcludeExt, Attribute: FormObj.Attribute };
		var Params = JSON.stringify(addSessionParams(ParamsObj));
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
			Params: Params,
			rows: 9999
		});
	}
	$HUI.dialog('#SelReqWin', {
		onOpen: function() {
			SelReqDefa();
			SelReqQuery();
		}
	});
};
$(initSelReq);