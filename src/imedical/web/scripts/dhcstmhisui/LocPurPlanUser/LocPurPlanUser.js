var init = function() {
	var HospId = '';
	function InitHosp() {
		var hospComp = InitHospCombo('CT_Loc', gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				$UI.clearBlock('LocTB');
				Query();
			};
		} else {
			HospId = gHospId;
		}
	}
	/* var GroupComData = $.cm({
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetUserGroup',
			ResultSetType: 'array',
			UserId: gUserId
		}, false);
		*/
	var GroupCombox = $HUI.combobox('#GroupId', {
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			GroupCombox.clear();
			var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var userid = gUserId;
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetUserGroup&ResultSetType=array&UserId=' + userid + '&Params=' + Params;
			if (HospId != gHospId) {
				url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetGroup&ResultSetType=array&Params=' + Params;
			}
			GroupCombox.reload(url);
		}
	});
	function Query() {
		var SessionParmas = addSessionParams({ BDPHospital: HospId });
		var Paramsobj = $UI.loopBlock('#LocTB');
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		if (isEmpty(Paramsobj.GroupId)) {
			$UI.msg('alert', '请选择安全组!');
			return;
		}
		$UI.clear(PurPlanUserGrid);
		LocGrid.load({
			ClassName: 'web.DHCSTMHUI.LocPurPlanUser',
			QueryName: 'GetGroupLoc',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$('#SearchBT').on('click', function() {
		Query();
	}
	);
	var LocCm = [[
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
			title: '描述',
			field: 'Description',
			width: 250
		}
	]];

	var LocGrid = $UI.datagrid('#LocList', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocPurPlanUser',
			QueryName: 'GetGroupLoc',
			query2JsonStrict: 1
		},
		columns: LocCm,
		// toolbar: '#LocTB',
		fitColumns: true,
		sortName: 'RowId',
		sortOrder: 'Desc',
		onClickCell: function(index, filed, value) {
			var Row = LocGrid.getRows()[index];
			var Id = Row.RowId;
			if (!isEmpty(Id)) {
				PurPlanUser(Id);
			}
		}
	});
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
				var Selected = LocGrid.getSelected();
				if (!isEmpty(Selected)) {
					param.Params = JSON.stringify({
						LocDr: Selected.RowId
					});
				}
			},
			onSelect: function(record) {
				var rows = PurPlanUserGrid.getRows();
				var row = rows[PurPlanUserGrid.editIndex];
				row.UserDesc = record.Description;
			}
		}
	};
	
	function CheckDataBeforeSave() {
		if (!PurPlanUserGrid.endEditing()) {
			return false;
		}
		var RowsData = PurPlanUserGrid.getRows();
		var DefCount = 0;
		for (var i = 0; i < RowsData.length; i++) {
			var DefaultFlag = RowsData[i].DefaultFlag;
			if (DefaultFlag == 'Y') {
				DefCount = DefCount + 1;
			}
		}
		if (DefCount > 1) {
			$UI.msg('alert', '设置了多个默认值!');
			return false;
		}
		
		return true;
	}
	
	var PurPlanUserBar = [{
		text: '新增',
		iconCls: 'icon-add',
		handler: function() {
			var Selected = LocGrid.getSelected();
			if (isEmpty(Selected)) {
				$UI.msg('alert', '请选中要维护的科室!');
				return;
			}
			PurPlanUserGrid.commonAddRow();
		}
	}, {
		text: '保存',
		iconCls: 'icon-save',
		handler: function() {
			if (!CheckDataBeforeSave()) {
				return;
			}
			var Rows = PurPlanUserGrid.getChangesData();
			var Selected = LocGrid.getSelected();
			var PRowId = Selected.RowId;
			if (Rows === false) {	// 未完成编辑或明细为空
				return;
			}
			if (isEmpty(Rows)) {	// 明细不变
				$UI.msg('alert', '没有需要保存的明细!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.LocPurPlanUser',
				MethodName: 'Save',
				LocId: PRowId,
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					PurPlanUserGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	}, {
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			var Rows = PurPlanUserGrid.getSelections();
			if (Rows.length <= 0) {
				$UI.msg('alert', '请选择要删除的信息!');
				return;
			}
			$UI.confirm('确定要删除吗?', '', '', function() {
				$.cm({
					ClassName: 'web.DHCSTMHUI.LocPurPlanUser',
					MethodName: 'Delete',
					Params: JSON.stringify(Rows)
				}, function(jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						PurPlanUserGrid.reload();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			});
		}
	}
	];
	var PurPlanUserCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '工号',
			field: 'Code',
			width: 150
		}, {
			title: '姓名',
			field: 'UserId',
			formatter: CommonFormatter(UserCombox, 'UserId', 'UserDesc'),
			width: 200,
			editor: UserCombox
		}, {
			title: '默认标志',
			field: 'DefaultFlag',
			width: 80,
			editor: {
				type: 'checkbox',
				options: {
					on: 'Y',
					off: 'N'
				}
			}
		}, {
			title: '激活标志',
			field: 'ActiveFlag',
			width: 80,
			editor: {
				type: 'checkbox',
				options: {
					on: 'Y',
					off: 'N'
				}
			}
		}
	]];

	var PurPlanUserGrid = $UI.datagrid('#PurPlanUserList', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocPurPlanUser',
			MethodName: 'SelectLocUser'
		},
		columns: PurPlanUserCm,
		fitColumns: true,
		pagination: false,
		toolbar: PurPlanUserBar,
		singleSelect: false,
		onClickCell: function(index, field, value) {
			var Row = PurPlanUserGrid.getRows()[index];
			if ((field == 'UserId') && (!isEmpty(Row.RowId))) {
				return false;
			}
			PurPlanUserGrid.commonClickCell(index, field);
		}
	});
	function PurPlanUser(Id) {
		PurPlanUserGrid.load({
			ClassName: 'web.DHCSTMHUI.LocPurPlanUser',
			MethodName: 'SelectLocUser',
			LocId: Id
		});
	}
	InitHosp();
};
$(init);