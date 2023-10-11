var FindWin = function(Fn, HVFlag) {
	if (HVFlag == undefined) {
		HVFlag = '';
	}
	$HUI.dialog('#FindWin', { width: gWinWidth, height: gWinHeight }).open();
	var LocParams = JSON.stringify(addSessionParams({
		Type: 'Login',
		Element: 'LocId',
		LoginLocType: 2
	}));
	var LocBox = $HUI.combobox('#FLocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
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
			field: 'IndsNo',
			width: 150
		}, {
			title: '���տ���',
			field: 'ReqLoc',
			width: 150
		}, {
			title: '������',
			field: 'RecUser',
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
			title: '��������',
			field: 'DispMode',
			width: 100,
			formatter: function(value, row, index) {
				if (value == 1) {
					return '����';
				} else {
					return 'רҵ��';
				}
			}
		}, {
			title: '���ݱ�ע',
			field: 'Remark',
			width: 100
		}
	]];
	var MainGrid = $UI.datagrid('#FMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDisp',
			QueryName: 'DHCINDisp',
			query2JsonStrict: 1
		},
		columns: MainCm,
		fitColumns: true,
		onSelect: function(index, row) {
			$UI.clear(DetailGrid);
			DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINDispItm',
				QueryName: 'DHCINDispItm',
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
			title: 'Inclb',
			field: 'Inclb',
			width: 50,
			hidden: true
		}, {
			title: 'InciId',
			field: 'InciId',
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
			title: '��ֵ����',
			field: 'HVBarCode',
			width: 200
		}, {
			title: '���',
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
			title: '��������',
			field: 'Qty',
			width: 80,
			align: 'right'
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 80
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
			title: '��������',
			field: 'Manf',
			width: 200
		}, {
			title: '��Ʒ��ע',
			field: 'Remark',
			width: 100
		}
	]];
	var DetailGrid = $UI.datagrid('#FDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispItm',
			QueryName: 'DHCINDispItm',
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
			$UI.msg('alert', '��ѡ�񷢷ſ���!');
			return;
		}
		var ParamsObject = $.extend(ParamsObj, { HVFlag: HVFlag });
		var Params = JSON.stringify(ParamsObject);
		$UI.clear(MainGrid);
		$UI.clear(DetailGrid);
		MainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINDisp',
			QueryName: 'DHCINDisp',
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
				$UI.msg('alert', '��ѡ��Ҫ���صķ��ŵ�!');
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
			LocId: gLocId
		};
		$UI.fillBlock('#FConditions', DefaultData);
	}

	Clear();
	Query();
};