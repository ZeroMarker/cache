// 图标包装材料弹框
var gPkgId, gFn;
var FindPkgMaterial = function(PkgId, Fn) {
	gPkgId = PkgId;
	gFn = Fn;
	$HUI.dialog('#MatCompareWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
};

var initFindPkgMaterial = function() {
	// 包装材料下拉数据
	var GetMaterialsBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetMaterials&ResultSetType=array&Params='
				+ JSON.stringify(addSessionParams({ BDPHospital: gHospId })),
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect: function(record) {
				var rows = MaterialsGrid.getRows();
				var row = rows[MaterialsGrid.editIndex];
				row.MaterialId = record.RowId;
				row.MaterialDesc = record.Description;
				var LengthEditor = $('#MatCompare').datagrid('getEditor', { index: MaterialsGrid.editIndex, field: 'ExpLength' });
				LengthEditor.target.numberbox('setValue', record['Length']);
				var index = MaterialsGrid.getRowIndex(row);
				for (var i = 0; i < rows.length; i++) {
					if (rows[i].MaterialDesc === record.Description && i !== index) {
						$UI.msg('alert', '包装材料名称重复!');
						$(this).combobox('clear');
					}
				}
			}
			
		}
	};

	var MaterialsCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 60,
			hidden: true
		}, {
			title: '包装材料代码',
			field: 'MaterialCode',
			align: 'left',
			width: 150
		}, {
			title: '包装材料',
			field: 'MaterialId',
			align: 'left',
			width: 200,
			formatter: CommonFormatter(GetMaterialsBox, 'MaterialId', 'MaterialDesc'),
			editor: GetMaterialsBox
		}, {
			title: '有效期天数',
			field: 'ExpLength',
			align: 'right',
			width: 100,
			sortable: true,
			editor: { type: 'numberbox', options: { required: true, min: 1 }}
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
			align: 'center',
			width: 100,
			sortable: true,
			editor: { type: 'checkbox', check: 'checked', options: { on: 'Y', off: 'N' }},
			formatter: BoolFormatter
		}
	]];
	var MaterialsGrid = $UI.datagrid('#MatCompare', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.PackageMatCompare',
			QueryName: 'SelectPackageMat'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.PackageMatCompare',
			MethodName: 'jsDelete'
		},
		showAddSaveDelItems: true,
		columns: MaterialsCm,
		checkField: 'MaterialId',
		fitColumns: true,
		pagination: false,
		remoteSort: false,
		sortName: 'MaterialCode',
		sortOrder: 'asc',
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
			if (DefaultCount != 1) {
				$UI.msg('alert', '需设置一个默认包装材料!');
				return;
			}
			var Others = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
			Rows = MaterialsGrid.getChangesData();
			if (isEmpty(Rows)) {
				return;
			}
			if (Rows === false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.PackageInfo.PackageMatCompare',
				MethodName: 'jsSave',
				Parref: gPkgId,
				Params: JSON.stringify(Rows),
				Others: Others
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					MaterialsGrid.reload();
					gFn();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		onClickRow: function(index, row) {
			MaterialsGrid.commonClickRow(index, row);
		}
	});
	$HUI.dialog('#MatCompareWin', {
		onOpen: function() {
			MaterialsGrid.load({
				ClassName: 'web.CSSDHUI.PackageInfo.PackageMatCompare',
				QueryName: 'SelectPackageMat',
				Parref: gPkgId,
				rows: 999
			});
		}
	});
};
$(initFindPkgMaterial);