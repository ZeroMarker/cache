var ItemGrid, UllageGrid;
// �ύ
var CurrId = '';
function submitOrder(mainRowId) {
	if (isEmpty(mainRowId)) {
		$UI.msg('alert', '��ѡ��Ҫ�ύ�ĵ���!');
		return false;
	}
	CurrId = mainRowId;
	$.cm({
		ClassName: 'web.CSSDHUI.CallBack.Ullage',
		MethodName: 'jsSubmitUll',
		mainRowId: mainRowId,
		gUser: gUserId
	}, function(jsonData) {
		if (jsonData.success == 0) {
			$UI.msg('success', jsonData.msg);
			$('#UllageGrid').datagrid('reload');
		} else {
			$UI.msg('error', jsonData.msg);
		}
	});
}
// ����
function cancelOrder(mainRowId) {
	if (isEmpty(mainRowId)) {
		$UI.msg('alert', '��ѡ��Ҫ�����ĵ���!');
		return false;
	}
	if (CallBackParamObj.RequiredCancel == 'Y') {
		$UI.confirm('��ȷ��Ҫִ�г���������', '', '', Cancel, '', '', '', '', mainRowId);
	} else {
		Cancel(mainRowId);
	}
}
function Cancel(mainRowId) {
	CurrId = mainRowId;
	$.cm({
		ClassName: 'web.CSSDHUI.CallBack.Ullage',
		MethodName: 'jsCancelUll',
		mainRowId: mainRowId
	}, function(jsonData) {
		if (jsonData.success == 0) {
			$UI.msg('success', jsonData.msg);
			$('#UllageGrid').datagrid('reload');
		} else {
			$UI.msg('error', jsonData.msg);
		}
	});
}

