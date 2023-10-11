/* ��ⵥ���*/
var init = function() {
	var M_Inci = '';
	var Clear = function() {
		$UI.clearBlock('#MainConditions');
		M_Inci = '';
		$UI.clear(InciGrid);
		$UI.clear(LinkBarGrid);
		$UI.clear(NotLinkBarGrid);
		// /���ó�ʼֵ ����ʹ������
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
			$UI.msg('alert', '��ѡ������!');
			return;
		}
		if (isEmpty(ParamsObj.RecLocId)) {
			$UI.msg('alert', '��ѡ�����!');
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
		text: '�����',
		iconCls: 'icon-no',
		handler: function() {
			bindcancel();
		}
	};
	var OkBT = {
		text: '��',
		iconCls: 'icon-ok',
		handler: function() {
			bindok();
		}
	};
	function bindok() {
		var RowsData = InciGrid.getSelections();
		if (RowsData.length <= 0) {
			$UI.msg('alert', '��ѡ��Ҫ�󶨵�����!');
			return false;
		}
		var Row = InciGrid.getSelected();
		var Inclb = Row.Inclb;
		if (Inclb == '') {
			$UI.msg('alert', '��ѡ��Ҫ�󶨵�����!');
			return false;
		}
		RowsData = NotLinkBarGrid.getSelections();
		// ��Ч����
		var count = 0;
		for (var i = 0; i < RowsData.length; i++) {
			var item = RowsData[i].dhcit;
			if (!isEmpty(item)) {
				count++;
			}
		}
		if (RowsData.length <= 0 || count <= 0) {
			$UI.msg('alert', '��ѡ��Ҫ�󶨵�����!');
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
			$UI.msg('alert', '��ѡ��Ҫ����󶨵�����!');
			return false;
		}
		var Row = InciGrid.getSelected();
		var Inclb = Row.Inclb;
		if (Inclb == '') {
			$UI.msg('alert', '��ѡ��Ҫ����󶨵�����!');
			return false;
		}
		RowsData = LinkBarGrid.getSelections();
		// ��Ч����
		var count = 0;
		for (var i = 0; i < RowsData.length; i++) {
			var item = RowsData[i].dhcit;
			if (!isEmpty(item)) {
				count++;
			}
		}
		
		if (RowsData.length <= 0 || count <= 0) {
			$UI.msg('alert', '��ѡ��Ҫ����󶨵�����!');
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
			Status = '����';
		} else if (value == 'Return') {
			Status = '�˻�';
		} else if (value == 'Used') {
			Status = '��ʹ��';
		} else if (value == 'InScrap') {
			Status = '����';
		} else if (value == 'InAdj') {
			Status = '����';
		} else if (value == '') {
			Status = 'ע��';
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
			title: '����',
			field: 'BatchNo',
			width: 120
		}, {
			title: 'Ч��',
			field: 'ExpDate',
			width: 120
		}, {
			title: '���ο��',
			field: 'InclbQty',
			width: 120
		}, {
			title: '��������',
			field: 'AvaQty',
			width: 120
		}, {
			title: '�Ѱ󶨿�����������',
			field: 'BindedEnableQty',
			width: 100
		}, {
			title: 'δ������',
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
			title: '��ֵ����',
			field: 'HVBarcode',
			width: 150
		}, {
			title: '����״̬',
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
			title: '��ֵ����',
			field: 'HVBarcode',
			width: 150
		}, {
			title: '����״̬',
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