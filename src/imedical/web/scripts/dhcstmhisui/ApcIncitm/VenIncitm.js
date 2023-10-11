var init = function() {
	var HospId = gHospId;
	var TableName = 'APC_Vendor';
	function InitHosp() {
		var hospComp = InitHospCombo(TableName, gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			Clear();
			QueryVen();
			InciQuery();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				setStkGrpHospid(HospId);
				$HUI.combotree('#StkGrpBox').load(HospId);
				$HUI.combotree('#WinStkGrpBox').load(HospId);
				Clear();
				QueryVen();
				InciQuery();
			};
		}
		setStkGrpHospid(HospId);
	}
	var VendorCat = $HUI.combobox('#VendorCat', {
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.APCVendCat&QueryName=GetVendorCat&ResultSetType=array&Params=' + Params;
			VendorCat.reload(url);
		}
	});
	var VendorCm = [[
		{
			title: 'Venid',
			field: 'Venid',
			width: 50,
			hidden: true
		}, {
			title: '����',
			field: 'Code',
			width: 100
		}, {
			title: '����',
			field: 'Name',
			width: 200
		}, {
			title: '�绰',
			field: 'Tel',
			width: 100
		}, {
			title: '����',
			field: 'Category',
			width: 100
		}, {
			title: '�˻�',
			field: 'CtrlAcct',
			width: 150
		}, {
			title: 'ע���ʽ�',
			field: 'CrAvail',
			align: 'right',
			width: 100
		}, {
			title: '��ͬ����',
			field: 'LstPoDate',
			width: 100
		}, {
			title: '����',
			field: 'Fax',
			width: 100
		}, {
			title: '����',
			field: 'President',
			width: 100
		}, {
			title: 'ʹ�ñ�־',
			field: 'Status',
			width: 100,
			formatter: function(value, row, index) {
				if (value == 'A') {
					return 'ʹ��';
				} else {
					return 'ͣ��';
				}
			}
		}
	]];

	var VendorGrid = $UI.datagrid('#VendorGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.VenIncitm',
			QueryName: 'GetAllVendor',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		columns: VendorCm,
		onSelect: function(Index, Row) {
			QueryVenInci(Row.Venid);
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				VendorGrid.selectRow(0);
			}
		}
	});

	$UI.linkbutton('#VenQueryBT', {
		onClick: function() {
			QueryVen();
		}
	});
	
	function Clear() {
		$UI.clearBlock('#VenConditions');
		var DefaultData = {
			Status: 'A'
		};
		$UI.fillBlock('#VenConditions', DefaultData);
	}
	
	function QueryVen() {
		var SessionParmas = addSessionParams({ BDPHospital: HospId });
		var Paramsobj = $UI.loopBlock('#VenConditions');
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		$UI.clear(VendorGrid);
		VendorGrid.load({
			ClassName: 'web.DHCSTMHUI.VenIncitm',
			QueryName: 'GetAllVendor',
			query2JsonStrict: 1,
			Params: Params,
			rows: 99999
		});
	}
	var VenInciCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '�����id',
			field: 'IncId',
			width: 100,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'Incicode',
			width: 100,
			frozen: true
		}, {
			title: '��������',
			field: 'Incidesc',
			width: 150,
			frozen: true
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '��ʼ����',
			field: 'StartDate',
			width: 100
		}, {
			title: '��ֹ����',
			field: 'EndDate',
			width: 100
		}
	]];
	function CancelVenInciAu() {
		var ItmDetail = VenInciGrid.getSelections();
		if (isEmpty(ItmDetail)) {
			$UI.msg('alert', '��ѡ����Ҫ����ļ�¼!');
			return false;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.VenIncitm',
			MethodName: 'StopInciVendor',
			Params: JSON.stringify(ItmDetail)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				var RowData = VendorGrid.getSelected();
				var VendId = RowData.Venid;
				QueryVenInci(VendId);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var VenInciToolBar = [{
		text: '����Ʒ��ά��',
		iconCls: 'icon-write-order',
		handler: function() {
			var RowData = VendorGrid.getSelected();
			if (isEmpty(RowData)) {
				$UI.msg('alert', '��ѡ��Ӧ��!');
				return false;
			}
			var Venid = RowData.Venid;
			if (isEmpty(Venid)) {
				$UI.msg('alert', '��ѡ��Ӧ��!');
				return false;
			}
			UAuItmListWin(Venid, QueryVenInci, HospId);
		}
	}, '-', {
		text: 'ȡ����Ȩ',
		iconCls: 'icon-cancel-order',
		handler: function() {
			CancelVenInciAu();
		}
	}
	];
	var VenInciGrid = $UI.datagrid('#VenInciGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.VenIncitm',
			QueryName: 'GetVenInci',
			query2JsonStrict: 1
		},
		columns: VenInciCm,
		fitColumns: true,
		singleSelect: false,
		toolbar: VenInciToolBar
	});
	function QueryVenInci(Venid) {
		if (isEmpty(Venid)) {
			$UI.info('alert', '��ѡ��һ����Ӧ��');
			return false;
		}
		$UI.clear(VenInciGrid);
		VenInciGrid.load({
			ClassName: 'web.DHCSTMHUI.VenIncitm',
			QueryName: 'GetVenInci',
			query2JsonStrict: 1,
			Vendor: Venid
		});
	}
	// / ����->��Ӧ��
	var StkCatBox = $HUI.combobox('#StkCatBox', {
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			var scg = $('#StkGrpBox').combotree('getValue');
			var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			StkCatBox.clear();
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId=' + scg + '&Params=' + Params;
			StkCatBox.reload(url);
		}
	});
		
	var InciInfoCm = [[{
		title: '�����id',
		field: 'RowId',
		width: 100,
		hidden: true
	}, {
		title: '���ʴ���',
		field: 'InciCode',
		width: 100,
		frozen: true
	}, {
		title: '��������',
		field: 'InciDesc',
		width: 150,
		frozen: true
	}, {
		title: '���',
		field: 'Spec',
		width: 100
	}
	]];
	var InciGrid = $UI.datagrid('#InciGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
			QueryName: 'GetItm',
			query2JsonStrict: 1,
			rows: 99999
		},
		columns: InciInfoCm,
		fitColumns: true,
		pagination: false,
		onSelect: function(Index, Row) {
			QueryInciVen(Row.RowId);
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				InciGrid.selectRow(0);
			}
		}
	});
	$UI.linkbutton('#InciQueryBT', {
		onClick: function() { InciQuery(); }
	});
	function InciQuery() {
		var SessionParmas = addSessionParams({ BDPHospital: HospId });
		var Paramsobj = $UI.loopBlock('#InciConditions');
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		$UI.clear(InciGrid);
		InciGrid.load({
			ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
			QueryName: 'GetItm',
			query2JsonStrict: 1,
			Params: Params,
			rows: 99999
		});
	}
	var InciVendorCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: 'Vendor',
			field: 'Vendor',
			width: 50,
			hidden: true
		}, {
			title: '����',
			field: 'VendorDesc',
			width: 200
		}, {
			title: '��ʼ����',
			field: 'StartDate',
			width: 100
		}, {
			title: '��ֹ����',
			field: 'EndDate',
			width: 100
		}
	]];
	function CancelInciVenAu() {
		var ItmDetail = InciApcGrid.getSelections();
		if (isEmpty(ItmDetail)) {
			$UI.msg('alert', '��ѡ����Ҫ����ļ�¼!');
			return false;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.VenIncitm',
			MethodName: 'StopInciVendor',
			Params: JSON.stringify(ItmDetail)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				var RowData = InciGrid.getSelected();
				var RowId = RowData.RowId;
				QueryInciVen(RowId);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var InciVenToolBar = [{
		text: '��Ȩ��Ӧ��ά��',
		iconCls: 'icon-write-order',
		handler: function() {
			var RowData = InciGrid.getSelected();
			if (isEmpty(RowData)) {
				$UI.msg('alert', '��ѡ��������!');
				return false;
			}
			var Incid = RowData.RowId;
			if (isEmpty(Incid)) {
				$UI.msg('alert', '��ѡ��������!');
				return false;
			}
			UAuVenListWin(Incid, QueryInciVen, HospId);
		}
	}, '-', {
		text: 'ȡ����Ȩ',
		iconCls: 'icon-cancel-order',
		handler: function() {
			CancelInciVenAu();
		}
	}
	];
	var InciApcGrid = $UI.datagrid('#InciApcGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.VenIncitm',
			QueryName: 'GetInciApc',
			query2JsonStrict: 1
		},
		columns: InciVendorCm,
		fitColumns: true,
		singleSelect: false,
		toolbar: InciVenToolBar
	});
	function QueryInciVen(Incid) {
		if (isEmpty(Incid)) {
			$UI.info('alert', '��ѡ��һ��������');
			return false;
		}
		$UI.clear(InciApcGrid);
		InciApcGrid.load({
			ClassName: 'web.DHCSTMHUI.VenIncitm',
			QueryName: 'GetInciApc',
			query2JsonStrict: 1,
			Inci: Incid
		});
	}
	InitHosp();
};
$(init);