var init = function() {
	var PhaLocParams = JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: gHospId }));
	$HUI.combobox('#PhaLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PhaLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var PkgParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, TypeDetail: '2' }));
	$HUI.combobox('#Package', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + PkgParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	// ��������
	var LocParams = JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: gHospId }));
	var LocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect: function(record) {
				var rows = UllageGrid.getRows();
				var row = rows[UllageGrid.editIndex];
				row.LocDesc = record.Description;
			}
		}
	};
	var packData = $.cm({
		ClassName: 'web.CSSDHUI.Common.Dicts',
		QueryName: 'GetConsumeReason',
		ResultSetType: 'array',
		Params: JSON.stringify(addSessionParams({ BDPHospital: gHospId }))
	}, false);

	var ReasonBox = {
		type: 'combobox',
		options: {
			data: packData,
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect: function(record) {
				var rows = ItemGrid.getRows();
				var row = rows[ItemGrid.editIndex];
				row.ConsumeReasonName = record.Description;
			}
		}
	};
	var ItemComData = $.cm({
		ClassName: 'web.CSSDHUI.Common.Dicts',
		QueryName: 'GetPackageItem',
		ResultSetType: 'array'
	}, false);
	
	var SelectRow = function(row) {
		var rows = ItemGrid.getRows();
		var rowMain = rows[ItemGrid.editIndex];
		rowMain.ItemDesc = row.ItemDescription;
		rowMain.Spec = row.ItemSpec;
		var index = ItemGrid.getRowIndex(rowMain);
		for (var i = 0; i < rows.length; i++) {
			if (rows[i].ItemDesc == row.ItemDescription && rows[i].Spec == row.ItemSpec && (i != index)) {
				$UI.msg('alert', '��е���ظ�!');
			}
		}
		ItemGrid.updateRow({
			index: ItemGrid.editIndex,
			row: {
				Spec: row.ItemSpec,
				ItemDesc: row.ItemDescription,
				ItemId: row.RowId
			}
		});
		ItemGrid.refreshRow();
	};
	var Params = JSON.stringify($UI.loopBlock('ConsumeItemTB'));
	// ���
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clearBlock('#ConsumeItemTB');
			Default();
			$UI.clear(UllageGrid);
			$UI.clear(ItemGrid);
		}
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			query();
		}
	});

	function query() {
		var Params = JSON.stringify($UI.loopBlock('ConsumeItemTB'));
		$UI.clear(ItemGrid);
		UllageGrid.load({
			ClassName: 'web.CSSDHUI.CallBack.Ullage',
			QueryName: 'GetUllageInfo',
			Params: Params
		});
	}

	var UllageGridCm = [[
		{
			field: 'operate',
			title: '����',
			frozen: true,
			align: 'center',
			width: 100,
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '';
				if (row.ComplateFlag == 'Y') {
					str = '<div class="col-icon icon-back" href="#" title="����" onclick="cancelOrder(' + row.RowId + ')"></div>';
				} else {
					str = str + '<div class="col-icon icon-cancel" href="#"  title="ɾ��" onclick="UllageGrid.commonDeleteRow(true,' + index + ')"></div>'
							+ '<div class="col-icon icon-submit" href="#" title="�ύ" onclick="submitOrder(' + row.RowId + ')"></div>';
				}
				return str;
			}
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '����',
			field: 'No',
			width: 150
		}, {
			title: '����',
			field: 'LocId',
			width: 160,
			formatter: CommonFormatter(LocCombox, 'LocId', 'LocDesc'),
			editor: LocCombox, options: { required: true }
		}, {
			title: '����ʱ��',
			field: 'commitDate',
			width: 160
		}, {
			title: '������Ա',
			field: 'callName',
			width: 100
		}, {
			title: '�Ƿ��ύ',
			field: 'ComplateFlag',
			width: 80,
			formatter: BoolFormatter,
			hidden: true
		}
	]];

	UllageGrid = $UI.datagrid('#UllageGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.CallBack.Ullage',
			QueryName: 'GetUllageInfo',
			Params: Params
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.CallBack.Ullage',
			MethodName: 'jsDelete'
		},
		columns: UllageGridCm,
		remoteSort: false,
		selectOnCheck: false,
		showAddSaveDelItems: true,
		sortName: 'RowId',
		sortOrder: 'desc',
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				var GridListIndex = '';
				if (!isEmpty(CurrId)) {
					var Rows = $('#UllageGrid').datagrid('getRows');
					$.each(Rows, function(index, item) {
						if (item.RowId == CurrId) {
							GridListIndex = index;
							return false;
						}
					});
					CurrId = '';
				} else if (CommParObj.SelectFirstRow == 'Y') {
					GridListIndex = 0;
				}
				if (!isEmpty(GridListIndex)) {
					$('#UllageGrid').datagrid('selectRow', GridListIndex);
				}
			}
		},
		beforeAddFn: function() {
			var LocId = $('#PhaLoc').combobox('getValue');
			var LocDesc = $('#PhaLoc').combobox('getText');
			var DefaultData = { LocId: LocId, LocDesc: LocDesc };
			return DefaultData;
		},
		onSelect: function(index, rowData) {
			var Id = rowData.RowId;
			if (!isEmpty(Id)) {
				ItemDetailById(Id);
			}
		},
		onClickRow: function(index, row) {
			if (row.ComplateFlag == 'Y') {
				return false;
			}
			UllageGrid.commonClickRow(index, row);
		},
		saveDataFn: function() {
			var Rows = UllageGrid.getChangesData();
			if (isEmpty(Rows)) {
				$UI.msg('alert', 'û����Ҫ�������Ϣ�����δ��ı�������Ϣ!');
				return;
			}
			if (Rows == false) {
				$UI.msg('alert', '����δ��д�ı�������ܱ���!');
				return;
			}
			showMask();
			$.cm({
				ClassName: 'web.CSSDHUI.CallBack.Ullage',
				MethodName: 'jsUllageSave',
				User: gUserId,
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					CurrId = jsonData.rowid;
					UllageGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		afterDelFn: function() {
			$UI.clear(ItemGrid);
		}
	});

	var ItemGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '��еDr',
			field: 'ItemId',
			width: 150,
			hidden: true
		}, {
			title: '��е',
			field: 'ItemDesc',
			width: 150,
			editor: PackageItemEditor('', SelectRow)
		}, {
			title: '��е���',
			field: 'Spec',
			width: 80
		}, {
			title: '��������',
			align: 'right',
			field: 'ConsumeQty',
			width: 100,
			editor: { type: 'numberbox', options: { required: true, min: 1 }}
		}, {
			title: '����ԭ��',
			field: 'ConsumeReasonDR',
			width: 200,
			formatter: CommonFormatter(ReasonBox, 'ConsumeReasonDR', 'ConsumeReasonName'),
			editor: ReasonBox
		}
	]];
	ItemGrid = $UI.datagrid('#ItemGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.CallBack.Ullage',
			QueryName: 'GetItemInfo'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.CallBack.Ullage',
			MethodName: 'jsDeleteItem'
		},
		showAddSaveDelItems: true,
		columns: ItemGridCm,
		sortName: 'RowId',
		sortOrder: 'desc',
		fitColumns: true,
		pagination: false,
		checkField: 'ItemId',
		saveDataFn: function() { // ������ϸ
			var Rows = ItemGrid.getChangesData();
			if ((Rows == false) || (isEmpty(Rows))) {
				$UI.msg('alert', 'û����Ҫ�������Ϣ�����δ��ı�������Ϣ!');
				return;
			}
			var Selected = UllageGrid.getSelected();
			var MainRowId = Selected.RowId;
			$.cm({
				ClassName: 'web.CSSDHUI.CallBack.Ullage',
				MethodName: 'jsSaveItem',
				Parref: MainRowId,
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					ItemGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		beforeAddFn: function() {
			var rowMain = $('#UllageGrid').datagrid('getSelected');
			if (isEmpty(rowMain)) {
				$UI.msg('alert', '��ѡ��Ҫ���ӵı��𵥾�!');
				return false;
			}
			if (rowMain.ComplateFlag != 'N') return false;
		},
		beforeDelFn: function() {
			var ItemRowId = '';
			var rowItem = $('#ItemGrid').datagrid('getSelected');
			if (!isEmpty(rowItem)) {
				ItemRowId = rowItem.RowId;
			}
			if (isEmpty(rowItem)) {
				$UI.msg('alert', '��ѡ��Ҫɾ������ϸ!');
				return false;
			}
			var MainObj = $('#UllageGrid').datagrid('getSelected');
			if (!isEmpty(ItemRowId)) {
				if (MainObj.ComplateFlag != 'N') {
					$UI.msg('alert', '�������ύ����ɾ����ϸ!');
					return false;
				}
			}
		},
		onClickRow: function(index, row) {
			ItemGrid.commonClickRow(index, row);
		},
		onBeforeEdit: function() {
			var rowMain = $('#UllageGrid').datagrid('getSelected');
			if (rowMain.ComplateFlag != 'N') return false;
		}
	});

	function ItemDetailById(Id) {
		ItemGrid.load({
			ClassName: 'web.CSSDHUI.CallBack.Ullage',
			QueryName: 'GetItemInfo',
			Parref: Id,
			rows: 999
		});
	}
	var Default = function() {
		// /���ó�ʼֵ ����ʹ������
		$('#PhaLoc').combobox('setValue', gLocObj.RowId);
		$('#FStartDate').datebox('setValue', DateFormatter(new Date()));
		$('#FEndDate').datebox('setValue', DateFormatter(new Date()));
		$('#ClearBT').focus();
	};
	Default();
	query();
};
$(init);