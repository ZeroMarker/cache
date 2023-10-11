// /����: ��������ɹ���˼���ά��
// /����: ��������ɹ���˼���ά��
// /��д�ߣ�zhangxiao
// /��д����: 2018.07.25
var init = function() {
	var HospId = gHospId;
	var TableName = 'CT_Loc';
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
	function Query() {
		var SessionParmas = addSessionParams({ BDPHospital: HospId });
		var Paramsobj = $UI.loopBlock('#LocTB');
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		LocGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCPlanStatusInit',
			QueryName: 'QueryGroupLoc',
			query2JsonStrict: 1,
			Params: Params,
			GroupId: ''
		});
	}
	
	var PlanStatusCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPlanStatus&ResultSetType=Array',
			valueField: 'RowId',
			textField: 'Description',
			// mode: 'remote',
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			},
			onSelect: function(record) {
				var rows = StatusGrpGrid.getRows();
				var row = rows[StatusGrpGrid.editIndex];
				row.PlanStatusDesc = record.Description;
			}
		}
	};
	
	var GroupCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetGroup&ResultSetType=Array',
			valueField: 'RowId',
			textField: 'Description',
			// mode: 'remote',
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			},
			onSelect: function(record) {
				var rows = StatusGrpGrid.getRows();
				var row = rows[StatusGrpGrid.editIndex];
				row.GroupDesc = record.Description;
			}
		}
	};
	
	$('#SearchBT').on('click', function() {
		Query();
	});
	$('#ClearBT').on('click', function() {
		$UI.clearBlock('LocTB');
		$UI.clear(LocGrid);
		$UI.clear(StatusGrpGrid);
	});
	var LocGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '����',
			field: 'Code',
			width: 250
		}, {
			title: '����',
			field: 'Description',
			width: 300
		}
	]];
	var LocGrid = $UI.datagrid('#LocList', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCPlanStatusInit',
			QueryName: 'QueryGroupLoc',
			query2JsonStrict: 1,
			GroupId: ''
		},
		columns: LocGridCm,
		// toolbar: '#LocTB',
		sortName: 'RowId',
		sortOrder: 'Desc',
		onClickRow: function(index, row) {
			var Id = row.RowId;
			if (!isEmpty(Id)) {
				StatusGrp(Id);
			}
			LocGrid.commonClickRow(index, row);
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	var StatusGrpBar = [
		{
			text: '����',
			iconCls: 'icon-add',
			handler: function() {
				var Selected = LocGrid.getSelected();
				if (isEmpty(Selected)) {
					$UI.msg('alert', '��ѡ��Ҫά���Ŀ���!');
					return;
				}
				var PRowId = Selected.RowId;
				if (isEmpty(PRowId)) {
					$UI.msg('alert', '��ѡ��Ҫά���Ŀ���!');
					return;
				}
				StatusGrpGrid.commonAddRow();
			}
		}, {
			text: '����',
			iconCls: 'icon-save',
			handler: function() {
				var Rows = StatusGrpGrid.getChangesData();
				if (Rows === false) {	// δ��ɱ༭����ϸΪ��
					return;
				}
				if (isEmpty(Rows)) {	// ��ϸ����
					$UI.msg('alert', 'û����Ҫ�������ϸ!');
					return;
				}
				var Selected = LocGrid.getSelected();
				var PRowId = Selected.RowId;
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCPlanStatusInit',
					MethodName: 'Save',
					LocId: PRowId,
					Params: JSON.stringify(Rows)
				}, function(jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						StatusGrpGrid.reload();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}, {
			text: 'ɾ��',
			iconCls: 'icon-cancel',
			handler: function() {
				var Rows = StatusGrpGrid.getSelectedData();
				if (isEmpty(Rows)) {
					StatusGrpGrid.commonDeleteRow();
				} else {
					$UI.confirm('ȷ��Ҫɾ����?', '', '', function() {
						$.cm({
							ClassName: 'web.DHCSTMHUI.DHCPlanStatusInit',
							MethodName: 'Delete',
							Params: JSON.stringify(Rows)
						}, function(jsonData) {
							if (jsonData.success == 0) {
								$UI.msg('success', jsonData.msg);
								StatusGrpGrid.reload();
							} else {
								$UI.msg('error', jsonData.msg);
							}
						});
					});
				}
			}
		}
	];
	var StatusGrpGridCm = [[
		{
			title: 'PsiRowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '��˼���',
			field: 'PlanStatusId',
			width: 250,
			formatter: CommonFormatter(PlanStatusCombox, 'PlanStatusId', 'PlanStatusDesc'),
			editor: PlanStatusCombox
		}, {
			title: '��ȫ��',
			field: 'GroupId',
			width: 310,
			formatter: CommonFormatter(GroupCombox, 'GroupId', 'GroupDesc'),
			editor: GroupCombox
			
		}
	]];

	var StatusGrpGrid = $UI.datagrid('#StatusGrpGridList', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCPlanStatusInit',
			MethodName: 'QueryPlanStatus'
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCPlanStatusInit',
			MethodName: 'Delete'
		},
		columns: StatusGrpGridCm,
		toolbar: StatusGrpBar,
		onClickRow: function(index, row) {
			StatusGrpGrid.commonClickRow(index, row);
		}
	});
	function StatusGrp(Id) {
		StatusGrpGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCPlanStatusInit',
			QueryName: 'QueryPlanStatus',
			query2JsonStrict: 1,
			LocId: Id
		});
	}
	InitHosp();
};
$(init);