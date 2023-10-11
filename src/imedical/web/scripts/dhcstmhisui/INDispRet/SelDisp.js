var FrLocId = '';
var SelDisp = function(Fn, HVFlag) {
	if (HVFlag == undefined) {
		HVFlag = '';
	}
	$HUI.dialog('#DispWin', { width: gWinWidth, height: gWinHeight }).open();
	var LocParams = JSON.stringify(addSessionParams({
		Type: 'Login',
		Element: 'LocId',
		LoginLocType: 2
	}));
	var LocBox = $HUI.combobox('#FrLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			FrLocId = record['RowId'];
			$('#ToLoc').combobox('clear');
			$('#ToLoc').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
				+ JSON.stringify(addSessionParams({
					Type: 'LeadLoc',
					LocId: FrLocId,
					Element: 'ToLoc'
				})));
		}
	});
	FrLocId = $('#FrLoc').combobox('getValue');
	// ���տ���
	var ToLocParams = JSON.stringify(addSessionParams({
		Type: 'LeadLoc',
		LocId: FrLocId,
		Element: 'ReqLoc'
	}));
	var ToLocBox = $HUI.combobox('#ToLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ToLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var DispMainCm = [[
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
	var DispMasterGrid = $UI.datagrid('#DispMasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDisp',
			QueryName: 'DHCINDisp',
			query2JsonStrict: 1
		},
		columns: DispMainCm,
		onSelect: function(index, row) {
			$UI.clear(DispDetailGrid);
			DispDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINDispItm',
				QueryName: 'DHCINDispItm',
				query2JsonStrict: 1,
				Parref: row.RowId
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				DispMasterGrid.selectRow(0);
			}
		}
	});

	var DispDetailCm = [[
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
		}, {
			title: '��������',
			field: 'AvaRetQty',
			width: 80,
			align: 'right'
		}, {
			title: '����ռ��',
			field: 'DisRetQty',
			width: 80,
			align: 'right',
			hidden: true
		}
	]];
	var DispDetailGrid = $UI.datagrid('#DispDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispItm',
			QueryName: 'DHCINDispItm',
			query2JsonStrict: 1
		},
		columns: DispDetailCm
	});

	$UI.linkbutton('#FDispQueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('#FDispConditions');
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
		var AuditFlag = 'Y';
		var ParamsObject = $.extend(ParamsObj, { HVFlag: HVFlag, AuditFlag: AuditFlag });
		var Params = JSON.stringify(ParamsObject);
		$UI.clear(DispMasterGrid);
		$UI.clear(DispDetailGrid);
		DispMasterGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINDisp',
			QueryName: 'DHCINDisp',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#FDispClearBT', {
		onClick: function() {
			FDispClear();
		}
	});
	// ѡȡ
	$UI.linkbutton('#FDispSelBT', {
		onClick: function() {
			var Row = DispMasterGrid.getSelected();
			var DetailObj = DispDetailGrid.getSelections();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ�˻صķ��ŵ�!');
				return;
			}
			var DetailNewObj = [];
			var DspiStr = '';
			for (var i = 0; i < DetailObj.length; i++) {
				var InciCode = DetailObj[i].InciCode;
				var AvaRetQty = DetailObj[i].AvaRetQty;
				if (AvaRetQty <= 0) {
					$UI.msg('alert', InciCode + '��������С�ڻ����0!');
					return;
				}
				if (DspiStr = '') {
					DspiStr = DetailObj[i].RowId;
				} else {
					DspiStr = DspiStr + '^' + DetailObj[i].RowId;
				}
			}
			var Params = JSON.stringify(addSessionParams({ Dsp: Row.RowId, DspiStr: DspiStr }));
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINDispRet',
				MethodName: 'jsSaveByDisp',
				Params: Params
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					Fn(jsonData.rowid);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
			$HUI.dialog('#DispWin').close();
		}
	});

	function FDispClear() {
		$UI.clearBlock('#FDispConditions');
		$UI.clear(DispMasterGrid);
		$UI.clear(DispDetailGrid);
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			LocId: gLocId
		};
		$UI.fillBlock('#FDispConditions', DefaultData);
	}

	FDispClear();
	Query();
};