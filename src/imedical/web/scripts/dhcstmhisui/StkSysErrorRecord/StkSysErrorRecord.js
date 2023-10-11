
var init = function() {
	var ClearMain = function() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(ErrorRecordGrid);
		var DefaultData = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date())
		};
		$UI.fillBlock('#MainConditions', DefaultData);
	};
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
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
			var Params = JSON.stringify(ParamsObj);
			ErrorRecordGrid.load({
				ClassName: 'web.DHCSTMHUI.ErrorRecord',
				QueryName: 'Query',
				query2JsonStrict: 1,
				Params: Params
			});
		}
	});
	var ErrorRecordGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '��־��������',
			field: 'Date',
			width: 100
		}, {
			title: '��־����ʱ��',
			field: 'Time',
			width: 100
		}, {
			title: '������ģ��',
			field: 'AppName',
			width: 150
		}, {
			title: '��������',
			field: 'ErrInfo',
			width: 100
		}, {
			title: '�������������',
			field: 'KValue',
			width: 150
		}, {
			title: '��������Ĵ���',
			field: 'Trigger',
			width: 100
		}, {
			title: '��������IP',
			field: 'IP',
			width: 100
		}, {
			title: '�����û�',
			field: 'UserName',
			width: 100
		}, {
			title: '�����Ϣ',
			field: 'BrowserInfo',
			width: 100
		}
	]];

	var ErrorRecordGrid = $UI.datagrid('#ErrorRecordGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ErrorRecord',
			QueryName: 'Query',
			query2JsonStrict: 1
		},
		columns: ErrorRecordGridCm,
		fitColumns: true,
		singleSelect: false,
		showBar: true,
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	ClearMain();
};
$(init);