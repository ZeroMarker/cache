/*
��ⵥ�Ƶ���ѯ(��ֵ)
*/
var DrugImportGrSearch = function(Fn) {
	$HUI.dialog('#FindWin', {
		height: gWinHeight,
		width: gWinWidth
	}).open();
	var Clear = function() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(InGdRecMainGrid);
		$UI.clear(InGdRecDetailGrid);
		// /���ó�ʼֵ ����ʹ������
		var LocId = $('#RecLoc').combobox('getValue');
		var LocDesc = $('#RecLoc').combobox('getText');
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			FRecLoc: { RowId: LocId, Description: LocDesc },
			AuditFlag: 'N',
			HVFlag: 'Y'
		};
		$UI.fillBlock('#FindConditions', DefaultData);
	};
	var FRecLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var FRecLocBox = $HUI.combobox('#FRecLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FRecLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			if (CommParObj.ApcScg == 'L') {
				FVendorBoxBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M', LocId: LocId }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
				FVendorBoxBox.reload(url);
			}
		}
	});
	var FVendorBoxParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var FVendorBoxBox = $HUI.combobox('#FVendorBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FVendorBoxParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#FQueryBT', {
		onClick: function() {
			FQuery();
		}
	});
	function FQuery() {
		var ParamsObj = $UI.loopBlock('#FindConditions');
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(ParamsObj.FRecLoc)) {
			$UI.msg('alert', '�����Ҳ���Ϊ��!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(InGdRecDetailGrid);
		InGdRecMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'Query',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	$UI.linkbutton('#FClearBT', {
		onClick: function() {
			Clear();
		}
	});
	$UI.linkbutton('#FReturnBT', {
		onClick: function() {
			var Row = InGdRecMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ���ص���ⵥ!');
				return;
			}
			Fn(Row.IngrId);
			$HUI.dialog('#FindWin').close();
		}
	});
	var InGdRecMainCm = [[
		{
			title: 'RowId',
			field: 'IngrId',
			width: 100,
			hidden: true
		}, {
			title: '��ⵥ��',
			field: 'IngrNo',
			width: 120
		}, {
			title: '��Ӧ��',
			field: 'Vendor',
			width: 200
		}, {
			title: '��������',
			field: 'ReqLocDesc',
			width: 150
		}, {
			title: '�ɹ�Ա',
			field: 'PurchUser',
			width: 70
		}, {
			title: '�������',
			field: 'IngrType',
			width: 80
		}, {
			title: '��ɱ�־',
			field: 'Complete',
			width: 70
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '������',
			field: 'CreateUser',
			width: 70
		}, {
			title: '��������',
			field: 'CreateDate',
			width: 90
		}
	]];

	var InGdRecMainGrid = $UI.datagrid('#InGdRecMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'Query',
			query2JsonStrict: 1
		},
		columns: InGdRecMainCm,
		showBar: true,
		onSelect: function(index, row) {
			InGdRecDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
				QueryName: 'QueryDetail',
				query2JsonStrict: 1,
				Parref: row.IngrId
			});
		},
		onDblClickRow: function(index, row) {
			Fn(row.IngrId);
			$HUI.dialog('#FindWin').close();
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				InGdRecMainGrid.selectRow(0);
			}
		}
	});

	var InGdRecDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'IncCode',
			width: 80
		}, {
			title: '��������',
			field: 'IncDesc',
			width: 230
		}, {
			title: '��������',
			field: 'Manf',
			width: 180
		}, {
			title: '����',
			field: 'BatchNo',
			width: 90
		}, {
			title: '��Ч��',
			field: 'ExpDate',
			width: 100
		}, {
			title: '��λ',
			field: 'IngrUom',
			width: 60
		}, {
			title: '����',
			field: 'RecQty',
			width: 80,
			align: 'right'
		}, {
			title: '����',
			field: 'Rp',
			width: 60,
			align: 'right'
		}, {
			title: '�ۼ�',
			field: 'Sp',
			width: 60,
			align: 'right'
		}, {
			title: '��Ʊ��',
			field: 'InvNo',
			width: 80
		}, {
			title: '��Ʊ����',
			field: 'InvDate',
			width: 100
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 100,
			align: 'right'
		}
	]];

	var InGdRecDetailGrid = $UI.datagrid('#InGdRecDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
			QueryName: 'QueryDetail',
			query2JsonStrict: 1
		},
		columns: InGdRecDetailCm,
		showBar: true
	});
	Clear();
	FQuery();
};