var gFn, gReqLocId;
var ApplyMoudle = function(Fn, LocId) {
	gFn = Fn;
	gReqLocId = LocId;
	$HUI.dialog('#SelReqWin').open();
};

var initApplyMoudle = function() {
	// 选取请领模板
	$UI.linkbutton('#SelApplyMoudleBT', {
		onClick: function() {
			MoudleCreate();
		}
	});

	function MoudleCreate() {
		var MainRow = $('#MoudleGrid').datagrid('getSelected');
		if (isEmpty(MainRow)) {
			$UI.msg('alert', '请选择需要生成的请领单据模板');
			return;
		}
		var MainId = MainRow.RowId;
		var ItemRowObj = MoudleDetailGrid.getSelectedData();
		var DetailRows = '';
		for (var i = ItemRowObj.length - 1; i >= 0; i--) {
			var DetailRow = ItemRowObj[i]['RowId'];
			if (DetailRows === '') {
				DetailRows = DetailRow;
			} else {
				DetailRows = DetailRows + ',' + DetailRow;
			}
		}
		var ParamsObj = {};
		var Params = JSON.stringify(addSessionParams(ParamsObj));
		$.cm({
			ClassName: 'web.CSSDHUI.Apply.PackageMoudle',
			MethodName: 'jsPackageApplyByMoudle',
			DetailRows: DetailRows,
			MainId: MainId,
			Params: Params
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				$('#SelReqWin').window('close');
				var ApplyId = jsonData.rowid;
				gFn(ApplyId);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	// 请求科室是否取全院科室
	var ReqLocParams = '';
	if (ApplyParamObj.IfAllLoc == 'Y') {
		ReqLocParams = JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: gHospId }));
	} else {
		ReqLocParams = JSON.stringify(addSessionParams({ Type: 'Login', BDPHospital: gHospId }));
	}
	// 请求科室
	var ReqLocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect: function(record) {
				var rows = MoudleGrid.getRows();
				var row = rows[MoudleGrid.editIndex];
				row.ReqLocDesc = record.Description;
			}
		}
	};
	var SupLocParams = JSON.stringify(addSessionParams({ Type: 'SupLoc', BDPHospital: gHospId }));
	var SupLocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SupLocParams,
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onLoadSuccess: function(data) {
				if (data.length === 1) {
					$(this).combobox('setValue', data[0].RowId);
				}
			},
			onSelect: function(record) {
				var rows = MoudleGrid.getRows();
				var row = rows[MoudleGrid.editIndex];
				row.SupLocDesc = record.Description;
			}
		}
	};

	var ReqTypeCombox = {
		type: 'combobox',
		options: {
			data: [
				{ 'RowId': '0', 'Description': $g('回收申请单') },
				{ 'RowId': '1', 'Description': $g('借包单') },
				{ 'RowId': '2', 'Description': $g('非循环包申请单') }
			],
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = MoudleGrid.getRows();
				var row = rows[MoudleGrid.editIndex];
				row.ReqTypeDesc = record.Description;
				if (record.RowId == 4) {
					$UI.msg('alert', '归还单不支持自建模板!');
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

	var MoudleCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '模板名称',
			field: 'MoudleName',
			width: 120,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '申请科室',
			field: 'ApplyLocDr',
			width: 130,
			formatter: CommonFormatter(ReqLocCombox, 'ApplyLocDr', 'ReqLocDesc'),
			editor: ReqLocCombox
		}, {
			title: '单据类型',
			field: 'ReqType',
			width: 120,
			formatter: CommonFormatter(ReqTypeCombox, 'ReqType', 'ReqTypeDesc'),
			editor: ReqTypeCombox
		}, {
			title: '紧急程度',
			field: 'ReqLevel',
			width: 110,
			formatter: CommonFormatter(ReqLevelCombox, 'ReqLevel', 'ReqLevelDesc'),
			editor: ReqLevelCombox
		}, {
			title: '供应科室',
			field: 'SupRowId',
			width: 100,
			formatter: CommonFormatter(SupLocCombox, 'SupRowId', 'SupLocDesc'),
			editor: SupLocCombox
		}
	]];

	function QueryModule(RowId) {
		$UI.clear(MoudleDetailGrid);
		$UI.clear(MoudleGrid);
		var ParamsObj = { ReqLocId: gReqLocId, RowId: RowId };
		var Params = JSON.stringify(addSessionParams(ParamsObj));
		MoudleGrid.load({
			ClassName: 'web.CSSDHUI.Apply.PackageMoudle',
			QueryName: 'SelectMoudle',
			Params: Params
		});
	}
	// 模板主单据
	var MoudleGrid = $UI.datagrid('#MoudleGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Apply.PackageMoudle',
			QueryName: 'SelectMoudle'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.Apply.PackageMoudle',
			MethodName: 'jsDeleteMoudle'
		},
		columns: MoudleCm,
		fitColumns: true,
		pagination: false,
		singleSelect: true,
		sortName: 'RowId',
		sortOrder: 'desc',
		showAddSaveDelItems: true,
		checkField: 'MoudleName',
		toolbar: [
			{
				text: '编辑',
				iconCls: 'icon-edit',
				handler: function() {
					var Row = $('#MoudleGrid').datagrid('getSelected');
					if (isEmpty(Row)) {
						return;
					}
					var RowIndex = $('#MoudleGrid').datagrid('getRowIndex', Row);
					MoudleGrid.beginEdit(RowIndex);
					MoudleGrid.editIndex = RowIndex;
				}
			}, {
				text: '刷新',
				iconCls: 'icon-reload',
				handler: function() {
					QueryModule();
				}
			}
		],
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#MoudleGrid').datagrid('selectRow', 0);
			}
		},
		saveDataFn: function() {
			if (!MoudleGrid.endEditing()) {
				return;
			}
			var Rows = MoudleGrid.getChangesData();
			if (isEmpty(Rows)) {
				// $UI.msg('alert','没有需要保存的信息!');
				return;
			}
			if (Rows === false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			var MainObj = $('#MoudleGrid').datagrid('getSelected');
			if ((!isEmpty(MainObj)) && (MainObj.ApplyLocDr == MainObj.SupRowId) && ((!isEmpty(MainObj.ApplyLocDr)) || (!isEmpty(MainObj.SupRowId)))) {
				$UI.msg('alert', '申请科室和供应科室不能相同');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.Apply.PackageMoudle',
				MethodName: 'jsSaveMoudleMain',
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					var RowId = jsonData.rowid;
					QueryModule(RowId);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		beforeDelFn: function() {
			var rowMoudle = $('#MoudleGrid').datagrid('getSelected');
			if (isEmpty(rowMoudle)) {
				$UI.msg('alert', '请选择要删除的单据!');
				return false;
			}
		},
		afterDelFn: function() {
			$UI.clear(MoudleDetailGrid);
			MoudleGrid.reload();
		},
		onSelect: function(index, rowData) {
			var Id = rowData.RowId;
			if (!isEmpty(Id)) {
				MoudleDetailGrid.load({
					ClassName: 'web.CSSDHUI.Apply.PackageMoudle',
					QueryName: 'SelectMoudleDetail',
					MoudleId: Id,
					rows: 9999
				});
			}
		},
		onClickRow: function(index, row) {
			MoudleGrid.endEditing();
		},
		beforeAddFn: function() {
			$UI.clear(MoudleDetailGrid);
		},
		onDblClickRow: function(rowIndex) {
			$('#MoudleGrid').datagrid('selectRow', rowIndex);
			MoudleCreate();
		}
	});

	var PackageCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onBeforeLoad: function(param) {
				var rowMain = $('#MoudleGrid').datagrid('getSelected');
				var ReqType = rowMain.ReqType;
				var LocId = rowMain.ApplyLocDr;
				if (ReqType == 2) {
					param.Params = JSON.stringify(addSessionParams({ TypeDetail: '7', BDPHospital: gHospId }));
				} else {
					param.Params = JSON.stringify(addSessionParams({ TypeDetail: '2', BDPHospital: gHospId }));
				}
			},
			onSelect: function(record) {
				var rows = MoudleDetailGrid.getRows();
				var row = rows[MoudleDetailGrid.editIndex];
				MoudleDetailGrid.EditorSetValue('PackageDR', record.RowId);
				row.PackageName = record.Description;
				var index = MoudleDetailGrid.getRowIndex(row);
				for (var i = 0; i < rows.length; i++) {
					if (rows[i].PackageName === record.Description && (i !== index)) {
						$UI.msg('alert', '消毒包重复!');
						$(this).combobox('clear');
						return;
					}
				}

				// 联动消毒包材料 (一旦保存,不允许编辑消毒包)
				var ed = MoudleDetailGrid.getEditor({ index: MoudleDetailGrid.editIndex, field: 'MaterialId' });
				if (isEmpty(ed)) {
					MoudleDetailGrid.updateRow({
						index: MoudleDetailGrid.editIndex,
						row: { MaterialId: '', MaterialDesc: '' }
					});
				} else {
					AddComboData($(ed.target), record['MaterialId'], record['MaterialDesc']);
					MoudleDetailGrid.EditorSetValue('MaterialId', record['MaterialId']);

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
				var rows = MoudleDetailGrid.getRows();
				var row = rows[MoudleDetailGrid.editIndex];
				row.MaterialDesc = record.Description;
			},
			onBeforeLoad: function(param) {
				var RowItem = MoudleDetailGrid.getRows()[MoudleDetailGrid.editIndex];
				if (!isEmpty(RowItem)) {
					param['packageDr'] = RowItem['PackageDR'];
				}
			}
		}
	};

	var MoudleDetailCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '消毒包',
			field: 'PackageDR',
			width: 140,
			formatter: CommonFormatter(PackageCombox, 'PackageDR', 'PackageName'),
			editor: PackageCombox
		}, {
			title: '请领数量',
			align: 'right',
			field: 'Qty',
			width: 80,
			editor: { type: 'numberbox', options: { required: true, min: 0 }}
		}, {
			title: '包装材料',
			field: 'MaterialId',
			width: 140,
			formatter: CommonFormatter(GetMaterialsBox, 'MaterialId', 'MaterialDesc'),
			editor: GetMaterialsBox
		}, {
			title: '备注',
			field: 'Remark',
			width: 130,
			editor: { type: 'validatebox' }
		}
	]];
	// 模板明细
	var MoudleDetailGrid = $UI.datagrid('#MoudleDetailGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Apply.PackageMoudle',
			QueryName: 'SelectMoudleDetail'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.Apply.PackageMoudle',
			MethodName: 'jsDelete'
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#MoudleDetailGrid').datagrid('selectAll');
			}
		},
		showAddSaveDelItems: true,
		columns: MoudleDetailCm,
		fitColumns: true,
		pagination: false,
		singleSelect: false,
		checkField: 'PackageDR',
		sortName: 'RowId',
		sortOrder: 'desc',
		saveDataFn: function() {
			var Rows = MoudleDetailGrid.getChangesData();
			if (isEmpty(Rows)) {
				// $UI.msg('alert','没有需要保存的信息!');
				return;
			}
			if (Rows == false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			var Selected = MoudleGrid.getSelected();
			var MainRowId = Selected.RowId;
			$.cm({
				ClassName: 'web.CSSDHUI.Apply.PackageMoudle',
				MethodName: 'jsSave',
				Parref: MainRowId,
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					MoudleDetailGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		beforeAddFn: function() {
			var rowMain = $('#MoudleGrid').datagrid('getSelected');
			if (isEmpty(rowMain)) {
				$UI.msg('alert', '请选择模板单据！');
				return false;
			}
		},
		onClickCell: function(index, field, value) {
			if (field === 'PackageDR') {
				return false;
			}
			MoudleDetailGrid.commonClickCell(index, field);
		}
	});

	$HUI.dialog('#SelReqWin', {
		height: gWinHeight,
		width: gWinWidth,
		onOpen: function() {
			QueryModule();
		}
	});
};
$(initApplyMoudle);