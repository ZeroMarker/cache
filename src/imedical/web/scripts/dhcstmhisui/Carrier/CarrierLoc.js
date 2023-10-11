var HospId = gHospId;
var TableName = 'DHC_Carrier';
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
	$UI.linkbutton('#SearchLinkBT', {
		onClick: function() {
			SearchLinkInfo();
		}
	});
	$UI.linkbutton('#SearchNoLinkBT', {
		onClick: function() {
			SearchNoLinkInfo();
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
			ClassName: 'web.DHCSTMHUI.CarrierLoc',
			QueryName: 'GeLoc',
			query2JsonStrict: 1,
			Params: Params,
			rows: 99999
		});
	}
	function SearchLinkInfo() {
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
		LinkGrid.load({
			ClassName: 'web.DHCSTMHUI.CarrierLoc',
			QueryName: 'GetCarrier',
			query2JsonStrict: 1,
			Params: Params,
			rows: 99999
		});
	}
	function SearchNoLinkInfo() {
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
		NoLinkGrid.load({
			ClassName: 'web.DHCSTMHUI.CarrierLoc',
			QueryName: 'GetCarrier',
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
		var RowsData = NoLinkGrid.getSelections();
		if (isEmpty(RowsData)) {
			$UI.msg('alert', '请选择需要授权的配送商!');
			return;
		}
		var Params = JSON.stringify(RowsData);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.CarrierLoc',
			MethodName: 'jsSave',
			LocId: LocId,
			CarrierStr: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				SearchLinkInfo();
				SearchNoLinkInfo();
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
		var RowsData = LinkGrid.getSelections();
		if (isEmpty(RowsData)) {
			$UI.msg('alert', '请选择需要取消授权的供应商!');
			return;
		}
		var Params = JSON.stringify(RowsData);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.CarrierLoc',
			MethodName: 'jsDelete',
			LinkIdStr: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				SearchLinkInfo();
				SearchNoLinkInfo();
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
			ClassName: 'web.DHCSTMHUI.CarrierLoc',
			QueryName: 'GeLoc',
			query2JsonStrict: 1
		},
		columns: LocCm,
		displayMsg: '',
		onSelect: function(Index, Row) {
			SearchLinkInfo();
			SearchNoLinkInfo();
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				LocGrid.selectRow(0);
			}
		}
	});
	var LinkCm = [[
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
			field: 'CarrierCode',
			width: 150
		}, {
			title: '名称',
			field: 'CarrierDesc',
			width: 200
		}
	]];

	var LinkGrid = $UI.datagrid('#LinkGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.CarrierLoc',
			QueryName: 'GetCarrier',
			query2JsonStrict: 1,
			rows: 99999
		},
		columns: LinkCm,
		checkOnSelect: false,
		pagination: false,
		singleSelect: false,
		fitColumns: true
	});
	
	var NoLinkCm = [[
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
			field: 'CarrierCode',
			width: 150
		}, {
			title: '名称',
			field: 'CarrierDesc',
			width: 200
		}
	]];

	var NoLinkGrid = $UI.datagrid('#NoLinkGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.CarrierLoc',
			QueryName: 'GetCarrier',
			query2JsonStrict: 1,
			rows: 99999
		},
		columns: NoLinkCm,
		checkOnSelect: false,
		pagination: false,
		singleSelect: false
	});
	InitHosp();
};
$(init);