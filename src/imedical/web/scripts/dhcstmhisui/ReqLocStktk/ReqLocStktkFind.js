var FindWin = function(Fn) {
	var Clear = function() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(StkMainGrid);
		$UI.clear(StkDetailGrid);
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			StkLoc: gLocObj
		};
		$UI.fillBlock('#FindConditions', DefaultData);
	};
	$HUI.dialog('#FindWin', { width: gWinWidth, height: gWinHeight }).open();
	$UI.linkbutton('#FQueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#FindConditions');
			if (isEmpty(ParamsObj.StartDate)) {
				$UI.msg('alert', '开始日期不能为空!');
				return;
			}
			if (isEmpty(ParamsObj.EndDate)) {
				$UI.msg('alert', '截止日期不能为空!');
				return;
			}
			if (isEmpty(ParamsObj.StkLoc)) {
				$UI.msg('alert', '科室不能为空!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			$UI.clear(StkDetailGrid);
			StkMainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCReqLocStktk',
				QueryName: 'QueryMaster',
				query2JsonStrict: 1,
				StrParam: Params
			});
		}
	});
	$UI.linkbutton('#FComBT', {
		onClick: function() {
			var Row = StkMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要返回的盘点单!');
				return;
			}
			Fn(Row.RowId);
			$HUI.dialog('#FindWin').close();
		}
	});
	$UI.linkbutton('#FClearBT', {
		onClick: function() {
			Clear();
		}
	});

	var FStkLocParams = JSON.stringify(addSessionParams({ Type: INREQUEST_LOCTYPE }));
	var FStkLocBox = $HUI.combobox('#FStkLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FStkLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var StkMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '便易盘点单号',
			field: 'SubSTNo',
			width: 150
		}, {
			title: '库房',
			field: 'CreateLocDesc',
			width: 150
		}, {
			title: '盘点科室',
			field: 'StkTkLocDesc',
			width: 100
		}, {
			title: '制单人',
			field: 'CreateUser',
			width: 70
		}, {
			title: '日期',
			field: 'CreateDate',
			width: 90,
			align: 'right'
		}, {
			title: '时间',
			field: 'CreateTime',
			width: 80,
			align: 'right'
		}, {
			title: '账盘完成状态',
			field: 'Completed',
			width: 60
		}, {
			title: '实盘完成状态',
			field: 'CountCompleted',
			width: 60
		}, {
			title: '调整完成状态',
			field: 'AdjCompleted',
			width: 60
		}
	]];
	
	var StkMainGrid = $UI.datagrid('#StkMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCReqLocStktk',
			QueryName: 'QueryMaster',
			query2JsonStrict: 1
		},
		columns: StkMainCm,
		onSelect: function(index, row) {
			StkDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCReqLocStktk',
				QueryName: 'QueryDetail',
				query2JsonStrict: 1,
				Parref: row.RowId
			});
		},
		onDblClickRow: function(index, row) {
			Fn(row.RowId);
			$HUI.dialog('#FindWin').close();
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				StkMainGrid.selectRow(0);
			}
		}
	});
	
	var StkDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: 'Incil',
			field: 'Incil',
			hidden: true,
			width: 80
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 120
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 150
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '冻结数量',
			field: 'FreezeQty',
			width: 100,
			align: 'right'
		}, {
			title: '单位',
			field: 'PUomDesc',
			width: 80
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '备注',
			field: 'Remarks',
			width: 100
		}
	]];
	
	var StkDetailGrid = $UI.datagrid('#StkDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCReqLocStktk',
			QueryName: 'QueryDetail',
			query2JsonStrict: 1
		},
		columns: StkDetailCm
	});
	
	Clear();
	$('#FQueryBT').click();
};