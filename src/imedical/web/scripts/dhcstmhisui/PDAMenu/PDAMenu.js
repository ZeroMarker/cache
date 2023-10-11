// /��������ά��
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
				{ RowId: 'INRequestMenu', Description: '����' },
				{ RowId: 'INReqByCodeMenu', Description: 'ɨ������' },
				{ RowId: 'RecAcceptMenu', Description: '����' },
				{ RowId: 'INGdRecMenu', Description: '���' },
				{ RowId: 'INIsTrfMenu', Description: '����' },
				{ RowId: 'INGdRecSCIMenu', Description: 'SCI���' },
				{ RowId: 'INStkTkMenu', Description: '�̵�' },
				{ RowId: 'StockQueryMenu', Description: '��ѯ���' }
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
				{RowId: 'INReqMenu', Description: '����'},
				{RowId: 'RecAcceptMenu', Description: '����'},
				{RowId: 'INGdRecSCIMenu', Description: '���'},
				{RowId: 'INIsTrfSCIMenu', Description: '����'},
				{RowId: 'InitAckInMenu', Description: '�������'},
				{RowId: 'INStkTkMenu', Description: '�̵�'},
				{RowId: 'StockQueryMenu', Description: '��ѯ���'}
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
			title: '����',
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
		text: '����',
		iconCls: 'icon-add',
		handler: function() {
			var Selected = GroupGrid.getSelected();
			if (isEmpty(Selected)) {
				$UI.msg('alert', '��ѡ��Ҫά���İ�ȫ��!');
				return;
			}
			var PRowId = Selected.RowId;
			if (isEmpty(PRowId)) {
				$UI.msg('alert', '��ѡ��Ҫά���İ�ȫ��!');
				return;
			}
			PDAMenuGrid.commonAddRow();
		}
	}, {
		text: '����',
		iconCls: 'icon-save',
		handler: function() {
			var Rows = PDAMenuGrid.getChangesData();
			if (Rows === false) {	// δ��ɱ༭����ϸΪ��
				return;
			}
			if (isEmpty(Rows)) {	// ��ϸ����
				$UI.msg('alert', 'û����Ҫ�������ϸ!');
				return;
			}
			var Selected = GroupGrid.getSelected();
			var PRowId = Selected.RowId;
			if (isEmpty(PRowId)) {
				$UI.msg('alert', '��ѡ��Ҫά���İ�ȫ��!');
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
		text: 'ɾ��',
		iconCls: 'icon-cancel',
		handler: function() {
			var Rows = PDAMenuGrid.getSelectedData();
			if (isEmpty(Rows)) {
				$UI.msg('alert', '��ѡ����Ҫɾ���Ŀ�����Ϣ!');
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
			title: '����',
			field: 'XSCode',
			width: 250
		}, {
			title: '����',
			field: 'Code',
			width: 250,
			formatter: CommonFormatter(PDAMenuCombo, 'Code', 'Desc'),
			editor: PDAMenuCombo
		}, {
			title: '�Ƿ񼤻�',
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