
var FindWin = function(Fn, StatusFlag, HvFlag) {
	if (StatusFlag == undefined) {
		StatusFlag = '';
	}
	if (HvFlag == undefined) {
		HvFlag = '';
	}
	
	var Clear = function() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(FMasterGrid);
		$UI.clear(FDetailGrid);
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate()
		};
		$UI.fillBlock('#FindConditions', DefaultData);
	};
	$HUI.dialog('#FindWin', { width: gWinWidth, height: gWinHeight }).open();
	
	$UI.linkbutton('#FQueryBT', {
		onClick: function() {
			FindQuery();
		}
	});
	function FindQuery() {
		var ParamsObj = $UI.loopBlock('#FindConditions');
		ParamsObj.ToLoc = $('#InitToLoc').combobox('getValue');
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '开始日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.ToLoc)) {
			$UI.msg('alert', '库房不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.Status)) {
			ParamsObj.Status = '10,11,20';
		}
		ParamsObj.HVFlag = HvFlag;
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(FDetailGrid);
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

	var FReqLocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	var FReqLocBox = $HUI.combobox('#FReqLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var FStatus = $HUI.combobox('#FStatus', {
		valueField: 'RowId',
		textField: 'Description',
		data: [
			{ 'RowId': '10', 'Description': '未完成' },
			{ 'RowId': '11', 'Description': '已完成' },
			{ 'RowId': '20', 'Description': '出库审核不通过' },
			{ 'RowId': '30', 'Description': '拒绝接收' }
		]
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
			title: '退库科室',
			field: 'FrLocDesc',
			width: 150,
			sortable: true
		}, {
			title: '库房',
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
		showBar: true,
		onSelect: function(index, row) {
			var Init = row['RowId'];
			var ParamsObj = { Init: Init, InitType: 'T' };
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
			title: '高值条码',
			field: 'HVBarCode',
			width: 150
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
		showBar: true,
		remoteSort: false
	});
	
	Clear();
	FindQuery();
};