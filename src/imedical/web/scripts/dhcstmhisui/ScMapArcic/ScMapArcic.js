// /库存分类 医嘱分类 费用分类 收费项目分类 关联维护
// /20180824 XuChao
var init = function() {
	var HospId = gHospId;
	var TableName = 'DHCSTM_ScMapArcic';
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
	
	// 库存分类
	var StkCatBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetAllStkCat&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			// mode: 'remote',
			tipPosition: 'bottom',
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			},
			onSelect: function(record) {
				var rows = ScMapArcGrid.getRows();
				var row = rows[ScMapArcGrid.editIndex];
				row.ScRowId = record.RowId;
				row.ScDescription = record.Description;
			}
		}
	};
	// 医嘱子类
	var OrdSubCatBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrdSubCatM&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			// mode: 'remote',
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			}, onSelect: function(record) {
				var rows = ScMapArcGrid.getRows();
				var row = rows[ScMapArcGrid.editIndex];
				row.ArDescription = record.Description;
			}
		}
	};
	// 费用子类
	var ARCBillSubBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetBillSubCatAll&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			// mode: 'remote',
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			}, onSelect: function(record) {
				var rows = ScMapArcGrid.getRows();
				var row = rows[ScMapArcGrid.editIndex];
				row.BiDescription = record.Description;
			}
		}
	};
	// 子分类
	var SubTypeFeeBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarSubCat&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			// mode: 'remote',
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			}, onSelect: function(record) {
				var rows = ScMapArcGrid.getRows();
				var row = rows[ScMapArcGrid.editIndex];
				row.SubTDescription = record.Description;
			}
		}
	};
	// 住院子分类
	var InSubTypeFeeBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarInpatCat&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			// mode: 'remote',
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			}, onSelect: function(record) {
				var rows = ScMapArcGrid.getRows();
				var row = rows[ScMapArcGrid.editIndex];
				row.InSubTDescription = record.Description;
			}
		}
	};
	// 门诊子分类
	var OutSubTypeFeeBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarOutpatCat&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			// mode: 'remote',
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			}, onSelect: function(record) {
				var rows = ScMapArcGrid.getRows();
				var row = rows[ScMapArcGrid.editIndex];
				row.OutSubTDescription = record.Description;
			}
		}
	};
	// 核算子分类
	var AccSubTypeFeeBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarEMCCat&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			// mode: 'remote',
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			}, onSelect: function(record) {
				var rows = ScMapArcGrid.getRows();
				var row = rows[ScMapArcGrid.editIndex];
				row.ASubTDescription = record.Description;
			}
		}
	};
	// 病历首页分类
	var MedSubTypeFeeBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarMRCat&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			// mode: 'remote',
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			}, onSelect: function(record) {
				var rows = ScMapArcGrid.getRows();
				var row = rows[ScMapArcGrid.editIndex];
				row.MedDescription = record.Description;
			}
		}
	};
	// 新病历首页分类
	var NewMedSubTypeFeeBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarNewMRCat&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			// mode: 'remote',
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			}, onSelect: function(record) {
				var rows = ScMapArcGrid.getRows();
				var row = rows[ScMapArcGrid.editIndex];
				row.NewMedDescription = record.Description;
			}
		}
	};
	// 会计子分类
	var AccountSubTypeFeeBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarAcctCat&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			// mode: 'remote',
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			}, onSelect: function(record) {
				var rows = ScMapArcGrid.getRows();
				var row = rows[ScMapArcGrid.editIndex];
				row.ASTDescription = record.Description;
			}
		}
	};
	// 优先级
	var PriorityBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOECPriority&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			// mode: 'remote',
			onSelect: function(record) {
				var rows = ScMapArcGrid.getRows();
				var row = rows[ScMapArcGrid.editIndex];
				row.PriorityDescription = record.Description;
			}
		}
	};
	// 按钮相关
	$UI.linkbutton('#AddBT', {
		onClick: function() {
			ScMapArcGrid.commonAddRow();
		}
	});
	$UI.linkbutton('#DelBT', {
		onClick: function() {
			ScMapArcGrid.commonDeleteRow();
		}
	});
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			Query();
		}
	});

	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			Save();
		}
	});
	var Query = function() {
		var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		ScMapArcGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCScMapArcic',
			QueryName: 'Query',
			query2JsonStrict: 1,
			Params: Params
		});
	};
	var Save = function() {
		var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		var Detail = ScMapArcGrid.getChangesData();
		if (Detail === false) {
			return;
		}
		if (isEmpty(Detail)) {	// 明细不变
			$UI.msg('alert', '没有需要保存的明细!');
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCScMapArcic',
			MethodName: 'Save',
			Main: Params,
			Params: JSON.stringify(Detail)
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	};
	var ScMapArcGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '库存分类',
			field: 'ScRowId',
			width: 100,
			align: 'left',
			formatter: CommonFormatter(StkCatBox, 'ScRowId', 'ScDescription'),
			editor: StkCatBox
		}, {
			title: '医嘱子类',
			field: 'ArRowId',
			width: 100,
			align: 'left',
			formatter: CommonFormatter(OrdSubCatBox, 'ArRowId', 'ArDescription'),
			editor: OrdSubCatBox
		}, {
			title: '费用子类',
			field: 'BiRowId',
			width: 100,
			align: 'left',
			formatter: CommonFormatter(ARCBillSubBox, 'BiRowId', 'BiDescription'),
			editor: ARCBillSubBox
		}, {
			title: '子分类',
			field: 'SubTRowId',
			width: 100,
			align: 'left',
			formatter: CommonFormatter(SubTypeFeeBox, 'SubTRowId', 'SubTDescription'),
			editor: SubTypeFeeBox
		}, {
			title: '住院子分类',
			field: 'InSubTRowId',
			width: 100,
			align: 'left',
			formatter: CommonFormatter(InSubTypeFeeBox, 'InSubTRowId', 'InSubTDescription'),
			editor: InSubTypeFeeBox
		}, {
			title: '门诊子分类',
			field: 'OutSubTRowId',
			width: 100,
			align: 'left',
			formatter: CommonFormatter(OutSubTypeFeeBox, 'OutSubTRowId', 'OutSubTDescription'),
			editor: OutSubTypeFeeBox
		}, {
			title: '核算子分类',
			field: 'ASubTRowId',
			width: 100,
			align: 'left',
			formatter: CommonFormatter(AccSubTypeFeeBox, 'ASubTRowId', 'ASubTDescription'),
			editor: AccSubTypeFeeBox
		}, {
			title: '病历首页分类',
			field: 'MedRowId',
			width: 150,
			align: 'left',
			formatter: CommonFormatter(MedSubTypeFeeBox, 'MedRowId', 'MedDescription'),
			editor: MedSubTypeFeeBox
		}, {
			title: '新病历首页分类',
			field: 'NewMedRowId',
			width: 150,
			align: 'left',
			formatter: CommonFormatter(NewMedSubTypeFeeBox, 'NewMedRowId', 'NewMedDescription'),
			editor: NewMedSubTypeFeeBox
		}, {
			title: '会计子分类',
			field: 'ASTRowId',
			width: 100,
			align: 'left',
			formatter: CommonFormatter(AccountSubTypeFeeBox, 'ASTRowId', 'ASTDescription'),
			editor: AccountSubTypeFeeBox
		}, {
			title: '默认当天生效',
			field: 'EffDateFlag',
			width: 100,
			align: 'center',
			editor: {
				type: 'checkbox',
				options: { on: 'Y', off: 'N' }
			},
			formatter: BoolFormatter
		}, {
			title: '优先级',
			field: 'PriorityRowId',
			width: 100,
			align: 'left',
			formatter: CommonFormatter(PriorityBox, 'PriorityRowId', 'PriorityDescription'),
			editor: PriorityBox
		}, {
			title: '默认独立医嘱',
			field: 'OwnFlag',
			width: 100,
			align: 'center',
			editor: {
				type: 'checkbox',
				options: { on: 'Y', off: 'N' }
			},
			formatter: BoolFormatter
		}
	]];
	var ScMapArcGrid = $UI.datagrid('#ScMapArcGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCScMapArcic',
			QueryName: 'Query',
			query2JsonStrict: 1
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCScMapArcic',
			MethodName: 'jsDelete'
		},
		columns: ScMapArcGridCm,
		checkField: 'ScRowId',
		toolbar: '#ScMapArcTB',
		pagination: false,
		onClickRow: function(index, row) {
			ScMapArcGrid.commonClickRow(index, row);
		}
	});
	InitHosp();
};
$(init);