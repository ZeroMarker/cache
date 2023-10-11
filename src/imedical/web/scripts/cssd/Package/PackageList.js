// 消毒包维护界面js
var MainGrid, ItemListGrid;
function GetPkgMat(PkgId) {
	FindPkgMaterial(PkgId, queryMain);
}
function EditDetail(RowId, HospId) {
	AddPkgWin(RowId, HospId, queryMain);
}

function queryMain() {
	$('#PackageList').datagrid('reload');
}

// 明细向上移动
function UpItem(ItemId, sort) {
	$.cm({
		ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
		MethodName: 'UpItem',
		ItemId: ItemId,
		sort: sort
	}, function(jsonData) {
		if (jsonData.success !== 0) {
			$UI.msg('error', jsonData.msg);
		} else {
			$('#ItemList').datagrid('reload');
		}
	});
}
// 明细向下移动
function DownItem(ItemId, sort) {
	$.cm({
		ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
		MethodName: 'DownItem',
		ItemId: ItemId,
		sort: sort
	}, function(jsonData) {
		if (jsonData.success !== 0) {
			$UI.msg('error', jsonData.msg);
		} else {
			$('#ItemList').datagrid('reload');
		}
	});
}

var init = function() {
	var HospId = gHospId;
	var TableName = 'CSSD_Package';
	function InitHosp() {
		var hospComp = InitHospCombo(TableName, gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			QueryPkgInfo();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				QueryPkgInfo();
			};
		} else {
			QueryPkgInfo();
		}
	}
	$('#FPackType').combobox('setValue', '');
	$('#FAttributeId').combobox('setValue', '');
	// /===========================初始化条件======================
	var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
	$HUI.combobox('#FLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + Params,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	$HUI.combobox('#FAttributeId', {
		valueField: 'RowId',
		textField: 'Description',
		data: PackTypeMData
	});

	$HUI.combobox('#FNotUse', {
		valueField: 'RowId',
		textField: 'Description',
		data: NotUseData,
		onLoadSuccess: function(data) {
			$('#FNotUse').combobox('setValue', 'Y');
		}
	});
	var PkgClassParams = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
	$HUI.combobox('#FPkgClassId', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackageClass&ResultSetType=array&Params=' + PkgClassParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	var SterTypeParams = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
	$HUI.combobox('#FSterTypeId', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetSterType&ResultSetType=array&Params=' + SterTypeParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			QueryPkgInfo();
		}
	});
	function QueryPkgInfo(PkgId) {
		$UI.clear(ItemListGrid);
		var OthersParams = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		var ParamsObj = $UI.loopBlock('#Conditions');
		if (!isEmpty(PkgId)) {
			ParamsObj.PkgId = PkgId;
		}
		ParamsObj.ContainerFlag = 'N';
		var QueryParams = JSON.stringify(ParamsObj);
		MainGrid.load({
			ClassName: 'web.CSSDHUI.PackageInfo.Package',
			QueryName: 'QueryPkgInfo',
			Params: QueryParams,
			Others: OthersParams
		});
	}
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			ClearPkgInfo();
		}
	});
	function ClearPkgInfo() {
		$UI.clearBlock('#Conditions');
		$UI.clear(MainGrid);
		$UI.clear(ItemListGrid);
	}
	// 复制按钮
	function Copy() {
		var PkgRow = $('#PackageList').datagrid('getSelected');
		if (isEmpty(PkgRow)) {
			$UI.msg('alert', '请选择要复制的消毒包!');
			return false;
		}
		var PkgId = PkgRow.RowId;
		$UI.confirm('您确定要执行复制操作吗', '', '', CopyPkgInfo, '', '', '', '', PkgId);
	}
	function CopyPkgInfo(PkgId) {
		$.cm({
			ClassName: 'web.CSSDHUI.PackageInfo.Package',
			MethodName: 'JsCopyPackage',
			PkgId: PkgId
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				QueryPkgInfo(jsonData.rowid);
			} else {
				$UI.msg('alert', jsonData.msg);
			}
		});
	}
	// 拍照
	$UI.linkbutton('#CertTakePhotoBT', {
		onClick: function() {
			var Row = MainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要拍照上传图片的消毒包!');
				return;
			}
			var PkgRowId = Row.RowId;
			TakePhotoWin('Pkg', PkgRowId, 'Pkg', 'Pkg', PkgRowId, '');
		}
	});
	
	$UI.linkbutton('#ViewPicBT', { // 浏览图片
		onClick: function() {
			var Row = MainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要预览图片的消毒包!');
				return;
			}
			var PkgId = Row.RowId;
			ViewPic(PkgId);
		}
	});
	// 另存明细按钮
	function ItemSave() {
		var MainRow = MainGrid.getSelected();
		var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		if (isEmpty(MainRow)) {
			$UI.msg('alert', '请选择需要添加明细的消毒包!');
			return;
		}
		var PkgId = MainRow.RowId;
		SelReq(PkgId, Others);
	}
	// 打印代码
	function PrintCode() {
		var Detail = MainGrid.getSelections();
		if (isEmpty(Detail)) {
			$UI.msg('alert', '请选择要打印的数据!');
			return;
		}
		if (!isEmpty(Detail)) {
			$.each(Detail, function(index, item) {
				printCodeDict(item.PkgCode, item.PkgDesc, item.SterTypeDesc, '');
			});
		}
	}
	
	$UI.linkbutton('#QueryLogBT', {
		onClick: function() {
			var Row = MainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择消毒包!');
				return;
			}
			var PackageId = Row.RowId;
			Common_GetLog('User.CSSDPackage', PackageId);
		}
	});
	
	$('#BioFlag').keywords({
		singleSelect: true,
		items: [
			{ text: '全部', id: '' }, { text: '是', id: 'Y' }, { text: '否', id: 'N' }
		]
	});
	$('#ExtFlag').keywords({
		singleSelect: true,
		items: [
			{ text: '全部', id: '' }, { text: '是', id: 'Y' }, { text: '否', id: 'N' }
		]
	});
	
	var MainCm = [[
		{
			field: 'operate',
			title: '操作',
			frozen: true,
			align: 'center',
			width: 100,
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '<div class="col-icon icon-cancel" href="#" title="删除" onclick="MainGrid.commonDeleteRow(true,' + index + ');"></div>'
						+ '<div class="col-icon icon-paper-info" href="#" title="包装材料" onclick="GetPkgMat(' + row.RowId + ')"></div>'
						+ '<div class="col-icon icon-write-order" href="#" title="编辑" onclick="EditDetail(' + row.RowId + ',' + HospId + ')"></div>';
				return str;
			}
		}, {
			title: 'RowId',
			field: 'RowId',
			align: 'left',
			width: 100,
			hidden: true
		}, {
			title: '代码',
			field: 'PkgCode',
			align: 'left',
			width: 50,
			sortable: true
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			align: 'left',
			width: 200,
			sortable: true
		}, {
			title: '别名',
			field: 'PkgAlias',
			align: 'left',
			width: 100,
			sortable: true
		}, {
			title: '规格',
			field: 'SpecDesc',
			align: 'left',
			width: 80,
			sortable: true
		}, {
			title: '包属性',
			field: 'AttributeId',
			align: 'left',
			width: 100,
			sortable: true,
			hidden: true
		}, {
			title: '包属性',
			field: 'AttributeDesc',
			align: 'left',
			width: 100,
			sortable: true
		}, {
			title: '消毒包分类',
			field: 'PkgClassDesc',
			align: 'left',
			width: 100,
			sortable: true
		}, {
			title: '包装材料',
			field: 'MaterialId',
			align: 'left',
			width: 100,
			sortable: true,
			hidden: true
		}, {
			title: '包装材料',
			field: 'MaterialDesc',
			align: 'left',
			width: 100,
			sortable: true
		}, {
			title: '单价',
			field: 'Price',
			align: 'right',
			width: 100,
			sortable: true
		}, {
			title: '有效期',
			field: 'Length',
			align: 'right',
			width: 100,
			sortable: true
		}, {
			title: '灭菌方式',
			field: 'SterTypeDesc',
			width: 100,
			align: 'left',
			sortable: true
		}, {
			title: '单位',
			field: 'UomDesc',
			align: 'left',
			width: 100,
			sortable: true
		}, {
			title: '最大使用次数',
			field: 'WorkTimes',
			align: 'right',
			width: 100,
			sortable: true
		}, {
			title: '科室',
			field: 'LocDesc',
			align: 'left',
			width: 100,
			sortable: true
		}, {
			title: '厂商',
			field: 'FirmDesc',
			align: 'left',
			width: 100,
			sortable: true
		}, {
			title: '是否启用生物监测',
			field: 'NotBioFlag',
			width: 100,
			align: 'center',
			sortable: true,
			formatter: BoolFormatter
		}, {
			title: '是否可用',
			field: 'NotUseFlag',
			width: 100,
			align: 'center',
			sortable: true,
			formatter: BoolFormatter
		}, {
			title: '是否外来器械',
			field: 'IsExt',
			width: 100,
			align: 'center',
			sortable: true,
			formatter: BoolFormatter
		}, {
			title: '备注',
			field: 'Remark',
			align: 'left',
			width: 100,
			sortable: true
		}, {
			title: '器械总数',
			field: 'ItmQty',
			align: 'right',
			width: 80,
			tipWidth: 120,
			showTipFormatter: function(row, rowIndex) {
				return "<span style='display:block;'>注意:器械明细不为空则为器械明细数量之和" + '</span>';
			}
		}
	]];

	MainGrid = $UI.datagrid('#PackageList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.Package',
			QueryName: 'QueryPkgInfo'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.Package',
			MethodName: 'jsDeletePkg'
		},
		columns: MainCm,
		checkField: 'PkgDesc',
		showBar: true,
		toolbar: [
			{
				text: '新增',
				iconCls: 'icon-add',
				handler: function() {
					AddPkgWin('', HospId, QueryPkgInfo);
				}
			}, {
				text: '复制',
				iconCls: 'icon-copy',
				handler: function() {
					Copy();
				}
			}, {
				text: '另存明细',
				iconCls: 'icon-move',
				handler: function() {
					ItemSave();
				}
			}, {
				text: '打印代码',
				iconCls: 'icon-print',
				handler: function() {
					PrintCode();
				}
			}
		],
		singleSelect: true,
		onSelect: function(index, rowData) {
			var PkgId = rowData.RowId;
			if (!isEmpty(PkgId)) {
				FindItemByF(PkgId);
			}
		},
		onLoadSuccess: function(data) {
			$UI.clear(ItemListGrid);
			if (data.rows.length > 0) {
				$('#PackageList').datagrid('selectRow', 0);
			}
		},
		onBeforeLoad: function(param) {
			param.Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		},
		onDblClickRow: function(index, row) {
			var RowId = row.RowId;
			if (!isEmpty(RowId)) {
				EditDetail(RowId, HospId);
			}
		}
	});

	var SelectRow = function(row) {
		var rows = ItemListGrid.getRows();
		var rowMain = rows[ItemListGrid.editIndex];
		rowMain.ItmDesc = row.ItemDescription;
		rowMain.ItmSpec = row.ItemSpec;
		var index = ItemListGrid.getRowIndex(rowMain);
		for (var i = 0; i < rows.length; i++) {
			if (rows[i].ItmDesc === row.ItemDescription && rows[i].ItmSpec === row.ItemSpec && (i !== index)) {
				$UI.msg('alert', '器械名重复!');
				$(this).combobox('clear');
			}
		}
		ItemListGrid.updateRow({
			index: ItemListGrid.editIndex,
			row: {
				ItmSpec: row.ItemSpec,
				ItmDesc: row.ItemDescription,
				ItmId: row.RowId
			}
		});
		ItemListGrid.refreshRow();
	};
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
			width: 100,
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '';
				if (row.ItmDesc === '合计') {
					return '';
				} else {
					str = '<div class="col-icon icon-cancel" href="#" title="删除" onclick="ItemListGrid.commonDeleteRow(false,' + index + ');"></div>'
						+ '<div class="col-icon icon-top-green" href="#" title="上移" onclick="UpItem(' + row.RowId + ',' + row.SerialNo + ')"></div>'
						+ '<div class="col-icon icon-down-blue" href="#" title="下移" onclick="DownItem(' + row.RowId + ',' + row.SerialNo + ')"></div>';
					return str;
				}
			}
		}, {
			title: '序号',
			field: 'SerialNo',
			align: 'right',
			width: 40
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '器械Id',
			field: 'ItmId',
			width: 150,
			hidden: true
		}, {
			title: '器械',
			field: 'ItmDesc',
			width: 150,
			editor: PackageItemEditor('', SelectRow, gLocId)
		}, {
			title: '数量',
			field: 'Qty',
			align: 'right',
			width: 40,
			editor: { type: 'numberbox', options: { required: true, min: 1 }}
		}, {
			title: '器械规格',
			field: 'ItmSpec',
			width: 100
		}, {
			title: '是否启用',
			field: 'UseFlagDesc',
			align: 'center',
			width: 80
		}
	]];

	ItemListGrid = $UI.datagrid('#ItemList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
			QueryName: 'SelectByF',
			rows: 99999
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
			MethodName: 'jsDelete'
		},
		columns: ItemCm,
		pagination: false,
		showFooter: true,
		singleSelect: false,
		checkField: 'ItmDesc',
		showAddSaveItems: true,
		saveDataFn: function() { // 保存明细
			var Rows = ItemListGrid.getChangesData();
			if (isEmpty(Rows)) {
				return;
			}
			if (Rows === false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			var PkgObj = MainGrid.getSelected();
			var PkgId = PkgObj.RowId;
			$.cm({
				ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
				MethodName: 'jsAddPkgItm',
				PkgId: PkgId,
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				$UI.msg('success', jsonData.msg);
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					ItemListGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		beforeAddFn: function() {
			var RowMain = $('#PackageList').datagrid('getSelected');
			if (isEmpty(RowMain)) {
				$UI.msg('alert', '请选择消毒包再添加明细!');
				return false;
			}
			var AttributeId = RowMain.AttributeId;
			if ((AttributeId === '3') || ((AttributeId === '6'))) {
				$UI.msg('alert', '当前数据不允许维护明细!');
				return false;
			}
		},
		onClickRow: function(index, row) {
			ItemListGrid.commonClickRow(index, row);
		}
	});
	function FindItemByF(PkgId) {
		ItemListGrid.load({
			ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
			QueryName: 'SelectByF',
			PkgId: PkgId,
			rows: 99999,
			totalFooter: '"ItmDesc":"合计"',
			totalFields: 'Qty'
		});
	}
	InitHosp();
};
$(init);