/* 库存查询*/
var CodeMainParamObj = GetAppPropValue('DHCSTDRUGMAINTAINM');
var init = function() {
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			QueryStockQty();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			StockQtyClear();
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			StockQtyPrint();
		}
	});
	var PhaLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var PhaLocBox = $HUI.combobox('#PhaLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PhaLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$HUI.combotree('#StkGrpId').setFilterByLoc(LocId);
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
	var PhManufacturerParams = JSON.stringify(addSessionParams({ StkType: 'M' }));
	var PhManufacturerBox = $HUI.combobox('#PhManufacturer', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + PhManufacturerParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$('#StkGrpId').stkscgcombotree({
		onSelect: function(node) {
			$.cm({
				ClassName: 'web.DHCSTMHUI.Common.Dicts',
				QueryName: 'GetStkCat',
				ResultSetType: 'array',
				StkGrpId: node.id
			}, function(data) {
				StkCatBox.clear();
				StkCatBox.loadData(data);
			});
			if (CommParObj.ApcScg == 'S') {
				VendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M' }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params + '&ScgId=' + node.id ;
				VendorBox.reload(url);
			}
		}
	});
	var StkCatBox = $HUI.combobox('#StkCat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams = function() {
		var StkGrpId = $('#StkGrpId').combotree('getValue');
		var PhaLoc = $('#PhaLoc').combo('getValue');
		var Obj = { StkGrpRowId: StkGrpId, StkGrpType: 'M', Locdr: PhaLoc };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	var InsuTypeParams = JSON.stringify(addSessionParams());
	var InsuTypeBox = $HUI.combobox('#InsuType', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInsuCat&ResultSetType=array&Params=' + InsuTypeParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var LocManGrpBox = $HUI.combobox('#LocManGrp', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocManGrp&ResultSetType=array&LocId=' + gLocId,
		valueField: 'RowId',
		textField: 'Description'
	});
	var ARCItemCatBox = $HUI.combobox('#ARCItemCat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrdSubCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var INFOImportFlagBox = $HUI.combobox('#INFOImportFlag', {
		data: [{ 'RowId': '', 'Description': '全部' }, { 'RowId': '国产', 'Description': '国产' }, { 'RowId': '进口', 'Description': '进口' }, { 'RowId': '合资', 'Description': '合资' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var StockTypeBox = $HUI.combobox('#StockType', {
		data: [{ 'RowId': 0, 'Description': '全部' }, { 'RowId': 1, 'Description': '库存为零' }, { 'RowId': 2, 'Description': '库存为正' }, { 'RowId': 3, 'Description': '库存为负' }, { 'RowId': 4, 'Description': '库存非零' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var SupervisionBox = $HUI.combobox('#Supervision', {
		data: [{ 'RowId': '', 'Description': '全部' }, { 'RowId': 'I', 'Description': 'I' }, { 'RowId': 'II', 'Description': 'II' }, { 'RowId': 'III', 'Description': 'III' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var StkBinBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocStkBin&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ LocDr: $('#PhaLoc').combobox('getValue'), BDPHospital: gHospId }));
			}
		}
	};
	// 68分类
	var Official = $HUI.combotree('#Official', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&MethodName=GetMCOChildNode&NodeId=AllMCO&Params=' + gHospId,
		valueField: 'id',
		textField: 'text',
		editable: true
	});
	$('#Official').parent().find('.combo-text').blur(function() {
		$('#Official').combotree('clear');
	});
	var ClinicalCatlParams = JSON.stringify(addSessionParams());
	/*
	$HUI.lookup('#ClinicalCat', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetClinicCat',
			Params: ClinicalCatlParams,
			rows: 9999
		}
	});
	*/
	var ClinicalCat = $HUI.combobox('#ClinicalCat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetClinicCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			ClinicalCat.clear();
			var Params = JSON.stringify(addSessionParams({ BDPHospital: GetHospId() }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetClinicCat&ResultSetType=array&Params=' + Params;
			ClinicalCat.reload(url);
		}
	});
	var StockQtyCm = [[
		{
			title: 'INCILRowID',
			field: 'Incil',
			width: 60,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			sortable: true,
			width: 100
		}, {
			title: '物资名称',
			field: 'InciDesc',
			sortable: true,
			width: 200
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '型号',
			field: 'Model',
			width: 100,
			hidden: true
		}, {
			title: '货位',
			field: 'StkBinId',
			width: 90,
			formatter: CommonFormatter(StkBinBox, 'StkBinId', 'StkBin'),
			editor: StkBinBox
		}, {
			title: '库存(包装单位)',
			field: 'PurStockQty',
			width: 120,
			hidden: true,
			align: 'right'
		}, {
			title: '库存(基本单位)',
			field: 'StockQty',
			width: 120,
			sortable: true,
			align: 'right'
		}, {
			title: '基本单位',
			field: 'BUomDesc',
			width: 80
		}, {
			title: '入库单位',
			field: 'PurUomDesc',
			width: 80
		}, {
			title: '库存(入库单位)',
			field: 'StkQtyUom',
			width: 100,
			align: 'right'
		}, {
			title: '未过期数量',
			field: 'UnexpiredQty',
			width: 100,
			align: 'right'
		}, {
			title: '占用库存',
			field: 'DirtyQty',
			width: 100,
			align: 'right'
		}, {
			title: '在途库存',
			field: 'ReservedQty',
			width: 100,
			align: 'right'
		}, {
			title: '可用库存',
			field: 'AvaQty',
			width: 100,
			align: 'right'
		}, {
			title: '条码数',
			field: 'BarCodeCount',
			width: 80,
			align: 'right'
		}, {
			title: '零售价',
			field: 'Sp',
			width: 80,
			sortable: true,
			align: 'right'
		}, {
			title: '最新进价',
			field: 'Rp',
			width: 80,
			sortable: true,
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
			title: '生产厂家',
			field: 'ManfDesc',
			width: 150
		}, {
			title: '医保类别',
			field: 'OfficalCode',
			hidden: true,
			width: 80
		}, {
			title: '重点关注',
			field: 'ManFlag',
			width: 80,
			formatter: BoolFormatter
		}, {
			title: '高值标志',
			field: 'HVFlag',
			width: 60,
			formatter: BoolFormatter
		}, {
			title: '招标供应商',
			field: 'VendorDesc',
			width: 160
		}, {
			title: '最新入库供应商',
			field: 'LastVenDesc',
			width: 160
		}, {
			title: '国家医保编码',
			field: 'MatInsuCode',
			width: 160
		}, {
			title: '国家医保名称',
			field: 'MatInsuDesc',
			width: 160
		}
	]];

	var StkQtyGrid = $UI.datagrid('#StkQtyGrid', {
		lazy: true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmStk',
			MethodName: 'LocItmStkDetail'
		},
		idField: 'Incil',
		columns: StockQtyCm,
		showBar: true,
		toolbar: '#StkTB',
		showFooter: true,
		totalFooter: '"InciDesc":"合计"',
		totalFields: 'RpAmt,SpAmt',
		onSelect: function(index, row) {
			QueryBatInfo();
		},
		onClickCell: function(index, field, value) {
			StkQtyGrid.commonClickCell(index, field);
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		},
		onRowContextMenu: function(e, index, row) {
			e.preventDefault();
			$(this).datagrid('selectRow', index);
			var ParamsObj = $UI.loopBlock('#Conditions');
			var Date = ParamsObj.StartDate;
			var Incil = row.Incil;
			var IncCode = row.InciCode;
			var IncDesc = row.InciDesc;
			$('#StkQtyRightMenu').menu({
				onClick: function(item) {
					switch (item.name) {
						case 'TransMoveInfo' :
							TransQuery(Incil, Date);
							break;
						case 'HVBarcodeInfo' :
							HVBarcodeQuery(Incil);
							break;
						case 'SynIncilData' :
							$UI.confirm('确定同步"' + IncCode + ' ' + IncDesc + '"库存？', 'question', '', function() {
								$.cm({
									ClassName: 'web.DHCSTMHUI.LocItmStk',
									MethodName: 'SynIncilStkQty',
									incil: Incil
								}, function(jsonData) {
									if (jsonData.success === 0) {
										$UI.msg('success', jsonData.msg);
									} else {
										$UI.msg('error', jsonData.msg);
									}
								});
							});
							break;
						case 'ClrResQtyLocInci':
							ClrLocInciResQty(Incil);
							break;
						case 'ReservedQtyInfo' :
							ReservedQtyQuery(Incil);
							break;
					}
				}
			}).menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		}
	});
	function ClrLocInciResQty(Incil) {
		$.cm({
			ClassName: 'web.DHCSTMHUI.LocItmStk',
			MethodName: 'ClrLocInciResQty',
			Incil: Incil
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				QueryStockQty();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	$UI.linkbutton('#InclbFilterBtn', {
		onClick: function() {
			QueryBatInfo();
		}
	});
	function QueryBatInfo() {
		var row = StkQtyGrid.getSelected();
		if (isEmpty(row)) {
			return;
		}
		var ParamsObj = $UI.loopBlock('#Conditions');
		var BatParamsObj = $UI.loopBlock('#BatTB');
		BatParamsObj['Vendor'] = ParamsObj['Vendor'];
		BatParamsObj['StartDate'] = ParamsObj['StartDate'];
		BatGrid.load({
			ClassName: 'web.DHCSTMHUI.LocItmStk',
			MethodName: 'Batch',
			StrParam: JSON.stringify(BatParamsObj),
			InciParam: row.Incil
		});
	}
	$UI.linkbutton('#Save', {
		onClick: function() {
			Save();
		}
	});
	function Save() {
		var Detail = BatGrid.getChangesData();
		if (Detail === false) {	// 未完成编辑或明细为空
			return;
		}
		if (isEmpty(Detail)) {	// 明细不变
			$UI.msg('alert', '没有需要保存的明细!');
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.ItmBatLock',
			MethodName: 'SaveRecallFlag',
			ListData: JSON.stringify(Detail)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				BatGrid.commonReload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	$UI.linkbutton('#SaveStkBin', {
		onClick: function() {
			SaveStkBin();
		}
	});
	function SaveStkBin() {
		var Detail = StkQtyGrid.getChangesData();
		if (Detail === false) {	// 未完成编辑或明细为空
			return;
		}
		if (isEmpty(Detail)) {	// 明细不变
			$UI.msg('alert', '没有需要保存的明细!');
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.LocItmStk',
			MethodName: 'JsSaveStkBin',
			Detail: JSON.stringify(Detail)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				StkQtyGrid.commonReload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var BatchCm = [[
		{
			title: 'Inclb',
			field: 'Inclb',
			width: 80,
			hidden: true
		}, {
			title: '批号',
			field: 'BatNo',
			width: 180
		}, {
			title: '效期',
			field: 'ExpDate',
			width: 100
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			width: 100,
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: '批次库存',
			field: 'QtyUom',
			width: 90,
			align: 'right'
		}, {
			title: '批次占用',
			field: 'DirtyQty',
			width: 70,
			align: 'right'
		}, {
			title: '批次在途',
			field: 'ReservedQty',
			width: 70,
			align: 'right'
		}, {
			title: '批次可用库存',
			field: 'AvaQty',
			width: 100,
			align: 'right'
		}, {
			title: '条码数',
			field: 'BarCodeCount',
			width: 80,
			align: 'right'
		}, {
			title: '进价(基本单位)',
			field: 'BRp',
			width: 120,
			align: 'right'
		}, {
			title: '进价(包装单位)',
			field: 'PRp',
			width: 120,
			align: 'right'
		}, {
			title: '售价(基本单位)',
			field: 'BSp',
			width: 120,
			align: 'right'
		}, {
			title: '售价(包装单位)',
			field: 'PSp',
			width: 120,
			align: 'right'
		}, {
			title: '供应商',
			field: 'Vendor',
			width: 180
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 180
		}, {
			title: '入库日期',
			field: 'IngrDate',
			width: 100,
			hidden: true
		}, {
			title: '入库单号',
			field: 'IngrNo',
			width: 150,
			hidden: true
		}, {
			title: '入库科室',
			field: 'IngrLocDesc',
			width: 120,
			hidden: true
		}, {
			title: '税额(基本单位)',
			field: 'BTax',
			width: 120,
			align: 'right'
		}, {
			title: '批次码',
			field: 'BarCode',
			width: 180
		}, {
			title: '锁定标志',
			field: 'RecallFlag',
			width: 100,
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }},
			align: 'center'
		}
	]];

	var BatGrid = $UI.datagrid('#BatGrid', {
		lazy: true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmStk',
			MethodName: 'Batch'
		},
		idField: 'Inclb',
		columns: BatchCm,
		showBar: true,
		toolbar: '#BatTB',
		onClickRow: function(index, row) {
			BatGrid.commonClickRow(index, row);
		},
		onRowContextMenu: function(e, index, row) {
			e.preventDefault();
			$(this).datagrid('selectRow', index);
			var ParamsObj = $UI.loopBlock('#Conditions');
			var Inclb = row.Inclb;
			var Date = ParamsObj.StartDate;
			$('#BatNoRightMenu').menu({
				onClick: function(item) {
					switch (item.name) {
						case 'DirtyQtyInfo' :
							DirtyQtyQuery(Inclb);
							break;
						case 'InclbHVBarcodeInfo' :
							HVBarcodeQuery(Inclb);
							break;
						case 'InclbTransMoveInfo' :
							TransQuery(Inclb, Date);
							break;
					}
				}
			}).menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		}
	});
	
	$('#BatTB').bind('keydown', function(e) {
		var theEvent = e || window.event;
		var code = theEvent.keyCode || theEvent.which || theEvent.charCode;
		if (code == 13) {
			QueryBatInfo();
		}
	});
	
	function QueryStockQty() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '日期不能为空!');
			return;
		}

		if (isEmpty(ParamsObj.StockType)) {
			$UI.msg('alert', '类型不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.PhaLoc)) {
			$UI.msg('alert', '科室不能为空!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(StkQtyGrid);
		$UI.clear(BatGrid);
		StkQtyGrid.load({
			ClassName: 'web.DHCSTMHUI.LocItmStk',
			MethodName: 'LocItmStkDetail',
			Params: Params,
			totalFooter: '"InciDesc":"合计"',
			totalFields: 'RpAmt,SpAmt'
		});
	}
	function StockQtyClear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(StkQtyGrid);
		$UI.clear(BatGrid);
		$UI.clearBlock('#BatTB');
		var DefaultData = {
			StartDate: DateFormatter(new Date()),
			PhaLoc: gLocObj,
			StockType: 4
		};
		$UI.fillBlock('#Conditions', DefaultData);
	}
	StockQtyClear();
};

function StockQtyPrint() {
	var ParamsObj = $UI.loopBlock('#Conditions');
	if (isEmpty(ParamsObj.StartDate)) {
		$UI.msg('alert', '日期不能为空!');
		return;
	}

	if (isEmpty(ParamsObj.StockType)) {
		$UI.msg('alert', '类型不能为空!');
		return;
	}
	if (isEmpty(ParamsObj.PhaLoc)) {
		$UI.msg('alert', '科室不能为空!');
		return;
	}
	var Params = JSON.stringify(ParamsObj);
	Paramstr = encodeUrlStr(Params);
	var RaqName = 'DHCSTM_HUI_LocItmStk_Common.raq';
	var fileName = '{' + RaqName + '(Params=' + Paramstr + ')}';
	transfileName = TranslateRQStr(fileName);
	DHCCPM_RQPrint(transfileName);
}

$(init);