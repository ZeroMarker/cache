var init = function () {
	var Clear = function () {
		$UI.clearBlock('#Conditions');
		$UI.clear(MainGrid);
		$UI.clear(DetailGrid);
		var Dafult = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			RetLoc: gLocObj
		}
		$UI.fillBlock('#Conditions', Dafult)
	}
	var UomCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote',
			onBeforeLoad: function (param) {
				var rows = DetailGrid.getRows();
				var row = rows[DetailGrid.editIndex];
				if (!isEmpty(row)) {
					param.Inci = row.IncId;
				}
			},
			onSelect: function (record) {
				var rows = DetailGrid.getRows();
				var row = rows[DetailGrid.editIndex];
				row.UomDesc = record.Description;

			}
		}
	};
	/*var ReasonComData = $.cm({
		ClassName: 'web.DHCSTMHUI.Common.Dicts',
		QueryName: 'GetRetReason',
		ResultSetType: 'array'
	}, false);
	var ReasonCombox = {
		type: 'combobox',
		options: {
			data: ReasonComData,
			valueField: 'RowId',
			textField: 'Description'
		}
	}*/
	var ReasonParams = JSON.stringify(addSessionParams())
	var ReasonCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetRetReason&ResultSetType=array&Params=' + ReasonParams,
			valueField: 'RowId',
			textField: 'Description'
		}
	}
	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#Conditions')
			if (isEmpty(ParamsObj.StartDate)) {
				$UI.msg('alert', '开始日期不能为空!');
				return;
			}
			if (isEmpty(ParamsObj.EndDate)) {
				$UI.msg('alert', '截止日期不能为空!');
				return;
			}
			if (isEmpty(ParamsObj.RetLoc)) {
				$UI.msg('alert', '科室不能为空!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			$UI.clear(DetailGrid);
			MainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRetAuxByRec',
				QueryName: 'QueryIngrForRet',
				Params: Params
			});
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function () {
			Save();
		}
	});
	var CheckSave = function (obj) {
		for (var i = 0; i < obj.length; i++) {
			var Row = obj[i];
			var Qty = Row.Qty;
			if (isEmpty(Qty)) { return false; }
		}
		return true;
	}
	var Save = function () {
		var MainObj = $UI.loopBlock('#Conditions');
		var Selected = MainGrid.getSelectedData();
		if (Selected.length == 0) {
			$UI.msg('alert', '请选择要保存的内容!!')
			return;
		}
		MainObj = $.extend(true, MainObj, Selected[0]);
		var Main = JSON.stringify(MainObj);
		var DetailObj = DetailGrid.getRowsData('IngrId');
		if (DetailObj === false) {
			return;
		} //验证未通过  不能保存
		else if (DetailObj.length == 0) {
			$UI.msg('alert', '没有需要保存的明细!')
			return;
		}
		if (CheckSave(DetailObj) == false) {
			$UI.msg('alert', '请填写退货数量!');
			return;
		}
		var Detail = JSON.stringify(DetailObj)
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRet',
			MethodName: 'Save',
			Main: Main,
			Detail: Detail
		}, function (jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.clear(DetailGrid);
				$UI.msg('success', jsonData.msg);
				var checkedRadioJObj = $("input[name='HvFlag']:checked");
				if (checkedRadioJObj.val() != "Y") {
					var UrlStr = "dhcstmhui.ingdret.csp?gIngrtId=" + jsonData.rowid;
				}
				else {
					var UrlStr = "dhcstmhui.ingdrethv.csp?gIngrtId=" + jsonData.rowid;
				}
				Common_AddTab('入库', UrlStr);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	};
	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			Clear();
		}
	});

	var RetLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var RetLocBox = $HUI.combobox('#RetLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + RetLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var VendorParams = JSON.stringify(addSessionParams({ APCType: "M", RcFlag: "Y" }));
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	var MainCm = [[{
		title: 'IngrId',
		field: 'IngrId',
		hidden: true
	}, {
		title: '入库单号',
		field: 'IngrNo',
		width: 150
	}, {
		title: '供应商',
		field: 'VendorDesc',
		width: 150
	}, {
		title: '入库科室',
		field: 'RecLoc',
		width: 150
	}, {
		title: "类组",
		field: 'StkGrpDesc',
		width: 120
	}
	]];

	var MainGrid = $UI.datagrid('#MainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRetAuxByRec',
			QueryName: 'QueryIngrForRet'
		},
		columns: MainCm,
		onSelect: function (index, row) {
			DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRetAuxByRec',
				QueryName: 'QueryIngrDetailForRet',
				Parref: row.IngrId
			});
		}
	})

	var DetailCm = [[{
		title: '入库明细id',
		field: 'Ingri',
		width: 100,
		hidden: true
	}, {
		title: '物资RowId',
		field: 'IncId',
		width: 100,
		hidden: true
	}, {
		title: '批次RowId',
		field: 'Inclb',
		hidden: true
	}, {
		title: '物资代码',
		field: 'IncCode',
		width: 100
	}, {
		title: '物资名称',
		field: 'IncDesc',
		width: 150
	}, {
		title: "高值标志",
		field: 'HVFlag',
		width: 100
	}, {
		title: "高值条码",
		field: 'HVBarCode',
		width: 150
	}, {
		title: "批号~效期",
		field: 'BatExp',
		width: 100
	}, {
		title: "批次库存",
		field: 'StkQty',
		width: 100,
		align: 'right'
	}, {
		title: "退货数量",
		field: 'Qty',
		width: 100,
		align: 'right',
		editor: {
			type: 'numberbox',
			options: {
				required: true
			}
		}
	}, {
		title: "单位",
		field: 'Uom',
		width: 100,
		formatter: CommonFormatter(UomCombox, 'Uom', 'UomDesc'),
		editor: UomCombox
	}, {
		title: "退货原因",
		field: 'ReasonId',
		formatter: CommonFormatter(ReasonCombox, 'ReasonId', 'Reason'),
		editor: ReasonCombox,
		width: 100
	}, {
		title: "退货进价",
		field: 'Rp',
		width: 100,
		align: 'right'
	}, {
		title: "进价金额",
		field: 'RpAmt',
		width: 100,
		align: 'right'
	}, {
		title: "生产厂商",
		field: 'Manf',
		width: 100,
		align: 'left'
	}, {
		title: "占用数量",
		field: 'DirtyQty',
		width: 100,
		align: 'right'

	}, {
		title: "可用数量",
		field: 'AvaQty',
		width: 100,
		align: 'right'
	}, {
		title: "零售单价",
		field: 'Sp',
		width: 100,
		align: 'right'
	}, {
		title: "售价金额",
		field: 'SpAmt',
		width: 100,
		align: 'right'
	}, {
		title: "转换率",
		field: 'ConFac',
		width: 200,
		align: 'left'
	}, {
		title: "基本单位",
		field: 'BUomId',
		width: 100,
		hidden: true,
		align: 'left'
	}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRetAuxByRec',
			QueryName: 'QueryIngrDetailForRet'
		},
		columns: DetailCm,
		onClickCell: function (index, filed, value) {
			DetailGrid.commonClickCell(index, filed, value);
		},
		onEndEdit: function (index, row, changes) {
			var Editors = $(this).datagrid('getEditors', index);
			for (var i = 0; i < Editors.length; i++) {
				var Editor = Editors[i];
				if (Editor.field == 'Qty') {
					var Qty = Number(row.Qty);
					var StkQty = Number(row.StkQty);

					if (Qty > StkQty) {
						$UI.msg("alert", "退货数量不能大于库存数量!");
						DetailGrid.checked = false;
						return false;
					} else {
						row.RpAmt = accMul(Qty, row.Rp);
						row.SpAmt = accMul(Qty, row.Sp);
					}
				}
			}
		}
	})

	Clear();
}
$(init);
