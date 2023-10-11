var SelInitWin = function(Fn, DispLoc, ReqLoc, HvFlag) {
	$HUI.dialog('#SelInitWin', { width: gWinWidth, height: gWinHeight }).open();
	$HUI.radio("[name='DispMode']", {
		onChecked: function(e, value) {
			var DispMode = $("input[name='DispMode']:checked").val();
			if (DispMode == '0') {
				$('#InitUserList').combobox({
					disabled: true
				});
				$('#InitGrpList').combobox({
					disabled: false
				});
			} else {
				$('#InitUserList').combobox({
					disabled: false
				});
				$('#InitGrpList').combobox({
					disabled: true
				});
			}
		}
	});
	var LocParams = JSON.stringify(addSessionParams({
		Type: 'LeadLoc',
		LocId: DispLoc
	}));
	var LocBox = $HUI.combobox('#FrLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	// רҵ��
	var GrpListParams = JSON.stringify(addSessionParams({
		User: gUserId,
		SubLoc: ReqLoc,
		ReqFlag: ''
	}));
	var GrpListBox = $HUI.combobox('#InitGrpList', {
		url: $URL + '?ClassName=web.DHCSTMHUI.DHCSubLocUserGroup&QueryName=GetLocGrp&ResultSetType=array&Params=' + GrpListParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	// ������Ա
	var UserListBox = $HUI.combobox('#InitUserList', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=array&Params='
			+ JSON.stringify({
				LocDr: ReqLoc
			}),
		valueField: 'RowId',
		textField: 'Description'
	});
	var MainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '����',
			field: 'InitNo',
			align: 'left',
			editor: 'text',
			width: 150,
			sortable: true
		}, {
			title: '��������',
			field: 'FrLocDesc',
			width: 150,
			sortable: true
		}, {
			title: '�Ƶ�ʱ��',
			field: 'InitDateTime',
			width: 150
		}, {
			title: '����״̬',
			field: 'StatusCode',
			width: 70
		}, {
			title: '�Ƶ���',
			field: 'UserName',
			width: 80
		}, {
			title: '���۽��',
			field: 'RpAmt',
			align: 'right',
			width: 100
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			align: 'right',
			width: 100
		}, {
			title: '������',
			field: 'MarginAmt',
			align: 'right',
			width: 100
		}, {
			title: '��ע',
			field: 'Remark',
			width: 150
		}
	]];
	var MainGrid = $UI.datagrid('#InitMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'DHCINIsTrfM',
			query2JsonStrict: 1
		},
		columns: MainCm,
		onSelect: function(index, row) {
			var Init = row['RowId'];
			var ParamsObj = {
				Init: Init,
				InitType: 'T'
			};
			$UI.clear(DetailGrid);
			DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
				QueryName: 'DHCINIsTrfD',
				query2JsonStrict: 1,
				Params: JSON.stringify(ParamsObj)
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
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '��������Id',
			field: 'Inclb',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 120
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 180
		}, {
			title: '���',
			field: 'Spec',
			width: 80
		}, {
			title: '����~Ч��',
			field: 'BatExp',
			width: 200
		}, {
			title: '��������',
			field: 'ManfDesc',
			width: 160
		}, {
			title: '���ο��',
			field: 'InclbQty',
			align: 'right',
			width: 80
		}, {
			title: 'ת������',
			field: 'Qty',
			align: 'right',
			width: 80
		}, {
			title: '��������',
			field: 'DispQty',
			width: 80,
			saveCol: true,
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					tipPosition: 'bottom',
					required: true,
					precision: GetFmtNum('FmtQTY')
				}
			},
			align: 'right'
		}, {
			title: '��λId',
			field: 'UomId',
			saveCol: true,
			hidden: true,
			width: 50
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 50
		}, {
			title: '����',
			field: 'Rp',
			align: 'right',
			width: 80
		}, {
			title: '�ۼ�',
			field: 'Sp',
			align: 'right',
			width: 80
		}, {
			title: '���۽��',
			field: 'RpAmt',
			align: 'right',
			width: 80
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			align: 'right',
			width: 80
		}, {
			title: '��������',
			field: 'InclbAvaQty',
			align: 'right',
			width: 100
		}
	]];
	var DetailGrid = $UI.datagrid('#InitDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfD',
			query2JsonStrict: 1
		},
		columns: DetailCm,
		singleSelect: false,
		onClickRow: function(index, row) {
			DetailGrid.commonClickRow(index, row);
		}
	});

	$UI.linkbutton('#InitQueryBT', {
		onClick: function() {
			InitQuery();
		}
	});
	function InitQuery() {
		var ParamsObj = $UI.loopBlock('#InitConditions');
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return;
		}
		ParamsObj.Status = '31';
		ParamsObj.ToLoc = DispLoc;
		ParamsObj.HVFlag = HvFlag;
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(MainGrid);
		$UI.clear(DetailGrid);
		MainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'DHCINIsTrfM',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#InitClearBT', {
		onClick: function() {
			Clear();
		}
	});

	$UI.linkbutton('#InitSelectBT', {
		onClick: function() {
			SaveDispByInit();
		}
	});
	function SaveDispByInit() {
		if (!DetailGrid.endEditing()) {
			return;
		}
		var SelectedRow = MainGrid.getSelected();
		if (isEmpty(SelectedRow)) {
			$UI.msg('alert', '��ѡ��ת�Ƶ�!');
			return;
		}
		var Rows = DetailGrid.getSelections();
		if (Rows.length <= 0) {
			$UI.msg('alert', '��ѡ��ת�Ƶ���ϸ!');
			return;
		}
		for (var i = 0; i < Rows.length; i++) {
			if (isEmpty(Rows[i].DispQty) || Rows[i].DispQty == 0) {
				var InciDesc = Rows[i].InciDesc;
				$UI.msg('alert', '������' + InciDesc + '�ķ�������!');
				return;
			}
		}
		var ParamsObj = $UI.loopBlock('#InitConditions');
		var DispMode = $("input[name='DispMode']:checked").val();
		if ((DispMode == '1') && (isEmpty(ParamsObj['UserList']))) {
			$UI.msg('alert', '��ѡ�񷢷���Ա!');
			return;
		}
		if ((DispMode == '0') && (isEmpty(ParamsObj['GrpList']))) {
			$UI.msg('alert', '��ѡ�񷢷�רҵ��!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		var Main = JSON.stringify(SelectedRow);
		var Detail = JSON.stringify(DetailGrid.getSelectedData());
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINDisp',
			MethodName: 'SaveDispByInit',
			Main: Main,
			Detail: Detail,
			Params: Params,
			DispLoc: DispLoc,
			ReqLoc: ReqLoc
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				Fn(jsonData.rowid);
				$HUI.dialog('#SelInitWin').close();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	function Clear() {
		$UI.clearBlock('#InitConditions');
		$UI.clear(MainGrid);
		$UI.clear(DetailGrid);
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate()
		};
		$UI.fillBlock('#InitConditions', DefaultData);
	}

	Clear();
	InitQuery();
};