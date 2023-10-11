function GetArcforLinkInci(Inci) {
	if (isEmpty(Inci)) {
		$UI.msg('alert', '请先选择要维护的库存项!');
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
				$UI.confirm('库存项已存在医嘱项关联，是否重新关联', 'question', '', ArcLink, '', '', '', '', ArcId);
			} else {
				ArcLink(ArcId);
			}
		}
	});
	function ArcLink(ArcId) {
		var Linked = tkMakeServerCall('web.DHCSTMHUI.ShowArcinfoForlinkInci', 'IfLinkInci', ArcId);
		if (Linked == 'Y') {
			$UI.msg('info', '此医嘱已经存在关联的库存项,请联系管理员处理!');
			return;
		}
		var Ret = tkMakeServerCall('web.DHCSTMHUI.ShowArcinfoForlinkInci', 'LinkInci', ArcId, Inci);
		if (Ret == 0) {
			$UI.msg('success', '关联成功!');
			$HUI.dialog('#LinkArcWin').close();
			GetDetail(Inci);
		} else {
			$UI.msg('error', '关联失败!');
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
			title: '是否可用',
			field: 'Flag',
			width: 150
		}, {
			title: '医嘱代码',
			field: 'ArcCode',
			width: 150
		}, {
			title: '医嘱名称',
			field: 'ArcDesc',
			width: 150
		}, {
			title: '账单单位',
			field: 'BillUom',
			width: 100
		}, {
			title: '计费项售价',
			field: 'TarPrice',
			width: 100,
			align: 'right'
		}, {
			title: '医嘱大类',
			field: 'OrdCat',
			width: 100
		}, {
			title: '医嘱子类',
			field: 'OrdSubCat',
			width: 100
		}, {
			title: '独立医嘱',
			field: 'OwnFlag',
			width: 100,
			align: 'cenrer'
		}, {
			title: '医保名称',
			field: 'InsuDesc',
			width: 100
		}, { title: '医嘱提示',
			field: 'OeMessage',
			width: 100
		}, {
			title: '收费项代码',
			field: 'TariCode',
			width: 100
		}, {
			title: '收费项名称',
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

// 取消医嘱项关联
function CancelArcLinkInci(Inci) {
	if (isEmpty(Inci)) {
		$UI.msg('alert', '请先选择要处理的库存项!');
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