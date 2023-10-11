var UAuVenListWin = function(Incid, fn, HospId) {
	$HUI.dialog('#UAuVenListWin', { width: gWinWidth, height: gWinHeight }).open();
	UnVenClear();
	var WinVendorCat = $HUI.combobox('#WinVendorCat', {
		// url: $URL + '?ClassName=web.DHCSTMHUI.APCVendCat&QueryName=GetVendorCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.APCVendCat&QueryName=GetVendorCat&ResultSetType=array&Params=' + Params;
			WinVendorCat.reload(url);
		}
	});
	$UI.linkbutton('#VenAuthorBT', {
		onClick: function() {
			var ItmDetail = VenItmGrid.getSelections();
			if (isEmpty(ItmDetail)) {
				$UI.msg('alert', '请选择处理的记录');
				return false;
			}
			if (isEmpty(Incid)) {
				$UI.msg('alert', '请选择先选择物资记录');
				return false;
			}
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.VenIncitm',
				MethodName: 'AddInciVendor',
				Incid: Incid,
				VenObj: JSON.stringify(ItmDetail)
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					fn(Incid);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
			close();
		}
	});

	$UI.linkbutton('#VenCancelBT', {
		onClick: function() {
			close();
		}
	});
	function UAuVenQueryBT() {
		var SessionParmas = addSessionParams({ BDPHospital: HospId });
		var Paramsobj = $UI.loopBlock('#UAuVenListConditions');
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		$UI.clear(VenItmGrid);
		VenItmGrid.load({
			ClassName: 'web.DHCSTMHUI.VenIncitm',
			QueryName: 'GetUnInciApc',
			query2JsonStrict: 1,
			Inci: Incid,
			Params: Params
		});
	}
	$UI.linkbutton('#UAuVenQueryBT', {
		onClick: function() {
			UAuVenQueryBT();
		}
	});
	var VenItmCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: '供应商Id',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '供应商代码',
			field: 'Code',
			width: 150
		}, {
			title: '供应商名称',
			field: 'Name',
			width: 200
		}
	]];

	var VenItmGrid = $UI.datagrid('#VenItmGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.VenIncitm',
			QueryName: 'GetUnInciApc',
			query2JsonStrict: 1
		},
		columns: VenItmCm,
		fitColumns: true,
		singleSelect: false
	});
	function close() {
		$HUI.dialog('#UAuVenListWin').close();
	}
	function UnVenClear() {
		$UI.clearBlock('#UAuVenListConditions');
	}
};