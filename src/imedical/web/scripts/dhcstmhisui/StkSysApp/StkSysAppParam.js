// 名称:参数设置管理

var init = function() {
	var AppSynBT = {
		text: '同步参数',
		iconCls: 'icon-reload',
		handler: function() {
			var synRet = tkMakeServerCall('web.DHCSTMHUI.Tools.CreateAppPara', 'Prop');
			var synRetArr = synRet.split('^');
			$UI.msg('success', '遍历' + synRetArr[2] + '个, 新增' + synRetArr[0] + '个, 修改' + synRetArr[1] + '个!');
			$UI.clear(AppGrid);
			$UI.clear(AppParamGrid);
			$UI.clear(AppParamValueGrid);
			AppGrid.reload();
		}
	};
	
	var AppGrid = $UI.datagrid('#AppGrid', {
		lazy: false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCStkSysApp',
			MethodName: 'SelectAll',
			rows: 999
		},
		remoteSort: false,
		pagination: false,
		toolbar: [AppSynBT],
		showAddDelItems: false,
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
				width: 200
			}, {
				title: '名称',
				field: 'Desc',
				width: 200
			}
		]],
		onSelect: function(index, row) {
			var Parref = row['RowId'];
			$UI.clear(AppParamValueGrid);
			$UI.clear(AppParamGrid);
			AppParamGrid.load({
				ClassName: 'web.DHCSTMHUI.StkSysAppParam',
				MethodName: 'SelectAll',
				Parref: Parref,
				rows: 999
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	
	var AppParamSaveBT = {
		text: '保存',
		iconCls: 'icon-save',
		handler: function() {
			var AppRow = AppGrid.getSelected();
			if (isEmpty(AppRow)) {
				$UI.msg('alert', '请选择相应的应用程序!');
				return;
			}
			var Parref = AppRow['RowId'];
			if (!AppParamGrid.endEditing()) {
				return;
			}
			var Detail = AppParamGrid.getChangesData('Code');
			if (Detail === false) {	// 未完成编辑或明细为空
				return;
			}
			if (isEmpty(Detail)) {	// 明细不变
				$UI.msg('alert', '没有需要保存的明细!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.StkSysAppParam',
				MethodName: 'Save',
				Parref: Parref,
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
	};
	var AppParamDelBT = {
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			var Select = AppParamGrid.getSelected();
			if (isEmpty(Select.RowId)) {
				AppParamGrid.commonDeleteRow();
			} else {
				var AppParamRowData = AppParamGrid.getSelectedData();
				$UI.confirm('确定要删除吗?', '', '', function() {
					$.cm({
						ClassName: 'web.DHCSTMHUI.StkSysAppParam',
						MethodName: 'Delete',
						Params: JSON.stringify(AppParamRowData)
					}, function(jsonData) {
						if (jsonData.success === 0) {
							$UI.msg('success', jsonData.msg);
							AppParamGrid.reload();
							$UI.clear(AppParamValueGrid);
						} else {
							$UI.msg('error', jsonData.msg);
						}
					});
				});
			}
		}
	};
	var AppParamGrid = $UI.datagrid('#AppParamGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.StkSysAppParam',
			MethodName: 'SelectAll',
			rows: 999
		},
		remoteSort: false,
		pagination: false,
		toolbar: [AppParamDelBT, AppParamSaveBT],
		showAddItems: true,
		beforeAddFn: function() {
			var AppRow = AppGrid.getSelected();
			if (isEmpty(AppRow)) {
				$UI.msg('alert', '请选择相应的应用程序!');
				return false;
			}
		},
		fitColumns: true,
		columns: [[
			{
				title: 'RowId',
				field: 'RowId',
				width: 80,
				hidden: true
			}, {
				title: '名称',
				field: 'Code',
				width: 200,
				editor: {
					type: 'validatebox',
					options: {
						tipPosition: 'bottom',
						required: true
					}
				}
			}, {
				title: '描述',
				field: 'Desc',
				width: 200,
				editor: {
					type: 'validatebox',
					options: {
						tipPosition: 'bottom',
						required: true
					}
				}
			}, {
				title: '备注',
				field: 'Memo',
				width: 200,
				editor: 'validatebox'
			}, {
				title: '缺省值',
				field: 'PropValue',
				width: 250,
				editor: 'validatebox'
			}
		]],
		onClickCell: function(index, field, value) {
			AppParamGrid.commonClickCell(index, field);
		},
		onBeforeCellEdit: function(index, field) {
			var RowData = $(this).datagrid('getRows')[index];
			if (field == 'Code' && !isEmpty(RowData['RowId'])) {
				return false;
			}
		},
		onSelect: function(index, row) {
			var Parref = row['RowId'];
			var ParamCode = row['Code'];
			$UI.clear(AppParamValueGrid);
			if (ParamCode == 'BatSp' || ParamCode == 'BatSpHV') {
				AppParamValueGrid.showColumn('StartDate');
			} else {
				AppParamValueGrid.hideColumn('StartDate');
			}
			if (!isEmpty(Parref)) {
				AppParamValueGrid.load({
					ClassName: 'web.DHCSTMHUI.StkSysAppParam',
					MethodName: 'SelectProp',
					Parref: Parref,
					HospId: gHospId,
					rows: 999
				});
			}
		},
		onLoadSuccess: function(data) {
			
		}
	});
	
	var TypeField = $HUI.combobox('#TypeField', {
		data: [{ RowId: 'G', Description: '安全组' }, { RowId: 'L', Description: '科室' },
			{ RowId: 'U', Description: '人员' }, { RowId: 'D', Description: '全院' }
		],
		valueField: 'RowId',
		textField: 'Description',
		editable: false,
		onSelect: function(record) {
			var Type = record['RowId'];
			// var RowIndex = AppParamValueGrid.getRowIndex(AppParamValueGrid.getSelected());
			// var PointerTarget = $('#AppParamValueGrid').datagrid('getEditor', {index: RowIndex, field: 'Pointer'}).target;
			var PointerTarget = $('#PointerField');
			PointerTarget.combobox('setValue', '');
			if (Type == 'G') {
				PointerTarget.combobox('reload',
					$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetGroup&ResultSetType=Array'
					+ '&Params=' + JSON.stringify(addSessionParams({ ShowAllHospFlag: 'Y' })));
			} else if (Type == 'L') {
				PointerTarget.combobox('reload',
					$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array'
					+ '&Params=' + JSON.stringify(addSessionParams({ Type: 'All', ShowAllHospFlag: 'Y' })));
			} else if (Type == 'U') {
				PointerTarget.combobox('reload',
					$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetUser&ResultSetType=Array'
					+ '&Params=' + JSON.stringify(addSessionParams({ ShowAllHospFlag: 'Y' })));
			} else if (Type == 'D') {
				PointerTarget.combobox('reload',
					$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetHosp&ResultSetType=Array');
				// PointerTarget.combobox('loadData', [{RowId: 'DHC', Description: 'DHC'}]);
				// PointerTarget.combobox('setValue', 'DHC');
			}
		}
	});
	$HUI.combobox('#PointerField', {
		valueField: 'RowId',
		textField: 'Description'
	});
	/* $HUI.combobox('#HospField', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetHosp&ResultSetType=Array',
		valueField: 'RowId',
		textField: 'Description'
	});*/
	
	var ParamValueAddBtn = {
		text: '新增',
		iconCls: 'icon-add',
		handler: function() {
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
	};
	var ParamValueUpdateBtn = {
		text: '修改',
		iconCls: 'icon-write-order',
		handler: function() {
			var RowData = AppParamValueGrid.getSelected();
			if (isEmpty(RowData)) {
				$UI.msg('alert', '请选择需要修改的行!');
				return;
			}
			var RowId = RowData['RowId'];
			var ParamRow = AppParamGrid.getSelected();
			var Parref = ParamRow['RowId'];
			
			ParamValueWin(Parref, RowId);
		}
	};
	var ParamValueDelBtn = {
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			AppParamValueGrid.commonDeleteRow();
		}
	};
	
	function ParamValueWin(Parref, RowId) {
		$HUI.dialog('#ParamValueWin', {
			buttons: [{
				text: '保存',
				iconCls: 'icon-w-save',
				handler: function() {
					var Detail = $UI.loopBlock('#ParamValueForm');
					if (isEmpty(Detail)) {
						$UI.msg('alert', '没有需要保存的内容!');
						return;
					}
					$.cm({
						ClassName: 'web.DHCSTMHUI.StkSysAppParam',
						MethodName: 'SaveProp',
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
				var ParamRow = AppParamGrid.getSelected();
				var ParamCode = ParamRow['Code'];
				if (ParamCode == 'BatSp' || ParamCode == 'BatSpHV') {
					$('#StartDate').parents('tr').show();
				} else {
					$('#StartDate').parents('tr').hide();
				}
				if (!isEmpty(RowId)) {
					$.cm({
						ClassName: 'web.DHCSTMHUI.StkSysAppParam',
						MethodName: 'GetPropDetail',
						RowId: RowId
					}, function(jsonData) {
						$UI.fillBlock('#ParamValueForm', jsonData);
					});
				}
			}
		}).open();
	}
	
	var AppParamValueGrid = $UI.datagrid('#AppParamValueGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.StkSysAppParam',
			MethodName: 'SelectProp',
			rows: 999
		},
		remoteSort: false,
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.StkSysAppParam',
			MethodName: 'DeleteProp'
		},
		singleSelect: true,
		pagination: false,
		toolbar: [ParamValueAddBtn, ParamValueUpdateBtn, ParamValueDelBtn],
		showAddDelItems: false,
		beforeAddFn: function() {
			var ParamRow = AppParamGrid.getSelected();
			if (isEmpty(ParamRow)) {
				$UI.msg('alert', '请选择相应的参数!');
				return false;
			}
		},
		// fitColumns: true,
		columns: [[
			{ title: 'RowId', field: 'RowId', width: 60, hidden: true },
			{ title: '类型', field: 'TypeName', width: 100 },
			{ title: '类型值', field: 'PointerName', width: 240 },
			{ title: '参数值', field: 'Value', width: 160 },
			{ title: '生效日期', field: 'StartDate', width: 120 }
		]]
	});
};
$(init);