var MainListGrid, ItemListGrid;
var CurrMainId;// 当前主单id(全局变量)

// 提交
function submitOrder(MainId) {
	if (isEmpty(MainId)) {
		$UI.msg('alert', '请选择要提交的单据!');
		return false;
	}
	var Params = JSON.stringify(addSessionParams({ mainRowId: MainId }));
	showMask();
	$.cm({
		ClassName: 'web.CSSDHUI.CallBack.CallBack',
		MethodName: 'jsSubmitOrder',
		Params: Params
	}, function(jsonData) {
		hideMask();
		if (jsonData.success == 0) {
			$UI.msg('success', jsonData.msg);
			CurrMainId = MainId;
			$('#MainListGrid').datagrid('reload');
		} else {
			$UI.msg('error', jsonData.msg);
		}
	});
}

// 撤销
function cancelOrder(MainId) {
	if (isEmpty(MainId)) {
		$UI.msg('alert', '请选择要撤销的单据!');
		return false;
	}
	if (CallBackParamObj.RequiredCancel == 'Y') {
		$UI.confirm('您确定要执行撤销操作吗？', '', '', Cancel, '', '', '', '', MainId);
	} else {
		Cancel(MainId);
	}
}
function Cancel(MainId) {
	var Params = JSON.stringify(addSessionParams());
	showMask();
	$.cm({
		ClassName: 'web.CSSDHUI.CallBack.CallBack',
		MethodName: 'jsCancelOrder',
		mainRowId: MainId,
		Params: Params
	}, function(jsonData) {
		hideMask();
		if (jsonData.success === 0) {
			$UI.msg('success', jsonData.msg);
			CurrMainId = MainId;
			$('#MainListGrid').datagrid('reload');
		} else {
			$UI.msg('error', jsonData.msg);
		}
	});
}

