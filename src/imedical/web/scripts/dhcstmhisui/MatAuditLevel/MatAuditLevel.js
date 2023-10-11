// 名称: 各业务审核等级维护
// 编写日期: 20200701

var init = function() {
	var HospId = gHospId;
	var TableName = 'DHC_MatAuditLevel';
	function InitHosp() {
		var hospComp = InitHospCombo(TableName, gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			Query();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				Query();
			};
		}
	}
	
	// 业务类型
	var TypeCombox = {
		type: 'combobox',
		options: {
			mode: 'local',
			valueField: 'RowId',
			textField: 'Description',
			data: [
				{ RowId: 'G', Description: '入库' },
				{ RowId: 'R', Description: '退货' },
				{ RowId: 'T', Description: '转移出库' },
				{ RowId: 'K', Description: '转移入库' },
				{ RowId: 'D', Description: '报损' },
				{ RowId: 'A', Description: '调整' },
				{ RowId: 'Basic', Description: '物资信息' }
			]
		}
	};
	// 级别
	var LevelCombox = {
		type: 'combobox',
		options: {
			mode: 'local',
			valueField: 'RowId',
			textField: 'Description',
			data: [
				{ RowId: '0', Description: '0' },
				{ RowId: '1', Description: '1' },
				{ RowId: '2', Description: '2' },
				{ RowId: '3', Description: '3' },
				{ RowId: '4', Description: '4' },
				{ RowId: '5', Description: '5' },
				{ RowId: '6', Description: '6' }
			]
		}
	};
	// 安全组
	var GroupCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetGroup&ResultSetType=Array',
			valueField: 'RowId',
			textField: 'Description',
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			},
			onSelect: function(record) {
				var rows = MatAuditLevelGrid.getRows();
				var row = rows[MatAuditLevelGrid.editIndex];
				row.SSGroupDesc = record.Description;
			}
		}
	};
	// 科室
	var LocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: HospId }));
			},
			onSelect: function(record) {
				var rows = MatAuditLevelGrid.getRows();
				var row = rows[MatAuditLevelGrid.editIndex];
				row.LocDesc = record.Description;
				// row.LocId = record.RowId;
				row.SSUserId = '';
				row.SSUserDesc = '';
			}
		}
	};
	// 人员
	var UserBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			onBeforeLoad: function(param) {
				var rows = MatAuditLevelGrid.getRows();
				var row = rows[MatAuditLevelGrid.editIndex];
				if (isEmpty(row)) { return false; }
				var LocId = row.LocId;
				param.Params = JSON.stringify(addSessionParams({ LocDr: LocId }));
			},
			onSelect: function(record) {
				var rows = MatAuditLevelGrid.getRows();
				var row = rows[MatAuditLevelGrid.editIndex];
				row.SSUserDesc = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};

	$UI.linkbutton('#ReLoadBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		MatAuditLevelGrid.load({
			ClassName: 'web.DHCSTMHUI.MatAuditLevel',
			QueryName: 'QueryMatAuditLevel',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	$UI.linkbutton('#AddBT', {
		onClick: function() {
			MatAuditLevelGrid.commonAddRow();
		}
	});

	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var Rows = MatAuditLevelGrid.getChangesData();
			if (Rows === false) {	// 未完成编辑或明细为空
				return;
			}
			if (isEmpty(Rows)) {	// 明细不变
				$UI.msg('alert', '没有需要保存的明细!');
				return;
			}
			var MainObj = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			$.cm({
				ClassName: 'web.DHCSTMHUI.MatAuditLevel',
				MethodName: 'jsSave',
				Params: MainObj,
				ListData: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					MatAuditLevelGrid.commonReload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	var ScgCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTopScg&ResultSetType=Array',
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = MatAuditLevelGrid.getRows();
				var row = rows[MatAuditLevelGrid.editIndex];
				row.ScgDesc = record.Description;
			}
		}
	};
	var MatAuditLevelCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '业务类型',
			field: 'Type',
			width: 200,
			formatter: CommonFormatter(TypeCombox),
			editor: TypeCombox
		}, {
			title: '类组',
			field: 'ScgId',
			width: 120,
			formatter: CommonFormatter(ScgCombox, 'ScgId', 'ScgDesc'),
			editor: ScgCombox
		}, {
			title: '审核级别',
			field: 'Level',
			width: 200,
			formatter: CommonFormatter(LevelCombox),
			editor: LevelCombox
		}, {
			title: '安全组',
			field: 'SSGroupId',
			width: 200,
			formatter: CommonFormatter(GroupCombox, 'SSGroupId', 'SSGroupDesc'),
			editor: GroupCombox
		}, {
			title: '科室',
			field: 'LocId',
			width: 200,
			formatter: CommonFormatter(LocCombox, 'LocId', 'LocDesc'),
			editor: LocCombox
		}, {
			title: '人员',
			field: 'SSUserId',
			width: 200,
			formatter: CommonFormatter(UserBox, 'SSUserId', 'SSUserDesc'),
			editor: UserBox
		}, {
			title: '激活标志',
			field: 'ActiveFlag',
			width: 120,
			align: 'center',
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }},
			formatter: BoolFormatter
		}
	]];
	
	var MatAuditLevelGrid = $UI.datagrid('#MatAuditLevelGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.MatAuditLevel',
			QueryName: 'QueryMatAuditLevel',
			query2JsonStrict: 1
		},
		columns: MatAuditLevelCm,
		toolbar: '#MatAuditLevelTB',
		onClickRow: function(index, row) {
			MatAuditLevelGrid.commonClickRow(index, row);
		}
	});
	InitHosp();
	Query();
};
$(init);