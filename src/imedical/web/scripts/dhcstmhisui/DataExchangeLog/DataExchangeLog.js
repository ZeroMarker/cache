
var init = function() {
	var HospId = gHospId;
	var TableName = 'DHC_ServiceConfig';
	function InitHosp() {
		var hospComp = InitHospCombo(TableName, gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				Clear();
				Query();
			};
		}
		Clear();
		Query();
	}
	
	var TypeBox = $HUI.combobox('#Type', {
		// url: $URL + '?ClassName=web.DHCSTMHUI.GetDataExchangeLog&QueryName=GetLogType&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			TypeBox.clear();
			var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.GetDataExchangeLog&QueryName=GetLogType&ResultSetType=array&Params=' + Params;
			TypeBox.reload(url);
		}
	});
	
	var MethodNameBox = $HUI.combobox('#MethodName', {
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			var LogType = $HUI.combobox('#Type').getValue();
			if (isEmpty(LogType)) {
				$UI.msg('alert', '����ѡ������!');
				return;
			}
			MethodNameBox.clear();
			var url = $URL + '?ClassName=web.DHCSTMHUI.GetDataExchangeLog&QueryName=GetLogMethodName&ResultSetType=array&LogType=' + LogType;
			MethodNameBox.reload(url);
		}
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
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return;
		}
		if (compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���С�ڿ�ʼ����!');
			return;
		}
		var Params = JSON.stringify(jQuery.extend(true, ParamsObj, SessionParmas));
		LogRecordGrid.load({
			ClassName: 'web.DHCSTMHUI.GetDataExchangeLog',
			MethodName: 'QueryLog',
			Params: Params
		});
	}
	var SendBT = {
		text: '���·���',
		iconCls: 'icon-paper-plane',
		handler: function() {
			var Row = LogRecordGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ���·�������!');
				return;
			}
			var LogSuccess = Row.LogSuccess;
			var LogSendAgain = Row.LogSendAgain;
			if (LogSuccess == 'Y') {
				$UI.msg('alert', '��ѡ����ʧ�ܵ�����!');
				return;
			}
			if (LogSendAgain == 'Y') {
				$UI.msg('alert', '�����·���!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.GetDataExchangeLog',
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
			title: '����',
			field: 'LogType',
			width: 60
		}, {
			title: '�ɹ�',
			field: 'LogSuccess',
			width: 70,
			hidden: true,
			formatter: BoolFormatter
		}, {
			title: '����',
			field: 'LogClassName',
			width: 300
		}, {
			title: '������',
			field: 'LogMethodName',
			width: 120
		}, {
			title: '���ʱ��',
			field: 'LogParamsDateTime',
			width: 150
		}, {
			title: '����ֵʱ��',
			field: 'LogResultDateTime',
			width: 150
		}, {
			title: '���',
			field: 'LogParams',
			width: 400,
			showTip: true,
			tipWidth: 150
		}, {
			title: '����ֵ',
			field: 'LogResult',
			width: 400,
			showTip: true,
			tipWidth: 500
		}
	]];

	var LogRecordGrid = $UI.datagrid('#LogRecordGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.GetDataExchangeLog',
			MethodName: 'QueryLog'
		},
		columns: LogRecordGridCm,
		showBar: true,
		toolbar: [SendBT],
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	Clear();
	InitHosp();
};
$(init);