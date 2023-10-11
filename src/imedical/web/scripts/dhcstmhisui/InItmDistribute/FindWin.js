var FindWin = function() {
	$HUI.dialog('#FindWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();

	/* --按钮功能--*/
	$UI.linkbutton('#FQueryBT', {
		onClick: function() {
			$UI.clear(AlDispMainGrid);
			$UI.clear(AlDispDetailGrid);
			var ParamsObj = $UI.loopBlock('#FindConditions');
			var StartDate = ParamsObj.StartDate;
			var EndDate = ParamsObj.EndDate;
			if (isEmpty(StartDate)) {
				$UI.msg('alert', '开始日期不能为空!');
				return;
			}
			if (isEmpty(EndDate)) {
				$UI.msg('alert', '截止日期不能为空!');
				return;
			}
			if (compareDate(StartDate, EndDate)) {
				$UI.msg('alert', '截止日期不能小于开始日期!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			AlDispMainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCInMatDisp',
				QueryName: 'QueryInMatDispMain',
				query2JsonStrict: 1,
				Params: Params
			});
		}
	});
	
	$UI.linkbutton('#FClearBT', {
		onClick: function() {
			FDefaultData();
		}
	});
	
	$UI.linkbutton('#FPrintBT', {
		onClick: function() {
			var Row = AlDispMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要选取的发放单');
				return;
			}
			
			PrintDisp(Row.RowId);
		}
	});
	
	/* --绑定控件--*/
	var Params = JSON.stringify(addSessionParams());
	$HUI.combobox('#FWardLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetWardLoc&ResultSetType=array&Params=' + Params,
		valueField: 'RowId',
		textField: 'Description'
	});
	/* --Grid--*/
	var AlDispDetailGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 80
		}, {
			title: '就诊科室',
			field: 'AdmLocDesc',
			width: 100
		}, {
			title: '床号',
			field: 'BedNo',
			width: 100
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 100
		}, {
			title: '物资id',
			field: 'InciId',
			width: 100,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 100
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 100
		}, {
			title: '规格',
			field: 'Spec',
			width: 100,
			align: 'right'
		}, {
			title: '货位',
			field: 'Stkbin',
			width: 100
		}, {
			title: '数量',
			field: 'Qty',
			width: 100,
			align: 'right'
		}, {
			title: '售价',
			field: 'Sp',
			width: 100,
			align: 'right'
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width: 100,
			align: 'right'
		}
	]];
	
	var AlDispDetailGrid = $UI.datagrid('#AlDispDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCInMatDisp',
			QueryName: 'QueryInMatDispItm',
			query2JsonStrict: 1
		},
		columns: AlDispDetailGridCm,
		showBar: true
	});
	
	var AlDispMainGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '发放单号',
			field: 'DispNo',
			width: 100
		}, {
			title: '病区',
			field: 'WardLocDesc',
			width: 100
		}, {
			title: '发放日期',
			field: 'Date',
			width: 100
		}, {
			title: '发放时间',
			field: 'Time',
			width: 150
		}, {
			title: '发放人',
			field: 'UserName',
			width: 100
		}
	]];
	
	var AlDispMainGrid = $UI.datagrid('#AlDispMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCInMatDisp',
			QueryName: 'QueryInMatDispMain',
			query2JsonStrict: 1
		},
		columns: AlDispMainGridCm,
		showBar: true,
		onSelect: function(index, row) {
			AlDispDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCInMatDisp',
				QueryName: 'QueryInMatDispItm',
				query2JsonStrict: 1,
				Parref: row.RowId
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				AlDispMainGrid.selectRow(0);
			}
		}
	});
	
	/* --设置初始值--*/
	var FDefaultData = function() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(AlDispMainGrid);
		$UI.clear(AlDispDetailGrid);
		// /设置初始值 考虑使用配置
		var FDefaultDataValue = {
			StartDate: DateAdd(new Date(), 'd', parseInt(-7)),
			EndDate: new Date()
		};
		$UI.fillBlock('#FindConditions', FDefaultDataValue);
	};
	FDefaultData();
	$('#FQueryBT').click();
};