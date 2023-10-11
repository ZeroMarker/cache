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
var IncItmBathvWindow = function(Input, Params, Fn) {
	$HUI.dialog('#IncItmBathvWindow').open();
	var gRowArr = [];
	var ProLocId = Params['Locdr'], ReqLocId = Params['ToLoc'];
	var IntrType = Params['IntrType'] || '';
	var QtyFlagBat = Params['QtyFlagBat'] || '0';
	var gInciRowIndex, gInciRow;
	$UI.linkbutton('#IncItmBathvSelBT', {
		onClick: function() {
			ReturnInclbHVData();
		}
	});
	
	$UI.linkbutton('#IncItmBathvSearchBT', {
		onClick: function() {
			var SelectedRow = IncItmBathvMasterGrid.getSelected();
			var InciDr = SelectedRow['InciDr'];
			var ParamsObj1 = { InciDr: InciDr, ProLocId: ProLocId, ReqLocId: ReqLocId, QtyFlag: QtyFlagBat };
			var ParamsObj2 = $UI.loopBlock('#HVWinConditions');
			var Params = JSON.stringify(jQuery.extend(true, ParamsObj1, ParamsObj2));
			IncItmBathvDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
				MethodName: 'GetDrugHVBatInfo',
				Params: Params
			});
		}
	});

	var IncItmBatHvMasterCm = [[
		// {field: 'ck', checkbox: true },
		{ title: 'Incil', field: 'Incil', width: 80, hidden: true, editor: 'text' },
		{ title: 'InciDr', field: 'InciDr', hidden: true, width: 140 },
		{ title: '代码', field: 'InciCode', width: 140 },
		{ title: '名称', field: 'InciDesc', width: 200 },
		{ title: '规格', field: 'Spec', width: 100 },
		{ title: '型号', field: 'Model', width: 100 },
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
		{ title: '不可用', field: 'NotUseFlag', hidden: true, width: 50, align: 'center', formatter: BoolFormatter },
		{ title: '国家医保编码', field: 'MatInsuCode', width: 100 },
		{ title: '国家医保名称', field: 'MatInsuDesc', width: 100 }
	]];
	var StrParam = JSON.stringify(addSessionParams(Params));
	var IncItmBathvMasterGrid = $UI.datagrid('#IncItmBathvMasterGrid', {
		lazy: false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
			MethodName: 'GetPhaOrderItemInfo',
			StrParam: StrParam,
			q: Input
		},
		columns: IncItmBatHvMasterCm,
		onSelect: function(index, row) {
			gInciRowIndex = index, gInciRow = row;
			var InciDr = row['InciDr'];
			var ParamsObj = { InciDr: InciDr, ProLocId: ProLocId, ReqLocId: ReqLocId, QtyFlag: QtyFlagBat };
			IncItmBathvDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
				MethodName: 'GetDrugHVBatInfo',
				Params: JSON.stringify(ParamsObj)
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				IncItmBathvMasterGrid.selectRow(0);
			}
		}
	});

	var IncItmBathvDetailCm = [[{ field: 'ck', checkbox: true },
		{ title: '批次RowID', field: 'Inclb', width: 100, hidden: true, editor: 'text' },
		{ title: 'InciDr', field: 'InciDr', width: 200, hidden: true, align: 'left' },
		{ title: 'dhcit', field: 'dhcit', width: 200, hidden: true, align: 'left' },
		{ title: '批次~效期', field: 'BatExp', width: 200, align: 'left' },
		{ title: '高值条码', field: 'HVBarCode', width: 200, align: 'left' },
		{ title: '具体规格', field: 'SpecDesc', width: 100, align: 'left' },
		{ title: '业务数量', field: 'OperQty', width: 90, align: 'right' },
		{ title: '供应商', field: 'VendorName', width: 120 },
		{ title: '生产厂家', field: 'Manf', width: 180 },
		{ title: '单位', field: 'PurUomDesc', width: 80 },
		{ title: '批次售价', field: 'BatSp', width: 60, align: 'right' },
		{ title: '请求数量', field: 'ReqQty', width: 80, align: 'right' },
		{ title: '基本单位RowId', field: 'BUomId', width: 80, hidden: true },
		{ title: '基本单位', field: 'BUomDesc', width: 80 },
		{ title: '进价', field: 'Rp', width: 60, align: 'right' },
		{ title: '货位码', field: 'StkBin', width: 100 },
		{ title: '供应方库存', field: 'SupplyStockQty', width: 100, align: 'right' },
		{ title: '供应方可用库存', field: 'SupplyAvaStockQty', width: 100, align: 'right' },
		{ title: '请求方库存', field: 'RequrstStockQty', width: 100, align: 'right' },
		{ title: '转换率', field: 'ConFac', width: 60, align: 'center' },
		{ title: '高值标志', field: 'HVFlag', width: 60, align: 'center' },
		{ title: '锁定标志', field: 'RecallFlag', width: 60, align: 'center' },
		{ title: '灭菌批号', field: 'SterilizedBat', width: 100 }
	]];
	var IncItmBathvDetailGrid = $UI.datagrid('#IncItmBathvDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
			MethodName: 'GetDrugHVBatInfo'
		},
		singleSelect: false,
		columns: IncItmBathvDetailCm,
		onDblClickRow: function(index, row) {
			ReturnInclbHVData();
		}
	});

	function ReturnInclbHVData() {
		var rows = IncItmBathvDetailGrid.getSelections();
		if (rows.length == 0) {
			$UI.msg('alert', '请选择需要出库的明细！');
		} else {
			Fn(rows);
			$HUI.dialog('#IncItmBathvWindow').close();
		}
	}
};