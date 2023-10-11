/* 入库单审核*/
var init = function() {
	var M_Inci = '';
	var Clear = function() {
		$UI.clearBlock('#MainConditions');
		M_Inci = '';
		$UI.clear(InciGrid);
		$UI.clear(LinkBarGrid);
		$UI.clear(NotLinkBarGrid);
		// /设置初始值 考虑使用配置
		var DefaultData = {
			RecLocId: gLocObj,
			notzero: 'Y'
		};
		$UI.fillBlock('#MainConditions', DefaultData);
	};
	var FRecLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var FRecLocBox = $HUI.combobox('#RecLocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FRecLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var HandlerParams = function() {
		var Scg = $('#ScgStk').combotree('getValue');
		var Obj = { StkGrpRowId: Scg, StkGrpType: 'M' };
		return Obj;
	};
	$('#inciDesc').lookup(InciLookUpOp(HandlerParams, '#inciDesc', '#Inci'));
	
	function Query() {
		var ParamsObj = $CommonUI.loopBlock('#MainConditions');
		var inci = ParamsObj.Inci;
		if (isEmpty(ParamsObj.Inci)) {
			$UI.msg('alert', '请选择物资!');
			return;
		}
		if (isEmpty(ParamsObj.RecLocId)) {
			$UI.msg('alert', '请选择科室!');
			return;
		}
		$UI.clear(InciGrid);
		$UI.clear(LinkBarGrid);
		$UI.clear(NotLinkBarGrid);
		
		var Params = JSON.stringify(ParamsObj);
		InciGrid.load({
			ClassName: 'web.DHCSTMHUI.BindInclbBarcode',
			QueryName: 'GetInclbInfo',
			query2JsonStrict: 1,
			Params: Params
		});
		NotLinkBarGrid.load({
			ClassName: 'web.DHCSTMHUI.BindInclbBarcode',
			QueryName: 'GetBarcodes',
			query2JsonStrict: 1,
			inclb: inci,
			nullStatus: 'Y'
		});
	}
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	var cancelBT = {
		text: '解除绑定',
		iconCls: 'icon-no',
		handler: function() {
			bindcancel();
		}
	};
	var OkBT = {
		text: '绑定',
		iconCls: 'icon-ok',
		handler: function() {
			bindok();
		}
	};
	function bindok() {
		var RowsData = InciGrid.getSelections();
		if (RowsData.length <= 0) {
			$UI.msg('alert', '请选择要绑定的批次!');
			return false;
		}
		var Row = InciGrid.getSelected();
		var Inclb = Row.Inclb;
		if (Inclb == '') {
			$UI.msg('alert', '请选择要绑定的批次!');
			return false;
		}
		RowsData = NotLinkBarGrid.getSelections();
		// 有效行数
		var count = 0;
		for (var i = 0; i < RowsData.length; i++) {
			var item = RowsData[i].dhcit;
			if (!isEmpty(item)) {
				count++;
			}
		}
		if (RowsData.length <= 0 || count <= 0) {
			$UI.msg('alert', '请选择要绑定的条码!');
			return false;
		}
		RowsData = NotLinkBarGrid.getSelectedData();
		$.cm({
			ClassName: 'web.DHCSTMHUI.BindInclbBarcode',
			MethodName: 'Save',
			Inclb: Inclb,
			len: RowsData.length,
			ListData: JSON.stringify(RowsData)
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	function bindcancel() {
		var RowsData = InciGrid.getSelections();
		if (RowsData.length <= 0) {
			$UI.msg('alert', '请选择要解除绑定的批次!');
			return false;
		}
		var Row = InciGrid.getSelected();
		var Inclb = Row.Inclb;
		if (Inclb == '') {
			$UI.msg('alert', '请选择要解除绑定的批次!');
			return false;
		}
		RowsData = LinkBarGrid.getSelections();
		// 有效行数
		var count = 0;
		for (var i = 0; i < RowsData.length; i++) {
			var item = RowsData[i].dhcit;
			if (!isEmpty(item)) {
				count++;
			}
		}
		
		if (RowsData.length <= 0 || count <= 0) {
			$UI.msg('alert', '请选择要解除绑定的条码!');
			return false;
		}
		RowsData = LinkBarGrid.getSelectedData();
		$.cm({
			ClassName: 'web.DHCSTMHUI.BindInclbBarcode',
			MethodName: 'Cancel',
			Inclb: Inclb,
			len: RowsData.length,
			ListData: JSON.stringify(RowsData)
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	function statusRenderer(value) {
		var Status = value;
		if (value == 'Enable') {
			Status = '可用';
		} else if (value == 'Return') {
			Status = '退货';
		} else if (value == 'Used') {
			Status = '已使用';
		} else if (value == 'InScrap') {
			Status = '报损';
		} else if (value == 'InAdj') {
			Status = '调整';
		} else if (value == '') {
			Status = '注册';
		} else {
			Status = value;
		}
		return Status;
	}
	var InciMainCm = [[
		{
			title: 'Inclb',
			field: 'Inclb',
			width: 100,
			hidden: true
		}, {
			title: '批号',
			field: 'BatchNo',
			width: 120
		}, {
			title: '效期',
			field: 'ExpDate',
			width: 120
		}, {
			title: '批次库存',
			field: 'InclbQty',
			width: 120
		}, {
			title: '可用数量',
			field: 'AvaQty',
			width: 120
		}, {
			title: '已绑定可用条码数量',
			field: 'BindedEnableQty',
			width: 100
		}, {
			title: '未绑定数量',
			field: 'BindQty',
			width: 100
		}
	]];
	var InciGrid = $UI.datagrid('#InciGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.BindInclbBarcode',
			QueryName: 'GetInclbInfo',
			query2JsonStrict: 1
		},
		columns: InciMainCm,
		showBar: false,
		onSelect: function(index, row) {
			LinkBarGrid.load({
				ClassName: 'web.DHCSTMHUI.BindInclbBarcode',
				QueryName: 'GetBarcodes',
				query2JsonStrict: 1,
				inclb: row.Inclb,
				nullStatus: 'N'
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				InciGrid.selectRow(0);
			}
		}
	});
	
	var LinkBarCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'dhcit',
			field: 'dhcit',
			width: 100,
			hidden: true
		}, {
			title: '高值条码',
			field: 'HVBarcode',
			width: 150
		}, {
			title: '条码状态',
			field: 'Status',
			width: 150,
			formatter: statusRenderer
		}
	]];
	
	var LinkBarGrid = $UI.datagrid('#LinkBarGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.BindInclbBarcode',
			QueryName: 'GetBarcodes',
			query2JsonStrict: 1
		},
		singleSelect: false,
		columns: LinkBarCm,
		fitColumns: true,
		displayMsg: '',
		showBar: false,
		toolbar: [cancelBT]
	});
	
	var NotLinkBarCm = [[
		{
			field: 'ck2',
			checkbox: true
		}, {
			title: 'dhcit',
			field: 'dhcit',
			width: 100,
			hidden: true
		}, {
			title: '高值条码',
			field: 'HVBarcode',
			width: 150
		}, {
			title: '条码状态',
			field: 'Status',
			width: 150,
			formatter: statusRenderer
		}
	]];
	
	var NotLinkBarGrid = $UI.datagrid('#NotLinkBarGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.BindInclbBarcode',
			QueryName: 'QueryItmTrackItem',
			query2JsonStrict: 1
		},
		singleSelect: false,
		columns: NotLinkBarCm,
		fitColumns: true,
		showBar: false,
		toolbar: [OkBT]
	});
	
	Clear();
};
$(init);