// 消毒包和包装材料对照界面
var init = function() {
	var HospId = gHospId;
	var TableName = 'CSSD_Package';
	function InitHosp() {
		var hospComp = InitHospCombo(TableName, gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				Query();
			};
		}
		Query();
	}

	$HUI.combobox('#PkgClassId', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackageClass&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: HospId })),
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.combobox('#AttributeId', {
		valueField: 'RowId',
		textField: 'Description',
		data: PackTypeMData
	});
	// 包装材料下拉数据
	var GetMaterialsBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetMaterials&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: HospId })),
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect: function(record) {
				var rows = MaterialsGrid.getRows();
				var row = rows[MaterialsGrid.editIndex];
				for (var i = 0; i < rows.length; i++) {
					if (rows[i].MaterialDesc == record.Description && i != MaterialsGrid.editIndex) {
						$UI.msg('alert', '包装材料名称重复!');
						$(this).combobox('clear');
						return;
					}
				}
				row.MaterialId = record.RowId;
				row.MaterialDesc = record.Description;
				var LengthEditor = $('#MaterialsGrid').datagrid('getEditor', { index: MaterialsGrid.editIndex, field: 'ExpLength' });
				LengthEditor.target.numberbox('setValue', record['Length']);
			}
		}
	};

	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			Query();
		}
	});

	function Query() {
		$UI.clear(MaterialsGrid);
		var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		var ParamsObj = $UI.loopBlock('Conditions');
		ParamsObj.ContainerFlag = 'N';
		var Params = JSON.stringify(ParamsObj);
		PackageGrid.load({
			ClassName: 'web.CSSDHUI.PackageInfo.Package',
			QueryName: 'QueryPkgInfo',
			Params: Params,
			Others: Others,
			rows: 999
		});
	}

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clearBlock('Conditions');
			$UI.clear(PackageGrid);
			$UI.clear(MaterialsGrid);
		}
	});

	var PackageGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 60,
			hidden: true
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			align: 'left',
			width: 300,
			sortable: true
		}, {
			title: '包属性',
			field: 'AttributeDesc',
			align: 'left',
			width: 130,
			sortable: true
		}, {
			title: '消毒包分类',
			field: 'PkgClassDesc',
			align: 'left',
			width: 130,
			sortable: true
		}, {
			title: '灭菌方式',
			field: 'SterTypeDesc',
			width: 130,
			align: 'left',
			sortable: true
		}
	]];
	var PackageGrid = $UI.datagrid('#PackageGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.Package',
			QueryName: 'QueryPkgInfo'
		},
		fitColumns: true,
		columns: PackageGridCm,
		singleSelect: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		},
		onClickRow: function(index, row) {
			PackageGrid.commonClickRow(index, row);
		},
		onSelect: function(index, rowData) {
			var Id = rowData.RowId;
			if (!isEmpty(Id)) {
				MaterialsGrid.load({
					ClassName: 'web.CSSDHUI.PackageInfo.PackageMatCompare',
					QueryName: 'SelectPackageMat',
					Parref: Id,
					rows: 999
				});
			}
		}
	});

	var MaterialsGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 60,
			hidden: true
		}, {
			title: '包装材料代码',
			field: 'MaterialCode',
			width: 150,
			hidden: true
		}, {
			title: '包装材料',
			align: 'left',
			field: 'MaterialId',
			width: 150,
			formatter: CommonFormatter(GetMaterialsBox, 'MaterialId', 'MaterialDesc'),
			editor: GetMaterialsBox
		}, {
			title: '有效期天数',
			field: 'ExpLength',
			align: 'right',
			width: 120,
			sortable: true,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					precision: 0,
					min: 1
				}}
		}, {
			title: '价格',
			field: 'Price',
			align: 'right',
			width: 100,
			sortable: true,
			editor: { type: 'numberbox', options: { required: true, min: 0 }},
			formatter: function(value, row, index) {
				if (value !== '') {
					return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
				}
			}
		}, {
			title: '是否默认',
			field: 'DefaultFlag',
			width: 100,
			align: 'center',
			editor: { type: 'checkbox', check: 'checked', options: { on: 'Y', off: 'N' }},
			formatter: BoolFormatter
		}
	]];
	var MaterialsGrid = $UI.datagrid('#MaterialsGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.PackageMatCompare',
			QueryName: 'SelectPackageMat'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.PackageMatCompare',
			MethodName: 'jsDelete'
		},
		showAddSaveDelItems: true,
		columns: MaterialsGridCm,
		fitColumns: true,
		pagination: false,
		remoteSort: false,
		sortName: 'MaterialCode',
		sortOrder: 'asc',
		checkField: 'MaterialId',
		saveDataFn: function() { // 保存明细
			var Rows = MaterialsGrid.getRowsData();
			var Len = Rows.length;
			var DefaultCount = 0;
			for (var i = 0; i < Len; i++) {
				var row = Rows[i];
				if (row['DefaultFlag'] == 'Y') {
					DefaultCount = DefaultCount + 1;
				}
			}
			if (DefaultCount !== 1) {
				$UI.msg('alert', '需设置一个默认包装材料!');
				return;
			}
			var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			Rows = MaterialsGrid.getChangesData();
			if (isEmpty(Rows)) {
				return;
			}
			if (Rows == false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			var Selected = PackageGrid.getSelected();
			var PkgRowId = Selected.RowId;
			showMask();
			$.cm({
				ClassName: 'web.CSSDHUI.PackageInfo.PackageMatCompare',
				MethodName: 'jsSave',
				Parref: PkgRowId,
				Params: JSON.stringify(Rows),
				Others: Others
			}, function(jsonData) {
				hideMask();
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					MaterialsGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		beforeAddFn: function() {
			var rowMain = $('#PackageGrid').datagrid('getSelected');
			if (isEmpty(rowMain)) {
				$UI.msg('alert', '请选择消毒包信息!');
				return false;
			}
			var RowsCount = $('#MaterialsGrid').datagrid('getRows').length;
			if (RowsCount === 0) {
				return { DefaultFlag: 'Y' };
			}
		},
		beforeDelFn: function() {
			var rowMaterials = $('#MaterialsGrid').datagrid('getSelected');
			if (isEmpty(rowMaterials)) {
				$UI.msg('alert', '请选择要删除的单据!');
				return false;
			}
			if (rowMaterials.DefaultFlag == 'Y') {
				$UI.msg('alert', '不能删除默认包装材料!');
				return false;
			}
			var RowsCount = $('#MaterialsGrid').datagrid('getRows').length;
			if (RowsCount <= 1) {
				$UI.msg('alert', '当前仅有一个包装材料,不能继续删除,请核实!');
				return false;
			}
		},
		onClickRow: function(index, row) {
			MaterialsGrid.commonClickRow(index, row);
		}
	});
	InitHosp();
};
$(init);