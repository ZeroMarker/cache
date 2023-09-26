var ToolBar, PayCm, PayGrid;
var init = function () {
	var IngrLocParams = JSON.stringify(addSessionParams({
				Type: 'Login'
			}));
	var IngrLocBox = $HUI.combobox('#IngrLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + IngrLocParams,
			valueField: 'RowId',
			textField: 'Description'
		});

	var VendorParams = JSON.stringify(addSessionParams({
				APCType: "M",
				RcFlag: "Y"
			}));
	var VendorBox = $HUI.combobox('#Vendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
			valueField: 'RowId',
			textField: 'Description'
		});

	var UserBox = $HUI.combobox('#PayUser', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetUser&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description'
		});

	var PurUserBox = $HUI.combobox('#PurUser', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetUser&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description'
		});

	var AccUserBox = $HUI.combobox('#AccUser', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetUser&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description'
		});

	ToolBar = [{
			text: 'ɾ��',
			iconCls: 'icon-cancel',
			handler: function () {
				var ParamsObj = $UI.loopBlock('#MainConditions');
				if (ParamsObj.Comp == "Y") {
					$UI.msg('alert', '�����,����ɾ��!');
					return;
				}
				if (ParamsObj.PurConfirm == "Y") {
					$UI.msg('alert', '�Ѳɹ�ȷ��,����ɾ��!');
					return;
				}
				if (ParamsObj.AccConfirm == "Y") {
					$UI.msg('alert', '�ѻ��ȷ��,����ɾ��!');
					return;
				}
				var Rows = PayGrid.getSelections();
				if (Rows.length <= 0) {
					$UI.msg('alert', '��ѡ��Ҫɾ������ϸ!');
					return;
				}
				var Params = PayGrid.getSelectedData();
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCPayItm',
					MethodName: 'Delete',
					PayId: ParamsObj.RowId,
					Params: JSON.stringify(Params)
				}, function (jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						Select(ParamsObj.RowId);
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}
	];

	PayCm = [[{
				field: 'ck',
				checkbox: true
			}, {
				title: 'RowId',
				field: 'RowId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: '���(�˻�)RowId',
				field: 'Pointer',
				width: 50,
				hidden: true
			}, {
				title: '����',
				field: 'TransType',
				width: 100,
				formatter: function (value, row, index) {
					if (value == "G") {
						return "���";
					} else {
						return "�˻�";
					}
				}
			}, {
				title: '����Inclb',
				field: 'Inclb',
				width: 50,
				hidden: true
			}, {
				title: '����RowId',
				field: 'Inci',
				width: 50,
				hidden: true
			}, {
				title: '����',
				field: 'Code',
				width: 100
			}, {
				title: '����',
				field: 'Description',
				width: 150
			}, {
				title: "���",
				field: 'Spec',
				width: 100
			}, {
				title: "����",
				field: 'Qty',
				width: 100,
				align: 'right'
			}, {
				title: "��λ",
				field: 'UomDesc',
				width: 100
			}, {
				title: "�����",
				field: 'RecAmt',
				width: 100,
				align: 'right'
			}, {
				title: "������",
				field: 'PayAmt',
				width: 100,
				align: 'right'
			}, {
				title: "�����ۼƽ��",
				field: 'SumPayAmt',
				width: 100,
				align: 'right'
			}, {
				title: "����",
				field: 'Rp',
				width: 100,
				align: 'right'
			}, {
				title: "���۽��",
				field: 'RpAmt',
				width: 100,
				align: 'right'
			}, {
				title: "�ۼ�",
				field: 'Sp',
				width: 100,
				align: 'right'
			}, {
				title: "�ۼ۽��",
				field: 'SpAmt',
				width: 100,
				align: 'right'
			}, {
				title: "����",
				field: 'Manf',
				width: 150
			}, {
				title: "��Ʊ��",
				field: 'InvNo',
				width: 100
			}, {
				title: "��Ʊ����",
				field: 'InvDate',
				width: 100
			}, {
				title: "���ݺ�",
				field: 'GRNo',
				width: 200
			}, {
				title: "���е���",
				field: 'InsxNo',
				width: 200
			}, {
				title: "����",
				field: 'BatNo',
				width: 100
			}, {
				title: "Ч��",
				field: 'ExpDate',
				width: 100
			}
		]];

	PayGrid = $UI.datagrid('#PayGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCPayItm',
				QueryName: 'DHCPayItm',
				rows: 99999
			},
			columns: PayCm,
			toolbar: ToolBar,
			singleSelect: false,
			pagination: false
		});

	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#MainConditions');
			if (isEmpty(ParamsObj.IngrLoc)) {
				$UI.msg('alert', '�����Ҳ���Ϊ��!');
				return;
			}
			FindWin(ParamsObj.IngrLoc, Select);
		}
	});

	$UI.linkbutton('#DelBT', {
		onClick: function () {
			var RowId = $('#RowId').val();
			if (isEmpty(RowId)) {
				return;
			}
			var ParamsObj = $UI.loopBlock('#MainConditions');
			if (ParamsObj.Comp == "Y") {
				$UI.msg('alert', '�����,����ɾ��!');
				return;
			}
			if (ParamsObj.PurConfirm == "Y") {
				$UI.msg('alert', '�Ѳɹ�ȷ��,����ɾ��!');
				return;
			}
			if (ParamsObj.AccConfirm == "Y") {
				$UI.msg('alert', '�ѻ��ȷ��,����ɾ��!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCPay',
				MethodName: 'Delete',
				PayId: $('#RowId').val()
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					Clear();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	$UI.linkbutton('#ComBT', {
		onClick: function () {
			var RowId = $('#RowId').val();
			if (isEmpty(RowId)) {
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCPay',
				MethodName: 'SetComp',
				PayId: RowId
			}, function (jsonData) {
				if (jsonData.success == 0) {
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
			var RowId = $('#RowId').val();
			if (isEmpty(RowId)) {
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCPay',
				MethodName: 'CancelComp',
				PayId: RowId
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					Select(jsonData.rowid);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			Clear();
		}
	});

	$UI.linkbutton('#PrintBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#MainConditions');
			if (isEmpty(ParamsObj.RowId)) {
				$UI.msg('alert', "û����Ҫ��ӡ�ĸ��!");
				return;
			}
			PrintPay(ParamsObj.RowId);
		}
	});

	$UI.linkbutton('#QueryPayBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#MainConditions');
			if (isEmpty(ParamsObj.IngrLoc)) {
				$UI.msg('alert', '�����Ҳ���Ϊ��!');
				return;
			}
			var RowId = $('#RowId').val();
			FindPayWin(ParamsObj.IngrLoc, RowId, Select);
		}
	});

	SetDefaValues();
}
$(init);

function setEditDisable() {
	$HUI.combobox("#IngrLoc").disable();
	$HUI.combobox("#Vendor").disable();
	ChangeButtonEnable({'#DelBT':false,'#ComBT':false,'#CanComBT':true});
}

function setEditEnable() {
	$HUI.combobox("#IngrLoc").enable();
	$HUI.combobox("#Vendor").enable();
	ChangeButtonEnable({'#DelBT':true,'#ComBT':true,'#CanComBT':false});
}

function Select(Pay) {
	$UI.clearBlock('#MainConditions');
	$UI.clear(PayGrid);
	$.cm({
		ClassName: 'web.DHCSTMHUI.DHCPay',
		MethodName: 'Select',
		Pay: Pay
	}, function (jsonData) {
		$UI.fillBlock('#MainConditions', jsonData);
		if ($HUI.checkbox('#Comp').getValue()) {
			setEditDisable();
		} else {
			setEditEnable();
		}
	});
	PayGrid.load({
		ClassName: 'web.DHCSTMHUI.DHCPayItm',
		QueryName: 'DHCPayItm',
		Pay: Pay,
		rows: 99999
	});
}

function Clear() {
	$UI.clearBlock('#MainConditions');
	$UI.clear(PayGrid);
	setEditEnable();
	SetDefaValues();
}
