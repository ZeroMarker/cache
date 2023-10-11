// /消毒包调拨
var MainGrid, TrfItmGrid, UnTrfItmGrid;
var CurrMainId;// 当前主单id(全局变量)
var DocType = '1';	// 单据类型
// 提交
function submitOrder(mainRowId) {
	if (isEmpty(mainRowId)) {
		$UI.msg('alert', '请选择要提交的单据!');
		return false;
	}
	var ParamsObj = $UI.loopBlock('#MainCondition');
	ParamsObj.mainRowId = mainRowId;
	var Params = JSON.stringify(ParamsObj);
	showMask();
	$.cm({
		ClassName: 'web.CSSDHUI.PackageDisp.Disp',
		MethodName: 'jsSubmitOrder',
		Params: Params
	}, function(jsonData) {
		hideMask();
		if (jsonData.success === 0) {
			$UI.msg('success', jsonData.msg);
			CurrMainId = mainRowId;
			$('#MainGrid').datagrid('reload');
			GetMarkQty();
		} else {
			$UI.msg('error', jsonData.msg);
		}
	});
}
// 撤销
function cancelOrder(mainRowId) {
	if (isEmpty(mainRowId)) {
		$UI.msg('alert', '请选择要撤销的单据!');
		return false;
	}
	if (DispParamObj.RequiredCancel == 'Y') {
		$UI.confirm('您确定要执行撤销操作吗？', '', '', Cancel, '', '', '', '', mainRowId);
	} else {
		Cancel(mainRowId);
	}
}

function Cancel(mainRowId) {
	var ParamsObj = $UI.loopBlock('#MainCondition');
	ParamsObj.mainRowId = mainRowId;
	var Params = JSON.stringify(ParamsObj);
	showMask();
	$.cm({
		ClassName: 'web.CSSDHUI.PackageDisp.Disp',
		MethodName: 'jsCancelOrder',
		Params: Params
	}, function(jsonData) {
		hideMask();
		if (jsonData.success === 0) {
			$UI.msg('success', jsonData.msg);
			CurrMainId = mainRowId;
			$('#MainGrid').datagrid('reload');
			GetMarkQty();
		} else {
			$UI.msg('error', jsonData.msg);
		}
	});
}

// 显示数量角标
function GetMarkQty() {
	var ConditonObj = $UI.loopBlock('#MainCondition');
	var ParamsObj = {};
	ParamsObj.fromLocDr = ConditonObj.fromLocDr;
	ParamsObj.FStartDate = ConditonObj.FStartDate;
	ParamsObj.FEndDate = ConditonObj.FEndDate;
	ParamsObj.FComplateFlag = 'Y';
	ParamsObj.DocType = 1;
	ParamsObj.FStatu = 'N';
	var Params = JSON.stringify(addSessionParams(ParamsObj));
	var MarkQtyObj = $.cm({
		ClassName: 'web.CSSDHUI.PackageDisp.DispScan',
		MethodName: 'GetMarkQty',
		Params: Params
	}, false);
	$('#UnTrfInNum').html(MarkQtyObj.UnTrfInNum);
}
	
