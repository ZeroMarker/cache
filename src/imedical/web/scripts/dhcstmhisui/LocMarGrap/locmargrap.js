var init = function() {
	var HospId = gHospId;
	function InitHosp() {
		var hospComp = InitHospCombo('CT_Loc', gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				$UI.clearBlock('LocMarTB');
				QueryLocM();
			};
		}
		QueryLocM();
	}
	function QueryLocM() {
		var SessionParmas = addSessionParams({ Hospital: HospId });
		var Paramsobj = $UI.loopBlock('LocMarTB');
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		LocMarGrid.load({
			ClassName: 'web.DHCSTMHUI.CTLOC',
			QueryName: 'QueryLocM',
			query2JsonStrict: 1,
			StrFilter: Params
		});
	}
	$('#SearchBT').on('click', function() {
		QueryLocM();
	});
	function clear() {
		$UI.clearBlock('LocMarTB');
		$UI.clear(LocMarGrid);
		$UI.clear(LocMarGrpGrid);
		InitHosp();
	}
	$('#ClearBT').on('click', function() {
		clear();
	});
	var LocMarGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '代码',
			field: 'Code',
			width: 300
		}, {
			title: '名称',
			field: 'Description',
			width: 275
		}
	]];
	var SessionParmas = addSessionParams({ Hospital: HospId });
	var Paramsobj = $UI.loopBlock('LocMarTB');
	var Params1 = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
	var LocMarGrid = $UI.datagrid('#LocMarList', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.CTLOC',
			QueryName: 'QueryLocM',
			query2JsonStrict: 1,
			StrFilter: Params1
		},
		columns: LocMarGridCm,
		// toolbar: '#LocMarTB',
		sortName: 'RowId',
		sortOrder: 'Desc',
		onSelect: function(index, row) {
			var LocId = row.RowId;
			LocMarGrpGrid.load({
				ClassName: 'web.DHCSTMHUI.LocManGrp',
				QueryName: 'QueryLocMar',
				query2JsonStrict: 1,
				LocId: LocId
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	var LocMarGrpBar = [
		{
			text: '新增',
			class: 'hisui-linkbutton',
			iconCls: 'icon-add',
			handler: function() {
				var Selected = LocMarGrid.getSelected();
				if (isEmpty(Selected)) {
					$UI.msg('alert', '请选中要维护的科室!');
					return;
				}
				var PRowId = Selected.RowId;
				if (isEmpty(PRowId)) {
					$UI.msg('alert', '请选中要维护的科室!');
					return;
				}
				LocMarGrpGrid.commonAddRow();
			}
		}, {
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				var Rows = LocMarGrpGrid.getChangesData();
				if (Rows === false) {	// 未完成编辑或明细为空
					return;
				}
				if (isEmpty(Rows)) {	// 明细不变
					$UI.msg('alert', '没有需要保存的明细!');
					return;
				}
				var Selected = LocMarGrid.getSelected();
				var PRowId = Selected.RowId;
				$.cm({
					ClassName: 'web.DHCSTMHUI.LocManGrp',
					MethodName: 'Save',
					LocId: PRowId,
					Params: JSON.stringify(Rows)
				}, function(jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						LocMarGrpGrid.reload();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}, {
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function() {
				var Rows = LocMarGrpGrid.getSelections();
				if (Rows.length <= 0) {
					$UI.msg('alert', '请选择要删除的信息!');
					return;
				}
				$UI.confirm('确定要删除吗?', '', '', function() {
					$.cm({
						ClassName: 'web.DHCSTMHUI.LocManGrp',
						MethodName: 'Delete',
						Params: JSON.stringify(Rows)
					}, function(jsonData) {
						if (jsonData.success == 0) {
							$UI.msg('success', jsonData.msg);
							LocMarGrpGrid.reload();
						} else {
							$UI.msg('error', jsonData.msg);
						}
					});
				});
			}
		}
	];
	var LocMarGrpGridCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '代码',
			field: 'Code',
			width: 200,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '描述',
			field: 'Desc',
			width: 350,
			editor: { type: 'validatebox', options: { required: true }}
		}
	]];
	var LocMarGrpGrid = $UI.datagrid('#LocMarGrpGridList', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocManGrp',
			MethodName: 'QueryLocMar'
		},
		columns: LocMarGrpGridCm,
		toolbar: LocMarGrpBar,
		singleSelect: false,
		onClickRow: function(index, row) {
			LocMarGrpGrid.commonClickRow(index, row);
		}
	});
	clear();
};
$(init);