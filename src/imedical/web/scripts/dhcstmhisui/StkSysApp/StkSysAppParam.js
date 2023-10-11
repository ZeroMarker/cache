// ����:�������ù���

var init = function() {
	var AppSynBT = {
		text: 'ͬ������',
		iconCls: 'icon-reload',
		handler: function() {
			var synRet = tkMakeServerCall('web.DHCSTMHUI.Tools.CreateAppPara', 'Prop');
			var synRetArr = synRet.split('^');
			$UI.msg('success', '����' + synRetArr[2] + '��, ����' + synRetArr[0] + '��, �޸�' + synRetArr[1] + '��!');
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
				title: '����',
				field: 'Code',
				width: 200
			}, {
				title: '����',
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
		text: '����',
		iconCls: 'icon-save',
		handler: function() {
			var AppRow = AppGrid.getSelected();
			if (isEmpty(AppRow)) {
				$UI.msg('alert', '��ѡ����Ӧ��Ӧ�ó���!');
				return;
			}
			var Parref = AppRow['RowId'];
			if (!AppParamGrid.endEditing()) {
				return;
			}
			var Detail = AppParamGrid.getChangesData('Code');
			if (Detail === false) {	// δ��ɱ༭����ϸΪ��
				return;
			}
			if (isEmpty(Detail)) {	// ��ϸ����
				$UI.msg('alert', 'û����Ҫ�������ϸ!');
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
		text: 'ɾ��',
		iconCls: 'icon-cancel',
		handler: function() {
			var Select = AppParamGrid.getSelected();
			if (isEmpty(Select.RowId)) {
				AppParamGrid.commonDeleteRow();
			} else {
				var AppParamRowData = AppParamGrid.getSelectedData();
				$UI.confirm('ȷ��Ҫɾ����?', '', '', function() {
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
				$UI.msg('alert', '��ѡ����Ӧ��Ӧ�ó���!');
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
				title: '����',
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
				title: '����',
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
				title: '��ע',
				field: 'Memo',
				width: 200,
				editor: 'validatebox'
			}, {
				title: 'ȱʡֵ',
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
		data: [{ RowId: 'G', Description: '��ȫ��' }, { RowId: 'L', Description: '����' },
			{ RowId: 'U', Description: '��Ա' }, { RowId: 'D', Description: 'ȫԺ' }
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
		text: '����',
		iconCls: 'icon-add',
		handler: function() {
			var ParamRow = AppParamGrid.getSelected();
			if (isEmpty(ParamRow)) {
				$UI.msg('alert', '��ѡ����Ӧ�Ĳ���!');
				return;
			}
			var Parref = ParamRow['RowId'];
			if (isEmpty(Parref)) {
				$UI.msg('alert', '���ȱ�����Ӧ�Ĳ���!');
				return;
			}
			ParamValueWin(Parref, '');
		}
	};
	var ParamValueUpdateBtn = {
		text: '�޸�',
		iconCls: 'icon-write-order',
		handler: function() {
			var RowData = AppParamValueGrid.getSelected();
			if (isEmpty(RowData)) {
				$UI.msg('alert', '��ѡ����Ҫ�޸ĵ���!');
				return;
			}
			var RowId = RowData['RowId'];
			var ParamRow = AppParamGrid.getSelected();
			var Parref = ParamRow['RowId'];
			
			ParamValueWin(Parref, RowId);
		}
	};
	var ParamValueDelBtn = {
		text: 'ɾ��',
		iconCls: 'icon-cancel',
		handler: function() {
			AppParamValueGrid.commonDeleteRow();
		}
	};
	
	function ParamValueWin(Parref, RowId) {
		$HUI.dialog('#ParamValueWin', {
			buttons: [{
				text: '����',
				iconCls: 'icon-w-save',
				handler: function() {
					var Detail = $UI.loopBlock('#ParamValueForm');
					if (isEmpty(Detail)) {
						$UI.msg('alert', 'û����Ҫ���������!');
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
				$UI.msg('alert', '��ѡ����Ӧ�Ĳ���!');
				return false;
			}
		},
		// fitColumns: true,
		columns: [[
			{ title: 'RowId', field: 'RowId', width: 60, hidden: true },
			{ title: '����', field: 'TypeName', width: 100 },
			{ title: '����ֵ', field: 'PointerName', width: 240 },
			{ title: '����ֵ', field: 'Value', width: 160 },
			{ title: '��Ч����', field: 'StartDate', width: 120 }
		]]
	});
};
$(init);