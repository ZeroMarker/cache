/*
������ѯ
*/
var ImportPoSearch = function(Fn, LocObj) {
	$HUI.dialog('#ImportByPo', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
	
	var Clear = function() {
		$UI.clearBlock('#ImportByPoConditions');
		$UI.clear(PoMainGrid);
		$UI.clear(PoDetailGrid);
		
		var DefaPoData = {
			PoStartDate: TrackDefaultStDate(),
			PoEndDate: TrackDefaultEdDate(),
			PoRecLoc: LocObj
		};
		$UI.fillBlock('#ImportByPoConditions', DefaPoData);
	};
	
	var PRecLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var PRecLocBox = $HUI.combobox('#PoRecLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PRecLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var PVendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var VendorBox = $HUI.combobox('#PoVendorBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + PVendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#PoQueryBT', {
		onClick: function() {
			PoQuery();
		}
	});
	function PoQuery() {
		$UI.clear(PoMainGrid);
		$UI.clear(PoDetailGrid);
		var ParamsObj = $CommonUI.loopBlock('#ImportByPoConditions');
		var StartDate = ParamsObj.PoStartDate;
		var EndDate = ParamsObj.PoEndDate;
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
		var Params = JSON.stringify(ParamsObj);
		PoMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'QueryPo',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	$UI.linkbutton('#PoClearBT', {
		onClick: function() {
			Clear();
		}
	});
	function ReturnPo() {
		var Row = PoMainGrid.getSelected();
		if (isEmpty(Row)) {
			$UI.msg('alert', '��ѡ��Ҫ���صĶ���!');
			return;
		}
		var VendorId = Row.VendorId;
		var VendorDesc = Row.VendorDesc;
		var rowsData = PoDetailGrid.getRowsData();	// ȡgrid���м�¼
		Fn(rowsData, VendorId, VendorDesc);
		$HUI.dialog('#ImportByPo').close();
	}
	$UI.linkbutton('#PoReturnBT', {
		onClick: function() {
			ReturnPo();
		}
	});
	var PoMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '��������',
			field: 'PoNo',
			width: 120
		}, {
			title: '��Ӧ��id',
			field: 'VendorId',
			width: 50,
			hidden: true
		}, {
			title: '��Ӧ��',
			field: 'VendorDesc',
			width: 150
		}, {
			title: '��������',
			field: 'PoLocDesc',
			width: 150
		}, {
			title: '�깺����',
			field: 'ReqLocDesc',
			width: 150
		}, {
			title: '��������',
			field: 'PoDate',
			width: 90
		}
	]];
	
	var PoMainGrid = $UI.datagrid('#PoMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'QueryPo',
			query2JsonStrict: 1
		},
		columns: PoMainCm,
		onSelect: function(index, row) {
			PoDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCItmTrack',
				QueryName: 'INPOItmQuery',
				query2JsonStrict: 1,
				Parref: row.RowId
			});
		},
		onDblClickRow: function(index, row) {
			ReturnPo();
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				PoMainGrid.selectRow(0);
			}
		}
	});
	
	var PoDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '����id',
			field: 'InciId',
			hidden: true,
			width: 80
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 80
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 200
		}, {
			title: '���',
			field: 'Spec',
			width: 80
		}, {
			title: '����',
			field: 'AvaQty',
			align: 'right',
			width: 60
		}, {
			title: '����',
			field: 'Rp',
			align: 'right',
			width: 60
		}, {
			title: '��λid',
			field: 'UomId',
			width: 50,
			hidden: true
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 50
		}, {
			title: '��������',
			field: 'PurQty',
			align: 'right',
			width: 90
		}, {
			title: '���������',
			field: 'ImpQty',
			align: 'right',
			width: 90
		}, {
			title: 'ע��֤����',
			field: 'CertNo',
			width: 90
		}, {
			title: 'ע��֤Ч��',
			field: 'CertExpDate',
			width: 90
		}, {
			title: '��������id',
			field: 'ManfId',
			width: 90,
			hidden: true
		}, {
			title: '��������',
			field: 'ManfDesc',
			width: 90
		}, {
			title: '�������־',
			field: 'BatchCodeFlag',
			width: 100,
			hidden: false,
			align: 'center'
		}
	]];
	
	var PoDetailGrid = $UI.datagrid('#PoDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'INPOItmQuery',
			query2JsonStrict: 1
		},
		columns: PoDetailCm
	});
	Clear();
	PoQuery();
};