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
				title: "单号",
				field: 'GRNo',
				width: 150
			}, {
				title: "供应商",
				field: 'VendorDesc',
				width: 100
			}, {
				title: "类型",
				field: 'Type',
				width: 70,
				saveCol: true,
				formatter: function (value, row, index) {
					if (value == "G") {
						return "入库";
					} else {
						return "退货";
					}
				}
			}, {
				title: "进价金额",
				field: 'RpAmt',
				width: 100,
				align: 'right'
			}, {
				title: "售价金额",
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
				title: "代码",
				field: 'Code',
				width: 120
			}, {
				title: "描述",
				field: 'Description',
				width: 150
			}, {
				title: "规格",
				field: 'Spec',
				width: 100
			}, {
				title: "数量",
				field: 'Qty',
				width: 100,
				align: 'right'
			}, {
				title: "单位",
				field: 'UomDesc',
				width: 80
			}, {
				title: "进价",
				field: 'Rp',
				width: 100,
				align: 'right'
			}, {
				title: "进价金额",
				field: 'RpAmt',
				width: 100,
				saveCol: true,
				align: 'right'
			}, {
				title: "售价",
				field: 'Sp',
				width: 100,
				align: 'right'
			}, {
				title: "售价金额",
				field: 'SpAmt',
				width: 100,
				saveCol: true,
				align: 'right'
			}, {
				title: "厂商",
				field: 'Manf',
				width: 100
			}, {
				title: "类型",
				field: 'Type',
				align: 'center',
				saveCol: true,
				formatter: function (value, row, index) {
					if (value == "G") {
						return "入库";
					} else {
						return "退货";
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
				$UI.msg('alert','起始日期不能为空!');
				return;
			}
			if (isEmpty(ParamsObj.EndDate)) {
				$UI.msg('alert','截止日期不能为空!');
				return;
			}
			if (isEmpty(ParamsObj.Vendor)) {
				$UI.msg('alert','供应商不能为空!');
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
				$UI.msg('alert','请选择要组合的入库退货单明细!');
				return;
			}
			var TotalAmt = $('#TotalRpAmt').val();
			if (TotalAmt==""||TotalAmt==0){
				$UI.msg('alert','组合的入库退货单进价总额为零!');
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
