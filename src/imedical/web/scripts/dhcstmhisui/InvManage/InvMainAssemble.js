var InvMainWin = function (IngrLoc, Fn) {
	$HUI.dialog('#InvMainWin').open();

	var FVMVendorParams = JSON.stringify(addSessionParams({
				APCType: "M",
				RcFlag: "Y"
			}));
	var FVMVendorBox = $HUI.combobox('#FVMVendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FVMVendorParams,
			valueField: 'RowId',
			textField: 'Description'
		});

	var GRMCm = [[{
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
				width: 200
			}, {
				title: "供应商",
				field: 'VendorDesc',
				width: 200
			}, {
				title: "类型",
				field: 'Type',
				width: 100,
				saveCol: true,
				formatter: function(value,row,index){
					if (value=="G"){
						return "入库";
					} else {
						return "退货";
					}
				}
			}, {
				title: "进价金额",
				field: 'RpAmt',
				width: 150,
				align: 'right'
			}, {
				title: "售价金额",
				field: 'SpAmt',
				width: 150,
				align: 'right'
			}
		]];

	var GRMGrid = $UI.datagrid('#GRMGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				QueryName: 'GetIngdRec'
			},
			columns: GRMCm,
			singleSelect: false,
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

	$UI.linkbutton('#FVMQueryBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#FVMConditions');
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
			GRMGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				QueryName: 'GetIngdRec',
				LocId: IngrLoc,
				Params: Params
			});
		}
	});
	
	$UI.linkbutton('#FVMSaveBT', {
		onClick: function () {
			var Rows = GRMGrid.getSelections();
			if (Rows.length <= 0) {
				$UI.msg('alert','请选择要组合的入库退货单!');
				return;
			}
			var TotalAmt = $('#TotalAmt').val();
			if (TotalAmt==""||TotalAmt==0){
				$UI.msg('alert','组合的入库退货单进价总额为零!');
				return;
			}
			var ParamsObj = $UI.loopBlock('#FVMConditions');
			var Main = JSON.stringify(ParamsObj);
			var Detail = GRMGrid.getSelectedData();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				MethodName: 'Save',
				LocId: IngrLoc,
				Main: Main,
				Detail: JSON.stringify(Detail)
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					Fn(jsonData.rowid);
					$HUI.dialog('#InvMainWin').close();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
			
		}
	});
	
	$UI.linkbutton('#FVMClearBT', {
		onClick: function () {
			Clear();
		}
	});

	function Clear() {
		$UI.clearBlock('#FVMConditions');
		$UI.clear(GRMGrid);
		var Dafult = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
		}
		$UI.fillBlock('#FVMConditions', Dafult);
	}
	
	function TotalAmt() {
		var TotalAmt = 0;
		var Rows = GRMGrid.getChecked();
		for (var i = 0; i < Rows.length; i++) {
			var RpAmt = Rows[i].RpAmt;
			TotalAmt = Number(TotalAmt) + Number(RpAmt);
		}
		$('#TotalAmt').val(TotalAmt);
	}

	Clear();
}