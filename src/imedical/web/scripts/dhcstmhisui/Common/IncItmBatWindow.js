// 名称:		批次弹窗
// 编写者:	wangjiabin
// 编写日期:	2018-05-19

/**
 Input:物资别名录入值
 StkGrpRowId：类组id
 StkGrpType：类组类型，G：物资
 Locdr:科室id
 NotUseFlag：不可用标志
 QtyFlag：是否包含0库存项目
 HospID：医院id
 ReqLoc:请求科室id(请求科室id为空时，请求科室库存显示为空)
 Fn：回调函数
 IntrType : 业务类型(相应台账type) 2014-08-31添加
 StkCat : 库存分类id 2016-11-29添加
 QtyFlagBat:是否包含0库存批次
 HV:高值标志(Y:仅高值,N:仅低值,'':所有)
*/
var gSelColor = '#51AD9D';
var IncItmBatWindow = function(Input, Params, Fn) {
	Params.RequestNoStock = 'N';			// 不显示没有库存记录的数据

	var BarCodeInfo = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCUDI',
		MethodName: 'UDIInfo',
		Code: Input
	}, false);
	// "OrgBarCode^InciBarCode^Inci^Incib^BatchNo^ExpDate^ProduceDate^SerialNo"
	$HUI.dialog('#IncItmBatWindow', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
	var gRowArr = [];
	var ProLocId = Params['Locdr'], ReqLocId = Params['ToLoc'];
	var IntrType = Params['IntrType'] || '';
	var QtyFlagBat = Params['QtyFlagBat'] || '0';
	var gInciRowIndex, gInciRow, BatchNo, ExpDate;

	$UI.linkbutton('#IncItmBatSelBT', {
		onClick: function() {
			ReturnInclbData();
		}
	});
	
	$UI.linkbutton('#IncItmFilterBtn', {
		onClick: function() {
			$UI.clear(IncItmBatMasterGrid);
			$UI.clear(IncItmBatDetailGrid);
			var BatParamsObj = $UI.loopBlock('#IncItmBatTB');
			var StrParamObj = JSON.parse(StrParam);
			StrParamObj['Spec'] = BatParamsObj['Spec'];
			StrParamObj['Rp'] = BatParamsObj['Rp'];
			StrParamObj['Brand'] = BatParamsObj['Brand'];
			StrParamNew = JSON.stringify(StrParamObj);
			IncItmBatMasterGrid.load({
				ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
				MethodName: 'GetPhaOrderItemInfo',
				StrParam: StrParamNew,
				q: Input
			});
		}
	});

	var IncItmBatMasterCm = [[
		{ field: 'ck', checkbox: true },
		{ title: 'Incil', field: 'Incil', width: 80, hidden: true, editor: 'text' },
		{ title: '代码', field: 'InciCode', width: 140,
			formatter: function(value, rec) {
				var btn = '<a style="opacity:0.0;border:none;" class="editcls" href="javascript:void(0)"></a>' + value;
				return btn;
			}
		},
		{ title: '名称', field: 'InciDesc', width: 200 },
		{ title: '规格', field: 'Spec', width: 100 },
		{ title: '型号', field: 'Model', width: 100 },
		{ title: '品牌', field: 'Brand', width: 100 },
		{ title: '生产厂家', field: 'ManfName', width: 160 },
		{ title: '入库单位', field: 'PUomDesc', width: 70 },
		{ title: '进价(入库单位)', field: 'PRp', width: 100, align: 'right' },
		{ title: '售价(入库单位)', field: 'PSp', width: 100, align: 'right' },
		{ title: '数量(入库单位)', field: 'PUomQty', width: 100, align: 'right' },
		{ title: '基本单位', field: 'BUomDesc', width: 80 },
		{ title: '进价(基本单位)', field: 'BRp', width: 100, align: 'right' },
		{ title: '售价(基本单位)', field: 'BSp', width: 100, align: 'right' },
		{ title: '数量(基本单位)', field: 'BUomQty', width: 100, align: 'right' },
		{ title: '账单单位', field: 'BillUomDesc', width: 80 },
		{ title: '进价(账单单位)', field: 'BillRp', width: 100, align: 'right' },
		{ title: '售价(账单单位)', field: 'BillSp', width: 100, align: 'right' },
		{ title: '数量(账单单位)', field: 'BillUomQty', width: 100, align: 'right' },
		{ title: '不可用', field: 'NotUseFlag', width: 50, align: 'center', formatter: BoolFormatter },
		{ title: '国家医保编码', field: 'MatInsuCode', width: 100 },
		{ title: '国家医保名称', field: 'MatInsuDesc', width: 100 }
	]];
	var StrParam;
	if (BarCodeInfo.Inci) {
		BatchNo = BarCodeInfo.BatchNo;
		ExpDate = BarCodeInfo.ExpDate;
		var _options = jQuery.extend(true, {}, { BarCode: BarCodeInfo.InciBarCode }, addSessionParams(Params));
		StrParam = JSON.stringify(_options);
		Input = '';
	} else {
		StrParam = JSON.stringify(addSessionParams(Params));
	}
	var IncItmBatMasterGrid = $UI.datagrid('#IncItmBatMasterGrid', {
		lazy: false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
			MethodName: 'GetPhaOrderItemInfo',
			StrParam: StrParam,
			q: Input
		},
		toolbar: '#IncItmBatTB',
		columns: IncItmBatMasterCm,
		onSelect: function(index, row) {
			if (!IncItmBatDetailGrid.endEditing()) {
				return;
			}
			gInciRowIndex = index, gInciRow = row;
			var InciDr = row['InciDr'];
			var ParamsObj = { InciDr: InciDr, ProLocId: ProLocId, ReqLocId: ReqLocId, QtyFlag: QtyFlagBat, BatchNo: BatchNo, ExpDate: ExpDate };
			IncItmBatDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
				MethodName: 'GetDrugBatInfo',
				Params: JSON.stringify(ParamsObj)
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				IncItmBatMasterGrid.selectRow(0);
				$(IncItmBatMasterGrid.getPanel().find('div.datagrid-body .editcls')[0]).focus();
			}
			$.each(data.rows, function(index, row) {
				ChangeColor(IncItmBatMasterGrid, index, 'Incil');
			});
		},
		navigatingWithKey: true,
		navigateHandler: {
			up: function(targetIndex) { },
			down: function(targetIndex) { },
			enter: function(selectedData) {
				if (IncItmBatDetailGrid.getRows().length > 0) {
					IncItmBatDetailGrid.selectRow(0);
					IncItmBatDetailGrid.editIndex = 0;
					IncItmBatDetailGrid.beginEdit(0);
					var ed = IncItmBatDetailGrid.getEditor({ index: 0, field: 'OperQty' });
					$(ed.target).focus();
				}
			}
		}
	});

	var InclbUomCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote',
			editable: false,
			onBeforeLoad: function(param) {
				var Select = IncItmBatDetailGrid.getRows()[IncItmBatDetailGrid.editIndex];
				if (!isEmpty(Select)) {
					var Inci = Select.Inclb.split('||')[0];
					param.Inci = Inci;
				}
			},
			onSelect: function(record) {
				var rows = IncItmBatDetailGrid.getRows();
				var row = rows[IncItmBatDetailGrid.editIndex];
				
				var NewUomId = record['RowId'];
				var OldUomId = row['PurUomId'];
				if (isEmpty(NewUomId) || (NewUomId == OldUomId)) {
					return false;
				}
				var BUomId = row['BUomId'];
				var ConFac = row['ConFac'];
				if (NewUomId == BUomId) {
					// 入库单位转换为基本单位
					row['Rp'] = accDiv(row['Rp'], ConFac);
					row['Sp'] = accDiv(row['Sp'], ConFac);
					row['BatSp'] = accDiv(row['BatSp'], ConFac);
					if (row['InclbQty'] !== '') {
						row['InclbQty'] = accMul(row['InclbQty'], ConFac);
						row['InclbDirtyQty'] = accMul(row['InclbDirtyQty'], ConFac);
						row['InclbAvaQty'] = accMul(row['InclbAvaQty'], ConFac);
						row['ReqQty'] = accMul(row['ReqQty'], ConFac);
						row['SupplyStockQty'] = accMul(row['SupplyStockQty'], ConFac);
						row['SupplyAvaStockQty'] = accMul(row['SupplyAvaStockQty'], ConFac);
						row['RequrstStockQty'] = accMul(row['RequrstStockQty'], ConFac);
						row['AvaQty'] = accMul(row['AvaQty'], ConFac);
					}
				} else { // 基本单位转换为入库单位
					row['Rp'] = accMul(row['Rp'], ConFac);
					row['Sp'] = accMul(row['Sp'], ConFac);
					row['BatSp'] = accMul(row['BatSp'], ConFac);
					if (row['InclbQty'] !== '') {
						row['InclbQty'] = accDiv(row['InclbQty'], ConFac);
						row['InclbDirtyQty'] = accDiv(row['InclbDirtyQty'], ConFac);
						row['InclbAvaQty'] = accDiv(row['InclbAvaQty'], ConFac);
						row['ReqQty'] = accDiv(row['ReqQty'], ConFac);
						row['SupplyStockQty'] = accDiv(row['SupplyStockQty'], ConFac);
						row['SupplyAvaStockQty'] = accDiv(row['SupplyAvaStockQty'], ConFac);
						row['RequrstStockQty'] = accDiv(row['RequrstStockQty'], ConFac);
						row['AvaQty'] = accDiv(row['AvaQty'], ConFac);
					}
				}
				row['PurUomId'] = NewUomId;
				row['PurUomDesc'] = record['Description'];
				setTimeout(function() {
					IncItmBatDetailGrid.refreshRow();
				}, 0);
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	
	var IncItmBatDetailCm = [[
		{ title: '批次RowID', field: 'Inclb', width: 100, hidden: true, editor: 'text' },
		{ title: '批次~效期', field: 'BatExp', width: 200, align: 'left', sortable: true },
		{ title: '具体规格', field: 'SpecDesc', width: 100, align: 'left' },
		{ title: '批次库存', field: 'InclbQty', width: 90, align: 'right' },
		{ title: '批次可用库存', field: 'AvaQty', width: 90, align: 'right' },
		{ title: '业务数量', field: 'OperQty', width: 90, align: 'right', editor: {
			type: 'numberbox',
			options: {
				precision: GetFmtNum('FmtQTY')
			}}},
		{ title: '供应商', field: 'VendorName', width: 120 },
		{ title: '生产厂家', field: 'Manf', width: 180 },
		{ title: '单位', field: 'PurUomId', width: 80, editor: InclbUomCombox, formatter: CommonFormatter(InclbUomCombox, 'PurUomId', 'PurUomDesc') },
		{ title: '请求数量', field: 'ReqQty', width: 80, align: 'right' },
		{ title: '基本单位RowId', field: 'BUomId', width: 80, hidden: true },
		{ title: '基本单位', field: 'BUomDesc', width: 80 },
		{ title: '进价', field: 'Rp', width: 60, align: 'right' },
		// {title : '货位码', field : 'StkBin', width : 100},
		{ title: '供应方库存', field: 'SupplyStockQty', width: 100, align: 'right' },
		{ title: '供应方可用库存', field: 'SupplyAvaStockQty', width: 100, align: 'right' },
		{ title: '请求方库存', field: 'RequrstStockQty', width: 100, align: 'right' },
		// {title : '入库日期', field : 'IngrDate', width : 80, align : 'center'},
		{ title: '转换率', field: 'ConFac', width: 60, align: 'center' },
		// {title : '批次占用库存', field : 'DirtyQty', width : 90, align : 'right'},
		{ title: '高值标志', field: 'HVFlag', width: 60, align: 'center' },
		{ title: '锁定标志', field: 'RecallFlag', width: 60, align: 'center' },
		{ title: '灭菌批号', field: 'SterilizedBat', width: 100 }
	]];

	var IncItmBatDetailGrid = $UI.datagrid('#IncItmBatDetailGrid', {
		lazy: true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
			MethodName: 'GetDrugBatInfo'
		},
		idField: 'Inclb',
		columns: IncItmBatDetailCm,
		navigatingWithKey: true,
		navigateHandler: {
			up: function(targetIndex) {
				if (IncItmBatDetailGrid.editIndex > 0) {
					var RowIndex = IncItmBatDetailGrid.editIndex - 1;
					if (!IncItmBatDetailGrid.endEditing()) {
						return;
					}
					IncItmBatDetailGrid.selectRow(RowIndex);
					// IncItmBatDetailGrid.beginEdit(RowIndex);
					IncItmBatDetailGrid.editCell({ index: RowIndex, field: 'OperQty' });
					var ed = IncItmBatDetailGrid.getEditor({ index: RowIndex, field: 'OperQty' });
					$(ed.target).focus();
				}
				return false;
			},
			down: function(targetIndex) {
				if (IncItmBatDetailGrid.editIndex < IncItmBatDetailGrid.getRows().length - 1) {
					var RowIndex = IncItmBatDetailGrid.editIndex + 1;
					if (!IncItmBatDetailGrid.endEditing()) {
						return;
					}
					IncItmBatDetailGrid.selectRow(RowIndex);
					// IncItmBatDetailGrid.beginEdit(RowIndex);
					IncItmBatDetailGrid.editCell({ index: RowIndex, field: 'OperQty' });
					var ed = IncItmBatDetailGrid.getEditor({ index: RowIndex, field: 'OperQty' });
					$(ed.target).focus();
				}
				return false;
			}
		},
		onClickRow: function(index, row) {
			IncItmBatDetailGrid.commonClickRow(index, row);
		},
		onDblClickRow: function(index, row) {
			ReturnInclbData();
		},
		onBeginEdit: function(index, row) {
			if (row['RecallFlag'] == 'Y') {
				$UI.msg('alert', '批次锁定 不可以使用!');
				var target = $('#IncItmBatDetailGrid').datagrid('getEditor', { index: index, field: 'OperQty' }).target;
				$(target).attr('disabled', true);
			} else {
				$(this).datagrid('beginEdit', index);
				IncItmBatDetailGrid.editIndex = index;
				var ed = $(this).datagrid('getEditors', index);
				for (var i = 0; i < ed.length; i++) {
					var e = ed[i];
					if (e.field == 'OperQty') {
						$(e.target).bind('blur', function(event) {
							var OperQty = $(this).val();
							var AvaQty = Number(row['AvaQty']);
							if (IntrType == 'A') {
								// 库存调整可录入负值, 添加控制
								if (accAdd(OperQty, AvaQty) < 0) {
									$UI.msg('alert', '调整数量为负数时不能超过批次可用库存!');
									return;
								}
							} else if ((IntrType != 'G') && (IntrType != 'A') && (OperQty > AvaQty)) {
								$UI.msg('alert', '数量不可大于批次可用数量');
								return;
							} else if ((IntrType != 'A') && (OperQty <= 0)) {
								$UI.msg('alert', '数量不可小于或等于零');
								return;
							}
						});
						$(e.target).bind('keydown', function(event) {
							if (event.keyCode == 13) {
								var OperQty = $(this).val();
								var AvaQty = Number(row['AvaQty']);
								if (IntrType != 'G' && IntrType != 'A' && OperQty > AvaQty) {
									$UI.msg('alert', '数量不可大于批次可用数量');
									return;
								} else if ((IntrType != 'A') && (OperQty <= 0)) {
									$UI.msg('alert', '数量不可小于或等于零');
									return;
								} else if (IntrType == 'A') {
									if (accAdd(OperQty, AvaQty) < 0) {
										$UI.msg('alert', '调整数量为负数时不能超过批次可用库存!');
										return;
									}
								}
								ReturnInclbData();
							} else if (event.altKey) {
								if (gInciRowIndex == IncItmBatMasterGrid.getRows().length - 1) {
									IncItmBatMasterGrid.selectRow(gInciRowIndex);
									$(IncItmBatMasterGrid.getPanel().find('div.datagrid-body .editcls')[gInciRowIndex]).focus();
								} else {
									IncItmBatMasterGrid.selectRow(gInciRowIndex + 1);
									$(IncItmBatMasterGrid.getPanel().find('div.datagrid-body .editcls')[gInciRowIndex + 1]).focus();
								}
							}
						});
					}
				}
			}
		},
		onEndEdit: function(index, row, changes) {
			var ed = $(this).datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var e = ed[i];
				if (e.field == 'OperQty') {
					var OperQty = row['OperQty'];
					var UomId = row['PurUomId'];
					var ConFac = row['ConFac'];
					var BUomId = row['BUomId'];
					if (UomId == BUomId) {
						if (!CheckFmtQty(ConFac, 'BUom', OperQty)) {
							IncItmBatDetailGrid.checked = false;
							return;
						}
					} else {
						if (!CheckFmtQty(ConFac, 'PUom', OperQty)) {
							IncItmBatDetailGrid.checked = false;
							return;
						}
					}
				}
			}
		},
		onAfterEdit: function(index, row, changes) {
			if (changes.hasOwnProperty('OperQty')) {
				var OperQty = Number(changes['OperQty']);
				var AvaQty = Number(row['AvaQty']);
				if (IntrType == 'A') {
					// 库存调整可录入负值, 添加控制
					if (accAdd(OperQty, AvaQty) < 0) {
						$UI.msg('alert', '调整数量为负数时不能超过批次可用库存!');
						$(this).datagrid('updateRow', {
							index: index,
							row: {
								OperQty: ''
							}
						});
						return;
					}
				} else if (IntrType != 'G' && OperQty > AvaQty) {
					// 虚拟入库不控制数量
					$UI.msg('alert', '数量不可大于批次可用数量');
					$(this).datagrid('updateRow', {
						index: index,
						row: {
							OperQty: ''
						}
					});
					return;
				}
				var Inclb = row['Inclb'];
				var InclbExistFlag = false;
				$.each(gRowArr, function(Index, Item) {
					if (Item['Inclb'] == Inclb) {
						InclbExistFlag = true;
						if (OperQty != 0) {
							Item['OperQty'] = OperQty;
						} else {
							gRowArr.splice(Index, 1);
						}
						return false;
					}
				});
				if (!InclbExistFlag && OperQty != 0) {
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
								OperQty: ArrRow['OperQty']
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
			$UI.msg('alert', '请选择批次，输入业务数量！');
		} else {
			Fn(gRowArr);
			$HUI.dialog('#IncItmBatWindow').close();
		}
	}
	function IncItmBatClear() {
		$('#IncItmBatSpec').val('');
		$('#IncItmBatBrand').val('');
		$('#IncItmBatRp').val('');
	}
	IncItmBatClear();
};