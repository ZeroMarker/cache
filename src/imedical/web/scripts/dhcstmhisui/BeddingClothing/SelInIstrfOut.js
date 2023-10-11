var SelInIsTrfOut = function(Fn) {
	$HUI.dialog('#TransWin', { width: gWinWidth, height: gWinHeight }).open();
	
	$UI.linkbutton('#TransQueryBT', {
		onClick: function() {
			FindTransQuery();
		}
	});
	function FindTransQuery() {
		$UI.clear(TransDetailGrid);
		$UI.clear(TransMasterGrid);
		var ParamsObj = $UI.loopBlock('#TransConditions');
		ParamsObj.FrLoc = $('#InitToLoc').combobox('getValue');
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '开始日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.FrLoc)) {
			$UI.msg('alert', '库房不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.Status)) {
			ParamsObj.Status = '31';
		}
		var Params = JSON.stringify(ParamsObj);
		TransMasterGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'DHCINIsTrfM',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	$UI.linkbutton('#TransSaveBT', {
		onClick: function() {
			var Row = TransMasterGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要保存的单据!');
			}
			Params = JSON.stringify(addSessionParams({ Init: Row.RowId }));
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
				MethodName: 'jsCreateInIsTrf',
				Params: Params
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					Fn(jsonData.rowid);
					$HUI.dialog('#TransWin').close();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	function Clear() {
		$UI.clearBlock('#TransConditions');
		$UI.clear(TransMasterGrid);
		$UI.clear(TransDetailGrid);
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate()
		};
		$UI.fillBlock('#TransConditions', DefaultData);
	}
	
	TransLocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	var TransLocBox = $HUI.combobox('#TransLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + TransLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var TransMasterCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '单号',
			field: 'InitNo',
			align: 'left',
			editor: 'text',
			width: 150,
			sortable: true
		}, {
			title: '来源科室',
			field: 'FrLocDesc',
			width: 150,
			sortable: true
		}, {
			title: '接收科室',
			field: 'ToLocDesc',
			width: 150
		}, {
			title: '制单时间',
			field: 'InitDateTime',
			width: 150
		}, {
			title: '类组',
			field: 'ScgDesc',
			width: 150
		}
	]];
	
	var TransMasterGrid = $UI.datagrid('#TransMasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'DHCINIsTrfM',
			query2JsonStrict: 1
		},
		columns: TransMasterCm,
		onSelect: function(index, row) {
			var Init = row['RowId'];
			var ParamsObj = { Init: Init, InitType: 'T' };
			$UI.clear(TransDetailGrid);
			TransDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
				QueryName: 'DHCINIsTrfD',
				query2JsonStrict: 1,
				Params: JSON.stringify(ParamsObj)
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				TransMasterGrid.selectRow(0);
			}
		}
	});
	var TransDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 120
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 180
		}, {
			title: '转移数量',
			field: 'Qty',
			align: 'right',
			width: 80
		}, {
			title: '规格',
			field: 'Spec',
			width: 80
		}, {
			title: '批号~效期',
			field: 'BatExp',
			width: 200
		}, {
			title: '生产厂家',
			field: 'ManfDesc',
			width: 160
		}, {
			title: '批次库存',
			field: 'InclbQty',
			align: 'right',
			width: 80
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 50
		}, {
			title: '进价',
			field: 'Rp',
			align: 'right',
			width: 80
		}, {
			title: '售价',
			field: 'Sp',
			align: 'right',
			width: 80
		}, {
			title: '进价金额',
			field: 'RpAmt',
			align: 'right',
			width: 80
		}, {
			title: '售价金额',
			field: 'SpAmt',
			align: 'right',
			width: 80
		}, {
			title: '占用数量',
			field: 'InclbDirtyQty',
			align: 'right',
			width: 100
		}, {
			title: '可用数量',
			field: 'InclbAvaQty',
			align: 'right',
			width: 100
		}
	]];

	var TransDetailGrid = $UI.datagrid('#TransDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfD',
			query2JsonStrict: 1
		},
		columns: TransDetailCm,
		remoteSort: false
	});
	
	Clear();
	FindTransQuery();
};