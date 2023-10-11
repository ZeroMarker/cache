// 消毒包发放
var MainListGrid, ItemListGrid;
var tabTitle = '发放详情';
var CurrMainId;// 当前主单id(全局变量)
var DocType = '0';
// 提交
function submitOrder(mainRowId) {
	var ParamsObj = $UI.loopBlock('#MainCondition');
	if (isEmpty(mainRowId)) {
		$UI.msg('alert', '请选择要提交的单据!');
		return false;
	}
	ParamsObj.mainRowId = mainRowId;
	var Params = JSON.stringify(ParamsObj);
	showMask();
	$.cm({
		ClassName: 'web.CSSDHUI.PackageDisp.Disp',
		MethodName: 'jsSubmitOrder',
		Params: Params
	}, function(jsonData) {
		hideMask();
		if (jsonData.success == 0) {
			$UI.msg('success', jsonData.msg);
			CurrMainId = mainRowId;
			$('#MainList').datagrid('reload');
			// $('#ItemList').datagrid('reload');
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
		$.messager.confirm('操作提示', '您确定要执行撤销操作吗？', function(data) {
			if (data) {
				Cancel(mainRowId);
			}
		});
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
		if (jsonData.success == 0) {
			$UI.msg('success', jsonData.msg);
			CurrMainId = mainRowId;
			$('#MainList').datagrid('reload');
		} else {
			$UI.msg('error', jsonData.msg);
		}
	});
}
var init = function() {
	// 获取页面传参
	function getQueryVariable(variable) {
		var query = window.location.search.substring(1);
		var vars = query.split('&');
		for (var i = 0; i < vars.length; i++) {
			var pair = vars[i].split('=');
			if (pair[0] === variable) {
				return pair[1];
			}
		}
		return (false);
	}
	// 发放科室
	var ReqLocParams = JSON.stringify(addSessionParams({ Type: 'Login', BDPHospital: gHospId }));
	$HUI.combobox('#fromLocDr', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			$HUI.combobox('#fromUserDr').clear();
			var FrUserParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, LocId: record.RowId }));
			var url = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array&Params=' + FrUserParams;
			$HUI.combobox('#fromUserDr').reload(url);
		}
	});
	// 接收科室
	var SupLocParams = JSON.stringify(addSessionParams({ Type: 'RecLoc', BDPHospital: gHospId }));
	$HUI.combobox('#toLocDr', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SupLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	// 设置默认科室
	$HUI.checkbox('#LocDefaultFlag', {
		onCheckChange: function(e, value) {
			if (value) {
				$('#toLocDr').combobox('setValue', '');
				var LocObj = GetDefaultLoc('RecLoc', gHospId);
				if (isEmpty(LocObj.RowId)) {
					$('#LocDefaultFlag').checkbox('setValue', false);
					$UI.msg('alert', '未设置默认科室');
					return;
				} else {
					AddComboData($('#toLocDr'), LocObj.RowId, LocObj.Description);
					$('#toLocDr').combobox('setValue', LocObj.RowId);
				}
			} else {
				$('#toLocDr').combobox('setValue', '');
			}
		}
	});
	
	// 发放人
	var ParamsTB = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	$HUI.combobox('#fromUserDr', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array&Params=' + ParamsTB,
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		spellField: 'Code'
	});
	$('#fromUserDr').combobox('textbox').keyup(function(event) {
		if (event.keyCode == 13) {
			var userCode = $('#fromUserDr').combobox('getText');
			if (userCode != '') {
				var UserObj = $.cm({
					ClassName: 'web.CSSDHUI.Common.Dicts',
					MethodName: 'GetUserByCodeJson',
					userCode: userCode,
					Params: ParamsTB
				}, false);
				if (UserObj['RowId'] === '') {
					$UI.msg('alert', '未获取审核人相关信息！');
					$('#fromUserDr').combobox('clear');
					$('#fromUserDr').combobox('setValue', '').combobox('hidePanel');
					$('#fromUserDr').combobox('textbox').focus();
					return;
				}
				$('#fromUserDr').combobox('clear');
				$('#fromUserDr').combobox('setValue', UserObj['RowId']).combobox('hidePanel');
			}
		}
	});

	var PkgParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, AttributeCode: '1,2,7' }));
	$HUI.combobox('#packageDesc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + PkgParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	// 批量提交
	function submitAll() {
		$.messager.confirm('操作提示', '您确定要执行批量提交操作吗？', function(data) {
			if (data) {
				var Rows = MainListGrid.getChecked();
				if (isEmpty(Rows)) {
					$UI.msg('alert', '请选择需要提交单据');
					return;
				}
				var MainIdStr = '';
				for (var i = 0, Len = Rows.length; i < Len; i++) {
					var MainId = Rows[i]['RowId'];
					var ComplateFlag = Rows[i]['ComplateFlag'];
					if (ComplateFlag === 'Y') {
						$UI.msg('alert', '存在已提交单据！');
						return;
					}
					if (MainIdStr === '') {
						MainIdStr = MainId;
					} else {
						MainIdStr = MainIdStr + ',' + MainId;
					}
				}
				submitOrder(MainIdStr);
			}
		});
	}
	// 打印单据
	function Print() {
		var Detail = MainListGrid.getChecked();
		if (isEmpty(Detail)) {
			$UI.msg('alert', '请选择需要打印单据');
			return;
		}
		var DispStr = '';
		for (var i = 0; i < Detail.length; i++) {
			var DispId = Detail[i].RowId;
			if (DispStr == '') {
				DispStr = DispId;
			} else {
				DispStr = DispStr + '^' + DispId;
			}
		}
		if (DispStr == '') {
			$UI.msg('alert', '请选择需要打印的信息!');
			return false;
		}
		PrintDispMain(DispStr);
	}
	
	function PrintSum() {
		var Detail = MainListGrid.getChecked();
		if (isEmpty(Detail)) {
			$UI.msg('alert', '请选择需要打印单据');
			return;
		}
		var DetailIds = '';
		if (!isEmpty(Detail)) {
			$.each(Detail, function(index, item) {
				if (DetailIds == '') {
					DetailIds = item.RowId;
				} else {
					DetailIds = DetailIds + ',' + item.RowId;
				}
			});
		}
		var RaqName = 'CSSD_HUI_DispPrintSum.raq';
		PrintINDispSum(RaqName, DetailIds);
	}
	
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			saveMast();
		}
	});
	
	function saveMast() {
		var MainObj = $UI.loopBlock('#MainCondition');
		if (MainObj.fromLocDr == MainObj.toLocDr) {
			$UI.msg('alert', '发放科室和接收科室不能相同');
			return;
		}
		if (DispParamObj['RequiredDispUser'] === 'Y' && isEmpty(MainObj.fromUserDr)) {
			$UI.msg('alert', '发放人不能为空');
			return false;
		} else {
			if (isEmpty(MainObj.fromUserDr)) {
				MainObj.fromUserDr = gUserId;
			}
		}
		if (isEmpty(MainObj.fromUserDr)) {
			$UI.msg('alert', '回收人不能为空');
			return;
		}
		if (isEmpty(MainObj.toLocDr)) {
			$UI.msg('alert', '接收科室不能为空');
			return;
		}
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
				$('#fromUserDr').val('');
				$('#fromUserDr').combobox('setValue', '').combobox('hidePanel');
				$('#toLocDr').combobox('setValue', '');
				CurrMainId = jsonData.rowid;
				query(jsonData.rowid);
				$('#BarCode').focus();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			$UI.clear(MainListGrid);
			$UI.clear(ItemListGrid);
			query();
		}
	});
	function query(RowId) {
		var ParamsObj = $UI.loopBlock('#MainCondition');
		var fromlocdr = ParamsObj.fromLocDr;
		if (isEmpty(fromlocdr)) {
			$UI.msg('alert', '请选择发放科室！');
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
		
		if (ParamsObj.FComplateFlag != 'Y') {
			SetLocalStorage('CompleteFlag', ParamsObj.FComplateFlag);
		}

		MainListGrid.load({
			ClassName: 'web.CSSDHUI.PackageDisp.DispScan',
			QueryName: 'SelectAll',
			Params: JSON.stringify(ParamsObj)
		});
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
				if (row.ComplateFlag === 'Y') {
					str = '<div class="col-icon icon-back" href="#" title="' + $g('撤销') + '" onclick="cancelOrder(' + row.RowId + ')"></div>';
				} else {
					str = '<div class="col-icon icon-cancel" href="#" title="' + $g('删除') + '" onclick="MainListGrid.commonDeleteRow(true,' + index + ');"></div>'
							+ '<div class="col-icon icon-submit" href="#" title="' + $g('提交') + '" onclick="submitOrder(' + row.RowId + ')"></div>';
				}
				if (row.LevelFlag === '1') {
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
			title: '发放单号',
			field: 'No',
			width: 120
		}, {
			title: '接收科室',
			field: 'ToLocDesc',
			width: 100
		}, {
			title: '发放人',
			field: 'FromUserDesc',
			width: 100
		}, {
			title: '制单时间',
			field: 'DispDate',
			width: 160
		}, {
			title: '提交标志',
			field: 'ComplateFlag',
			hidden: true,
			align: 'center',
			width: 80
		}, {
			title: '提交人',
			field: 'DispCHKUserDesc',
			width: 100
		}, {
			title: '提交时间',
			field: 'DispCHKDate',
			width: 160
		}, {
			title: '发放科室',
			field: 'FromLocDesc',
			width: 100
		}, {
			title: '紧急状态',
			field: 'LevelFlag',
			width: 50,
			hidden: true
		}, {
			title: 'ToLocDR',
			field: 'ToLocDR',
			width: 100,
			hidden: true
		}, {
			title: '接收标记',
			field: 'IsRec',
			align: 'center',
			width: 80
		}
	]];
	
	MainListGrid = $UI.datagrid('#MainList', {
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
		toolbar: [
			{
				id: 'submitAll',
				text: '批量提交',
				iconCls: 'icon-paper-submit',
				handler: function() {
					submitAll();
				}
			}, {
				text: '打印',
				iconCls: 'icon-print',
				handler: function() {
					Print();
				}
			}, {
				text: '汇总打印',
				iconCls: 'icon-print-box',
				handler: function() {
					PrintSum();
				}
			}
		],
		selectOnCheck: false,
		onLoadSuccess: function(data) {
			$UI.clear(ItemListGrid);
			$UI.clear(UnDispGrid);
			if (data.rows.length > 0) {
				var GridListIndex = '';
				if (!isEmpty(CurrMainId)) {
					var Rows = $('#MainList').datagrid('getRows');
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
					$('#MainList').datagrid('selectRow', GridListIndex);
				}
			}
		},
		onClickRow: function(index, row) {
			MainListGrid.commonClickRow(index, row);
		},
		onSelect: function(index, rowData) {
			var Id = rowData.RowId;
			if (!isEmpty(Id)) {
				quertItm();
			}
		}
	});

	$HUI.tabs('#DispTabs', {
		onSelect: function(title, index) {
			tabTitle = title;
			quertItm();
		}
	});
	
	function quertItm() {
		var row = $('#MainList').datagrid('getSelected');
		var Id = row.RowId;
		if (tabTitle === '发放详情') {
			$UI.clear(ItemListGrid);
			ItemListGrid.load({
				ClassName: 'web.CSSDHUI.PackageDisp.DispItm',
				QueryName: 'SelectByF',
				MainId: Id,
				sort: 'RowId',
				order: 'desc',
				rows: 9999
			});
		} else if (tabTitle === '发放汇总') {
			$UI.clear(DispItmSumGrid);
			DispItmSumGrid.load({
				ClassName: 'web.CSSDHUI.PackageDisp.DispItm',
				QueryName: 'DispItmSum',
				DispId: Id,
				rows: 9999
			});
		}
	}
	// 查询待发放
	$UI.linkbutton('#SelReqSearchBT', {
		onClick: function() {
			FindUnDispItmByF();
		}
	});
	// 批量添加标签
	$UI.linkbutton('#SelReqAddBT', {
		onClick: function() {
			var Rows = UnDispGrid.getChecked();
			if (isEmpty(Rows)) {
				$UI.msg('alert', '未获取到标签信息!');
				return;
			}
			for (var i = 0, Len = Rows.length; i < Len; i++) {
				var Label = Rows[i]['Label'];
				AddDispItem(Label);
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
	
	// 参数为Label字符串, 或者Array类型数据
	function AddDispItem(Label) {
		var row = $('#MainList').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择需要添加的发放单据!');
			return;
		}
		if (isEmpty(row.RowId)) {
			$UI.msg('alert', '没有可添加消毒包的发放单据!');
			return;
		}
		if (isEmpty(Label)) {
			$UI.msg('alert', '标签录入为空!');
			return;
		}
		var LabelArr = Label;
		if (typeof Label !== 'object') {
			LabelArr = [{ Label: Label }];
		}
		
		var Params = JSON.stringify(LabelArr);
		var MainParams = JSON.stringify(addSessionParams({ MainId: row.RowId }));
		$('#BarCode').attr('disabled', 'disabled');
		$.cm({
			ClassName: 'web.CSSDHUI.PackageDisp.DispDetail',
			MethodName: 'jsSaveDetail',
			MainParams: MainParams,
			Params: Params
		}, function(jsonData) {
			if (jsonData.success === 0) {
				playSuccess();
				$UI.msg('success', jsonData.msg);
				ItemListGrid.reload();
				UnDispGrid.reload();
			} else {
				playWarn();
				$UI.msg('error', jsonData.msg);
			}
			$('#BarCode').removeAttr('disabled');
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
	ItemListGrid = $UI.datagrid('#ItemList', {
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
			var rowItem = $('#ItemList').datagrid('getSelected');
			if (isEmpty(rowItem)) {
				$UI.msg('alert', '请选择要删除的发放单明细!');
				return false;
			}
			var MainObj = $('#MainList').datagrid('getSelected');
			if (MainObj.ComplateFlag === 'Y') {
				$UI.msg('alert', '发放单已提交不能删除明细!');
				return false;
			}
		},
		afterDelFn: function() {
			FindUnDispItmByF();
		}
	});

	var ItemSumCm = [[
		{
			title: '消毒包Id',
			field: 'PackageId',
			width: 100,
			hidden: true
		}, {
			title: '消毒包',
			field: 'PackageName',
			width: 150,
			showTip: true,
			tipWidth: 200
		}, {
			title: '合计数量',
			field: 'Qty',
			align: 'right',
			width: 80
		}
	]];
	var DispItmSumGrid = $UI.datagrid('#DispItmSumGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.DispItm',
			QueryName: 'DispItmSum'
		},
		columns: ItemSumCm,
		fitColumns: false,
		pagination: false
	});
	
	var UnDispCm = [[
		{
			title: '',
			field: 'ck',
			checkbox: true,
			frozen: true,
			width: 50
		}, {
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
					str = str + '<div class="icon-emergency col-icon" href="#" title="' + $g('紧急') + '"></div>';
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
	
	var UnDispGrid = $UI.datagrid('#UnDispGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.DispDetail',
			QueryName: 'SelectAllSter'
		},
		columns: UnDispCm,
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
	
	function FindUnDispItmByF() {
		var ParamsObj = $UI.loopBlock('#UnDispConditions');
		var Params = JSON.stringify(ParamsObj);
		ParamsObj.Type = 'opr';
		UnDispGrid.load({
			ClassName: 'web.CSSDHUI.PackageDisp.DispDetail',
			QueryName: 'SelectAllSter',
			Params: Params,
			rows: 9999
		});
	}
	
	function Default() {
		var StartDate = getQueryVariable('StartDate');
		var DefaultData = {
			fromLocDr: gLocObj,
			FStartDate: DefaultStDate(),
			FEndDate: DefaultEdDate(),
			FComplateFlag: GetLocalStorage('CompleteFlag') || ''
		};
		$UI.fillBlock('#MainCondition', DefaultData);
		$('#fromLocDr').combobox('setValue', gLocId);
		$UI.clearBlock('#UnDispConditions');
		var UnDispStartDate;
		if (StartDate == false) {
			UnDispStartDate = DateFormatter(DateAdd(new Date(), 'd', parseInt(-180)));
		} else {
			UnDispStartDate = StartDate;
		}
		var UnDispDefault = {
			StartDate: UnDispStartDate,
			EndDate: DefaultEdDate()
		};
		$UI.fillBlock('#UnDispConditions', UnDispDefault);
	}
	
	function AdjustLayoutSize() {
		var NorthWidth = $(window).width() - 620;
		var DispWestWidth = NorthWidth * 0.5;
		$('#DispLayout').layout('panel', 'east').panel('resize', { width: DispWestWidth });
		$('#DispLayout').layout();
	}
	window.onresize = function() {
		AdjustLayoutSize();
	};
	AdjustLayoutSize();
	Default();
	query();
	FindUnDispItmByF();
};
$(init);