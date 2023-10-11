var PayMainCm, PayDetailCm, ToolBar;
var PayMainGrid, PayDetailGrid;
var init = function() {
	var IngrLocParams = JSON.stringify(addSessionParams({
		Type: 'Login'
	}));
	var IngrLocBox = $HUI.combobox('#IngrLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + IngrLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			if (CommParObj.ApcScg == 'L') {
				VendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M', LocId: LocId }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
				VendorBox.reload(url);
			}
		}
	});

	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
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

	ToolBar = [
		{
			text: '�ɹ�ȷ��',
			iconCls: 'icon-shopping-cart-ok',
			handler: function() {
				var RowData = PayMainGrid.getSelections();
				var PayIdStr = '';
				for (var i = 0; i < RowData.length; i++) {
					var PayId = RowData[i].RowId;
					if (PayIdStr == '') {
						PayIdStr = PayId;
					} else {
						PayIdStr = PayIdStr + '^' + PayId;
					}
				}
				if (PayIdStr == '') {
					$UI.msg('alert', 'û����Ҫȷ�ϵĵ���!');
					return false;
				}
				var Params = JSON.stringify(sessionObj);
				showMask();
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCPayQuery',
					MethodName: 'jsPurConfirm',
					PayIdStr: PayIdStr,
					Params: Params
				}, function(jsonData) {
					hideMask();
					if (jsonData.success == 0) {
						Select();
						var info = jsonData.msg;
						var infoArr = info.split('@');
						var Allcnt = infoArr[0];
						var Succnt = infoArr[1];
						var failcnt = Allcnt - Succnt;
						var ErrInfo = infoArr[2];
						$UI.msg('success', '��:' + Allcnt + '��¼,�ɹ�:' + Succnt + '��');
						if (failcnt > 0) {
							$UI.msg('error', 'ʧ��:' + failcnt + '��;' + ErrInfo);
						}
					}
				});
			}
		}, {
			text: '���ȷ��',
			iconCls: 'icon-person-ok',
			handler: function() {
				var Row = PayMainGrid.getSelected();
				if (isEmpty(Row)) {
					$UI.msg('alert', '��ѡ�񸶿!');
					return;
				}
				if (Row.AccConfirm == 'Y') {
					$UI.msg('alert', '�˸���ѻ��ȷ��!');
					return;
				}
				AccAckWin(Row, Select);
			}
		}, {
			text: '����ȷ��',
			iconCls: 'icon-mnypaper-ok',
			handler: function() {
				var RowData = PayMainGrid.getSelections();
				var PayIdStr = '';
				for (var i = 0; i < RowData.length; i++) {
					var PayId = RowData[i].RowId;
					if (PayIdStr == '') {
						PayIdStr = PayId;
					} else {
						PayIdStr = PayIdStr + '^' + PayId;
					}
				}
				if (PayIdStr == '') {
					$UI.msg('alert', 'û����Ҫȷ�ϵĵ���!');
					return false;
				}
				var Params = JSON.stringify(sessionObj);
				showMask();
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCPayQuery',
					MethodName: 'jsFinConfirm',
					PayIdStr: PayIdStr,
					Params: Params
				}, function(jsonData) {
					hideMask();
					if (jsonData.success == 0) {
						Select();
						var info = jsonData.msg;
						var infoArr = info.split('@');
						var Allcnt = infoArr[0];
						var Succnt = infoArr[1];
						var failcnt = Allcnt - Succnt;
						var ErrInfo = infoArr[2];
						$UI.msg('success', '��:' + Allcnt + '��¼,�ɹ�:' + Succnt + '��');
						if (failcnt > 0) {
							$UI.msg('error', 'ʧ��:' + failcnt + '��;' + ErrInfo);
						}
					}
				});
			}
		}, '-', {
			text: '��ӡ',
			iconCls: 'icon-print',
			handler: function() {
				var Row = PayMainGrid.getSelected();
				if (isEmpty(Row)) {
					$UI.msg('alert', '��ѡ�񸶿!');
					return;
				}
				PrintPay(Row.RowId);
			}
		}
	];

	PayMainCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: 'Vendor',
			field: 'Vendor',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '�����',
			field: 'PayNo',
			width: 200
		}, {
			title: '��Ӧ��',
			field: 'VendorDesc',
			width: 200
		}, {
			title: '�Ƶ���',
			field: 'UserName',
			width: 80
		}, {
			title: '�Ƶ�����',
			field: 'Date',
			width: 100
		}, {
			title: '�Ƶ�ʱ��',
			field: 'Time',
			width: 80
		}, {
			title: '������',
			field: 'PayAmt',
			width: 100,
			align: 'right'
		}, {
			title: '�ɹ�ȷ��',
			field: 'PurConfirm',
			width: 80
		}, {
			title: '�ɹ�ȷ����',
			field: 'PurConfirmUser',
			width: 100
		}, {
			title: '�ɹ�ȷ������',
			field: 'PurConfirmDate',
			saveCol: true,
			width: 100
		}, {
			title: '���ȷ��',
			field: 'AccConfirm',
			width: 80
		}, {
			title: '���ȷ����',
			field: 'AccConfirmUser',
			width: 100
		}, {
			title: '���ȷ������',
			field: 'AccConfirmDate',
			saveCol: true,
			width: 100
		}, {
			title: '����ȷ��',
			field: 'FinConfirm',
			width: 80
		}, {
			title: '����ȷ����',
			field: 'FinConfirmUser',
			width: 100
		}, {
			title: '����ȷ������',
			field: 'FinConfirmDate',
			saveCol: true,
			width: 100
		}, {
			title: '֧����ʽ',
			field: 'PayModeId',
			width: 80,
			hidden: true
		}, {
			title: '֧����ʽ',
			field: 'PayMode',
			width: 80
		}, {
			title: '֧������',
			field: 'CheckNo',
			width: 100
		}, {
			title: '֧�����',
			field: 'CheckAmt',
			width: 100,
			align: 'right'
		}
	]];

	PayMainGrid = $UI.datagrid('#PayMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCPay',
			QueryName: 'DHCPay',
			query2JsonStrict: 1
		},
		toolbar: ToolBar,
		columns: PayMainCm,
		showBar: true,
		singleSelect: false,
		onSelect: function(index, row) {
			PayDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCPayItm',
				QueryName: 'DHCPayItm',
				query2JsonStrict: 1,
				Pay: row.RowId,
				rows: 99999
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				PayMainGrid.selectRow(0);
			}
		}
	});

	PayDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '����˻�Id',
			field: 'Pointer',
			width: 50,
			hidden: true
		}, {
			title: 'Inci',
			field: 'Inci',
			width: 50,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'Code',
			width: 150
		}, {
			title: '��������',
			field: 'Description',
			width: 200
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '����',
			field: 'BatNo',
			width: 100
		}, {
			title: '��Ч��',
			field: 'ExpDate',
			width: 100
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 80
		}, {
			title: '����',
			field: 'Qty',
			width: 80,
			align: 'right'
		}, {
			title: '������',
			field: 'PayAmt',
			width: 80,
			align: 'right'
		}, {
			title: '����',
			field: 'Rp',
			width: 80,
			align: 'right'
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '�ۼ�',
			field: 'Sp',
			width: 80,
			align: 'right'
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '��������',
			field: 'Manf',
			width: 200
		}, {
			title: '��Ʊ��',
			field: 'InvNo',
			width: 80
		}, {
			title: '��Ʊ����',
			field: 'InvDate',
			width: 100
		}, {
			title: '��Ʊ���',
			field: 'InvAmt',
			width: 80,
			align: 'right'
		}, {
			title: '�����־',
			field: 'OverFlag',
			width: 80
		}, {
			title: 'ҵ�񵥺�',
			field: 'GRNo',
			width: 200
		}, {
			title: '����',
			field: 'TransType',
			width: 80,
			formatter: function(value, row, index) {
				if (value == 'G') {
					return '���';
				} else {
					return '�˻�';
				}
			}
		}
	]];

	PayDetailGrid = $UI.datagrid('#PayDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecPaymentApproval',
			QueryName: 'QueryDetail',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		columns: PayDetailCm,
		showBar: true
	});

	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			$UI.clear(PayDetailGrid);
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('#MainConditions');
		
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (isEmpty(ParamsObj.IngrLoc)) {
			$UI.msg('alert', '�����Ҳ���Ϊ��!');
			return;
		}
		if (isEmpty(StartDate)) {
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return;
		}
		if (compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���С�ڿ�ʼ����!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		PayMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCPay',
			QueryName: 'DHCPay',
			query2JsonStrict: 1,
			LocId: ParamsObj.IngrLoc,
			Params: Params
		});
	}

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clearBlock('#MainConditions');
			$UI.clear(PayMainGrid);
			$UI.clear(PayDetailGrid);
			SetDefaValues();
		}
	});

	SetDefaValues();
	Query();
};
$(init);
function Select() {
	$UI.clear(PayMainGrid);
	$UI.clear(PayDetailGrid);
	PayMainGrid.commonReload();
}