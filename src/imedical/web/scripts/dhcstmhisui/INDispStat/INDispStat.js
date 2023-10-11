var init = function() {
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	// ���ſ���
	var DispLocParams = JSON.stringify(addSessionParams({ Type: 'All', Element: 'DispLoc' }));
	var DispLocBox = $HUI.combobox('#DispLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + DispLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	// ���տ���
	var ReqLocParams = JSON.stringify(addSessionParams({ Type: 'All', Element: 'ReqLoc' }));
	var ReqLocBox = $HUI.combobox('#ReqLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$('#UserList').combobox('clear');
			$('#GrpList').combobox('clear');
			$('#UserList').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=Array&Params='
				+ JSON.stringify({
					LocDr: LocId
				}));
			$('#GrpList').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.DHCSubLocUserGroup&QueryName=GetLocGrp&ResultSetType=Array&Params='
				+ JSON.stringify({
					SubLoc: LocId
				}));
		}
	});
	// ����
	$('#StkGrp').stkscgcombotree({
		onSelect: function(node) {
			$.cm({
				ClassName: 'web.DHCSTMHUI.Common.Dicts',
				QueryName: 'GetStkCat',
				ResultSetType: 'array',
				StkGrpId: node.id
			}, function(data) {
				StkCatBox.clear();
				StkCatBox.loadData(data);
			});
		}
	});
	// ������
	var StkCatBox = $HUI.combobox('#StkCat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	// ��������
	var HandlerParams = function() {
		var Scg = $('#StkGrp').combotree('getValue');
		var Loc = $('#DispLoc').combo('getValue');
		var Obj = { StkGrpRowId: Scg, StkGrpType: 'M', Locdr: Loc };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	// רҵ��
	var GrpListBox = $HUI.combobox('#GrpList', {
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			var ReqLocId = $('#ReqLoc').combo('getValue');
			if (ReqLocId == '') {
				$UI.msg('alert', '����ѡ����տ���');
				return;
			}
			GrpListBox.clear();
			var url = $URL + '?ClassName=web.DHCSTMHUI.DHCSubLocUserGroup&QueryName=GetLocGrp&ResultSetType=array&Params=' + JSON.stringify({ SubLoc: ReqLocId });
			GrpListBox.reload(url);
		}
	});
	// ������
	var UserListBox = $HUI.combobox('#UserList', {
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			var ReqLocId = $('#ReqLoc').combo('getValue');
			if (ReqLocId == '') {
				$UI.msg('alert', '����ѡ����տ���');
				return;
			}
			UserListBox.clear();
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=array&Params=' + JSON.stringify({ LocDr: ReqLocId });
			UserListBox.reload(url);
		}
	});

	// �����б�
	var MainCm = [[
		{
			title: 'Inci',
			field: 'Inci',
			width: 50,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 100
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 150
		}, {
			title: '���',
			field: 'Spec',
			width: 80
		}, {
			title: 'Ʒ��',
			field: 'Brand',
			width: 80
		}, {
			title: '�ͺ�',
			field: 'Model',
			width: 80
		}, {
			title: '��������',
			field: 'QtyUom',
			width: 100,
			align: 'right'
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '�շѱ�־',
			field: 'ChargeFlag',
			width: 80,
			formatter: function(value, row, index) {
				if (value == 'Y') {
					return '��';
				} else {
					return '��';
				}
			}
		}
	]];
	var MainGrid = $UI.datagrid('#MainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.SubLocMatStat',
			QueryName: 'INDispStat',
			query2JsonStrict: 1
		},
		columns: MainCm,
		showBar: true,
		fitColumns: true,
		onSelect: function(index, row) {
			$UI.clear(DetailGrid);
			var ParamsObj = $UI.loopBlock('#Conditions');
			ParamsObj.Inci = row.Inci;
			var Params = JSON.stringify(ParamsObj);
			DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.SubLocMatStat',
				QueryName: 'INDispDetailStat',
				query2JsonStrict: 1,
				Params: Params
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
			title: 'ҵ������',
			field: 'Type',
			width: 80,
			formatter: function(value, row, index) {
				if (value == 'C') {
					return '����';
				} else if (value == 'L') {
					return '�˻�';
				} else {
					return value;
				}
			}
		}, {
			title: '����',
			field: 'BatchNo',
			width: 100
		}, {
			title: 'Ч��',
			field: 'ExpDate',
			width: 100
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
			title: '���ŵ���',
			field: 'IndsNo',
			width: 200
		}, {
			title: '��������',
			field: 'DispDate',
			width: 100
		}, {
			title: '���쵥��',
			field: 'DsrqNo',
			width: 200
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.SubLocMatStat',
			QueryName: 'INDispDetailStat',
			query2JsonStrict: 1
		},
		columns: DetailCm,
		showBar: true
	});
	// �����б�
	var ReqMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: 'ҵ������',
			field: 'Type',
			width: 80,
			formatter: function(value, row, index) {
				if (value == 'C') {
					return '����';
				} else if (value == 'L') {
					return '�˻�';
				} else {
					return value;
				}
			}
		}, {
			title: '��������',
			field: 'DispDate',
			width: 100
		}, {
			title: '������',
			field: 'Receiver',
			width: 100
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 100
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 100
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
			title: '���ŵ���',
			field: 'IndsNo',
			width: 100
		}, {
			title: '��������',
			field: 'DispDate',
			width: 100
		}, {
			title: '���쵥��',
			field: 'DsrqNo',
			width: 100
		}
	]];
	var ReqMainGrid = $UI.datagrid('#ReqMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.SubLocMatStat',
			QueryName: 'INDispDetailStat',
			query2JsonStrict: 1
		},
		columns: ReqMainCm,
		showBar: true
	});
	// ���Ź�֧

	$HUI.tabs('#tabs', {
		onSelect: function(title) {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var Params = JSON.stringify(ParamsObj);
			if (title == '�����б�') {
				MainGrid.load({
					ClassName: 'web.DHCSTMHUI.SubLocMatStat',
					QueryName: 'INDispStat',
					query2JsonStrict: 1,
					Params: Params
				});
			} else if (title == '�����б�') {
				ReqMainGrid.load({
					ClassName: 'web.DHCSTMHUI.SubLocMatStat',
					QueryName: 'INDispDetailStat',
					query2JsonStrict: 1,
					Params: Params
				});
			} else if (title == '���Ź�֧') {
				Params = encodeUrlStr(Params);
				var url = PmRunQianUrl + '?reportName=DHCSTM_HUI_SubLocDispAllotStat.raq&Params=' + Params;
				var currTab = $('#tabs').tabs('getSelected');
				$('#tabs').tabs('update', {
					tab: currTab,
					options: {
						content: CreateFrame(url)
					}
				});
			} else if (title == '����������ϸ') {
				Params = encodeUrlStr(Params);
				var url = PmRunQianUrl + '?reportName=DHCSTM_HUI_SubLocDispAndOeori.raq&Params=' + Params;
				var currTab = $('#tabs').tabs('getSelected');
				$('#tabs').tabs('update', {
					tab: currTab,
					options: {
						content: CreateFrame(url)
					}
				});
			} else if (title == '������') {
				Params = encodeUrlStr(Params);
				var url = PmRunQianUrl + '?reportName=DHCSTM_HUI_LocDispStatAll_INCI_Common.raq&Params=' + Params;
				var currTab = $('#tabs').tabs('getSelected');
				$('#tabs').tabs('update', {
					tab: currTab,
					options: {
						content: CreateFrame(url)
					}
				});
			} else if (title == '��������') {
				Params = encodeUrlStr(Params);
				var url = PmRunQianUrl + '?reportName=DHCSTM_HUI_LocDispStatAll_STKCAT_Common.raq&Params=' + Params;
				var currTab = $('#tabs').tabs('getSelected');
				$('#tabs').tabs('update', {
					tab: currTab,
					options: {
						content: CreateFrame(url)
					}
				});
			} else if (title == '�����տ���') {
				Params = encodeUrlStr(Params);
				var url = PmRunQianUrl + '?reportName=DHCSTM_HUI_LocDispStatAll_RecLoc.raq&Params=' + Params;
				var currTab = $('#tabs').tabs('getSelected');
				$('#tabs').tabs('update', {
					tab: currTab,
					options: {
						content: CreateFrame(url)
					}
				});
			} else if (title == '��Ӧ�̻���') {
				Params = encodeUrlStr(Params);
				var url = PmRunQianUrl + '?reportName=DHCSTM_HUI_LocDispStatAll_VendorSum.raq&Params=' + Params;
				var currTab = $('#tabs').tabs('getSelected');
				$('#tabs').tabs('update', {
					tab: currTab,
					options: {
						content: CreateFrame(url)
					}
				});
			}
		}
	});

	function Query() {
		$UI.clear(MainGrid);
		$UI.clear(DetailGrid);
		$UI.clear(ReqMainGrid);
		var ParamsObj = $UI.loopBlock('#Conditions');
		var Params = JSON.stringify(ParamsObj);
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
		/* if (isEmpty(ParamsObj.DispLoc)) {
			$UI.msg('alert', '���Ҳ���Ϊ��!');
			return;
		}*/
		var currTab = $('#tabs').tabs('getSelected');
		var index = $('#tabs').tabs('getTabIndex', currTab);
		if (index == 0) {
			MainGrid.load({
				ClassName: 'web.DHCSTMHUI.SubLocMatStat',
				QueryName: 'INDispStat',
				query2JsonStrict: 1,
				Params: Params
			});
		} else if (index == 1) {
			ReqMainGrid.load({
				ClassName: 'web.DHCSTMHUI.SubLocMatStat',
				QueryName: 'INDispDetailStat',
				query2JsonStrict: 1,
				Params: Params
			});
		} else if (index == 2) {
			Params = encodeUrlStr(Params);
			var url = PmRunQianUrl + '?reportName=DHCSTM_HUI_SubLocDispAllotStat.raq&Params=' + Params;
			$('#tabs').tabs('update', {
				tab: currTab,
				options: {
					content: CreateFrame(url)
				}
			});
		} else if (index == 3) {
			Params = encodeUrlStr(Params);
			var url = PmRunQianUrl + '?reportName=DHCSTM_HUI_SubLocDispAndOeori.raq&Params=' + Params;
			$('#tabs').tabs('update', {
				tab: currTab,
				options: {
					content: CreateFrame(url)
				}
			});
		}
	}

	function Clear() {
		$UI.clearBlock('#Conditions');
		$('#DispLoc').combobox('setValue', gLocId);
		$('#StartDate').datebox('setValue', DateFormatter(new Date()));
		$('#EndDate').datebox('setValue', DateFormatter(new Date()));
		$UI.clear(MainGrid);
		$UI.clear(DetailGrid);
		$UI.clear(ReqMainGrid);
	}

	Clear();
};
$(init);