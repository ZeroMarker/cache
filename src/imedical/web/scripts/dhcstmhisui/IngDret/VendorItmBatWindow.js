// 名称:		退货供应商批次弹窗
// 编写者:	XuChao
// 编写日期:	2018-08-28

/**
 Input: 物资别名录入值
 StkGrpRowId：类组id
 StkGrpType：类组类型,G/M
 Locdr: 科室id
 Vendor: 供应商id
 VendorName: 供应商名称
 NotUseFlag：不可用标志
 QtyFlag：是否包含0库存项目,1-不包含/0-包含
 HospID：医院id
 ReqLoc: 请求科室id(请求科室id为空时，请求科室库存显示为空)
 Fn：回调函数
 */

var VendorIncItmBatWindow = function (Input, Params, Fn) {
	var BarCodeInfo=$.cm({
		ClassName: 'web.DHCSTMHUI.DHCUDI',
		MethodName: 'UDIInfo',
		Code:Input
	},false);
	///"OrgBarCode^InciBarCode^Inci^Incib^BatchNo^ExpDate^ProduceDate^SerialNo"	
	$HUI.dialog('#VendorIncItmBatWindow').open();
	var Loc = Params.Locdr, Vendor = Params.InclbVendor, ZeroFlag = Params.ZeroFlag;

	var IncItmBatMasterCm = [[
		{ checkbox: true },
		{ title: 'Incil', field: 'Incil', width: 80, hidden: true, editor: 'text' },
		{ title: '代码', field: 'InciCode', width: 140 },
		{ title: '名称', field: 'InciDesc', width: 200 },
		{ title: '规格', field: 'Spec', width: 100 },
		{ title: '厂商', field: 'ManfName', width: 160 },
		{ title: '入库单位', field: 'PUomDesc', width: 70 },
		{ title: '进价(入库单位)', field: 'PRp', width: 100, align: 'right' },
		{ title: '售价(入库单位)', field: 'PSp', width: 100, align: 'right' },
		{ title: '数量(入库单位)', field: 'PUomQty', width: 100, align: 'right' },
		{ title: '基本单位', field: 'BUomDesc', width: 80 },
		{ title: '进价(基本单位)', field: 'BRp', width: 100, align: 'right' },
		{ title: '售价(基本单位)', field: 'BSp', width: 100, align: 'right' },
		{ title: '数量(基本单位)', field: 'BUomQty', width: 100, align: 'right' },
		{ title: '计价单位', field: 'BillUomDesc', width: 80 },
		{ title: '进价(计价单位)', field: 'BillRp', width: 100, align: 'right' },
		{ title: '售价(计价单位)', field: 'BillSp', width: 100, align: 'right' },
		{ title: '数量(计价单位)', field: 'BillUomQty', width: 100, align: 'right' },
		{ title: '不可用', field: 'NotUseFlag', width: 45,formatter:function(value){
		if(value==0)
		return '否';
		else
		return '是';} 
		}
	]];
	var StrParam;
	if(BarCodeInfo.Inci){
		var _options=jQuery.extend(true,{},{BarCode:BarCodeInfo.InciBarCode},addSessionParams(Params));
		StrParam=JSON.stringify(_options)
		Input=""
	}else{
		StrParam=JSON.stringify(addSessionParams(Params))
	}
	var IncItmBatMasterGrid = $UI.datagrid('#IncItmBatMasterGrid', {
		lazy: false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
			MethodName: 'GetPhaOrderItemInfo',
			StrParam:StrParam,
			q: Input
		},
		columns: IncItmBatMasterCm,
		onSelect: function (index, row) {
			var Inci = row['InciDr'];
			var ParamsObj = { Inci: Inci, Loc: Loc, ZeroFlag: ZeroFlag, Vendor: Vendor,BatchNo:BarCodeInfo.BatchNo,ExpDate:BarCodeInfo.ExpDate  };
			IncItmBatDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRet',
				QueryName: 'GdRecItmToRet',
				Params: JSON.stringify(ParamsObj)
			});
		}
	});

	var IncItmBatDetailCm = [[
		{ field: 'Code', title: '代码', width: 120 },
		{ field: 'Description', title: '名称', width: 150 },
		{ field: 'Inci', title: 'Inci', width: 60, hidden: true },
		{ field: 'ManfName', title: '厂商', width: 120 },
		{ field: 'BatNo', title: '批号', width: 100 },
		{ field: 'ExpDate', title: '效期', width: 100 },
		{ field: 'Ingri', title: 'Ingri', width: 60, hidden: true },
		{ field: 'Inclb', title: 'Inclb', width: 100, hidden: true },
		{ field: 'RecQty', title: '入库数量', width: 60 },
		{ field: 'IDate', title: '入库时间', width: 100 },
		{ field: 'StkQty', title: '库存数量', width: 100 },
		{ field: 'Uom', title: '单位Id', width: 100, hidden: true },
		{ field: 'UomDesc', title: '单位', width: 60 },
		{ field: 'Rp', title: '进价', width: 100 },
		{ field: 'Sp', title: '售价', width: 60 },
		{ field: 'InvNo', title: '发票号', width: 100 },
		{ field: 'InvDate', title: '发票日期', width: 60 },
		{ field: 'InvAmt', title: '发票金额', width: 100 },
		{ field: 'VendorDesc', title: '供应商', width: 100 },
		{ field: 'ConFac', title: '转换系数', width: 100 },
		{ field: 'SpecDesc', title: '具体规格', width: 100 }
	]]

	var IncItmBatDetailGrid = $UI.datagrid('#IncItmBatDetailGrid', {
		lazy: true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRet',
			QueryName: 'GdRecItmToRet'
		},
		idField: 'Inclb',
		columns: IncItmBatDetailCm,
		onClickCell: function (index, field, value) {
			IncItmBatDetailGrid.commonClickCell(index, field);
		},
		onDblClickRow: function (index, row) {
			var InciRow = IncItmBatMasterGrid.getSelected();
			$.extend(row, InciRow);
			Fn(row);
			$HUI.dialog('#VendorIncItmBatWindow').close();
		}
	});

	$UI.linkbutton('#IncItmBatSelBT', {
		onClick: function () {
			ReturnInclbData();
		}
	});

	function ReturnInclbData() {
		var InciRow = IncItmBatMasterGrid.getSelected();
		var row = IncItmBatDetailGrid.getSelected();
		if(isEmpty(row)){
			$UI.msg("alert", "请选择入库批次信息!");
			return;
		}
		$.extend(row, InciRow);
		Fn(row);
		$HUI.dialog('#VendorIncItmBatWindow').close();
	}
}
