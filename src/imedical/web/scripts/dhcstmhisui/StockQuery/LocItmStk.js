/* ����ѯ*/
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
		data: [{ 'RowId': '', 'Description': 'ȫ��' }, { 'RowId': '����', 'Description': '����' }, { 'RowId': '����', 'Description': '����' }, { 'RowId': '����', 'Description': '����' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var StockTypeBox = $HUI.combobox('#StockType', {
		data: [{ 'RowId': 0, 'Description': 'ȫ��' }, { 'RowId': 1, 'Description': '���Ϊ��' }, { 'RowId': 2, 'Description': '���Ϊ��' }, { 'RowId': 3, 'Description': '���Ϊ��' }, { 'RowId': 4, 'Description': '������' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var SupervisionBox = $HUI.combobox('#Supervision', {
		data: [{ 'RowId': '', 'Description': 'ȫ��' }, { 'RowId': 'I', 'Description': 'I' }, { 'RowId': 'II', 'Description': 'II' }, { 'RowId': 'III', 'Description': 'III' }],
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
	// 68����
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
			title: '���ʴ���',
			field: 'InciCode',
			sortable: true,
			width: 100
		}, {
			title: '��������',
			field: 'InciDesc',
			sortable: true,
			width: 200
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '�ͺ�',
			field: 'Model',
			width: 100,
			hidden: true
		}, {
			title: '��λ',
			field: 'StkBinId',
			width: 90,
			formatter: CommonFormatter(StkBinBox, 'StkBinId', 'StkBin'),
			editor: StkBinBox
		}, {
			title: '���(��װ��λ)',
			field: 'PurStockQty',
			width: 120,
			hidden: true,
			align: 'right'
		}, {
			title: '���(������λ)',
			field: 'StockQty',
			width: 120,
			sortable: true,
			align: 'right'
		}, {
			title: '������λ',
			field: 'BUomDesc',
			width: 80
		}, {
			title: '��ⵥλ',
			field: 'PurUomDesc',
			width: 80
		}, {
			title: '���(��ⵥλ)',
			field: 'StkQtyUom',
			width: 100,
			align: 'right'
		}, {
			title: 'δ��������',
			field: 'UnexpiredQty',
			width: 100,
			align: 'right'
		}, {
			title: 'ռ�ÿ��',
			field: 'DirtyQty',
			width: 100,
			align: 'right'
		}, {
			title: '��;���',
			field: 'ReservedQty',
			width: 100,
			align: 'right'
		}, {
			title: '���ÿ��',
			field: 'AvaQty',
			width: 100,
			align: 'right'
		}, {
			title: '������',
			field: 'BarCodeCount',
			width: 80,
			align: 'right'
		}, {
			title: '���ۼ�',
			field: 'Sp',
			width: 80,
			sortable: true,
			align: 'right'
		}, {
			title: '���½���',
			field: 'Rp',
			width: 80,
			sortable: true,
			align: 'right'
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 120,
			align: 'right'
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 120,
			align: 'right'
		}, {
			title: '��������',
			field: 'ManfDesc',
			width: 150
		}, {
			title: 'ҽ�����',
			field: 'OfficalCode',
			hidden: true,
			width: 80
		}, {
			title: '�ص��ע',
			field: 'ManFlag',
			width: 80,
			formatter: BoolFormatter
		}, {
			title: '��ֵ��־',
			field: 'HVFlag',
			width: 60,
			formatter: BoolFormatter
		}, {
			title: '�б깩Ӧ��',
			field: 'VendorDesc',
			width: 160
		}, {
			title: '������⹩Ӧ��',
			field: 'LastVenDesc',
			width: 160
		}, {
			title: '����ҽ������',
			field: 'MatInsuCode',
			width: 160
		}, {
			title: '����ҽ������',
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
		totalFooter: '"InciDesc":"�ϼ�"',
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
							$UI.confirm('ȷ��ͬ��"' + IncCode + ' ' + IncDesc + '"��棿', 'question', '', function() {
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
		if (Detail === false) {	// δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Detail)) {	// ��ϸ����
			$UI.msg('alert', 'û����Ҫ�������ϸ!');
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
		if (Detail === false) {	// δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Detail)) {	// ��ϸ����
			$UI.msg('alert', 'û����Ҫ�������ϸ!');
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
			title: '����',
			field: 'BatNo',
			width: 180
		}, {
			title: 'Ч��',
			field: 'ExpDate',
			width: 100
		}, {
			title: '������',
			field: 'SpecDesc',
			width: 100,
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: '���ο��',
			field: 'QtyUom',
			width: 90,
			align: 'right'
		}, {
			title: '����ռ��',
			field: 'DirtyQty',
			width: 70,
			align: 'right'
		}, {
			title: '������;',
			field: 'ReservedQty',
			width: 70,
			align: 'right'
		}, {
			title: '���ο��ÿ��',
			field: 'AvaQty',
			width: 100,
			align: 'right'
		}, {
			title: '������',
			field: 'BarCodeCount',
			width: 80,
			align: 'right'
		}, {
			title: '����(������λ)',
			field: 'BRp',
			width: 120,
			align: 'right'
		}, {
			title: '����(��װ��λ)',
			field: 'PRp',
			width: 120,
			align: 'right'
		}, {
			title: '�ۼ�(������λ)',
			field: 'BSp',
			width: 120,
			align: 'right'
		}, {
			title: '�ۼ�(��װ��λ)',
			field: 'PSp',
			width: 120,
			align: 'right'
		}, {
			title: '��Ӧ��',
			field: 'Vendor',
			width: 180
		}, {
			title: '��������',
			field: 'Manf',
			width: 180
		}, {
			title: '�������',
			field: 'IngrDate',
			width: 100,
			hidden: true
		}, {
			title: '��ⵥ��',
			field: 'IngrNo',
			width: 150,
			hidden: true
		}, {
			title: '������',
			field: 'IngrLocDesc',
			width: 120,
			hidden: true
		}, {
			title: '˰��(������λ)',
			field: 'BTax',
			width: 120,
			align: 'right'
		}, {
			title: '������',
			field: 'BarCode',
			width: 180
		}, {
			title: '������־',
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
			$UI.msg('alert', '���ڲ���Ϊ��!');
			return;
		}

		if (isEmpty(ParamsObj.StockType)) {
			$UI.msg('alert', '���Ͳ���Ϊ��!');
			return;
		}
		if (isEmpty(ParamsObj.PhaLoc)) {
			$UI.msg('alert', '���Ҳ���Ϊ��!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(StkQtyGrid);
		$UI.clear(BatGrid);
		StkQtyGrid.load({
			ClassName: 'web.DHCSTMHUI.LocItmStk',
			MethodName: 'LocItmStkDetail',
			Params: Params,
			totalFooter: '"InciDesc":"�ϼ�"',
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
		$UI.msg('alert', '���ڲ���Ϊ��!');
		return;
	}

	if (isEmpty(ParamsObj.StockType)) {
		$UI.msg('alert', '���Ͳ���Ϊ��!');
		return;
	}
	if (isEmpty(ParamsObj.PhaLoc)) {
		$UI.msg('alert', '���Ҳ���Ϊ��!');
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