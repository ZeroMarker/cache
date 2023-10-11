// /下属科室维护
var init = function() {
	var HospId = gHospId;
	var TableName = 'CT_Loc';
	function InitHosp() {
		var hospComp = InitHospCombo(TableName, gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				QueryGroupLoc();
			};
		}
		QueryGroupLoc();
	}
	var LocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array',
			valueField: 'RowId',
			textField: 'Description',
			// mode: 'remote',
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: HospId }));
			},
			onSelect: function(record) {
				var rows = DeflocGrpGrid.getRows();
				var row = rows[DeflocGrpGrid.editIndex];
				row.CtDesc = record.Description;
			}
		}
	};
	function QueryGroupLoc() {
		var SessionParmas = addSessionParams({ BDPHospital: HospId });
		var Paramsobj = $UI.loopBlock('LocTB');
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		$UI.clear(DeflocGrpGrid);
		$UI.clear(LocGrid);
		LocGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCPlanStatusInit',
			QueryName: 'QueryGroupLoc',
			query2JsonStrict: 1,
			Params: Params
			// GroupId:gGroupId
		});
	}
	$('#SearchBT').on('click', function() {
		QueryGroupLoc();
	});
	function clear() {
		$UI.clearBlock('LocTB');
		$UI.clear(LocGrid);
		$UI.clear(DeflocGrpGrid);
		InitHosp();
	}
	$('#ClearBT').on('click', function() {
		clear();
	});
	var LocGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '代码',
			field: 'Code',
			width: 200
		}, {
			title: '名称',
			field: 'Description',
			width: 325
		}
	]];
	var SessionParmas = addSessionParams({ Hospital: HospId });
	var Paramsobj = $UI.loopBlock('LocTB');
	var Params1 = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
	var LocGrid = $UI.datagrid('#LocList', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCPlanStatusInit',
			QueryName: 'QueryGroupLoc',
			query2JsonStrict: 1,
			Params: Params1
			// GroupId:gGroupId
		},
		columns: LocGridCm,
		// toolbar: '#LocTB',
		sortName: 'RowId',
		sortOrder: 'Desc',
		onClickRow: function(index, row) {
			var Id = row.RowId;
			if (!isEmpty(Id)) {
				DeflocGrp(Id);
			}
			LocGrid.commonClickRow(index, row);
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	var DefLocGrpBar = [
		{
			text: '增加',
			iconCls: 'icon-add',
			handler: function() {
				var Selected = LocGrid.getSelected();
				if (isEmpty(Selected)) {
					$UI.msg('alert', '请选中要维护的科室!');
					return;
				}
				var PRowId = Selected.RowId;
				if (isEmpty(PRowId)) {
					$UI.msg('alert', '请选中要维护的科室!');
					return;
				}
				DeflocGrpGrid.commonAddRow();
			}
		}, {
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				var Rows = DeflocGrpGrid.getChangesData();
				if (Rows === false) {	// 未完成编辑或明细为空
					return;
				}
				if (isEmpty(Rows)) {	// 明细不变
					$UI.msg('alert', '没有需要保存的明细!');
					return;
				}
				for (var i = 0; i < Rows.length; i++) {
					if (isEmpty(Rows[i].CtRowId)) {
						$UI.msg('alert', '请选择科室描述信息!');
						return;
					}
				}
				var Selected = LocGrid.getSelected();
				var PRowId = Selected.RowId;
				$.cm({
					ClassName: 'web.DHCSTMHUI.DefLoc',
					MethodName: 'Save',
					LocId: PRowId,
					Params: JSON.stringify(Rows)
				}, function(jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						DeflocGrpGrid.reload();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}, {
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function() {
				var Rows = DeflocGrpGrid.getSelectedData();
				if (isEmpty(Rows)) {
					$UI.msg('alert', '请选择需要删除的科室信息!');
					return;
				}
				$UI.confirm('确定要删除吗?', '', '', function() {
					$.cm({
						ClassName: 'web.DHCSTMHUI.DefLoc',
						MethodName: 'Delete',
						Params: JSON.stringify(Rows)
					}, function(jsonData) {
						if (jsonData.success == 0) {
							$UI.msg('success', jsonData.msg);
							DeflocGrpGrid.reload();
						} else {
							$UI.msg('error', jsonData.msg);
						}
					});
				});
			}
		}
	];
	var DeflocGrpGridCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'Rowid',
			field: 'Rowid',
			hidden: true,
			width: 60
		}, {
			title: '代码',
			field: 'CtCode',
			width: 220
		}, {
			title: '描述',
			field: 'CtRowId',
			width: 250,
			formatter: CommonFormatter(LocCombox, 'CtRowId', 'CtDesc'),
			editor: LocCombox
		}, {
			title: '使用标志',
			field: 'UseFlag',
			hidden: true,
			width: 60
		}
	]];
	var DeflocGrpGrid = $UI.datagrid('#DeflocGrpGridList', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DefLoc',
			MethodName: 'QueryDefLoc'
		},
		columns: DeflocGrpGridCm,
		fitColumns: true,
		toolbar: DefLocGrpBar,
		onClickRow: function(index, row) {
			DeflocGrpGrid.commonClickRow(index, row);
		}
	});
	function DeflocGrp(Id) {
		DeflocGrpGrid.load({
			ClassName: 'web.DHCSTMHUI.DefLoc',
			QueryName: 'QueryDefLoc',
			query2JsonStrict: 1,
			LocId: Id
		});
	}
	clear();
};
$(init);