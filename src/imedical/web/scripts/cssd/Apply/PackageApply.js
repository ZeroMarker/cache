// 回收申请界面

// 当前主单id(全局变量)
var CurrApplyId = '';

// 检查科室是否在线路有效时间段内
function CheckLocTime(LocId, SupLocId) {
	var LocTimeObj = $.cm({
		ClassName: 'web.CSSDHUI.System.SendRoadLine',
		MethodName: 'jsCheckLocTime',
		LocId: LocId,
		Time: GetNowTime(),
		SupLocId: SupLocId
	}, false);
	if (LocTimeObj.success < 0) {
		$UI.msg('alert', LocTimeObj.msg, 2000);
		return false;
	}
	return true;
}

// 提交
function submitOrder(mainRowId) {
	if (isEmpty(mainRowId)) {
		$UI.msg('alert', '请选择要提交的单据!');
		return false;
	}
	CurrApplyId = mainRowId;
	var Params = JSON.stringify(addSessionParams({ mainRowId: mainRowId }));
	$.cm({
		ClassName: 'web.CSSDHUI.Apply.PackageApply',
		MethodName: 'jsSubmitOrder',
		Params: Params
	}, function(jsonData) {
		if (jsonData.success === 0) {
			$UI.msg('success', jsonData.msg);
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
	CurrApplyId = mainRowId;
	var Params = JSON.stringify(addSessionParams({ mainRowId: mainRowId }));
	if (ApplyParamObj.RequiredCancel === 'Y') {
		$UI.confirm('您将撤销申请单,是否继续?', 'question', '', cancelOrderFun, '', '', '', '', Params);
	} else {
		cancelOrderFun(Params);
	}
}
function cancelOrderFun(Params) {
	$.cm({
		ClassName: 'web.CSSDHUI.Apply.PackageApply',
		MethodName: 'jsCancelOrder',
		Params: Params
	}, function(jsonData) {
		if (jsonData.success === 0) {
			$UI.msg('success', jsonData.msg);
			$('#MainList').datagrid('reload');
		} else {
			$UI.msg('error', jsonData.msg);
		}
	});
}
var init = function() {
	var ReqLocParams = '';
	// 请求科室是否取全院科室
	if (ApplyParamObj.IfAllLoc === 'Y') {
		ReqLocParams = JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: gHospId }));
	} else {
		ReqLocParams = JSON.stringify(addSessionParams({ Type: 'Login', BDPHospital: gHospId }));
	}
	$HUI.combobox('#ReqLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			GetMarkQty();
		}
	});
	// 供应科室
	var SupLocParams = JSON.stringify(addSessionParams({ Type: 'SupLoc', BDPHospital: gHospId }));
	$HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SupLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function(data) {
			if (data.length === 1) {
				$('#SupLoc').combobox('setValue', data[0].RowId);
			} else {
				$('#SupLoc').combobox('setValue', GetLocalStorage('SupLoc'));
			}
		},
		onSelect: function(record) {
			SetLocalStorage('SupLoc', record.RowId);
		}
	});
	$HUI.combobox('#ReqType', {
		valueField: 'RowId',
		textField: 'Description',
		data: ReqTypeAllData
	});
	$HUI.combobox('#ReqStatus', {
		valueField: 'RowId',
		textField: 'Description',
		data: ReqStatusAllData
	});
	$HUI.combobox('#ReqLevel', {
		valueField: 'RowId',
		textField: 'Description',
		data: ReqLevelAllData
	});
	function AddApply() {
		$UI.clear(ItemSListGrid);
		$UI.clear(ItemListGrid);
		var ParamsObj = $UI.loopBlock('#MainCondition');
		var ReqType = ParamsObj['ReqType'];
		var ReqLocId = ParamsObj['FReqLoc'];
		var ReqLocDesc = $('#ReqLoc').combo('getText');
		var SupRowId = $('#SupLoc').combo('getValue');
		var SupLocDesc = $('#SupLoc').combo('getText');
		var DefaData = {
			LocRowId: ReqLocId,
			ReqLocDesc: ReqLocDesc,
			SupRowId: SupRowId,
			SupLocDesc: SupLocDesc,
			ReqType: ReqType
		};
		MainListGrid.commonAddRow(DefaData);
	}

	function saveMast() {
		var Rows = MainListGrid.getChangesData();
		if (isEmpty(Rows)) {
			return;
		}
		if (Rows === false) {
			$UI.msg('alert', '存在未填写的必填项，不能保存!');
			return;
		}
		var Obj = $UI.loopBlock('#MainCondition');
		var fromLoc = Obj.FSupLoc;
		var MainObj = $('#MainList').datagrid('getSelected');
		if (!isEmpty(MainObj) && MainObj.LocRowId == MainObj.SupRowId && (!isEmpty(MainObj.LocRowId) || !isEmpty(MainObj.SupRowId))) {
			$UI.msg('alert', '请领科室和供应科室不能相同');
			return;
		}
		if (!isEmpty(MainObj) && MainObj.ReqType === '4') {
			$UI.msg('alert', '归还单不能新增只能通过借包单生成');
			return;
		}
		if (!isEmpty(MainObj) && MainObj.ReqFlag != '0' && !isEmpty(MainObj.ReqFlag)) {
			$UI.msg('alert', '申请单已提交无法修改');
			return;
		}
		var MainParams = {
			FromLoc: fromLoc,
			CreateUser: gUserId
		};
		for (var i = 0; i < Rows.length; i++) {
			var RowId = Rows[i].RowId;
			var oriReqTypeInfo = tkMakeServerCall('web.CSSDHUI.Apply.PackageApply', 'GetReqType', RowId);
			var oriReqType = oriReqTypeInfo.split('^')[0];
			var ExistFlag = tkMakeServerCall('web.CSSDHUI.Apply.PackageApply', 'GetIsExistDetail', RowId);
			if (oriReqType != Rows[i].ReqType && (ItemListGrid.getRows().length > 0 || ExistFlag == 'Y')) {
				$UI.msg('alert', '已存在明细, 不允许修改单据类型');
				MainListGrid.reload();
				return;
			}
		}
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.Apply.PackageApply',
			MethodName: 'jsSave',
			Params: JSON.stringify(Rows),
			MainParams: JSON.stringify(MainParams)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				$UI.clear(ItemSListGrid);
				$UI.clear(ItemListGrid);
				Query(jsonData.rowid);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	// 设置模板
	function SaveMoudle() {
		var MainObj = $('#MainList').datagrid('getChecked');
		if (MainObj.length !== 1) {
			$UI.msg('alert', '请选择一条申请单设为模板！');
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.Apply.PackageMoudle',
			MethodName: 'jsMoudleSave',
			MainId: MainObj[0].RowId
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	// 选取需要归还的单据
	$UI.linkbutton('#ReturnNoBT', {
		onClick: function() {
			ReturnPkg(Query);
		}
	});
	// 打印单据
	function PrintApply() {
		var Detail = MainListGrid.getChecked();
		if (isEmpty(Detail)) {
			$UI.msg('alert', '请选择需要打印申请单！');
			return;
		}
		$.each(Detail, function(index, item) {
			// 回收申请单是否提交后打印
			if (ApplyParamObj.IfPrintAfterSub == 'Y' && item.ReqFlag == '0') {
				$UI.msg('alert', '存在未提交的单据!');
				return false;
			}
		});
		var ApplyStr = '';
		for (var i = 0; i < Detail.length; i++) {
			var ApplyId = Detail[i].RowId;
			if (ApplyStr == '') {
				ApplyStr = ApplyId;
			} else {
				ApplyStr = ApplyStr + '^' + ApplyId;
			}
		}
		if (ApplyStr == '') {
			$UI.msg('alert', '请选择需要打印的信息!');
			return false;
		}
		PrintPackageApply(ApplyStr);
	}
	$('#MainCondition').bind('keydown', function(e) {
		var theEvent = e || window.event;
		var code = theEvent.keyCode || theEvent.which || theEvent.charCode;
		if (code === 13) {
			Query();
		}
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			if (isEmpty($('#ReqLoc').combobox('getValue'))) {
				$UI.msg('alert', '申请科室不能为空！');
				return;
			}
			Query();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clearBlock('#MainCondition');
			$UI.fillBlock('#MainCondition', Default);
			$HUI.combobox('#SupLoc').reload();
			$UI.fillBlock('#MainCondition', { 'SupLoc': GetLocalStorage('SupLoc') });
			$UI.clear(ItemSListGrid);
			$UI.clear(ItemListGrid);
			$UI.clear(MainListGrid);
		}
	});

	function Query(Id) {
		$UI.clear(ItemSListGrid);
		$UI.clear(ItemListGrid);
		$UI.clear(MainListGrid);
		var ParamsObj = $UI.loopBlock('#MainCondition');
		ParamsObj.ApplyRowIds = Id;
		if (isEmpty(ParamsObj.FStartDate)) {
			$UI.msg('alert', '起始日期为空!');
			return;
		} else if (isEmpty(ParamsObj.FEndDate)) {
			$UI.msg('alert', '截止日期为空!');
			return;
		}
		CurrApplyId = Id;
		var Params = JSON.stringify(ParamsObj);
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.Apply.PackageApply',
			QueryName: 'SelectAll',
			Params: Params
		});
	}
	var ReqTypeCombox = {
		type: 'combobox',
		options: {
			data: [
				{ 'RowId': '0', 'Description': $g('回收申请单') },
				{ 'RowId': '1', 'Description': $g('借包单') },
				{ 'RowId': '2', 'Description': $g('非循环包申请单') },
				{ 'RowId': '4', 'Description': $g('归还单') }
			],
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				if (record.RowId === '4') {
					$UI.msg('alert', '归还单不支持自建单据!');
					$(this).combobox('clear');
				}
			}
		}
	};
	var ReqLevelCombox = {
		type: 'combobox',
		options: {
			data: ReqLevelData,
			valueField: 'RowId',
			textField: 'Description'
		}
	};
	if (ApplyParamObj.IfAllLoc === 'Y') {
		ReqLocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	} else {
		ReqLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	}
	var ReqLocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect: function(record) {
				var rows = MainListGrid.getRows();
				var row = rows[MainListGrid.editIndex];
				row.ReqLocDesc = record.Description;
			}
		}
	};
	var SupLocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SupLocParams,
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect: function(record) {
				var rows = MainListGrid.getRows();
				var row = rows[MainListGrid.editIndex];
				row.SupLocDesc = record.Description;
				$('#SupLoc').combobox('setValue', record.RowId);
			}
		}
	};
	// 消毒包分类
	var PackClassDrCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackageClass&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = MainListGrid.getRows();
				var row = rows[MainListGrid.editIndex];
				row.PackClassDrDesc = record.Description;
			},
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
			}
		}
	};
	var MainCm = [[
		{
			field: 'ck',
			checkbox: true,
			frozen: true,
			width: 50
		}, {
			field: 'operate',
			title: '操作',
			align: 'center',
			width: 100,
			frozen: true,
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '';
				if (!isEmpty(row.ReqFlag)) {
					if (row.ReqFlag !== '0') {
						str = '<div class="col-icon icon-back" href="#" title="' + $g('撤销') + '" onclick="cancelOrder(' + row.RowId + ')"></div>';
					} else {
						str = '<div class="col-icon icon-submit" href="#" title="' + $g('提交') + '"onclick="submitOrder(' + row.RowId + ')"></div>';
					}
				}
				if (row.ReqLevel === '1') {
					str = str + '<div class="col-icon icon-emergency" href="#" title="' + $g('紧急') + '"></div>';
				}
				if (row.BeInfected === 'Y') {
					str = str + '<div class="col-icon icon-virus" href="#" title="' + $g('感染') + '"></div>';
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
			title: '单据状态',
			field: 'ReqFlag',
			formatter: ReqStatusRenderer,
			width: 70
		}, {
			title: '申请科室',
			field: 'LocRowId',
			width: 150,
			formatter: CommonFormatter(ReqLocCombox, 'LocRowId', 'ReqLocDesc'),
			editor: ReqLocCombox
		}, {
			title: '供应科室',
			field: 'SupRowId',
			width: 100,
			formatter: CommonFormatter(SupLocCombox, 'SupRowId', 'SupLocDesc'),
			editor: SupLocCombox
		}, {
			title: '单据类型',
			field: 'ReqType',
			width: 100,
			formatter: CommonFormatter(ReqTypeCombox, 'ReqType', 'ReqTypeDesc'),
			editor: ReqTypeCombox
		}, {
			title: '发放状态',
			field: 'DispStatus',
			width: 70
		}, {
			title: '紧急程度',
			field: 'ReqLevel',
			width: 70,
			formatter: CommonFormatter(ReqLevelCombox, 'ReqLevel', 'ReqLevelDesc'),
			editor: ReqLevelCombox
		}, {
			title: '需求日期',
			field: 'ReqDate',
			width: 120,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '消毒包分类',
			field: 'PackClassDr',
			align: 'left',
			width: 100,
			formatter: CommonFormatter(PackClassDrCombox, 'PackClassDr', 'PackClassDrDesc'),
			editor: PackClassDrCombox
		}, {
			title: '提交时间',
			field: 'commitDate',
			width: 150
		}, {
			title: '提交人',
			field: 'commitUser',
			width: 100
		}, {
			title: '制单人',
			field: 'CreateUser',
			width: 100
		}, {
			title: '制单日期',
			field: 'CreateDate',
			width: 100
		}, {
			title: 'BeInfected',
			field: 'BeInfected',
			width: 50,
			hidden: true
		}
	]];
	var MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Apply.PackageApply',
			QueryName: 'SelectAll'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.Apply.PackageApply',
			MethodName: 'jsDelete'
		},
		columns: MainCm,
		firstFocusField: 'ReqType',
		toolbar: [
			{
				id: 'AddBT',
				text: '新增',
				iconCls: 'icon-add',
				handler: function() {
					AddApply();
				}
			}, {
				id: 'SaveBT',
				text: '保存',
				iconCls: 'icon-save',
				handler: function() {
					saveMast();
				}
			}, {
				id: 'EditBT',
				text: '编辑',
				iconCls: 'icon-edit',
				handler: function() {
					var Row = $('#MainList').datagrid('getSelected');
					if (isEmpty(Row)) {
						return;
					}
					var RowIndex = $('#MainList').datagrid('getRowIndex', Row);
					MainListGrid.beginEdit(RowIndex);
					MainListGrid.editIndex = RowIndex;
				}
			}, {
				id: 'DeleteBT',
				text: '删除',
				iconCls: 'icon-cancel',
				handler: function() {
					MainListGrid.commonDeleteRow(true);
				}
			}, {
				id: 'SaveMoudleBT',
				text: '设置模板',
				iconCls: 'icon-two-recta-gear',
				handler: function() {
					var MainObj = $('#MainList').datagrid('getChecked');
					if (MainObj.length !== 1) {
						$UI.msg('alert', '请选择一条申请单设为模板！');
						return;
					}
					$UI.confirm('您将根据目前选择的单据生成模板,生成时会自动移除标牌追溯包,是否继续?', 'question', '', SaveMoudle);
				}
			}, {
				id: 'ApplyMoudleBT',
				text: '选取申请模板',
				iconCls: 'icon-template',
				handler: function() {
					var ReqLocRowId = $('#ReqLoc').combo('getValue');
					ApplyMoudle(Query, ReqLocRowId);
				}
			}, {
				id: 'Print',
				text: '打印申请单',
				iconCls: 'icon-print',
				handler: function() {
					PrintApply();
				}
			}
		],
		selectOnCheck: false,
		sortName: 'RowId',
		sortOrder: 'desc',
		onLoadSuccess: function(data) {
			GetMarkQty();
			if (data.rows.length > 0) {
				var GridListIndex = '';
				if (!isEmpty(CurrApplyId)) {
					var Rows = $('#MainList').datagrid('getRows');
					$.each(Rows, function(index, item) {
						if (item.RowId == CurrApplyId) {
							GridListIndex = index;
							return false;
						}
					});
					CurrApplyId = '';
				} else if (CommParObj.SelectFirstRow == 'Y') {
					GridListIndex = 0;
				}
				if (!isEmpty(GridListIndex)) {
					$('#MainList').datagrid('selectRow', GridListIndex);
				}
			}
		},
		onSelect: function(index, rowData) {
			var Id = rowData.RowId;
			var ReqType = rowData.ReqType, ReqFlag = rowData.ReqFlag;
			if ((ReqType !== '0' && ReqType !== '5') || (ReqFlag !== '0')) {
				$('#BarCode').attr('disabled', 'disabled');
				$('#BarCodeSwitchBT').linkbutton('disable');
			} else {
				$('#BarCode').removeAttr('disabled');
				$('#BarCodeSwitchBT').linkbutton('enable');
			}

			$UI.clear(ItemSListGrid);
			$UI.clear(ItemListGrid);
			ItemListGrid.load({
				ClassName: 'web.CSSDHUI.Apply.PackageApplyItm',
				QueryName: 'SelectByF',
				ApplyId: Id,
				rows: 99999
			});
			$('#BarCode').focus();
		},
		onBeforeEdit: function(index, row) {
			if (row.ReqType === '4' && row.RowId) {
				return false;
			}
			if (row.ReqFlag !== '0' && row.RowId) {
				return false;
			}
		},
		beforeAddFn: function() {
			$('#MainList').datagrid('unselectAll');
			var ReqLocId = $('#ReqLoc').combo('getValue');
			var SupLocId = $('#SupLoc').combo('getValue');
			if (!CheckLocTime(ReqLocId, SupLocId)) return false;
		},
		afterDelFn: function() {
			$UI.clear(ItemSListGrid);
			$UI.clear(ItemListGrid);
			GetMarkQty();
		}
	});

	var PackageBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onBeforeLoad: function(param) {
				var rowMain = $('#MainList').datagrid('getSelected');
				var ReqType = rowMain.ReqType;
				var PkgClassDr = rowMain.PackClassDr;
				var LocId = rowMain['LocRowId'];
				if (ReqType === '2') {
					param.Params = JSON.stringify(addSessionParams({ TypeDetail: '7', PkgClassId: PkgClassDr, LocId: LocId }));
				} else if (ReqType === '1') {
					param.Params = JSON.stringify(addSessionParams({ TypeDetail: '1,2', PkgClassId: PkgClassDr, LocId: LocId }));
				} else {
					param.Params = JSON.stringify(addSessionParams({ TypeDetail: '2', PkgClassId: PkgClassDr, LocId: LocId }));
				}
			},
			onSelect: function(record) {
				var rows = ItemListGrid.getRows();
				var row = rows[ItemListGrid.editIndex];
				ItemListGrid.EditorSetValue('PackageDR', record.RowId);
				row.PackageName = record.Description;
				var index = ItemListGrid.getRowIndex(row);
				for (var i = 0; i < rows.length; i++) {
					if (rows[i].PackageName === record.Description && i !== index) {
						$UI.msg('alert', '消毒包重复!');
						$(this).combobox('clear');
						return;
					}
				}
				// 联动消毒包材料 (一旦保存,不允许编辑消毒包)
				var ed = ItemListGrid.getEditor({ index: ItemListGrid.editIndex, field: 'MaterialId' });
				if (isEmpty(ed)) {
					ItemListGrid.updateRow({
						index: ItemListGrid.editIndex,
						row: { MaterialId: '', MaterialDesc: '' }
					});
				} else {
					AddComboData($(ed.target), record['MaterialId'], record['MaterialDesc']);
					ItemListGrid.EditorSetValue('MaterialId', record['MaterialId']);

					var url = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetBindMaterials&ResultSetType=array&packageDr=' + record.RowId;
					$(ed.target).combobox('reload', url);
				}
			}
		}
	};
	// 包装材料
	var GetMaterialsBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetBindMaterials&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = ItemListGrid.getRows();
				var row = rows[ItemListGrid.editIndex];
				row.MaterialDesc = record.Description;
			},
			onBeforeLoad: function(param) {
				var RowItem = ItemListGrid.getRows()[ItemListGrid.editIndex];
				if (!isEmpty(RowItem)) {
					param['packageDr'] = RowItem['PackageDR'];
				}
			}
		}
	};
	var InfectCombox = {
		type: 'combobox',
		options: {
			data: InfectData,
			valueField: 'RowId',
			textField: 'Description',
			onShowPanel: function() {
				var row = MainListGrid.getSelected();
				if (row.ReqType === '2') {
					$UI.msg('alert', '非循环包申请单不需要设置感染信息!');
					$(this).combobox('hidePanel');
				}
			}
		}
	};

	// 扫码动作
	$('#BarCode').keyup(function(event) {
		if (event.which === 13) {
			AddBarCode();
		}
	}).focus(function(event) {
		$('#BarCode').val('');
		$('#BarCodeHidden').val('');
		var ReadOnly = $('#BarCode').attr('readonly');
		if (ReadOnly === 'readonly') {
			$('#BarCodeHidden').focus();
		}
		InitScanIcon();
	}).blur(function(event) {
		InitScanIcon();
	});
	$('#BarCodeHidden').keyup(function(event) {
		if (event.which === 13) {
			var HiddenVal = $('#BarCodeHidden').val();
			$('#BarCode').val(HiddenVal);
			$('#BarCodeHidden').val('');
			AddBarCode();
		}
	}).focus(function(enent) {
		InitScanIcon();
	}).blur(function(event) {
		InitScanIcon();
	});
	// 控制是否允许编辑
	$('#BarCodeSwitchBT').linkbutton({
		iconCls: 'icon-w-switch',
		// plain: true,
		// iconCls: 'icon-key-switch',
		onClick: function() {
			var ReadOnly = $('#BarCode').attr('readonly');		// 只读时,此值为'readonly'
			if (ReadOnly === 'readonly') {
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
		if (ElementId === 'BarCodeHidden') {
			// 扫描icon
			$('#UseBarCodeBT').linkbutton({ iconCls: 'icon-scanning' });
		} else if (ReadOnly === 'readonly') {
			// 只读icon
			$('#UseBarCodeBT').linkbutton({ iconCls: 'icon-gray-edit' });
		} else {
			// 可编辑icon
			$('#UseBarCodeBT').linkbutton({ iconCls: 'icon-blue-edit' });
		}
	}
	if (GetLocalStorage('BarCodeHidden') === 'Y') {
		$('#BarCode').attr({ 'readonly': true });
	} else {
		$('#BarCode').attr({ 'readonly': false });
	}
	InitScanIcon();

	function AddBarCode() {
		var BarCode = $('#BarCode').val();
		var row = $('#MainList').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择需要添加的申请单据!');
			return;
		}
		if (isEmpty(BarCode)) {
			$UI.msg('alert', '未获取到扫描的标签!');
			return;
		}
		var ReqType = row.ReqType, ReqFlag = row.ReqFlag;
		if (isEmpty(row.RowId)) {
			$UI.msg('alert', '请选择主单据!');
			return;
		} else if (ReqType !== '0' && ReqType !== '5') {
			$UI.msg('alert', '该单据类型不允许录入标牌!');
			return;
		} else if (ReqFlag !== '0') {
			$UI.msg('alert', '请核实单据状态!');
			return;
		}
		var Params = JSON.stringify(addSessionParams({ BarCode: BarCode }));
		$.cm({
			ClassName: 'web.CSSDHUI.Apply.PackageApplyItm',
			MethodName: 'jsSaveBarCode',
			MainId: row.RowId,
			Params: Params
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				ItemListGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
			$('#BarCode').val('');
			$('#BarCode').focus();
		});
	}

	var ItemCm = [[
		{
			field: 'ck',
			checkbox: true,
			frozen: true
		}, {
			title: '操作',
			field: 'Icon',
			width: 50,
			align: 'center',
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '';
				str = str + '<div class="col-icon icon-img" href="#" title="查看图片" onclick="ViewPic(' + row.PackageDR + ')"></div>';
				return str;
			}
		}, {
			title: 'RowId',
			field: 'RowId',
			saveCol: true,
			width: 100,
			hidden: true
		}, {
			title: '消毒包',
			field: 'PackageDR',
			saveCol: true,
			width: 160,
			formatter: CommonFormatter(PackageBox, 'PackageDR', 'PackageName'),
			editor: PackageBox,
			showTip: true,
			tipWidth: 200,
			tipTrackMouse: true
		}, {
			title: '标牌',
			field: 'BarCode',
			saveCol: true,
			width: 100
		}, {
			title: '数量',
			field: 'Qty',
			saveCol: false,		// 制单界面不传递此字段
			width: 70,
			hidden: true
		}, {
			title: '申请数',
			field: 'ReqQty',
			saveCol: true,
			width: 70,
			align: 'right',
			editor: { type: 'numberbox', options: { required: true, min: 1, max: 10000 }}
		}, {
			title: '未发数',
			field: 'UnDispQty',
			width: 70,
			align: 'right'
		}, {
			title: '包装材料',
			field: 'MaterialId',
			saveCol: true,
			width: 120,
			formatter: CommonFormatter(GetMaterialsBox, 'MaterialId', 'MaterialDesc'),
			editor: GetMaterialsBox
		}, {
			title: '备注',
			field: 'Remark',
			saveCol: true,
			width: 110,
			editor: { type: 'validatebox' }
		}, {
			title: '感染信息',
			field: 'InfectRemark',
			saveCol: true,
			width: 100,
			editor: InfectCombox,
			formatter: CommonFormatter(InfectCombox, 'InfectRemark')
		}, {
			title: '反馈信息',
			field: 'RemarkInfo',
			saveCol: true,
			width: 110
		}
	]];
	var ItemListGrid = $UI.datagrid('#ItemList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Apply.PackageApplyItm',
			QueryName: 'SelectByF'
		},
		columns: ItemCm,
		pagination: false,
		checkField: 'PackageDR',
		singleSelect: false,
		sortName: 'RowId',
		sortOrder: 'asc',
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.Apply.PackageApplyItm',
			MethodName: 'jsDelete'
		},
		showAddSaveDelItems: true,
		onClickCell: function(index, field, value) {
			ItemListGrid.commonClickCell(index, field, value);
		},
		onSelect: function(index, row) {
			var PkgId = row.PackageDR;
			FindItemSByF(PkgId);
		},
		/*
		onUnselect: function(index, row) {
			FindItemSByF();
		},
		onSelectAll: function(rows) {
			FindItemSByF();
		},
		onUnselectAll: function(rows) {
			$UI.clear(ItemSListGrid);
		},
		*/
		onBeforeCellEdit: function(index, field) {
			var rowMain = $('#MainList').datagrid('getSelected');
			if (rowMain.ReqFlag !== '0') return false;
			if (rowMain.ReqType === '4') return false;

			// 空白行删除,可能影响此处的取值
			if (!isEmpty(ItemListGrid.getRows()[index])) {
				var BarCode = ItemListGrid.getRows()[index]['BarCode'];
				if (field === 'PackageDR') {
					return false;
				} else if (field === 'ReqQty' && !isEmpty(BarCode)) {
					return false;
				}
			}
		},
		saveDataFn: function() { // 保存明细
			var Rows = ItemListGrid.getChangesData();
			if (isEmpty(Rows)) {
				return;
			}
			if (Rows === false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			var rowMain = $('#MainList').datagrid('getSelected');
			$.cm({
				ClassName: 'web.CSSDHUI.Apply.PackageApplyItm',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows),
				MainId: rowMain.RowId
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					ItemListGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		beforeDelFn: function() {
			var rowMain = $('#ItemList').datagrid('getSelected');
			if (isEmpty(rowMain)) {
				$UI.msg('alert', '请选择要删除的申请单明细!');
				return false;
			}
			var MainObj = $('#MainList').datagrid('getSelected');
			if (MainObj.ReqFlag !== '0') {
				$UI.msg('alert', '申请单已提交不能删除明细!');
				return false;
			}
		},
		afterDelFn: function() {
			$UI.clear(ItemSListGrid);
		},
		beforeAddFn: function() {
			var rowMain = $('#MainList').datagrid('getSelected');
			var ReqFlag = rowMain['ReqFlag'], ReqType = rowMain['ReqType'];
			if (isEmpty(rowMain)) {
				$UI.msg('alert', '请选择申请单据!');
				return false;
			}
			if (isEmpty(rowMain.RowId)) {
				$UI.msg('alert', '请先保存主表信息!');
				return false;
			}
			if (ReqFlag !== '0') return false;
			if (ReqType === '5') {
				$UI.msg('alert', '手术申请单,请通过扫描标牌或标签添加!');
				return false;
			} else if (ReqType === '4') {
				return false;
			}
		}
	});
	function FindItemSByF(PkgIdStr) {
		$UI.clear(ItemSListGrid);
		/* 此写法引起后台报错, 暂按单个消毒包处理
		var Rows = ItemListGrid.getSelections();
		for (var i = 0, Len = Rows.length; i < Len; i++) {
			var PkgId = Rows[i]['PackageDR'];
			if (PkgIdStr === '') {
				PkgIdStr = PkgId;
			} else {
				PkgIdStr = PkgIdStr + ',' + PkgId;
			}
		}
		*/
		if (PkgIdStr === '') {
			return;
		}
		ItemSListGrid.load({
			ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
			QueryName: 'SelectByF',
			PkgId: PkgIdStr,
			rows: 99999
		});
	}

	var ItemSCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '器械',
			field: 'ItmDesc',
			width: 140,
			styler: function(value, row, index) {
				return 'background-color:' + row.OneOffColor + ';';
			}
		}, {
			title: '器械规格',
			field: 'ItmSpec',
			width: 80
		}, {
			title: '数量',
			field: 'Qty',
			align: 'right',
			width: 60
		}
	]];
	var ItemSListGrid = $UI.datagrid('#ItemSListGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
			QueryName: 'SelectByF'
		},
		columns: ItemSCm,
		pagination: false,
		fitColumns: true
	});

	// 显示数量角标
	function GetMarkQty() {
		var LocId = $('#ReqLoc').combobox('getValue');
		var Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId, FReqLoc: LocId }));
		var MarkQtyObj = $.cm({
			ClassName: 'web.CSSDHUI.Apply.ReturnPackage',
			MethodName: 'GetMarkQty',
			Params: Params
		}, false);
		$('#ReturnNum').html(MarkQtyObj.ReturnNum);
	}
	var Default = {
		FReqLoc: gLocObj,
		FStartDate: DefaultStDate(),
		FEndDate: DefaultEdDate()
	};
	$UI.fillBlock('#MainCondition', Default);
	Query();
	GetMarkQty();
	CheckLocTime(gLocId);
};
$(init);