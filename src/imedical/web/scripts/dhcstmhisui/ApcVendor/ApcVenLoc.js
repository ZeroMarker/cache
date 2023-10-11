var HospId = gHospId;
var TableName = 'APC_Vendor';
var init = function() {
	function InitHosp() {
		var hospComp = InitHospCombo(TableName, gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				SearchLoc();
			};
		}
		SearchLoc();
	}
	$UI.linkbutton('#SearchLocBT', {
		onClick: function() {
			SearchLoc();
		}
	});
	$UI.linkbutton('#SearchVenBT', {
		onClick: function() {
			SearchLinkVen();
		}
	});
	$UI.linkbutton('#SearchNoLinkBT', {
		onClick: function() {
			SearchNoLinkVen();
		}
	});
	$UI.linkbutton('#DeleteBT', {
		onClick: function() {
			DeleteLink();
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			SaveLink();
		}
	});
	function SearchLoc() {
		var SessionParmas = addSessionParams({ BDPHospital: HospId });
		var Paramsobj = $UI.loopBlock('#LocConditions');
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		LocGrid.load({
			ClassName: 'web.DHCSTMHUI.ApcVenLoc',
			QueryName: 'GeLoc',
			query2JsonStrict: 1,
			Params: Params,
			rows: 99999
		});
	}
	function SearchLinkVen() {
		var SelectedRow = LocGrid.getSelected();
		if (isEmpty(SelectedRow)) {
			$UI.msg('alert', '请选择科室信息!');
			return;
		}
		var LocId = SelectedRow['LocId'];
		if (isEmpty(LocId)) {
			$UI.msg('alert', '请选择科室信息!');
			return false;
		}
		var SessionParmas = addSessionParams({ BDPHospital: HospId, LocId: LocId, LinkFlag: 'Y' });
		var Paramsobj = $UI.loopBlock('#LinkConditions');
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		LinkVenGrid.load({
			ClassName: 'web.DHCSTMHUI.ApcVenLoc',
			QueryName: 'GetVendor',
			query2JsonStrict: 1,
			Params: Params,
			rows: 99999
		});
	}
	function SearchNoLinkVen() {
		var SelectedRow = LocGrid.getSelected();
		if (isEmpty(SelectedRow)) {
			$UI.msg('alert', '请选择科室信息!');
			return;
		}
		var LocId = SelectedRow['LocId'];
		if (isEmpty(LocId)) {
			$UI.msg('alert', '请选择科室信息!');
			return false;
		}
		var SessionParmas = addSessionParams({ BDPHospital: HospId, LocId: LocId, LinkFlag: 'N' });
		var Paramsobj = $UI.loopBlock('#NoLinkConditions');
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		NoLinkVenGrid.load({
			ClassName: 'web.DHCSTMHUI.ApcVenLoc',
			QueryName: 'GetVendor',
			query2JsonStrict: 1,
			Params: Params,
			rows: 99999
		});
	}
	function SaveLink() {
		var SelectedRow = LocGrid.getSelected();
		if (isEmpty(SelectedRow)) {
			$UI.msg('alert', '请选择科室信息!');
			return;
		}
		var LocId = SelectedRow['LocId'];
		if (isEmpty(LocId)) {
			$UI.msg('alert', '请选择科室信息!');
			return false;
		}
		var RowsData = NoLinkVenGrid.getSelections();
		if (isEmpty(RowsData)) {
			$UI.msg('alert', '请选择需要授权的供应商!');
			return;
		}
		var Params = JSON.stringify(RowsData);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.ApcVenLoc',
			MethodName: 'jsSave',
			LocId: LocId,
			VenStr: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				SearchLinkVen();
				SearchNoLinkVen();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	function DeleteLink() {
		var SelectedRow = LocGrid.getSelected();
		if (isEmpty(SelectedRow)) {
			$UI.msg('alert', '请选择科室信息!');
			return;
		}
		var LocId = SelectedRow['LocId'];
		if (isEmpty(LocId)) {
			$UI.msg('alert', '请选择科室信息!');
			return false;
		}
		var RowsData = LinkVenGrid.getSelections();
		if (isEmpty(RowsData)) {
			$UI.msg('alert', '请选择需要取消授权的供应商!');
			return;
		}
		var Params = JSON.stringify(RowsData);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.ApcVenLoc',
			MethodName: 'jsDelete',
			LinkIdStr: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				SearchLinkVen();
				SearchNoLinkVen();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var LocCm = [[
		{
			title: 'LocId',
			field: 'LocId',
			hidden: true,
			width: 60
		}, {
			title: '科室描述',
			field: 'LocDesc',
			width: 300
		}
	]];
	var LocGrid = $UI.datagrid('#LocGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ApcVenLoc',
			QueryName: 'GeLoc',
			query2JsonStrict: 1
		},
		columns: LocCm,
		displayMsg: '',
		onSelect: function(Index, Row) {
			SearchLinkVen();
			SearchNoLinkVen();
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				LocGrid.selectRow(0);
			}
		}
	});
	var LinkVenCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'LinkId',
			field: 'LinkId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '代码',
			field: 'VendorCode',
			width: 150
		}, {
			title: '名称',
			field: 'VendorDesc',
			width: 200
		}
	]];

	var LinkVenGrid = $UI.datagrid('#LinkVenGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ApcVenLoc',
			QueryName: 'GetVendor',
			query2JsonStrict: 1,
			rows: 99999
		},
		columns: LinkVenCm,
		fitColumns: true,
		checkOnSelect: false,
		pagination: false,
		singleSelect: false
	});
	
	var NoLinkVenCm = [[
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
			title: '代码',
			field: 'VendorCode',
			width: 150
		}, {
			title: '名称',
			field: 'VendorDesc',
			width: 200
		}
	]];

	var NoLinkVenGrid = $UI.datagrid('#NoLinkVenGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ApcVenLoc',
			QueryName: 'GetVendor',
			query2JsonStrict: 1,
			rows: 99999
		},
		columns: NoLinkVenCm,
		checkOnSelect: false,
		pagination: false,
		singleSelect: false
	});
	InitHosp();
};
$(init);