// 名称:		物资弹窗
// 编写者:		lxt
// 编写日期:	20201022
/**
Params
	StkGrpRowId：类组id
	StkGrpType：类组类型，G：物资
	StkCat : 库存分类
	Locdr:科室id
	ToLoc:请求科室id(请求科室id为空时，请求科室库存显示为空)
	NotUseFlag：不可用标志
	QtyFlag：是否包含0库存项目
	ReqModeLimited：O临时请求，C申领计划
	NoLocReq
	HV:高值标志(Y:仅高值,N:仅低值,'':所有)
	RequestNoStock：Y允许未入库，N不允许
	SeachAllFlag:Y(可以不传库存项信息)，N必须传
	Vendor:供应商id
Others
	DefaUom：0入库单位，1基本单位
	MoreThanStockFlag:Y允许数量大于库存，N不允许

Fn：回调函数
*/
var IncItmWindow = function(Params, Others, Fn) {
	var DefaUom = Others.DefaUom;
	var MoreThanStockFlag = Others.MoreThanStockFlag;
	
	$HUI.dialog('#IncItmWindow', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
	
	$UI.linkbutton('#IncItmSelBT', {
		onClick: function() {
			ReturnInciData();
		}
	});
	
	function ReturnInciData() {
		if (!IncItmGrid.endEditing()) {
			return;
		}
		var RowsData = IncItmGrid.getChecked();
		var Len = RowsData.length;
		if (Len == 0) {
			$UI.msg('alert', '请选择至少一条明细!');
			return false;
		}
		for (var i = 0; i < Len; i++) {
			var RowData = RowsData[i];
			var InciDesc = RowData['InciDesc'];
			var Qty = RowData['Qty'];
			if (isEmpty(Qty)) {
				$UI.msg('alert', InciDesc + ' 数量不能为空！');
				return false;
			}
		}
		Fn(RowsData);
		$HUI.dialog('#IncItmWindow').close();
	}
	
	function Query() {
		IncItmGrid.load({
			ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
			MethodName: 'GetPhaOrderItemInfo',
			StrParam: JSON.stringify(addSessionParams(Params)),
			page: 1,
			rows: 99999
		});
	}
	
	/* --Grid--*/
	var IncItmCm = [[{
		field: 'ck',
		checkbox: true
	}, {
		title: 'Incil',
		field: 'Incil',
		hidden: true
	}, {
		title: '物资RowId',
		field: 'InciDr',
		hidden: true
	}, {
		title: '物资代码',
		field: 'InciCode',
		width: 100
	}, {
		title: '物资名称',
		field: 'InciDesc',
		width: 200
	}, {
		title: '规格',
		field: 'Spec',
		width: 100
	}, {
		title: '型号',
		field: 'Model',
		width: 100
	}, {
		title: '生产厂家id',
		field: 'Manfdr',
		width: 100,
		hidden: true
	}, {
		title: '生产厂家',
		field: 'ManfName',
		width: 100
	}, {
		title: '数量',
		field: 'Qty',
		width: 100,
		align: 'right',
		editor: {
			type: 'numberbox',
			options: {
				min: 0,
				precision: GetFmtNum('FmtQTY')
			}
		}
	}, {
		title: '基本单位id',
		field: 'BUomDr',
		width: 80,
		hidden: true
	}, {
		title: '基本单位',
		field: 'BUomDesc',
		width: 80,
		hidden: (DefaUom != '0' ? false : true)
	}, {
		title: '进价',
		field: 'BRp',
		width: 80,
		align: 'right',
		hidden: (DefaUom != '0' ? false : true)
	}, {
		title: '售价',
		field: 'BSp',
		width: 80,
		align: 'right',
		hidden: (DefaUom != '0' ? false : true)
	}, {
		title: '库存量',
		field: 'BUomQty',
		width: 80,
		align: 'right',
		hidden: (DefaUom != '0' ? false : true)
	}, {
		title: '可用库存',
		field: 'BUomAvaQty',
		width: 80,
		align: 'right',
		hidden: (DefaUom != '0' ? false : true)
	}, {
		title: '请求科室库存（基本单位）',
		field: 'ReqBuomQty',
		width: 80,
		align: 'right',
		hidden: true
	}, {
		title: '入库单位id',
		field: 'PUomDr',
		width: 80,
		hidden: true
	}, {
		title: '入库单位',
		field: 'PUomDesc',
		width: 80,
		hidden: (DefaUom == '0' ? false : true)
	}, {
		title: '进价',
		field: 'PRp',
		width: 80,
		align: 'right',
		hidden: (DefaUom == '0' ? false : true)
	}, {
		title: '售价',
		field: 'PSp',
		width: 80,
		align: 'right',
		hidden: (DefaUom == '0' ? false : true)
	}, {
		title: '库存量',
		field: 'PUomQty',
		width: 80,
		align: 'right',
		hidden: (DefaUom == '0' ? false : true)
	}, {
		title: '可用库存',
		field: 'PUomAvaQty',
		width: 80,
		align: 'right',
		hidden: (DefaUom == '0' ? false : true)
	}, {
		title: '请求科室库存（入库单位）',
		field: 'ReqPuomQty',
		width: 80,
		align: 'right',
		hidden: true
	}, {
		title: '备注',
		field: 'Remarks',
		width: 80
	}, {
		title: '高值',
		field: 'HVFlag',
		width: 40,
		formatter: BoolFormatter
	}, {
		title: '单位转换',
		field: 'PFac',
		width: 40,
		hidden: true
	}
	]];

	var IncItmGrid = $UI.datagrid('#IncItmGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
			QueryName: 'GetPhaOrderItemInfo',
			rows: 99999
		},
		checkOnSelect: true,
		selectOnCheck: true,
		pagination: false,
		columns: IncItmCm,
		singleSelect: false,
		onClickCell: function(index, filed, value) {
			IncItmGrid.commonClickCell(index, filed, value);
		},
		navigatingWithKey: true,
		onEndEdit: function(index, row, changes) {
			if (changes.hasOwnProperty('Qty')) {
				var Qty = Number(row.Qty);
				var PrvQty = '';
				if (DefaUom == '0') {
					PrvQty = Number(row.PUomAvaQty);
				} else {
					PrvQty = Number(row.BUomAvaQty);
				}
				if (!isEmpty(Qty)) {
					if (Qty <= 0) {
						$UI.msg('alert', '数量必须大于0!');
						$(this).datagrid('updateRow', {
							index: index,
							row: { Qty: '' }
						});
						return false;
					} else {
						if ((!isEmpty(Params.ReqModeLimited)) && (MoreThanStockFlag != 'Y') && (PrvQty < Qty)) {
							$UI.msg('alert', '数量不允许大于可用库存!');
							$(this).datagrid('updateRow', {
								index: index,
								row: { Qty: '' }
							});
							return false;
						} else {
							$('#IncItmGrid').datagrid('selectRow', index);
						}
					}
				}
			}
		}
	});
	
	Query();
};