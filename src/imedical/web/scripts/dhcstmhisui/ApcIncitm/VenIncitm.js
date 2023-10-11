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
			title: '代码',
			field: 'Code',
			width: 100
		}, {
			title: '名称',
			field: 'Name',
			width: 200
		}, {
			title: '电话',
			field: 'Tel',
			width: 100
		}, {
			title: '分类',
			field: 'Category',
			width: 100
		}, {
			title: '账户',
			field: 'CtrlAcct',
			width: 150
		}, {
			title: '注册资金',
			field: 'CrAvail',
			align: 'right',
			width: 100
		}, {
			title: '合同日期',
			field: 'LstPoDate',
			width: 100
		}, {
			title: '传真',
			field: 'Fax',
			width: 100
		}, {
			title: '法人',
			field: 'President',
			width: 100
		}, {
			title: '使用标志',
			field: 'Status',
			width: 100,
			formatter: function(value, row, index) {
				if (value == 'A') {
					return '使用';
				} else {
					return '停用';
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
			title: '库存项id',
			field: 'IncId',
			width: 100,
			hidden: true
		}, {
			title: '物资代码',
			field: 'Incicode',
			width: 100,
			frozen: true
		}, {
			title: '物资名称',
			field: 'Incidesc',
			width: 150,
			frozen: true
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '开始日期',
			field: 'StartDate',
			width: 100
		}, {
			title: '截止日期',
			field: 'EndDate',
			width: 100
		}
	]];
	function CancelVenInciAu() {
		var ItmDetail = VenInciGrid.getSelections();
		if (isEmpty(ItmDetail)) {
			$UI.msg('alert', '请选择需要处理的记录!');
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
		text: '供货品种维护',
		iconCls: 'icon-write-order',
		handler: function() {
			var RowData = VendorGrid.getSelected();
			if (isEmpty(RowData)) {
				$UI.msg('alert', '请选择供应商!');
				return false;
			}
			var Venid = RowData.Venid;
			if (isEmpty(Venid)) {
				$UI.msg('alert', '请选择供应商!');
				return false;
			}
			UAuItmListWin(Venid, QueryVenInci, HospId);
		}
	}, '-', {
		text: '取消授权',
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
			$UI.info('alert', '请选择一个供应商');
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
	// / 物资->供应商
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
		title: '库存项id',
		field: 'RowId',
		width: 100,
		hidden: true
	}, {
		title: '物资代码',
		field: 'InciCode',
		width: 100,
		frozen: true
	}, {
		title: '物资名称',
		field: 'InciDesc',
		width: 150,
		frozen: true
	}, {
		title: '规格',
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
			title: '名称',
			field: 'VendorDesc',
			width: 200
		}, {
			title: '开始日期',
			field: 'StartDate',
			width: 100
		}, {
			title: '截止日期',
			field: 'EndDate',
			width: 100
		}
	]];
	function CancelInciVenAu() {
		var ItmDetail = InciApcGrid.getSelections();
		if (isEmpty(ItmDetail)) {
			$UI.msg('alert', '请选择需要处理的记录!');
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
		text: '授权供应商维护',
		iconCls: 'icon-write-order',
		handler: function() {
			var RowData = InciGrid.getSelected();
			if (isEmpty(RowData)) {
				$UI.msg('alert', '请选择物资项!');
				return false;
			}
			var Incid = RowData.RowId;
			if (isEmpty(Incid)) {
				$UI.msg('alert', '请选择物资项!');
				return false;
			}
			UAuVenListWin(Incid, QueryInciVen, HospId);
		}
	}, '-', {
		text: '取消授权',
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
			$UI.info('alert', '请选择一个物资项');
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