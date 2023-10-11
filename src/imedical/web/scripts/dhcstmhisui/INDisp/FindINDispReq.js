var SelReqWin = function(Fn, DispLoc) {
	$HUI.dialog('#SelReqWin', {
		height: gWinHeight,
		width: gWinWidth
	}).open();
	var LocParams = JSON.stringify(addSessionParams({
		Type: 'LeadLoc',
		LocId: DispLoc
	}));
	var LocBox = $HUI.combobox('#ToLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$('#ReqGrpList').combobox('clear');
			$('#ReqGrpList').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.DHCSubLocUserGroup&QueryName=GetLocGrp&ResultSetType=Array&Params='
				+ JSON.stringify({
					SubLoc: LocId
				})
			);
		}
	});
	// רҵ��
	var GrpListBox = $HUI.combobox('#ReqGrpList', {
		url: '',
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
			title: '���տ���',
			field: 'LocDesc',
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
			title: '��������',
			field: 'ReqMode',
			width: 100,
			formatter: function(value, row, index) {
				if (value == 1) {
					return '����';
				} else {
					return 'רҵ��';
				}
			}
		}, {
			title: '��ע',
			field: 'Remark',
			width: 100
		}, {
			title: '״̬',
			field: 'Status',
			width: 100,
			formatter: MainStatusFormatter
		}
	]];
	function MainStatusFormatter(value) {
		var status = value;
		if (value == 'C') {
			status = '�Ѵ���';
		} else if (value == 'O') {
			status = '������';
		} else if (value == 'X') {
			status = '��ȡ��';
		} else if (value == 'R') {
			status = '�Ѿܾ�';
		}
		return status;
	}
	var MainGrid = $UI.datagrid('#ReqMainGrid', {
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
				Parref: row.RowId,
				rows: 9999
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				MainGrid.selectRow(0);
			}
		}
	});

	var ToolBar = [{
		text: '�ܾ�',
		iconCls: 'icon-audit-x',
		handler: function() {
			var Rows = DetailGrid.getChecked();
			if (Rows.length <= 0) {
				$UI.msg('alert', '��ѡ��Ҫ�ܾ�����ϸ!');
				return;
			}
			$UI.confirm('����Ҫ�ܾ�����,�Ƿ����?', '', '', DenyReqItm);
		}
	}];
	var DetailCm = [[
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
			title: '��������',
			field: 'Qty',
			width: 80,
			align: 'right'
		}, {
			title: '���ſ��ҿ��',
			field: 'StkQty',
			width: 100,
			align: 'right'
		}, {
			title: '���Ƶ�����',
			field: 'DispMadeQty',
			width: 100,
			align: 'right'
		}, {
			title: '�ѷ�������',
			field: 'DispedQty',
			width: 100,
			align: 'right'
		}, {
			title: '��������',
			field: 'DispQty',
			width: 100,
			align: 'right',
			saveCol: true,
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					tipPosition: 'bottom',
					required: true,
					precision: GetFmtNum('FmtQTY')
				}
			}
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 80
		}, {
			title: '����',
			field: 'Sp',
			width: 80,
			align: 'right'
		}, {
			title: '���۽��',
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
		}, {
			title: '״̬',
			field: 'Status',
			width: 100,
			formatter: DetailStatusFormatter
		}
	]];
	function DetailStatusFormatter(value) {
		var status = value;
		if (value == 'G') {
			status = 'δ����';
		} else if (value == 'D') {
			status = '�ѷ���';
		} else if (value == 'X') {
			status = '��ȡ��';
		} else if (value == 'R') {
			status = '�Ѿܾ�';
		}
		return status;
	}
	var DetailGrid = $UI.datagrid('#ReqDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispReqItm',
			QueryName: 'DHCINDispReqItm',
			query2JsonStrict: 1
		},
		columns: DetailCm,
		pagination: false,
		toolbar: ToolBar,
		singleSelect: false,
		checkOnSelect: false,
		onClickRow: function(index, row) {
			DetailGrid.commonClickRow(index, row);
		}
	});

	$UI.linkbutton('#ReqQueryBT', {
		onClick: function() {
			ReqQuery();
		}
	});
	function ReqQuery() {
		var ParamsObj = $UI.loopBlock('#ReqConditions');
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(ParamsObj.LocId)) {
			$UI.msg('alert', '��ѡ����տ���!');
			return;
		}
		//	ParamsObj.Status = "O";
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
	$UI.linkbutton('#ReqClearBT', {
		onClick: function() {
			Clear();
		}
	});
	$UI.linkbutton('#ReqSelectBT', {
		onClick: function() {
			SaveDispByReq();
		}
	});
	$UI.linkbutton('#ReqDenyBT', {
		onClick: function() {
			var Row = MainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ�����쵥!');
				return;
			}
			$UI.confirm('����Ҫ�ܾ�����,�Ƿ����?', '', '', DenyReq);
		}
	});
	function DenyReq() {
		var Row = MainGrid.getSelected();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINDispReq',
			MethodName: 'DenyReq',
			Dsrq: Row.RowId
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				Clear();
				MainGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	function DenyReqItm(Params) {
		var Row = MainGrid.getSelected();
		var Params = DetailGrid.getSelectedData();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINDispReqItm',
			MethodName: 'DenyReqItm',
			Dsrq: Row.RowId,
			Params: JSON.stringify(Params)
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				DetailGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	function SaveDispByReq() {
		if (!DetailGrid.endEditing()) {
			return;
		}
		var SelectedRow = MainGrid.getSelected();
		if (isEmpty(SelectedRow)) {
			$UI.msg('alert', '��ѡ�����쵥!');
			return;
		}
		var Main = JSON.stringify(SelectedRow);
		var Rows = DetailGrid.getChecked();
		if (Rows.length <= 0) {
			$UI.msg('alert', '��ѡ�����쵥��ϸ!');
			return;
		}
		for (var i = 0; i < Rows.length; i++) {
			var InciDesc = Rows[i].InciDesc;
			var StkQty = Rows[i].StkQty;	// ���
			if (isEmpty(Rows[i].DispQty) || Rows[i].DispQty <= 0) {
				$UI.msg('alert', '������' + InciDesc + '�ķ�������!');
				return;
			}
			if (Number(Rows[i].DispQty) > Number(StkQty)) {
				$UI.msg('alert', InciDesc + '�ķ����������ڿ��,���޸�!');
				return;
			}
		}
		var Detail = DetailGrid.getSelectedData();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINDisp',
			MethodName: 'SaveDispByReq',
			Main: Main,
			Detail: JSON.stringify(Detail),
			UserId: gUserId,
			DispLoc: DispLoc
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				Fn(jsonData.rowid);
				$HUI.dialog('#SelReqWin').close();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	function Clear() {
		$UI.clearBlock('#ReqConditions');
		$UI.clear(MainGrid);
		$UI.clear(DetailGrid);
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			LocId: $('#LocId').combo('getValue'),
			CompFlag: 'Y'
		};
		$UI.fillBlock('#ReqConditions', DefaultData);
	}

	Clear();
	ReqQuery();
};