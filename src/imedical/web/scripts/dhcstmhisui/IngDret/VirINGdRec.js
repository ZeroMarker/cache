var init = function() {
	var ClearMain = function() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(Grid);
		$HUI.combobox('#Loc').enable();
		$HUI.combobox('#ScgStk').enable();
		$HUI.combobox('#Vendor').enable();
		var DefaultData = {
			Loc: gLocObj
		};
		$UI.fillBlock('#MainConditions', DefaultData);
		SetFieldDisabled('enable');
	};
	// Grid 列 comboxData
	var UomCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote',
			editable: false,
			onBeforeLoad: function(param) {
				var rows = Grid.getRows();
				var row = rows[Grid.editIndex];
				if (!isEmpty(row)) {
					param.Inci = row.Inci;
				}
			},
			onSelect: function(record) {
				var rows = Grid.getRows();
				var row = rows[Grid.editIndex];
				row.UomDesc = record.Description;
			}
		}
	};
	var LocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var LocBox = $HUI.combobox('#Loc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$HUI.combotree('#ScgStk').setFilterByLoc(LocId);
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
	$('#ScgStk').stkscgcombotree({
		onSelect: function(node) {
			if (CommParObj.ApcScg == 'S') {
				VendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M' }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params + '&ScgId=' + node.id ;
				VendorBox.reload(url);
			}
		}
	});
	var UserBox = $HUI.combobox('#User', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetUser&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var MainObj = $UI.loopBlock('#MainConditions');
			var Main = JSON.stringify(MainObj);
			var DetailObj = Grid.getChangesData();
			// 判断
			var ifChangeMain = $UI.isChangeBlock('#MainConditions');
			if (DetailObj === false) {	// 未完成编辑或明细为空
				return;
			}
			if (!ifChangeMain && (isEmpty(DetailObj))) {	// 主单和明细不变
				$UI.msg('alert', '没有需要保存的信息!');
				return;
			}
			var Detail = JSON.stringify(DetailObj);
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.VirINGdRet',
				MethodName: 'SaveVirtualImp',
				Main: Main,
				Detail: Detail
			}, function(jsonData) {
				hideMask();
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
		onClick: function() {
			ClearMain();
		}
	});
	var Select = function(Ingr) {
		$UI.clearBlock('#MainConditions');
		$UI.clear(Grid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.VirINGdRet',
			MethodName: 'Select',
			Ingr: Ingr
		},
		function(jsonData) {
			$UI.fillBlock('#MainConditions', jsonData);
		});
		Grid.load({
			ClassName: 'web.DHCSTMHUI.VirINGdRet',
			QueryName: 'QueryIngri',
			query2JsonStrict: 1,
			Ingr: Ingr
		});
	};

	var Cm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: 'Ingri',
			field: 'Ingri',
			width: 100,
			hidden: true
		}, {
			title: 'Inci',
			field: 'Inci',
			width: 100,
			hidden: true
		}, {
			title: 'Inclb',
			field: 'Inclb',
			width: 100,
			saveCol: true,
			hidden: true
		}, {
			title: '物资代码',
			field: 'Code',
			width: 100
		}, {
			title: '物资名称',
			field: 'Description',
			jump: false,
			width: 150,
			editor: {
				type: 'validatebox',
				options: {
					required: true,
					tipPosition: 'bottom'
				}
			}
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 150
		}, {
			title: '批号效期',
			field: 'BatExp',
			width: 100
		}, {
			title: '数量',
			field: 'Qty',
			width: 100,
			align: 'right',
			saveCol: true,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					min: 0,
					precision: GetFmtNum('FmtQTY')
				}
			}
		}, {
			title: '单位',
			field: 'Uom',
			width: 80,
			formatter: CommonFormatter(UomCombox, 'Uom', 'UomDesc'),
			saveCol: true,
			editor: UomCombox
		}, {
			title: '进价',
			field: 'Rp',
			width: 80,
			align: 'right'
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '零售单价',
			field: 'Sp',
			width: 80,
			align: 'right'
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width: 80,
			align: 'right'
		}
	]];

	function SetFieldDisabled(bool) {
		$('#Loc').combobox(bool);
		$('#ScgStk').combobox(bool);
		$('#Vendor').combobox(bool);
	}
	var Grid = $UI.datagrid('#Grid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.VirINGdRet',
			QueryName: 'QueryIngri',
			query2JsonStrict: 1
		},
		columns: Cm,
		checkField: 'Inclb',
		singleSelect: false,
		showBar: true,
		remoteSort: false,
		showAddDelItems: true,
		onClickRow: function(index, row) {
			Grid.commonClickRow(index, row);
		},
		onEndEdit: function(index, row, changes) {
			var Editors = $(this).datagrid('getEditors', index);
			for (var i = 0; i < Editors.length; i++) {
				var Editor = Editors[i];
				if (Editor.field == 'Qty') {
					var RepLev = row.RepLev;
					var Qty = row.Qty;
					var StkQty = row.StkQty;
					if (Qty > StkQty) {
						$UI.msg('alert', '数量不能大于库存数量!');
						return false;
					} else {
						row.RpAmt = accMul(Qty, row.Rp);
						row.SpAmt = accMul(Qty, row.Sp);
					}
				}
			}
		},
		beforeAddFn: function() {
			if (isEmpty($HUI.combobox('#Loc').getValue())) {
				$UI.msg('alert', '科室不能为空!');
				return false;
			}
			if (isEmpty($HUI.combobox('#Vendor').getValue())) {
				$UI.msg('alert', '供应商不能为空!');
				return false;
			}
			SetFieldDisabled('disable');
		},
		onBeginEdit: function(index, row) {
			$('#Grid').datagrid('beginEdit', index);
			var ed = $('#Grid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var e = ed[i];
				if (e.field == 'Description') {
					$(e.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var Input = $(this).val();
							if (isEmpty(Input)) {
								return;
							}
							var Scg = $('#ScgStk').combotree('getValue');
							var LocDr = $('#Loc').combo('getValue');
							var HV = 'N';
							var ParamsObj = { StkGrpRowId: Scg, StkGrpType: 'M', Locdr: LocDr, NotUseFlag: 'N', QtyFlag: 'Y', HV: HV };
							IncItmBatWindow(Input, ParamsObj, ReturnInfoFn);
						}
					});
				}
			}
		}
	});
	function ReturnInfoFn(rows) {
		rows = [].concat(rows);
		if (rows == null || rows == '') {
			return;
		}
		$.each(rows, function(index, row) {
			Grid.updateRow({
				index: Grid.editIndex,
				row: {
					Inci: row.InciDr,
					Code: row.InciCode,
					Description: row.InciDesc,
					Spec: row.Spec,
					Inclb: row.Inclb,
					Ingri: row.Ingri,
					Rp: row.Rp,
					Sp: row.Sp,
					RpAmt: accMul(row.OperQty, row.Rp),
					SpAmt: accMul(row.OperQty, row.Sp),
					Qty: row.OperQty,
					BatExp: row.BatExp,
					Uom: row.PurUomId,
					UomDesc: row.PurUomDesc,
					Manf: row.Manf,
					StkQty: row.StkQty,
					ConFac: row.ConFac,
					SpecDesc: row.SpecDesc
				}
			});
			$('#Grid').datagrid('refreshRow', Grid.editIndex);
			if (index < rows.length) {
				Grid.commonAddRow();
			}
		});
	}
	ClearMain();
};
$(init);