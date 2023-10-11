var FindRetWin = function() {
	$HUI.dialog('#FindRetWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
	
	/* --按钮功能--*/
	$UI.linkbutton('#FQueryBT', {
		onClick: function() {
			$UI.clear(AlDispRetMainGrid);
			$UI.clear(AlDispRetDetailGrid);
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
			AlDispRetMainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCInMatRet',
				QueryName: 'QueryInMatDispRetMain',
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
			var Row = AlDispRetMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要选取的发放单');
				return;
			}
			
			PrintDispRet(Row.RowId);
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
	var AlDispRetDetailGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '就诊科室',
			field: 'AdmLocDesc',
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
		}, {
			title: '姓名',
			field: 'PatName',
			width: 60
		}, {
			title: '床号',
			field: 'BedNo',
			width: 60
		}, {
			title: '发放日期',
			field: 'DispDate',
			width: 150
		}, {
			title: '发放时间',
			field: 'DispTime',
			width: 150
		}
	]];
	
	var AlDispRetDetailGrid = $UI.datagrid('#AlDispRetDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCInMatRet',
			QueryName: 'QueryInMatDispRetItm',
			query2JsonStrict: 1
		},
		columns: AlDispRetDetailGridCm,
		showBar: true
	});
	
	var AlDispRetMainGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 80
		}, {
			title: '退回单号',
			field: 'DispRetNo',
			width: 100
		}, {
			title: '科室',
			field: 'LocDesc',
			width: 100
		}, {
			title: '病区',
			field: 'WardLocDesc',
			width: 100
		}, {
			title: '退回日期',
			field: 'Date',
			width: 100
		}, {
			title: '退回时间',
			field: 'Time',
			width: 150
		}, {
			title: '退回人',
			field: 'UserName',
			width: 100
		}
	]];
	
	var AlDispRetMainGrid = $UI.datagrid('#AlDispRetMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCInMatRet',
			QueryName: 'QueryInMatDispRetMain',
			query2JsonStrict: 1
		},
		columns: AlDispRetMainGridCm,
		showBar: true,
		onSelect: function(index, row) {
			AlDispRetDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCInMatRet',
				QueryName: 'QueryInMatDispRetItm',
				query2JsonStrict: 1,
				Parref: row.RowId
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				AlDispRetMainGrid.selectRow(0);
			}
		}
	});
	
	/* --设置初始值--*/
	var FDefaultData = function() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(AlDispRetMainGrid);
		$UI.clear(AlDispRetDetailGrid);
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