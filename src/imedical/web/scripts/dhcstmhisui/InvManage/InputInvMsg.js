var ToolBar, InvMainCm, InvDetailCm, InvMainGrid, InvDetailGrid;
var IsOneRow = 1;
var init = function () {
	var VendorParams = JSON.stringify(addSessionParams({
				APCType: "M",
				RcFlag: "Y"
			}));
	var VendorBox = $HUI.combobox('#Vendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
			valueField: 'RowId',
			textField: 'Description'
		});

	ToolBar = [{
			text: '保存',
			iconCls: 'icon-save',
			handler: function () {
				var Rows = InvMainGrid.getChangesData();
				if (Rows === false){	//未完成编辑或明细为空
					return;
				}
				if (isEmpty(Rows)){	//明细不变
					$UI.msg("alert", "没有需要保存的明细!");
					return;
				}
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCVendorInv',
					MethodName: 'SaveInvNo',
					Params: JSON.stringify(Rows)
				}, function (jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						Select();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}
	];

	InvMainCm = [[{
				title: "RowId",
				field: 'RowId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: "操作",
				field: 'Icon',
				width: 50,
				align: 'center',
				formatter: function (value, row, index) {
					var str = "<a href='#' onclick='Print(" + row.RowId + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/print.png' title='打印' border='0'></a>";
					return str;
				}
			}, {
				title: "组合单号",
				field: 'AssemNo',
				width: 180
			}, {
				title: "Vendor",
				field: 'Vendor',
				width: 50,
				hidden: true
			}, {
				title: "供应商",
				field: 'VendorDesc',
				width: 180
			}, {
				title: "制单人",
				field: 'CreateUser',
				width: 80
			}, {
				title: "制单日期",
				field: 'CreateDate',
				width: 100
			}, {
				title: "制单时间",
				field: 'CreateTime',
				width: 80
			}, {
				title: "组合进价",
				field: 'RpAmt',
				width: 80,
				align: 'right'
			}, {
				title: "发票号",
				field: 'InvNo',
				width: 120,
				saveCol: true,
				editor: {
					type: 'text',
					options: {}
				}
			}, {
				title: "发票金额",
				field: 'InvRpAmt',
				width: 80,
				align: 'right',
				saveCol: true,
				editor: {
					type: 'numberbox',
					options: {}
				}
			}, {
				title: "发票日期",
				field: 'InvDate',
				width: 100,
				saveCol: true,
				editor: {
					type: 'datebox',
					options: {}
				}
			}
		]];

	InvMainGrid = $UI.datagrid('#InvMainGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				QueryName: 'DHCVendorInv'
			},
			toolbar: ToolBar,
			columns: InvMainCm,
			fitColumns: true,
			onSelect: function (index, row) {
				if (IsOneRow == 1) {
					InvDetailGrid.load({
						ClassName: 'web.DHCSTMHUI.DHCVendorInv',
						QueryName: 'DHCVendorInvItm',
						Inv: row.RowId,
						rows: 99999
					});
				} else {
					IsOneRow = 1;
				}
			},
			onClickCell: function (index, filed, value) {
				InvMainGrid.commonClickCell(index, filed)
			},
			onLoadSuccess: function (data) {
				if (data.rows.length > 0) {
					InvMainGrid.selectRow(0);
				}
			}
		});

	InvDetailCm = [[{
				title: "RowId",
				field: 'RowId',
				width: 50,
				hidden: true,
				saveCol: true
			}, {
				title: "Ingri",
				field: 'Ingri',
				width: 50,
				hidden: true
			}, {
				title: "IncId",
				field: 'IncId',
				width: 50,
				hidden: true
			}, {
				title: "物资代码",
				field: 'Code',
				width: 150
			}, {
				title: "物资名称",
				field: 'Description',
				width: 150
			}, {
				title: "规格",
				field: 'Spec',
				width: 100
			}, {
				title: "单位",
				field: 'UomDesc',
				width: 90
			}, {
				title: "数量",
				field: 'Qty',
				width: 80,
				align: 'right'
			}, {
				title: "进价",
				field: 'Rp',
				width: 80,
				align: 'right'
			}, {
				title: "进价金额",
				field: 'RpAmt',
				width: 80,
				align: 'right'
			}, {
				title: "售价",
				field: 'Sp',
				width: 80,
				align: 'right',
				hidden: true
			}, {
				title: "售价金额",
				field: 'SpAmt',
				width: 80,
				align: 'right',
				hidden: true
			}, {
				title: "厂商",
				field: 'Manf',
				width: 180
			}, {
				title: "类型",
				field: 'Type',
				width: 70,
				formatter: function (value, row, index) {
					if (value == "G") {
						return "入库";
					} else {
						return "退货";
					}
				}
			}
		]];

	InvDetailGrid = $UI.datagrid('#InvDetailGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				QueryName: 'DHCVendorInvItm',
				rows: 99999
			},
			pagination:false,
			columns: InvDetailCm,
			fitColumns: true
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
			ParamsObj.Complate="Y"
			var Params = JSON.stringify(ParamsObj);
			$UI.clear(InvDetailGrid);
			InvMainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				QueryName: 'DHCVendorInv',
				LocId: gLocObj,
				Params: Params
			});
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			$UI.clearBlock('#MainConditions');
			$UI.clear(InvMainGrid);
			$UI.clear(InvDetailGrid);
			SetDefaValues();
		}
	});

	SetDefaValues();
}
$(init);

function Select() {
	$UI.clear(InvMainGrid);
	$UI.clear(InvDetailGrid);
	InvMainGrid.commonReload();
}
function Print(RowId) {
	IsOneRow = 0;
	PrintInv(RowId);
}
