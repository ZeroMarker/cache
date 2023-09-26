var GRToolBar, GRCm, GRGrid, ToolBar, ReimPayCm, ReimPayGrid;
var init = function () {
	var IngrLocParams = JSON.stringify(addSessionParams({
				Type: 'Login'
			}));
	var IngrLocBox = $HUI.combobox('#IngrLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + IngrLocParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	$('#IngrLoc').combobox('setValue', gLocId);

	GRToolBar = [{
			text: '���뱨֧��',
			iconCls: 'icon-add',
			handler: function () {
				var ParamsObj = $UI.loopBlock('#PayConditions');
				var Main = JSON.stringify(ParamsObj);
				var Detail = GRGrid.getRowsData();
				if (Detail==""){
					$UI.msg('error', "������˻�����Ʊ��ϸ!");
					return;
				}
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCReimPay',
					MethodName: 'Save',
					Main: Main,
					Detail: JSON.stringify(Detail)
				}, function (jsonData) {
					if (jsonData.success == 0) {
						$UI.clearBlock('#PayConditions');
						$UI.clear(ReimPayGrid);
						$.cm({
							ClassName: 'web.DHCSTMHUI.DHCReimPay',
							MethodName: 'Select',
							RowId: jsonData.rowid
						}, function (jsonData) {
							$UI.fillBlock('#PayConditions', jsonData);
							Select();
							Clear();
						});
					}else{
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}
	];

	GRCm = [[{
				title: 'RowId',
				field: 'RowId',
				width: 50,
				hidden: true
			}, {
				title: '���(�˻�)RowId',
				field: 'Ingri',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: '����',
				field: 'GRNo',
				width: 200
			}, {
				title: '����',
				field: 'Type',
				width: 80,
				saveCol: true,
				formatter: function (value, row, index) {
					if (value == "G") {
						return "���";
					} else {
						return "�˻�";
					}
				}
			}, {
				title: '����RowId',
				field: 'Inci',
				width: 50,
				hidden: true
			}, {
				title: '����',
				field: 'InciCode',
				width: 150
			}, {
				title: '����',
				field: 'InciDesc',
				width: 200
			}, {
				title: "��Ʊ��",
				field: 'InvNo',
				saveCol: true,
				width: 100
			}, {
				title: "���",
				field: 'RpAmt',
				width: 100,
				saveCol: true,
				align: 'right'
			}, {
				title: "��Ӧ��",
				field: 'VendorDesc',
				width: 200
			}
		]];

	GRGrid = $UI.datagrid('#GRGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCReimPay',
				QueryName: 'DHCING',
				rows: 99999
			},
			pagination: false,
			toolbar: GRToolBar,
			columns: GRCm
		});

	ToolBar = [{
			text: '����',
			iconCls: 'icon-save',
			handler: function () {
				var Data = ReimPayGrid.getChangesData();
				if (Data === false){	//δ��ɱ༭����ϸΪ��
					return;
				}
				if (isEmpty(Data)){	//��ϸ����
					$UI.msg("alert", "û����Ҫ�������ϸ!");
					return;
				}
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCReimPayInv',
					MethodName: 'Update',
					Data: JSON.stringify(Data)
				}, function (jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						Select();
					}else{
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}, {
			text: 'ɾ��',
			iconCls: 'icon-cancel',
			handler: function () {
				var Rows = ReimPayGrid.getSelections();
				if (Rows.length <= 0) {
					$UI.msg('alert', '��ѡ��Ҫɾ������Ϣ!');
					return;
				}
				var Data = ReimPayGrid.getSelectedData();
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCReimPayInv',
					MethodName: 'Delete',
					Data: JSON.stringify(Data)
				}, function (jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						Select();
					}else{
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}, {
			text: '��ӡ',
			iconCls: 'icon-print',
			handler: function () {
				Print();
			}
		}, '-', {
			text: '����ƾ֤',
			iconCls: 'icon-exe-order',
			handler: function () {
				var ParamsObj = $UI.loopBlock('#PayConditions');
				var Params = JSON.stringify(ParamsObj);
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCReimPay',
					MethodName: 'AcctVoucherNo',
					Params: Params
				}, function (jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
					}else{
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}, {
			text: '��ӡƾ֤',
			iconCls: 'icon-print',
			handler: function () {
				PrintVoucher();
			}
		}
	];

	ReimPayCm = [[{
				field: 'ck',
				checkbox: true
			}, {
				title: 'RowId',
				field: 'RowId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: '��Ʊ��',
				field: 'InvNo',
				width: 100
			}, {
				title: '��Ʊ���',
				field: 'InvAmt',
				width: 100,
				align: 'right'
			}, {
				title: "�ۿ���",
				field: 'UnPayAmt',
				width: 100,
				align: 'right',
				saveCol: true,
				editor: {
					type: 'numberbox'
				}
			}, {
				title: "ʵ�����",
				field: 'PayAmt',
				width: 100,
				align: 'right'
			}, {
				title: "��Ӧ��",
				field: 'VendorDesc',
				width: 200
			}
		]];

	ReimPayGrid = $UI.datagrid('#ReimPayGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCReimPayInv',
				QueryName: 'DHCReimPayInv',
				rows: 99999
			},
			toolbar: ToolBar,
			columns: ReimPayCm,
			singleSelect: false,
			pagination: false,
			onClickCell: function (index, filed, value) {
				ReimPayGrid.commonClickCell(index, filed)
			}
		});

	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#MainConditions');
			if (isEmpty(ParamsObj.IngrLoc)) {
				$UI.msg('alert', '��ѡ��������!');
				return;
			}
			if (isEmpty(ParamsObj.InvNo)) {
				$UI.msg('alert', '�����뷢Ʊ��!');
				return;
			}
			var ReimPayFlag = tkMakeServerCall("web.DHCSTMHUI.DHCReimPay", "CheckLocInv", ParamsObj.IngrLoc, ParamsObj.InvNo);
			if (ReimPayFlag == -1) {
				$UI.msg('alert', '�÷�Ʊ�Ŵ���δ��˵ĵ���!');
				return;
			}
			if (ReimPayFlag == -2) {
				$UI.msg('alert', '�÷�Ʊ��û����Ҫ����ĵ���!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			GRGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCReimPay',
				QueryName: 'DHCING',
				Params: Params,
				rows: 99999
			});
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			Clear();
		}
	});

	$UI.linkbutton('#QueryPayBT', {
		onClick: function () {
			Select();
		}
	});

	$UI.linkbutton('#ClearPayBT', {
		onClick: function () {
			$UI.clearBlock('#PayConditions');
			$UI.clear(ReimPayGrid);
		}
	});
}
$(init);
function Clear() {
	$UI.clearBlock('#MainConditions');
	$UI.clear(GRGrid);
	$('#IngrLoc').combobox('setValue', gLocId);
}

