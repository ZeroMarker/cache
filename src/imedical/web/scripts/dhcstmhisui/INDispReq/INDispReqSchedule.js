var init = function() {
	var LocParams = JSON.stringify(addSessionParams({
		Type: 'Login'
	}));
	var LocBox = $HUI.combobox('#LocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	// רҵ��
	var UserGrpParams = JSON.stringify(addSessionParams({
		User: gUserId,
		SubLoc: gLocId,
		ReqFlag: ''
	}));
	var UserGrpBox = $HUI.combobox('#UserGrp', {
		url: $URL + '?ClassName=web.DHCSTMHUI.DHCSubLocUserGroup&QueryName=GetUserGrp&ResultSetType=array&Params=' + UserGrpParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	var MainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '����',
			field: 'DsrqNo',
			width: 150
		}, {
			title: '����',
			field: 'DispSchedule',
			width: 100,
			formatter: function(value, row, index) {
				if (value == 0) {
					return 'δ����';
				} else if (value == 1) {
					return '���ַ���';
				} else if (value == 2) {
					return 'ȫ������';
				}
			}
		}, {
			title: '������',
			field: 'ReqUser',
			width: 100
		}, {
			title: 'רҵ��',
			field: 'GrpDesc',
			width: 100
		}, {
			title: '�Ƶ�����',
			field: 'CreateDate',
			width: 100
		}, {
			title: '�Ƶ�ʱ��',
			field: 'CreateTime',
			width: 100
		}, {
			title: '���',
			field: 'Comp',
			width: 100,
			formatter: function(value, row, index) {
				if (value == 'Y') {
					return '��';
				} else {
					return '��';
				}
			}
		}, {
			title: '״̬',
			field: 'Status',
			width: 100,
			formatter: function(value, row, index) {
				if (value == 'O') {
					return '������';
				} else if (value == 'C') {
					return '�Ѵ���';
				} else if (value == 'X') {
					return '������';
				} else if (value == 'R') {
					return '�Ѿܾ�';
				}
			}
		}, {
			title: '��ע',
			field: 'Remark',
			width: 100
		}
	]];

	var MainGrid = $UI.datagrid('#MainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispReq',
			QueryName: 'DHCINDispReq',
			query2JsonStrict: 1
		},
		columns: MainCm,
		fitColumns: true,
		showBar: true,
		onSelect: function(index, row) {
			$UI.clear(DetailGrid);
			DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINDispReqItm',
				QueryName: 'DHCINDispReqItm',
				query2JsonStrict: 1,
				Parref: row.RowId,
				rows: 99999
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				MainGrid.selectRow(0);
			}
		}
	});

	var DetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: 'IncId',
			field: 'IncId',
			width: 50,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 150
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 200
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '����',
			field: 'Qty',
			width: 80,
			align: 'right'
		}, {
			title: '�ѷ�����',
			field: 'DispedQty',
			width: 80,
			align: 'right'
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 80
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
			title: '״̬',
			field: 'Status',
			width: 100,
			formatter: function(value, row, index) {
				if (value == 'G') {
					return '������';
				} else if (value == 'D') {
					return '�Ѵ���';
				} else if (value == 'X') {
					return '������';
				} else if (value == 'R') {
					return '�Ѿܾ�';
				}
			}
		}, {
			title: '��ע',
			field: 'Remark',
			width: 100
		}
	]];

	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispReqItm',
			QueryName: 'DHCINDispReqItm',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		columns: DetailCm,
		showBar: true
	});

	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (isEmpty(ParamsObj.LocId)) {
			$UI.msg('alert', '���Ҳ���Ϊ��!');
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
		MainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINDispReq',
			QueryName: 'DHCINDispReq',
			query2JsonStrict: 1,
			Params: Params
		});
	}

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clearBlock('#Conditions');
			$UI.clear(MainGrid);
			$UI.clear(DetailGrid);
			SetDefaValues();
		}
	});

	SetDefaValues();
	Query();
};
$(init);