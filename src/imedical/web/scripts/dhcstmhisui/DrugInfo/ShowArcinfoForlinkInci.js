function GetArcforLinkInci(Inci) {
	if (isEmpty(Inci)) {
		$UI.msg('alert', '����ѡ��Ҫά���Ŀ����!');
		return;
	}
	var Clear = function() {
		$UI.clearBlock('#ArcConditions');
		$UI.clear(ArcGrid);
		var DefaultData = {};
		$UI.fillBlock('#LinkArcWin', DefaultData);
	};
	$HUI.dialog('#LinkArcWin', { width: gWinWidth, height: gWinHeight }).open();
	$UI.linkbutton('#ArcQueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#ArcConditions');
			var Params = JSON.stringify(ParamsObj);
			ArcGrid.load({
				ClassName: 'web.DHCSTMHUI.ShowArcinfoForlinkInci',
				QueryName: 'getArcinfo',
				query2JsonStrict: 1,
				Params: Params
			});
		}
	});
	$UI.linkbutton('#ArcLinkBT', {
		onClick: function() {
			var ArcId = ArcGrid.getSelected().ArcId;
			var InciLinked = tkMakeServerCall('web.DHCSTMHUI.ShowArcinfoForlinkInci', 'IfInciLinkArc', Inci);
			if (InciLinked == 'Y') {
				$UI.confirm('������Ѵ���ҽ����������Ƿ����¹���', 'question', '', ArcLink, '', '', '', '', ArcId);
			} else {
				ArcLink(ArcId);
			}
		}
	});
	function ArcLink(ArcId) {
		var Linked = tkMakeServerCall('web.DHCSTMHUI.ShowArcinfoForlinkInci', 'IfLinkInci', ArcId);
		if (Linked == 'Y') {
			$UI.msg('info', '��ҽ���Ѿ����ڹ����Ŀ����,����ϵ����Ա����!');
			return;
		}
		var Ret = tkMakeServerCall('web.DHCSTMHUI.ShowArcinfoForlinkInci', 'LinkInci', ArcId, Inci);
		if (Ret == 0) {
			$UI.msg('success', '�����ɹ�!');
			$HUI.dialog('#LinkArcWin').close();
			GetDetail(Inci);
		} else {
			$UI.msg('error', '����ʧ��!');
		}
	}
	$UI.linkbutton('#ArcClearBT', {
		onClick: function() {
			Clear();
		}
	});
	$HUI.combobox('#LinkOrdCatBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrdCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			LinkOrdSubCatBox.clear();
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrdSubCat&ResultSetType=array&OrdCat=' + record.RowId;
			LinkOrdSubCatBox.reload(url);
		}
	});
	var LinkOrdSubCatBox = $HUI.combobox('#LinkOrdSubCatBox', {
		valueField: 'RowId',
		textField: 'Description'
	});
	var ArcCm = [[
		{
			title: 'ArcId',
			field: 'ArcId',
			width: 150,
			hidden: true
		}, {
			title: '�Ƿ����',
			field: 'Flag',
			width: 150
		}, {
			title: 'ҽ������',
			field: 'ArcCode',
			width: 150
		}, {
			title: 'ҽ������',
			field: 'ArcDesc',
			width: 150
		}, {
			title: '�˵���λ',
			field: 'BillUom',
			width: 100
		}, {
			title: '�Ʒ����ۼ�',
			field: 'TarPrice',
			width: 100,
			align: 'right'
		}, {
			title: 'ҽ������',
			field: 'OrdCat',
			width: 100
		}, {
			title: 'ҽ������',
			field: 'OrdSubCat',
			width: 100
		}, {
			title: '����ҽ��',
			field: 'OwnFlag',
			width: 100,
			align: 'cenrer'
		}, {
			title: 'ҽ������',
			field: 'InsuDesc',
			width: 100
		}, { title: 'ҽ����ʾ',
			field: 'OeMessage',
			width: 100
		}, {
			title: '�շ������',
			field: 'TariCode',
			width: 100
		}, {
			title: '�շ�������',
			field: 'TariDesc',
			width: 100
		}
	]];
	var ArcGrid = $UI.datagrid('#LinkArcGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ShowArcinfoForlinkInci',
			QueryName: 'getArcinfo',
			query2JsonStrict: 1
		},
		columns: ArcCm,
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	Clear();
}

// ȡ��ҽ�������
function CancelArcLinkInci(Inci) {
	if (isEmpty(Inci)) {
		$UI.msg('alert', '����ѡ��Ҫ����Ŀ����!');
		return;
	}
	showMask();
	$.cm({
		ClassName: 'web.DHCSTMHUI.ShowArcinfoForlinkInci',
		MethodName: 'jsCancelLinkInci',
		InciId: Inci
	}, function(jsonData) {
		hideMask();
		if (jsonData.success == 0) {
			$UI.msg('success', jsonData.msg);
			GetDetail(Inci);
		} else {
			$UI.msg('error', jsonData.msg);
		}
	});
}