// /======================================事件处理end=======================
var init = function() {
	// var OPRFlag = 'N';
	var ParamsTB = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	// 回收科室
	var ReqLocParams = JSON.stringify(addSessionParams({ Type: 'RecLoc', BDPHospital: gHospId }));
	$HUI.combobox('#ReqLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	// 供应科室
	var SupLocParams = JSON.stringify(addSessionParams({ Type: 'Login', BDPHospital: gHospId }));
	$HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SupLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.combobox('#ToUser', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array&Params=' + ParamsTB,
		valueField: 'RowId',
		textField: 'Description',
		spellField: 'Code'
	});

	$('#ToUser').combobox('textbox').keyup(function(event) {
		if (event.keyCode === 13) {
			var UserCode = $('#ToUser').combobox('getText');
			if (isEmpty(UserCode)) {
				return;
			}
			var UserObj = $.cm({
				ClassName: 'web.CSSDHUI.Common.Dicts',
				MethodName: 'GetUserByCodeJson',
				userCode: UserCode,
				Params: ParamsTB
			}, false);
			if (isEmpty(UserObj['RowId'])) {
				$UI.msg('alert', '未获取到相关回收人！');
				$('#ToUser').combobox('setValue', '');
				$('#ToUser').combobox('textbox').focus();
				return;
			}
			$('#ToUser').combobox('setValue', UserObj['RowId']);
		}
	});

	function Default() {
		$UI.clearBlock('#MainCondition');
		$UI.clear(ItemListGrid);
		$UI.clear(ItemSListGrid);
		var DefaultData = {
			SupLoc: gLocObj,
			FStartDate: DefaultStDate(),
			FEndDate: DefaultEdDate()
		};
		$UI.fillBlock('#MainCondition', DefaultData);
	}

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Default();
			Query();
		}
	});

	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			saveMast();
		}
	});
	function saveMast() {
		var MainObj = $UI.loopBlock('#MainCondition');
		if (isEmpty(MainObj.SupLoc)) {
			$UI.msg('alert', '供应科室不能为空!');
			$('#SupLoc').combobox('textbox').focus();
			return;
		}
		if (isEmpty(MainObj.ReqLoc)) {
			$UI.msg('alert', '申请科室不能为空');
			$('#ReqLoc').combobox('textbox').focus();
			return;
		}
		if (MainObj.SupLoc === MainObj.ReqLoc) {
			$UI.msg('alert', '回收科室和供应科室不能相同');
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.CallBack.CallBack',
			MethodName: 'jsSave',
			Params: JSON.stringify(MainObj)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				if (!isEmpty(jsonData.rowid)) {
					CurrMainId = jsonData.rowid;
				}
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	// 更新单据的备注信息
	function UpdateRemark() {
		var Rows = MainListGrid.getChangesData();
		if (isEmpty(Rows)) {
			$UI.msg('alert', '请选择需要保存的单据');
			return;
		}
		if (Rows === false) {
			$UI.msg('alert', '存在未填写的必填项，不能保存!');
			return;
		}
		for (var i = 0; i < Rows.length; i++) {
			var ComplateFlag = Rows[i].ComplateFlag;
			if (ComplateFlag == 'Y') {
				$UI.msg('alert', '已提交不能修改!');
				return;
			}
		}
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.CallBack.CallBack',
			MethodName: 'JsUpdateRemark',
			Rows: JSON.stringify(Rows)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				MainListGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	// 生成请领单
	$UI.linkbutton('#CreateBT', {
		onClick: function() {
			SelReq(Query);
		}
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query(RowIdStr) {
		$UI.clear(MainListGrid);
		$UI.clear(ItemListGrid);
		$UI.clear(ItemSListGrid);
		var ParamsObj = {};
		if (!isEmpty(RowIdStr)) {
			ParamsObj = { RowIdStr: RowIdStr };
		} else {
			ParamsObj = $UI.loopBlock('#MainCondition');
			if (isEmpty(ParamsObj.SupLoc)) {
				$UI.msg('alert', '供应科室不能为空!');
				$('#SupLoc').combobox('textbox').focus();
				return;
			}
			if (isEmpty(ParamsObj.FStartDate)) {
				$UI.msg('alert', '起始日期不能为空!');
				$('#SupLoc').combobox('textbox').focus();
				return;
			}
			if (isEmpty(ParamsObj.FEndDate)) {
				$UI.msg('alert', '截止日期不能为空!');
				$('#SupLoc').combobox('textbox').focus();
				return;
			}
		}
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.CallBack.CallBack',
			QueryName: 'SelectAll',
			Params: JSON.stringify(ParamsObj)
		});
	}
	// 打印单据
	function Print() {
		var Detail = MainListGrid.getChecked();
		if (isEmpty(Detail)) {
			$UI.msg('alert', '请选择需要打印单据');
			return;
		}
		var CallBackStr = '';
		for (var i = 0; i < Detail.length; i++) {
			var CallBackId = Detail[i].RowId;
			if (CallBackStr == '') {
				CallBackStr = CallBackId;
			} else {
				CallBackStr = CallBackStr + '^' + CallBackId;
			}
		}
		if (CallBackStr == '') {
			$UI.msg('alert', '请选择需要打印的信息!');
			return false;
		}
		PrintCallBack(CallBackStr);
	}
	// 汇总打印单据
	function PrintBack() {
		var Detail = MainListGrid.getChecked();
		if (isEmpty(Detail)) {
			$UI.msg('alert', '请选择需要打印单据');
			return;
		}
		var DetailIds = '';
		$.each(Detail, function(index, item) {
			if (DetailIds === '') {
				DetailIds = item.RowId;
			} else {
				DetailIds = DetailIds + ',' + item.RowId;
			}
		});
		PrintINBackCount(DetailIds);
	}
	// 批量提交
	function submitAll() {
		$UI.confirm('您确定要执行提交操作吗？', '', '', function() {
			var RowsData = MainListGrid.getChecked();
			if (isEmpty(RowsData)) {
				$UI.msg('alert', '请选择需要提交单据');
				return;
			}
			var MainIdStr = '';
			for (var i = 0; i < RowsData.length; i++) {
				var RowId = RowsData[i].RowId;
				if (MainIdStr == '') {
					MainIdStr = RowId;
				} else {
					MainIdStr = MainIdStr + '^' + RowId;
				}
			}
			submitOrder(MainIdStr);
		});
	}
	
	// 所有待回收标牌
	$UI.linkbutton('#CodeDictQuery', {
		onClick: function() {
			var row = $('#MainListGrid').datagrid('getSelected');
			if (!isEmpty(row)) {
				if (row.ComplateFlag === 'Y') {
					$UI.msg('alert', '单据已提交无法继续添加明细!');
					return;
				}
			}
			CodeDictWin(FindItemByF);
		}
	});
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
			align: 'center',
			width: 120,
			frozen: true,
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '';
				if (row.ComplateFlag === 'Y') {
					str = str + '<div class="icon-back col-icon" href="#" title="撤销" onclick="cancelOrder(' + row.RowId + ')"></div>';
				} else {
					str = str + '<div class="icon-cancel col-icon"  href="#"  title="删除" onclick="MainListGrid.commonDeleteRow(true,' + index + ');"></div>'
						+ '<div class="icon-submit col-icon" href="#" title="提交" onclick="submitOrder(' + row.RowId + ')"></div>';
				}
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
			width: 120
		}, {
			title: '回收科室',
			field: 'FroLocDesc',
			width: 150
		}, {
			title: '是否提交',
			field: 'ComplateFlag',
			width: 80,
			formatter: BoolFormatter,
			hidden: true
		}, {
			title: '回收时间',
			field: 'CBDateTime',
			width: 150,
			align: 'left'
		}, {
			title: '回收人',
			field: 'ToUser',
			width: 60
		}, {
			title: '提交时间',
			field: 'AckDate',
			width: 150,
			align: 'left'
		}, {
			title: '提交人',
			field: 'AckUserDesc',
			width: 60
		}, {
			title: '申请单号',
			field: 'ApplyNo',
			width: 120
		}, {
			title: '申请人',
			field: 'ApplyUserName',
			width: 60,
			align: 'left'
		}, {
			title: '申请时间',
			field: 'ApplyDateTime',
			width: 150,
			align: 'left'
		}, {
			title: '备注',
			field: 'Remark',
			width: 150,
			editor: { type: 'validatebox' }
		}, {
			title: '紧急程度',
			field: 'ReqLevel',
			width: 80,
			hidden: true
		}, {
			title: '感染标志',
			field: 'BeInfected',
			width: 50,
			hidden: true
		}
	]];

	MainListGrid = $UI.datagrid('#MainListGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.CallBack.CallBack',
			QueryName: 'SelectAll'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.CallBack.CallBack',
			MethodName: 'jsDelete'
		},
		toolbar: [{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				UpdateRemark();
			}
		}, {
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
			text: '打印汇总',
			iconCls: 'icon-print-box',
			handler: function() {
				PrintBack();
			}
		}],
		columns: MainCm,
		sortName: 'RowId',
		sortOrder: 'desc',
		selectOnCheck: false,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				var GridListIndex = '';
				if (!isEmpty(CurrMainId)) {
					var Rows = $('#MainListGrid').datagrid('getRows');
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
					$('#MainListGrid').datagrid('selectRow', GridListIndex);
				}
			}
			GetMarkQty();
		},
		onClickRow: function(index, row) {
			MainListGrid.commonClickRow(index, row);
		},
		onSelect: function(index, rowData) {
			var RowId = rowData.RowId;
			if (!isEmpty(RowId)) {
				FindItemByF(RowId);
			}
		},
		afterDelFn: function() {
			$UI.clear(ItemListGrid);
			$UI.clear(ItemSListGrid);
		}
	});

	var PackageBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + ParamsTB,
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onBeforeLoad: function(param) {
				var rowMain = MainListGrid.getSelected();
				var ReqType = rowMain.ReqType;
				var PackTypeDetail = '2,10';
				if (ReqType === 2) {
					PackTypeDetail = '7';
				} else if (ReqType === 1) {
					PackTypeDetail = '2';
				}
				param.Params = JSON.stringify(addSessionParams({ TypeDetail: PackTypeDetail }));
			},
			onSelect: function(record) {
				var rows = ItemListGrid.getRows();
				var Index = ItemListGrid.editIndex;
				var row = rows[Index];
				row.PackageDR = record.RowId;
				row.PackageName = record.Description;

				for (var i = 0; i < rows.length; i++) {
					if ((rows[i].PackageName == record.Description) && (i !== Index)) {
						$UI.msg('alert', '包名重复!');
						$(this).combobox('clear');
						return;
					}
				}
				
				// 联动消毒包材料 (一旦保存,不允许编辑消毒包)
				var ed = ItemListGrid.getEditor({ index: Index, field: 'MaterialDr' });
				if (isEmpty(ed)) {
					ItemListGrid.updateRow({
						index: Index,
						row: { MaterialDr: '', MaterialDesc: '' }
					});
				} else {
					var url = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetBindMaterials&ResultSetType=array&packageDr=' + record.PkgId;
					$(ed.target).combobox('clear').combobox('reload', url);
				}
				ItemListGrid.startEditingNext('PackageDR');
			}
		}
	};
	// /包装材料下拉数据
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

	$('#BarCode').keyup(function(event) {
		if (event.which == 13) {
			AddItem();
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
			AddItem();
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

	function AddItem() {
		var label = $('#BarCode').val();
		if (isEmpty(label)) {
			$UI.msg('alert', '未获取到扫描的标签!');
			return;
		}
		var row = $('#MainListGrid').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择需要添加的回收单据!');
			return;
		}
		if (isEmpty(row.RowId)) {
			$UI.msg('alert', '请选择回收单据!');
			return;
		}
		if (row.ComplateFlag == 1) {
			$UI.msg('alert', '已提交不允许添加!');
			$('#BarCode').val('');
			return;
		}
		var Params = JSON.stringify($UI.loopBlock('#MainCondition'));
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.CallBack.CallBack',
			MethodName: 'jsCallBackLabel',
			MainId: row.RowId,
			label: label,
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				ItemListGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
			$('#BarCode').val('').focus();
		});
	}

	function FindItemByF(Id) {
		$UI.clear(ItemListGrid);
		$UI.clear(ItemSListGrid);
		ItemListGrid.load({
			ClassName: 'web.CSSDHUI.CallBack.CallBackItm',
			QueryName: 'SelectByF',
			MainId: Id,
			rows: 99999
		});
	}

	function SaveItm(Rows) {
		var Main = MainListGrid.getSelected();
		var MainId = Main.RowId;
		if (Main.ComplateFlag === 'Y') {
			$UI.msg('alert', '单据已提交不能保存!');
			return false;
		}
		// 保存明细
		if (isEmpty(Rows)) {
			Rows = ItemListGrid.getChangesData('PackageDR');
		}
		if (isEmpty(Rows)) {
			$UI.msg('alert', '没有需要保存的单据明细');
			return;
		}
		if (Rows === false) {
			$UI.msg('alert', '存在未填写的必填项，不能保存!');
			return;
		}
		for (var i = 0; i < Rows.length; i++) {
			if (isEmpty(Rows[i].Qty)) {
				$UI.msg('alert', Rows[i].PackageName + '数量未录入!');
				return;
			} else if (Rows[i].Qty < Rows[i].LabelQty) {
				$UI.msg('alert', Rows[i].PackageName + '数量不能小于扫描标签数!');
				return;
			}
		}
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.CallBack.CallBackItm',
			MethodName: 'jsSave',
			Params: JSON.stringify(Rows),
			MainId: MainId
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				ItemListGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	function UpdateUrgent(Flag) {
		var Main = MainListGrid.getSelected();
		var MainId = Main.RowId;
		var Rows = ItemListGrid.getSelections();
		if (isEmpty(Flag)) {
			Flag = 'Y';
		}
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.CallBack.CallBackItm',
			MethodName: 'jsUrgent',
			Params: JSON.stringify(Rows),
			Flag: Flag
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				CurrMainId = MainId;
				MainListGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	function UpdateInfect(Flag) {
		var Main = MainListGrid.getSelected();
		var MainId = Main.RowId;
		var Rows = ItemListGrid.getSelections();
		if (isEmpty(Flag)) {
			Flag = 'Y';
		}
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.CallBack.CallBackItm',
			MethodName: 'jsInfect',
			Params: JSON.stringify(Rows),
			Flag: Flag
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				CurrMainId = MainId;
				MainListGrid.reload();
			} else {
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
			align: 'center',
			width: 100,
			frozen: true,
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '';
				var rowMain = MainListGrid.getSelected();
				if (rowMain.ComplateFlag != 'Y') {
					str = str + '<div class="icon-cancel col-icon" href="#" title="删除" onclick="ItemListGrid.commonDeleteRow(false,' + index + ')"></div>';
				}
				if (row.LevelFlag === '1') {
					str = str + '<div class="icon-emergency col-icon" href="#" title="紧急"></div>';
				}
				if (row.InfectFlag === 'Y') {
					str = str + '<div class="icon-virus col-icon" href="#" title="感染"></div>';
				}
				str = str + '<div class="icon-img col-icon" href="#" title="图片"onclick="ViewPic(' + row.PackageDR + ')"></div>';
				if (!isEmpty(row.PackageLabel)) {
					str = str + '<div class="icon-location col-icon" href="#" title="追踪信息" onclick="TransInfoWin(\'' + row.PackageLabel + '\')"></div>';
				}
				return str;
			}
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '紧急状态',
			field: 'LevelFlag',
			width: 100,
			hidden: true
		}, {
			title: '感染状态',
			field: 'InfectFlag',
			width: 100,
			hidden: true
		}, {
			title: 'ApplyDetailDr',
			field: 'ApplyDetailDr',
			width: 100,
			hidden: true
		}, {
			title: '消毒包',
			field: 'PackageDR',
			width: 140,
			formatter: CommonFormatter(PackageBox, 'PackageDR', 'PackageName'),
			editor: PackageBox,
			jump: false
		}, {
			title: '数量',
			field: 'Qty',
			width: 60,
			align: 'right',
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					min: 1,
					precision: 0,
					max: 10000
				}}
		}, {
			title: '标签数',
			field: 'LabelQty',
			width: 60,
			align: 'right',
			hidden: true
		}, {
			title: '标牌',
			field: 'DictLabel',
			width: 100
		}, {
			title: '包装材料',
			field: 'MaterialDr',
			width: 120,
			formatter: CommonFormatter(GetMaterialsBox, 'MaterialDr', 'MaterialDesc'),
			editor: GetMaterialsBox
		}, {
			title: 'PackTypeDetail',
			field: 'PackTypeDetail',
			width: 100,
			hidden: true
		}, {
			title: 'PackageLabel',
			field: 'PackageLabel',
			width: 100,
			hidden: true
		}
	]];

	ItemListGrid = $UI.datagrid('#ItemListGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.CallBack.CallBackItm',
			QueryName: 'SelectByF',
			rows: 99999
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.CallBack.CallBackItm',
			MethodName: 'jsDelete'
		},
		columns: ItemCm,
		sortName: 'RowId',
		sortOrder: 'asc',
		checkField: 'PackageDR',
		singleSelect: false,
		pagination: false,
		showAddSaveDelItems: true,
		toolbar: [{
			text: '紧急',
			iconCls: 'icon-emergency',
			handler: function() {
				var Main = MainListGrid.getSelected();
				if (Main.ComplateFlag === 'Y') {
					$UI.msg('alert', '单据已提交，不能处理紧急!');
					return false;
				}
				var Rows = ItemListGrid.getSelections();
				if (isEmpty(Rows)) {
					$UI.msg('alert', '请选择需要处理紧急的消毒包！');
					return false;
				}
				var TotalCount = 0, DealCount = 0;
				for (var i = 0; i < Rows.length; i++) {
					TotalCount = TotalCount + 1;
					if (Rows[i].LevelFlag == '1') {
						DealCount = DealCount + 1;
					}
				}
				if (DealCount == TotalCount) {
					$UI.confirm('已紧急，重复操作会取消紧急，是否继续？', '', '', UpdateUrgent, '', '', '', '', 'N');
				} else {
					UpdateUrgent();
				}
			}
		}, {
			text: '感染',
			iconCls: 'icon-virus',
			handler: function() {
				var Main = MainListGrid.getSelected();
				if (Main.ComplateFlag === 'Y') {
					$UI.msg('alert', '单据已提交，不能处理感染!');
					return false;
				}
				var Rows = ItemListGrid.getSelections();
				if (isEmpty(Rows)) {
					$UI.msg('alert', '请选择需要处理感染的消毒包！');
					return false;
				}
				var TotalCount = 0, DealCount = 0;
				for (var i = 0; i < Rows.length; i++) {
					TotalCount = TotalCount + 1;
					if (Rows[i].InfectFlag == 'Y') {
						DealCount = DealCount + 1;
					}
				}
				if (DealCount == TotalCount) {
					$UI.confirm('已感染，重复操作会取消感染，是否继续？', '', '', UpdateInfect, '', '', '', '', 'N');
				} else {
					UpdateInfect();
				}
			}
		}],
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				// $('#ItemListGrid').datagrid('selectRow', 0);
			}
		},
		onSelect: function(index, row) {
			var Id = row.PackageDR;
			if (!isEmpty(Id)) {
				FindItemSByF(Id);
			}
		},
		saveDataFn: function() {
			SaveItm();
		},
		onBeginEdit: function(index, row) {
			$('#ItemSListGrid').datagrid('beginEdit', index);
			var ed = $('#ItemSListGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var e = ed[i];
				if (e.field === 'Qty') {
					$(e.target).bind('keydown', function(event) {
						if (event.keyCode === 13) {
							var Rows = ItemSListGrid.getChangesData('PackageDR');
							Rows[0].Qty = parseInt($(this).val());
							SaveItm(Rows);
							setTimeout(function() {
								ItemSListGrid.commonAddRow();
							}, 200);
						}
					});
				}
			}
		},
		beforeDelFn: function() {
			var MainObj = MainListGrid.getSelected();
			if (MainObj.ComplateFlag !== 'N') {
				$UI.msg('alert', '单据已提交不能删除明细!');
				return false;
			}
		},
		onClickCell: function(index, field, value) {
			if (field === 'PackageDR') {
				return false;
			}
			var Row = ItemListGrid.getRows()[index];
			if (Row.PackTypeDetail == 1) {
				return false;
			}
			ItemListGrid.commonClickCell(index, field);
		},
		beforeAddFn: function() {
			var rowMain = MainListGrid.getSelected();
			if (rowMain.ComplateFlag === 'Y') {
				$UI.msg('alert', '单据已提交不能增加!');
				return false;
			}
		},
		onBeforeEdit: function() {
			var rowMain = MainListGrid.getSelected();
			if (rowMain.ComplateFlag === 'Y') {
				$UI.msg('alert', '单据已提交不能修改!');
				return false;
			}
		},
		afterDelFn: function() {
			var rowMain = MainListGrid.getSelected();
			var MainId = rowMain.RowId;
			CurrMainId = MainId;
			MainListGrid.reload();
		}
	});

	function FindItemSByF(Id) {
		ItemSListGrid.load({
			ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
			QueryName: 'SelectByF',
			PkgId: Id,
			rows: 99999
		});
	}
	
	function flagColor(val, row, index) {
		if (row.OneOffFlag === 'Y') {
			return 'color:white;background:' + GetColorCode('yellow');
		}
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
			styler: flagColor
		}, {
			title: '器械规格',
			field: 'ItmSpec',
			width: 100
		}, {
			title: '数量',
			field: 'Qty',
			align: 'right',
			width: 60
		}, {
			title: 'OneOffFlag',
			field: 'OneOffFlag',
			align: 'right',
			width: 60,
			hidden: true
		}
	]];
	var ItemSListGrid = $UI.datagrid('#ItemSListGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
			QueryName: 'SelectByF'
		},
		columns: ItemSCm,
		pagination: false
	});

	// 显示数量角标
	function GetMarkQty() {
		var ParamsObj = {};
		var Obj = $UI.loopBlock('#MainCondition');
		ParamsObj.FSupLoc = Obj.SupLoc;
		ParamsObj.FStartDate = DefaultStDate();
		ParamsObj.FEndDate = DefaultEdDate();
		ParamsObj.DateType = 1;
		ParamsObj.ReqStatus = 5;
		ParamsObj.IsCallBackAll = 'N';
		ParamsObj.ReqType = '0,4,5';
		var Params = JSON.stringify(addSessionParams(ParamsObj));
		var MarkQtyObj = $.cm({
			ClassName: 'web.CSSDHUI.CallBack.CallBack',
			MethodName: 'GetMarkQty',
			Params: Params
		}, false);
		$('#ApplyNum').html(MarkQtyObj.ApplyNum);
	}
	
	function AdjustLayoutSize() {
		var NorthWidth = $(window).width() * 0.5;
		var DispWestWidth = $(window).width() * 0.3;
		$('#OrdLayout').layout('panel', 'east').panel('resize', { width: NorthWidth });
		$('#OrdLayout').layout();
		$('#CallBackLayout').layout('panel', 'west').panel('resize', { width: DispWestWidth });
		$('#CallBackLayout').layout();
	}

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
		return '';
	}
	var gRowIdStr = getQueryVariable('RowIdStr');
	window.onresize = function() {
		AdjustLayoutSize();
	};
	AdjustLayoutSize();
	Default();
	if (!isEmpty(gRowIdStr)) {
		Query(gRowIdStr);
	} else {
		Query();
	}
};
$(init);