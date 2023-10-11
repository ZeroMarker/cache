var init = function() {
	var MethodNameBox = $HUI.combobox('#MethodName', {
		url: $URL + '?ClassName=web.DHCSTMHUI.HISInterfaceLog&QueryName=GetLogMethodName&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	function Clear() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(LogGrid);
		var DefaultData = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date())
		};
		$UI.fillBlock('#MainConditions', DefaultData);
	}
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		$UI.clear(LogGrid);
		var ParamsObj = $UI.loopBlock('#MainConditions');
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
		LogGrid.load({
			ClassName: 'web.DHCSTMHUI.HISInterfaceLog',
			MethodName: 'QueryLog',
			Params: Params
		});
	}
	var LogCm = [[
		{
			title: 'LogId',
			field: 'LogId',
			width: 100,
			hidden: true
		}, {
			title: '类型',
			field: 'Type',
			width: 60
		}, {
			title: '成功',
			field: 'Success',
			width: 70,
			hidden: true,
			formatter: BoolFormatter
		}, {
			title: '类名',
			field: 'ClassName',
			width: 300
		}, {
			title: '方法名',
			field: 'MethodName',
			width: 120
		}, {
			title: '入参时间',
			field: 'ParamsDateTime',
			width: 160
		}, {
			title: '返回值时间',
			field: 'ResultDateTime',
			width: 160
		}, {
			title: '入参',
			field: 'Params',
			width: 400,
			showTip: true,
			tipWidth: 150
		}, {
			title: '返回值',
			field: 'Result',
			width: 400,
			showTip: true,
			tipWidth: 500
		}
	]];

	var LogGrid = $UI.datagrid('#LogGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.HISInterfaceLog',
			MethodName: 'QueryLog'
		},
		columns: LogCm,
		showBar: true,
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	Clear();
	Query();
};
$(init);
