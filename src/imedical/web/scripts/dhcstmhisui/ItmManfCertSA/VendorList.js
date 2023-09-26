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
				$UI.msg('alert', '��ѡ����!');
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
				$UI.msg('alert', '��ѡ��Ӧ����Ȩ����Ϣ!');
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
				title: "ע��֤��",
				field: 'CertNo',
				width: 150
			}, {
				title: "ע��֤Ч��",
				field: 'CertExpDate',
				width: 105
			}, {
				title: "һ����Ӧ��",
				field: 'VendorDesc1',
				width: 150
			}, {
				title: "һ����Ȩ��",
				field: 'Lic1',
				width: 100
			}, {
				title: "һ����ȨЧ��",
				field: 'LicExp1',
				width: 105
			}, {
				title: "������Ӧ��",
				field: 'VendorDesc2',
				width: 150
			}, {
				title: "������Ȩ��",
				field: 'Lic2',
				width: 100
			}, {
				title: "������ȨЧ��",
				field: 'LicExp2',
				width: 105
			}, {
				title: "������Ӧ��",
				field: 'VendorDesc3',
				width: 150
			}, {
				title: "������Ȩ��",
				field: 'Lic3',
				width: 100
			}, {
				title: "������ȨЧ��",
				field: 'LicExp3',
				width: 105
			}, {
				title: "�ļ���Ӧ��",
				field: 'VendorDesc4',
				width: 150
			}, {
				title: "�ļ���Ȩ��",
				field: 'Lic4',
				width: 100
			}, {
				title: "�ļ���ȨЧ��",
				field: 'LicExp4',
				width: 105
			}, {
				title: "�弶��Ӧ��",
				field: 'VendorDesc5',
				width: 150
			}, {
				title: "�弶��Ȩ��",
				field: 'Lic5',
				width: 100
			}, {
				title: "�弶��ȨЧ��",
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