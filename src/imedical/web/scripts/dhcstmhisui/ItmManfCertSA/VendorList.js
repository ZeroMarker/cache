var VendorListWin = function (OldSA, ItmDetail, Fn) {
	$UI.clearBlock('#Conditions');
	$UI.clear(VendorGrid);
	$HUI.dialog('#VendorListWin').open();

	var ManfParams = JSON.stringify(addSessionParams({}));
	var Manf = $HUI.combobox('#FManf', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + ManfParams,
			valueField: 'RowId',
			textField: 'Description'
		});

	var VendorParams = JSON.stringify(addSessionParams({
				APCType: "M",
				RcFlag: "Y"
			}));
	var VendorBox = $HUI.combobox('#FVendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
			valueField: 'RowId',
			textField: 'Description'
		});

	$UI.linkbutton('#FQueryBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#Conditions');
			if (isEmpty(ParamsObj.Manf)) {
				$UI.msg('alert', '请选择厂商!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			VendorGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCItmManfCertSA',
				QueryName: 'SAByManf',
				Params: Params
			});
		}
	});

	$UI.linkbutton('#FChangeBT', {
		onClick: function () {
			var RowData = VendorGrid.getSelected();
			if (RowData == null || RowData == "") {
				$UI.msg('alert', '请选择供应商授权链信息!');
				return;
			}
			var SA = RowData.RowId;
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCItmManfCertSA',
				MethodName: 'SaveSAItm',
				SA: SA,
				Detail: ItmDetail
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					$HUI.dialog('#VendorListWin').close();
					Fn(OldSA);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	var VendorCm = [[{
				title: "RowId",
				field: 'RowId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: "注册证号",
				field: 'CertNo',
				width: 150
			}, {
				title: "注册证效期",
				field: 'CertExpDate',
				width: 105
			}, {
				title: "一级供应商",
				field: 'VendorDesc1',
				width: 150
			}, {
				title: "一级授权书",
				field: 'Lic1',
				width: 100
			}, {
				title: "一级授权效期",
				field: 'LicExp1',
				width: 105
			}, {
				title: "二级供应商",
				field: 'VendorDesc2',
				width: 150
			}, {
				title: "二级授权书",
				field: 'Lic2',
				width: 100
			}, {
				title: "二级授权效期",
				field: 'LicExp2',
				width: 105
			}, {
				title: "三级供应商",
				field: 'VendorDesc3',
				width: 150
			}, {
				title: "三级授权书",
				field: 'Lic3',
				width: 100
			}, {
				title: "三级授权效期",
				field: 'LicExp3',
				width: 105
			}, {
				title: "四级供应商",
				field: 'VendorDesc4',
				width: 150
			}, {
				title: "四级授权书",
				field: 'Lic4',
				width: 100
			}, {
				title: "四级授权效期",
				field: 'LicExp4',
				width: 105
			}, {
				title: "五级供应商",
				field: 'VendorDesc5',
				width: 150
			}, {
				title: "五级授权书",
				field: 'Lic5',
				width: 100
			}, {
				title: "五级授权效期",
				field: 'LicExp5',
				width: 105
			}
		]];

	var VendorGrid = $UI.datagrid('#VendorGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCItmManfCertSA',
				QueryName: 'SAByManf'
			},
			columns: VendorCm
		});
};