// 消毒包接收
function ReceOrder(mainRowId) {
	if (isEmpty(mainRowId)) {
		$UI.msg('alert', '请选择要提交的单据!');
		return false;
	}
	var UserId = gUserId;
	var MainObj = $UI.loopBlock('#ReceCondition');
	if (DispParamObj['RequiredReceiveUser'] === 'Y') {
		UserId = MainObj.toUser;
		if (isEmpty(MainObj.toUser)) {
			$UI.msg('alert', '接收人不能为空');
			$('#toUser').combobox('textbox').focus();
			return false;
		}
	}
	showMask();
	$.cm({
		ClassName: 'web.CSSDHUI.PackageDisp.Receive',
		MethodName: 'jsReceOrder',
		DispMainId: mainRowId,
		UserId: UserId
	}, function(jsonData) {
		hideMask();
		if (jsonData.success === 0) {
			$UI.msg('success', jsonData.msg);
			$('#ItemList').datagrid('loadData', []);
			$('#MainList').datagrid('reload');
		} else {
			$UI.msg('error', jsonData.msg);
		}
	});
}
// 取消接收
function cancelOrder(mainRowId) {
	if (isEmpty(mainRowId)) {
		$UI.msg('alert', '请选择要取消的单据!');
		return false;
	}
	$UI.confirm('您将要取消接收该单据,是否继续?', '', '', cancelOrderFun, '', '', '', '', mainRowId);
}
function cancelOrderFun(mainRowId) {
	var UserId = gUserId;
	showMask();
	$.cm({
		ClassName: 'web.CSSDHUI.PackageDisp.Receive',
		MethodName: 'jsCanlRecOrder',
		DispMainId: mainRowId,
		UserId: UserId
	}, function(jsonData) {
		hideMask();
		if (jsonData.success === 0) {
			$UI.msg('success', jsonData.msg);
			$('#ItemList').datagrid('loadData', []);
			$('#MainList').datagrid('reload');
		} else {
			$UI.msg('error', jsonData.msg);
		}
	});
}

