var ItmListWin = function (SA,HospId) {
	$HUI.dialog('#ItmListWin').open();
	
	var VendorBox = $HUI.combobox('#Vendor', {
			valueField: 'RowId',
			textField: 'Description',
			onShowPanel: function(){
				var Params = JSON.stringify(addSessionParams({APCType: "M",RcFlag: "Y",BDPHospital:HospId}));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+Params;
				VendorBox.reload(url);
			}
		});

	var StkCatBox = $HUI.combobox('#StkCat', {
			valueField: 'RowId',
			textField: 'Description',
			onShowPanel: function () {
				var scg=$("#Scg").combotree('getValue');
				var Params=JSON.stringify(addSessionParams({BDPHospital:HospId}));
				StkCatBox.clear();
				var url=$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId=' + scg+'&Params='+Params;
				StkCatBox.reload(url);
			}
		});

	$UI.linkbutton('#SaveBT', {
		onClick: function () {
			var ItmDetail = ItmGrid.getChangesData("InciId");
			if (ItmDetail === false){	//未完成编辑或明细为空
				return;
			}
			if (isEmpty(ItmDetail)){	//明细不变
				$UI.msg("alert", "没有需要保存的明细!");
				return;
			}
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCItmManfCertSA',
				MethodName: 'SaveSAItm',
				SA: SA,
				Detail: JSON.stringify(ItmDetail)
			}, function (jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					Select(SA);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	$UI.linkbutton('#ChangeBT', {
		onClick: function () {
			var ItmDetail = ItmGrid.getChangesData();
			if (ItmDetail != "") {
				$UI.msg('alert', '存在未保存的物资明细,请先保存!');
				return;
			};
			var Rows = ItmGrid.getSelections();
			if (Rows.length <= 0) {
				$UI.msg('alert', '请选择要更换的物资明细!');
				return;
			}
			var ItmDetail = ItmGrid.getSelectedData();
			VendorListWin(SA,JSON.stringify(ItmDetail),Select);
		}
	});

	var HandlerParams = function () {
		var Scg = $("#Scg").combotree('getValue');
		var StkCat = $("#StkCat").combo('getValue');
		var Vendor = $("#Vendor").combo('getValue');
		var Obj = {
			StkGrpRowId: Scg,
			StkGrpType: "M",
			StkCat: StkCat,
			Vendor: Vendor,
			BDPHospital:HospId
		};
		return Obj;
	};

	var SelectRow = function (row) {
		ItmGrid.updateRow({
			index:ItmGrid.editIndex,
			row: {
				InciId:row.InciDr,
				InciCode:row.InciCode,
				InciDesc:row.InciDesc,
				Spec:row.Spec,
				UomDesc:row.PUomDesc,
				Rp:row.PRp,
			    Sp:row.PSp
			}
		});
		setTimeout(function () {
			ItmGrid.refreshRow();
			ItmGrid.startEditingNext('InciDesc');
		}, 0);
	};

	var ItmCm = [[{
				field: 'ck',
				checkbox: true
			}, {
				title: "RowId",
				field: 'RowId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: '物资Id',
				field: 'InciId',
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
			}, {
				title: '单位',
				field: 'UomDesc',
				width: 100
			}, {
				title: '进价',
				field: 'Rp',
				width: 100,
				align: 'right'
			}, {
				title: '售价',
				field: 'Sp',
				width: 100,
				align: 'right'
			}
		]];

	var ItmGrid = $UI.datagrid('#ItmGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCItmManfCertSA',
				QueryName: 'SAItmList'
			},
			deleteRowParams: {
				ClassName: 'web.DHCSTMHUI.DHCItmManfCertSA',
				MethodName: 'DeleteSAItmList'
			},
			columns: ItmCm,
			fitColumns: true,
			singleSelect: false,
			showAddDelItems: true,
			onClickCell: function (index, field, value) {
				ItmGrid.commonClickCell(index, field);
			}
		});

	function Select(SA) {
		$UI.clearBlock('#FindConditions');
		$UI.clear(ItmGrid);
		ItmGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCItmManfCertSA',
			QueryName: 'SAItmList',
			SA: SA
		});
	}
	Select(SA);
};