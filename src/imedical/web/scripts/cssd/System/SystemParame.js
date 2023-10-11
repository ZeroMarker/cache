// 参数设置管理
var init = function() {
	var AppParamValueGrid;
	var HospId = gHospId;
	var TableName = 'CSSD_Parameter';
	function InitHosp() {
		var hospComp = InitHospCombo(TableName, gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			Query();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				Query();
			};
		} else {
			Query();
		}
	}
	var Query = function() {
		AppGrid.load({
			ClassName: 'web.CSSDHUI.System.BaseCodeType',
			QueryName: 'SelectAll'
		});
	};
	function QueryDetail(Parref) {
		$UI.clear(AppParamGrid);
		$UI.clear(AppParamValueGrid);
		var Params = JSON.stringify(addSessionParams({ Parref: Parref, BDPHospital: HospId }));
		AppParamGrid.load({
			ClassName: 'web.CSSDHUI.System.SystemParame',
			MethodName: 'SelectAll',
			Params: Params
		});
	}
	
	// 程序模块
	function AppSyn() {
		showMask();
		var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId, Type: 'SysParame', InitFlag: 'N', SynFlag: '1' }));
		$.cm({
			ClassName: 'web.CSSDHUI.DataInit',
			MethodName: 'jsInit',
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	var AppCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 80,
			hidden: true
		}, {
			title: '代码',
			field: 'Code',
			width: 200
		}, {
			title: '名称',
			field: 'Description',
			width: 200
		}
	]];
	AppGrid = $UI.datagrid('#AppGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.BaseCodeType',
			QueryName: 'SelectAll',
			rows: 999
		},
		remoteSort: false,
		pagination: false,
		showAddDelItems: false,
		fitColumns: true,
		columns: AppCm,
		toolbar: [{
			text: '同步参数',
			iconCls: 'icon-reload',
			handler: function() {
				AppSyn();
			}
		}],
		onSelect: function(index, row) {
			var Parref = row['RowId'];
			QueryDetail(Parref);
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#AppGrid').datagrid('selectRow', 0);
			}
		}
	});
	
	// 参数
	var AppParamCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 80,
			hidden: true
		}, {
			title: '代码',
			field: 'Code',
			width: 100,
			required: true,
			editor: 'validatebox'
		}, {
			title: '名称',
			field: 'Description',
			width: 150,
			required: true,
			editor: 'validatebox'
		}, {
			title: '参数值',
			align: 'left',
			field: 'ParaValue',
			width: 100,
			editor: 'validatebox'
		}, {
			title: '说明',
			field: 'ParaExplain',
			width: 200,
			showTip: true,
			tipWidth: 300,
			editor: 'text'
		}
	]];
	AppParamGrid = $UI.datagrid('#AppParamGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.SystemParame',
			MethodName: 'SelectAll',
			rows: 99999999
		},
		remoteSort: false,
		pagination: false,
		showAddSaveDelItems: true,
		fitColumns: true,
		columns: AppParamCm,
		checkField: 'Code',
		onLoadSuccess: function(data) {
			var ItemRow = $('#AppParamGrid').datagrid('getRows');
			for (var i = 0; i < ItemRow.length; i++) {
				var ParaExplain = ItemRow[i].ParaExplain;
				if (isEmpty(ParaExplain)) {
					$(this).css('showTip', false);
				}
			}
		},
		onClickCell: function(index, field, value) {
			AppParamGrid.commonClickCell(index, field);
		},
		onBeforeCellEdit: function(index, field) {
			var RowData = $(this).datagrid('getRows')[index];
			if (field === 'Code' && !isEmpty(RowData['RowId'])) {
				return false;
			}
		},
		onSelect: function(index, row) {
			$UI.clear(AppParamValueGrid);
			var Parref = row['RowId'];
			if (!isEmpty(Parref)) {
				AppParamValueGrid.load({
					ClassName: 'web.CSSDHUI.System.SystemParame',
					MethodName: 'SelectProp',
					Parref: Parref,
					rows: 9999999
				});
			}
		},
		beforeAddFn: function() {
			var AppRow = AppGrid.getSelected();
			if (isEmpty(AppRow)) {
				$UI.msg('alert', '请选择相应的程序模块!');
				return false;
			}
		},
		beforeDelFn: function() {
			var parameRow = $('#AppParamGrid').datagrid('getSelected');
			if (!isEmpty(parameRow)) {
				var parameRowid = parameRow.RowId;
				if (!isEmpty(parameRowid)) {
					$UI.msg('alert', '参数已维护，不能删除!');
					return false;
				}
			} else {
				$UI.msg('alert', '请选择要删除的参数!');
				return false;
			}
		},
		saveDataFn: function() {
			var AppRow = AppGrid.getSelected();
			if (isEmpty(AppRow)) {
				$UI.msg('alert', '请选择相应的应用程序!');
				return;
			}
			var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var Parref = AppRow['RowId'];
			var Detail = AppParamGrid.getChangesData();
			var Params = JSON.stringify(addSessionParams({ Parref: Parref, BDPHospital: HospId }));
			if (isEmpty(Detail)) {
				return;
			}
			if (Detail === false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			var Obj = $('#AppParamGrid').datagrid('getSelected');
			if (isEmpty(Obj.Description) || isEmpty(Obj.Code)) {
				$UI.msg('alert', '代码或名称不能为空!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.System.SystemParame',
				MethodName: 'jsSave',
				Params: Params,
				Detail: JSON.stringify(Detail)
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					AppParamGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	// 参数值
	var TypeFieldData = [{ RowId: 'G', Description: '安全组' }, { RowId: 'L', Description: '科室' },
		{ RowId: 'U', Description: '用户' }
	];
	$HUI.combobox('#TypeField', {
		data: TypeFieldData,
		valueField: 'RowId',
		textField: 'Description',
		editable: false,
		onSelect: function(record) {
			var Type = record['RowId'];
			var PointerTarget = $('#PointerField');
			PointerTarget.combobox('setValue', '');
			var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			if (Type === 'G') {
				PointerTarget.combobox('reload',
					$URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetGroup&ResultSetType=Array'
					+ '&Params=' + Params);
			} else if (Type === 'L') {
				PointerTarget.combobox('reload',
					$URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array'
					+ '&Params=' + JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: HospId })));
			} else if (Type === 'U') {
				PointerTarget.combobox('reload',
					$URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetUser&ResultSetType=Array'
					+ '&Params=' + Params);
			}
		}
	});
	
	$HUI.combobox('#PointerField', {
		valueField: 'RowId',
		textField: 'Description'
	});
	
	function ParamValueAdd() {
		var ParamRow = AppParamGrid.getSelected();
		if (isEmpty(ParamRow)) {
			$UI.msg('alert', '请选择相应的参数!');
			return;
		}
		var Parref = ParamRow['RowId'];
		if (isEmpty(Parref)) {
			$UI.msg('alert', '请先保存相应的参数!');
			return;
		}
		ParamValueWin(Parref, '');
	}
	
	function ParamValueUpdate() {
		var RowData = AppParamValueGrid.getSelected();
		if (isEmpty(RowData)) {
			$UI.msg('alert', '请选择需要修改的行!');
			return;
		}
		var RowId = RowData['RowId'];
		ParamValueWin('', RowId);
	}

	function ParamValueDel() {
		AppParamValueGrid.commonDeleteRow();
	}
	
	var ParamValueWin = function(Parref, RowId) {
		$HUI.dialog('#ParamValueWin', {
			buttons: [{
				text: '保存',
				handler: function() {
					var Detail = $UI.loopBlock('#ParamValueForm');
					if (isEmpty(Detail)) {
						$UI.msg('alert', '没有需要保存的内容!');
						return;
					}
					var Obj = $UI.loopBlock('#ParamValueForm');
					if (isEmpty(Obj.TypeField) || isEmpty(Obj.PointerField)) {
						$UI.msg('alert', '类型或类型值不能为空!');
						return;
					}
					$.cm({
						ClassName: 'web.CSSDHUI.System.SystemParame',
						MethodName: 'jsSaveProp',
						Parref: Parref,
						Detail: JSON.stringify(Detail)
					}, function(jsonData) {
						if (jsonData.success === 0) {
							$UI.msg('success', jsonData.msg);
							AppParamValueGrid.reload();
							$HUI.dialog('#ParamValueWin').close();
						} else {
							$UI.msg('error', jsonData.msg);
						}
					});
				}
			}],
			onOpen: function() {
				$UI.clearBlock('#ParamValueForm');
				if (!isEmpty(RowId)) {
					$.cm({
						ClassName: 'web.CSSDHUI.System.SystemParame',
						MethodName: 'GetPropDetail',
						RowId: RowId
					}, function(jsonData) {
						$UI.fillBlock('#ParamValueForm', jsonData);
					});
				}
			}
		}).open();
	};
	
	var Cm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 60,
			hidden: true
		}, {
			title: '类型',
			field: 'TypeDesc',
			width: 100
		}, {
			title: '类型值',
			field: 'PointerDesc',
			width: 240
		}, {
			title: '参数值',
			field: 'Value',
			width: 160
		}
	]];
	AppParamValueGrid = $UI.datagrid('#AppParamValueGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.SystemParame',
			MethodName: 'SelectProp',
			rows: 9999999
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.System.SystemParame',
			MethodName: 'jsDeleteProp'
		},
		columns: Cm,
		toolbar: [{
			text: '新增',
			iconCls: 'icon-add',
			handler: function() {
				ParamValueAdd();
			}
		}, {
			text: '修改',
			iconCls: 'icon-write-order',
			handler: function() {
				ParamValueUpdate();
			}
		}, {
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function() {
				ParamValueDel();
			}
		}],
		fitColumns: true,
		remoteSort: false,
		singleSelect: true,
		pagination: false,
		showAddDelItems: false,
		beforeAddFn: function() {
			var ParamRow = AppParamGrid.getSelected();
			if (isEmpty(ParamRow)) {
				$UI.msg('alert', '请选择相应的参数!');
				return false;
			}
		}
	});
	
	function AdjLayoutSize() {
		var SouthHeight = $(window).height() * 0.35;
		$('#ItmLayout').layout('panel', 'south').panel('resize', { height: SouthHeight });
		$('#ItmLayout').layout();
	}
	window.onresize = function() {
		AdjLayoutSize();
	};
	AdjLayoutSize();
	InitHosp();
};
$(init);