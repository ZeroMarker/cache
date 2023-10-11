var init = function() {
	var LocParams = JSON.stringify(addSessionParams({
		Type: 'Login',
		Element: 'LocId',
		LoginLocType: 2
	}));
	var LocBox = $HUI.combobox('#LocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});

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
					var InciId = Select.InciId;
					param.Inci = InciId;
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
			title: 'Inclb',
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
			title: '��������',
			field: 'DispQty',
			width: 80,
			align: 'right'
		}, {
			title: '����ռ��',
			field: 'DisRetQty',
			width: 80,
			align: 'right',
			hidden: true
		}, {
			title: '�˻�����',
			field: 'Qty',
			width: 80,
			saveCol: true,
			align: 'right'
		}, {
			title: '����ռ��',
			field: 'RetDirtyQty',
			width: 80,
			align: 'right',
			hidden: true
		}, {
			title: '��λ',
			field: 'UomId',
			saveCol: true,
			formatter: CommonFormatter(UomCombox, 'UomId', 'UomDesc'),
			editor: UomCombox,
			width: 80
		}, {
			title: '����',
			field: 'Rp',
			width: 80,
			saveCol: true,
			align: 'right'
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 100,
			saveCol: true,
			align: 'right'
		}, {
			title: '�ۼ�',
			field: 'Sp',
			width: 80,
			saveCol: true,
			align: 'right'
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 100,
			saveCol: true,
			align: 'right'
		}, {
			title: '��ע',
			field: 'Remark',
			editor: {
				type: 'validatebox'
			},
			saveCol: true,
			width: 150
		}, {
			title: '������ϸId',
			field: 'Indsi',
			width: 50,
			saveCol: true,
			hidden: true
		}
	]];

	var MainGrid = $UI.datagrid('#MainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispRetItm',
			QueryName: 'DHCINDispRetItm',
			query2JsonStrict: 1
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispRetItm',
			MethodName: 'jsDelete'
		},
		columns: MainCm,
		remoteSort: false,
		showBar: true,
		showAddDelItems: true,
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
							var INDispItmId = BarCodeData['INDispItmId'];
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
							} else if (Status != 'InDisp') {
								CheckMsg = '�ø�ֵ���벻�Ƿ���״̬,�����˻�!';
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

							var LocId = $('#LocId').combobox('getValue');
							var RetData = $.cm({
								ClassName: 'web.DHCSTMHUI.DHCINDispRetItm',
								MethodName: 'GetDataForRet',
								Indsi: INDispItmId,
								Loc: LocId
							}, false);
							var Indsi = RetData.Indsi;
							if (isEmpty(Indsi)) {
								$UI.msg('alert', BarCode + 'û����Ӧ����¼,�����Ƶ�!');
								$(this).val('');
								$(this).focus();
								MainGrid.stopJump();
								return false;
							}
							$(this).val(BarCode).validatebox('validate');
							var RetInfo = $.extend(RetData, { InciDr: Inci, dhcit: dhcit, HVBarCode: BarCode, OriginalStatus: OriginalStatus });
							ReturnInfoFunc(index, RetInfo);
						}
					});
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
			Clear();
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
				$UI.msg('alert', '��ѡ���˻ؿ���!');
				return;
			}
			var Main = JSON.stringify(MainObj);
			var Detail = MainGrid.getChangesData('Inclb');
			if (Detail === false) {	// δ��ɱ༭����ϸΪ��
				return;
			}
			if (isEmpty(Detail)) {	// ��ϸ����
				$UI.msg('alert', 'û����Ҫ�������ϸ!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINDispRet',
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
			var DsrId = ParamsObj['RowId'];
			if (isEmpty(DsrId)) {
				$UI.msg('alert', '�˻ص�������!');
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
			var DsrId = ParamsObj['RowId'];
			if (isEmpty(DsrId)) {
				return;
			}
			var CompFlag = ParamsObj['CompFlag'];
			if (CompFlag == 'Y') {
				$UI.msg('alert', '�õ��������,�����ظ�����!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINDispRet',
				MethodName: 'jsSetComp',
				Dsr: DsrId,
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
			var DsrId = ParamsObj['RowId'];
			if (isEmpty(DsrId)) {
				return;
			}
			var CompFlag = ParamsObj['CompFlag'];
			if (CompFlag != 'Y') {
				$UI.msg('alert', '�õ��ݲ������״̬,���ɲ���!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINDispRet',
				MethodName: 'CancelComp',
				Dsr: DsrId
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

	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			PrintINDispRet($('#RowId').val());
		}
	});
	$UI.linkbutton('#SelDispBT', {
		onClick: function() {
			SelDisp(Select, 'Y');
		}
	});
	function ReturnInfoFunc(RowIndex, row) {
		MainGrid.updateRow({
			index: RowIndex,
			row: {
				HVBarCode: row.HVBarCode,
				InciId: row.InciDr,
				InciCode: row.InciCode,
				InciDesc: row.InciDesc,
				Spec: row.Spec,
				Inclb: row.Inclb,
				BatchNo: row.BatchNo,
				ExpDate: row.ExpDate,
				DispQty: row.DispQty,
				DisRetQty: row.DsiRetQty,
				Qty: 1,
				UomId: row.DispUom,
				UomDesc: row.DispUomDesc,
				Rp: row.Rp,
				Sp: row.Sp,
				RpAmt: row.Rp,
				SpAmt: row.Sp,
				Manf: row.Manf,
				Indsi: row.Indsi
			}
		});
		setTimeout(function() {
			MainGrid.refreshRow();
			MainGrid.commonAddRow();
		}, 50);
	}

	function setEditDisable() {
		$HUI.combobox('#LocId').disable();
		$HUI.combobox('#Scg').disable();
		ChangeButtonEnable({
			'#DelBT': false,
			'#ComBT': false,
			'#CanComBT': true
		});
	}

	function setEditEnable() {
		$HUI.combobox('#LocId').enable();
		$HUI.combobox('#Scg').enable();
		ChangeButtonEnable({
			'#DelBT': true,
			'#ComBT': true,
			'#CanComBT': false
		});
	}

	function Select(Dsr) {
		$UI.clearBlock('#Conditions');
		$UI.clear(MainGrid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINDispRet',
			MethodName: 'Select',
			Dsr: Dsr
		}, function(jsonData) {
			$UI.fillBlock('#Conditions', jsonData);
			if ($HUI.checkbox('#CompFlag').getValue()) {
				setEditDisable();
			} else {
				setEditEnable();
			}
		});
		MainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINDispRetItm',
			QueryName: 'DHCINDispRetItm',
			query2JsonStrict: 1,
			Parref: Dsr
		});
	}

	function Delete() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var DsrId = ParamsObj['RowId'];
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINDispRet',
			MethodName: 'Delete',
			Dsr: DsrId
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
	function Clear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(MainGrid);
		SetDefaValues();
		setEditEnable();
	}
	SetDefaValues();
};
$(init);