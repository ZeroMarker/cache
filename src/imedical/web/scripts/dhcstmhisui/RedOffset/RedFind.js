/*
����Ƶ���ѯ
*/
var RedFind = function(Fn) {
	$HUI.dialog('#FindWin', {
		height: gWinHeight,
		width: gWinWidth
	}).open();
	// ������
	var FRedLocParams = JSON.stringify(addSessionParams({
		Type: 'Login',
		Element: 'FRedLoc',
		onSelect: function(record) {
			var LocId = record['RowId'];
			if (CommParObj.ApcScg == 'L') {
				FVendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M', LocId: LocId }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
				FVendorBox.reload(url);
			}
		}
	}));
	var FRedLocBox = $HUI.combobox('#FRedLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FRedLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	// ��Ӧ��
	var FVendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var FVendorBox = $HUI.combobox('#FVendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FVendorParams,
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
		if (isEmpty(ParamsObj.RedLoc)) {
			$UI.msg('alert', '�����Ҳ���Ϊ��!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(RedDetailGrid);
		RedMainGrid.load({
			ClassName: 'web.DHCSTMHUI.RedOffset',
			QueryName: 'Query',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	$UI.linkbutton('#FClearBT', {
		onClick: function() {
			FClear();
		}
	});
	var FClear = function() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(RedMainGrid);
		$UI.clear(RedDetailGrid);
		// /���ó�ʼֵ ����ʹ������
		var LocId = $('#RedLoc').combobox('getValue');
		var LocDesc = $('#RedLoc').combobox('getText');
		var Dafult = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			RedLoc: { RowId: LocId, Description: LocDesc },
			AuditFlag: 'N'
		};
		$UI.fillBlock('#FindConditions', Dafult);
	};
	$UI.linkbutton('#FSelectBT', {
		onClick: function() {
			var Row = RedMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ���صĺ�嵥!');
				return;
			}
			Fn(Row.RowId);
			$HUI.dialog('#FindWin').close();
		}
	});
	var RedMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '��嵥��',
			field: 'RedNo',
			width: 150
		}, {
			title: '������',
			field: 'RedLoc',
			width: 150
		}, {
			title: '��Ӧ��',
			field: 'Vendor',
			width: 150
		}, {
			title: '������',
			field: 'CreateUser',
			width: 100
		}, {
			title: '��������',
			field: 'CreateDate',
			width: 100
		}, {
			title: 'CompFlag',
			field: 'CompFlag',
			width: 100,
			hidden: true
		}
	]];

	var RedMainGrid = $UI.datagrid('#RedMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.RedOffset',
			QueryName: 'Query',
			query2JsonStrict: 1
		},
		columns: RedMainCm,
		showBar: true,
		singleSelect: false,
		onSelect: function(index, row) {
			RedDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.RedOffsetItm',
				QueryName: 'QueryDetail',
				query2JsonStrict: 1,
				Parref: row.RowId,
				rows: 99999
			});
		},
		onDblClickRow: function(index, row) {
			Fn(row.RowId);
			$HUI.dialog('#FindWin').close();
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				RedMainGrid.selectRow(0);
			}
		}
	});

	var RedDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 100
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 160
		}, {
			title: '���',
			field: 'Spec',
			width: 80
		}, {
			title: '��������',
			field: 'Manf',
			width: 180
		}, {
			title: '����id',
			field: 'Inclb',
			width: 70,
			hidden: true
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
			field: 'Uom',
			width: 80
		}, {
			title: '�������',
			field: 'Qty',
			width: 80,
			align: 'right'
		}, {
			title: '�½���',
			field: 'NewRp',
			width: 60,
			align: 'right'
		}, {
			title: '���ۼ�',
			field: 'NewSp',
			width: 60,
			align: 'right'
		}, {
			title: '�½��۽��',
			field: 'NewRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '���ۼ۽��',
			field: 'NewSpAmt',
			width: 100,
			align: 'right'
		}, {
			title: 'ԭ����',
			field: 'OldRp',
			width: 60,
			align: 'right'
		}, {
			title: 'ԭ�ۼ�',
			field: 'OldSp',
			width: 60,
			align: 'right'
		}, {
			title: 'ԭ���۽��',
			field: 'OldRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: 'ԭ�ۼ۽��',
			field: 'OldSpAmt',
			width: 100,
			align: 'right'
		}
	]];
	var RedDetailGrid = $UI.datagrid('#RedDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.RedOffsetItm',
			QueryName: 'QueryDetail',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		columns: RedDetailCm,
		showBar: true,
		onClickRow: function(index, row) {
			RedDetailGrid.commonClickRow(index, row);
		}
	});
	FClear();
	FQuery();
};