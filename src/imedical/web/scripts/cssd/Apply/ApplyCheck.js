// 回收申请确认
var MainListGrid;
var ItemListGrid;

// 确认
function CheckPass(RowId) {
	var Row = [{ RowId: RowId }];
	CheckPassFun(Row);
}
function CheckPassFun(Rows) {
	var Params = JSON.stringify(Rows);
	var MainParams = JSON.stringify(addSessionParams());
	showMask();
	$.cm({
		ClassName: 'web.CSSDHUI.Apply.ApplyCheck',
		MethodName: 'jsAudit',
		Params: Params,
		main: MainParams
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

// 取消确认
function CheckBack(RowId) {
	var Row = [{ RowId: RowId }];
	$UI.confirm('您将要取消确认，是否继续？', '', '', CheckBackFun, '', '', '', '', Row);
}
function CheckBackFun(Rows) {
	var Params = JSON.stringify(Rows);
	showMask();
	$.cm({
		ClassName: 'web.CSSDHUI.Apply.ApplyCheck',
		MethodName: 'jsCancelAudit',
		Params: Params
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
	// 请求科室
	var ReqLocParams = JSON.stringify(addSessionParams({ Type: 'RecLoc', BDPHospital: gHospId }));
	$HUI.combobox('#FReqLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	// 供应科室
	var SupLocParams = JSON.stringify(addSessionParams({ Type: 'Login', BDPHospital: gHospId }));
	$HUI.combobox('#FSupLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SupLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LineParams = JSON.stringify(addSessionParams({ SupLocId: record['RowId'], BDPHospital: gHospId }));
			var url = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetLine&ResultSetType=array&Params=' + LineParams;
			$('#LineCode').combobox('clear').combobox('reload', url);
		}
	});
	// 单据类型
	$HUI.combobox('#ReqType', {
		valueField: 'RowId',
		textField: 'Description',
		data: [
			{ 'RowId': '0,4,5', 'Description': $g('全部') },
			{ 'RowId': '0', 'Description': $g('回收申请单') },
			{ 'RowId': '4', 'Description': $g('归还单') }
			//, { 'RowId': '5', 'Description': $g('手术申请单') }
		]
	});
	// 状态
	$HUI.combobox('#ReqStatus', {
		valueField: 'RowId',
		textField: 'Description',
		data: [
			{ 'RowId': '1,2,5,7,8', 'Description': $g('全部') },
			{ 'RowId': '1', 'Description': $g('提交') },
			{ 'RowId': '5', 'Description': $g('确认') },
			{ 'RowId': '8', 'Description': $g('拒绝') },
			{ 'RowId': '7', 'Description': $g('归还') },
			{ 'RowId': '2', 'Description': $g('回收') }
		]
	});

	var LineParams = JSON.stringify(addSessionParams({ SupLocId: gLocId, BDPHospital: gHospId }));
	$HUI.combobox('#LineCode', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetLine&ResultSetType=array&Params=' + LineParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			query();
		}
	});
	
	function query() {
		$UI.clear(ItemListGrid);
		$UI.clear(MainListGrid);
		if (isEmpty($('#FSupLoc').combobox('getValue'))) {
			$UI.msg('alert', '供应科室不能为空!');
			return;
		}
		var ParamsObj = $UI.loopBlock('#MainCondition');
		if (isEmpty(ParamsObj.ReqType)) {
			ParamsObj.ReqType = '0,4,5';
		}
		if (isEmpty(ParamsObj.ReqStatus)) {
			ParamsObj.ReqType = '1,2,5,7,8';
		}
		ParamsObj.DateType = '1';
		if (isEmpty(ParamsObj.FStartDate)) {
			$UI.msg('alert', '起始日期为空!');
			return;
		} else if (isEmpty(ParamsObj.FEndDate)) {
			$UI.msg('alert', '截止日期为空!');
			return;
		}
		
		var Params = JSON.stringify(ParamsObj);
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.Apply.PackageApply',
			QueryName: 'SelectAll',
			Params: Params
		});
	}
	
	function Print() {
		var Detail = MainListGrid.getChecked();
		if (isEmpty(Detail)) {
			$UI.msg('alert', '请选择需要打印单据');
			return;
		}
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
	function PrintSum() {
		var Detail = MainListGrid.getChecked();
		if (isEmpty(Detail)) {
			$UI.msg('alert', '请选择需要打印单据');
		}
		var DetailIds = '';
		$.each(Detail, function(index, item) {
			if (DetailIds === '') {
				DetailIds = item.RowId;
			} else {
				DetailIds = DetailIds + ',' + item.RowId;
			}
		});
		PrintApplySum(DetailIds);
	}
	// 打印回收核对单
	function PrintSumByNo() {
		var Detail = MainListGrid.getChecked();
		if (isEmpty(Detail)) {
			$UI.msg('alert', '请选择需要打印单据');
		}
		var DetailIds = '';
		$.each(Detail, function(index, item) {
			if (DetailIds === '') {
				DetailIds = item.RowId;
			} else {
				DetailIds = DetailIds + ',' + item.RowId;
			}
		});
		PrintApplyCheck(DetailIds);
	}

	// 确认
	function audit() {
		var rows = MainListGrid.getChecked();
		if (rows.length === 0) {
			$UI.msg('alert', '请选择单据！');
			return;
		}
		var AllCheckStr = '';
		for (var i = 0, len = rows.length; i < len; i++) {
			var row = rows[i];
			var rowIndex = MainListGrid.getRowIndex(row);
			var CheckStr = '';
			if (row.ReqFlag === '5') {
				CheckStr = CheckStr + '已确认.';
			} else if (row.ReqFlag !== '1') {
				CheckStr = CheckStr + '请核实状态.';
			}
			if (!isEmpty(CheckStr)) {
				CheckStr = '第' + (rowIndex + 1) + '行' + CheckStr;
				AllCheckStr = AllCheckStr + CheckStr;
			}
		}
		if (!isEmpty(AllCheckStr)) {
			$UI.msg('alert', AllCheckStr);
			return false;
		}

		CheckPassFun(rows);
	}

	// 取消确认
	function Cancelaudit() {
		var rows = MainListGrid.getChecked();
		if (rows.length === 0) {
			$UI.msg('alert', '请选择单据！');
			return;
		}
		var AllCheckStr = '';
		for (var i = 0, len = rows.length; i < len; i++) {
			var row = rows[i];
			var rowIndex = MainListGrid.getRowIndex(row);
			var CheckStr = '';
			if (row.ReqFlag !== '5') {
				CheckStr = CheckStr + '请核实状态.';
			}
			if (!isEmpty(CheckStr)) {
				CheckStr = '第' + (rowIndex + 1) + '行' + CheckStr;
				AllCheckStr = AllCheckStr + CheckStr;
			}
		}
		if (!isEmpty(AllCheckStr)) {
			$UI.msg('alert', AllCheckStr);
			return false;
		}
		
		$UI.confirm('您将要取消确认，是否继续？', '', '', CheckBackFun, '', '', '', '', rows);
	}

	// 拒绝
	function refuse() {
		var rows = MainListGrid.getSelectedData();
		if (rows.length === 0) {
			$UI.msg('alert', '请选择单据！');
			return;
		}
		var AllCheckStr = '';
		for (var i = 0, len = rows.length; i < len; i++) {
			var row = rows[i];
			var rowIndex = MainListGrid.getRowIndex(row);
			var CheckStr = '';
			if (row.ReqFlag !== '1') {
				CheckStr = CheckStr + '请核实状态.';
			} else if (isEmpty(row.RefuseReason)) {
				CheckStr = CheckStr + '请录入拒绝原因!';
			}
			if (!isEmpty(CheckStr)) {
				CheckStr = '第' + (rowIndex + 1) + '行' + CheckStr;
				AllCheckStr = AllCheckStr + CheckStr;
			}
		}
		if (!isEmpty(AllCheckStr)) {
			$UI.msg('alert', AllCheckStr);
			return false;
		}
		
		var Params = JSON.stringify(rows);
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.Apply.ApplyCheck',
			MethodName: 'jsRefuse',
			Params: Params
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

	var MainCm = [[
		{
			field: 'ck',
			frozen: true,
			checkbox: true
		}, {
			field: 'operate',
			title: '标识',
			align: 'center',
			width: 80,
			frozen: true,
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '';
				if (row.ReqLevel === '1') {
					str = str + '<div class="col-icon icon-emergency" href="#" title="' + $g('紧急') + '"></div>';
				}
				if (row.BeInfected === 'Y') {
					str = str + '<div class="col-icon icon-virus" href="#" title=' + $g('感染') + '"></div>';
				}
				if (row.ReqFlag === '1') {
					str = str + '<div class="col-icon icon-submit" href="#" title="' + $g('确认') + '"onclick="CheckPass(' + row.RowId + ')"></div>';
				} else if (row.ReqFlag === '5') {
					str = str + '<div class="col-icon icon-back" href="#" title="' + $g('撤销') + '" onclick="CheckBack(' + row.RowId + ')"></div>';
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
			width: 100
		}, {
			title: '单据类型',
			field: 'ReqType',
			formatter: ReqTypeRenderer,
			width: 100
		}, {
			title: '申请科室',
			field: 'ReqLocDesc',
			width: 150
		}, {
			title: '拒绝原因',
			field: 'RefuseReason',
			width: 150,
			editor: { type: 'validatebox' }
		}, {
			title: '单据状态',
			field: 'ReqFlag',
			formatter: ReqStatusRenderer,
			width: 80
		}, {
			title: '提交时间',
			field: 'commitDate',
			width: 150
		}, {
			title: '提交人',
			field: 'commitUser',
			width: 100
		}, {
			title: '紧急程度',
			field: 'ReqLevel',
			formatter: ReqLevelRenderer,
			width: 80
		}, {
			title: 'BeInfected',
			field: 'BeInfected',
			width: 50,
			hidden: true
		}
	]];

	MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Apply.PackageApply',
			QueryName: 'SelectAll'
		},
		toolbar: [
			{
				text: '确认',
				iconCls: 'icon-ok',
				handler: function() {
					audit();
				}
			}, {
				text: '取消确认',
				iconCls: 'icon-back',
				handler: function() {
					Cancelaudit();
				}
			}, {
				text: '拒绝',
				iconCls: 'icon-no',
				handler: function() {
					refuse();
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
					PrintSum();
				}
			}, {
				text: '核对打印',
				iconCls: 'icon-reprint-inv',
				handler: function() {
					PrintSumByNo();
				}
			}
		],
		columns: MainCm,
		selectOnCheck: false,
		sortName: 'RowId',
		sortOrder: 'desc',
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				if (CommParObj.SelectFirstRow == 'Y') {
					$('#MainList').datagrid('selectRow', 0);
				}
			}
		},
		onSelect: function(index, rowData) {
			var Id = rowData.RowId;
			ItemListGrid.load({
				ClassName: 'web.CSSDHUI.Apply.PackageApplyItm',
				QueryName: 'SelectByF',
				ApplyId: Id,
				rows: 9999
			});
		},
		onClickRow: function(index, row) {
			var ReqFlag = row.ReqFlag;
			if (ReqFlag === '1') {
				MainListGrid.commonClickRow(index, row);
			}
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
				var LocId = rowMain['LocRowId'];
				if (ReqType === '2') {
					param.Params = JSON.stringify(addSessionParams({ TypeDetail: '7', LocId: LocId }));
				} else {
					param.Params = JSON.stringify(addSessionParams({ TypeDetail: '2', LocId: LocId }));
				}
			},
			onSelect: function(record) {
				var rows = ItemListGrid.getRows();
				var row = rows[ItemListGrid.editIndex];
				row.PackageName = record.Description;
				var pkgDr = record['RowId'];
				var index = ItemListGrid.getRowIndex(row);
				for (var i = 0; i < rows.length; i++) {
					if (rows[i].PackageDR === pkgDr && i !== index) {
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

	var ItemCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '消毒包',
			field: 'PackageDR',
			width: 166,
			formatter: CommonFormatter(PackageBox, 'PackageDR', 'PackageName'),
			editor: PackageBox
		}, {
			title: '标牌',
			field: 'BarCode',
			width: 100
		}, {
			title: '包装材料',
			field: 'MaterialId',
			width: 120,
			formatter: CommonFormatter(GetMaterialsBox, 'MaterialId', 'MaterialDesc'),
			editor: GetMaterialsBox
		}, {
			title: '数量',
			field: 'Qty',
			align: 'right',
			hidden: true,
			width: 100
		}, {
			title: '申请数量',
			field: 'ReqQty',
			align: 'right',
			editor: { type: 'numberbox', options: { required: true, min: 1, max: 10000 }},
			width: 100,
			styler: function(value, row, index) {
				if (row.ReqQty !== row.Qty) {
					return 'color:' + GetFontColorCode('red');
				}
			}
		}, {
			title: '备注',
			field: 'Remark',
			width: 166
		}, {
			title: '反馈信息',
			field: 'RemarkInfo',
			width: 110,
			editor: { type: 'validatebox' }
		}
	]];

	ItemListGrid = $UI.datagrid('#ItemList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Apply.PackageApplyItm',
			QueryName: 'SelectByF'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.Apply.ApplyCheck',
			MethodName: 'jsDeleteItm'
		},
		columns: ItemCm,
		pagination: false,
		showAddSaveDelItems: true,
		sortName: 'RowId',
		sortOrder: 'asc',
		saveDataFn: function() {
			var ItemRows = ItemListGrid.getChangesData();
			if (isEmpty(ItemRows)) return;
			if (ItemRows === false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			var rowMain = $('#MainList').datagrid('getSelected');
			if (isEmpty(rowMain)) return;
			$.cm({
				ClassName: 'web.CSSDHUI.Apply.PackageApplyItm',
				MethodName: 'jsSave',
				Params: JSON.stringify(ItemRows),
				MainId: rowMain.RowId
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					ItemListGrid.reload();
				} else {
					$UI.msg('alert', jsonData.msg);
				}
			});
		},
		onClickCell: function(index, field, value) {
			ItemListGrid.commonClickCell(index, field, value);
		},
		onBeforeCellEdit: function(index, field) {
			var rowMain = $('#MainList').datagrid('getSelected');
			if (rowMain.ReqFlag !== '1') return false;
			if (rowMain.ReqType === '4') return false;

			var BarCode = ItemListGrid.getRows()[ItemListGrid.editIndex]['BarCode'];
			if (field === 'PackageDR') {
				return false;
			} else if (field === 'Qty' && !isEmpty(BarCode)) {
				return false;
			}
		},
		beforeDelFn: function() {
			var rowMain = $('#ItemList').datagrid('getSelected');
			if (isEmpty(rowMain)) {
				$UI.msg('alert', '请选择要删除的单据！');
				return false;
			}
			var MainObj = $('#MainList').datagrid('getSelected');
			var ReqFlag = MainObj.ReqFlag;
			if (ReqFlag !== '1') {
				$UI.msg('alert', '仅允许编辑提交状态的单据!');
				return false;
			}
			/*
			if (MainObj.ReqFlag == '8') {
				$UI.msg('alert', '单据已拒绝不能删除明细！');
				return false;
			} else if (MainObj.ReqFlag == '5') {
				$UI.msg('alert', '单据已确认不能删除明细！');
				return false;
			}
			*/
		},
		beforeAddFn: function() {
			var rowMain = $('#MainList').datagrid('getSelected');
			if (rowMain.ReqFlag !== '1') return false;
			if (rowMain.ReqType === '4') return false;
		}
	});

	function Default() {
		var StartDate = getQueryVariable('StartDate');
		var DefaultDate = {
			FSupLoc: gLocObj,
			ReqType: '0,4,5',		// 单据类型
			ReqStatus: '1,2,5,7,8',
			FStartDate: StartDate,
			FEndDate: DefaultEdDate()
		};
		$UI.fillBlock('#MainCondition', DefaultDate);
	}
	Default();
	query();
};

$(init);