// 名称:	退货供应商批次弹窗
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

var VendorIncItmBatWindow = function(Input, Params, Fn) {
	var BarCodeInfo = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCUDI',
		MethodName: 'UDIInfo',
		Code: Input
	}, false);
	// /"OrgBarCode^InciBarCode^Inci^Incib^BatchNo^ExpDate^ProduceDate^SerialNo"	
	$HUI.dialog('#VendorIncItmBatWindow', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
	var Loc = Params.Locdr, Vendor = Params.InclbVendor, ZeroFlag = Params.ZeroFlag;

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
		{ title: '生产厂家', field: 'ManfName', width: 160 },
		{ title: '入库单位', field: 'PUomDesc', width: 70 },
		{ title: '进价(入库单位)', field: 'PRp', width: 110, align: 'right' },
		{ title: '售价(入库单位)', field: 'PSp', width: 110, align: 'right' },
		{ title: '数量(入库单位)', field: 'PUomQty', width: 110, align: 'right' },
		{ title: '基本单位', field: 'BUomDesc', width: 80 },
		{ title: '进价(基本单位)', field: 'BRp', width: 110, align: 'right' },
		{ title: '售价(基本单位)', field: 'BSp', width: 110, align: 'right' },
		{ title: '数量(基本单位)', field: 'BUomQty', width: 110, align: 'right' },
		{ title: '账单单位', field: 'BillUomDesc', width: 80 },
		{ title: '进价(账单单位)', field: 'BillRp', width: 110, align: 'right' },
		{ title: '售价(账单单位)', field: 'BillSp', width: 110, align: 'right' },
		{ title: '数量(账单单位)', field: 'BillUomQty', width: 110, align: 'right' },
		{ title: '不可用', field: 'NotUseFlag', width: 80, formatter: BoolFormatter },
		{ title: '国家医保编码', field: 'MatInsuCode', width: 100 },
		{ title: '国家医保名称', field: 'MatInsuDesc', width: 100 }
	]];
	var StrParam;
	if (BarCodeInfo.Inci) {
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
		columns: IncItmBatMasterCm,
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
				$(IncItmBatMasterGrid.getPanel().find('div.datagrid-body .editcls')[0]).focus();
			}
		},
		onSelect: function(index, row) {
			$UI.clear(IncItmBatDetailGrid);
			var Inci = row['InciDr'];
			var BatchNo = '', ExpDate = '';
			if (BarCodeInfo.Inci) {
				BatchNo = BarCodeInfo.BatchNo;
				ExpDate = BarCodeInfo.ExpDate;
			}
			var ParamsObj = { Inci: Inci, Loc: Loc, ZeroFlag: ZeroFlag, Vendor: Vendor, BatchNo: BatchNo, ExpDate: ExpDate };
			IncItmBatDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRet',
				QueryName: 'GdRecItmToRet',
				query2JsonStrict: 1,
				Params: JSON.stringify(ParamsObj)
			});
		},
		navigateHandler: {
			up: function(targetIndex) {},
			down: function(targetIndex) {},
			enter: function(selectedData) {
				if (IncItmBatDetailGrid.getRows().length > 0) {
					IncItmBatDetailGrid.selectRow(0);
				}
			}
		}
	});

	var IncItmBatDetailCm = [[
		{ field: 'Code', title: '代码', width: 120,
			formatter: function(value, rec) {
				var btn = '<a style="opacity:0.0;border:none;" class="editcls" href="javascript:void(0)"></a>' + value;
				return btn;
			}
		},
		{ field: 'Description', title: '名称', width: 150 },
		{ field: 'Inci', title: 'Inci', width: 60, hidden: true },
		{ field: 'ManfName', title: '生产厂家', width: 120 },
		{ field: 'BatNo', title: '批号', width: 100 },
		{ field: 'ExpDate', title: '效期', width: 100 },
		{ field: 'SpecDesc', title: '具体规格', width: 100, hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true },
		{ field: 'Ingri', title: 'Ingri', width: 60, hidden: true },
		{ field: 'Inclb', title: 'Inclb', width: 100, hidden: true },
		{ field: 'RecQty', title: '入库数量', width: 80, align: 'right' },
		{ field: 'IDate', title: '入库时间', width: 100 },
		// { field: 'StkQty', title: '库存数量', width: 100, align: 'right' },		//库存数量,调整后=可退数量,显示冗余
		{ field: 'IngriLeftQty', title: '可退数量', width: 80, align: 'right' },
		{ field: 'Uom', title: '单位Id', width: 100, hidden: true },
		{ field: 'UomDesc', title: '单位', width: 60 },
		{ field: 'Rp', title: '进价', width: 80, align: 'right' },
		{ field: 'Sp', title: '售价', width: 80, align: 'right' },
		{ field: 'InvNo', title: '发票号', width: 100 },
		{ field: 'InvDate', title: '发票日期', width: 100 },
		{ field: 'InvAmt', title: '发票金额', width: 80 },
		{ field: 'VendorDesc', title: '供应商', width: 100 },
		{ field: 'ConFac', title: '转换系数', width: 80, hidden: true },
		{ field: 'BUom', title: 'BUom', width: 80, hidden: true },
		{ field: 'PConFac', title: 'PConFac', width: 80, hidden: true },
		{ title: '医用耗材代码', field: 'MatInsuCode', width: 100 }
	]];

	var IncItmBatDetailGrid = $UI.datagrid('#IncItmBatDetailGrid', {
		lazy: true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRet',
			QueryName: 'GdRecItmToRet',
			query2JsonStrict: 1
		},
		idField: 'Inclb',
		columns: IncItmBatDetailCm,
		navigatingWithKey: true,
		onSelect: function(index, row) {
			if (index == 0) {
				var MainRow = $('#IncItmBatMasterGrid').datagrid('getSelected');
				var MainIndex = $('#IncItmBatMasterGrid').datagrid('getRowIndex', MainRow);
				$(IncItmBatMasterGrid.getPanel().find('div.datagrid-body .editcls')[MainIndex]).blur();
				$(IncItmBatDetailGrid.getPanel().find('div.datagrid-body .editcls')[0]).focus();
			}
		},
		navigateHandler: {
			up: function(targetIndex) {},
			down: function(targetIndex) {},
			enter: function(selectedData) {
				ReturnInclbData();
			}
			
		},
		onClickRow: function(index, row) {
			IncItmBatDetailGrid.commonClickRow(index, row);
		},
		onDblClickRow: function(index, row) {
			var InciRow = IncItmBatMasterGrid.getSelected();
			$.extend(row, InciRow);
			Fn(row);
			$HUI.dialog('#VendorIncItmBatWindow').close();
		}
	});

	$UI.linkbutton('#IncItmBatSelBT', {
		onClick: function() {
			ReturnInclbData();
		}
	});

	function ReturnInclbData() {
		var InciRow = IncItmBatMasterGrid.getSelected();
		var row = IncItmBatDetailGrid.getSelected();
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择入库批次信息!');
			return;
		}
		$.extend(row, InciRow);
		Fn(row);
		$HUI.dialog('#VendorIncItmBatWindow').close();
	}
};