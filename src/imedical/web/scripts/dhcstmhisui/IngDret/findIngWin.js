var FindWin = function(Fn) {
	$HUI.dialog('#FindWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
	
	var Clear = function() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(RetMainGrid);
		$UI.clear(RetDetailGrid);
		var LocId = $('#RetLoc').combobox('getValue');
		var LocDesc = $('#RetLoc').combobox('getText');
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			RetLoc: { RowId: LocId, Description: LocDesc },
			AuditFlag: 'N',
			HvFlag: gHVInRet ? 'Y' : 'N'
		};
		$UI.fillBlock('#FindConditions', DefaultData);
	};
	$UI.linkbutton('#FQueryBT', {
		onClick: function() {
			FQuery();
		}
	});
	function FQuery() {
		$UI.clear(RetDetailGrid);
		var ParamsObj = $UI.loopBlock('#FindConditions');
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(ParamsObj.RetLoc)) {
			$UI.msg('alert', '�˻����Ҳ���Ϊ��!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		RetMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINGdRet',
			QueryName: 'DHCINGdRet',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#FComBT', {
		onClick: function() {
			var Row = RetMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ���ص��˻���!');
				return;
			}
			Fn(Row.RowId);
			$HUI.dialog('#FindWin').close();
		}
	});
	$UI.linkbutton('#FClearBT', {
		onClick: function() {
			Clear();
		}
	});

	var FRetLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var FRetLocBox = $HUI.combobox('#FRetLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FRetLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			if (CommParObj.ApcScg == 'L') {
				FVendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M', LocId: LocId }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
				FVendorBox.reload(url);
			}
		}
	});
	var FVendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var FVendorBox = $HUI.combobox('#FVendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FVendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var RetMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '�˻�����',
			field: 'RetNo',
			width: 150
		}, {
			title: '��Ӧ��',
			field: 'VendorName',
			width: 150
		}, {
			title: '�˻�����',
			field: 'RetLocDesc',
			width: 150
		}, {
			title: '�Ƶ���',
			field: 'RetUserName',
			width: 70
		}, {
			title: '�Ƶ�����',
			field: 'RetDate',
			width: 90
		}, {
			title: '�Ƶ�ʱ��',
			field: 'RetTime',
			width: 80
		}, {
			title: '���״̬',
			field: 'Completed',
			width: 80,
			formatter: BoolFormatter
		}, {
			title: '��ע',
			field: 'Remark',
			width: 100
		}
	]];
	
	var RetMainGrid = $UI.datagrid('#RetMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRet',
			QueryName: 'DHCINGdRet',
			query2JsonStrict: 1
		},
		columns: RetMainCm,
		showBar: true,
		onSelect: function(index, row) {
			var ParamsObj = { RefuseFlag: 1 };
			var Params = JSON.stringify(ParamsObj);
			RetDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGrtItm',
				QueryName: 'DHCINGdRetItm',
				query2JsonStrict: 1,
				RetId: row.RowId
			});
		},
		onDblClickRow: function(index, row) {
			Fn(row.RowId);
			$HUI.dialog('#FindWin').close();
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	
	var RetDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: 'Ingri',
			field: 'Ingri',
			width: 100,
			hidden: true
		}, {
			title: 'Inci',
			field: 'Inci',
			width: 100,
			hidden: true
		}, {
			title: 'Inclb',
			field: 'Inclb',
			width: 100,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'Code',
			width: 100
		}, {
			title: '��������',
			field: 'Description',
			width: 150
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '��������',
			field: 'Manf',
			width: 150
		}, {
			title: '����',
			field: 'BatNo',
			width: 100
		}, {
			title: 'Ч��',
			field: 'ExpDate',
			width: 120
		}, {
			title: '���ο��',
			field: 'StkQty',
			width: 100,
			align: 'right'
		}, {
			title: '�˻�����',
			field: 'Qty',
			width: 100,
			align: 'right'
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 100
		}, {
			title: '�˻�ԭ��',
			field: 'Reason',
			width: 100
		}, {
			title: '�˻�����',
			field: 'Rp',
			width: 100,
			align: 'right'
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '��Ʊ��',
			field: 'InvNo',
			width: 100,
			align: 'left'
		}, {
			title: '��Ʊ����',
			field: 'InvDate',
			width: 100,
			align: 'left'
		}, {
			title: '��Ʊ���',
			field: 'InvAmt',
			width: 100,
			align: 'right'
		}, {
			title: '���۵���',
			field: 'Sp',
			width: 100,
			align: 'right'
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '��ע',
			field: 'Remark',
			width: 200,
			align: 'left'
		}, {
			title: '������',
			field: 'SpecDesc',
			width: 100,
			align: 'left',
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: '��ֵ��־',
			field: 'HvFlag',
			width: 80,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: '���е���',
			field: 'SxNo',
			width: 200,
			align: 'left'
		}
	]];
	var RetDetailGrid = $UI.datagrid('#RetDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGrtItm',
			QueryName: 'DHCINGdRetItm',
			query2JsonStrict: 1
		},
		columns: RetDetailCm,
		showBar: true
	});
	Clear();
	FQuery();
};