var MarkTypeGrid,MarkRuleGrid,StkDecimalGrid;
var init = function () {
	var HospId=gHospId;
	var TableName="DHC_MarkType";
	function InitHosp() {
		var hospComp=InitHospCombo(TableName,gSessionStr);
		if (typeof hospComp ==='object'){
			HospId=$HUI.combogrid('#_HospList').getValue();
			Query();
			$('#_HospList').combogrid("options").onSelect=function(index,record){
				HospId=record.HOSPRowId;
				Query();
			};
		}
	}
	function Query(){
		var Params=JSON.stringify(addSessionParams({BDPHospital:HospId}));
		if (TableName=="DHC_MarkType") {
			MarkTypeGrid.load({
				ClassName: 'web.DHCSTMHUI.MarkType',
				MethodName: 'SelectAll',
				Params: Params
			});
		}
		else if (TableName=="DHC_StkDecimal") {
			$UI.clear(StkDecimalItmGrid);
			StkDecimalGrid.load({
				ClassName: 'web.DHCSTMHUI.StkDecimal',
				MethodName: 'SelectAll',
				Params: Params
			});
		}
		else if (TableName=="DHC_MarkRule") {
			$UI.clear(MarkRuleItmGrid);
			MarkRuleGrid.load({
				ClassName: 'web.DHCSTMHUI.MarkRule',
				MethodName: 'SelectAll',
				Params:Params
			})
		}
	}
	$HUI.tabs("#DetailTabs", {
		onSelect: function (title, index) {
			if (title == "定价类型") {
				TableName="DHC_MarkType";
			}
			else if (title == "小数规则") {
				TableName="DHC_StkDecimal";
			}
			else if (title == "定价规则") {
				TableName="DHC_MarkRule";
			}
			InitHosp();
		}
	});
	//================================定价类型===========================
	var MarkTypeSaveBT = {
		iconCls: 'icon-save',
		text: '保存',
		handler: function () {
			MarkTypeSave();
		}
	};

	function MarkTypeSave() {
		MarkTypeGrid.endEditing();
		var Rows = MarkTypeGrid.getChangesData('Code');
		if (Rows === false){	//未完成编辑或明细为空
			return;
		}
		if (isEmpty(Rows)){	//明细不变
			$UI.msg("alert", "没有需要保存的明细!");
			return;
		}
		var MainObj = JSON.stringify(addSessionParams({BDPHospital:HospId}));
		$.cm({
			ClassName: 'web.DHCSTMHUI.MarkType',
			MethodName: 'Save',
			Main: MainObj,
			Params: JSON.stringify(Rows)
		}, function (jsonData) {
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
		handler: function () {
			MarkTypeGrid.commonAddRow();
		}
	}
	var MarkTypeUse = {
		type: 'combobox',
		options: {
			data: [{ RowId: 'Y', Description: '是' }, { RowId: 'N', Description: '否' }
			],
			valueField: 'RowId',
			textField: 'Description',
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
			mode: 'local'
		}
	};

	MarkTypeGrid = $UI.datagrid('#MarkTypeGrid', {
		lazy: false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.MarkType',
			MethodName: 'SelectAll',
			rows: 999
		},
		pagination: false,
		toolbar: [MarkTypeAddBT, MarkTypeSaveBT],
		fitColumns: true,
		columns: [[
			{
				title: 'RowId',
				field: 'RowId',
				width: 80,
				hidden: true
			}, {
				title: '代码',
				field: 'Code',
				width: 200,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				title: '名称',
				field: 'Desc',
				width: 300,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				title: '是否中标',
				field: 'ZbFlag',
				width: 200,
				editor: MarkTypePb,
				formatter: CommonFormatter(MarkTypePb)
			}, {
				title: '是否使用',
				field: 'UseFlag',
				width: 200,
				editor: MarkTypeUse,
				formatter: CommonFormatter(MarkTypeUse)
			}
		]],
		onClickCell: function (index, field, value) {
			MarkTypeGrid.commonClickCell(index, field);
		},
		onBeforeCellEdit: function (index, field) {
			var RowData = $(this).datagrid('getRows')[index];
			if (field == 'Code' && !isEmpty(RowData['RowId'])) {
				return false;
			}
			return true;
		}
	});
	//=========================小数规则=======================================
	function FindAllStkDecimal() {
		var Params = JSON.stringify(addSessionParams({BDPHospital:HospId}));
		StkDecimalGrid.load({
			ClassName: 'web.DHCSTMHUI.StkDecimal',
			MethodName: 'SelectAll',
			Params:Params
		})
	}
	var StkDecimalBar = [{
		text: '新增',
		iconCls: 'icon-add',
		handler: function () {
			StkDecimalGrid.commonAddRow();
		}
	}, {
		text: '保存',
		iconCls: 'icon-save',
		handler: function () {
			var Rows = StkDecimalGrid.getChangesData();
			if (Rows === false){	//未完成编辑或明细为空
				return;
			}
			if (isEmpty(Rows)){	//明细不变
				$UI.msg("alert", "没有需要保存的明细!");
				return;
			}
			var MainObj = JSON.stringify(addSessionParams({BDPHospital:HospId}));
			$.cm({
				ClassName: 'web.DHCSTMHUI.StkDecimal',
				MethodName: 'Save',
				Main: MainObj,
				Params: JSON.stringify(Rows)
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg("success", jsonData.msg);
					Query();
				}
				else {
					$UI.msg("error", jsonData.msg);
				}
			})
		}
	}, {
		text: '查询',
		iconCls: 'icon-search',
		handler: function () {
			FindAllStkDecimal();
		}
	}
	];

	var StkDecimalCm = [[{
		title: 'RowId',
		field: 'RowId',
		width: 150,
		hidden: true
	}, {
		title: '代码',
		field: 'Name',
		width: 100,
		editor: { type: 'validatebox', options: { required: true } }
	}, {
		title: '描述',
		field: 'Desc',
		width: 150,
		editor: { type: 'validatebox', options: { required: true } }
	}, {
		title: '是否使用',
		field: 'UseFlag',
		width: 50,
		editor: { type: 'checkbox', options: { on: 'Y', off: 'N' } },
		formatter: BoolFormatter
	}
	]];

	StkDecimalGrid = $UI.datagrid('#StkDecimalGrid', {
		url: $URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.StkDecimal',
			QueryName: 'SelectAll'
		},
		columns: StkDecimalCm,
		toolbar: StkDecimalBar,
		sortName: 'RowId',
		sortOrder: 'Desc',
		fitColumns: true,
		onClickCell: function (index, filed, value) {
			var Row = StkDecimalGrid.getRows()[index]
			var Parref = Row.RowId;
			if (!isEmpty(Parref)) {
				FindItmByParref(Parref);
			}
			StkDecimalGrid.commonClickCell(index, filed)
		}
	})

	var StkDecimalItmBar = [{
		text: '新增',
		iconCls: 'icon-add',
		handler: function () {
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
		handler: function () {
			var Rows = StkDecimalItmGrid.getChangesData();
			var Selected = StkDecimalGrid.getSelected();
			var PRowId = Selected.RowId;
			if (Rows === false){	//未完成编辑或明细为空
				return;
			}
			if (isEmpty(Rows)){	//明细不变
				$UI.msg("alert", "没有需要保存的明细!");
				return;
			}
			for (var i = 0; i < Rows.length; i++) {
				if (Number(Rows[i].Min) > Number(Rows[i].Max)) {
					$UI.msg('alert', '下限' + Rows[i].Min + '大于上限' + Rows[i].Max + ',请重新输入!');
					return;
				}
				if (Rows[i].DecimalLen < 0){
					$UI.msg('alert','规则位数是负数，无法保存！');
					return;
					}
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.StkDecimalItm',
				MethodName: 'Save',
				PRowId: PRowId,
				Params: JSON.stringify(Rows)
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					StkDecimalItmGrid.reload()
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	}, {
		text: '删除',
		iconCls: 'icon-remove',
		handler: function () {
			var Rows = StkDecimalItmGrid.getSelectedData("RowId")
			if (isEmpty(Rows)) {
				StkDecimalItmGrid.commonDeleteRow();
				//$UI.msg('alert', '请选操作数据!');
				return false;
			}
			var RowId = Rows[0].RowId
			if (isEmpty(RowId)) {
				return false;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.StkDecimalItm',
				MethodName: 'Delete',
				RowId: RowId
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					StkDecimalItmGrid.reload()
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	}
	];
	var StkDecimalItmCm = [[{
		title: 'RowId',
		field: 'RowId',
		hidden: true,
		width: 100
	}, {
		title: '下限',
		field: 'Min',
		width: 100,
		editor: { type: 'numberbox', options: { required: true } }
	}, {
		title: '上限',
		field: 'Max',
		width: 100,
		editor: { type: 'numberbox', options: { required: true } }
	}, {
		title: '规则位数',
		field: 'DecimalLen',
		width: 100,
		editor: { type: 'numberbox', options: { required: true } }
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
		onClickCell: function (index, field, value) {
			var Row = StkDecimalItmGrid.getRows()[index]
			StkDecimalItmGrid.commonClickCell(index, field)
		}
	});

	function FindItmByParref(Parref) {
		StkDecimalItmGrid.load({
			ClassName: 'web.DHCSTMHUI.StkDecimalItm',
			MethodName: 'SelectAll',
			Parref: Parref
		});
	}


	//====================定价规则=======================================
	function FindAllMarkRule() {
		var Params = JSON.stringify(addSessionParams({BDPHospital:HospId}));
		MarkRuleGrid.load({
			ClassName: 'web.DHCSTMHUI.MarkRule',
			MethodName: 'SelectAll',
			Params: Params
		})
	}
	//定价类型
	var MarkTypeCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetMarkType&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote',
			onBeforeLoad: function (param) {
				var rows = MarkRuleGrid.getRows();
				var row = rows[MarkRuleGrid.editIndex];
				if (!isEmpty(row)) {
					param.Params = JSON.stringify(addSessionParams({BDPHospital:HospId}));
				}
			},
			onSelect:function(record){
				var rows =MarkRuleGrid.getRows();
				var row = rows[MarkRuleGrid.editIndex];
				row.MtDesc=record.Description;
			},
			onShowPanel: function () {
				$(this).combobox('clear');
				$(this).combobox('reload')
			}
		}
	};
	var ComboxParams= JSON.stringify(addSessionParams({BDPHospital:HospId}));
	/*var MarkTypeCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetMarkType&ResultSetType=array&Params='+ComboxParams,
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote'
		}
	}*/
	//小数规则
	var StkDecimalCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkDecimal&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote',
			onBeforeLoad: function (param) {
				var rows = MarkRuleGrid.getRows();
				var row = rows[MarkRuleGrid.editIndex];
				if (!isEmpty(row)) {
					param.Params = JSON.stringify(addSessionParams({BDPHospital:HospId}));
	}
			},
			onSelect:function(record){
				var rows =MarkRuleGrid.getRows();
				var row = rows[MarkRuleGrid.editIndex];
				row.SdDesc=record.Description;
			},
			onShowPanel: function () {
				$(this).combobox('clear');
				$(this).combobox('reload')
			}
		}
	};
	/*var StkDecimalCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkDecimal&ResultSetType=array&Params='+ComboxParams,
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote'
		}
	}*/

	var MarkRuleBar = [{
		text: '新增',
		iconCls: 'icon-add',
		handler: function () {
			MarkRuleGrid.commonAddRow();
		}
	}, {
		text: '保存',
		iconCls: 'icon-save',
		handler: function () {
			var Rows = MarkRuleGrid.getChangesData();
			if (Rows === false){	//未完成编辑或明细为空
				return;
			}
			if (isEmpty(Rows)){	//明细不变
				$UI.msg("alert", "没有需要保存的明细!");
				return;
			}
			var MainObj = JSON.stringify(addSessionParams({BDPHospital:HospId}));
			$.cm({
				ClassName: 'web.DHCSTMHUI.MarkRule',
				MethodName: 'Save',
				Main: MainObj,
				Params: JSON.stringify(Rows)
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					FindAllMarkRule();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			})
		}
	}, {
		text: '查询',
		iconCls: 'icon-search',
		handler: function () {
			FindAllMarkRule();
		}
	}, {
		text: '页面说明',
		iconCls: 'icon-help',
		handler: function () {
			var href = "../scripts/dhcstmhisui/help/定价类型简要说明.htm"
			$('#myWindow').window({
				title: "定价类型说明文档",
				width: gWinWidth,
				height: gWinHeight,
				content: '<iframe scrolling="yes" frameborder="0"  src="' + href + '" style="width:100%;height:98%;"></iframe>'
			})
		}
	}
	];

	var MarkRuleCm = [[{
		title: 'RowId',
		field: 'RowId',
		width: 150,
		hidden: true
	}, {
		title: '代码',
		field: 'Code',
		width: 100,
		editor: { type: 'validatebox', options: { required: true } }
	}, {
		title: '描述',
		field: 'Desc',
		width: 150,
		editor: { type: 'validatebox', options: { required: true } }
	}, {
		title: '规则下限',
		field: 'MinRp',
		width: 100,
		editor: { type: 'numberbox', options: { required: true } }
	}, {
		title: '规则上限',
		field: 'MaxRp',
		width: 100,
		editor: { type: 'numberbox', options: { required: true } }
	}, {
		title: '加成率',
		field: 'Margin',
		width: 100,
		editor: { type: 'numberbox', options: { required: true } }
	}, {
		title: '加成额',
		field: 'MPrice',
		width: 100,
		editor: { type: 'numberbox', options: { required: true } }
	}, {
		title: '最高加成比',
		field: 'MaxMargin',
		width: 100,
		editor: { type: 'numberbox', options: { required: true } }
	}, {
		title: '最高加成额',
		field: 'MaxMPrice',
		width: 100,
		editor: { type: 'numberbox', options: { required: true } }
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
		width: 50,
		editor: { type: 'checkbox', options: { on: 'Y', off: 'N' } },
		formatter: BoolFormatter
	}, {
		title: '备注',
		field: 'Remark',
		width: 50,
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
		onClickCell: function (index, filed, value) {
			var Row = MarkRuleGrid.getRows()[index]
			var Parref = Row.RowId;
			if (!isEmpty(Parref)) {
				FindItmRByParref(Parref);
			}
			MarkRuleGrid.commonClickCell(index, filed)
		}
	})

	var MarkRuleItmBar = [{
		text: '新增',
		iconCls: 'icon-add',
		handler: function () {
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
		handler: function () {
			var Rows = MarkRuleItmGrid.getChangesData();
			var Selected = MarkRuleGrid.getSelected();
			var PRowId = Selected.RowId;
			if (Rows === false){	//未完成编辑或明细为空
				return;
			}
			if (isEmpty(Rows)){	//明细不变
				$UI.msg("alert", "没有需要保存的明细!");
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.MarkRuleAdd',
				MethodName: 'Save',
				PRowId: PRowId,
				Params: JSON.stringify(Rows)
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					MarkRuleItmGrid.reload()
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	}, {
		text: '删除',
		iconCls: 'icon-remove',
		handler: function () {
			var Rows = MarkRuleItmGrid.getSelectedData("RowId")
			if (isEmpty(Rows)) {
				MarkRuleItmGrid.commonDeleteRow();
				//$UI.msg('alert', '请选操作数据!');
				return false;
			}
			var RowId = Rows[0].RowId;
			if (isEmpty(RowId)) {
				return false;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.MarkRuleAdd',
				MethodName: 'Delete',
				RowId: RowId
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					MarkRuleItmGrid.reload()
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	}
	];
	var MarkRuleItmCm = [[{
		title: 'RowId',
		field: 'RowId',
		hidden: true,
		width: 100
	}, {
		title: '代码',
		field: 'Code',
		width: 100,
		editor: { type: 'validatebox', options: { required: true } }
	}, {
		title: '描述',
		field: 'Desc',
		width: 150,
		editor: { type: 'validatebox', options: { required: true } }
	}, {
		title: '下限',
		field: 'MinRp',
		width: 100,
		editor: { type: 'numberbox', options: { required: true } }
	}, {
		title: '上限',
		field: 'MaxRp',
		width: 100,
		editor: { type: 'numberbox', options: { required: true } }
	}, {
		title: '加成率',
		field: 'Margin',
		width: 100,
		editor: { type: 'numberbox', options: { required: true } }
	}, {
		title: '是否使用',
		field: 'UseFlag',
		width: 50,
		editor: { type: 'checkbox', options: { on: 'Y', off: 'N' } },
		formatter: BoolFormatter
	}, {
		title: '备注',
		field: 'Remark',
		width: 50,
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
		onClickCell: function (index, field, value) {
			var Row = MarkRuleItmGrid.getRows()[index]
			MarkRuleItmGrid.commonClickCell(index, field)
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
}
$(init);