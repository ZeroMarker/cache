// /高值标志 医嘱分类 费用分类 收费项目分类 关联维护
// /20180824 zx
var init = function() {
	var HospId = gHospId;
	var TableName = 'DHCSTM_HvMapArcic';
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
	
	var HvFlagData = [{ 'RowId': 'Y', 'Description': '是' }, { 'RowId': 'N', 'Description': '否' }];
	var HvFlagCombox = {
		type: 'combobox',
		options: {
			data: HvFlagData,
			valueField: 'RowId',
			textField: 'Description',
			required: 'Y'
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
				var rows = HvMapArcGrid.getRows();
				var row = rows[HvMapArcGrid.editIndex];
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
				var rows = HvMapArcGrid.getRows();
				var row = rows[HvMapArcGrid.editIndex];
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
				var rows = HvMapArcGrid.getRows();
				var row = rows[HvMapArcGrid.editIndex];
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
				var rows = HvMapArcGrid.getRows();
				var row = rows[HvMapArcGrid.editIndex];
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
				var rows = HvMapArcGrid.getRows();
				var row = rows[HvMapArcGrid.editIndex];
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
				var rows = HvMapArcGrid.getRows();
				var row = rows[HvMapArcGrid.editIndex];
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
				var rows = HvMapArcGrid.getRows();
				var row = rows[HvMapArcGrid.editIndex];
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
				var rows = HvMapArcGrid.getRows();
				var row = rows[HvMapArcGrid.editIndex];
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
				var rows = HvMapArcGrid.getRows();
				var row = rows[HvMapArcGrid.editIndex];
				row.ASTDescription = record.Description;
			}
		}
	};
	$UI.linkbutton('#AddBT', {
		onClick: function() {
			HvMapArcGrid.commonAddRow();
		}
	});
	$UI.linkbutton('#DelBT', {
		onClick: function() {
			HvMapArcGrid.commonDeleteRow();
		}
	});
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			Query();
		}
	});
	var Query = function() {
		var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		HvMapArcGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCHvMapArc',
			QueryName: 'Query',
			query2JsonStrict: 1,
			Params: Params
		});
	};
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			Save();
		}
	});
	var Save = function() {
		if (!HvMapArcGrid.endEditing()) {
			return false;
		}
		var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		var Detail = HvMapArcGrid.getChangesData('HvRowId');
		if (Detail === false) {	// 未完成编辑或明细为空
			return;
		}
		if (isEmpty(Detail)) {	// 明细不变
			$UI.msg('alert', '没有需要保存的明细!');
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCHvMapArc',
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
	var HvMapArcGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '高值标志',
			field: 'HvRowId',
			width: 100,
			align: 'left',
			formatter: CommonFormatter(HvFlagCombox, 'HvRowId', 'HvDescription'),
			editor: HvFlagCombox
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
		}
	]];
	var HvMapArcGrid = $UI.datagrid('#HvMapArcGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCHvMapArc',
			QueryName: 'Query',
			query2JsonStrict: 1
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCHvMapArc',
			MethodName: 'jsDelete'
		},
		columns: HvMapArcGridCm,
		toolbar: '#HvMapArcTB',
		pagination: false,
		fitColumns: true,
		onClickRow: function(index, row) {
			HvMapArcGrid.commonClickRow(index, row);
		}
	});
	InitHosp();
};
$(init);