var MarkTypeGrid, MarkRuleGrid, StkDecimalGrid;
var init = function() {
	var HospId = gHospId;
	var TableName = 'DHC_MarkType';
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
		var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		if (TableName == 'DHC_MarkType') {
			MarkTypeGrid.load({
				ClassName: 'web.DHCSTMHUI.MarkType',
				MethodName: 'SelectAll',
				Params: Params
			});
		} else if (TableName == 'DHC_StkDecimal') {
			$UI.clear(StkDecimalItmGrid);
			StkDecimalGrid.load({
				ClassName: 'web.DHCSTMHUI.StkDecimal',
				MethodName: 'SelectAll',
				Params: Params
			});
		} else if (TableName == 'DHC_MarkRule') {
			$UI.clear(MarkRuleItmGrid);
			MarkRuleGrid.load({
				ClassName: 'web.DHCSTMHUI.MarkRule',
				MethodName: 'SelectAll',
				Params: Params
			});
		}
	}
	$HUI.tabs('#DetailTabs', {
		onSelect: function(title, index) {
			if (title == '定价类型') {
				TableName = 'DHC_MarkType';
			} else if (title == '小数规则') {
				TableName = 'DHC_StkDecimal';
			} else if (title == '定价规则') {
				TableName = 'DHC_MarkRule';
			}
			InitHosp();
		}
	});
	// ================================定价类型===========================
	var MarkTypeSaveBT = {
		iconCls: 'icon-save',
		text: '保存',
		handler: function() {
			MarkTypeSave();
		}
	};

	function MarkTypeSave() {
		if (!MarkTypeGrid.endEditing()) {
			return;
		}
		var Rows = MarkTypeGrid.getChangesData('Code');
		if (Rows === false) {	// 未完成编辑或明细为空
			return;
		}
		if (isEmpty(Rows)) {	// 明细不变
			$UI.msg('alert', '没有需要保存的明细!');
			return;
		}
		var MainObj = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		$.cm({
			ClassName: 'web.DHCSTMHUI.MarkType',
			MethodName: 'Save',
			Main: MainObj,
			Params: JSON.stringify(Rows)
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				MarkTypeGrid.reload();
				FindAllMarkRule();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var MarkTypeAddBT = {
		text: '新增',
		iconCls: 'icon-add',
		handler: function() {
			MarkTypeGrid.commonAddRow();
		}
	};
	var MarkTypeUse = {
		type: 'combobox',
		options: {
			data: [{ RowId: 'Y', Description: '是' }, { RowId: 'N', Description: '否' }
			],
			valueField: 'RowId',
			textField: 'Description',
			tipPosition: 'bottom',
			required: true,
			mode: 'local'
		}
	};
	var MarkTypePb = {
		type: 'combobox',
		options: {
			data: [{ RowId: 'Y', Description: '是' }, { RowId: 'N', Description: '否' }
			],
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			tipPosition: 'bottom',
			mode: 'local'
		}
	};

	MarkTypeGrid = $UI.datagrid('#MarkTypeGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.MarkType',
			MethodName: 'SelectAll',
			rows: 999
		},
		pagination: false,
		toolbar: [MarkTypeAddBT, MarkTypeSaveBT],
		columns: [[
			{
				title: 'RowId',
				field: 'RowId',
				width: 80,
				hidden: true
			}, {
				title: '代码',
				field: 'Code',
				width: 150,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				title: '名称',
				field: 'Desc',
				width: 150,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				title: '是否中标',
				field: 'ZbFlag',
				width: 100,
				editor: MarkTypePb,
				formatter: CommonFormatter(MarkTypePb)
			}, {
				title: '是否使用',
				field: 'UseFlag',
				width: 100,
				editor: MarkTypeUse,
				formatter: CommonFormatter(MarkTypeUse)
			}
		]],
		onClickCell: function(index, field, value) {
			MarkTypeGrid.commonClickCell(index, field);
		},
		onBeforeCellEdit: function(index, field) {
			var RowData = $(this).datagrid('getRows')[index];
			if (field == 'Code' && !isEmpty(RowData['RowId'])) {
				return false;
			}
			return true;
		}
	});
	// =========================小数规则=======================================
	function FindAllStkDecimal() {
		var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		StkDecimalGrid.load({
			ClassName: 'web.DHCSTMHUI.StkDecimal',
			MethodName: 'SelectAll',
			Params: Params
		});
	}
	var StkDecimalBar = [
		{
			text: '新增',
			iconCls: 'icon-add',
			handler: function() {
				StkDecimalGrid.commonAddRow();
			}
		}, {
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				var Rows = StkDecimalGrid.getChangesData();
				if (Rows === false) {	// 未完成编辑或明细为空
					return;
				}
				if (isEmpty(Rows)) {	// 明细不变
					$UI.msg('alert', '没有需要保存的明细!');
					return;
				}
				var MainObj = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
				$.cm({
					ClassName: 'web.DHCSTMHUI.StkDecimal',
					MethodName: 'Save',
					Main: MainObj,
					Params: JSON.stringify(Rows)
				}, function(jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						Query();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}, {
			text: '刷新',
			iconCls: 'icon-reload',
			handler: function() {
				FindAllStkDecimal();
			}
		}
	];

	var StkDecimalCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 150,
			hidden: true
		}, {
			title: '代码',
			field: 'Name',
			width: 100,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '描述',
			field: 'Desc',
			width: 150,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '是否使用',
			field: 'UseFlag',
			width: 80,
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }},
			formatter: BoolFormatter
		}
	]];

	StkDecimalGrid = $UI.datagrid('#StkDecimalGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.StkDecimal',
			QueryName: 'SelectAll'
		},
		columns: StkDecimalCm,
		toolbar: StkDecimalBar,
		fitColumns: true,
		onClickRow: function(index, row) {
			StkDecimalGrid.commonClickRow(index, row);
		},
		onSelect: function(index, row) {
			var Parref = row.RowId;
			if (!isEmpty(Parref)) {
				FindItmByParref(Parref);
			}
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});

	var StkDecimalItmBar = [
		{
			text: '新增',
			iconCls: 'icon-add',
			handler: function() {
				var Selected = StkDecimalGrid.getSelected();
				if (isEmpty(Selected)) {
					$UI.msg('alert', '请选小数规则!');
					return;
				}
				var PRowId = Selected.RowId;
				if (isEmpty(PRowId)) {
					$UI.msg('alert', '请先保存小数规则!');
					return;
				}
				StkDecimalItmGrid.commonAddRow();
			}
		}, {
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				var Rows = StkDecimalItmGrid.getChangesData();
				var Selected = StkDecimalGrid.getSelected();
				var PRowId = Selected.RowId;
				if (Rows === false) {	// 未完成编辑或明细为空
					return;
				}
				if (isEmpty(Rows)) {	// 明细不变
					$UI.msg('alert', '没有需要保存的明细!');
					return;
				}
				for (var i = 0; i < Rows.length; i++) {
					if (Number(Rows[i].Min) > Number(Rows[i].Max)) {
						$UI.msg('alert', '下限' + Rows[i].Min + '大于上限' + Rows[i].Max + ',请重新输入!');
						return;
					}
					if (Rows[i].DecimalLen < 0) {
						$UI.msg('alert', '规则位数是负数，无法保存！');
						return;
					}
				}
				$.cm({
					ClassName: 'web.DHCSTMHUI.StkDecimalItm',
					MethodName: 'Save',
					PRowId: PRowId,
					Params: JSON.stringify(Rows)
				}, function(jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						StkDecimalItmGrid.reload();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}, {
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function() {
				var Rows = StkDecimalItmGrid.getSelectedData('RowId');
				if (Rows == false) {
					StkDecimalItmGrid.commonDeleteRow();
					return false;
				}
				if (isEmpty(Rows)) {
					$UI.msg('alert', '请选择要删除的数据!');
					return false;
				}
				var RowId = Rows[0].RowId;
				if (isEmpty(RowId)) {
					return false;
				}
				$UI.confirm('确定要删除吗?', '', '', function() {
					$.cm({
						ClassName: 'web.DHCSTMHUI.StkDecimalItm',
						MethodName: 'Delete',
						RowId: RowId
					}, function(jsonData) {
						if (jsonData.success == 0) {
							$UI.msg('success', jsonData.msg);
							StkDecimalItmGrid.reload();
						} else {
							$UI.msg('error', jsonData.msg);
						}
					});
				});
			}
		}
	];
	var StkDecimalItmCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 100
		}, {
			title: '下限',
			field: 'Min',
			width: 100,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					min: 0,
					precision: GetFmtNum('FmtRP')
				}
			}
		}, {
			title: '上限',
			field: 'Max',
			width: 100,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					min: 0,
					precision: GetFmtNum('FmtRP')
				}
			}
		}, {
			title: '规则位数',
			field: 'DecimalLen',
			width: 100,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					min: 0,
					precision: GetFmtNum('FmtQTY')
				}
			}
		}
	]];

	var StkDecimalItmGrid = $UI.datagrid('#StkDecimalItmGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.StkDecimalItm',
			MethodName: 'SelectAll'
		},
		columns: StkDecimalItmCm,
		pagination: false,
		toolbar: StkDecimalItmBar,
		onClickRow: function(index, row) {
			StkDecimalItmGrid.commonClickRow(index, row);
		}
	});

	function FindItmByParref(Parref) {
		StkDecimalItmGrid.load({
			ClassName: 'web.DHCSTMHUI.StkDecimalItm',
			MethodName: 'SelectAll',
			Parref: Parref
		});
	}

	// ====================定价规则=======================================
	function FindAllMarkRule() {
		var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		MarkRuleGrid.load({
			ClassName: 'web.DHCSTMHUI.MarkRule',
			MethodName: 'SelectAll',
			Params: Params
		});
	}
	// 定价类型
	var MarkTypeCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetMarkType&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			// mode: 'remote',
			onBeforeLoad: function(param) {
				var rows = MarkRuleGrid.getRows();
				var row = rows[MarkRuleGrid.editIndex];
				if (!isEmpty(row)) {
					param.Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
				}
			},
			onSelect: function(record) {
				var rows = MarkRuleGrid.getRows();
				var row = rows[MarkRuleGrid.editIndex];
				row.MtDesc = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('clear');
				$(this).combobox('reload');
			}
		}
	};
	var ComboxParams = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
	/* var MarkTypeCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetMarkType&ResultSetType=array&Params='+ComboxParams,
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote'
		}
	}*/
	// 小数规则
	var StkDecimalCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkDecimal&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			// mode: 'remote',
			onBeforeLoad: function(param) {
				var rows = MarkRuleGrid.getRows();
				var row = rows[MarkRuleGrid.editIndex];
				if (!isEmpty(row)) {
					param.Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
				}
			},
			onSelect: function(record) {
				var rows = MarkRuleGrid.getRows();
				var row = rows[MarkRuleGrid.editIndex];
				row.SdDesc = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('clear');
				$(this).combobox('reload');
			}
		}
	};
	/* var StkDecimalCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkDecimal&ResultSetType=array&Params='+ComboxParams,
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote'
		}
	}*/

	var MarkRuleBar = [
		{
			text: '新增',
			iconCls: 'icon-add',
			handler: function() {
				MarkRuleGrid.commonAddRow();
			}
		}, {
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				var Rows = MarkRuleGrid.getChangesData();
				if (Rows === false) {	// 未完成编辑或明细为空
					return;
				}
				if (isEmpty(Rows)) {	// 明细不变
					$UI.msg('alert', '没有需要保存的明细!');
					return;
				}
				var MainObj = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
				$.cm({
					ClassName: 'web.DHCSTMHUI.MarkRule',
					MethodName: 'Save',
					Main: MainObj,
					Params: JSON.stringify(Rows)
				}, function(jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						FindAllMarkRule();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}, {
			text: '刷新',
			iconCls: 'icon-reload',
			handler: function() {
				FindAllMarkRule();
			}
		}, {
			text: '页面说明',
			iconCls: 'icon-help',
			handler: function() {
				var href = '../scripts/dhcstmhisui/help/定价类型简要说明.htm';
				$('#myWindow').window({
					title: '定价类型说明文档',
					width: gWinWidth,
					height: gWinHeight,
					content: CreateFrame(href)
				});
			}
		}
	];

	var MarkRuleCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 150,
			hidden: true
		}, {
			title: '代码',
			field: 'Code',
			width: 100,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '描述',
			field: 'Desc',
			width: 150,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '规则下限',
			field: 'MinRp',
			width: 100,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					min: 0,
					precision: GetFmtNum('FmtRP')
				}
			}
		}, {
			title: '规则上限',
			field: 'MaxRp',
			width: 100,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					min: 0,
					precision: GetFmtNum('FmtRP')
				}
			}
		}, {
			title: '加成率',
			field: 'Margin',
			width: 100,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					min: 0,
					precision: GetFmtNum('FmtRP')
				}
			}
		}, {
			title: '加成额',
			field: 'MPrice',
			width: 100,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					min: 0,
					precision: GetFmtNum('FmtRP')
				}
			}
		}, {
			title: '最高加成比',
			field: 'MaxMargin',
			width: 100,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					min: 0,
					precision: GetFmtNum('FmtRP')
				}
			}
		}, {
			title: '最高加成额',
			field: 'MaxMPrice',
			width: 100,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					min: 0,
					precision: GetFmtNum('FmtRP')
				}
			}
		}, {
			title: '定价类型',
			field: 'MtDr',
			formatter: CommonFormatter(MarkTypeCombox, 'MtDr', 'MtDesc'),
			width: 100,
			editor: MarkTypeCombox
		}, {
			title: '小数规则',
			field: 'SdDr',
			formatter: CommonFormatter(StkDecimalCombox, 'SdDr', 'SdDesc'),
			width: 100,
			editor: StkDecimalCombox
		}, {
			title: '是否使用',
			field: 'UseFlag',
			width: 100,
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }},
			formatter: BoolFormatter
		}, {
			title: '备注',
			field: 'Remark',
			width: 100,
			editor: { type: 'validatebox' }
		}
	]];

	MarkRuleGrid = $UI.datagrid('#MarkRuleGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.MarkRule',
			QueryName: 'SelectAll'
		},
		columns: MarkRuleCm,
		toolbar: MarkRuleBar,
		sortName: 'RowId',
		sortOrder: 'Desc',
		onClickRow: function(index, row) {
			MarkRuleGrid.commonClickRow(index, row);
		},
		onSelect: function(index, row) {
			var Parref = row.RowId;
			if (!isEmpty(Parref)) {
				FindItmRByParref(Parref);
			}
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});

	var MarkRuleItmBar = [
		{
			text: '新增',
			iconCls: 'icon-add',
			handler: function() {
				var Selected = MarkRuleGrid.getSelected();
				if (isEmpty(Selected)) {
					$UI.msg('alert', '请选定价规则!');
					return;
				}
				var PRowId = Selected.RowId;
				if (isEmpty(PRowId)) {
					$UI.msg('alert', '请先保存定价规则!');
					return;
				}
				MarkRuleItmGrid.commonAddRow();
			}
		}, {
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				var Rows = MarkRuleItmGrid.getChangesData();
				var Selected = MarkRuleGrid.getSelected();
				var PRowId = Selected.RowId;
				if (Rows === false) {	// 未完成编辑或明细为空
					return;
				}
				if (isEmpty(Rows)) {	// 明细不变
					$UI.msg('alert', '没有需要保存的明细!');
					return;
				}
				$.cm({
					ClassName: 'web.DHCSTMHUI.MarkRuleAdd',
					MethodName: 'Save',
					PRowId: PRowId,
					Params: JSON.stringify(Rows)
				}, function(jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						MarkRuleItmGrid.reload();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}, {
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function() {
				var Rows = MarkRuleItmGrid.getSelectedData('RowId');
				if (Rows == false) {
					MarkRuleItmGrid.commonDeleteRow();
					return false;
				}
				if (isEmpty(Rows)) {
					$UI.msg('alert', '请选择要删除的数据!');
					return false;
				}
				var RowId = Rows[0].RowId;
				if (isEmpty(RowId)) {
					return false;
				}
				$UI.confirm('确定要删除吗?', '', '', function() {
					$.cm({
						ClassName: 'web.DHCSTMHUI.MarkRuleAdd',
						MethodName: 'Delete',
						RowId: RowId
					}, function(jsonData) {
						if (jsonData.success == 0) {
							$UI.msg('success', jsonData.msg);
							MarkRuleItmGrid.reload();
						} else {
							$UI.msg('error', jsonData.msg);
						}
					});
				});
			}
		}
	];
	var MarkRuleItmCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 100
		}, {
			title: '代码',
			field: 'Code',
			width: 100,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '描述',
			field: 'Desc',
			width: 150,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '下限',
			field: 'MinRp',
			width: 100,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					min: 0,
					precision: GetFmtNum('FmtRP')
				}
			}
		}, {
			title: '上限',
			field: 'MaxRp',
			width: 100,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					min: 0,
					precision: GetFmtNum('FmtRP')
				}
			}
		}, {
			title: '加成率',
			field: 'Margin',
			width: 100,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					min: 0,
					precision: GetFmtNum('FmtRP')
				}
			}
		}, {
			title: '是否使用',
			field: 'UseFlag',
			width: 100,
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }},
			formatter: BoolFormatter
		}, {
			title: '备注',
			field: 'Remark',
			width: 100,
			editor: { type: 'validatebox' }
		}
	]];

	var MarkRuleItmGrid = $UI.datagrid('#MarkRuleItmGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.MarkRuleAdd',
			MethodName: 'SelectAll'
		},
		columns: MarkRuleItmCm,
		pagination: false,
		toolbar: MarkRuleItmBar,
		onClickRow: function(index, row) {
			MarkRuleItmGrid.commonClickRow(index, row);
		}
	});

	function FindItmRByParref(Parref) {
		MarkRuleItmGrid.load({
			ClassName: 'web.DHCSTMHUI.MarkRuleAdd',
			MethodName: 'SelectAll',
			Parref: Parref
		});
	}
	InitHosp();
};
$(init);
