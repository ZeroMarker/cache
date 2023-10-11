var init = function() {
	var Clear = function() {
		$UI.clearBlock('#Conditions');
		$UI.clear(MainGrid);
		$UI.clear(DetailGrid);
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			RetLoc: gLocObj
		};
		$UI.fillBlock('#Conditions', DefaultData);
	};
	var UomCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			tipPosition: 'bottom',
			mode: 'remote',
			editable: false,
			onBeforeLoad: function(param) {
				var rows = DetailGrid.getRows();
				var row = rows[DetailGrid.editIndex];
				if (!isEmpty(row)) {
					param.Inci = row.IncId;
				}
			},
			onSelect: function(record) {
				var rows = DetailGrid.getRows();
				var row = rows[DetailGrid.editIndex];
				row.UomDesc = record.Description;
				var NewUomid = record.RowId;
				var OldUomid = row.Uom;
				if (isEmpty(NewUomid) || (NewUomid == OldUomid)) {
					return false;
				}
				var BUomId = row.BUomId;
				var Rp = row.Rp;
				var StkQty = row.StkQty;
				var Qty = row.Qty;
				var Sp = row.Sp;
				var RpAmt = row.RpAmt;
				var SpAmt = row.SpAmt;
				var confac = row.ConFac;
				if (NewUomid == BUomId) { // 入库单位转换为基本单位
					row.Rp = Number(Rp).div(confac);
					row.Sp = Number(Sp).div(confac);
					if (!isEmpty(StkQty)) {
						row.StkQty = Number(StkQty).mul(confac);
					}
				} else { // 基本单位转换为入库单位
					row.Rp = Number(Rp).mul(confac);
					row.Sp = Number(Sp).mul(confac);
					if (!isEmpty(StkQty)) {
						row.StkQty = Number(StkQty).div(confac);
					}
				}
				row.Uom = NewUomid;
				setTimeout(function() {
					DetailGrid.refreshRow();
				}, 0);
			}
		}
	};
	
	var ReasonParams = JSON.stringify(addSessionParams());
	var ReasonCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetRetReason&ResultSetType=array&Params=' + ReasonParams,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = DetailGrid.getRows();
				var row = rows[DetailGrid.editIndex];
				row.Reason = record.Description;
			}
		}
	};
	var SelReqHandlerParams = function() {
		var Obj = { StkGrpType: 'M' };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(SelReqHandlerParams, '#InciDesc', '#InciId'));
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var StartDate = ParamsObj.StartDate;
			var EndDate = ParamsObj.EndDate;
			if (isEmpty(ParamsObj.RetLoc)) {
				$UI.msg('alert', '科室不能为空!');
				return;
			}
			if (isEmpty(StartDate)) {
				$UI.msg('alert', '开始日期不能为空!');
				return;
			}
			if (isEmpty(EndDate)) {
				$UI.msg('alert', '截止日期不能为空!');
				return;
			}
			if (compareDate(StartDate, EndDate)) {
				$UI.msg('alert', '截止日期不能小于开始日期!');
				return;
			}
			var InciDesc = $HUI.lookup('#InciDesc').getText();
			ParamsObj.InciDesc = InciDesc;
			var Params = JSON.stringify(ParamsObj);
			$UI.clear(DetailGrid);
			MainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRetAuxByRec',
				QueryName: 'QueryIngrForRet',
				query2JsonStrict: 1,
				Params: Params
			});
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			Save();
		}
	});
	
	function CheckDataBeforeSave() {
		if (!DetailGrid.endEditing()) {
			return false;
		}
		var RowsData = DetailGrid.getSelections();
		if (RowsData.length == 0) {
			$UI.msg('alert', '没有要保存的明细!');
			return false;
		}
		for (var i = 0, Len = RowsData.length; i < Len; i++) {
			var Row = RowsData[i];
			var RowIndex = DetailGrid.getRowIndex(Row);
			var ReasonId = Row['ReasonId'];
			var Qty = Row['Qty'];
			if (isEmpty(Qty)) {
				$UI.msg('alert', '第' + (RowIndex + 1) + '行数量不能为空!');
				return false;
			}
			if (IngrtParamObj['AllowSaveReasonEmpty'] != 'Y' && isEmpty(ReasonId)) {
				$UI.msg('alert', '第' + (RowIndex + 1) + '行退货原因不能为空!');
				return false;
			}
			var HVFlag = Row['HVFlag'];
			var Inci = Row['IncId'];
			var BatchCodeFlag = tkMakeServerCall('web.DHCSTMHUI.Common.DrugInfoCommon', 'GetBatchCodeFlag', Inci);
			if (HVFlag == 'Y' && BatchCodeFlag == 'N' && Qty > 1) {
				$UI.msg('alert', '第' + (RowIndex + 1) + '行高值材料退货数量不能大于1!');
				return false;
			}
		}
		return true;
	}
	
	var Save = function() {
		if (CheckDataBeforeSave() == false) {
			return;
		}
		var MainObj = $UI.loopBlock('#Conditions');
		var Selected = MainGrid.getSelections();
		if (Selected.length == 0) {
			$UI.msg('alert', '请选择要保存的内容!!');
			return;
		}
		MainObj = $.extend(true, MainObj, Selected[0]);
		var Main = JSON.stringify(MainObj);
		
		var DetailObj = DetailGrid.getSelections();
		if (DetailObj === false) {
			return;
		} else if (DetailObj.length == 0) {
			$UI.msg('alert', '没有需要保存的明细!');
			return;
		}
		var Detail = JSON.stringify(DetailObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRet',
			MethodName: 'jsSave',
			Main: Main,
			Detail: Detail
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.clear(DetailGrid);
				$UI.msg('success', jsonData.msg);
				var checkedRadioJObj = $("input[name='HvFlag']:checked");
				if (checkedRadioJObj.val() != 'Y') {
					var UrlStr = 'dhcstmhui.ingdret.csp?gIngrtId=' + jsonData.rowid;
				} else {
					var UrlStr = 'dhcstmhui.ingdrethv.csp?gIngrtId=' + jsonData.rowid;
				}
				Common_AddTab('退货单制单', UrlStr);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	};
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});

	var RetLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var RetLocBox = $HUI.combobox('#RetLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + RetLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			if (CommParObj.ApcScg == 'L') {
				VendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M', LocId: LocId }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
				VendorBox.reload(url);
			}
		}
	});
	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	var MainCm = [[
		{
			title: 'IngrId',
			field: 'IngrId',
			width: 100,
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
			title: '类组',
			field: 'StkGrpDesc',
			width: 120
		}
	]];

	var MainGrid = $UI.datagrid('#MainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRetAuxByRec',
			QueryName: 'QueryIngrForRet',
			query2JsonStrict: 1
		},
		columns: MainCm,
		showBar: true,
		onSelect: function(index, row) {
			DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRetAuxByRec',
				QueryName: 'QueryIngrDetailForRet',
				query2JsonStrict: 1,
				Parref: row.IngrId,
				rows: 9999
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});

	var DetailCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
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
			width: 100,
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
			title: '退货数量',
			field: 'Qty',
			width: 80,
			align: 'right',
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: GetFmtNum('FmtQTY')
				}
			}
		}, {
			title: '单位',
			field: 'Uom',
			width: 60,
			formatter: CommonFormatter(UomCombox, 'Uom', 'UomDesc'),
			editor: UomCombox
		}, {
			title: '退货原因',
			field: 'ReasonId',
			formatter: CommonFormatter(ReasonCombox, 'ReasonId', 'Reason'),
			editor: ReasonCombox,
			width: 100
		}, {
			title: '退货进价',
			field: 'Rp',
			width: 80,
			align: 'right'
		}, {
			title: '高值标志',
			field: 'HVFlag',
			width: 80,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: '高值条码',
			field: 'HvBarCode',
			width: 150
		}, {
			title: '批号~效期',
			field: 'BatExp',
			width: 150
		}, {
			title: '批次库存',
			field: 'StkQty',
			width: 80,
			align: 'right'
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 100,
			align: 'left'
		}, {
			title: '占用数量',
			field: 'DirtyQty',
			width: 80,
			align: 'right'

		}, {
			title: '可用数量',
			field: 'AvaQty',
			width: 80,
			align: 'right'
		}, {
			title: '售价',
			field: 'Sp',
			width: 80,
			align: 'right',
			hidden: true
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width: 80,
			align: 'right',
			hidden: true
		}, {
			title: '转换率',
			field: 'ConFac',
			width: 80,
			align: 'right',
			hidden: true
		}, {
			title: '基本单位',
			field: 'BUomId',
			width: 100,
			hidden: true,
			align: 'left'
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRetAuxByRec',
			QueryName: 'QueryIngrDetailForRet',
			query2JsonStrict: 1
		},
		columns: DetailCm,
		pagination: false,
		showBar: true,
		singleSelect: false,
		checkOnSelect: true,
		onClickRow: function(index, row) {
			DetailGrid.commonClickRow(index, row);
		},
		onEndEdit: function(index, row, changes) {
			var Editors = $(this).datagrid('getEditors', index);
			for (var i = 0; i < Editors.length; i++) {
				var Editor = Editors[i];
				if (Editor.field == 'Qty') {
					var Qty = Number(row.Qty);
					var StkQty = Number(row.StkQty);
					if (Qty > StkQty) {
						$UI.msg('alert', '退货数量不能大于库存数量!');
						DetailGrid.checked = false;
						return false;
					} else {
						row.RpAmt = accMul(Qty, row.Rp);
						row.SpAmt = accMul(Qty, row.Sp);
					}
				}
			}
		}
	});
	Clear();
	$('#QueryBT').click();
};
$(init);