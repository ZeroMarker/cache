var init = function() {
	var HospId = gHospId;
	var TableName = 'CSSD_CleanType';
	var TableType = '';
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
		if (TableName == 'CSSD_CleanType') {
			CleanModeGrid.load({
				ClassName: 'web.CSSDHUI.System.CleanType',
				QueryName: 'SelectAllCleanType',
				Params: Params,
				rows: 99999
			});
		} else if (TableName == 'CSSD_SterType') {
			SterModeGrid.load({
				ClassName: 'web.CSSDHUI.System.SterType',
				QueryName: 'SelectAllSterType',
				Params: Params,
				rows: 99999
			});
		} else if (TableName == 'CSSD_BaseCode') {
			if (TableType == 'CleanProcess') {
				CleanSystemGrid.load({
					ClassName: 'web.CSSDHUI.System.CleanProcedures',
					QueryName: 'SelectAllCleanProcedures',
					Params: Params,
					rows: 99999
				});
			} else if (TableType == 'SterProcess') {
				SterilizationSysGrid.load({
					ClassName: 'web.CSSDHUI.System.SterilizationSys',
					QueryName: 'SelectAllSterilizationSys',
					Params: Params,
					rows: 99999
				});
			}
		} else if (TableName == 'CSSD_SteCheckReason') {
			ReasonForSteriFailGrid.load({
				ClassName: 'web.CSSDHUI.System.ReasonForSteriFail',
				QueryName: 'SelectAllReasonForSteriFail',
				Params: Params,
				rows: 99999
			});
		} else if (TableName == 'CSSD_CleanItmReason') {
			ReasonForCleanFailGrid.load({
				ClassName: 'web.CSSDHUI.System.ReasonForCleanFail',
				QueryName: 'SelectAllReasonForCleanFail',
				Params: Params,
				rows: 99999
			});
		} else if (TableName == 'CSSD_MachineConsumeReason') {
			ReasonForConsumeGrid.load({
				ClassName: 'web.CSSDHUI.System.ReasonForConsume',
				QueryName: 'SelectAllReasonForConsume',
				Params: Params,
				rows: 99999
			});
		} else if (TableName == 'CSSD_RecallReason') {
			ReasonForRecallGrid.load({
				ClassName: 'web.CSSDHUI.System.ReasonForRecall',
				QueryName: 'SelectAllReasonForRecall',
				Params: Params,
				rows: 99999
			});
		} else if (TableName == 'CSSD_Material') {
			MaterialInfoGrid.load({
				ClassName: 'web.CSSDHUI.PackageInfo.PackageMatCompare',
				QueryName: 'SelectMaterialInfo',
				Params: Params,
				rows: 99999
			});
		} else if (TableName == 'CT_STER_CSSD.PackageSpec') {
			PackageSpecGrid.load({
				ClassName: 'web.CSSDHUI.System.PackageSpec',
				QueryName: 'SelectAllPackageSpec',
				Params: Params,
				rows: 99999
			});
		} else if (TableName == 'CT_STER_CSSD.Satisfaction') {
			SatisfactionGrid.load({
				ClassName: 'web.CSSDHUI.System.Satisfaction',
				QueryName: 'SelectAllSatisfaction',
				Params: Params,
				rows: 99999
			});
		} else if (TableName == 'CSSD_DeptCenter') {
			SupplyCenterGrid.load({
				ClassName: 'web.CSSDHUI.System.SupplyCenter',
				QueryName: 'SelectAllSupplyCenter',
				Params: Params,
				rows: 99999
			});
		} else if (TableName == 'CSSD_BindLoc') {
			BindLocGrid.load({
				ClassName: 'web.CSSDHUI.System.BindLoc',
				QueryName: 'SelectAllBindLoc',
				Params: Params,
				rows: 99999
			});
		} else if (TableName == 'CT_STER_CSSD.PrintRules') {
			PrintRulesGrid.load({
				ClassName: 'web.CSSDHUI.System.PrintRules',
				QueryName: 'SelectAllPrintRules',
				rows: 99999
			});
		} else if (TableName == 'CF_STER_CSSD.LocHospPrintRules') {
			LocPrintRulesGrid.load({
				ClassName: 'web.CSSDHUI.System.LocPrintRules',
				QueryName: 'SelectAllLocPrintRules',
				row: 99999
			});
		}
	}

	$HUI.tabs('#DetailTabs', {
		onSelect: function(title, index) {
			TableName = '';
			TableType = '';
			if (title == '清洗方式') {
				TableName = 'CSSD_CleanType';
			} else if (title == '灭菌方式') {
				TableName = 'CSSD_SterType';
			} else if (title == '清洗程序') {
				TableName = 'CSSD_BaseCode';
				TableType = 'CleanProcess';
			} else if (title == '灭菌程序') {
				TableName = 'CSSD_BaseCode';
				TableType = 'SterProcess';
			} else if (title == '灭菌不合格原因') {
				TableName = 'CSSD_SteCheckReason';
			} else if (title == '清洗不合格原因') {
				TableName = 'CSSD_CleanItmReason';
			} else if (title == '器械报损原因') {
				TableName = 'CSSD_MachineConsumeReason';
			} else if (title == '消毒包召回原因') {
				TableName = 'CSSD_RecallReason';
			} else if (title == '包装材料') {
				TableName = 'CSSD_Material';
			} else if (title == '消毒包规格') {
				TableName = 'CT_STER_CSSD.PackageSpec';
			} else if (title == '满意度调查项目') {
				TableName = 'CT_STER_CSSD.Satisfaction';
			} else if (title == '供应中心') {
				TableName = 'CSSD_DeptCenter';
			} else if (title == '科室类型') {
				TableName = 'CSSD_BindLoc';
			} else if (title == '打印规则') {
				TableName = 'CT_STER_CSSD.PrintRules';
			} else if (title == '医院科室打印规则') {
				TableName = 'CF_STER_CSSD.LocHospPrintRules';
			}
			InitHosp();
		}
	});

	// 清洗方式
	function PrintCleanType() {
		var rowMain = $('#CleanModeGrid').datagrid('getSelected');
		if (isEmpty(rowMain)) {
			$UI.msg('alert', '请选择要打印的数据!');
			return;
		}
		printCodeDict(rowMain.CleanTypeCode, rowMain.CleanTypeDesc);
	}
	var CleanModeGrid = $UI.datagrid('#CleanModeGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.CleanType',
			QueryName: 'SelectAllCleanType',
			rows: 99999
		},
		fitColumns: true,
		toolbar: [{
			text: '打印',
			iconCls: 'icon-print',
			handler: function() {
				PrintCleanType();
			}
		}],

		beforeAddFn: function() {
			var DefaultData = { UseFlag: 'Y' };
			return DefaultData;
		},
		beforeDelFn: function() {
			var rowMain = $('#CleanModeGrid').datagrid('getSelected');
			if (!isEmpty(rowMain)) {
				var ID = rowMain.RowId;
			}
			if (!isEmpty(rowMain) && !isEmpty(ID)) {
				$UI.msg('alert', '已维护清洗方式只能停用,不能删除');
				return false;
			}
		},
		saveDataFn: function() {
			var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var Rows = CleanModeGrid.getChangesData();
			if (isEmpty(Rows)) {
				return;
			}
			if (Rows == false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.System.CleanType',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows),
				Others: Others
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', '保存成功！');
					CleanModeGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		columns: [[
			{
				title: 'RowId',
				align: 'right',
				field: 'RowId',
				width: 150,
				hidden: true
			}, {
				title: '代码',
				align: 'left',
				field: 'CleanTypeCode',
				width: 100,
				editor: { type: 'validatebox', options: { required: true }}
			}, {
				title: '描述',
				align: 'left',
				field: 'CleanTypeDesc',
				width: 150,
				editor: { type: 'validatebox', options: { required: true }}
			}, {
				title: '是否手工清洗',
				align: 'center',
				field: 'ManualFlag',
				width: 100,
				editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }},
				formatter: BoolFormatter
			}, {
				title: '是否启用',
				align: 'center',
				field: 'UseFlag',
				width: 70,
				editor: { type: 'checkbox', check: 'checked', options: { on: 'Y', off: 'N' }},
				formatter: BoolFormatter
			}
		]],
		showAddSaveDelItems: true,
		pagination: false,
		remoteSort: false,
		checkField: 'CleanTypeCode',
		onClickRow: function(index, row) {
			CleanModeGrid.commonClickRow(index, row);
		}
	});

	// 灭菌方式
	function PrintSterType() {
		var rowMain = $('#SterModeGrid').datagrid('getSelected');
		if (isEmpty(rowMain)) {
			$UI.msg('alert', '请选择要打印的数据!');
			return;
		}
		printCodeDict(rowMain.SterTypeCode, rowMain.SterTypeDesc);
	}
	var SterModeGrid = $UI.datagrid('#SterModeGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.SterType',
			QueryName: 'SelectAllSterType',
			rows: 99999
		},
		toolbar: [{
			text: '打印',
			iconCls: 'icon-print',
			handler: function() {
				PrintSterType();
			}
		}],
		beforeAddFn: function() {
			var DefaultData = { UseFlag: 'Y' };
			return DefaultData;
		},
		beforeDelFn: function() {
			var rowMain = $('#SterModeGrid').datagrid('getSelected');
			if (!isEmpty(rowMain)) {
				var ID = rowMain.RowId;
			}
			if (!isEmpty(rowMain) && !isEmpty(ID)) {
				$UI.msg('alert', '已维护灭菌方式只能停用,不能删除');
				return false;
			}
		},
		saveDataFn: function() {
			var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var Rows = SterModeGrid.getChangesData();
			if (isEmpty(Rows)) {
				return;
			}
			if (Rows == false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.System.SterType',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows),
				Others: Others
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', '保存成功！');
					SterModeGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		columns: [[
			{
				title: 'RowId',
				align: 'right',
				field: 'RowId',
				width: 150,
				hidden: true
			}, {
				title: '代码',
				align: 'left',
				field: 'SterTypeCode',
				width: 100,
				editor: { type: 'validatebox', options: { required: true }}
			}, {
				title: '描述',
				align: 'left',
				field: 'SterTypeDesc',
				width: 150,
				editor: { type: 'validatebox', options: { required: true }}
			}, {
				title: '灭菌展示颜色',
				field: 'DisplayColor',
				width: 100,
				editor: { type: 'colorpicker' },
				styler: function(value, row, index) {
					if (!isEmpty(value)) {
						return 'background-color:' + value + ';' + 'color:' + GetFontColor(value);
					}
				},
				align: 'center'
			}, {
				title: '是否使用灭菌器',
				align: 'center',
				field: 'SterFlag',
				width: 120,
				editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }},
				formatter: BoolFormatter
			}, {
				title: '是否低温灭菌',
				align: 'center',
				field: 'LowerTempFlag',
				width: 120,
				editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }},
				formatter: BoolFormatter
			}, {
				title: '是否启用',
				align: 'center',
				field: 'UseFlag',
				width: 70,
				editor: { type: 'checkbox', check: 'checked', options: { on: 'Y', off: 'N' }},
				formatter: BoolFormatter
			}
		]],
		pagination: false,
		showAddSaveDelItems: true,
		checkField: 'SterTypeCode',
		fitColumns: true,
		onClickRow: function(index, row) {
			SterModeGrid.commonClickRow(index, row);
		}
	});

	// 清洗程序
	function PrintCleanProce() {
		var rowMain = $('#CleanSystemGrid').datagrid('getSelected');
		if (isEmpty(rowMain)) {
			$UI.msg('alert', '请选择要打印的数据!');
			return;
		}
		printCodeDict(rowMain.CleanProCode, rowMain.CleanProDesc);
	}
	var CleanSystemGrid = $UI.datagrid('#CleanSystemGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.CleanProcedures',
			QueryName: 'SelectAllCleanProcedures',
			rows: 99999
		},
		toolbar: [{
			text: '打印',
			iconCls: 'icon-print',
			handler: function() {
				PrintCleanProce();
			}
		}],
		beforeAddFn: function() {
			var DefaultData = { UseFlag: 'Y' };
			return DefaultData;
		},
		beforeDelFn: function() {
			var rowMain = $('#CleanSystemGrid').datagrid('getSelected');
			if (!isEmpty(rowMain)) {
				var ID = rowMain.RowId;
			}
			if (!isEmpty(rowMain) && !isEmpty(ID)) {
				$UI.msg('alert', '已维护清洗程序只能停用,不能删除');
				return false;
			}
		},
		saveDataFn: function() {
			var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var Rows = CleanSystemGrid.getChangesData();
			if (isEmpty(Rows)) {
				return;
			}
			if (Rows == false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.System.CleanProcedures',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows),
				Others: Others
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', '保存成功！');
					CleanSystemGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		columns: [[
			{
				title: 'RowId',
				align: 'right',
				field: 'RowId',
				width: 100,
				hidden: true
			}, {
				title: '代码',
				align: 'left',
				field: 'CleanProCode',
				width: 100,
				editor: { type: 'validatebox', options: { required: true }}
			}, {
				title: '描述',
				align: 'left',
				field: 'CleanProDesc',
				width: 100,
				editor: { type: 'validatebox', options: { required: true }}
			}, {
				title: '验收时长(分钟)',
				field: 'Interval',
				align: 'right',
				width: 120,
				editor: {
					type: 'numberbox',
					options: {
						min: 0
					}
				}
			}, {
				title: '是否启用',
				align: 'center',
				field: 'UseFlag',
				width: 70,
				editor: { type: 'checkbox', check: 'checked', options: { on: 'Y', off: 'N' }},
				formatter: BoolFormatter
			}
		]],
		showAddSaveDelItems: true,
		pagination: false,
		remoteSort: false,
		checkField: 'CleanProCode',
		fitColumns: true,
		onClickRow: function(index, row) {
			CleanSystemGrid.commonClickRow(index, row);
		}
	});

	// 灭菌程序
	function PrintSteProce() {
		var rowMain = $('#SterilizationSysGrid').datagrid('getSelected');
		if (isEmpty(rowMain)) {
			$UI.msg('alert', '请选择要打印的数据!');
			return;
		}
		printCodeDict(rowMain.SterProCode, rowMain.SterProDesc);
	}
	// 灭菌方式下拉数据
	var SterTypeCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetSterType&ResultSetType=array&isSter=Y',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect: function(record) {
				var rows = SterilizationSysGrid.getRows();
				var row = rows[SterilizationSysGrid.editIndex];
				row.SterTypeDesc = record.Description;
			},
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			}
		}
	};
	var SterilizationSysGrid = $UI.datagrid('#SterilizationSysGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.SterilizationSys',
			QueryName: 'SelectAllSterilizationSys',
			rows: 99999
		},
		toolbar: [
			{
				text: '打印',
				iconCls: 'icon-print',
				handler: function() {
					PrintSteProce();
				}
			}
		],
		beforeAddFn: function() {
			var DefaultData = { UseFlag: 'Y' };
			return DefaultData;
		},
		beforeDelFn: function() {
			var rowMain = $('#SterilizationSysGrid').datagrid('getSelected');
			if (!isEmpty(rowMain)) {
				var Id = rowMain.RowId;
			}
			if (!isEmpty(rowMain) && !isEmpty(Id)) {
				$UI.msg('alert', '已维护灭菌程序只能停用,不能删除');
				return false;
			}
		},
		saveDataFn: function() {
			var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var Rows = SterilizationSysGrid.getChangesData();
			if (isEmpty(Rows)) {
				return;
			}
			if (Rows == false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.System.SterilizationSys',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows),
				Others: Others
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', '保存成功！');
					SterilizationSysGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		columns: [[
			{
				title: 'RowId',
				align: 'right',
				field: 'RowId',
				width: 100,
				hidden: true
			}, {
				title: '代码',
				align: 'left',
				field: 'SterProCode',
				width: 100,
				editor: { type: 'validatebox', options: { required: true }}
			}, {
				title: '描述',
				align: 'left',
				field: 'SterProDesc',
				width: 100,
				editor: { type: 'validatebox', options: { required: true }}
			}, {
				title: '灭菌方式',
				align: 'left',
				field: 'SterType',
				width: 100,
				formatter: CommonFormatter(SterTypeCombox, 'SterType', 'SterTypeDesc'),
				editor: SterTypeCombox
			}, {
				title: '验收时长(分钟)',
				align: 'right',
				field: 'Interval',
				width: 120,
				editor: {
					type: 'numberbox',
					options: {
						min: 0
					}
				}
			}, {
				title: '是否启用',
				align: 'center',
				field: 'UseFlag',
				width: 70,
				editor: { type: 'checkbox', check: 'checked', options: { on: 'Y', off: 'N' }},
				formatter: BoolFormatter
			}
		]],
		showAddSaveDelItems: true,
		pagination: false,
		remoteSort: false,
		checkField: 'SterProCode',
		fitColumns: true,
		onClickRow: function(index, row) {
			SterilizationSysGrid.commonClickRow(index, row);
		}
	});

	// 灭菌不合格原因
	var ReasonForSteriFailGrid = $UI.datagrid('#ReasonForSteriFailGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.ReasonForSteriFail',
			QueryName: 'SelectAllReasonForSteriFail',
			rows: 99999
		},
		beforeAddFn: function() {
			var DefaultData = { UseFlag: 'Y' };
			return DefaultData;
		},
		beforeDelFn: function() {
			var rowMain = $('#ReasonForSteriFailGrid').datagrid('getSelected');
			if (!isEmpty(rowMain)) {
				var Id = rowMain.RowId;
			}
			if (!isEmpty(rowMain) && !isEmpty(Id)) {
				$UI.msg('alert', '已维护灭菌不合格原因只能停用,不能删除');
				return false;
			}
		},
		saveDataFn: function() {
			var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var Rows = ReasonForSteriFailGrid.getChangesData();
			if (isEmpty(Rows)) {
				return;
			}
			if (Rows == false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.System.ReasonForSteriFail',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows),
				Others: Others
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', '保存成功！');
					ReasonForSteriFailGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		columns: [[
			{
				title: 'RowId',
				align: 'right',
				field: 'RowId',
				width: 100,
				hidden: true
			}, {
				title: '代码',
				align: 'left',
				field: 'SteReasonCode',
				width: 100,
				editor: { type: 'validatebox', options: { required: true }}
			}, {
				title: '描述',
				align: 'left',
				field: 'SteReasonDesc',
				width: 200,
				editor: { type: 'validatebox', options: { required: true }}
			}, {
				title: '是否启用',
				align: 'center',
				field: 'UseFlag',
				width: 70,
				editor: { type: 'checkbox', check: 'checked', options: { on: 'Y', off: 'N' }},
				formatter: BoolFormatter
			}
		]],
		showAddSaveDelItems: true,
		pagination: false,
		remoteSort: false,
		checkField: 'SteReasonCode',
		fitColumns: true,
		onClickRow: function(index, row) {
			ReasonForSteriFailGrid.commonClickRow(index, row);
		}
	});

	// 清洗不合格原因
	var ReasonForCleanFailGrid = $UI.datagrid('#ReasonForCleanFailGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.ReasonForCleanFail',
			QueryName: 'SelectAllReasonForCleanFail',
			rows: 99999
		},
		beforeAddFn: function() {
			var DefaultData = { UseFlag: 'Y' };
			return DefaultData;
		},
		beforeDelFn: function() {
			var rowMain = $('#ReasonForCleanFailGrid').datagrid('getSelected');
			if (!isEmpty(rowMain)) {
				var ID = rowMain.RowId;
			}
			if (!isEmpty(rowMain) && !isEmpty(ID)) {
				$UI.msg('alert', '已维护清洗不合格原因只能停用,不能删除');
				return false;
			}
		},
		saveDataFn: function() {
			var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var Rows = ReasonForCleanFailGrid.getChangesData();
			if (isEmpty(Rows)) {
				return;
			}
			if (Rows == false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.System.ReasonForCleanFail',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows),
				Others: Others
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', '保存成功！');
					ReasonForCleanFailGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		columns: [[
			{
				title: 'RowId',
				align: 'right',
				field: 'RowId',
				width: 100,
				hidden: true
			}, {
				title: '代码',
				align: 'left',
				field: 'CleanReasonCode',
				width: 100,
				editor: { type: 'validatebox', options: { required: true }}
			}, {
				title: '描述',
				align: 'left',
				field: 'CleanReasonDesc',
				width: 150,
				editor: { type: 'validatebox', options: { required: true }}
			}, {
				title: '是否启用',
				align: 'center',
				field: 'UseFlag',
				width: 70,
				editor: { type: 'checkbox', check: 'checked', options: { on: 'Y', off: 'N' }},
				formatter: BoolFormatter
			}
		]],
		showAddSaveDelItems: true,
		pagination: false,
		remoteSort: false,
		checkField: 'CleanReasonCode',
		fitColumns: true,
		onClickRow: function(index, row) {
			ReasonForCleanFailGrid.commonClickRow(index, row);
		}
	});

	// 器材报损原因
	var ReasonForConsumeGrid = $UI.datagrid('#ReasonForConsumeGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.ReasonForConsume',
			QueryName: 'SelectAllReasonForConsume',
			rows: 99999
		},
		beforeAddFn: function() {
			var DefaultData = { UseFlag: 'Y' };
			return DefaultData;
		},
		beforeDelFn: function() {
			var rowMain = $('#ReasonForConsumeGrid').datagrid('getSelected');
			if (!isEmpty(rowMain)) {
				var Id = rowMain.RowId;
			}
			if (!isEmpty(rowMain) && !isEmpty(Id)) {
				$UI.msg('alert', '已维护报损原因只能停用,不能删除');
				return false;
			}
		},
		saveDataFn: function() {
			var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var Rows = ReasonForConsumeGrid.getChangesData();
			if (isEmpty(Rows)) {
				return;
			}
			if (Rows == false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.System.ReasonForConsume',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows),
				Others: Others
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', '保存成功！');
					ReasonForConsumeGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		columns: [[
			{
				title: 'RowId',
				align: 'right',
				field: 'RowId',
				width: 100,
				hidden: true
			}, {
				title: '代码',
				align: 'left',
				field: 'ConsumeReasonCode',
				width: 100,
				editor: { type: 'validatebox', options: { required: true }}
			}, {
				title: '描述',
				align: 'left',
				field: 'ConsumeReasonDesc',
				width: 150,
				editor: { type: 'validatebox', options: { required: true }}
			}, {
				title: '是否启用',
				align: 'center',
				field: 'UseFlag',
				width: 70,
				editor: { type: 'checkbox', check: 'checked', options: { on: 'Y', off: 'N' }},
				formatter: BoolFormatter
			}
		]],
		showAddSaveDelItems: true,
		pagination: false,
		remoteSort: false,
		checkField: 'ConsumeReasonCode',
		fitColumns: true,
		onClickRow: function(index, row) {
			ReasonForConsumeGrid.commonClickRow(index, row);
		}
	});

	// 消毒包召回原因
	var ReasonForRecallGrid = $UI.datagrid('#ReasonForRecallGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.ReasonForRecall',
			QueryName: 'SelectAllReasonForRecall',
			rows: 99999
		},
		beforeAddFn: function() {
			var DefaultData = { UseFlag: 'Y' };
			return DefaultData;
		},
		beforeDelFn: function() {
			var rowMain = $('#ReasonForRecallGrid').datagrid('getSelected');
			if (!isEmpty(rowMain)) {
				var Id = rowMain.RowId;
			}
			if (!isEmpty(rowMain) && !isEmpty(Id)) {
				$UI.msg('alert', '已维护召回原因只能停用,不能删除');
				return false;
			}
		},
		saveDataFn: function() {
			var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var Rows = ReasonForRecallGrid.getChangesData();
			if (isEmpty(Rows)) {
				return;
			}
			if (Rows == false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.System.ReasonForRecall',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows),
				Others: Others
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', '保存成功！');
					ReasonForRecallGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		columns: [[
			{
				title: 'RowId',
				align: 'right',
				field: 'RowId',
				width: 100,
				hidden: true
			}, {
				title: '代码',
				align: 'left',
				field: 'RecallReasonCode',
				width: 100,
				editor: { type: 'validatebox', options: { required: true }}
			}, {
				title: '描述',
				align: 'left',
				field: 'RecallReasonDesc',
				width: 150,
				editor: { type: 'validatebox', options: { required: true }}
			}, {
				title: '是否启用',
				align: 'center',
				field: 'UseFlag',
				width: 70,
				editor: { type: 'checkbox', check: 'checked', options: { on: 'Y', off: 'N' }},
				formatter: BoolFormatter
			}
		]],
		showAddSaveDelItems: true,
		pagination: false,
		remoteSort: false,
		checkField: 'RecallReasonCode',
		fitColumns: true,
		onClickRow: function(index, row) {
			ReasonForRecallGrid.commonClickRow(index, row);
		}
	});

	// 包装材料
	var MaterialInfoGrid = $UI.datagrid('#MaterialInfoGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.PackageMatCompare',
			QueryName: 'SelectMaterialInfo',
			rows: 99999
		},
		beforeAddFn: function() {
			var DefaultData = { UseFlag: 'Y' };
			return DefaultData;
		},
		beforeDelFn: function() {
			var rowMain = $('#MaterialInfoGrid').datagrid('getSelected');
			if (!isEmpty(rowMain)) {
				var Id = rowMain.RowId;
			}
			if (!isEmpty(rowMain) && !isEmpty(Id)) {
				$UI.msg('alert', '已维护包装材料只能停用,不能删除');
				return false;
			}
		},
		saveDataFn: function() {
			var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var Rows = MaterialInfoGrid.getChangesData();
			if (isEmpty(Rows)) {
				return;
			}
			if (Rows == false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.PackageInfo.PackageMatCompare',
				MethodName: 'jsSaveMaterialInfo',
				Params: JSON.stringify(Rows),
				Others: Others
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', '保存成功！');
					MaterialInfoGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		columns: [[
			{
				title: 'RowId',
				align: 'right',
				field: 'RowId',
				width: 100,
				hidden: true
			}, {
				title: '代码',
				align: 'left',
				field: 'MaterialCode',
				width: 100,
				editor: { type: 'validatebox', options: { required: true }}
			}, {
				title: '描述',
				align: 'left',
				field: 'MaterialDesc',
				width: 150,
				editor: { type: 'validatebox', options: { required: true }}
			}, {
				title: '有效期天数',
				align: 'right',
				field: 'ExpLength',
				width: 100,
				editor: { type: 'numberbox', options: { required: false, min: 1 }}
			}, {
				title: '是否启用',
				align: 'center',
				field: 'UseFlag',
				width: 70,
				editor: { type: 'checkbox', check: 'checked', options: { on: 'Y', off: 'N' }},
				formatter: BoolFormatter
			}
		]],
		showAddSaveDelItems: true,
		pagination: false,
		remoteSort: false,
		checkField: 'MaterialCode',
		fitColumns: true,
		onClickRow: function(index, row) {
			MaterialInfoGrid.commonClickRow(index, row);
		}
	});

	// 消毒包规格
	var PackageSpecGrid = $UI.datagrid('#PackageSpecGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.PackageSpec',
			QueryName: 'SelectAllPackageSpec',
			rows: 99999
		},
		beforeAddFn: function() {
			var DefaultData = { UseFlag: 'Y' };
			return DefaultData;
		},
		beforeDelFn: function() {
			var rowMain = $('#PackageSpecGrid').datagrid('getSelected');
			if (!isEmpty(rowMain)) {
				var Id = rowMain.RowId;
			}
			if (!isEmpty(rowMain) && !isEmpty(Id)) {
				$UI.msg('alert', '已维护规格只能停用,不能删除');
				return false;
			}
		},
		saveDataFn: function() {
			var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var Rows = PackageSpecGrid.getChangesData();
			if (isEmpty(Rows)) {
				return;
			}
			if (Rows == false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.System.PackageSpec',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows),
				Others: Others
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', '保存成功！');
					PackageSpecGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		columns: [[
			{
				title: 'RowId',
				align: 'right',
				field: 'RowId',
				width: 100,
				hidden: true
			}, {
				title: '代码',
				align: 'left',
				field: 'SpecCode',
				width: 100,
				editor: { type: 'validatebox', options: { required: true }}
			}, {
				title: '描述',
				align: 'left',
				field: 'SpecDesc',
				width: 150,
				editor: { type: 'validatebox', options: { required: true }}
			}, {
				title: '是否启用',
				align: 'center',
				field: 'UseFlag',
				width: 70,
				editor: { type: 'checkbox', check: 'checked', options: { on: 'Y', off: 'N' }},
				formatter: BoolFormatter
			}
		]],
		showAddSaveDelItems: true,
		pagination: false,
		remoteSort: false,
		checkField: 'SpecCode',
		fitColumns: true,
		onClickRow: function(index, row) {
			PackageSpecGrid.commonClickRow(index, row);
		}
	});

	// 满意度调查项目
	var TypeData = [{ 'SatisfactionType': 'I', 'SatisfactionTypeDesc': '输入框' }, { 'SatisfactionType': 'R', 'SatisfactionTypeDesc': '勾选框' }];
	var TypeCombox = {
		type: 'combobox',
		options: {
			data: TypeData,
			valueField: 'SatisfactionType',
			textField: 'SatisfactionTypeDesc',
			required: true
		}
	};
	var SatisfactionGrid = $UI.datagrid('#SatisfactionGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.Satisfaction',
			QueryName: 'SelectAllSatisfaction',
			rows: 99999
		},
		beforeAddFn: function() {
			var DefaultData = { UseFlag: 'Y' };
			return DefaultData;
		},
		beforeDelFn: function() {
			var rowMain = $('#SatisfactionGrid').datagrid('getSelected');
			if (!isEmpty(rowMain)) {
				var Id = rowMain.RowId;
			}
			if (!isEmpty(rowMain) && !isEmpty(Id)) {
				$UI.msg('alert', '已维护满意度项目只能停用,不能删除');
				return false;
			}
		},
		saveDataFn: function() {
			var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var Rows = SatisfactionGrid.getChangesData();
			if (isEmpty(Rows)) return;
			if (Rows == false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.System.Satisfaction',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows),
				Others: Others
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', '保存成功！');
					SatisfactionGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		columns: [[
			{
				title: 'RowId',
				align: 'right',
				field: 'RowId',
				width:	150,
				hidden: true
			}, {
				title: '代码',
				align: 'left',
				field: 'SatisfactionCode',
				width:	100,
				editor: { type: 'validatebox', options: { required: true }}
			}, {
				title: '描述',
				align: 'left',
				field: 'SatisfactionDesc',
				width:	300,
				editor: { type: 'validatebox', options: { required: true }}
			}, {
				title: '类型',
				align: 'left',
				field: 'SatisfactionType',
				width: 80,
				formatter: CommonFormatter(TypeCombox, 'SatisfactionType', 'SatisfactionTypeDesc'),
				editor: TypeCombox
			}, {
				title: '是否启用',
				align: 'center',
				field: 'UseFlag',
				width:	70,
				editor: { type: 'checkbox', check: 'checked', options: { on: 'Y', off: 'N' }},
				formatter: BoolFormatter
			}
		]],
		showAddSaveDelItems: true,
		pagination: false,
		remoteSort: false,
		checkField: 'SatisfactionCode',
		fitColumns: true,
		onClickRow: function(index, row) {
			SatisfactionGrid.commonClickRow(index, row);
		}
	});

	// 供应中心维护
	var SupLocBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: HospId })),
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect: function(record) {
				var rows = SupplyCenterGrid.getRows();
				var row = rows[SupplyCenterGrid.editIndex];
				row.SupLocDesc = record.Description;
			}
		}
	};
	var SupplyCenterGrid = $UI.datagrid('#SupplyCenterGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.SupplyCenter',
			QueryName: 'SelectAllSupplyCenter',
			rows: 99999
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.System.SupplyCenter',
			MethodName: 'jsDelete'
		},
		saveDataFn: function() {
			var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var Rows = SupplyCenterGrid.getChangesData();
			if (isEmpty(Rows)) return;
			if (Rows == false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.System.SupplyCenter',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows),
				Others: Others
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', '保存成功！');
					SupplyCenterGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		columns: [[
			{
				title: 'RowId',
				align: 'right',
				field: 'RowId',
				width: 100,
				saveCol: true,
				hidden: true
			}, {
				title: '科室',
				align: 'left',
				field: 'SupLocId',
				width: 200,
				saveCol: true,
				formatter: CommonFormatter(SupLocBox, 'SupLocId', 'SupLocDesc'),
				editor: SupLocBox
			}, {
				title: '医院',
				align: 'left',
				field: 'HospDesc',
				width: 200
			}
		]],
		singleSelect: false,
		showAddSaveDelItems: true,
		pagination: false,
		remoteSort: false,
		checkField: 'SupLocId',
		fitColumns: true,
		onClickRow: function(index, row) {
			SupplyCenterGrid.commonClickRow(index, row);
		}
	});

	var SupLocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ Type: 'SupLoc' })),
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect: function(record) {
				var rows = BindLocGrid.getRows();
				var row = rows[BindLocGrid.editIndex];
				row.SupLocDesc = record.Description;
			}
		}
	};
	var LocComBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: HospId })),
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect: function(record) {
				var rows = BindLocGrid.getRows();
				var row = rows[BindLocGrid.editIndex];
				row.LocDesc = record.Description;
			}
		}
	};
	var BindLocGrid = $UI.datagrid('#BindLocGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.BindLoc',
			QueryName: 'SelectAllBindLoc',
			rows: 99999
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.System.BindLoc',
			MethodName: 'jsDelete'
		},
		beforeAddFn: function() {
			var DefaultData = { UseFlag: 'Y' };
			return DefaultData;
		},
		saveDataFn: function() {
			BindLocGrid.endEditing();
			var RowData = BindLocGrid.getRows();
			var Len = RowData.length;
			var RecCount = 0;
			for (var i = 0; i < Len; i++) {
				var row = RowData[i];
				if (row['DefaultFlag'] == 'Y') {
					RecCount = RecCount + 1;
				}
			}
			if (RecCount > 1) {
				$UI.msg('alert', '只能设置一个默认值!');
				return;
			}
			var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var Rows = BindLocGrid.getChangesData();
			if (isEmpty(Rows)) {
				return;
			}
			if (Rows == false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.System.BindLoc',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows),
				Others: Others
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', '保存成功！');
					BindLocGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		columns: [[
			{
				title: 'RowId',
				align: 'right',
				field: 'RowId',
				width: 100,
				hidden: true
			}, {
				title: '供应科室',
				align: 'left',
				field: 'SupLocId',
				width: 150,
				formatter: CommonFormatter(SupLocCombox, 'SupLocId', 'SupLocDesc'),
				editor: SupLocCombox
			}, {
				title: '类型',
				align: 'left',
				field: 'TypeCode',
				width: 100,
				hidden: true
			}, {
				title: '科室',
				align: 'left',
				field: 'LocId',
				width: 150,
				formatter: CommonFormatter(LocComBox, 'LocId', 'LocDesc'),
				editor: LocComBox
			}, {
				title: '是否启用',
				align: 'center',
				field: 'UseFlag',
				width: 70,
				editor: { type: 'checkbox', check: 'checked', options: { on: 'Y', off: 'N' }},
				formatter: BoolFormatter
			}, {
				title: '是否默认',
				align: 'center',
				field: 'DefaultFlag',
				width: 70,
				editor: { type: 'checkbox', check: 'checked', options: { on: 'Y', off: 'N' }},
				formatter: BoolFormatter
			}
		]],
		showAddSaveDelItems: true,
		pagination: false,
		remoteSort: false,
		fitColumns: true,
		onClickCell: function(index, field, value) {
			BindLocGrid.commonClickCell(index, field, value);
		}
	});

	// 打印规则维护
	var PrintRulesGrid = $UI.datagrid('#PrintRulesGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.PrintRules',
			QueryName: 'SelectAllPrintRules',
			rows: 99999
		},
		saveDataFn: function() {
			var Rows = PrintRulesGrid.getChangesData();
			if (isEmpty(Rows)) {
				return;
			}
			if (Rows == false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.System.PrintRules',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', '保存成功！');
					PrintRulesGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		columns: [[
			{
				title: 'RowId',
				align: 'right',
				field: 'RowId',
				width: 100,
				hidden: true
			}, {
				title: '代码',
				align: 'left',
				field: 'PrintRulesCode',
				width: 120
			}, {
				title: '描述',
				align: 'left',
				field: 'PrintRulesDesc',
				width: 150,
				editor: { type: 'validatebox', options: { required: true }}
			}
		]],
		showSaveItems: true,
		pagination: false,
		remoteSort: false,
		fitColumns: true,
		onClickRow: function(index, row) {
			PrintRulesGrid.commonClickRow(index, row);
		}
	});

	// 医院科室打印规则维护
	var PHospId;
	var HospitalBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetHosp&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: HospId })),
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect: function(record) {
				PHospId = record.RowId;
				var LocEditor = $('#LocPrintRulesGrid').datagrid('getEditor', { index: LocPrintRulesGrid.editIndex, field: 'LocId' });
				LocEditor.target.combobox('setValue', '');
				record['LocId'] = '', record['LocDesc'] = '';
				var rows = LocPrintRulesGrid.getRows();
				var row = rows[LocPrintRulesGrid.editIndex];
				row.HospDesc = record.Description;
			}
		}
	};

	var LocParams = JSON.stringify(addSessionParams({ HospFlag: 1 }));
	var LocBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
			valueField: 'RowId',
			textField: 'Description',
			onShowPanel: function() {
				var Params = JSON.stringify(addSessionParams({ BDPHospital: PHospId, HospFlag: 2 }));
				var url = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + Params;
				$(this).combobox('reload', url);
			},
			onSelect: function(record) {
				var rows = LocPrintRulesGrid.getRows();
				var row = rows[LocPrintRulesGrid.editIndex];
				row.LocDesc = record.Description;
			}
		}
	};
	var PrintModeData = $.cm({
		ClassName: 'web.CSSDHUI.Common.Dicts',
		QueryName: 'GetPrintRules',
		ResultSetType: 'array'
	}, false);
	var PrintModeBox = {
		type: 'combobox',
		options: {
			data: PrintModeData,
			valueField: 'RowId',
			textField: 'Code',
			required: true
		}
	};
	var LocPrintRulesGrid = $UI.datagrid('#LocPrintRulesGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.LocPrintRules',
			QueryName: 'SelectAllLocPrintRules',
			rows: 99999
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.System.LocPrintRules',
			MethodName: 'jsDelete'
		},
		saveDataFn: function() {
			var Rows = LocPrintRulesGrid.getChangesData();
			if (isEmpty(Rows)) return;
			if (Rows == false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.System.LocPrintRules',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', '保存成功！');
					LocPrintRulesGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		columns: [[
			{
				title: 'RowId',
				align: 'right',
				field: 'RowId',
				width: 100,
				hidden: true
			}, {
				title: '医院',
				align: 'left',
				field: 'HospId',
				width: 200,
				formatter: CommonFormatter(HospitalBox, 'HospId', 'HospDesc'),
				editor: HospitalBox
			}, {
				title: '科室',
				align: 'left',
				field: 'LocId',
				width: 150,
				formatter: CommonFormatter(LocBox, 'LocId', 'LocDesc'),
				editor: LocBox
			}, {
				title: '打印规则',
				align: 'center',
				field: 'PrintMode',
				width: 120,
				formatter: CommonFormatter(PrintModeBox, 'RowId', 'PrintMode'),
				editor: PrintModeBox
			}, {
				title: '打印规则描述',
				align: 'left',
				field: 'PrintRulesDesc',
				width: 120
			}
		]],
		showAddSaveDelItems: true,
		pagination: false,
		remoteSort: false,
		fitColumns: true,
		onClickRow: function(index, row) {
			if (!isEmpty(row.HospId)) {
				PHospId = row.HospId;
			}
			LocPrintRulesGrid.commonClickRow(index, row);
		}
	});
	InitHosp();
};
$(init);