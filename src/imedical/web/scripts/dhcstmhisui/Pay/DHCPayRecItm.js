var FindPayWin = function (IngrLoc, PayId, Fn) {
	$HUI.dialog('#FindPayWin').open();
	var FPVendorParams = JSON.stringify(addSessionParams({
				APCType: "M",
				RcFlag: "Y"
			}));
	var FPVendorBox = $HUI.combobox('#FPVendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FPVendorParams,
			valueField: 'RowId',
			textField: 'Description'
		});

	var PayModeBox = $HUI.combobox('#PayMode', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPayMode&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description'
		});

	$UI.linkbutton('#FPQueryBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#FindPayConditions');
			if (isEmpty(ParamsObj.FPStartDate)) {
				$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
				return;
			}
			if (isEmpty(ParamsObj.FPEndDate)) {
				$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			$UI.clear(VendorGrid);
			$UI.clear(ToPayGrid);
			VendorGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCPay',
				QueryName: 'VendorListToPay',
				LocId: IngrLoc,
				Params: Params
			});
		}
	});

	$UI.linkbutton('#FPSaveBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#FindPayConditions');
			var Rows = ToPayGrid.getSelections();
			if (Rows.length <= 0) {
				$UI.msg('alert', '��ѡ��Ҫ�����Ӧ������!');
				return;
			}
			var Vendor = VendorGrid.getSelected().RowId;
			var Main = JSON.stringify(ParamsObj);
			var Detail = ToPayGrid.getSelectedData();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCPay',
				MethodName: 'Save',
				PayId: PayId,
				LocId: IngrLoc,
				Vendor: Vendor,
				Main: Main,
				Detail: JSON.stringify(Detail)
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					$HUI.dialog('#FindPayWin').close();
					Fn(jsonData.rowid);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	$UI.linkbutton('#FPClearBT', {
		onClick: function () {
			Clear();
		}
	});

	var VendorCm = [[{
				title: 'RowId',
				field: 'RowId',
				width: 50,
				hidden: true
			}, {
				title: '��Ӧ��',
				field: 'VendorDesc',
				width: 150
			}
		]];
	var VendorGrid = $UI.datagrid('#VendorGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCPay',
				QueryName: 'VendorListToPay'
			},
			columns: VendorCm,
			pagination: false,
			onSelect: function (Index, Row) {
				$('#TotalAmt').val("");
				var ParamsObj = $UI.loopBlock('#FindPayConditions');
				var Params = JSON.stringify(ParamsObj);
				ToPayGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCPay',
					QueryName: 'GetItmToPay',
					LocId: IngrLoc,
					Vendor: Row.RowId,
					Params: Params,
					rows: 9999
				});
				ToPayGrid.clearChecked();
			},
			onLoadSuccess: function (data) {
				if (data.rows.length > 0) {
					VendorGrid.selectRow(0);
				}
			}
		});

	var ToPayCm = [[{
				field: 'ck',
				checkbox: true
			}, {
				title: "RowId",
				field: 'RowId',
				width: 50,
				hidden: true,
				saveCol: true
			}, {
				title: "����",
				field: 'No',
				width: 100
			}, {
				title: "����",
				field: 'Type',
				width: 50,
				saveCol: true,
				formatter: function (value, row, index) {
					if (value == "G") {
						return "���";
					} else {
						return "�˻�";
					}
				}
			}, {
				title: "������",
				field: 'PayAmt',
				width: 100,
				align: 'right',
				saveCol: true,
				editor: {
					type: 'numberbox'
				}
			}, {
				title: "����",
				field: 'Date',
				width: 90,
				align: 'right'
			}, {
				title: "ʱ��",
				field: 'Time',
				width: 80,
				align: 'right'
			}, {
				title: "�����",
				field: 'UserName',
				width: 70
			}, {
				title: "Inci",
				field: 'Inci',
				width: 50,
				hidden: true,
				saveCol: true
			}, {
				title: "���ʴ���",
				field: 'Code',
				width: 120
			}, {
				title: "��������",
				field: 'Description',
				width: 150
			}, {
				title: "���",
				field: 'Spec',
				width: 100
			}, {
				title: "����",
				field: 'Qty',
				width: 100,
				align: 'right'
			}, {
				title: "��λ",
				field: 'UomDesc',
				width: 80
			}, {
				title: "����",
				field: 'Rp',
				width: 100,
				align: 'right'
			}, {
				title: "���۽��",
				field: 'RpAmt',
				width: 100,
				align: 'right',
				saveCol: true
			}, {
				title: "�ۼ�",
				field: 'Sp',
				width: 100,
				align: 'right'
			}, {
				title: "�ۼ۽��",
				field: 'SpAmt',
				width: 100,
				align: 'right'
			}, {
				title: "����",
				field: 'Manf',
				width: 100
			}, {
				title: "�Ѹ����",
				field: 'PayedAmt',
				width: 100,
				align: 'right'
			}, {
				title: "�������",
				field: 'RestAmt',
				width: 100,
				align: 'right'
			}, {
				title: "��Ʊ��",
				field: 'InvNo',
				width: 100
			}, {
				title: "��Ʊ����",
				field: 'InvDate',
				width: 100
			}, {
				title: "��Ʊ���",
				field: 'InvAmt',
				width: 100,
				align: 'right'
			}, {
				title: "���е���",
				field: 'InsxNo',
				width: 100
			}, {
				title: "����",
				field: 'BatNo',
				width: 100
			}, {
				title: "Ч��",
				field: 'ExpDate',
				width: 100
			}
		]];

	var ToPayGrid = $UI.datagrid('#ToPayGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCPay',
				QueryName: 'GetItmToPay'
			},
			columns: ToPayCm,
			singleSelect: false,
			onClickCell: function (index, filed, value) {
				ToPayGrid.commonClickCell(index, filed)
			},
			onCheck: function (Index, Row) {
				TotalAmt();
			},
			onUncheck: function (Index, Row) {
				TotalAmt();
			},
			onCheckAll: function (rows) {
				TotalAmt();
			},
			onUncheckAll: function (rows) {
				$('#TotalAmt').val('');
			}
		});

	function Clear() {
		$('#TotalAmt').val("");
		$UI.clearBlock('#FindPayConditions');
		$UI.clear(VendorGrid);
		$UI.clear(ToPayGrid);
		var Dafult = {
			FPStartDate: DefaultStDate(),
			FPEndDate: DefaultEdDate(),
		}
		$UI.fillBlock('#FindPayConditions', Dafult)
	}

	function TotalAmt() {
		var PayRatio = $('#PayRatio').val();
		if ((Number(PayRatio) > 1) || (Number(PayRatio) < 0)) {
			$UI.msg('alert', 'Ԥ�����������0С�ڵ���1!')
			return;
		}
		if ((Number(PayRatio) <= 1) && (Number(PayRatio) > 0)) {
			PayRatio = Number(PayRatio);
		} else {
			PayRatio = 1;
		}
		var TotalAmt = 0;
		var Rows = ToPayGrid.getChecked();
		for (var i = 0; i < Rows.length; i++) {
			var PayAmt = Rows[i].PayAmt;
			PayAmt = Number(PayAmt) * PayRatio;
			TotalAmt = Number(TotalAmt) + PayAmt;
		}
		$('#TotalAmt').val(TotalAmt);
	}
	$('#PayRatio').keydown(function (e) {
		if (e.keyCode == 13) {
			var PayRatio = $('#PayRatio').val();
			if (PayRatio == null || PayRatio == "") {
				$UI.msg('alert', 'Ԥ������Ϊ��!')
				return;
			}
			TotalAmt();
		}
	});

	Clear();
}
