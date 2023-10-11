var FindWin = function(Fn) {
	$HUI.dialog('#FindWin', { width: gWinWidth, height: gWinHeight }).open();
	var LocParams = JSON.stringify(addSessionParams({
		Type: 'Login'
	}));
	var LocBox = $HUI.combobox('#FLocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description',
		onChange: function(e) {
			INDispLoc(e);
		}
	});
	// רҵ��
	function INDispLoc(LocId) {
		var UserGrpParams = JSON.stringify(addSessionParams({
			User: gUserId,
			SubLoc: LocId,
			ReqFlag: ''
		}));
		var UserGrpBox = $HUI.combobox('#FUserGrp', {
			url: $URL + '?ClassName=web.DHCSTMHUI.DHCSubLocUserGroup&QueryName=GetUserGrp&ResultSetType=array&Params=' + UserGrpParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	}
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
	var MainGrid = $UI.datagrid('#FMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispReq',
			QueryName: 'DHCINDispReq',
			query2JsonStrict: 1
		},
		columns: MainCm,
		onSelect: function(index, row) {
			$UI.clear(DetailGrid);
			DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINDispReqItm',
				QueryName: 'DHCINDispReqItm',
				query2JsonStrict: 1,
				Parref: row.RowId
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				MainGrid.selectRow(0);
			}
		},
		onDblClickRow: function(index, row) {
			Fn(row['RowId']);
			$HUI.dialog('#FindWin').close();
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
			title: '��ע',
			field: 'Remark',
			width: 100
		}
	]];
	var DetailGrid = $UI.datagrid('#FDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispReqItm',
			QueryName: 'DHCINDispReqItm',
			query2JsonStrict: 1
		},
		columns: DetailCm
	});

	$UI.linkbutton('#FQueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('#FConditions');
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(ParamsObj.LocId)) {
			$UI.msg('alert', '��ѡ�����!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(MainGrid);
		$UI.clear(DetailGrid);
		MainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINDispReq',
			QueryName: 'DHCINDispReq',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#FClearBT', {
		onClick: function() {
			Clear();
		}
	});
	$UI.linkbutton('#FSelectBT', {
		onClick: function() {
			var Row = MainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ���ص����쵥!');
				return;
			}
			Fn(Row.RowId);
			$HUI.dialog('#FindWin').close();
		}
	});

	function Clear() {
		$UI.clearBlock('#FConditions');
		$UI.clear(MainGrid);
		$UI.clear(DetailGrid);
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			LocId: gLocId,
			NotDisp: 0
		};
		$UI.fillBlock('#FConditions', DefaultData);
	}

	Clear();
	Query();
};