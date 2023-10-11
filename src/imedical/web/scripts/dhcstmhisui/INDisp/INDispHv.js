var DispLocId = '';
var init = function() {
	$HUI.radio("[name='ReqMode']", {
		onChecked: function(e, value) {
			var ReqMode = $("input[name='ReqMode']:checked").val();
			if (ReqMode == '0') {
				$('#UserList').combobox({
					disabled: true
				});
				$('#GrpList').combobox({
					disabled: false
				});
			} else {
				$('#UserList').combobox({
					disabled: false
				});
				$('#GrpList').combobox({
					disabled: true
				});
			}
		}
	});
	// ���ſ���
	var DispLocParams = JSON.stringify(addSessionParams({
		Type: 'Login',
		Element: 'LocId',
		LoginLocType: 2
	}));
	var DispLocBox = $HUI.combobox('#LocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + DispLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			DispLocId = record['RowId'];
			$('#ReqLoc').combobox('clear');
			$('#ReqLoc').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
				+ JSON.stringify(addSessionParams({
					Type: 'LeadLoc',
					LocId: DispLocId,
					Element: 'ReqLoc'
				})));
			$('#ReqLoc').combobox('setValue', DispLocId);
		}
	});
	$('#LocId').combobox('setValue', gLocId);
	DispLocId = $('#LocId').combobox('getValue');
	// ���տ���
	var ReqLocParams = JSON.stringify(addSessionParams({
		Type: 'LeadLoc',
		LocId: DispLocId,
		Element: 'ReqLoc'
	}));
	var ReqLocBox = $HUI.combobox('#ReqLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onChange: function(newValue, oldValue) {
			var LocId = newValue;
			$('#UserList').combobox('clear');
			$('#GrpList').combobox('clear');
			$('#UserList').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=Array&Params='
				+ JSON.stringify({
					LocDr: LocId
				}));
			$('#GrpList').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.DHCSubLocUserGroup&QueryName=GetLocGrp&ResultSetType=Array&Params='
				+ JSON.stringify({
					SubLoc: LocId
				}));
		},
		onSelect: function(record) {
			var LocId = record['RowId'];
			if ((DispLocId != LocId) && (INDispParamObj.AllowCrossLoc != 'Y')) {
				$UI.msg('alert', '���������ҷ���!');
				$('#ReqLoc').combobox('clear');
				return false;
			}
		}
	});
	$('#ReqLoc').combobox('setValue', DispLocId);
	// רҵ��
	var GrpListBox = $HUI.combobox('#GrpList', {
		url: '',
		valueField: 'RowId',
		textField: 'Description'
	});
	// ������Ա
	var UserListBox = $HUI.combobox('#UserList', {
		url: '',
		valueField: 'RowId',
		textField: 'Description'
	});
	// ��λ
	var UomCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			tipPosition: 'bottom',
			mode: 'remote',
			editable: false,
			onBeforeLoad: function(param) {
				var Select = MainGrid.getRows()[MainGrid.editIndex];
				if (!isEmpty(Select)) {
					param.Inci = Select.InciId;
				}
			}
		}
	};

	var MainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '��������Id',
			field: 'Inclb',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '����RowId',
			field: 'InciId',
			width: 50,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 100
		}, {
			title: '��������',
			field: 'InciDesc',
			jump: false,
			width: 150
		}, {
			title: '��ֵ����',
			field: 'HVBarCode',
			saveCol: true,
			jump: false,
			editor: {
				type: 'validatebox',
				options: {
					required: true,
					tipPosition: 'bottom'
				}
			},
			width: 150
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '����',
			field: 'BatchNo',
			width: 100
		}, {
			title: 'Ч��',
			field: 'ExpDate',
			width: 100
		}, {
			title: '��������',
			field: 'Manf',
			width: 150
		}, {
			title: '����',
			field: 'Qty',
			width: 80,
			saveCol: true,
			align: 'right'
		}, {
			title: '��λ',
			field: 'UomId',
			saveCol: true,
			formatter: CommonFormatter(UomCombox, 'UomId', 'UomDesc'),
			editor: UomCombox,
			width: 80
		}, {
			title: '���ÿ��',
			field: 'AvaQty',
			width: 100,
			align: 'right',
			hidden: true
		}, {
			title: '����ռ�ÿ��',
			field: 'DirtyQty',
			width: 50,
			align: 'right',
			hidden: true
		}, {
			title: '����',
			field: 'Rp',
			saveCol: true,
			width: 80,
			align: 'right'
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '�ۼ�',
			field: 'Sp',
			saveCol: true,
			width: 80,
			align: 'right'
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '��Ʒ��ע',
			field: 'Remark',
			editor: {
				type: 'validatebox'
			},
			saveCol: true,
			width: 150
		}
	]];

	var MainGrid = $UI.datagrid('#MainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispItm',
			QueryName: 'DHCINDispItm',
			query2JsonStrict: 1
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispItm',
			MethodName: 'jsDelete'
		},
		columns: MainCm,
		checkField: 'Inclb',
		showBar: true,
		remoteSort: false,
		showAddDelItems: true,
		pagination: false,
		onClickRow: function(index, row) {
			MainGrid.commonClickRow(index, row);
		},
		onBeforeEdit: function(index, row) {
			if ($HUI.checkbox('#CompFlag').getValue()) {
				$UI.msg('alert', '�Ѿ���ɣ������޸�!');
				return false;
			}
		},
		onBeginEdit: function(index, row) {
			$('#MainGrid').datagrid('beginEdit', index);
			var ed = $('#MainGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var e = ed[i];
				if (e.field == 'HVBarCode') {
					$(e.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var BarCode = $(this).val();
							if (isEmpty(BarCode)) {
								MainGrid.stopJump();
								return false;
							}
							var FindIndex = MainGrid.find('HVBarCode', BarCode);
							if (FindIndex >= 0 && FindIndex != index) {
								$UI.msg('alert', '���벻���ظ�¼��!');
								$(this).val('');
								$(this).focus();
								MainGrid.stopJump();
								return false;
							}
							var BarCodeData = $.cm({
								ClassName: 'web.DHCSTMHUI.DHCItmTrack',
								MethodName: 'GetItmByBarcode',
								BarCode: BarCode
							}, false);
							if (!isEmpty(BarCodeData.success) && BarCodeData.success != 0) {
								$UI.msg('alert', BarCodeData.msg);
								$(this).val('');
								$(this).focus();
								MainGrid.stopJump();
								return false;
							}
							var ScgStk = BarCodeData['ScgStk'];
							var ScgStkDesc = BarCodeData['ScgStkDesc'];
							var Inclb = BarCodeData['Inclb'];
							var IsAudit = BarCodeData['IsAudit'];
							var OperNo = BarCodeData['OperNo'];
							var Type = BarCodeData['Type'];
							var Status = BarCodeData['Status'];
							var RecallFlag = BarCodeData['RecallFlag'];
							var Inci = BarCodeData['Inci'];
							var dhcit = BarCodeData['dhcit'];
							var OriginalStatus = BarCodeData['OriginalStatus'];
							var Scg = $('#Scg').combobox('getValue');
							var CheckMsg = '';
							if (!CheckScgRelation(Scg, ScgStk)) {
								CheckMsg = '����' + BarCode + '����' + ScgStkDesc + '����,�뵱ǰ����!';
							} else if (Inclb == '') {
								CheckMsg = '�ø�ֵ����û����Ӧ����¼,�����Ƶ�!';
							} else if (IsAudit != 'Y' && OriginalStatus != 'NotUnique') {
								CheckMsg = '�ø�ֵ������δ��˵�' + OperNo + ',���ʵ!';
							} else if (Type == 'T' && OriginalStatus != 'NotUnique') {
								CheckMsg = '�ø�ֵ�����Ѿ�����,�����Ƶ�!';
							} else if (Status != 'Enable') {
								CheckMsg = '�ø�ֵ���봦�ڲ�����״̬,�����Ƶ�!';
							} else if (RecallFlag == 'Y') {
								CheckMsg = '�ø�ֵ���봦������״̬,�����Ƶ�!';
							}
							if (CheckMsg != '') {
								$UI.msg('alert', CheckMsg);
								$(this).val('');
								$(this).focus();
								MainGrid.stopJump();
								return false;
							}
							var ProLocId = $('#LocId').combobox('getValue');
							var ReqLocId = $('#ReqLoc').combobox('getValue');
							var ParamsObj = { InciDr: Inci, ProLocId: ProLocId, ReqLocId: ReqLocId, QtyFlag: 1, Inclb: Inclb };
							var Params = JSON.stringify(ParamsObj);
							var InclbData = $.cm({
								ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
								MethodName: 'GetDrugBatInfo',
								page: 1,
								rows: 1,
								Params: Params
							}, false);
							if (!InclbData || InclbData.rows.length < 1) {
								$UI.msg('alert', BarCode + 'û����Ӧ����¼,�����Ƶ�!');
								$(this).val('');
								$(this).focus();
								MainGrid.stopJump();
								return false;
							}
							$(this).val(BarCode).validatebox('validate');
							var InclbInfo = $.extend(InclbData.rows[0], { InciDr: Inci, dhcit: dhcit, HVBarCode: BarCode, OriginalStatus: OriginalStatus });
							ReturnInfoFunc(index, InclbInfo);
						}
					});
				}
			}
		},
		onAfterEdit: function(index, row, changes) {
			if (changes.hasOwnProperty('Qty')) {
				var Qty = Number(changes['Qty']);
				if (Qty <= 0) {
					$UI.msg('alert', '��������С�ڻ����0!');
					$(this).datagrid('updateRow', {
						index: index,
						row: {
							Qty: '',
							RpAmt: 0,
							SpAmt: 0
						}
					});
					return false;
				}
			}
		},
		beforeDelFn: function() {
			if ($HUI.checkbox('#CompFlag').getValue()) {
				$UI.msg('alert', '�Ѿ���ɣ�����ɾ��ѡ����!');
				return false;
			}
		},
		beforeAddFn: function() {
			if ($HUI.checkbox('#CompFlag').getValue()) {
				$UI.msg('alert', '�Ѿ���ɣ���������һ��!');
				return false;
			}
			if (isEmpty($HUI.combobox('#LocId').getValue())) {
				$UI.msg('alert', '���ſ��Ҳ���Ϊ��!');
				return false;
			}
			if (isEmpty($HUI.combobox('#ReqLoc').getValue())) {
				$UI.msg('alert', '���տ��Ҳ���Ϊ��!');
				return false;
			}
		},
		onLoadSuccess: function(data) {
			var RowId = $('#RowId').val();
			if (isEmpty(RowId)) {
				for (var i = 0; i < data.rows.length; i++) {
					data.rows[i].RowId = '';
				}
			}
		}
	});

	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var HVFlag = 'Y';
			FindWin(Select, HVFlag);
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clearBlock('#Conditions');
			$UI.clear(MainGrid);
			SetDefaValues();
			setEditEnable();
		}
	});

	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			PrintINDisp($('#RowId').val());
		}
	});

	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var MainObj = $UI.loopBlock('#Conditions');
			var IsChange = $UI.isChangeBlock('#Conditions');
			var SelectedRow = MainGrid.getSelected();
			if (isEmpty(SelectedRow) && IsChange == false) {
				$UI.msg('alert', 'û����Ҫ���������!');
				return;
			}
			if (MainObj['CompFlag'] == 'Y') {
				$UI.msg('alert', '�õ����Ѿ����,�����ظ�����!');
				return;
			}
			if (isEmpty(MainObj['LocId'])) {
				$UI.msg('alert', '��ѡ�񷢷ſ���!');
				return;
			}
			if (isEmpty(MainObj['ReqLoc'])) {
				$UI.msg('alert', '��ѡ����տ���!');
				return;
			}
			var ReqMode = $("input[name='ReqMode']:checked").val();
			if ((ReqMode == '1') && (isEmpty(MainObj['UserList']))) {
				$UI.msg('alert', '��ѡ�񷢷���Ա!');
				return;
			}
			if ((ReqMode == '0') && (isEmpty(MainObj['GrpList']))) {
				$UI.msg('alert', '��ѡ�񷢷�רҵ��!');
				return;
			}
			var Main = JSON.stringify(MainObj);
			var Detail = MainGrid.getChangesData();
			// �ж�
			if (Detail === false) {	// δ��ɱ༭����ϸΪ��
				return;
			}
			if (isEmpty(Detail)) {	// ��ϸ����
				$UI.msg('alert', 'û����Ҫ�������ϸ!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINDisp',
				MethodName: 'jsSave',
				Main: Main,
				Detail: JSON.stringify(Detail)
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					Select(jsonData.rowid);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	$UI.linkbutton('#DelBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var Inds = ParamsObj['RowId'];
			if (isEmpty(Inds)) {
				$UI.msg('alert', '���ŵ�������!');
				return;
			}
			var CompFlag = ParamsObj['CompFlag'];
			if (CompFlag == 'Y') {
				$UI.msg('alert', '�õ����Ѿ����,����ɾ��!');
				return;
			}
			$UI.confirm('����Ҫɾ������,�Ƿ����?', '', '', Delete);
		}
	});

	$UI.linkbutton('#ComBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var Inds = ParamsObj['RowId'];
			if (isEmpty(Inds)) {
				return;
			}
			var CompFlag = ParamsObj['CompFlag'];
			if (CompFlag == 'Y') {
				$UI.msg('alert', '�õ��������,�����ظ�����!');
				return;
			}
			if (isEmpty(ParamsObj.ReqLoc)) {
				$UI.msg('alert', '���տ��Ҳ���Ϊ��!');
				return false;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINDisp',
				MethodName: 'jsSetComp',
				Inds: Inds,
				Params: JSON.stringify(ParamsObj)
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					Select(jsonData.rowid);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	$UI.linkbutton('#CanComBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var Inds = ParamsObj['RowId'];
			if (isEmpty(Inds)) {
				return;
			}
			var CompFlag = ParamsObj['CompFlag'];
			if (CompFlag != 'Y') {
				$UI.msg('alert', '�õ��ݲ������״̬,���ɲ���!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINDisp',
				MethodName: 'CancelComp',
				Inds: Inds
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					Select(jsonData.rowid);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	function ReturnInfoFunc(RowIndex, row) {
		console.log(row);
		var BatchNo = row.BatExp.split('~')[0];
		var ExpDate = row.BatExp.split('~')[1];
		MainGrid.updateRow({
			index: RowIndex,
			row: {
				HVBarCode: row.HVBarCode,
				InciId: row.InciDr,
				InciCode: row.InciCode,
				InciDesc: row.InciDesc,
				Spec: row.Spec,
				Inclb: row.Inclb,
				Manf: row.Manf,
				BatchNo: BatchNo,
				ExpDate: ExpDate,
				Qty: 1,
				UomId: row.PurUomId,
				UomDesc: row.PurUomDesc,
				Rp: row.Rp,
				Sp: row.Sp,
				RpAmt: row.Rp,
				SpAmt: row.Sp,
				DirtyQty: row.DirtyQty,
				AvaQty: row.AvaQty
			}
		});
		setTimeout(function() {
			MainGrid.refreshRow();
			MainGrid.commonAddRow();
		}, 50);
	}

	function Select(Inds) {
		$UI.clearBlock('#Conditions');
		$UI.clear(MainGrid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINDisp',
			MethodName: 'Select',
			Inds: Inds
		}, function(jsonData) {
			$UI.fillBlock('#Conditions', jsonData);
			if (jsonData.UserList.RowId != '') {
				$HUI.radio('#DisByUser').setValue(true);
				$('#UserList').combobox('setValue', jsonData.UserList.RowId);
			}
			if (jsonData.GrpList.RowId != '') {
				$HUI.radio('#DisByGrp').setValue(true);
				$('#GrpList').combobox('setValue', jsonData.GrpList.RowId);
			}
			if ($HUI.checkbox('#CompFlag').getValue()) {
				setEditDisable();
			} else {
				setEditEnable();
			}
		});
		MainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINDispItm',
			QueryName: 'DHCINDispItm',
			query2JsonStrict: 1,
			Parref: Inds,
			rows: 9999
		});
	}

	function Delete() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var Inds = ParamsObj['RowId'];
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINDisp',
			MethodName: 'Delete',
			Inds: Inds
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				$UI.clearBlock('#Conditions');
				$UI.clear(MainGrid);
				SetDefaValues();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	function setEditDisable() {
		$HUI.combobox('#LocId').disable();
		$HUI.combobox('#Scg').disable();
		ChangeButtonEnable({
			'#DelBT': false,
			'#ComBT': false,
			'#SaveBT': false,
			'#CanComBT': true
		});
	}

	function setEditEnable() {
		$HUI.combobox('#LocId').enable();
		$HUI.combobox('#Scg').enable();
		ChangeButtonEnable({
			'#DelBT': true,
			'#ComBT': true,
			'#SaveBT': true,
			'#CanComBT': false
		});
	}
	SetDefaValues();
};
$(init);