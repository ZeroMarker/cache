var UAuItmListWin = function(VendId, fn, HospId) {
	$HUI.dialog('#UAuItmListWin', { width: gWinWidth, height: gWinHeight }).open();
	UnInciClear();
	
	var WinStkCatBox = $HUI.combobox('#WinStkCatBox', {
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			var scg = $('#WinStkGrpBox').combotree('getValue');
			var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			WinStkCatBox.clear();
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId=' + scg + '&Params=' + Params;
			WinStkCatBox.reload(url);
		}
	});

	$UI.linkbutton('#InciAuthorBT', {
		onClick: function() {
			var ItmDetail = ItmGrid.getSelections();
			if (isEmpty(ItmDetail)) {
				$UI.msg('alert', '请选择处理的记录');
				return false;
			}
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.VenIncitm',
				MethodName: 'Save',
				Venid: VendId,
				InciObj: JSON.stringify(ItmDetail)
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					fn(VendId);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
			close();
		}
	});

	$UI.linkbutton('#CancelBT', {
		onClick: function() {
			close();
		}
	});
	function UAuInciQuery() {
		var SessionParmas = addSessionParams({ BDPHospital: HospId });
		var Paramsobj = $UI.loopBlock('#UAuItmListConditions');
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		$UI.clear(ItmGrid);
		ItmGrid.load({
			ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
			QueryName: 'GetItm',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#UAuInciQueryBT', {
		onClick: function() {
			UAuInciQuery();
		}
	});

	var HandlerParams = function() {
		var Scg = $('#Scg').combotree('getValue');
		var StkCat = $('#StkCat').combo('getValue');
		var Vendor = $('#Vendor').combo('getValue');
		var Obj = {
			StkGrpRowId: Scg,
			StkGrpType: 'M',
			StkCat: StkCat,
			Vendor: Vendor,
			BDPHospital: HospId
		};
		return Obj;
	};

	var SelectRow = function(row) {
		ItmGrid.updateRow({
			index: ItmGrid.editIndex,
			row: {
				InciId: row.InciDr,
				InciCode: row.InciCode,
				InciDesc: row.InciDesc,
				Spec: row.Spec
			}
		});
		setTimeout(function() {
			ItmGrid.refreshRow();
			ItmGrid.startEditingNext('InciDesc');
		}, 0);
	};

	var ItmCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: '物资Id',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 150
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 200,
			editor: InciEditor(HandlerParams, SelectRow)
		}, {
			title: '规格',
			field: 'Spec',
			width: 150
		}
	]];

	var ItmGrid = $UI.datagrid('#ItmGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
			QueryName: 'GetItm',
			query2JsonStrict: 1
		},
		columns: ItmCm,
		fitColumns: true,
		singleSelect: false
	});
	function close() {
		$HUI.dialog('#UAuItmListWin').close();
	}
	function UnInciClear() {
		$UI.clearBlock('#UAuItmListConditions');
	}
};