var init = function() {
	// Grid 列 comboxData
	var UomComData = $.cm({
		ClassName: 'web.DHCSTMHUI.Common.Dicts',
		QueryName: 'GetCTUom',
		ResultSetType: 'array'
	}, false);
	var UomCombox = {
		type: 'combobox',
		options: {
			data: UomComData,
			valueField: 'RowId',
			textField: 'Description'
		}
	};
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var Params = JSON.stringify($UI.loopBlock('UomTB'));
		$UI.clear(UomFacGrid);
		UomGrid.load({
			ClassName: 'web.DHCSTMHUI.CTUOM',
			QueryName: 'SelectAll',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#AddBT', {
		onClick: function() {
			UomGrid.commonAddRow();
		}
	});

	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var Rows = UomGrid.getChangesData();
			if (Rows === false) {	// 未完成编辑或明细为空
				return;
			}
			if (isEmpty(Rows)) {	// 明细不变
				$UI.msg('alert', '没有需要保存的明细!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.CTUOM',
				MethodName: 'Save',
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					UomGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clearBlock('UomTB');
			$UI.clear(UomGrid);
			$UI.clear(UomFacGrid);
		}
	});
	var UomCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '代码',
			field: 'Code',
			width: 300,
			fitColumns: true,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '描述',
			field: 'Description',
			width: 350,
			fitColumns: true,
			editor: { type: 'validatebox', options: { required: true }}
		}
	]];
	
	var UomGrid = $UI.datagrid('#UomList', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.CTUOM',
			QueryName: 'SelectAll',
			query2JsonStrict: 1
		},
		columns: UomCm,
		toolbar: '#UomTB',
		fitColumns: true,
		onClickRow: function(index, row) {
			var Id = row.RowId;
			if (!isEmpty(Id)) {
				UomFac(Id);
			}
			UomGrid.commonClickRow(index, row);
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	var UomFacCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '描述',
			field: 'ToUomId',
			formatter: CommonFormatter(UomCombox, 'ToUomId', 'ToUomDesc'),
			width: 100,
			editor: UomCombox
		}, {
			title: '转换系数',
			field: 'ConFac',
			width: 100,
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: GetFmtNum('FmtQTY')
				}
			}
		},
		{
			title: '激活标志',
			field: 'ActiveFlag',
			width: 100,
			align: 'center',
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }},
			formatter: BoolFormatter
		}
	]];

	var UomFacGrid = $UI.datagrid('#UomFacList', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.CTUOM',
			MethodName: 'SelectConUom'
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.CTUOM',
			MethodName: 'DeleteConFac'
		},
		columns: UomFacCm,
		pagination: false,
		showAddSaveDelItems: true,
		fitColumns: true,
		onClickCell: function(index, field, value) {
			var Row = UomFacGrid.getRows()[index];
			if ((field == 'ToUomId') && (!isEmpty(Row.RowId))) {
				return false;
			}
			UomFacGrid.commonClickCell(index, field);
		},
		beforeAddFn: function() {
			var Selected = UomGrid.getSelected();
			if (isEmpty(Selected)) {
				$UI.msg('alert', '请选中要维护的单位!');
				return;
			}
			var PRowId = Selected.RowId;
			if (isEmpty(PRowId)) {
				$UI.msg('alert', '请先保存要维护的单位!');
				return;
			}
		},
		saveDataFn: function() {
			var Rows = UomFacGrid.getChangesData();
			var Selected = UomGrid.getSelected();
			var PRowId = Selected.RowId;
			if (Rows === false) {	// 未完成编辑或明细为空
				return;
			}
			if (isEmpty(Rows)) {	// 明细不变
				$UI.msg('alert', '没有需要保存的明细!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.CTUOM',
				MethodName: 'SaveConFac',
				FrUom: PRowId,
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					UomFacGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	function UomFac(Id) {
		UomFacGrid.load({
			ClassName: 'web.DHCSTMHUI.CTUOM',
			MethodName: 'SelectConUom',
			FrUomId: Id
		});
	}
	Query();
};
$(init);