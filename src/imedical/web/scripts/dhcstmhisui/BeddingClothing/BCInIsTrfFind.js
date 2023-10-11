// InOutFlag(转入转出标志:转入1,转出0), Fn
var BCInIsTrfFind = function(InOutFlag, Fn) {
	$HUI.dialog('#FindWin', { width: gWinWidth, height: gWinHeight }).open();
	
	$UI.linkbutton('#FQueryBT', {
		onClick: function() {
			FindQuery();
		}
	});
	function FindQuery() {
		$UI.clear(FDetailGrid);
		$UI.clear(FMasterGrid);
		var ParamsObj = $UI.loopBlock('#FindConditions');
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '开始日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		if (InOutFlag == 0) {
			if (isEmpty(ParamsObj.FrLoc)) {
				$UI.msg('alert', '出库科室不能为空!');
				return;
			}
		} else {
			if (isEmpty(ParamsObj.ToLoc)) {
				$UI.msg('alert', '库房不能为空!');
				return;
			}
		}
		if (isEmpty(ParamsObj.Status)) {
			ParamsObj.Status = '10,11,20,30';
		}
		var Params = JSON.stringify(ParamsObj);
		FMasterGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'DHCINIsTrfM',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	$UI.linkbutton('#FComBT', {
		onClick: function() {
			var Row = FMasterGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要返回的单据!');
			}
			Fn(Row['RowId']);
			$HUI.dialog('#FindWin').close();
		}
	});
	
	$UI.linkbutton('#FClearBT', {
		onClick: function() {
			Clear();
		}
	});
	function Clear() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(FMasterGrid);
		$UI.clear(FDetailGrid);
		
		if (InOutFlag == 0) {
			var deflocObj = { RowId: $('#InitFrLoc').combobox('getValue'), Description: $('#InitFrLoc').combobox('getText') };
			var DefaultData = {
				StartDate: DefaultStDate(),
				EndDate: DefaultEdDate(),
				FrLoc: deflocObj
			};
		} else {
			var deflocObj = { RowId: $('#InitToLoc').combobox('getValue'), Description: $('#InitToLoc').combobox('getText') };
			var DefaultData = {
				StartDate: DefaultStDate(),
				EndDate: DefaultEdDate(),
				ToLoc: deflocObj
			};
		}
		$UI.fillBlock('#FindConditions', DefaultData);
	}
	var FReqLocParams, FInitFrLocParams;
	if (InOutFlag == 0) {
		FReqLocParams = JSON.stringify(addSessionParams({ Type: 'All', Element: 'FReqLoc' }));
		FInitFrLocParams = JSON.stringify(addSessionParams({ Type: 'Login', Element: 'FInitFrLoc' }));
	} else {
		FReqLocParams = JSON.stringify(addSessionParams({ Type: 'Login', Element: 'FReqLoc' }));
		FInitFrLocParams = JSON.stringify(addSessionParams({ Type: 'All', Element: 'FInitFrLoc' }));
	}
	var FReqLocBox = $HUI.combobox('#FReqLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var FInitFrLocBox = $HUI.combobox('#FInitFrLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FInitFrLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var FStatusData;
	if (InOutFlag == 0) {
		FStatusData = [
			{ RowId: '', Description: '' },
			{ RowId: '10', Description: '未完成' },
			{ RowId: '11', Description: '已完成' },
			{ RowId: '20', Description: '出库审核不通过' }
		];
	} else {
		FStatusData = [
			{ RowId: '', Description: '' },
			{ RowId: '10', Description: '未完成' },
			{ RowId: '30', Description: '拒绝接收' }
		];
	}
	$('#FStatus').simplecombobox({
		data: FStatusData
	});
	
	var FMasterCm = [[
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
			title: '出库科室',
			field: 'FrLocDesc',
			width: 150,
			sortable: true
		}, {
			title: '接收科室',
			field: 'ToLocDesc',
			width: 150
		}, {
			title: '请求单号',
			field: 'ReqNo',
			width: 150
		}, {
			title: '制单时间',
			field: 'InitDateTime',
			width: 150
		}, {
			title: '出库类型',
			field: 'OperateTypeDesc',
			width: 80
		}, {
			title: '单据状态',
			field: 'StatusCode',
			width: 70
		}, {
			title: '制单人',
			field: 'UserName',
			width: 80
		}, {
			title: '进价金额',
			field: 'RpAmt',
			align: 'right',
			width: 100
		}, {
			title: '售价金额',
			field: 'SpAmt',
			align: 'right',
			width: 100
		}, {
			title: '进销差',
			field: 'MarginAmt',
			align: 'right',
			width: 100
		}, {
			title: '备注',
			field: 'Remark',
			width: 150
		}
	]];

	var FMasterGrid = $UI.datagrid('#FMasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'DHCINIsTrfM',
			query2JsonStrict: 1
		},
		columns: FMasterCm,
		onSelect: function(index, row) {
			var Init = row['RowId'];
			var ParamsObj = { Init: Init, InitType: 'T' };
			$UI.clear(FDetailGrid);
			FDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
				QueryName: 'DHCINIsTrfD',
				query2JsonStrict: 1,
				Params: JSON.stringify(ParamsObj)
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				FMasterGrid.selectRow(0);
			}
		},
		onDblClickRow: function(index, row) {
			Fn(row['RowId']);
			$HUI.dialog('#FindWin').close();
		}
	});

	var FDetailCm = [[
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
			title: '出库数量',
			field: 'Qty',
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
			title: '灭菌批号',
			field: 'SterilizedBat',
			width: 160
		}, {
			title: '请求数量',
			field: 'ReqQty',
			align: 'right',
			width: 80
		}, {
			title: '请求方库存',
			field: 'ReqLocStkQty',
			align: 'right',
			width: 100
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

	var FDetailGrid = $UI.datagrid('#FDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfD',
			query2JsonStrict: 1
		},
		columns: FDetailCm,
		remoteSort: false
	});
	
	Clear();
	FindQuery();
};