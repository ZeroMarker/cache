var INDispItmBatWindow = function(Input, Params, Fn) {
	$HUI.dialog('#INDispItmBatWindow', { width: gWinWidth, height: gWinHeight }).open();
	var LocId = Params['Locdr'], ToLoc = Params['ToLoc'];
	var gInciRowIndex, gInciRow;
	var gRowArr = [];

	$UI.linkbutton('#IncItmBatSelBT', {
		onClick: function() {
			ReturnInclbData();
		}
	});

	var IncItmBatMasterCm = [[
		{ field: 'ck', checkbox: true },
		{ title: 'Incil', field: 'Incil', width: 80, hidden: true, editor: 'text' },
		{ title: '代码', field: 'InciCode', width: 140 },
		{ title: '名称', field: 'InciDesc', width: 200 },
		{ title: '规格', field: 'Spec', width: 100 },
		{ title: '生产厂家', field: 'ManfName', width: 160 },
		{ title: '发放单位', field: 'PUomDesc', width: 70 },
		{ title: '进价(发放单位)', field: 'PRp', width: 100, align: 'right' },
		{ title: '售价(发放单位)', field: 'PSp', width: 100, align: 'right' },
		{ title: '数量(发放单位)', field: 'PUomQty', width: 100, align: 'right' },
		{ title: '基本单位', field: 'BUomDesc', width: 80 },
		{ title: '进价(基本单位)', field: 'BRp', width: 100, align: 'right' },
		{ title: '售价(基本单位)', field: 'BSp', width: 100, align: 'right' },
		{ title: '数量(基本单位)', field: 'BUomQty', width: 100, align: 'right' },
		{ title: '账单单位', field: 'BillUomDesc', width: 80 },
		{ title: '进价(账单单位)', field: 'BillRp', width: 100, align: 'right' },
		{ title: '售价(账单单位)', field: 'BillSp', width: 100, align: 'right' },
		{ title: '数量(账单单位)', field: 'BillUomQty', width: 100, align: 'right' },
		{ title: '不可用', field: 'NotUseFlag', width: 50, align: 'center', formatter: BoolFormatter }
	]];

	var IncItmBatMasterGrid = $UI.datagrid('#IncItmBatMasterGrid', {
		lazy: false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
			MethodName: 'GetPhaOrderItemInfo',
			StrParam: JSON.stringify(addSessionParams(Params)),
			q: Input
		},
		columns: IncItmBatMasterCm,
		onSelect: function(index, row) {
			if (!IncItmBatDetailGrid.endEditing()) {
				return;
			}
			gInciRowIndex = index, gInciRow = row;
			var InciDr = row['InciDr'];
			var ParamsObj = { InciDr: InciDr, LocId: LocId, ToLoc: ToLoc, UserId: gUserId };
			IncItmBatDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINDispRetItm',
				QueryName: 'GetDispItm',
				query2JsonStrict: 1,
				Params: JSON.stringify(ParamsObj)
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				IncItmBatMasterGrid.selectRow(0);
			}
			$.each(data.rows, function(index, row) {
				ChangeColor(IncItmBatMasterGrid, index, 'Incil');
			});
		}
	});

	var IncItmBatDetailCm = [[
		{ title: '发放明细ID', field: 'RowId', width: 80, hidden: true },
		{ title: '批次RowID', field: 'Inclb', width: 100, hidden: true },
		{ title: '批号', field: 'BatchNo', width: 100, align: 'left' },
		{ title: '效期', field: 'ExpDate', width: 100, align: 'left' },
		{ title: '可退数量', field: 'Qty', width: 90, align: 'right' },
		{ title: '已退数量', field: 'DisRetQty', width: 90, align: 'right' },
		{ title: '退回数量', field: 'RetQty', width: 90, align: 'right', editor: {
			type: 'numberbox',
			options: {
				min: 0,
				precision: GetFmtNum('FmtQTY')
			}
		}},
		{ title: '生产厂家', field: 'Manf', width: 180 },
		{ title: '单位', field: 'UomDesc', width: 80 },
		{ title: '进价', field: 'Rp', width: 60, align: 'right' },
		{ title: '售价', field: 'Sp', width: 60, align: 'right' },
		{ title: '发放日期', field: 'DispDate', width: 100 }
	]];

	var IncItmBatDetailGrid = $UI.datagrid('#IncItmBatDetailGrid', {
		lazy: true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispRetItm',
			QueryName: 'GetDispItm',
			query2JsonStrict: 1
		},
		idField: 'Inclb',
		columns: IncItmBatDetailCm,
		onClickCell: function(index, field, value) {
			IncItmBatDetailGrid.commonClickCell(index, field);
		},
		onDblClickRow: function(index, row) {
			ReturnInclbData();
		},
		onBeginEdit: function(index, row) {
			$(this).datagrid('beginEdit', index);
			var ed = $(this).datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var e = ed[i];
				if (e.field == 'RetQty') {
					$(e.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							ReturnInclbData();
						}
					});
				}
			}
		},
		onAfterEdit: function(index, row, changes) {
			if (changes.hasOwnProperty('RetQty')) {
				var RetQty = Number(changes['RetQty']);
				var Qty = Number(row['Qty']);
				if (RetQty > Qty) {
					$UI.msg('alert', '数量不可大于可退数量');
					$(this).datagrid('updateRow', {
						index: index,
						row: {
							RetQty: ''
						}
					});
					return;
				}
				var Inclb = row['Inclb'];
				var InclbExistFlag = false;
				$.each(gRowArr, function(Index, Item) {
					if (Item['Inclb'] == Inclb) {
						InclbExistFlag = true;
						if (RetQty != 0) {
							Item['RetQty'] = RetQty;
						} else {
							gRowArr.splice(Index, 1);
						}
						return false;
					}
				});
				if (!InclbExistFlag && RetQty != 0) {
					$.extend(row, gInciRow);
					gRowArr.push(row);
				}
				ChangeColor(IncItmBatMasterGrid, gInciRowIndex, 'Incil');
			}
		},
		onLoadSuccess: function(data) {
			$.each(data.rows, function(Index, Row) {
				$.each(gRowArr, function(ArrIndex, ArrRow) {
					if (ArrRow['Inclb'] == Row['Inclb']) {
						IncItmBatDetailGrid.updateRow({
							index: Index,
							row: {
								RetQty: ArrRow['RetQty']
							}
						});
					}
				});
			});
		}
	});

	function ChangeColor(Grid, RowIndex, Field) {
		var Incil = Grid.getRows()[RowIndex][Field];
		var IncilExist = false;
		var ColorField = 'InciDesc';
		$.each(gRowArr, function(ArrIndex, ArrRow) {
			var RowIncil = ArrRow[Field];
			if (RowIncil == Incil) {
				var OperateCss = '+CellBackGroundColor';
				SetGridCss(Grid, RowIndex, Field, ColorField, OperateCss);
				IncilExist = true;
				return false;
			}
		});
		if (!IncilExist) {
			var OperateCss = '-CellBackGroundColor';
			SetGridCss(Grid, RowIndex, Field, ColorField, OperateCss);
		}
	}

	function ReturnInclbData() {
		if (!IncItmBatDetailGrid.endEditing()) {
			return;
		}
		if (gRowArr.length == 0) {
			$UI.msg('alert', '请选择批次，输入退回数量！');
		} else {
			Fn(gRowArr);
			$HUI.dialog('#INDispItmBatWindow').close();
		}
	}
};