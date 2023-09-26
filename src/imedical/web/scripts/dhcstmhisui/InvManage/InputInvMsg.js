var ToolBar, InvMainCm, InvDetailCm, InvMainGrid, InvDetailGrid;
var IsOneRow = 1;
var init = function () {
	var VendorParams = JSON.stringify(addSessionParams({
				APCType: "M",
				RcFlag: "Y"
			}));
	var VendorBox = $HUI.combobox('#Vendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
			valueField: 'RowId',
			textField: 'Description'
		});

	ToolBar = [{
			text: '����',
			iconCls: 'icon-save',
			handler: function () {
				var Rows = InvMainGrid.getChangesData();
				if (Rows === false){	//δ��ɱ༭����ϸΪ��
					return;
				}
				if (isEmpty(Rows)){	//��ϸ����
					$UI.msg("alert", "û����Ҫ�������ϸ!");
					return;
				}
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCVendorInv',
					MethodName: 'SaveInvNo',
					Params: JSON.stringify(Rows)
				}, function (jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						Select();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}
	];

	InvMainCm = [[{
				title: "RowId",
				field: 'RowId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: "����",
				field: 'Icon',
				width: 50,
				align: 'center',
				formatter: function (value, row, index) {
					var str = "<a href='#' onclick='Print(" + row.RowId + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/print.png' title='��ӡ' border='0'></a>";
					return str;
				}
			}, {
				title: "��ϵ���",
				field: 'AssemNo',
				width: 180
			}, {
				title: "Vendor",
				field: 'Vendor',
				width: 50,
				hidden: true
			}, {
				title: "��Ӧ��",
				field: 'VendorDesc',
				width: 180
			}, {
				title: "�Ƶ���",
				field: 'CreateUser',
				width: 80
			}, {
				title: "�Ƶ�����",
				field: 'CreateDate',
				width: 100
			}, {
				title: "�Ƶ�ʱ��",
				field: 'CreateTime',
				width: 80
			}, {
				title: "��Ͻ���",
				field: 'RpAmt',
				width: 80,
				align: 'right'
			}, {
				title: "��Ʊ��",
				field: 'InvNo',
				width: 120,
				saveCol: true,
				editor: {
					type: 'text',
					options: {}
				}
			}, {
				title: "��Ʊ���",
				field: 'InvRpAmt',
				width: 80,
				align: 'right',
				saveCol: true,
				editor: {
					type: 'numberbox',
					options: {}
				}
			}, {
				title: "��Ʊ����",
				field: 'InvDate',
				width: 100,
				saveCol: true,
				editor: {
					type: 'datebox',
					options: {}
				}
			}
		]];

	InvMainGrid = $UI.datagrid('#InvMainGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				QueryName: 'DHCVendorInv'
			},
			toolbar: ToolBar,
			columns: InvMainCm,
			fitColumns: true,
			onSelect: function (index, row) {
				if (IsOneRow == 1) {
					InvDetailGrid.load({
						ClassName: 'web.DHCSTMHUI.DHCVendorInv',
						QueryName: 'DHCVendorInvItm',
						Inv: row.RowId,
						rows: 99999
					});
				} else {
					IsOneRow = 1;
				}
			},
			onClickCell: function (index, filed, value) {
				InvMainGrid.commonClickCell(index, filed)
			},
			onLoadSuccess: function (data) {
				if (data.rows.length > 0) {
					InvMainGrid.selectRow(0);
				}
			}
		});

	InvDetailCm = [[{
				title: "RowId",
				field: 'RowId',
				width: 50,
				hidden: true,
				saveCol: true
			}, {
				title: "Ingri",
				field: 'Ingri',
				width: 50,
				hidden: true
			}, {
				title: "IncId",
				field: 'IncId',
				width: 50,
				hidden: true
			}, {
				title: "���ʴ���",
				field: 'Code',
				width: 150
			}, {
				title: "��������",
				field: 'Description',
				width: 150
			}, {
				title: "���",
				field: 'Spec',
				width: 100
			}, {
				title: "��λ",
				field: 'UomDesc',
				width: 90
			}, {
				title: "����",
				field: 'Qty',
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
				align: 'right',
				hidden: true
			}, {
				title: "�ۼ۽��",
				field: 'SpAmt',
				width: 80,
				align: 'right',
				hidden: true
			}, {
				title: "����",
				field: 'Manf',
				width: 180
			}, {
				title: "����",
				field: 'Type',
				width: 70,
				formatter: function (value, row, index) {
					if (value == "G") {
						return "���";
					} else {
						return "�˻�";
					}
				}
			}
		]];

	InvDetailGrid = $UI.datagrid('#InvDetailGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				QueryName: 'DHCVendorInvItm',
				rows: 99999
			},
			pagination:false,
			columns: InvDetailCm,
			fitColumns: true
		});

	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#MainConditions');
			if (isEmpty(ParamsObj.StartDate)) {
				$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
				return;
			}
			if (isEmpty(ParamsObj.EndDate)) {
				$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
				return;
			}
			ParamsObj.Complate="Y"
			var Params = JSON.stringify(ParamsObj);
			$UI.clear(InvDetailGrid);
			InvMainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				QueryName: 'DHCVendorInv',
				LocId: gLocObj,
				Params: Params
			});
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			$UI.clearBlock('#MainConditions');
			$UI.clear(InvMainGrid);
			$UI.clear(InvDetailGrid);
			SetDefaValues();
		}
	});

	SetDefaValues();
}
$(init);

function Select() {
	$UI.clear(InvMainGrid);
	$UI.clear(InvDetailGrid);
	InvMainGrid.commonReload();
}
function Print(RowId) {
	IsOneRow = 0;
	PrintInv(RowId);
}
