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
				$UI.msg('alert', '��ѡ����ļ�¼');
				return false;
			}
			if (isEmpty(Incid)) {
				$UI.msg('alert', '��ѡ����ѡ�����ʼ�¼');
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
			title: '��Ӧ��Id',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '��Ӧ�̴���',
			field: 'Code',
			width: 150
		}, {
			title: '��Ӧ������',
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