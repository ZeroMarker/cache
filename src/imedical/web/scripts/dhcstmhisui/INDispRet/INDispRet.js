var init = function () {
	var LocParams = JSON.stringify(addSessionParams({
		Type: 'Login'
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
			mode: 'remote',
			onBeforeLoad: function (param) {
				var Select = MainGrid.getRows()[MainGrid.editIndex];
				if (!isEmpty(Select)) {
					var Inci = Select.Inclb.split('||')[0];
					param.Inci = Inci;
				}
			}
		}
	};

	var MainCm = [[{
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
		title: '����',
		field: 'InciCode',
		width: 100
	}, {
		title: '����',
		field: 'InciDesc',
		jump:false,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		},
		width: 150
	}, {
		title: "���",
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
		title: "����",
		field: 'Manf',
		width: 150
	}, {
		title: "��������",
		field: 'DispQty',
		width: 80,
		align: 'right'
	}, {
		title: "����ռ��",
		field: 'DisRetQty',
		width: 80,
		align: 'right',
		hidden: true
	}, {
		title: "�˻�����",
		field: 'Qty',
		width: 80,
		saveCol: true,
		editor: {
			type: 'numberbox',
			options: {
				min: 0,
				required: true
			}
		},
		align: 'right'
	}, {
		title: "����ռ��",
		field: 'RetDirtyQty',
		width: 80,
		align: 'right',
		hidden: true
	}, {
		title: "��λ",
		field: 'UomId',
		saveCol: true,
		formatter: CommonFormatter(UomCombox, 'UomId', 'UomDesc'),
		editor: UomCombox,
		width: 80
	}, {
		title: "����",
		field: 'Rp',
		width: 80,
		saveCol: true,
		align: 'right'
	}, {
		title: "���۽��",
		field: 'RpAmt',
		width: 100,
		saveCol: true,
		align: 'right'
	}, {
		title: "�ۼ�",
		field: 'Sp',
		width: 80,
		saveCol: true,
		align: 'right'
	}, {
		title: "�ۼ۽��",
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
			QueryName: 'DHCINDispRetItm'
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispRetItm',
			MethodName: 'jsDelete'
		},
		columns: MainCm,
		remoteSort: false,
		showBar: true,
		showAddDelItems: true,
		onClickCell: function (index, field, value) {
			MainGrid.commonClickCell(index, field);
		},
		onBeforeCellEdit: function (index, field) {
			if ($HUI.checkbox('#CompFlag').getValue()) {
				$UI.msg("alert", "�Ѿ���ɣ������޸�!");
				return false;
			}
		},
		onBeginEdit: function (index, row) {
			$('#MainGrid').datagrid('beginEdit', index);
			var ed = $('#MainGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var e = ed[i];
				if (e.field == 'InciDesc') {
					$(e.target).bind('keydown', function (event) {
						if (event.keyCode == 13) {
							var Input = $(this).val();
							var DispScg = $('#Scg').combotree('getValue');
							var DispToLoc = $('#LocId').combobox('getValue');
							var HV = 'N';
							var ChargeFlag="";
							var AllowChargeMat=GetAppPropValue('DHCSTINDISPM').AllowChargeMat;
							if (AllowChargeMat!="Y"){ChargeFlag="N";}
							var ParamsObj = {
								StkGrpRowId: DispScg,
								StkGrpType: 'M',
								Locdr: gLocId,
								NotUseFlag: 'N',
								QtyFlag: '1',
								ToLoc: DispToLoc,
								ChargeFlag:ChargeFlag
							};
							INDispItmBatWindow(Input, ParamsObj, ReturnInfoFunc);
						}
					});
				} else if (e.field == 'Qty') {
					$(e.target).bind('keyup', function (event) {
						if (event.keyCode == 13) {
							MainGrid.commonAddRow();
						}
					});
				}
			}
		}
	});

	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			FindWin(Select);
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			Clear();
		}
	});

	$UI.linkbutton('#SaveBT', {
		onClick: function () {
			var MainObj = $UI.loopBlock('#Conditions');
			var IsChange = $UI.isChangeBlock('#Conditions');
			var SelectedRow = MainGrid.getSelected();
			if (isEmpty(SelectedRow) && IsChange == false) {
				$UI.msg('alert', "û����Ҫ���������!");
				return;
			}
			if (MainObj['CompFlag'] == 'Y') {
				$UI.msg('alert', '�õ����Ѿ����,�����ظ�����!');
				return;
			}
			if (isEmpty(MainObj['LocId'])) {
				$UI.msg('alert', '��ѡ���˻ؿ���!')
				return;
			}
			var Main = JSON.stringify(MainObj);
			var Detail = MainGrid.getChangesData('Inclb');
			if (Detail === false){	//δ��ɱ༭����ϸΪ��
				return;
			}
			if (isEmpty(Detail)){	//��ϸ����
				$UI.msg("alert", "û����Ҫ�������ϸ!");
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINDispRet',
				MethodName: 'jsSave',
				Main: Main,
				Detail: JSON.stringify(Detail)
			}, function (jsonData) {
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
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var DsrId = ParamsObj['RowId'];
			if (isEmpty(DsrId)) {
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
		onClick: function () {
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
				MethodName: 'SetComp',
				Dsr: DsrId
			}, function (jsonData) {
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
		onClick: function () {
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
			}, function (jsonData) {
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
		onClick: function () {
			PrintINDispRet($('#RowId').val());
		}
	});

	function ReturnInfoFunc(rows) {
		rows = [].concat(rows);
		$.each(rows, function (index, row) {
			var RowIndex = MainGrid.editIndex;
			var ed = $('#MainGrid').datagrid('getEditor', {
				index: RowIndex,
				field: 'UomId'
			});
			AddComboData(ed.target, row.PUomDr, row.PUomDesc);
			MainGrid.updateRow({
				index: RowIndex,
				row: {
					InciId: row.InciDr,
					InciCode: row.InciCode,
					InciDesc: row.InciDesc,
					Spec: row.Spec,
					Inclb: row.Inclb,
					BatchNo: row.BatchNo,
					ExpDate: row.ExpDate,
					DispQty: row.Qty,
					Qty: row.RetQty,
					UomId: row.PUomDr,
					UomDesc: row.PUomDesc,
					Rp: row.Rp,
					Sp: row.Sp,
					RpAmt: accMul(row.RetQty, row.Rp),
					SpAmt: accMul(row.RetQty, row.Sp),
					Manf: row.Manf,
					Indsi: row.RowId
				}
			});
			$('#MainGrid').datagrid('refreshRow', RowIndex);
			if (index < rows.length) {
				MainGrid.commonAddRow();
			}
		});
	}

	function setEditDisable() {
		$HUI.combobox("#LocId").disable();
		$HUI.combobox("#Scg").disable();
		ChangeButtonEnable({
			'#DelBT': false,
			'#ComBT': false,
			'#CanComBT': true
		});
	}

	function setEditEnable() {
		$HUI.combobox("#LocId").enable();
		$HUI.combobox("#Scg").enable();
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
		}, function (jsonData) {
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
		}, function (jsonData) {
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
	function Clear(){
		$UI.clearBlock('#Conditions');
		$UI.clear(MainGrid);
		SetDefaValues();
		setEditEnable();
	}
	SetDefaValues();
}
$(init);
