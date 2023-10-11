var init = function() {
	var ReqLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var Params = JSON.stringify($UI.loopBlock('#MainCondition'));
	var DeptCenterObj = $.cm({
		ClassName: 'web.CSSDHUI.Common.Dicts',
		MethodName: 'GetDeptCenter',
		Params: Params
	}, false);
	var DeptCenterFlag = DeptCenterObj['DeptCenterFlag'];
	// 请求科室
	if (DeptCenterFlag === 'Y') {
		ReqLocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	}
	$HUI.combobox('#LendLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.combobox('#LendState', {
		valueField: 'RowId',
		textField: 'Description',
		data: LendStateData
	});
	var Default = {
		StartDate: DateFormatter(new Date()),
		EndDate: DateFormatter(new Date())
	};
	$UI.fillBlock('#MainCondition', Default);
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#MainCondition');
			if (isEmpty(ParamsObj.StartDate)) {
				$UI.msg('alert', '起始日期不能为空!');
				return;
			}
			if (isEmpty(ParamsObj.EndDate)) {
				$UI.msg('alert', '截止日期不能为空!');
				return;
			}
			if (ParamsObj.StartDate > ParamsObj.EndDate) {
				$UI.msg('alert', '起始日期不能大于截止日期!');
				return;
			}
			query();
		}
	});
	function query() {
		$UI.clear(MainListGrid);
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.Stat.LendPkgQueryStat',
			QueryName: 'SelectAll',
			rows: 9999,
			Params: JSON.stringify($UI.loopBlock('#MainCondition'))
		});
	}
	
	var MainCm = [[
		{
			title: 'RowId',
			field: 'ApplyId',
			width: 50,
			hidden: true
		}, {
			title: '借包单号',
			field: 'ApplyNO',
			width: 130
		}, {
			title: '借包科室',
			field: 'ApplyLocID',
			width: 100,
			hidden: true
		}, {
			title: '借包科室',
			field: 'ApplyLocDesc',
			width: 160
		}, {
			title: '借包人',
			field: 'ApplyUserName',
			width: 80
		}, {
			title: '借包日期',
			field: 'ApplyDate',
			width: 150
		}, {
			title: '消毒包DR',
			field: 'PkgDr',
			width: 100,
			hidden: true
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			width: 200
		}, {
			title: '借包数',
			field: 'ApplyQty',
			align: 'right',
			width: 80
		}, {
			title: '发放数',
			field: 'DispQty',
			align: 'right',
			width: 80
		}, {
			title: '还包数',
			field: 'ReturnQty',
			align: 'right',
			width: 80
		}, {
			title: '发放明细Id',
			field: 'DispItmId',
			align: 'left',
			width: 100,
			hidden: true
		}, {
			title: '发放单号',
			field: 'DispNo',
			width: 200,
			showTip: true,
			tipWidth: 300,
			tipTrackMouse: true,
			tipPosition: 'left'
		}, {
			title: '回收单号',
			field: 'CallBackNo',
			width: 200,
			showTip: true,
			tipWidth: 300,
			tipTrackMouse: true,
			tipPosition: 'left'
		}, {
			title: '回收ID',
			field: 'CallBackId',
			align: 'left',
			width: 100,
			hidden: true
		}, {
			title: '回收明细ID',
			field: 'CallBackItmId',
			align: 'left',
			width: 100,
			hidden: true
		}]];
	var MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Stat.LendPkgQueryStat',
			QueryName: 'SelectAll',
			Params: JSON.stringify($UI.loopBlock('#MainCondition'))
		},
		columns: MainCm,
		pagination: false,
		sortName: 'RowId',
		sortOrder: 'desc',
		onClickRow: function(index, row) {
			MainListGrid.commonClickRow(index, row);
		}
	});
	query();
};
$(init);