var init = function() {
	// 发放科室
	var ReqLocParams = JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: gHospId }));
	$HUI.combobox('#fromLocDr', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams
	});
	// 接收科室
	var SupLocParams = JSON.stringify(addSessionParams({ Type: 'Login', BDPHospital: gHospId }));
	$HUI.combobox('#toLocDr', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SupLocParams,
		onSelect: function(record) {
			var LocId = $('#toLocDr').combobox('getValue');
			$('#toUser').combobox('clear');
			var Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId, LocId: LocId }));
			var url = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array&Params=' + Params;
			$('#toUser').combobox('reload', url);
			$('#toUser').combobox('setValue', gUserId);
		}
	});
	
	// 接收人
	var ParamsTB = JSON.stringify($UI.loopBlock('#MainCondition'));
	$HUI.combobox('#toUser', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array',
		enterNullValueClear: false,
		spellField: 'Code'
	});
	$('#toUser').combobox('textbox').keyup(function(event) {
		if (event.keyCode == 13) {
			var userCode = $('#toUser').combobox('getText');
			if (userCode != '') {
				var UserObj = $.cm({
					ClassName: 'web.CSSDHUI.Common.Dicts',
					MethodName: 'GetUserByCodeJson',
					userCode: userCode,
					Params: ParamsTB
				}, false);
				if (UserObj['RowId'] == '') {
					$UI.msg('alert', '未获取审核人相关信息！');
					$('#toUser').combobox('setValue', '');
					$('#toUser').combobox('textbox').focus();
					return;
				}
				$('#ToUser').combobox('setValue', UserObj['RowId']);
			}
		}
	});
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			$UI.clear(ItemListGrid);
			query();
		}
	});
	function query() {
		var ParamsObj = $UI.loopBlock('#MainCondition');
		if (isEmpty(ParamsObj.toLocDr)) {
			$UI.msg('alert', '接收科室不能为空！');
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
		var Params = JSON.stringify(ParamsObj);
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.PackageDisp.DispScan',
			QueryName: 'SelectAll',
			Params: Params
		});
	}
	
	// 批量接收
	$UI.linkbutton('#ReceAll', {
		onClick: function() {
			$.messager.confirm('操作提示', '您确定要执行批量接收操作吗？', function(data) {
				if (data) {
					var Detail = MainListGrid.getChecked();
					if (isEmpty(Detail)) {
						$UI.msg('alert', '请选择需要接收的单据!');
						return;
					}
					var UserId = gUserId;
					var MainObj = $UI.loopBlock('#ReceCondition');
					if (DispParamObj['RequiredReceiveUser'] === 'Y') {
						UserId = MainObj.toUser;
						if (isEmpty(MainObj.toUser)) {
							$UI.msg('alert', '接收人不能为空');
							return false;
						}
					}
					var DetailParams = JSON.stringify(Detail);
					showMask();
					$.cm({
						ClassName: 'web.CSSDHUI.PackageDisp.Receive',
						MethodName: 'jsReceAll',
						Params: DetailParams,
						UserId: UserId
					}, function(jsonData) {
						hideMask();
						if (jsonData.success === 0) {
							$UI.msg('success', jsonData.msg);
							$UI.clear(ItemListGrid);
							$('#MainList').datagrid('reload');
						} else {
							$UI.msg('error', jsonData.msg);
						}
					});
				}
			});
		}
	});
	
	$UI.linkbutton('#RecePart', {
		onClick: function() {
			var Detail = ItemListGrid.getChecked();
			if (isEmpty(Detail)) {
				$UI.msg('alert', '请选择需要接收的标签!');
				return;
			}
			for (var i = 0; i < Detail.length; i++) {
				if (isEmpty(Detail[i].Label)) {
					$UI.msg('alert', '未按标签发放，不能按照明细接收!');
					return;
				}
			}
			var row = $('#MainList').datagrid('getSelected');
			var DetailParams = JSON.stringify(Detail);
			showMask();
			$.cm({
				ClassName: 'web.CSSDHUI.PackageDisp.Receive',
				MethodName: 'jsRecePart',
				mainId: row.RowId,
				Params: DetailParams,
				UserId: gUserId
			}, function(jsonData) {
				hideMask();
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					ItemListGrid.reload();
					var IsRec = jsonData.keyValue['IsRec'];
					var ToUserDesc = jsonData.keyValue['ToUser'];
					var RecDate = jsonData.keyValue['ReceiveTime'];
					if (IsRec === 'Y') {
						MainListGrid.updateRow({
							index: MainListGrid.editIndex,
							row: {
								IsRec: 'Y',
								ToUserDesc: ToUserDesc,
								RecDate: RecDate
							}
						});
						MainListGrid.refreshRow();
					}
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	var MainCm = [[
		{
			title: '',
			field: 'ck',
			checkbox: true,
			width: 50,
			frozen: true
		}, {
			field: 'operate',
			title: '操作',
			frozen: true,
			align: 'center',
			width: 60,
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '';
				if (row.IsRec === 'Y') {
					str = '<div class="col-icon icon-back" title="' + $g('撤销') + '" onclick="cancelOrder(' + row.RowId + ')"></div>';
				} else {
					str = '<div class="col-icon icon-submit" title="' + $g('接收') + '" onclick="ReceOrder(' + row.RowId + ')"></div>';
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
			title: '单据状态',
			field: 'IsRec',
			width: 100,
			styler: flagColor,
			align: 'center',
			formatter: function(value) {
				var status = '';
				if (value == 'Y') {
					status = $g('已接收');
				} else {
					status = $g('未接收');
				}
				return status;
			}
		}, {
			title: '单据类型',
			field: 'DocType',
			width: 80,
			styler: DocTypeflagColor,
			formatter: function(value) {
				var desc = '发放单';
				if (value == '1') {
					desc = $g('调拨单');
				}
				return desc;
			}
		}, {
			title: '发放科室',
			field: 'FromLocDesc',
			width: 100
		}, {
			title: '接收科室',
			field: 'ToLocDesc',
			width: 100
		}, {
			title: '接收人',
			field: 'ToUserDesc',
			width: 100
		}, {
			title: '接收时间',
			field: 'RecDate',
			width: 150
		}, {
			title: '发放人',
			field: 'FromUserDesc',
			width: 100
		}, {
			title: '发放时间',
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
			width: 100,
			hidden: true
		}, {
			title: '发放类型',
			field: 'DispType',
			width: 100,
			hidden: true
		}, {
			title: '申请单号',
			field: 'ApplyNo',
			width: 120
		}, {
			title: '申请时间',
			field: 'ApplyDateTime',
			width: 150
		}
	]];
	function flagColor(val, row, index) {
		if (val === 'Y') {
			return 'color:white;background:' + GetColorCode('green');
		} else {
			return 'color:white;background:' + GetColorCode('red');
		}
	}

	function DocTypeflagColor(val, row, index) {
		if (val == '1') {
			return 'color:white;background:' + GetColorCode('yellow');
		} else {
			return 'color:white;background:' + GetColorCode('orange');
		}
	}
	
	var MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.DispScan',
			QueryName: 'SelectAll'
		},
		columns: MainCm,
		sortOrder: 'desc',
		sortName: 'RowId',
		selectOnCheck: false,
		onLoadSuccess: function(data) {
			$UI.clear(ItemListGrid);
			if (data.rows.length > 0) {
				if (CommParObj.SelectFirstRow == 'Y') {
					$('#MainList').datagrid('selectRow', 0);
				}
			}
		},
		onClickRow: function(index, row) {
			MainListGrid.commonClickRow(index, row);
		},
		onSelect: function(index, rowData) {
			var Id = rowData.RowId;
			ItemListGrid.load({
				ClassName: 'web.CSSDHUI.PackageDisp.DispItm',
				QueryName: 'SelectByF',
				MainId: Id,
				rows: 9999
			});
		}
	});

	// 扫码动作
	$('#BarCode').keyup(function(event) {
		if (event.which == 13) {
			AddRecItem();
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
			AddRecItem();
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
	
	function AddRecItem() {
		var BarCode = $('#BarCode').val();
		var row = $('#MainList').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择需要接收的发放单据!');
			return;
		}
		if (isEmpty(row.RowId)) {
			$UI.msg('alert', '参数错误!');
			return;
		}
		if (isEmpty(BarCode)) {
			return;
		}
		var MainObj = $UI.loopBlock('#ReceCondition');
		var RecUserId = !isEmpty(MainObj.toUser) ? MainObj.toUser : gUserId;
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.PackageDisp.Receive',
			MethodName: 'jsRecDetail',
			mainId: row.RowId,
			barCode: BarCode,
			UserId: RecUserId
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				ItemListGrid.reload();
				var IsRec = jsonData.keyValue['IsRec'];
				if (IsRec === 'Y') {
					MainListGrid.updateRow({
						index: MainListGrid.editIndex,
						row: {
							IsRec: 'Y'
						}
					});
					MainListGrid.refreshRow();
				}
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
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '标签',
			field: 'Label',
			width: 170,
			styler: function(value, row, index) {
				var SterTypeColor = '';
				if ((!isEmpty(row.RecDate)) || (!isEmpty(row.ToUserDesc))) {
					SterTypeColor = GetColorCode('green');
				}
				return 'background-color:' + SterTypeColor + ';' + 'color:' + GetFontColor(SterTypeColor);
			}
		}, {
			title: '消毒包',
			field: 'PackageName',
			width: 150
		}, {
			title: '数量',
			field: 'Qty',
			align: 'right',
			width: 45
		}, {
			title: '接收人',
			field: 'ToUserDesc',
			width: 80
		}, {
			title: '包装材料',
			align: 'left',
			field: 'PackMaterialName',
			width: 80
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
			title: '接收日期',
			field: 'RecDate',
			width: 100,
			sortable: true,
			hidden: true
		}
	]];

	var ItemListGrid = $UI.datagrid('#ItemList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.DispItm',
			QueryName: 'SelectByF'
		},
		columns: ItemCm,
		pagination: false,
		singleSelect: false,
		sortName: 'RowId',
		sortOrder: 'desc'
	});
	
	var Default = {
		toLocDr: gLocObj,
		FStartDate: DefaultStDate(),
		FEndDate: DefaultEdDate()
	};
	var ReceDefault = {
		toUser: DispParamObj.IsGetRecUserByLogin === 'Y' ? gUserId : ''
	};
	$UI.fillBlock('#MainCondition', Default);
	$UI.fillBlock('#ReceCondition', ReceDefault);
	query();
};
$(init);