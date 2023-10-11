var init = function() {
	var HospId = gHospId;
	function InitHosp() {
		var hospComp = InitHospCombo('CT_Loc', gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				ReloadBT();
			};
		}
		ReloadBT();
	}
	var OperLocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			// mode: 'remote',
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: HospId }));
			},
			onSelect: function(record) {
				var rows = PerMLocGrid.getRows();
				var row = rows[PerMLocGrid.editIndex];
				row.OperLocDesc = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	var UserCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			tipPosition: 'bottom',
			// mode: 'remote',
			onBeforeLoad: function(param) {
				var Selected = PerMLocGrid.getSelected();
				if (!isEmpty(Selected)) {
					param.Params = JSON.stringify({
						LocDr: Selected.OperLocId
					});
				}
			},
			onSelect: function(record) {
				var rows = PerLocUserGrid.getRows();
				var row = rows[PerLocUserGrid.editIndex];
				row.User = record.Description;
				var index = PerLocUserGrid.getRowIndex(row);
				for (var i = 0; i < rows.length - 1; i++) {
					if (rows[i].User == record.Description && (i != index)) {
						$UI.msg('alert', '人员重复!');
						$(this).combobox('clear');
					}
				}
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	function ReloadBT() {
		var Params = JSON.stringify(addSessionParams({ Hospital: HospId }));
		$UI.clear(PerMLocGrid);
		$UI.clear(PerLocUserGrid);
		PerMLocGrid.load({
			ClassName: 'web.DHCSTMHUI.HVUsePermissonLoc',
			QueryName: 'selectAll',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	var PerMLocTB = [
		{
			text: '刷新',
			iconCls: 'icon-reload',
			handler: function() {
				ReloadBT();
			}
		}, {
			text: '新增',
			iconCls: 'icon-add',
			handler: function() {
				PerMLocGrid.commonAddRow();
			}
		}, {
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				var Rows = PerMLocGrid.getChangesData();
				if (Rows === false) {	// 未完成编辑或明细为空
					return;
				}
				if (isEmpty(Rows)) {	// 明细不变
					$UI.msg('alert', '没有需要保存的明细!');
					return;
				}
				$.cm({
					ClassName: 'web.DHCSTMHUI.HVUsePermissonLoc',
					MethodName: 'SavePerMLoc',
					Params: JSON.stringify(Rows),
					DOuser: gUserId
				}, function(jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						PerMLocGrid.reload();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}, {
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function() {
				var Rows = PerMLocGrid.getSelectedData();
				if (Rows == false) {
					PerMLocGrid.commonDeleteRow();
					return false;
				}
				if (isEmpty(Rows)) {
					$UI.msg('alert', '没有选中的信息!');
					return;
				}
				$UI.confirm('确定要删除吗?', '', '', function() {
					$.cm({
						ClassName: 'web.DHCSTMHUI.HVUsePermissonLoc',
						MethodName: 'DeletePerMLoc',
						Params: JSON.stringify(Rows)
					}, function(jsonData) {
						if (jsonData.success == 0) {
							$UI.msg('success', jsonData.msg);
							PerMLocGrid.reload();
							PerLocUserGrid.reload();
						} else {
							$UI.msg('error', jsonData.msg);
						}
					}
					);
				});
			}
		}
	];
	var PerMLocGridCm = [[
		{
			title: 'HUPLrowid',
			field: 'HUPLrowid',
			hidden: true,
			width: 60
		}, {
			title: '执行科室',
			field: 'OperLocId',
			width: 200,
			formatter: CommonFormatter(OperLocCombox, 'OperLocId', 'OperLocDesc'),
			editor: OperLocCombox
		}, {
			title: '开始日期',
			field: 'StartDate',
			width: 150,
			editor: {
				type: 'datebox',
				options: {
					required: true
				}
			}
		}, {
			title: '开始时间',
			field: 'StartTime',
			width: 120,
			editor: {
				type: 'timespinner',
				options: {
				}
			}
		}, {
			title: '截止日期',
			field: 'EndDate',
			width: 150,
			editor: {
				type: 'datebox',
				options: {
					required: true
				}
			}
		}, {
			title: '截止时间',
			field: 'EndTime',
			width: 120,
			editor: {
				type: 'timespinner',
				options: {
				}
			}
		}, {
			title: '是否激活',
			field: 'Active',
			width: 100,
			align: 'center',
			formatter: BoolFormatter,
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }}
		}
	]];
	var PerMLocGrid = $UI.datagrid('#PerMLocGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.HVUsePermissonLoc',
			QueryName: 'selectAll',
			query2JsonStrict: 1
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.HVUsePermissonLoc',
			MethodName: 'DeletePerMLoc'
		},
		columns: PerMLocGridCm,
		fitColumns: true,
		toolbar: PerMLocTB,
		sortName: 'RowId',
		sortOrder: 'Desc',
		onClickRow: function(index, row) {
			var HUPLrowid = row.HUPLrowid;
			if (!isEmpty(HUPLrowid)) {
				OperLocGrp(HUPLrowid);
			}
			PerMLocGrid.commonClickRow(index, row);
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	var PerLocUserBar = [{
		text: '新增',
		iconCls: 'icon-add',
		handler: function() {
			var Selected = PerMLocGrid.getSelected();
			if (isEmpty(Selected)) {
				$UI.msg('alert', '请选中要维护的科室!');
				return;
			}
			var HUPLrowid = Selected.HUPLrowid;
			if (isEmpty(HUPLrowid)) {
				$UI.msg('alert', '请选中要维护的科室!');
				return;
			}
			PerLocUserGrid.commonAddRow();
		}
	}, {
		text: '保存',
		iconCls: 'icon-save',
		handler: function() {
			var Rows = PerLocUserGrid.getChangesData();
			if (Rows === false) {	// 未完成编辑或明细为空
				return;
			}
			if (isEmpty(Rows)) {	// 明细不变
				$UI.msg('alert', '没有需要保存的明细!');
				return;
			}
			var Selected = PerMLocGrid.getSelected();
			var Parref = Selected.HUPLrowid;
			$.cm({
				ClassName: 'web.DHCSTMHUI.HVUsePermissonLoc',
				MethodName: 'SavePerLocUser',
				Params: JSON.stringify(Rows),
				PermLocId: Parref,
				DOuser: gUserId
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					PerLocUserGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	}, {
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			var Rows = PerLocUserGrid.getSelectedData();
			if (Rows == false) {
				PerLocUserGrid.commonDeleteRow();
				return false;
			}
			if (isEmpty(Rows)) {
				$UI.msg('alert', '没有选中的信息!');
				return;
			}
			$UI.confirm('确定要删除吗?', '', '', function() {
				$.cm({
					ClassName: 'web.DHCSTMHUI.HVUsePermissonLoc',
					MethodName: 'DeletePerLocUser',
					Params: JSON.stringify(Rows)
				}, function(jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						PerLocUserGrid.reload();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			});
		}
	}
	];
	var PerLocUserGridCm = [[
		{
			title: 'HUPLURowid',
			field: 'HUPLURowid',
			width: 100,
			hidden: true
		}, {
			title: '人员工号',
			field: 'Code',
			width: 100
		}, {
			title: '姓名',
			field: 'UserId',
			width: 100,
			formatter: CommonFormatter(UserCombox, 'UserId', 'User'),
			editor: UserCombox
		}, {
			title: '是否激活',
			field: 'ActiveFlag',
			width: 100,
			align: 'center',
			formatter: BoolFormatter,
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }}
		}
	]];
	var PerLocUserGrid = $UI.datagrid('#PerLocUserGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.HVUsePermissonLoc',
			QueryName: 'QueryPerLocUser',
			query2JsonStrict: 1
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.HVUsePermissonLoc',
			MethodName: 'DeletePerLocUser'
		},
		columns: PerLocUserGridCm,
		fitColumns: true,
		toolbar: PerLocUserBar,
		onClickRow: function(index, row) {
			PerLocUserGrid.commonClickRow(index, row);
		}
	});
	function OperLocGrp(HUPLrowid) {
		$UI.clear(PerLocUserGrid);
		PerLocUserGrid.load({
			ClassName: 'web.DHCSTMHUI.HVUsePermissonLoc',
			QueryName: 'QueryPerLocUser',
			query2JsonStrict: 1,
			Parref: HUPLrowid
		});
	}
	InitHosp();
};
$(init);