
var init = function() {
	var gInci = '';
	var Clear = function() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(BagMainGrid);
		$UI.clear(InciMainGrid);
	};
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		$UI.clear(InciMainGrid);
		$UI.clear(BagMainGrid);
		var Params = $UI.loopBlock('#MainConditions');
		BagMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
			QueryName: 'GetPack',
			query2JsonStrict: 1,
			Params: JSON.stringify(Params)
		});
	}
	
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			if (!BagMainGrid.endEditing()) {
				return false;
			}
			if (!InciMainGrid.endEditing()) {
				return false;
			}
			if (isEmpty(gInci)) {
				$UI.msg('alert', '请选择包!');
				return false;
			}
			var InciMainData = InciMainGrid.getChangesData();
			var BagMainData = BagMainGrid.getChangesData();
			if (isEmpty(InciMainData)) {	// 包信息
				$UI.msg('alert', '没有需要保存的包信息!');
				return;
			}
			if (isEmpty(BagMainData)) {	// 明细不变
				$UI.msg('alert', '没有需要保存的明细信息!');
				return;
			}
			if ((InciMainData === false) || (BagMainData === false)) {	// 未完成编辑或明细为空
				$UI.msg('alert', '没有需要保存的明细!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
				MethodName: 'Insert',
				Pack: gInci,
				ListData: JSON.stringify(InciMainData)
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					var Params = $UI.loopBlock('#MainConditions');
					BagMainGrid.load({
						ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
						QueryName: 'GetPack',
						query2JsonStrict: 1,
						Params: JSON.stringify(Params)
					});
					InciMainGrid.load({
						ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
						QueryName: 'GetDetail',
						query2JsonStrict: 1,
						Pack: gInci
					});
				} else {
					$UI.msg('alert', jsonData.msg);
				}
			});
		}
	});
	
	var addOneRow = {
		text: '新增包',
		iconCls: 'icon-add',
		handler: function() {
			var DefaData = {};
			gInci = '';
			BagMainGrid.commonAddRow(DefaData);
		}
	};
	var cancelOneRow = {
		text: '删除包',
		iconCls: 'icon-cancel',
		handler: function() {
			var RowsData = BagMainGrid.getSelections();
			if (RowsData.length <= 0) {
				$UI.msg('alert', '请选择要删除的包!');
				return false;
			}
			var rowid = RowsData[0].PackRowId;
			if ((rowid == 'undefined') || (rowid == '') || (rowid == null)) {
				BagMainGrid.commonDeleteRow();
				return;
			} else {
				var DetailLen = InciMainGrid.getRows().length;
				if (DetailLen > 0) {
					$UI.msg('alert', '请先解除关联!');
					return false;
				}
				var RowsData = BagMainGrid.getSelectedData();
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
					MethodName: 'DeletePack',
					ListData: JSON.stringify(RowsData)
				}, function(jsonData) {
					if (jsonData.success === 0) {
						Query();
						$UI.msg('success', jsonData.msg);
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}
	};

	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var VendorBox = $HUI.combobox('#FVendorBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var HandlerParams = function() {
		var Scg = '';
		var LocDr = session['LOGON.CTLOCID'];
		var ReqLoc = '';
		var HV = 'Y';
		var QtyFlag = '0';
		var PackChargeFlag = 'Y';
		var Obj = { StkGrpRowId: Scg, StkGrpType: 'M', Locdr: LocDr, NotUseFlag: 'N', QtyFlag: QtyFlag, HV: HV, RequestNoStock: 'Y', PackChargeFlag: PackChargeFlag };
		
		return Obj;
	};
	var SelectRow = function(row) {
		BagMainGrid.updateRow({
			index: BagMainGrid.editIndex,
			row: {
				PackRowId: row.InciDr,
				InciCode: row.InciCode,
				PackDesc: row.InciDesc,
				VendorDesc: row.PbVendorDesc
			}
		});
		setTimeout(function() {
			BagMainGrid.refreshRow();
		}, 50);
	};
	var HandlerParams2 = function() {
		var Scg = '';
		var LocDr = session['LOGON.CTLOCID'];
		var ReqLoc = '';
		var HV = 'Y';
		var QtyFlag = '0';
		var PackChargeFlag = 'N';
		var Obj = { StkGrpRowId: Scg, StkGrpType: 'M', Locdr: LocDr, NotUseFlag: 'N', QtyFlag: QtyFlag, HV: HV, RequestNoStock: 'Y', PackChargeFlag: PackChargeFlag };
		return Obj;
	};
	var SelectRow2 = function(row) {
		InciMainGrid.updateRow({
			index: InciMainGrid.editIndex,
			row: {
				InciCode: row.InciCode,
				InciDesc: row.InciDesc,
				Spec: row.Spec,
				Inci: row.InciDr
			}
		});
		setTimeout(function() {
			InciMainGrid.refreshRow();
			InciMainGrid.startEditingNext('InciDesc');
		}, 50);
	};
	var BagMainCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'PackRowId',
			field: 'PackRowId',
			width: 100,
			hidden: true
		}, {
			title: '包代码',
			field: 'InciCode',
			width: 100
		}, {
			title: '包名称',
			field: 'PackDesc',
			width: 230,
			editor: InciEditor(HandlerParams, SelectRow)
		}, {
			title: '招标供应商',
			field: 'VendorDesc',
			width: 200
		}
	]];
	
	var BagMainGrid = $UI.datagrid('#BagMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
			QueryName: 'GetPack',
			query2JsonStrict: 1
		},
		columns: BagMainCm,
		fitColumns: true,
		singleSelect: false,
		showBar: false,
		checkField: 'PackRowId',
		toolbar: [addOneRow, cancelOneRow],
		onClickRow: function(index, row) {
			BagMainGrid.commonClickRow(index, row);
		},
		onSelect: function(index, row) {
			gInci = row.PackRowId;
			$UI.clear(InciMainGrid);
			if (!isEmpty(gInci)) {
				InciMainGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
					QueryName: 'GetDetail',
					query2JsonStrict: 1,
					Pack: gInci
				});
			}
		}
	});
	
	var addInciRow = {
		text: '新增关联',
		iconCls: 'icon-add',
		handler: function() {
			var DefaData = {};
			InciMainGrid.commonAddRow(DefaData);
		}
	};
	var cancelInciRow = {
		text: '解除关联',
		iconCls: 'icon-no',
		handler: function() {
			var RowsData = InciMainGrid.getSelections();
			if (RowsData.length <= 0) {
				$UI.msg('alert', '请选择要解除关联的包!');
				return false;
			}
			
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
				MethodName: 'DeleteLink',
				ListData: JSON.stringify(RowsData)
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					InciMainGrid.load({
						ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
						QueryName: 'GetDetail',
						query2JsonStrict: 1,
						Pack: gInci
					});
				} else {
					$UI.msg('alert', jsonData.msg);
				}
			});
		}
	};

	var InciMainCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'PCL',
			field: 'PCL',
			hidden: true,
			width: 80
		}, {
			title: 'Inci',
			field: 'Inci',
			width: 80,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 150
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 200,
			editor: InciEditor(HandlerParams2, SelectRow2)
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}
	]];
	
	var InciMainGrid = $UI.datagrid('#InciMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
			QueryName: 'GetDetail',
			query2JsonStrict: 1
		},
		columns: InciMainCm,
		fitColumns: true,
		singleSelect: false,
		checkField: 'Inci',
		showBar: false,
		toolbar: [addInciRow, cancelInciRow],
		onClickRow: function(index, row) {
			InciMainGrid.commonClickRow(index, row);
		}
	});
	Query();
};
$(init);