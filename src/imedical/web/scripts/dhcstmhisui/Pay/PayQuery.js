var PayMainCm, PayDetailCm, ToolBar;
var PayMainGrid, PayDetailGrid;
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

	var PayModeBox = $HUI.combobox('#PayMode', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPayMode&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description'
		});

	ToolBar = [{
			text: '�ɹ�ȷ��',
			iconCls: 'icon-accept',
			handler: function () {
				var Row = PayMainGrid.getSelected();
				if (isEmpty(Row)) {
					$UI.msg('alert', '��ѡ�񸶿!');
					return;
				}
				var Params = JSON.stringify(addSessionParams({
							Pay: Row.RowId
						}));
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCPayQuery',
					MethodName: 'PurConfirm',
					Params: Params
				}, function (jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						Select();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}, {
			text: '���ȷ��',
			iconCls: 'icon-accept',
			handler: function () {
				var Row = PayMainGrid.getSelected();
				if (isEmpty(Row)) {
					$UI.msg('alert', '��ѡ�񸶿!');
					return;
				}
				if (Row.AccConfirm == "Y") {
					$UI.msg('alert', '�˸���ѻ��ȷ��!');
					return;
				}
				AccAckWin(Row, Select);
			}
		}, {
			text: '����ȷ��',
			iconCls: 'icon-accept',
			handler: function () {
				var Row = PayMainGrid.getSelected();
				if (isEmpty(Row)) {
					$UI.msg('alert', '��ѡ�񸶿!');
					return;
				}
				var Params = JSON.stringify(addSessionParams({
							Pay: Row.RowId
						}));
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCPayQuery',
					MethodName: 'FinConfirm',
					Params: Params
				}, function (jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						Select();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}, '-', {
			text: '��ӡ',
			iconCls: 'icon-print',
			handler: function () {
				var Row = PayMainGrid.getSelected();
				if (isEmpty(Row)) {
					$UI.msg('alert', '��ѡ�񸶿!');
					return;
				}
				PrintPay(Row.RowId);
			}
		}
	];

	PayMainCm = [[{
				title: "RowId",
				field: 'RowId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: "Vendor",
				field: 'Vendor',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: "�����",
				field: 'PayNo',
				width: 200
			}, {
				title: "��Ӧ��",
				field: 'VendorDesc',
				width: 200
			}, {
				title: "�Ƶ���",
				field: 'UserName',
				width: 80
			}, {
				title: "�Ƶ�����",
				field: 'Date',
				width: 100
			}, {
				title: "�Ƶ�ʱ��",
				field: 'Time',
				width: 80
			}, {
				title: "������",
				field: 'PayAmt',
				width: 100,
				align: 'right'
			}, {
				title: "�ɹ�ȷ��",
				field: 'PurConfirm',
				width: 80
			}, {
				title: "�ɹ�ȷ����",
				field: 'PurConfirmUser',
				width: 100
			}, {
				title: "�ɹ�ȷ������",
				field: 'PurConfirmDate',
				saveCol: true,
				width: 100
			}, {
				title: "���ȷ��",
				field: 'AccConfirm',
				width: 80
			}, {
				title: "���ȷ����",
				field: 'AccConfirmUser',
				width: 100
			}, {
				title: "���ȷ������",
				field: 'AccConfirmDate',
				saveCol: true,
				width: 100
			}, {
				title: "����ȷ��",
				field: 'FinConfirm',
				width: 80
			}, {
				title: "����ȷ����",
				field: 'FinConfirmUser',
				width: 100
			}, {
				title: "����ȷ������",
				field: 'FinConfirmDate',
				saveCol: true,
				width: 100
			}, {
				title: "֧����ʽ",
				field: 'PayMode',
				width: 80
			}, {
				title: "֧������",
				field: 'CheckNo',
				width: 100
			}, {
				title: "֧�����",
				field: 'CheckAmt',
				width: 100,
				align: 'right'
			}
		]];

	PayMainGrid = $UI.datagrid('#PayMainGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCPay',
				QueryName: 'DHCPay'
			},
			toolbar: ToolBar,
			columns: PayMainCm,
			onSelect: function (index, row) {
				PayDetailGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCPayItm',
					QueryName: 'DHCPayItm',
					Pay: row.RowId,
					rows: 99999
				});
			},
			onLoadSuccess: function (data) {
				if (data.rows.length > 0) {
					PayMainGrid.selectRow(0);
				}
			}
		});

	PayDetailCm = [[{
				title: "RowId",
				field: 'RowId',
				width: 50,
				hidden: true
			}, {
				title: "����˻�Id",
				field: 'Pointer',
				width: 50,
				hidden: true
			}, {
				title: "Inci",
				field: 'Inci',
				width: 50,
				hidden: true
			}, {
				title: "���ʴ���",
				field: 'Code',
				width: 150
			}, {
				title: "��������",
				field: 'Description',
				width: 200
			}, {
				title: "���",
				field: 'Spec',
				width: 100
			}, {
				title: "����",
				field: 'BatNo',
				width: 100
			}, {
				title: "��Ч��",
				field: 'ExpDate',
				width: 100
			}, {
				title: "��λ",
				field: 'UomDesc',
				width: 80
			}, {
				title: "����",
				field: 'Qty',
				width: 80,
				align: 'right'
			}, {
				title: "������",
				field: 'PayAmt',
				width: 80,
				align: 'right'
			}, {
				title: "����",
				field: 'Rp',
				width: 80,
				align: 'right'
			}, {
				title: "���۽��",
				field: 'RpAmt',
				width: 80,
				align: 'right'
			}, {
				title: "�ۼ�",
				field: 'Sp',
				width: 80,
				align: 'right'
			}, {
				title: "�ۼ۽��",
				field: 'SpAmt',
				width: 80,
				align: 'right'
			}, {
				title: "����",
				field: 'Manf',
				width: 200
			}, {
				title: "��Ʊ��",
				field: 'InvNo',
				width: 80
			}, {
				title: "��Ʊ����",
				field: 'InvDate',
				width: 100
			}, {
				title: "��Ʊ���",
				field: 'InvAmt',
				width: 80,
				align: 'right'
			}, {
				title: "�����־",
				field: 'OverFlag',
				width: 80
			}, {
				title: "ҵ�񵥺�",
				field: 'GRNo',
				width: 200
			}, {
				title: "����",
				field: 'TransType',
				width: 80,
				formatter: function (value, row, index) {
					if (value == "G") {
						return "���";
					} else {
						return "�˻�";
					}
				}
			}
		]];

	PayDetailGrid = $UI.datagrid('#PayDetailGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCINGdRecPaymentApproval',
				QueryName: 'QueryDetail',
				rows: 99999
			},
			pagination:false,
			columns: PayDetailCm
		});

	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#MainConditions');
			if (isEmpty(ParamsObj.IngrLoc)) {
				$UI.msg('alert', '�ɹ����Ҳ���Ϊ��!');
				return;
			}
			if (isEmpty(ParamsObj.StartDate)) {
				$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
				return;
			}
			if (isEmpty(ParamsObj.EndDate)) {
				$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			PayMainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCPay',
				QueryName: 'DHCPay',
				LocId: ParamsObj.IngrLoc,
				Params: Params
			});
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			$UI.clearBlock('#MainConditions');
			$UI.clear(PayMainGrid);
			$UI.clear(PayDetailGrid);
			SetDefaValues();
		}
	});

	SetDefaValues();
}
$(init);
function Select() {
	$UI.clear(PayMainGrid);
	$UI.clear(PayDetailGrid);
	PayMainGrid.commonReload();
}
