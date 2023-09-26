var GRMainCm, GRMainGrid;
var init = function () {
	var IngrLocParams = JSON.stringify(addSessionParams({
				Type: 'Login'
			}));
	var IngrLocBox = $HUI.combobox('#IngrLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + IngrLocParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	var VendorParams = JSON.stringify(addSessionParams({
				APCType: "M",
				RcFlag: "Y"
			}));
	var VendorBox = $HUI.combobox('#Vendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	$UI.linkbutton('#AddBT',{
		onClick:function(){
			var RowId = $('#RowId').val();
			if (isEmpty(RowId)) {
				$UI.msg('alert', '请先制一个付款封面!');
				return;
			}
			var Rows = GRMainGrid.getSelections();
			if (Rows.length <= 0) {
				$UI.msg('alert', '请选择要增加的单据!');
				return;
			}
			var ParamsObj = $CommonUI.loopBlock('#MainConditions');
			var Main = JSON.stringify(ParamsObj);
			var Detail = GRMainGrid.getSelectedData();
			$.cm({
				ClassName: 'web.DHCSTMHUI.PayCover',
				MethodName: 'Update',
				Main: Main,
				Detail: JSON.stringify(Detail)
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					$('#RowId').val(jsonData.rowid);
					$UI.clear(GRMainGrid);
					GRMainGrid.commonReload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	$UI.linkbutton('#SaveBT',{
		onClick:function(){
			var Rows = GRMainGrid.getSelections();
			if (Rows.length <= 0) {
				$UI.msg('alert', '请选择要保存的单据!');
				return;
			}
			var ParamsObj = $CommonUI.loopBlock('#MainConditions');
			var Main = JSON.stringify(ParamsObj);
			var Detail = GRMainGrid.getSelectedData();
			$.cm({
				ClassName: 'web.DHCSTMHUI.PayCover',
				MethodName: 'Save',
				Main: Main,
				Detail: JSON.stringify(Detail)
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					$('#RowId').val(jsonData.rowid);
					$UI.clear(GRMainGrid);
					GRMainGrid.commonReload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	GRMainCm = [[{
				field: 'ck',
				checkbox: true
			}, {
				title: "RowId",
				field: 'RowId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: "供应商",
				field: 'VendorDesc',
				width: 150
			}, {
				title: "单号",
				field: 'GRNo',
				width: 150
			}, {
				title: "类型",
				field: 'Type',
				saveCol: true,
				width: 60,
				formatter: function (value, row, index) {
					if (value == "G") {
						return "入库";
					} else {
						return "退货";
					}
				}
			}, {
				title: "接收科室",
				field: 'ReqLocDesc',
				width: 100
			}, {
				title: "类组",
				field: 'ScgDesc',
				width: 100
			}, {
				title: "数量",
				field: 'Qty',
				width: 80,
				align: 'right'
			}, {
				title: "进价金额",
				field: 'RpAmt',
				width: 80,
				align: 'right'
			}, {
				title: "售价金额",
				field: 'SpAmt',
				width: 80,
				align: 'right'
			}, {
				title: "制单人",
				field: 'CreateUser',
				width: 80
			}, {
				title: "制单日期",
				field: 'CreateDate',
				width: 80
			}, {
				title: "审核人",
				field: 'AuditUser',
				width: 80
			}, {
				title: "审核日期",
				field: 'AuditDate',
				width: 80
			}
		]];

	GRMainGrid = $UI.datagrid('#GRMainGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.PayCover',
				QueryName: 'RecListQuery',
				rows: 99999
			},
			columns: GRMainCm,
			singleSelect: false,
			pagination: false,
			onCheck: function (Index, Row) {
				SetTotal();
			},
			onUncheck: function (Index, Row) {
				SetTotal();
			},
			onCheckAll: function (rows) {
				SetTotal();
			},
			onUncheckAll: function (rows) {
				$('#QtyAmt').text(0);
				$('#RpAmt').text(0);
			}
		});

	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#MainConditions');
			if (isEmpty(ParamsObj.StartDate)) {
				$UI.msg('alert', '起始日期不能为空!');
				return;
			}
			if (isEmpty(ParamsObj.EndDate)) {
				$UI.msg('alert', '截止日期不能为空!');
				return;
			}
			if (isEmpty(ParamsObj.IngrLoc)) {
				$UI.msg('alert', '入库科室不能为空!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			GRMainGrid.load({
				ClassName: 'web.DHCSTMHUI.PayCover',
				QueryName: 'RecListQuery',
				Params: Params,
				rows: 99999
			});
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			$UI.clearBlock('#MainConditions');
			$UI.clear(GRMainGrid);
			SetDefaValues();
		}
	});

	SetDefaValues();
	$('#QtyAmt').text(0);
	$('#RpAmt').text(0);
}
$(init);
function SetTotal() {
	var TotalQty = 0;
	var TotalAmt = 0;
	var Rows = GRMainGrid.getChecked();
	for (var i = 0; i < Rows.length; i++) {
		var Qty = Rows[i].Qty;
		var RpAmt = Rows[i].RpAmt;
		TotalQty = Number(TotalQty) + Number(Qty);
		TotalAmt = Number(TotalAmt) + Number(RpAmt);
	}
	$('#QtyAmt').text(TotalQty);
	$('#RpAmt').text(TotalAmt);
}
