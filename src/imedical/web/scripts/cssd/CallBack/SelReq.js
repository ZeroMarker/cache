var gFn;
var SelReq = function(Fn) {
	gFn = Fn;
	$HUI.dialog('#SelReqWin').open();
};
var initSelReq = function() {
	// 申请科室
	var SelReqLocParams = JSON.stringify(addSessionParams({ Type: 'RecLoc', BDPHospital: gHospId }));
	$HUI.combobox('#SelReqLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params=' + SelReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
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

	// 线路
	$HUI.combobox('#SLineCode', {
		valueField: 'RowId',
		textField: 'Description'
	});
	
	//灭菌方式
	var SterTypeParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	$HUI.combobox('#SterType', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetSterType&ResultSetType=array&Params' + SterTypeParams,
		valueField: 'RowId',
		textField: 'Description'
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
		ParamsObj.DateType = 1;
		ParamsObj.ReqStatus = 5;
		ParamsObj.IsCallBackAll = 'N';
		SelReqMasterGrid.load({
			ClassName: 'web.CSSDHUI.Apply.PackageApply',
			QueryName: 'SelectAll',
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
			$UI.msg('alert', '请选择需要生成的消毒包');
			return;
		}
		var ItemRowObj = SelReqDetailGrid.getSelectedData();
		var Params = JSON.stringify(addSessionParams());
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.CallBack.CallBack',
			MethodName: 'jsCreateCallBackByApply',
			Params: Params,
			ItemRow: JSON.stringify(ItemRowObj)
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
			field: 'operate',
			title: '标识',
			frozen: true,
			align: 'center',
			width: 80,
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '';
				if (row.ReqLevel === '1') {
					str = str + '<div href="#" class="icon-emergency col-icon" title="紧急"></div>';
				}
				if (row.BeInfected === 'Y') {
					str = str + '<div href="#" class="icon-virus col-icon" title="感染"></div>';
				}
				return str;
			}
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '单号',
			field: 'No',
			width: 110
		}, {
			title: '申请科室',
			field: 'ReqLocDesc',
			width: 150
		}, {
			title: '供应科室',
			field: 'SupLocDesc',
			width: 150
		}, {
			title: '紧急程度',
			field: 'ReqLevel',
			width: 100,
			hidden: true
		}, {
			title: '单据状态',
			field: 'ReqFlag',
			width: 80,
			hidden: true
		}, {
			title: '提交时间',
			field: 'commitDate',
			width: 150
		}, {
			title: '提交人',
			field: 'commitUser',
			width: 100
		}, {
			title: '单据类型',
			field: 'ReqType',
			width: 100,
			formatter: ReqTypeRenderer
		}, {
			title: '感染',
			field: 'BeInfected',
			width: 100,
			hidden: true
		}
	]];

	var SelReqMasterGrid = $UI.datagrid('#SelReqMasterGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Apply.PackageApply',
			QueryName: 'SelectAll'
		},
		columns: SelReqMasterCm,
		singleSelect: false,
		pagination: false,
		sortName: 'RowId',
		sortOrder: 'desc',
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#SelReqMasterGrid').datagrid('selectRow', 0);
			}
		},
		onSelect: function(index, row) {
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
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '消毒包',
			field: 'PackageName',
			width: 100,
			showTip: true,
			tipWidth: 200,
			tipTrackMouse: true,
			styler: function(value, row, index) {
				return 'background-color:' + row.SterTypeColor + ';' + 'color:' + GetFontColor(row.SterTypeColor);
			}
		}, {
			title: '标牌',
			field: 'BarCode',
			width: 100
		}, {
			title: '待回收数量',
			align: 'right',
			field: 'NotQty',
			width: 80,
			editor: { type: 'numberbox' }
		}, {
			title: '请领数量',
			align: 'right',
			field: 'ReqQty',
			width: 70
		}, {
			title: '已回收数量',
			align: 'right',
			field: 'BackQty',
			width: 80
		}, /* {
			title: '未回收数量',
			align: 'right',
			field: 'NotQty',
			width: 80
		}, {
			title: '待回收数量',
			align: 'right',
			field: 'PreQty',
			width: 80,
			editor: { type: 'numberbox' }
		},*/{
			title: '包装材料',
			field: 'MaterialId',
			width: 90,
			hidden: true
		}, {
			title: '包装材料',
			field: 'MaterialDesc',
			width: 90
		}, {
			title: '备注',
			field: 'Remark',
			width: 70
		}, {
			title: 'SterTypeColor',
			field: 'SterTypeColor',
			width: 100,
			hidden: true
		}/*, {
			title: '主表id',
			field: 'MainId',
			width: 100,
			hidden: true
		}*/
	]];

	var SelReqDetailGrid = $UI.datagrid('#SelReqDetailGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Apply.PackageApplyItm',
			QueryName: 'SelectByF'
		},
		columns: SelReqDetailCm,
		pagination: false,
		singleSelect: false,
		sortName: 'RowId',
		sortOrder: 'asc',
		fitColumns: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#SelReqDetailGrid').datagrid('selectAll');
			}
		},
		onClickCell: function(index, field, value) {
			SelReqDetailGrid.commonClickCell(index, field);
		}
	});
	
	function FindItemByF() {
		$UI.clear(SelReqDetailGrid);
		var ReqIdStr = '';
		var SterTypeId = $('#SterType').combobox('getValue');
		var SelRows = SelReqMasterGrid.getSelections();
		for (var i = 0, Len = SelRows.length; i < Len; i++) {
			var ReqId = SelRows[i]['RowId'];
			if (ReqIdStr == '') {
				ReqIdStr = ReqId;
			} else {
				ReqIdStr = ReqIdStr + ',' + ReqId;
			}
		}
		if (ReqIdStr == '') {
			return;
		}
		SelReqDetailGrid.load({
			ClassName: 'web.CSSDHUI.Apply.PackageApplyItm',
			QueryName: 'SelectByF',
			ApplyId: ReqIdStr,
			PSterTypeId:SterTypeId,
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
$(initSelReq);