var G_CHAINID;
var G_CHAINManfId;
var ChainItmGrid;
function ChainItmWin(RowId, ChainManfId) {
	G_CHAINID = RowId;
	G_CHAINManfId = ChainManfId;
	$HUI.dialog('#ChainItmWin', { width: gWinWidth, height: gWinHeight }).open();
	var ParamsObj = { Parref: RowId };
	var Params = JSON.stringify(ParamsObj);
	ChainItmGrid.load({
		ClassName: 'web.DHCSTMHUI.SupplyChainItm',
		QueryName: 'QueryChainItm',
		query2JsonStrict: 1,
		Params: Params
	});
}

function InitChainItm() {
	$HUI.combobox('#ItmVendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='
			+ JSON.stringify(addSessionParams({ BDPHospital: gHospId }))
	});
	
	$HUI.combobox('#ItmManf', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params='
			+ JSON.stringify(addSessionParams({ BDPHospital: gHospId }))
	});
	
	var ItmHandlerParams = function() {
		var Obj = { StkGrpType: 'M', BDPHospital: gHospId };
		return Obj;
	};
	$('#ItmInciDesc').lookup(InciLookUpOp(ItmHandlerParams, '#ItmInciDesc', '#ItmInci'));
	
	$UI.linkbutton('#QueryUnLinkBT', {
		onClick: function() {
			QueryUnLinkInci();
		}
	});
	$UI.linkbutton('#ItmSaveBT', {
		onClick: function() {
			ItmSave();
		}
	});
	function QueryUnLinkInci() {
		var ParamsObj = $UI.loopBlock('#ChainItmMain');
		ParamsObj['ChainId'] = G_CHAINID;
		var Params = JSON.stringify(ParamsObj);
		UnLinkInciGrid.load({
			ClassName: 'web.DHCSTMHUI.SupplyChainItm',
			QueryName: 'QueryUnLinkInci',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	function ItmSave() {
		var Rows = UnLinkInciGrid.getSelectedData();
		if (Rows === false) {
			return;
		}
		var ListData = JSON.stringify(Rows);
		$.cm({
			ClassName: 'web.DHCSTMHUI.SupplyChainItm',
			MethodName: 'jsSave',
			Parref: G_CHAINID,
			ListData: ListData
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				ChainItmGrid.reload();
				UnLinkInciGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	var UnLinkInciCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'InciId',
			field: 'InciId',
			width: 100,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 120
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 180
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '��ⵥλ',
			field: 'PUomDesc',
			width: 80
		}, {
			title: '����',
			field: 'PRp',
			width: 100,
			align: 'right'
		}, {
			title: '��Ȩ��ID',
			field: 'ChainId',
			width: 80,
			hidden: true
		}, {
			title: '��Ȩ��',
			field: 'ChainCode',
			width: 100
		}, {
			title: '��������Rowid',
			field: 'ManfId',
			width: 100,
			hidden: true
		}
	]];
	
	var UnLinkInciGrid = $UI.datagrid('#UnLinkInciGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.SupplyChainItm',
			QueryName: 'QueryUnLinkInci',
			query2JsonStrict: 1
		},
		columns: UnLinkInciCm,
		fitColumns: true,
		singleSelect: false,
		pagination: true,
		onBeforeCheck: function(index, row) {
			var ChainId = row['ChainId'];
			var ManfId = row['ManfId'];
			if (ChainId == G_CHAINID) {
				$UI.msg('error', '�ѹ�����ǰ��Ȩ��!');
				return false;
			} else if (!isEmpty(ChainId)) {
				$UI.msg('alert', '�˺Ĳ��ѹ���������Ȩ��, ���������!');
			}
			if (!isEmpty(ManfId) && (ManfId != G_CHAINManfId)) {
				$UI.msg('error', '��Ʒ������������Ȩ�鳧�Ҳ�һ��,��������Ȩ!');
				return false;
			}
		}
	});
	
	$UI.linkbutton('#CancelLinkBT', {
		onClick: function() {
			var Rows = ChainItmGrid.getSelectedData();
			if (!isEmpty(Rows)) {
				$UI.confirm('����Ҫȡ����Ȩ�����,�Ƿ����?', '', '', CancelLink);
			}
		}
	});
	function CancelLink() {
		var Rows = ChainItmGrid.getSelectedData();
		if (isEmpty(Rows)) {
			return;
		}
		var ListData = JSON.stringify(Rows);
		$.cm({
			ClassName: 'web.DHCSTMHUI.SupplyChainItm',
			MethodName: 'jsCancel',
			ListData: ListData
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				ChainItmGrid.reload();
				QueryUnLinkInci();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	var ChainItmCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 120
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 150
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}
	]];
	
	ChainItmGrid = $UI.datagrid('#ChainItmGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.SupplyChainItm',
			QueryName: 'QueryChainItm',
			query2JsonStrict: 1
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.SupplyChainItm',
			MethodName: 'DeleteChain'
		},
		columns: ChainItmCm,
		fitColumns: true,
		singleSelect: false,
		pagination: true,
		onDblClickRow: function(index, row) {
			// var RowId = row['RowId'];
			// ChainDetailWin(RowId);
		}
	});
	
	$HUI.dialog('#ChainItmWin', {
		width: gWinWidth,
		height: gWinHeight,
		onOpen: function() {
			$UI.clearBlock('#ChainItmMain');
			$UI.clear(ChainItmGrid);
			$UI.clear(UnLinkInciGrid);
		}
	});
}
$(InitChainItm);