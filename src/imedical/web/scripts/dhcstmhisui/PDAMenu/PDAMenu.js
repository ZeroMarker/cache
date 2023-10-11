// /下属科室维护
var init = function() {
	var HospId = gHospId;
	var TableName = 'SS_Group';
	function InitHosp() {
		var hospComp = InitHospCombo(TableName, gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			QueryGroup();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				QueryGroup();
			};
		}
	}
	var PDAMenuCombo = {
		type: 'combobox',
		options: {
			data: [
				{ RowId: 'INRequestMenu', Description: '申请' },
				{ RowId: 'INReqByCodeMenu', Description: '扫码申请' },
				{ RowId: 'RecAcceptMenu', Description: '验收' },
				{ RowId: 'INGdRecMenu', Description: '入库' },
				{ RowId: 'INIsTrfMenu', Description: '出库' },
				{ RowId: 'INGdRecSCIMenu', Description: 'SCI入库' },
				{ RowId: 'INStkTkMenu', Description: '盘点' },
				{ RowId: 'StockQueryMenu', Description: '查询库存' }
			],
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = PDAMenuGrid.getRows();
				var row = rows[PDAMenuGrid.editIndex];
				row.Desc = record.Description;
			}
		}
	};/*
	var PDAMenuCombo = {
		type: 'combobox',
		options: {
			mode: 'local',
			valueField: 'RowId',
			textField: 'Description',
			data: [
				{RowId: 'INReqMenu', Description: '申请'},
				{RowId: 'RecAcceptMenu', Description: '验收'},
				{RowId: 'INGdRecSCIMenu', Description: '入库'},
				{RowId: 'INIsTrfSCIMenu', Description: '出库'},
				{RowId: 'InitAckInMenu', Description: '出库接收'},
				{RowId: 'INStkTkMenu', Description: '盘点'},
				{RowId: 'StockQueryMenu', Description: '查询库存'}
			]
		}
	};*/
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
				var rows = PDAMenuGrid.getRows();
				var row = rows[PDAMenuGrid.editIndex];
				row.CtDesc = record.Description;
			}
		}
	};
	function QueryGroup() {
		var SessionParmas = addSessionParams({ BDPHospital: HospId });
		var Paramsobj = $UI.loopBlock('GroupCondition');
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		$UI.clear(PDAMenuGrid);
		$UI.clear(GroupGrid);
		GroupGrid.load({
			ClassName: 'web.DHCSTMHUI.PDAMenu',
			QueryName: 'GetGroup',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$('#SearchBT').on('click', function() {
		QueryGroup();
	});
	function clear() {
		$UI.clearBlock('GroupCondition');
		$UI.clear(GroupGrid);
		$UI.clear(PDAMenuGrid);
		InitHosp();
	}
	$('#ClearBT').on('click', function() {
		clear();
	});
	var GroupCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '名称',
			field: 'Description',
			width: 200
		}
	]];
	var SessionParmas = addSessionParams({ Hospital: HospId });
	var Paramsobj = $UI.loopBlock('GroupCondition');
	var Params1 = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
	var GroupGrid = $UI.datagrid('#GroupGrid', {
		lazy: false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.PDAMenu',
			QueryName: 'GetGroup',
			query2JsonStrict: 1,
			Params: Params1
		},
		columns: GroupCm,
		sortName: 'RowId',
		sortOrder: 'Desc',
		onClickCell: function(index, filed, value) {
			var Row = GroupGrid.getRows()[index];
			var Id = Row.RowId;
			if (!isEmpty(Id)) {
				DeflocGrp(Id);
			}
			GroupGrid.commonClickCell(index, filed);
		}
	});
	var PDAMenuBar = [{
		text: '增加',
		iconCls: 'icon-add',
		handler: function() {
			var Selected = GroupGrid.getSelected();
			if (isEmpty(Selected)) {
				$UI.msg('alert', '请选中要维护的安全组!');
				return;
			}
			var PRowId = Selected.RowId;
			if (isEmpty(PRowId)) {
				$UI.msg('alert', '请选中要维护的安全组!');
				return;
			}
			PDAMenuGrid.commonAddRow();
		}
	}, {
		text: '保存',
		iconCls: 'icon-save',
		handler: function() {
			var Rows = PDAMenuGrid.getChangesData();
			if (Rows === false) {	// 未完成编辑或明细为空
				return;
			}
			if (isEmpty(Rows)) {	// 明细不变
				$UI.msg('alert', '没有需要保存的明细!');
				return;
			}
			var Selected = GroupGrid.getSelected();
			var PRowId = Selected.RowId;
			if (isEmpty(PRowId)) {
				$UI.msg('alert', '请选中要维护的安全组!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.PDAMenu',
				MethodName: 'Save',
				GroupId: PRowId,
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					PDAMenuGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	}, {
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			var Rows = PDAMenuGrid.getSelectedData();
			if (isEmpty(Rows)) {
				$UI.msg('alert', '请选择需要删除的科室信息!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.PDAMenu',
				MethodName: 'Delete',
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					PDAMenuGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	}
	];
	var PDAMenuGridCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'Rowid',
			field: 'Rowid',
			hidden: true
		}, {
			title: '代码',
			field: 'XSCode',
			width: 250
		}, {
			title: '描述',
			field: 'Code',
			width: 250,
			formatter: CommonFormatter(PDAMenuCombo, 'Code', 'Desc'),
			editor: PDAMenuCombo
		}, {
			title: '是否激活',
			field: 'Active',
			width: 100,
			align: 'center',
			formatter: BoolFormatter,
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }}
		}
	]];
	var PDAMenuGrid = $UI.datagrid('#PDAMenuGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.PDAMenu',
			MethodName: 'Query'
		},
		columns: PDAMenuGridCm,
		toolbar: PDAMenuBar,
		onClickRow: function(index, row) {
			PDAMenuGrid.commonClickRow(index, row);
		}
	});
	function DeflocGrp(Id) {
		PDAMenuGrid.load({
			ClassName: 'web.DHCSTMHUI.PDAMenu',
			QueryName: 'Query',
			query2JsonStrict: 1,
			GroupId: Id
		});
	}
	clear();
};
$(init);