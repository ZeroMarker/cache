var init = function () {
	$HUI.radio("[name='ReqMode']", {
		onChecked: function (e, value) {
			var ReqMode = $("input[name='ReqMode']:checked").val();
			if (ReqMode == '0') {
				$('#UserGrp').combobox({
					disabled: false
				});
			} else {
				$('#UserGrp').combobox({
					disabled: true
				});
			}
		}
	});
	var LocParams = JSON.stringify(addSessionParams({
				Type: 'Login'
			}));
	var LocBox = $HUI.combobox('#LocId', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	//רҵ��
	var UserGrpParams = JSON.stringify(addSessionParams({
				User: gUserId,
				SubLoc: gLocId,
				ReqFlag: "1"
			}));
	var UserGrpBox = $HUI.combobox('#UserGrp', {
			url: $URL + '?ClassName=web.DHCSTMHUI.DHCSubLocUserGroup&QueryName=GetUserGrp&ResultSetType=array&Params=' + UserGrpParams,
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
					param.Inci = Select.InciId;
				}
			}
		}
	};
	var HandlerParams = function () {
		var Scg = $("#Scg").combotree('getValue');
		var LocId = $("#LocId").combo('getValue');
		var ReqLoc = $("#LocId").combo('getValue');
		var QtyFlag = '0';
		var ChargeFlag="";
		var AllowChargeMat=GetAppPropValue('DHCSTINDISPM').AllowChargeMat;
		if (AllowChargeMat!="Y"){ChargeFlag="N";}
		var Obj = {
			StkGrpRowId: Scg,
			StkGrpType: "M",
			Locdr: LocId,
			NotUseFlag: "N",
			QtyFlag: QtyFlag,
			ToLoc: ReqLoc,
			ReqModeLimited: "",
			NoLocReq: "N",
			ChargeFlag:ChargeFlag
		};
		return Obj
	}
	var SelectRow = function (row) {
		var Rows = MainGrid.getRows();
		var Row = Rows[MainGrid.editIndex];
		MainGrid.updateRow({
			index: MainGrid.editIndex,
			row: {
				InciId: row.InciDr,
				InciCode: row.InciCode,
				UomId: row.PUomDr,
				UomDesc: row.PUomDesc,
				Rp: row.PRp,
				Sp: row.PSp,
				InciDesc: row.InciDesc,
				Spec: row.Spec,
				ManfDesc: row.ManfName
			}
		});
		if (!isEmpty(Row.Qty)) {
			Row.SpAmt = accMul(Number(Row.Qty), Number(Row.Sp));
			Row.RpAmt = accMul(Number(Row.Qty), Number(Row.Rp));
		}
		setTimeout(function () {
			MainGrid.refreshRow();
			MainGrid.startEditingNext('InciDesc');
		}, 0);
	}

	var MainCm = [[{
				title: 'RowId',
				field: 'RowId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: '����RowId',
				field: 'InciId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: '���ʴ���',
				field: 'InciCode',
				width: 100
			}, {
				title: '��������',
				field: 'InciDesc',
				editor: InciEditor(HandlerParams, SelectRow),
				width: 150
			}, {
				title: "���",
				field: 'Spec',
				width: 100
			}, {
				title: "����",
				field: 'Manf',
				width: 150
			}, {
				title: "����",
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
				title: "��λ",
				field: 'UomId',
				saveCol: true,
				formatter: CommonFormatter(UomCombox, 'UomId', 'UomDesc'),
				editor: UomCombox,
				width: 80
			}, {
				title: "�ۼ�",
				field: 'Sp',
				width: 80,
				align: 'right'
			}, {
				title: "�ۼ۽��",
				field: 'SpAmt',
				width: 100,
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
				title: '״̬',
				field: 'Status',
				width: 90,
				formatter: function (value, row, index) {
					if (value == "G") {
						return "������";
					} else if (value == "D") {
						return "�Ѵ���";
					} else if (value == "X") {
						return "������";
					} else if (value == "R") {
						return "�Ѿܾ�";
					}
				}
			}
		]];

	var MainGrid = $UI.datagrid('#MainGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCINDispReqItm',
				QueryName: 'DHCINDispReqItm'
			},
			deleteRowParams: {
				ClassName: 'web.DHCSTMHUI.DHCINDispReqItm',
				MethodName: 'jsDelete'
			},
			columns: MainCm,
			remoteSort: false,
			showBar: true,
			showAddDelItems: true,
			onClickCell: function (index, field, value) {
				MainGrid.commonClickCell(index, field, value);
			},
			onBeforeCellEdit: function (index, field) {
				if ($HUI.checkbox('#CompFlag').getValue()) {
					$UI.msg("alert", "�Ѿ���ɣ������޸�!");
					return false;
				}
			},
			onEndEdit: function (index, row, changes) {
				var Editors = $(this).datagrid('getEditors', index);
				for (var i = 0; i < Editors.length; i++) {
					var Editor = Editors[i];
					if (Editor.field == 'Qty') {
						var Qty = row.Qty;
						if (!isEmpty(Qty)) {
							row.SpAmt = accMul(Number(row.Qty), Number(row.Sp));
							row.RpAmt = accMul(Number(row.Qty), Number(row.Rp));
						}
					}
				}
			},
			beforeDelFn: function () {
				if ($HUI.checkbox('#CompFlag').getValue()) {
					$UI.msg("alert", "�Ѿ���ɣ�����ɾ��ѡ����!");
					return false;
				}
			},
			beforeAddFn: function () {
				if ($HUI.checkbox('#CompFlag').getValue()) {
					$UI.msg("alert", "�Ѿ���ɣ���������һ��!");
					return false;
				}
				if (isEmpty($HUI.combobox("#LocId").getValue())) {
					$UI.msg("alert", "���Ҳ���Ϊ��!");
					return false;
				};
			},
			onLoadSuccess: function (data) {
				var RowId = $('#RowId').val();
				if (isEmpty(RowId)) {
					for (var i = 0; i < data.rows.length; i++) {
						data.rows[i].RowId = '';
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
			$UI.clearBlock('#Conditions');
			$UI.clear(MainGrid);
			setEditEnable();
			SetDefaValues();
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
				$UI.msg('alert', '��ѡ�����!')
				return;
			}
			var ReqMode = $("input[name='ReqMode']:checked").val();
			if ((ReqMode == '0') && (isEmpty(MainObj['UserGrp']))) {
				$UI.msg('alert', '��ѡ��רҵ��!')
				return;
			}
			var Main = JSON.stringify(MainObj);
			var Detail = MainGrid.getChangesData();
			if (Detail === false){	//δ��ɱ༭����ϸΪ��
				return;
			}
			if (isEmpty(Detail)){	//��ϸ����
				$UI.msg("alert", "û����Ҫ�������ϸ!");
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINDispReq',
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
			var DsrqId = ParamsObj['RowId'];
			if (isEmpty(DsrqId)) {
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
			var DsrqId = ParamsObj['RowId'];
			if (isEmpty(DsrqId)) {
				return;
			}
			var CompFlag = ParamsObj['CompFlag'];
			if (CompFlag == 'Y') {
				$UI.msg('alert', '�õ��������,�����ظ�����!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINDispReq',
				MethodName: 'SetComp',
				Dsrq: DsrqId
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
			var DsrqId = ParamsObj['RowId'];
			if (isEmpty(DsrqId)) {
				return;
			}
			var CompFlag = ParamsObj['CompFlag'];
			if (CompFlag != 'Y') {
				$UI.msg('alert', '�õ��ݲ������״̬,���ɲ���!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINDispReq',
				MethodName: 'CancelComp',
				Dsrq: DsrqId
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
	$UI.linkbutton('#CancelBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var DsrqId = ParamsObj['RowId'];
			if (isEmpty(DsrqId)) {
				return;
			}
			var CompFlag = ParamsObj['CompFlag'];
			if (CompFlag != 'Y') {
				$UI.msg('alert', '�õ���δ���,��������!');
				return;
			}
			$UI.confirm('����Ҫ���ϵ���,�Ƿ����?', '', '', CancelReq);
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function () {
			PrintINDispReq($('#RowId').val());
		}
	});

	function CancelReq() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var DsrqId = ParamsObj['RowId'];
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINDispReq',
			MethodName: 'CancelReq',
			Dsrq: DsrqId
		}, function (jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				Select(jsonData.rowid);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	function Delete() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var DsrqId = ParamsObj['RowId'];
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINDispReq',
			MethodName: 'Delete',
			DsrqId: DsrqId
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

	function setEditDisable() {
		$HUI.combobox("#LocId").disable();
		$HUI.combobox("#Scg").disable();
		ChangeButtonEnable({
			'#DelBT': false,
			'#ComBT': false,
			'#SaveBT': false,
			'#CanComBT': true,
			'#CancelBT': true
		});
	}

	function setEditEnable() {
		$HUI.combobox("#LocId").enable();
		$HUI.combobox("#Scg").enable();
		ChangeButtonEnable({
			'#DelBT': true,
			'#ComBT': true,
			'#SaveBT': true,
			'#CanComBT': false,
			'#CancelBT': false
		});
	}

	function Select(Dsrq) {
		$UI.clearBlock('#Conditions');
		$UI.clear(MainGrid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINDispReq',
			MethodName: 'Select',
			Dsrq: Dsrq
		}, function (jsonData) {
			$UI.fillBlock('#Conditions', jsonData);
			if ($HUI.checkbox('#CompFlag').getValue()) {
				setEditDisable();
			} else {
				setEditEnable();
			}
		});
		MainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINDispReqItm',
			QueryName: 'DHCINDispReqItm',
			Parref: Dsrq
		});
	}

	SetDefaValues();
}
$(init);
