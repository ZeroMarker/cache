var FindWin = function(IngrLoc, Fn) {
	$HUI.dialog('#FindWin', { width: gWinWidth, height: gWinHeight }).open();

	var FVendorParams = JSON.stringify(addSessionParams({ APCType: 'M', LocId: IngrLoc }));
	var FVendorBox = $HUI.combobox('#FVendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FVendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	$UI.linkbutton('#FQueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('#FindConditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
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
		$UI.clear(PayMainGrid);
		$UI.clear(PayDetailGrid);
		PayMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCPay',
			QueryName: 'DHCPay',
			query2JsonStrict: 1,
			LocId: IngrLoc,
			Params: Params
		});
	}
	$UI.linkbutton('#FSelectBT', {
		onClick: function() {
			var Row = PayMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ���صĸ��!');
				return;
			}
			Fn(Row.RowId);
			$HUI.dialog('#FindWin').close();
		}
	});
	$UI.linkbutton('#FClearBT', {
		onClick: function() {
			Clear();
		}
	});

	var PayMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '�����',
			field: 'PayNo',
			width: 150
		}, {
			title: '�ɹ�����',
			field: 'LocDesc',
			width: 150
		}, {
			title: '��Ӧ��',
			field: 'VendorDesc',
			width: 100
		}, {
			title: '�Ƶ���',
			field: 'UserName',
			width: 70
		}, {
			title: '����',
			field: 'Date',
			width: 90,
			align: 'right'
		}, {
			title: 'ʱ��',
			field: 'Time',
			width: 80,
			align: 'right'
		}, {
			title: '������',
			field: 'PayAmt',
			width: 100,
			align: 'right'
		}, {
			title: '�ɹ�ȷ��',
			field: 'PurConfirm',
			width: 60
		}, {
			title: '���ȷ��',
			field: 'AccConfirm',
			width: 60
		}, {
			title: '���״̬',
			field: 'Complete',
			width: 60
		}, {
			title: '֧����ʽ',
			field: 'PayMode',
			width: 80
		}, {
			title: '֧��Ʊ�ݺ�',
			field: 'CheckNo',
			width: 80
		}, {
			title: 'Ʊ������',
			field: 'CheckDate',
			width: 90,
			align: 'right'
		}, {
			title: 'Ʊ�ݽ��',
			field: 'CheckAmt',
			width: 100,
			align: 'right'
		}
	]];

	var PayMainGrid = $UI.datagrid('#PayMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCPay',
			QueryName: 'DHCPay',
			query2JsonStrict: 1
		},
		columns: PayMainCm,
		showBar: true,
		onSelect: function(index, row) {
			PayDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCPayItm',
				QueryName: 'DHCPayItm',
				query2JsonStrict: 1,
				Pay: row.RowId
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				PayMainGrid.selectRow(0);
			}
		},
		onDblClickRow: function(index, row) {
			Fn(row.RowId);
			$HUI.dialog('#FindWin').close();
		}
	});

	var PayDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: 'Pointer',
			field: 'Pointer',
			width: 50,
			hidden: true
		}, {
			title: 'Inclb',
			field: 'Inclb',
			width: 50,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'Code',
			width: 120
		}, {
			title: '��������',
			field: 'Description',
			width: 150
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '����',
			field: 'Qty',
			width: 100,
			align: 'right'
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 80
		}, {
			title: '����',
			field: 'Rp',
			width: 100,
			align: 'right'
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '�ۼ�',
			field: 'Sp',
			width: 100,
			align: 'right'
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '��������',
			field: 'Manf',
			width: 100
		}, {
			title: '�����־',
			field: 'OverFlag',
			width: 60
		}, {
			title: '��Ʊ��',
			field: 'InvNo',
			width: 100
		}, {
			title: '��Ʊ����',
			field: 'InvDate',
			width: 100
		}, {
			title: '��Ʊ���',
			field: 'InvAmt',
			width: 100,
			align: 'right'
		}, {
			title: '����',
			field: 'BatNo',
			width: 100
		}, {
			title: 'Ч��',
			field: 'ExpDate',
			width: 100
		}, {
			header: '����',
			field: 'TransType',
			align: 'center',
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

	var PayDetailGrid = $UI.datagrid('#PayDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCPayItm',
			QueryName: 'DHCPayItm',
			query2JsonStrict: 1
		},
		columns: PayDetailCm,
		showBar: true
	});

	function Clear() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(PayMainGrid);
		$UI.clear(PayDetailGrid);
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate()
		};
		$UI.fillBlock('#FindConditions', DefaultData);
	}
	Clear();
	Query();
};