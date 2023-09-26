var InvDetailWin = function (IngrLoc, Fn) {
	$HUI.dialog('#InvDetailWin').open();

	var FVVendorParams = JSON.stringify(addSessionParams({
				APCType: "M",
				RcFlag: "Y"
			}));
	var FVVendorBox = $HUI.combobox('#FVVendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FVVendorParams,
			valueField: 'RowId',
			textField: 'Description'
		});

	var GRMainCm = [[{
				field: 'ck',
				checkbox: true
			}, {
				title: "RowId",
				field: 'RowId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: "����",
				field: 'GRNo',
				width: 150
			}, {
				title: "��Ӧ��",
				field: 'VendorDesc',
				width: 100
			}, {
				title: "����",
				field: 'Type',
				width: 70,
				saveCol: true,
				formatter: function (value, row, index) {
					if (value == "G") {
						return "���";
					} else {
						return "�˻�";
					}
				}
			}, {
				title: "���۽��",
				field: 'RpAmt',
				width: 100,
				align: 'right'
			}, {
				title: "�ۼ۽��",
				field: 'SpAmt',
				width: 100,
				align: 'right'
			}
		]];

	var GRMainGrid = $UI.datagrid('#GRMainGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				QueryName: 'GetIngdRec'
			},
			columns: GRMainCm,
			singleSelect: false,
			onCheck: function (index, row) {
				Select();
			},
			onUncheck: function (index, Row){
				Select();
			},
			onCheckAll: function(rows){
				Select();
			},
			onUncheckAll: function(rows){
				$UI.clear(GRDetailGrid);
				$('#TotalRpAmt').val('');
			},
			onLoadSuccess: function (data) {
				if (data.rows.length > 0) {
					GRMainGrid.selectRow(0);
					Select();
				}
			}
		});

	var GRDetailCm = [[{
				field: 'ck',
				checkbox: true
			}, {
				title: "RowId",
				field: 'RowId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: "IncId",
				field: 'IncId',
				width: 50,
				hidden: true
			}, {
				title: "����",
				field: 'Code',
				width: 120
			}, {
				title: "����",
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
				saveCol: true,
				align: 'right'
			}, {
				title: "�ۼ�",
				field: 'Sp',
				width: 100,
				align: 'right'
			}, {
				title: "�ۼ۽��",
				field: 'SpAmt',
				width: 100,
				saveCol: true,
				align: 'right'
			}, {
				title: "����",
				field: 'Manf',
				width: 100
			}, {
				title: "����",
				field: 'Type',
				align: 'center',
				saveCol: true,
				formatter: function (value, row, index) {
					if (value == "G") {
						return "���";
					} else {
						return "�˻�";
					}
				}
			}
		]];

	var GRDetailGrid = $UI.datagrid('#GRDetailGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				QueryName: 'GetIngdRecItm'
			},
			columns: GRDetailCm,
			singleSelect: false,
			onCheck: function (index, row) {
				TotalAmt();
			},
			onUncheck: function (index, Row){
				TotalAmt();
			},
			onCheckAll: function(rows){
				TotalAmt();
			},
			onUncheckAll: function(rows){
				$('#TotalRpAmt').val('');
			}
		});

	$UI.linkbutton('#FVQueryBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#FVConditions');
			if (isEmpty(ParamsObj.StartDate)) {
				$UI.msg('alert','��ʼ���ڲ���Ϊ��!');
				return;
			}
			if (isEmpty(ParamsObj.EndDate)) {
				$UI.msg('alert','��ֹ���ڲ���Ϊ��!');
				return;
			}
			if (isEmpty(ParamsObj.Vendor)) {
				$UI.msg('alert','��Ӧ�̲���Ϊ��!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			$UI.clear(GRMainGrid);
			$UI.clear(GRDetailGrid);
			GRMainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				QueryName: 'GetIngdRec',
				LocId: IngrLoc,
				Params: Params
			});
		}
	});

	$UI.linkbutton('#FVSaveBT', {
		onClick: function () {
			var Rows = GRDetailGrid.getSelections();
			if (Rows.length <= 0) {
				$UI.msg('alert','��ѡ��Ҫ��ϵ�����˻�����ϸ!');
				return;
			}
			var TotalAmt = $('#TotalRpAmt').val();
			if (TotalAmt==""||TotalAmt==0){
				$UI.msg('alert','��ϵ�����˻��������ܶ�Ϊ��!');
				return;
			}
			var ParamsObj = $UI.loopBlock('#FVConditions');
			var Main = JSON.stringify(ParamsObj);
			var Detail = GRDetailGrid.getSelectedData();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				MethodName: 'SaveByItm',
				LocId: IngrLoc,
				Main: Main,
				Detail: JSON.stringify(Detail)
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$HUI.dialog('#InvDetailWin').close();
					Fn(jsonData.rowid);
				}else{
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	$UI.linkbutton('#FVClearBT', {
		onClick: function () {
			Clear();
		}
	});
	
	function Select(){
		var Rows = GRMainGrid.getSelections();
		if (Rows.length <= 0) {
			$UI.clear(GRDetailGrid);
			return;
		}
		var Params = GRMainGrid.getSelectedData();
		GRDetailGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			QueryName: 'GetIngdRecItm',
			Params: JSON.stringify(Params)
		});
	}
	
	function Clear() {
		$UI.clearBlock('#FVConditions');
		$UI.clear(GRMainGrid);
		$UI.clear(GRDetailGrid);
		var Dafult = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate()
		}
		$UI.fillBlock('#FVConditions', Dafult);
	}
	
	function TotalAmt(){
		var TotalAmt = 0;
		var Rows = GRDetailGrid.getChecked();
		for (var i = 0; i < Rows.length; i++) {
			var RpAmt = Rows[i].RpAmt;
			TotalAmt = Number(TotalAmt) + Number(RpAmt);
		}
		$('#TotalRpAmt').val(TotalAmt);
	}
	
	Clear();
}
