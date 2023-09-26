var ToolBar, InvCm, InvGrid;
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

	var UserBox = $HUI.combobox('#CreateUser', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetUser&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description'
		});

	ToolBar = [{
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function () {
				var ParamsObj = $UI.loopBlock('#MainConditions');
				if (ParamsObj.Complate == "Y") {
					$UI.msg('alert', '已完成,不能删除!');
					return;
				}
				var Params = InvGrid.getSelectedData();
				if (Params.length == 0) {
					$UI.msg('alert', '请选择要删除的行!');
					return;
				}
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCVendorInv',
					MethodName: 'DeleteItm',
					Inv: ParamsObj.RowId,
					Params: JSON.stringify(Params)
				}, function (jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						Select(ParamsObj.RowId);
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}
	];

	InvCm = [[{
				field: 'ck',
				checkbox: true
			}, {
				title: 'RowId',
				field: 'RowId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: '入库(退货)RowId',
				field: 'Ingri',
				width: 50,
				hidden: true
			}, {
				title: '类型',
				field: 'Type',
				width: 100,
				formatter: function (value, row, index) {
					if (value == "G") {
						return "入库";
					} else {
						return "退货";
					}
				}
			}, {
				title: '物资RowId',
				field: 'IncId',
				width: 50,
				hidden: true
			}, {
				title: '代码',
				field: 'Code',
				width: 100
			}, {
				title: '描述',
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
				width: 100
			}, {
				title: "进价",
				field: 'Rp',
				width: 100,
				align: 'right'
			}, {
				title: "进价金额",
				field: 'RpAmt',
				width: 100,
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
				align: 'right'
			}, {
				title: "厂商",
				field: 'Manf',
				width: 150
			}
		]];

	InvGrid = $UI.datagrid('#InvGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				QueryName: 'DHCVendorInvItm'
			},
			toolbar: ToolBar,
			columns: InvCm,
			singleSelect: false,
			sortName: 'RowId',
			sortOrder: 'Desc'
		});

	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#MainConditions');
			if (isEmpty(ParamsObj.IngrLoc)) {
				$UI.msg('alert', '入库科室不能为空!');
				return;
			}
			FindWin(ParamsObj.IngrLoc, Select);
		}
	});

	$UI.linkbutton('#DelBT', {
		onClick: function () {
			var RowId = $('#RowId').val();
			if (isEmpty(RowId)) {
				return;
			}
			var ParamsObj = $UI.loopBlock('#MainConditions');
			if (ParamsObj.Comp == "Y") {
				$UI.msg('alert', '已完成,不能删除!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				MethodName: 'Delete',
				Inv: RowId
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					Clear();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	$UI.linkbutton('#ComBT', {
		onClick: function () {
			var RowId = $('#RowId').val();
			if (isEmpty(RowId)) {
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				MethodName: 'SetComp',
				Inv: RowId
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					Select(jsonData.rowid);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	$UI.linkbutton('#CanComBT', {
		onClick: function () {
			var RowId = $('#RowId').val();
			if (isEmpty(RowId)) {
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				MethodName: 'CancelComp',
				Inv: RowId
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					Select(jsonData.rowid);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			Clear();
		}
	});

	$UI.linkbutton('#PrintBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#MainConditions');
			if (isEmpty(ParamsObj.RowId)) {
				$UI.msg('alert', "没有需要打印的发票组合单!");
				return;
			}
			PrintInv(ParamsObj.RowId);
		}
	});

	$UI.linkbutton('#InvMainBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#MainConditions');
			if (isEmpty(ParamsObj.IngrLoc)) {
				$UI.msg('alert', '入库科室不能为空!');
				return;
			}
			InvMainWin(ParamsObj.IngrLoc, Select);
		}
	});

	$UI.linkbutton('#InvDetailBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#MainConditions');
			if (isEmpty(ParamsObj.IngrLoc)) {
				$UI.msg('alert', '入库科室不能为空!');
				return;
			}
			InvDetailWin(ParamsObj.IngrLoc, Select);
		}
	});

	SetDefaValues();
}
$(init);
function setEditDisable() {
	$HUI.combobox("#IngrLoc").disable();
	ChangeButtonEnable({'#DelBT':false,'#ComBT':false,'#CanComBT':true});
}

function setEditEnable() {
	$HUI.combobox("#IngrLoc").enable();
	ChangeButtonEnable({'#DelBT':true,'#ComBT':true,'#CanComBT':false});
}
function Clear() {
	$UI.clearBlock('#MainConditions');
	$UI.clear(InvGrid);
	SetDefaValues();
	setEditEnable();
}

function Select(Inv) {
	$UI.clearBlock('#MainConditions');
	$UI.clear(InvGrid);
	$.cm({
		ClassName: 'web.DHCSTMHUI.DHCVendorInv',
		MethodName: 'Select',
		Inv: Inv
	}, function (jsonData) {
		$UI.fillBlock('#MainConditions', jsonData);
		if ($HUI.checkbox('#Comp').getValue()) {
			setEditDisable();
		} else {
			setEditEnable();
		}
	});
	InvGrid.load({
		ClassName: 'web.DHCSTMHUI.DHCVendorInv',
		QueryName: 'DHCVendorInvItm',
		Inv: Inv
	});
}
