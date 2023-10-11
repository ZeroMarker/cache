
var init = function() {
	var HospId = gHospId;	
	$HUI.combobox('#Type', {
		data: [{ 'RowId': '3501', 'Description': '3501' }, { 'RowId': '3502', 'Description': '3502' }, { 'RowId': '3503', 'Description': '3503' }, { 'RowId': '3504', 'Description': '3504' }, { 'RowId': '3505', 'Description': '3505' }, { 'RowId': '3506', 'Description': '3506' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	
	$HUI.combobox('#Status', {
		data: [{ 'RowId': '', 'Description': '全部' }, { 'RowId': 'Y', 'Description': '成功' }, { 'RowId': 'N', 'Description': '失败' }],
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
		$UI.clear(LogRecordGrid);
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
		$UI.clear(LogRecordGrid);
		var SessionParmas = addSessionParams({ BDPHospital: HospId });
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
		var Params = JSON.stringify(jQuery.extend(true, ParamsObj, SessionParmas));
		LogRecordGrid.load({
			ClassName: 'web.DHCSTMHUI.InsuDataUpLoadLog',
			QueryName: 'QueryLog',
			Params: Params
		});
	}
	var SendBT = {
		text: '重新发送',
		iconCls: 'icon-paper-plane',
		handler: function() {
			var Row = LogRecordGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要重新发送数据!');
				return;
			}
			var LogSuccess = Row.LogSuccess;
			var LogSendAgain = Row.LogSendAgain;
			if (LogSuccess == 'Y') {
				$UI.msg('alert', '请选择发送失败的数据!');
				return;
			}
			if (LogSendAgain == 'Y') {
				$UI.msg('alert', '已重新发送!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.InsuDataUpLoadLog',
				MethodName: 'jsSend',
				LogId: Row.LogId
				
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					Query();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	};
	var LogRecordGridCm = [[
		{
			title: 'LogId',
			field: 'LogId',
			width: 100,
			hidden: true
		}, {
			title: '类型',
			field: 'LogType',
			width: 60
		}, {
			title: '成功',
			field: 'LogSuccess',
			width: 70,
			hidden: true,
			formatter: BoolFormatter
		}, {
			title: '类名',
			field: 'LogClassName',
			width: 300
		}, {
			title: '方法名',
			field: 'LogMethodName',
			width: 120
		}, {
			title: '入参时间',
			field: 'LogParamsDateTime',
			width: 150
		}, {
			title: '返回值时间',
			field: 'LogResultDateTime',
			width: 150
		}, {
			title: '入参',
			field: 'LogParams',
			width: 400,
			showTip: true,
			tipWidth: 150
		}, {
			title: '返回值',
			field: 'LogResult',
			width: 400,
			showTip: true,
			tipWidth: 500
		}
	]];

	var LogRecordGrid = $UI.datagrid('#LogRecordGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.InsuDataUpLoadLog',
			MethodName: 'QueryLog'
		},
		columns: LogRecordGridCm,
		showBar: true,
		toolbar: [SendBT]
	});
	Clear();
	Query();
};
$(init);