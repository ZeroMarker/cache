var findDispTemplateWin = function(Fn, HVFlag, FnCre) {
	if (HVFlag == undefined) {
		HVFlag = '';
	}
	$HUI.dialog('#TempWin', { width: gWinWidth, height: gWinHeight }).open();
	var LocParams = JSON.stringify(addSessionParams({
		Type: 'Login',
		Element: 'LocId',
		LoginLocType: 2
	}));
	var LocBox = $HUI.combobox('#TLocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	var TempMainCm = [[
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
	var TempMainGrid = $UI.datagrid('#TempMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDisp',
			QueryName: 'DHCINDisp',
			query2JsonStrict: 1
		},
		columns: TempMainCm,
		onSelect: function(index, row) {
			$UI.clear(TempDetailGrid);
			TempDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINDispItm',
				QueryName: 'DHCINDispItm',
				query2JsonStrict: 1,
				Parref: row.RowId
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				TempMainGrid.selectRow(0);
			}
		}
	});

	var TempDetailCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
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
	var TempDetailGrid = $UI.datagrid('#TempDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispItm',
			QueryName: 'DHCINDispItm',
			query2JsonStrict: 1
		},
		columns: TempDetailCm,
		singleSelect: false
	});

	$UI.linkbutton('#TQueryBT', {
		onClick: function() {
			TQuery();
		}
	});
	function TQuery() {
		var ParamsObj = $UI.loopBlock('#TempConditions');
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
		var ParamsObject = $.extend(ParamsObj, { HVFlag: HVFlag }, { TempFlag: 'Y' });
		var Params = JSON.stringify(ParamsObject);
		$UI.clear(TempMainGrid);
		$UI.clear(TempDetailGrid);
		TempMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINDisp',
			QueryName: 'DHCINDisp',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#TClearBT', {
		onClick: function() {
			TClear();
		}
	});
	$UI.linkbutton('#TSelectBT', {
		onClick: function() {
			var Row = TempMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ���صķ��ŵ�!');
				return;
			}
			var DetailRows = TempDetailGrid.getSelections();
			if (isEmpty(DetailRows)) {
				$UI.msg('alert', '��ѡ����Ҫ�Ƶ���ģ����ϸ����!');
				return;
			}
			var DispArr = [];
			$.each(DetailRows, function(index, row) {
				var DetailId = row['RowId'];
				DispArr.push(DetailId);
			});
			var DispDetailIdStr = DispArr.join('^');
			if (isEmpty(DispDetailIdStr)) {
				return false;
			}
			FnCre(Row.RowId, DispDetailIdStr);
			$HUI.dialog('#TempWin').close();
		}
	});

	function TClear() {
		$UI.clearBlock('#TempConditions');
		$UI.clear(TempMainGrid);
		$UI.clear(TempDetailGrid);
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			LocId: gLocId
		};
		$UI.fillBlock('TempConditions', DefaultData);
	}

	TClear();
	TQuery();
};