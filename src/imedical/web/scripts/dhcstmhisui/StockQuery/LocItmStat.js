/*库存统计*/
var init = function () {
	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			QueryStockQty();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			StockQtyClear();
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function () {
			PrintDetail();
		}
	});
	var PhaLocParams = JSON.stringify(addSessionParams({ Type: "All" }));
	var PhaLocBox = $HUI.combobox('#PhaLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PhaLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onChange: function (e) {
			init(e);
		}
	});
	var VendorParams = JSON.stringify(addSessionParams({ APCType: "M", RcFlag: "Y" }));
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var PhManufacturerParams = JSON.stringify(addSessionParams({ StkType: "M" }));
	var PhManufacturerBox = $HUI.combobox('#PhManufacturer', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + PhManufacturerParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams = function () {
		var Scg = $("#StkGrpId").combotree('getValue');
		var Loc = $("#PhaLoc").combo('getValue');
		var Obj = { StkGrpRowId: Scg, StkGrpType: "M", Locdr: Loc };
		return Obj
	}
	$("#InciDesc").lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	$('#StkGrpId').stkscgcombotree({
		onSelect: function (node) {
			$.cm({
				ClassName: 'web.DHCSTMHUI.Common.Dicts',
				QueryName: 'GetStkCat',
				ResultSetType: 'array',
				StkGrpId: node.id
			}, function (data) {
				StkCatBox.clear();
				StkCatBox.loadData(data);
			})
		}
	});
	var StkCatBox = $HUI.combobox('#StkCat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var HvFlagBox = $HUI.combobox('#HvFlag', {
		data: [{ 'RowId': '', 'Description': '全部' }, { 'RowId': 'Y', 'Description': '高值' }, { 'RowId': 'N', 'Description': '非高值' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var ManageDrugFlagBox = $HUI.combobox('#ManageDrugFlag', {
		data: [{ 'RowId': '', 'Description': '全部' }, { 'RowId': '1', 'Description': '重点关注' }, { 'RowId': '0', 'Description': '非重点关注' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var StockTypeBox = $HUI.combobox('#StockType', {
		data: [{ 'RowId': '', 'Description': '全部' }, { 'RowId': '1', 'Description': '库存为零' }, { 'RowId': '4', 'Description': '库存非零' }, { 'RowId': '2', 'Description': '库存为正' }, { 'RowId': '3', 'Description': '库存为负' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	function init(LocId) {
		var LocManGrpBox = $HUI.combobox('#LocManGrp', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocManGrp&ResultSetType=array&LocId=' + LocId,
			valueField: 'RowId',
			textField: 'Description'
		});
		var StkBinParams = JSON.stringify(addSessionParams({ LocDr: LocId }));
		var StkBinBox = $HUI.combobox('#StkBin', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocStkBin&ResultSetType=array&Params=' + StkBinParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	}
	var StockQtyCm = [[{
		title: "Incil",
		field: 'Incil',
		width: 20,
		hidden: true
	}, {
		title: '物资代码',
		field: 'InciCode',
		width: 100
	}, {
		title: "物资名称",
		field: 'InciDesc',
		width: 200
	}, {
		title: "规格",
		field: 'Spec',
		width: 100
	}, {
		title: "货位",
		field: 'StkBin',
		width: 90
	}, {
		title: '库存(包装单位)',
		field: 'PurStockQty',
		width: 120,
		hidden: true,
		align: 'right'
	}, {
		title: "包装单位",
		field: 'PurUomDesc',
		width: 80
	}, {
		title: "库存(基本单位)",
		field: 'StockQty',
		width: 120,
		align: 'right'
	}, {
		title: "基本单位",
		field: 'BUomDesc',
		width: 80
	}, {
		title: "零售价",
		field: 'Sp',
		width: 80,
		align: 'right'
	}, {
		title: "最新进价",
		field: 'Rp',
		width: 80,
		align: 'right'
	}, {
		title: '售价金额',
		field: 'SpAmt',
		width: 120,
		align: 'right'
	}, {
		title: '进价金额',
		field: 'RpAmt',
		width: 120,
		align: 'right'
	}, {
		title: '厂商',
		field: 'ManfDesc',
		width: 150
	}, {
		title: "重点关注",
		field: 'ManFlag',
		width: 80,
		align: 'center',
		formatter: BoolFormatter
	}, {
		title: "供应商",
		field: 'Vendor',
		width: 160
	}, {
		title: "价格变化",
		field: 'RpChangeFlag',
		width: 100
	}
	]];

	var StkQtyGrid = $UI.datagrid('#StkQtyGrid', {
		lazy: true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmStkStat',
			MethodName: 'ItmStkStat'
		},
		columns: StockQtyCm,
		totalFooter:'"InciCode":"合计"',
		totalFields: 'InciDesc,RpAmt,SpAmt',
		showFooter:true,
		showBar: true,
		pagination: false,
		onClickCell: function (index, filed, value) {
			StkQtyGrid.commonClickCell(index, filed, value);
		}
	})
	var BatQtyCm = [[{
		title: "Inclb",
		field: 'Inclb',
		width: 80,
		hidden: true
	}, {
		title: "INCIRowID",
		field: 'Inci',
		width: 80,
		hidden: true
	}, {
		title: '物资代码',
		field: 'InciCode',
		width: 100
	}, {
		title: "物资名称",
		field: 'InciDesc',
		width: 200
	}, {
		title: "规格",
		field: 'Spec',
		width: 100
	}, {
		title: "货位",
		field: 'StkBin',
		width: 90
	}, {
		title: '批号',
		field: 'BatNo',
		width: 180
	}, {
		title: "有效期",
		field: 'ExpDate',
		width: 100
	}, {
		title: '库存(包装单位)',
		field: 'PurStockQty',
		width: 120,
		hidden: true,
		align: 'right'
	}, {
		title: "包装单位",
		field: 'PurUomDesc',
		width: 80
	}, {
		title: "库存(基本单位)",
		field: 'StockQty',
		width: 120,
		align: 'right'
	}, {
		title: "基本单位",
		field: 'BUomDesc',
		width: 80
	}, {
		title: '批次进价',
		field: 'inclbRp',
		width: 100,
		align: 'right'
	}, {
		title: "零售价",
		field: 'Sp',
		width: 90,
		align: 'right'
	}, {
		title: "最新进价",
		field: 'Rp',
		width: 70,
		align: 'right'
	}, {
		title: "售价金额",
		field: 'SpAmt',
		width: 70,
		align: 'right'
	}, {
		title: "进价金额",
		field: 'RpAmt',
		width: 100,
		align: 'right'
	}, {
		title: '厂商',
		field: 'ManfDesc',
		width: 120
	}, {
		title: "供应商",
		field: 'Vendor',
		width: 120
	}, {
		title: "重点关注",
		field: 'ManFlag',
		width: 90,
		align: 'center',
		formatter: BoolFormatter
	}
	]];

	var BatQtyGrid = $UI.datagrid('#BatQtyGrid', {
		lazy: true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmStkStat',
			MethodName: 'ItmStkStatbyBat'
		},
		idField: 'Inclb',
		columns: BatQtyCm,
		showBar: true,
		totalFooter:'"InciCode":"合计"',
		totalFields: 'InciDesc,RpAmt,SpAmt',
		showFooter: true,
		pagination: false,
		singleSelect: false,
		onClickCell: function (index, filed, value) {
			BatQtyGrid.commonClickCell(index, filed, value);
		}
	})
	var StockRpQtyCm = [[{
		title: "inclb",
		field: 'inclb',
		width: 20,
		hidden: true
	}, {
		title: 'Inci',
		field: 'Inci',
		width: 100,
		hidden: true
	}, {
		title: '物资代码',
		field: 'InciCode',
		width: 100
	}, {
		title: "物资名称",
		field: 'InciDesc',
		width: 200
	}, {
		title: "规格",
		field: 'Spec',
		width: 100
	}, {
		title: "货位",
		field: 'StkBin',
		width: 90
	}, {
		title: '库存(包装单位)',
		field: 'PurStockQty',
		width: 120,
		hidden: true
	}, {
		title: "包装单位",
		field: 'PurUomDesc',
		width: 80
	}, {
		title: "库存(基本单位)",
		field: 'StockQty',
		width: 120
	}, {
		title: "基本单位",
		field: 'BUomDesc',
		width: 80
	}, {
		title: "零售价",
		field: 'Sp',
		width: 80,
		align: 'right'
	}, {
		title: "进价",
		field: 'Rp',
		width: 80,
		align: 'right'
	}, {
		title: '售价金额',
		field: 'SpAmt',
		width: 120,
		align: 'right'
	}, {
		title: '进价金额',
		field: 'RpAmt',
		width: 120,
		align: 'right'
	}, {
		title: '厂商',
		field: 'ManfDesc',
		width: 150
	}, {
		title: "重点关注",
		field: 'ManFlag',
		width: 80,
		align: 'center',
		formatter: BoolFormatter
	}, {
		title: "供应商",
		field: 'Vendor',
		width: 160
	}
	]];

	var StockRpQtyGrid = $UI.datagrid('#StockRpQtyGrid', {
		lazy: true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmStkStat',
			MethodName: 'ItmStkStatbyRp'
		},
		columns: StockRpQtyCm,
		showBar: true,
		pagination: false,
		totalFooter:'"InciCode":"合计"',
		totalFields: 'InciDesc,RpAmt,SpAmt',
		showFooter: true,
		onClickCell: function (index, filed, value) {
			StockRpQtyGrid.commonClickCell(index, filed, value);
		}
	})
	function QueryStockQty() {
		var ParamsObj = $UI.loopBlock('#Conditions')
		var Params = JSON.stringify(ParamsObj);
		var UseTypeObj = $UI.loopBlock('#FindConditions');
		var UseType = JSON.stringify(UseTypeObj);
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.PhaLoc)) {
			$UI.msg('alert', '科室不能为空!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		var currTab = $('#LocItmStatTab').tabs('getSelected');
		if (currTab.panel('options').title == '项目明细') {
			StkQtyGrid.load({
				ClassName: 'web.DHCSTMHUI.LocItmStkStat',
				MethodName: 'ItmStkStat',
				StrParam: Params,
				Usetype: UseType
			});
		}
		if (currTab.panel('options').title == '批次明细') {
			BatQtyGrid.load({
				ClassName: 'web.DHCSTMHUI.LocItmStkStat',
				MethodName: 'ItmStkStatbyBat',
				StrParam: Params,
				Usetype: UseType
			});
		}
		if (currTab.panel('options').title == '项目价格明细') {
			StockRpQtyGrid.load({
				ClassName: 'web.DHCSTMHUI.LocItmStkStat',
				MethodName: 'ItmStkStatbyRp',
				StrParam: Params,
				Usetype: UseType
			});
		}
	}
	$HUI.tabs("#LocItmStatTab", {
		onSelect: function (title) {
			QueryStockQty();
		}
	});
	function PrintDetail() {
		var ParamsObj = $UI.loopBlock('#Conditions')
		var Params = JSON.stringify(ParamsObj);
		StrPar = encodeUrlStr(Params);
		var UseTypeObj = $UI.loopBlock('#FindConditions');
		var UseType = JSON.stringify(UseTypeObj);
		UseType = encodeUrlStr(UseType);
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.PhaLoc)) {
			$UI.msg('alert', '科室不能为空!');
			return;
		}
		//获取查询条件列表
		var Conditions = "";
		if (ParamsObj.PhaLoc != "") {
			Conditions = "科室: " + $("#PhaLoc").combobox('getText');
		}
		if (ParamsObj.StkGrpId != "") {
			Conditions = Conditions + " 类组: " + $("#StkGrpId").combobox('getText');
		}
		if (ParamsObj.StkCat != "") {
			Conditions = Conditions + " 库存分类: " + $("#StkCat").combobox('getText');
		}
		if (ParamsObj.PhManufacturer != "") {
			Conditions = Conditions + " 厂商: " + $("#PhManufacturer").combobox('getText');
		}
		if (ParamsObj.LocManGrp != "") {
			Conditions = Conditions + " 管理组: " + $("#LocManGrp").combobox('getText');
		}
		if (ParamsObj.StkBin != "") {
			Conditions = Conditions + " 货位码: " + $("#StkBin").combobox('getText');
		}
		var currTab = $('#LocItmStatTab').tabs('getSelected');
		if (currTab.panel('options').title == '项目明细') {
			var RaqName = 'DHCSTM_HUI_ItmLocStk.raq';
			var fileName = "{" + RaqName + "(strParam=" + StrPar + "&Usetype=" + UseType + "&Conditions=" + Conditions + ")}";
			//transfileName = TranslateRQStr(fileName);
			//DHCCPM_RQPrint(transfileName)
			DHCCPM_RQDirectPrint(fileName);
		} else { 
			var RaqName = 'DHCSTM_HUI_ItmLocStkItm.raq';
			var fileName = "{" + RaqName + "(strParam=" + StrPar + "&Usetype=" + UseType + "&Conditions=" + Conditions + ")}";
			//transfileName = TranslateRQStr(fileName);
			//DHCCPM_RQPrint(transfileName)
			DHCCPM_RQDirectPrint(fileName);
		}
	}
	function StockQtyClear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(StkQtyGrid);
		$UI.clear(BatQtyGrid);
		$UI.clear(StockRpQtyGrid);
		var Dafult = {
			StartDate: DateFormatter(new Date()),
			PhaLoc: gLocObj,
			UseTime: 6,
			NotUseTime: 6,
			UseFlag: 'Y'
		};
		var Default = {
			UseTime: 6,
			NotUseTime: 6,
			UseFlag: 'Y'
		};
		$UI.fillBlock('#Conditions', Dafult);
		$UI.fillBlock('#FindConditions', Default);
	}
	StockQtyClear();
	QueryStockQty();
}
$(init);