function Select(){
	var ParamsObj = $UI.loopBlock('#PayConditions');
	var ReimPayNo = ParamsObj.ReimPayNo;
	if (isEmpty(ReimPayNo) && isEmpty(ParamsObj.InvNo)) {
		$UI.msg('alert', '�����뱨֧���Ż�Ʊ��!');
		return;
	}
	if (ParamsObj.InvNo!=""){
		ReimPayNo=tkMakeServerCall('web.DHCSTMHUI.DHCReimPayInv','GetRPNoByInvNo',ParamsObj.InvNo)
		$('#ReimPayNo').val(ReimPayNo);
	}
	ReimPayGrid.load({
		ClassName: 'web.DHCSTMHUI.DHCReimPayInv',
		QueryName: 'DHCReimPayInv',
		ReimPayNo: ReimPayNo,
		rows: 99999
	});
}
function Print(){
	var ParamsObj = $UI.loopBlock('#PayConditions');
	var ReimPayNo = ParamsObj.ReimPayNo;
	if(isEmpty(ReimPayNo)){
		$UI.msg('alert', '����д��Ҫ��ӡ�ı�֧����!');
		return;
	}
	var RaqName = 'DHCSTM_HUI_ReimPay.raq';
	var DirectPrintStr = '{' + RaqName + '(ReimPayNo=' + ReimPayNo +')}';
	DHCCPM_RQDirectPrint(DirectPrintStr);
}
function PrintVoucher(){
	var ParamsObj = $UI.loopBlock('#PayConditions');
	var ReimPayNo = ParamsObj.ReimPayNo;
	if(isEmpty(ReimPayNo)){
		$UI.msg('alert', '����д��Ҫ��ӡ�ı�֧����!');
		return;
	}
	var RaqName = 'DHCSTM_HUI_ReimPayPZ.raq';
	var DirectPrintStr = '{' + RaqName + '(ReimPayNo=' + ReimPayNo +')}';
	DHCCPM_RQDirectPrint(DirectPrintStr);
}