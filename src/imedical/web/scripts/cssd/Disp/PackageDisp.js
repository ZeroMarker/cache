// 删除明细
var MainListGrid, ItemListGrid, ItemSListGrid;
var CurrMainId = '';
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
		if (jsonData.success === 0) {
			$UI.msg('success', jsonData.msg);
			CurrMainId = mainRowId;
			$('#MainList').datagrid('reload');
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
	if (DispParamObj.RequiredCancel === 'Y') {
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
		if (jsonData.success === 0) {
			$UI.msg('success', jsonData.msg);
			CurrMainId = mainRowId;
			$('#MainList').datagrid('reload');
		} else {
			$UI.msg('error', jsonData.msg);
		}
	});
}
var init = function() {
	// 发放科室
	var ReqLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	$HUI.combobox('#ReqLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var Params = JSON.stringify(addSessionParams({ SupLocId: record['RowId'], BDPHospital: gHospId }));
			var url = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetLine&ResultSetType=array&Params=' + Params;
			$('#LineCode').combobox('clear').combobox('reload', url);

			$HUI.combobox('#fromUserDr').clear();
			var FrUserParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, LocId: record.RowId }));
			url = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array&Params=' + FrUserParams;
			$HUI.combobox('#fromUserDr').reload(url);
		}
	});
	var LineParams = JSON.stringify(addSessionParams({ SupLocId: gLocId, BDPHospital: gHospId }));
	$HUI.combobox('#LineCode', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetLine&ResultSetType=array&Params=' + LineParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	// 接收科室
	var SupLocParams = JSON.stringify(addSessionParams({ Type: 'RecLoc' }));
	$HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SupLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.combobox('#ReqType', {
		valueField: 'RowId',
		textField: 'Description',
		data: ReqTypeAllData
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

	// 消毒包
	var PkgParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, TypeDetail: '1,2,7' }));
	$HUI.combobox('#PackageName', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + PkgParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	// 生成请领单
	$UI.linkbutton('#CreateBT', {
		onClick: function() {
			var ExcludeExt = 'Y';
			SelReq(query, ExcludeExt);
		}
	});
	// 通过借包单生成发放单
	$UI.linkbutton('#CreateBTApply', {
		onClick: function() {
			var ApplyType = '1';
			SelReqApply(query, ApplyType);
		}
	});
	$UI.linkbutton('#CreateBTFLApply', {
		onClick: function() {
			var ApplyType = '2';
			SelReqApply(query, ApplyType);
		}
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			query();
		}
	});
	
	// 扫码动作
	$('#BarCode').keyup(function(event) {
		if (event.which == 13) {
			AddOrdDispItem();
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
			AddOrdDispItem();
		}
	}).focus(function(enent) {
		InitScanIcon();
	}).blur(function(event) {
		InitScanIcon();
	});
	// 控制标签是否允许编辑
	$('#BarCodeSwitchBT').linkbutton({
		iconCls: 'icon-w-switch',
		// plain: true,
		// iconCls: 'icon-key-switch',
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
	
	function AddOrdDispItem() {
		var BarCode = $('#BarCode').val();
		var row = $('#MainList').datagrid('getSelected');
		var DetailParams = JSON.stringify([{ Label: BarCode }]);
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择需要添加的发放单据!');
			return;
		}
		if (isEmpty(row.RowId)) {
			$UI.msg('alert', '参数错误!');
			return;
		}
		if (isEmpty(BarCode)) {
			$UI.msg('alert', '标签扫描为空!');
			return;
		}
		var MainParams = JSON.stringify(addSessionParams({ MainId: row.RowId }));
		$('#BarCode').attr('disabled', 'disabled');
		$.cm({
			ClassName: 'web.CSSDHUI.PackageDisp.DispDetail',
			MethodName: 'jsSaveDetail',
			MainParams: MainParams,
			Params: DetailParams
		}, function(jsonData) {
			$('#BarCode').removeAttr('disabled');
			if (jsonData.success >= 0) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
				} else {
					$UI.msg('alert', jsonData.msg);
				}
				playSuccess();
				ItemListGrid.reload();
			} else {
				playWarn();
				$UI.msg('error', jsonData.msg);
			}
			
			$('#BarCode').val('').focus();
		});
	}

	function query(Rowid) {
		$UI.clear(ItemSListGrid);
		$UI.clear(ItemListGrid);
		$UI.clear(MainListGrid);
		var Params = '';
		if (!isEmpty(Rowid)) {
			Params = JSON.stringify(addSessionParams({ RowId: Rowid }));
			var RowidArr = Rowid.split(',');
			CurrMainId = RowidArr[0];
		} else {
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
			ParamsObj.DocType = DocType;
			Params = JSON.stringify(ParamsObj);
			
			if (ParamsObj.FComplateFlag != 'Y') {
				SetLocalStorage('CompleteFlag', ParamsObj.FComplateFlag);
			}
		}
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.PackageDisp.DispScan',
			QueryName: 'SelectAll',
			sort: 'RowId',
			order: 'desc',
			Params: Params
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
	// 汇总打印单据
	function PrintSum() {
		var Detail = MainListGrid.getChecked();
		if (isEmpty(Detail)) {
			$UI.msg('alert', '请选择需要打印单据');
			return;
		}
		var DetailIds = '';
		$.each(Detail, function(index, item) {
			if (DetailIds == '') {
				DetailIds = item.RowId;
			} else {
				DetailIds = DetailIds + ',' + item.RowId;
			}
		});
		var RaqName = 'CSSD_HUI_DispPrintSum.raq';
		PrintINDispSum(RaqName, DetailIds);
	}
	// 批量提交
	function submitAll() {
		var Rows = MainListGrid.getChecked();
		if (isEmpty(Rows)) {
			$UI.msg('alert', '请选择需要提交单据!');
			return;
		}
		for (var i = 0, Len = Rows.length; i < Len; i++) {
			var ComplateFlag = Rows[i]['ComplateFlag'];
			if (ComplateFlag === 'Y') {
				$UI.msg('alert', '存在已提交单据！');
				return;
			}
		}
		$.messager.confirm('操作提示', '您确定要执行批量提交操作吗？', function(data) {
			if (data) {
				Rows = MainListGrid.getChecked();
				var MainIdStr = '';
				for (var i = 0, Len = Rows.length; i < Len; i++) {
					var MainId = Rows[i]['RowId'];
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
			width: '100',
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '';
				if (row.ComplateFlag === 'Y') {
					str = '<div class="col-icon icon-back" href="#" title="撤销" onclick="cancelOrder(' + row.RowId + ')"></div>';
				} else {
					str = '<div class="col-icon icon-cancel" href="#" title="删除" onclick="MainListGrid.commonDeleteRow(true,' + index + ');"></div>'
							+ '<div class="col-icon icon-submit" href="#" title="提交" onclick="submitOrder(' + row.RowId + ')"></div>';
				}
				if (row.LevelFlag === '1') {
					str = str + '<div class="col-icon icon-emergency" href="#" title="紧急"></div>';
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
			align: 'left',
			field: 'No',
			styler: function(val, row, index) {
				if (row.IsOver == '1') {
					return OverColor;
				}
			},
			width: 120
		}, {
			title: '发放依据',
			align: 'left',
			field: 'ApplyTypeDesc',
			width: 120
		}, {
			title: '接收科室',
			align: 'left',
			field: 'ToLocDesc',
			width: 150
		}, {
			title: '发放人',
			align: 'left',
			field: 'FromUserDesc',
			width: 80
		}, {
			title: '发放时间',
			align: 'left',
			field: 'DispDate',
			width: 150
		}, {
			title: '申请人',
			align: 'left',
			field: 'ApplyUserName',
			width: 80
		}, {
			title: '申请时间',
			align: 'left',
			field: 'ApplyDateTime',
			width: 160
		}, {
			title: '提交标志',
			field: 'ComplateFlag',
			hidden: true,
			align: 'center',
			width: 80
		}, {
			title: '提交人',
			align: 'left',
			field: 'DispUserDesc',
			width: 80
		}, {
			title: '提交时间',
			align: 'left',
			field: 'DispCHKDate',
			width: 160
		}, {
			title: '接收标记',
			field: 'IsRec',
			align: 'center',
			width: 80
		}, {
			title: '发放科室',
			align: 'left',
			field: 'FromLocDesc',
			width: 150
		}, {
			title: 'IsOver',
			field: 'IsOver',
			width: 50,
			hidden: true
		}, {
			title: '回收单号',
			align: 'left',
			field: 'CallbackNo',
			width: 120
		}, {
			title: '回收人',
			align: 'left',
			field: 'CallBackUserName',
			width: 100
		}, {
			title: '回收时间',
			align: 'left',
			field: 'CallBackDateTime',
			width: 160
		}, {
			title: '申请单类型',
			field: 'ApplyType',
			width: 50,
			hidden: true
		}
	]];

	MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.DispScan',
			QueryName: 'SelectAll'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.Disp',
			MethodName: 'jsDelete'
		},
		toolbar: [
			{
				id: 'submitAll',
				text: '批量提交',
				iconCls: 'icon-paper-submit',
				handler: function() {
					submitAll();
				}
			}, {
				id: 'Print',
				text: '打印',
				iconCls: 'icon-print',
				handler: function() {
					Print();
				}
			}, {
				id: 'PrintSum',
				text: '汇总打印',
				iconCls: 'icon-print-box',
				handler: function() {
					PrintSum();
				}
			}
		],
		columns: MainCm,
		selectOnCheck: false,
		sortOrder: 'desc',
		sortName: 'RowId',
		onLoadSuccess: function(data) {
			$UI.clear(ItemListGrid);
			$UI.clear(ItemSListGrid);
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
			GetMarkQty();
		},
		onSelect: function(index, rowData) {
			var Id = rowData.RowId;
			var isOPRFlag = rowData.isOPRFlag;
			if ((isOPRFlag === 'N') && (DispParamObj['UseLabelForDisp']) === 'N') {
				$('#BarCode').attr('disabled', 'disabled');
			} else {
				$('#BarCode').removeAttr('disabled');
			}
			if (!isEmpty(Id)) {
				FindItemByF(Id);
			}
		},
		onClickRow: function(index, row) {
			MainListGrid.commonClickRow(index, row);
		}
	});
	// 消毒包下拉列表
	var packData = $.cm({
		ClassName: 'web.CSSDHUI.Common.Dicts',
		QueryName: 'GetPkg',
		ResultSetType: 'array',
		Params: PkgParams
	}, false);
	var PackageBox = {
		type: 'combobox',
		options: {
			data: packData,
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect: function(record) {
				var rows = ItemListGrid.getRows();
				var row = rows[ItemListGrid.editIndex];
				row.PackageName = record.Description;
			}
		}
	};
	
	// 包装材料
	var PackagePackCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetMaterials&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description'
		}
	};
	
	function BatchDisp() {
		var row = $('#MainList').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择需要发放的单据!');
			return;
		}
		if (row.ComplateFlag == 'Y') {
			$UI.msg('alert', '该单据已提交不允许添加!');
			return;
		}
		var DispMainRowid = row.RowId;
		var ApplyType = row.ApplyType;
		var ExcludeExt = 'Y';
		SelectDispCode(AddItms, DispMainRowid, 'ord', ApplyType, ExcludeExt);
	}
	
	function AddItms(barcodes) {
		var row = $('#MainList').datagrid('getSelected');
		var DetailParams = JSON.stringify(barcodes);
		var MainParams = JSON.stringify(addSessionParams({ MainId: row.RowId }));
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.PackageDisp.DispDetail',
			MethodName: 'jsSaveDetail',
			MainParams: MainParams,
			Params: DetailParams
		}, function(jsonData) {
			hideMask();
			if (jsonData.success >= 0) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
				} else {
					$UI.msg('alert', jsonData.msg);
				}
				playSuccess();
				ItemListGrid.reload();
			} else {
				playWarn();
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	var ItemCm = [[
		{
			field: 'ck',
			checkbox: true,
			frozen: true
		}, {
			field: 'operate',
			title: '操作',
			frozen: true,
			align: 'center',
			width: 80,
			allowExport: false,
			formatter: function(value, row, index) {
				var rowMain = $('#MainList').datagrid('getSelected');
				var str = '';
				if (rowMain.ComplateFlag !== 'Y') {
					str = str + '<div class="icon-cancel col-icon" href="#" title="删除" onclick="ItemListGrid.commonDeleteRow(false,' + index + ')"></div>';
				}
				if (row.LevelFlag === '1') {
					str = str + '<div class="icon-emergency col-icon" href="#" title="紧急"></div>';
				}
				return str;
			}
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: 'CallBackDetailDr',
			field: 'CallBackDetailDr',
			width: 100,
			hidden: true
		}, {
			title: '消毒包',
			align: 'left',
			field: 'PackageDR',
			width: 140,
			formatter: CommonFormatter(PackageBox, 'PackageDR', 'PackageName'),
			editor: PackageBox
		}, {
			title: '发放数',
			align: 'right',
			field: 'Qty',
			width: 75,
			editor: { type: 'numberbox', options: { required: true }}
		}, {
			title: '未扫码',
			align: 'right',
			field: 'UnDispQty',
			width: 75
		}, {
			title: '扫码数',
			align: 'right',
			field: 'DispQty',
			width: 75,
			styler: function(value, row, index) {
				if (row.DispQty > row.Qty) {
					return OverColor;
				}
			}
		}, {
			title: '未发数',
			align: 'right',
			field: 'CBUnDispQty',
			width: 75
		}, {
			title: '包装材料',
			align: 'left',
			field: 'PackMaterial',
			width: 80,
			formatter: CommonFormatter(PackagePackCombox, 'PackMaterial', 'PackMaterialName')
		}, {
			title: '价格',
			align: 'right',
			field: 'Price',
			width: 100,
			hidden: true
		}, {
			title: '紧张状态',
			align: 'right',
			field: 'LevelFlag',
			width: 100,
			hidden: true
		}
	]];
	var DispItmRows = null;
	ItemListGrid = $UI.datagrid('#ItemList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.DispItm',
			QueryName: 'SelectByF'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.DispItm',
			MethodName: 'jsDelete'
		},
		columns: ItemCm,
		showAddSaveDelItems: true,
		beforeAddFn: function() {
			ItemListGrid.unselectAll();
			var rowMain = $('#MainList').datagrid('getSelected');
			if (isEmpty(rowMain)) {
				$UI.msg('alert', '请选择要增加的发放单据!');
				return false;
			}
			if (rowMain.ComplateFlag === 'Y') return false;
		},
		saveDataFn: function() {
			var rowMain = $('#MainList').datagrid('getSelected');
			var Rows = ItemListGrid.getChangesData();
			if (isEmpty(Rows)) {
				$UI.msg('alert', '没有需要保存的信息!');
				return;
			}
			if (Rows == false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			var MainId = rowMain.RowId;
			var Params = JSON.stringify(addSessionParams({ MainId: MainId }));
			showMask();
			$.cm({
				ClassName: 'web.CSSDHUI.PackageDisp.DispItm',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows),
				ParamsTB: Params
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					ItemListGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		toolbar: [{
			text: '待发放',
			iconCls: 'icon-paper-plane-clock',
			handler: function() {
				BatchDisp();
			}
		}],
		pagination: false,
		singleSelect: false,
		idField: 'RowId',
		sortName: 'RowId',
		sortOrder: 'desc',
		checkField: 'PackageDR',
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				if (!isEmpty(DispItmRows)) {
					$.each(DispItmRows, function(index, row) {
						var RowIndex = $('#ItemList').datagrid('getRowIndex', row.RowId);
						if (RowIndex !== -1) {
							// 这个位置的写法, 会引起使用弹窗后的check异常, 但是断点又获取不到,why?
							$('#ItemList').datagrid('selectRow', RowIndex);
						}
					});
					DispItmRows = null;
				} else {
					$('#ItemList').datagrid('selectRow', 0);
				}
			}
		},
		onSelect: function(index, rowData) {
			FindItemSByF();
		},
		onUnselect: function(index, row) {
			FindItemSByF();
		},
		onSelectAll: function(rows) {
			FindItemSByF();
		},
		onUnselectAll: function(rows) {
			$UI.clear(ItemSListGrid);
		},
		onClickCell: function(index, field, value) {
			ItemListGrid.commonClickCell(index, field);
		},
		onBeforeEdit: function() {
			var rowMain = $('#MainList').datagrid('getSelected');
			if (rowMain.ComplateFlag === 'Y') return false;
		},
		onBeforeCellEdit: function(index, field) {
			var row = $(this).datagrid('getRows')[index];
			var CallBackDetailDr = row.CallBackDetailDr;
			if (field === 'PackageDR') {
				if ((!isEmpty(row)) && (!isEmpty(CallBackDetailDr))) {
					return false;
				}
			}
		},
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
			$UI.clear(ItemSListGrid);
		}
	});
	
	function FindItemByF(Id) {
		$UI.clear(ItemListGrid);
		$UI.clear(ItemSListGrid);
		var Flag = 'Y';			// 加该标志为了不循环CSSD_PackageDispDetail
		ItemListGrid.load({
			ClassName: 'web.CSSDHUI.PackageDisp.DispItm',
			QueryName: 'SelectByF',
			MainId: Id,
			Flag: Flag,
			rows: 9999
		});
		$('#BarCode').focus();
	}
	// 发放标签明细
	var ItemSCm = [[
		{
			field: 'operate',
			title: '操作',
			frozen: true,
			align: 'center',
			width: 50,
			allowExport: false,
			formatter: function(value, row, index) {
				var rowMain = $('#MainList').datagrid('getSelected');
				var str = '';
				if (rowMain.ComplateFlag !== 'Y') {
					str = '<div class="col-icon icon-cancel" title="删除" onclick="ItemSListGrid.commonDeleteRow(false,' + index + ');"></div>';
				}
				return str;
			}
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '消毒包Id',
			align: 'left',
			field: 'PackageDR',
			width: 100,
			hidden: true
		}, {
			title: '消毒包',
			field: 'PackageName',
			align: 'left',
			width: 165
		}, {
			title: '标签',
			field: 'Label',
			align: 'left',
			width: 160
		}, {
			title: '包装材料',
			align: 'left',
			field: 'PackMaterial',
			width: 80,
			formatter: CommonFormatter(PackagePackCombox, 'PackMaterial', 'PackMaterialName')
		}
	]];
	ItemSListGrid = $UI.datagrid('#ItemSList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.DispDetail',
			QueryName: 'SelectByF'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.DispDetail',
			MethodName: 'jsDelete'
		},
		columns: ItemSCm,
		pagination: false,
		sortName: 'RowId',
		sortOrder: 'desc',
		fitColumns: true,
		onClickRow: function(index, row) {
			ItemSListGrid.commonClickRow(index, row);
		},
		afterDelFn: function() {
			DispItmRows = ItemListGrid.getChecked();
			ItemListGrid.reload();
		}
	});
	var Default = {
		fromLocDr: gLocObj,
		FStartDate: DefaultStDate(),
		FEndDate: DefaultEdDate(),
		FComplateFlag: GetLocalStorage('CompleteFlag') || ''
	};
	$UI.fillBlock('#MainCondition', Default);
	
	// 显示数量角标
	function GetMarkQty() {
		var Obj = $UI.loopBlock('#MainCondition');
		var ParamsObj = {};
		ParamsObj.StartDate = Obj.FStartDate;
		ParamsObj.EndDate = Obj.FEndDate;
		ParamsObj.DispFlag = '1';
		ParamsObj.ExcludeExt = 'Y';
		var Params = JSON.stringify(addSessionParams(ParamsObj));
		var MarkQtyObj = $.cm({
			ClassName: 'web.CSSDHUI.PackageDisp.DispDetail',
			MethodName: 'GetMarkQty',
			Params: Params
		}, false);
		$('#ReturnNum').html(MarkQtyObj.ReturnNum);
		$('#ApplyNum').html(MarkQtyObj.ApplyNum);
		$('#FLApplyNum').html(MarkQtyObj.FLApplyNum);
	}
	function AdjustLayoutSize() {
		var NorthHeight = $(window).height() * 0.5;
		var EastWidth = '';
		if ($(window).width() < 680) {
			EastWidth = 0;
		} else if ($(window).width() * 0.58 <= 680) {
			EastWidth = $(window).width() - 680;
		} else {
			EastWidth = $(window).width() * 0.42;
		}
		$('#Layout').layout('panel', 'east').panel('resize', { width: EastWidth });
		$('#Layout').layout();
		$('#ItmLayout').layout('panel', 'north').panel('resize', { height: NorthHeight });
		$('#ItmLayout').layout();
	}
	function FindItemSByF() {
		$UI.clear(ItemSListGrid);
		var DispIdStr = '';
		var Itms = ItemListGrid.getSelections();
		for (var i = 0, Len = Itms.length; i < Len; i++) {
			var DispId = Itms[i]['RowId'];
			if (DispIdStr === '') {
				DispIdStr = DispId;
			} else {
				DispIdStr = DispIdStr + ',' + DispId;
			}
		}
		if (DispIdStr === '') {
			return;
		}
		ItemSListGrid.load({
			ClassName: 'web.CSSDHUI.PackageDisp.DispDetail',
			QueryName: 'SelectByF',
			DispId: DispIdStr,
			rows: 9999
		});
	}
	window.onresize = function() {
		AdjustLayoutSize();
	};
	AdjustLayoutSize();
	query();
};
$(init);