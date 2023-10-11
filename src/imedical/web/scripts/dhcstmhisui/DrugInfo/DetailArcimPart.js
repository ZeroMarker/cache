
var InitDetailArcimPart = function() {
	$UI.linkbutton('#AddArcBT', {
		onClick: function() {
			$UI.clearBlock('#InciData');
			$UI.clearBlock('#ArcimData');
			$HUI.checkbox('#ChargeFlag').setValue(true);
			InitCompStat();
			ChangeState(0);
		}
	});
	$UI.linkbutton('#SaveArcBT', {
		onClick: function() {
			Save();
		}
	});
	$UI.linkbutton('#ArcCfgBT', {
		onClick: function() {
			MustInputSet('#ArcimData');
		}
	});
	// 界面元素授权
	$UI.linkbutton('#ArcPageAuthorBT', {
		onClick: function() {
			PageElementAuthorWin('#ArcimData');
		}
	});
	
	$('#ArcCode').bind('change', function() {
		ArcValChange();
	});
	$('#ArcDesc').bind('change', function() {
		ArcValChange();
	});
	
	var OrdCatBox = $HUI.combobox('#OrdCatBox', {
		///url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrdCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			OrdSubCatBox.clear();
			var Params = JSON.stringify(addSessionParams({ BDPHospital: GetHospId() }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrdSubCat&ResultSetType=array&OrdCat=' + record.RowId + '&Params=' + Params;
			OrdSubCatBox.reload(url);
		},
		onShowPanel: function() {
			OrdCatBox.clear();
			var Params = JSON.stringify(addSessionParams({ BDPHospital: GetHospId() }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrdCat&ResultSetType=array&Params=' + Params;
			OrdCatBox.reload(url);
		}
	});
	var OrdSubCatBox = $HUI.combobox('#OrdSubCatBox', {
		valueField: 'RowId',
		textField: 'Description'
	});
	
	/*
	$HUI.lookup('#OrdCatBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetOrdCat',
			rows: 9999
		},
		onBeforeLoad: function(param) {
			param['Params'] = JSON.stringify(addSessionParams({
				BDPHospital: GetHospId()
			}));
		},
		onSelect: function(index, row) {
			$HUI.lookup('#OrdSubCatBox').setValue('');
			$HUI.lookup('#OrdSubCatBox').setText('');
		}
	});
	
	$HUI.lookup('#OrdSubCatBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetOrdSubCat',
			rows: 9999
		},
		onBeforeLoad: function(param) {
			var OrdCatId = $HUI.lookup('#OrdCatBox').getValue();
			OrdCatId = isEmpty(OrdCatId) ? '' : OrdCatId;
			param['OrdCat'] = OrdCatId;
			param['Params'] = JSON.stringify(addSessionParams({
				BDPHospital: GetHospId()
			}));
		}
	});
	*/
	
	var BillCatBox = $HUI.combobox('#BillCatBox', {
		// url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetBillCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			BillSubCatBox.clear();
			var Params = JSON.stringify(addSessionParams({ BDPHospital: GetHospId() }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetBillSubCat&ResultSetType=array&BillCat=' + record.RowId + '&Params=' + Params;
			BillSubCatBox.reload(url);
		},
		onShowPanel: function() {
			BillCatBox.clear();
			var Params = JSON.stringify(addSessionParams({ BDPHospital: GetHospId() }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetBillCat&ResultSetType=array&Params=' + Params;
			BillCatBox.reload(url);
		}
	});
	var BillSubCatBox = $HUI.combobox('#BillSubCatBox', {
		valueField: 'RowId',
		textField: 'Description'
	});
	/*
	$HUI.lookup('#BillCatBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetBillCat',
			rows: 9999
		},
		onBeforeLoad: function(param) {
			param['Params'] = JSON.stringify(addSessionParams({
				BDPHospital: GetHospId()
			}));
		},
		onSelect: function(index, row) {
			$HUI.lookup('#BillSubCatBox').setValue('');
			$HUI.lookup('#BillSubCatBox').setText('');
		}
	});
	$HUI.lookup('#BillSubCatBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetBillSubCat',
			rows: 9999
		},
		onBeforeLoad: function(param) {
			var BillCatId = $HUI.lookup('#BillCatBox').getValue();
			BillCatId = isEmpty(BillCatId) ? '' : BillCatId;
			param['BillCat'] = BillCatId;
			param['Params'] = JSON.stringify(addSessionParams({
				BDPHospital: GetHospId()
			}));
		}
	});
	*/
	$HUI.combobox('#BillUomBox', {
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var PriorityBox = $HUI.combobox('#PriorityBox', {
		// url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOECPriority&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			PriorityBox.clear();
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOECPriority&ResultSetType=array';
			PriorityBox.reload(url);
		}
	});
	/*
	$HUI.lookup('#PriorityBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetOECPriority',
			rows: 9999
		}
	});
	*/
	$UI.linkbutton('#ArcAliasBT', {
		onClick: function() {
			OrdAliasEdit();
		}
	});
	
	var TarSubCatBox = $HUI.combobox('#TarSubCatBox', {
		// url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarSubCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			TarSubCatBox.clear();
			var Params = JSON.stringify(addSessionParams({ BDPHospital: GetHospId() }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarSubCat&ResultSetType=array&Params=' + Params;
			TarSubCatBox.reload(url);
		}
	});
	var TarInpatCatBox = $HUI.combobox('#TarInpatCatBox', {
		// url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarInpatCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			TarInpatCatBox.clear();
			var Params = JSON.stringify(addSessionParams({ BDPHospital: GetHospId() }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarInpatCat&ResultSetType=array&Params=' + Params;
			TarInpatCatBox.reload(url);
		}
	});
	var TarOutpatCatBox = $HUI.combobox('#TarOutpatCatBox', {
		// url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarOutpatCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			TarOutpatCatBox.clear();
			var Params = JSON.stringify(addSessionParams({ BDPHospital: GetHospId() }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarOutpatCat&ResultSetType=array&Params=' + Params;
			TarOutpatCatBox.reload(url);
		}
	});
	var TarEMCCatBox = $HUI.combobox('#TarEMCCatBox', {
		// url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarEMCCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			TarEMCCatBox.clear();
			var Params = JSON.stringify(addSessionParams({ BDPHospital: GetHospId() }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarEMCCat&ResultSetType=array&Params=' + Params;
			TarEMCCatBox.reload(url);
		}
	});
	var TarAcctCatBox = $HUI.combobox('#TarAcctCatBox', {
		// url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarAcctCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			TarAcctCatBox.clear();
			var Params = JSON.stringify(addSessionParams({ BDPHospital: GetHospId() }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarAcctCat&ResultSetType=array&Params=' + Params;
			TarAcctCatBox.reload(url);
		}
	});
	var TarMRCatBox = $HUI.combobox('#TarMRCatBox', {
		// url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarMRCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			TarMRCatBox.clear();
			var Params = JSON.stringify(addSessionParams({ BDPHospital: GetHospId() }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarMRCat&ResultSetType=array&Params=' + Params;
			TarMRCatBox.reload(url);
		}
	});
	var TarNewMRCatBox = $HUI.combobox('#TarNewMRCatBox', {
		// url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarNewMRCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			TarNewMRCatBox.clear();
			var Params = JSON.stringify(addSessionParams({ BDPHospital: GetHospId() }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarNewMRCat&ResultSetType=array&Params=' + Params;
			TarNewMRCatBox.reload(url);
		}
	});
	
	// 不维护计费项
	$HUI.checkbox('#FeeFlag', {
		onChecked: function() {
			$UI.enableBlock('#TariData', false);
		},
		onUnchecked: function() {
			$UI.enableBlock('#TariData', true);
		}
	});
	/*
	$HUI.lookup('#TarSubCatBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetTarSubCat',
			rows: 9999
		}, onBeforeLoad: function(param) {
			param['Params'] = JSON.stringify(addSessionParams({
				BDPHospital: GetHospId()
			}));
		}
	});
	$HUI.lookup('#TarInpatCatBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetTarInpatCat',
			rows: 9999
		}, onBeforeLoad: function(param) {
			param['Params'] = JSON.stringify(addSessionParams({
				BDPHospital: GetHospId()
			}));
		}
	});
	$HUI.lookup('#TarOutpatCatBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetTarOutpatCat',
			rows: 9999
		}, onBeforeLoad: function(param) {
			param['Params'] = JSON.stringify(addSessionParams({
				BDPHospital: GetHospId()
			}));
		}
	});
	$HUI.lookup('#TarEMCCatBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetTarEMCCat',
			rows: 9999
		}, onBeforeLoad: function(param) {
			param['Params'] = JSON.stringify(addSessionParams({
				BDPHospital: GetHospId()
			}));
		}
	});
	$HUI.lookup('#TarAcctCatBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetTarAcctCat',
			rows: 9999
		}, onBeforeLoad: function(param) {
			param['Params'] = JSON.stringify(addSessionParams({
				BDPHospital: GetHospId()
			}));
		}
	});
	$HUI.lookup('#TarMRCatBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetTarMRCat',
			rows: 9999
		}, onBeforeLoad: function(param) {
			param['Params'] = JSON.stringify(addSessionParams({
				BDPHospital: GetHospId()
			}));
		}
	});
	$HUI.lookup('#TarNewMRCatBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetTarNewMRCat',
			rows: 9999
		}, onBeforeLoad: function(param) {
			param['Params'] = JSON.stringify(addSessionParams({
				BDPHospital: GetHospId()
			}));
		}
	});
	*/
};
$(InitDetailArcimPart);