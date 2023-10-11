var init = function() {
	/* 被点评科室*/
	var PhaLocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	var PhaLocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PhaLocParams,
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect: function(record) {
				var rows = ComLocGrid.getRows();
				var row = rows[ComLocGrid.editIndex];
				row.PhaLocId = record.RowId;
				row.PhaLocDesc = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	/* 点评科室*/
	var ComLocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	var ComLocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ComLocParams,
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect: function(record) {
				var rows = ComLocGrid.getRows();
				var row = rows[ComLocGrid.editIndex];
				row.ComLocDesc = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	/* 点评人员*/
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
				var Selected = ComLocGrid.getSelected();
				if (!isEmpty(Selected)) {
					param.Params = JSON.stringify({
						LocDr: Selected.ComLocId
					});
				}
			},
			onSelect: function(record) {
				var rows = ComUserGrid.getRows();
				var row = rows[ComUserGrid.editIndex];
				row.ComUserId = record.Description;
				row.ComUser = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	function Query() {
		ComLocGrid.load({
			ClassName: 'web.DHCSTMHUI.CommentLocUser',
			QueryName: 'selectComLoc',
			query2JsonStrict: 1
		});
	}
	var ComLocTB = [
		{
			text: '新增',
			iconCls: 'icon-add',
			handler: function() {
				ComLocGrid.commonAddRow();
			}
		}, {
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				var Rows = ComLocGrid.getChangesData('PhaLocId');
				if (Rows === false) {
					return;
				}
				if (isEmpty(Rows)) {
					$UI.msg('alert', '没有需要保存的信息!');
					return;
				}
				for (var i = 0; i < Rows.length; i++) {
					var StartDate = Rows[i].StartDate;
					var StartTime = Rows[i].StartTime;
					var EndDate = Rows[i].EndDate;
					var EndTime = Rows[i].EndTime;
					var PhaLocDesc = Rows[i].PhaLocDesc;
					if ((StartDate != '') && (EndDate != '')) {
						if (compareDate(StartDate, EndDate) || (StartDate == EndDate && StartTime > EndTime)) {
							$UI.msg('alert', '被点评科室' + PhaLocDesc + '截止日期不能早于开始日期!');
							return false;
						}
					}
					if (((StartDate == '') && (StartTime != '')) || ((EndDate == '') && (EndTime != ''))) {
						$UI.msg('alert', '被点评科室' + PhaLocDesc + '请选择日期!');
						return false;
					}
				}
				$.cm({
					ClassName: 'web.DHCSTMHUI.CommentLocUser',
					MethodName: 'SaveComLoc',
					Params: JSON.stringify(Rows)
				}, function(jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						ComLocGrid.reload();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}, {
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function() {
				var Rows = ComLocGrid.getSelections();
				if (isEmpty(Rows)) {
					$UI.msg('alert', '没有选中的信息!');
					return;
				}
				$UI.confirm('确定要删除吗?', '', '', function() {
					$.cm({
						ClassName: 'web.DHCSTMHUI.CommentLocUser',
						MethodName: 'DeleteComLoc',
						Params: JSON.stringify(Rows)
					}, function(jsonData) {
						if (jsonData.success == 0) {
							$UI.msg('success', jsonData.msg);
							$UI.clear(ComUserGrid);
							ComLocGrid.reload();
						} else {
							$UI.msg('error', jsonData.msg);
						}
					}
					);
				});
			}
		}, {
			text: '刷新',
			iconCls: 'icon-reload',
			handler: function() {
				Query();
			}
		}
	];
	var ComLocGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '被点评科室',
			field: 'PhaLocId',
			width: 150,
			formatter: CommonFormatter(PhaLocCombox, 'PhaLocId', 'PhaLocDesc'),
			editor: PhaLocCombox
		}, {
			title: '可点评科室',
			field: 'ComLocId',
			width: 150,
			formatter: CommonFormatter(ComLocCombox, 'ComLocId', 'ComLocDesc'),
			editor: ComLocCombox
		}, {
			title: '开始日期',
			field: 'StartDate',
			width: 150,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '开始时间',
			field: 'StartTime',
			width: 150,
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
				type: 'datebox'
			}
		}, {
			title: '截止时间',
			field: 'EndTime',
			width: 150,
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
	var ComLocGrid = $UI.datagrid('#ComLocGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.CommentLocUser',
			QueryName: 'selectComLoc',
			query2JsonStrict: 1
		},
		columns: ComLocGridCm,
		toolbar: ComLocTB,
		checkField: 'PhaLocId',
		onClickRow: function(index, row) {
			var ParRef = row.RowId;
			if (!isEmpty(ParRef)) {
				ComLocUser(ParRef);
			}
			ComLocGrid.commonClickRow(index, row);
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	var ComUserBar = [
		{
			text: '新增',
			iconCls: 'icon-add',
			handler: function() {
				var Selected = ComLocGrid.getSelected();
				if (isEmpty(Selected)) {
					$UI.msg('alert', '请选中要维护的可点评科室!');
					return;
				}
				var ParRef = Selected.RowId;
				ComUserGrid.commonAddRow();
			}
		}, {
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				if (!ComUserGrid.endEditing()) {
					return false;
				}
				var Rows = ComUserGrid.getChangesData();
				if (Rows === false) {
					return;
				}
				if (isEmpty(Rows)) {
					$UI.msg('alert', '没有需要保存的信息!');
					return;
				}
				for (var i = 0; i < Rows.length; i++) {
					var StartDate = Rows[i].StartDate;
					var StartTime = Rows[i].StartTime;
					var EndDate = Rows[i].EndDate;
					var EndTime = Rows[i].EndTime;
					var ComUser = Rows[i].ComUser;
					if ((StartDate != '') && (EndDate != '')) {
						if (compareDate(StartDate, EndDate)) {
							$UI.msg('alert', ComUser + '截止日期不能早于开始日期!');
							return false;
						}
					}
					if (((StartDate == '') && (StartTime != '')) || ((EndDate == '') && (EndTime != ''))) {
						$UI.msg('alert', ComUser + '请选择日期!');
						return false;
					}
				}
				var Selected = ComLocGrid.getSelected();
				var ParRef = Selected.RowId;
				$.cm({
					ClassName: 'web.DHCSTMHUI.CommentLocUser',
					MethodName: 'SaveComUser',
					Params: JSON.stringify(Rows),
					ParRef: ParRef
				}, function(jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						ComUserGrid.reload();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}, {
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function() {
				var Rows = ComUserGrid.getSelections();
				if (isEmpty(Rows)) {
					$UI.msg('alert', '没有选中的信息!');
					return;
				}
				$UI.confirm('确定要删除吗?', '', '', function() {
					$.cm({
						ClassName: 'web.DHCSTMHUI.CommentLocUser',
						MethodName: 'DeleteComUser',
						Params: JSON.stringify(Rows)
					}, function(jsonData) {
						if (jsonData.success == 0) {
							$UI.msg('success', jsonData.msg);
							ComUserGrid.reload();
						} else {
							$UI.msg('error', jsonData.msg);
						}
					});
				});
			}
		}
	];
	var ComUserGridCm = [[
		{
			title: 'CNTLUParRef',
			field: 'CNTLUParRef',
			width: 100,
			hidden: true
		}, {
			title: 'CNTLURowid',
			field: 'CNTLURowid',
			width: 100,
			hidden: true
		}, {
			title: '人员工号',
			field: 'ComUserCode',
			width: 150
		}, {
			title: '姓名',
			field: 'ComUserId',
			width: 100,
			formatter: CommonFormatter(UserCombox, 'ComUserId', 'ComUser'),
			editor: UserCombox
		}, {
			title: '开始日期',
			field: 'StartDate',
			width: 150,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '开始时间',
			field: 'StartTime',
			width: 150,
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
				type: 'datebox'
			}
		}, {
			title: '截止时间',
			field: 'EndTime',
			width: 150,
			editor: {
				type: 'timespinner',
				options: {
				}
			}
		}, {
			title: '是否激活',
			field: 'ActiveFlag',
			width: 100,
			align: 'center',
			formatter: BoolFormatter,
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }}
		}
	]];
	var ComUserGrid = $UI.datagrid('#ComUserGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.CommentLocUser',
			QueryName: 'QueryComLocUser',
			query2JsonStrict: 1
		},
		columns: ComUserGridCm,
		toolbar: ComUserBar,
		onClickRow: function(index, row) {
			ComUserGrid.commonClickRow(index, row);
		}
	});
	function ComLocUser(ParRef) {
		ComUserGrid.load({
			ClassName: 'web.DHCSTMHUI.CommentLocUser',
			QueryName: 'QueryComLocUser',
			query2JsonStrict: 1,
			ParRef: ParRef
		});
	}
	Query();
};
$(init);