var init = function() {
	// 调拨科室
	var FrLocParams = JSON.stringify(addSessionParams({ Type: 'Login', BDPHospital: gHospId }));
	$HUI.combobox('#fromLocDr', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FrLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			$HUI.combobox('#fromUserDr').clear();
			var FrUserParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, LocId: record.RowId }));
			var url = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array&Params=' + FrUserParams;
			$HUI.combobox('#fromUserDr').reload(url);
			GetMarkQty();
		}
	});
	// 接收科室
	var ToLocParams = JSON.stringify(addSessionParams({ Type: 'RecLoc', BDPHospital: gHospId }));
	$HUI.combobox('#toLocDr', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ToLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	// 调拨人
	var FrUserParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	$HUI.combobox('#fromUserDr', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array&Params=' + FrUserParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	$UI.linkbutton('#UnTrfInBT', {
		onClick: function() {
			UnTrfInWin();
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	
	function Clear() {
		DefaultData();
	}
	
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			Save();
		}
	});
	
	function Save() {
		var MainObj = $UI.loopBlock('#MainCondition');
		if (isEmpty(MainObj.fromLocDr)) {
			$UI.msg('alert', '调拨科室不能为空！');
			return;
		}
		if (isEmpty(MainObj.toLocDr)) {
			$UI.msg('alert', '接收科室不能为空！');
			return;
		}
		if (MainObj.fromLocDr == MainObj.toLocDr) {
			$UI.msg('alert', '调拨科室与接收科室不能相同！');
			return;
		}
		MainObj.DocType = DocType;
		MainObj.Type = 'Y';
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.PackageDisp.DispScan',
			MethodName: 'jsSave',
			Params: JSON.stringify(MainObj)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				CurrMainId = jsonData.rowid;
				Query(jsonData.rowid);
				$('#BarCode').focus();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	
	function Query(RowId) {
		var ParamsObj = $UI.loopBlock('#MainCondition');
		if (isEmpty(ParamsObj.fromLocDr)) {
			$UI.msg('alert', '请选择调拨科室！');
			return;
		}
		if (isEmpty(ParamsObj.FStartDate)) {
			$UI.msg('alert', '起始日期不能为空！');
			return;
		}
		if (isEmpty(ParamsObj.FEndDate)) {
			$UI.msg('alert', '截止日期不能为空！');
			return;
		}
		ParamsObj.RowId = RowId;
		ParamsObj.DocType = DocType;
		MainGrid.load({
			ClassName: 'web.CSSDHUI.PackageDisp.DispScan',
			QueryName: 'SelectAll',
			Params: JSON.stringify(ParamsObj)
		});

		GetMarkQty();
	}
	
	var MainCm = [[
		{
			title: '',
			field: 'ck',
			checkbox: true,
			frozen: true,
			width: 50
		}, {
			field: 'operate',
			title: '操作',
			frozen: true,
			align: 'center',
			width: 90,
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '';
				if (row.ComplateFlag == 'Y') {
					str = '<div class="col-icon icon-back" href="#" title="' + $g('撤销') + '" onclick="cancelOrder(' + row.RowId + ')"></div>';
				} else {
					str = '<div class="col-icon icon-cancel" href="#" title="' + $g('删除') + '" onclick="MainGrid.commonDeleteRow(true,' + index + ');"></div>'
					+ '<div class="col-icon icon-submit" href="#" title="' + $g('提交') + '" onclick="submitOrder(' + row.RowId + ')"></div>';
				}
				if (row.LevelFlag == '1') {
					str = str + '<div class="col-icon icon-emergency" href="#" title="' + $g('紧急') + '"></div>';
				}
				return str;
			}
		}, {
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
	
	MainGrid = $UI.datagrid('#MainGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.DispScan',
			QueryName: 'SelectAll'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.DispScan',
			MethodName: 'jsDelete'
		},
		columns: MainCm,
		sortOrder: 'desc',
		sortName: 'RowId',
		selectOnCheck: false,
		onLoadSuccess: function(data) {
			$UI.clear(TrfItmGrid);
			$UI.clear(UnTrfItmGrid);
			if (data.rows.length > 0) {
				var GridListIndex = '';
				if (!isEmpty(CurrMainId)) {
					var Rows = $('#MainGrid').datagrid('getRows');
					$.each(Rows, function(index, item) {
						if (item.RowId == CurrMainId) {
							GridListIndex = index;
							return false;
						}
					});
					CurrMainId = '';
				} else if (CommParObj.SelectFirstRow == 'Y') {
					GridListIndex = 0;
				}
				if (!isEmpty(GridListIndex)) {
					$('#MainGrid').datagrid('selectRow', GridListIndex);
				}
			}
		},
		onClickRow: function(index, row) {
			MainGrid.commonClickRow(index, row);
		},
		onSelect: function(index, rowData) {
			var RowId = rowData.RowId;
			if (!isEmpty(RowId)) {
				FindItem(RowId);
			}
		}
	});

	// 扫码动作
	$('#BarCode').keyup(function(event) {
		if (event.which == 13) {
			var Label = $('#BarCode').val();
			AddDispItem(Label);
		}
	}).focus(function(event) {
		$('#BarCode').val('');
		$('#BarCodeHidden').val('');
		var ReadOnly = $('#BarCode').attr('readonly');
		if (ReadOnly == 'readonly') {
			$('#BarCodeHidden').focus();
		}
		InitScanIcon();
	}).blur(function(event) {
		InitScanIcon();
	});
	$('#BarCodeHidden').keyup(function(event) {
		if (event.which == 13) {
			var HiddenVal = $('#BarCodeHidden').val();
			$('#BarCode').val(HiddenVal);
			$('#BarCodeHidden').val('');
			AddDispItem(HiddenVal);
		}
	}).focus(function(enent) {
		InitScanIcon();
	}).blur(function(event) {
		InitScanIcon();
	});
	// 控制标签是否允许编辑
	$('#BarCodeSwitchBT').linkbutton({
		onClick: function() {
			var ReadOnly = $('#BarCode').attr('readonly');		// 只读时,此值为'readonly'
			if (ReadOnly == 'readonly') {
				$('#BarCode').attr({ readonly: false });
				SetLocalStorage('BarCodeHidden', '');
			} else {
				$('#BarCode').attr({ readonly: true });
				SetLocalStorage('BarCodeHidden', 'Y');
			}
			$('#BarCode').focus();
		}
	});
	// 控制扫码图标
	function InitScanIcon() {
		var ElementId = document.activeElement.id;
		var ReadOnly = $('#BarCode').attr('readonly');
		if (ElementId == 'BarCodeHidden') {
			// 扫描icon
			$('#UseBarCodeBT').linkbutton({ iconCls: 'icon-scanning' });
		} else if (ReadOnly == 'readonly') {
			// 只读icon
			$('#UseBarCodeBT').linkbutton({ iconCls: 'icon-gray-edit' });
		} else {
			// 可编辑icon
			$('#UseBarCodeBT').linkbutton({ iconCls: 'icon-blue-edit' });
		}
	}
	if (GetLocalStorage('BarCodeHidden') == 'Y') {
		$('#BarCode').attr({ 'readonly': true });
	} else {
		$('#BarCode').attr({ 'readonly': false });
	}
	InitScanIcon();
	
	function AddDispItem(Label) {
		var row = $('#MainGrid').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择调拨单据!');
			return;
		}
		if (isEmpty(Label)) {
			$UI.msg('alert', '请录入标签信息!');
			return;
		}
		var LabelArr = Label;
		if (typeof Label !== 'object') {
			LabelArr = [{ Label: Label }];
		}
		
		var Params = JSON.stringify(LabelArr);
		var MainParams = JSON.stringify(addSessionParams({ MainId: row.RowId }));
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.PackageDisp.DispDetail',
			MethodName: 'jsSaveDetail',
			MainParams: MainParams,
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				FindItem(row.RowId);
			} else {
				$UI.msg('error', jsonData.msg);
			}
			$('#BarCode').val('').focus();
		});
	}
	var ItemCm = [[
		{
			field: 'ck',
			checkbox: true,
			frozen: true
		}, {
			field: 'operate',
			title: '标识',
			frozen: true,
			align: 'center',
			width: 40,
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '';
				if (row.LevelFlag === '1') {
					str = str + '<div class="col-icon icon-emergency" href="#" title="' + $g('紧急') + '"></div>';
				}
				return str;
			}
		}, {
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
	TrfItmGrid = $UI.datagrid('#TrfItmGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.DispItm',
			MethodName: 'SelectByF'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.DispItm',
			MethodName: 'jsDelete'
		},
		columns: ItemCm,
		pagination: false,
		singleSelect: false,
		showDelItems: true,
		beforeDelFn: function() {
			var MainObj = $('#MainGrid').datagrid('getSelected');
			if (MainObj.ComplateFlag == 'Y') {
				$UI.msg('alert', '发放单已提交不能删除明细!');
				return false;
			}
		},
		afterDelFn: function() {
			$('#UnTrfItmGrid').datagrid('reload');
		}
	});
	
	var UnItmCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			saveCol: true,
			width: 50,
			sortable: true,
			hidden: true
		}, {
			field: 'operate',
			title: '标识',
			align: 'center',
			width: 40,
			formatter: function(value, row, index) {
				var str = '';
				if (row.LevelFlag == '1') {
					str = str + '<div class="col-icon icon-emergency" href="#" title="' + $g('紧急') + '"></div>';
				}
				return str;
			}
		}, {
			title: '标签',
			field: 'Label',
			width: 180,
			sortable: true
		}, {
			title: '消毒包',
			field: 'PackageName',
			width: 150,
			sortable: true
		}, {
			title: '包装材料',
			align: 'left',
			field: 'PackMaterial',
			width: 80
		}, {
			title: '消毒包属性Dr',
			field: 'PackageTypeDetail',
			width: 100,
			align: 'left',
			sortable: true,
			hidden: true
		}, {
			title: '消毒包属性',
			field: 'PackageTypeDetailName',
			width: 100,
			align: 'left',
			sortable: true
		}, {
			title: '日期',
			field: 'CSSDTDate',
			width: 100,
			sortable: true
		}, {
			title: '失效日期',
			field: 'ExpDate',
			width: 100,
			sortable: true
		}, {
			title: '科室',
			field: 'LocDesc',
			width: 120,
			sortable: true
		}, {
			title: '紧急状态',
			field: 'LevelFlag',
			width: 60,
			hidden: true
		}
	]];
	
	UnTrfItmGrid = $UI.datagrid('#UnTrfItmGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeItem',
			QueryName: 'SelectAllSter'
		},
		columns: UnItmCm,
		singleSelect: false,
		pagination: false,
		onDblClickRow: function(index, row) {
			var Label = row['Label'];
			if (isEmpty(Label)) {
				$UI.msg('alert', '未获取到标签信息!');
				return;
			}
			AddDispItem(Label);
		}
	});
	
	function FindItem(Id) {
		TrfItmGrid.load({
			ClassName: 'web.CSSDHUI.PackageDisp.DispItm',
			QueryName: 'SelectByF',
			MainId: Id,
			sort: 'RowId',
			order: 'desc',
			rows: 9999
		});
		
		var ParamsObj = $UI.loopBlock('#UnTrfConditions');
		ParamsObj.DocType = DocType;
		ParamsObj.DispMainId = Id;
		ParamsObj.Type = 'opr';
		ParamsObj.fromLocDr = $('#fromLocDr').combobox('getValue');
		var Params = JSON.stringify(ParamsObj);
		UnTrfItmGrid.load({
			ClassName: 'web.CSSDHUI.PackageDisp.DispDetail',
			QueryName: 'SelectAllSter',
			Params: Params,
			rows: 9999
		});
		
		$('#BarCode').focus();
	}
	
	function DefaultData() {
		$UI.clear(MainGrid);
		$UI.clear(TrfItmGrid);
		$UI.clear(UnTrfItmGrid);
		$UI.clearBlock('#MainCondition');
		var DefaultVal = {
			fromLocDr: gLocObj,
			FStartDate: DefaultStDate(),
			FEndDate: DefaultEdDate()
		};
		$UI.fillBlock('#MainCondition', DefaultVal);
	}
	
	function AdjustLayoutSize() {
		var NorthWidth = $(window).width() * 0.50;
		var DispWestWidth = $(window).width() * 0.25;
		$('#LayOut').layout('panel', 'east').panel('resize', { width: NorthWidth });
		$('#LayOut').layout();
		$('#LabelLayout').layout('panel', 'west').panel('resize', { width: DispWestWidth });
		$('#LabelLayout').layout();
	}
	window.onresize = function() {
		AdjustLayoutSize();
	};
	AdjustLayoutSize();
	DefaultData();
	Query();
};
$(init);