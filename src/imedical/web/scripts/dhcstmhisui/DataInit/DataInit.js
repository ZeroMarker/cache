var DIGrid;
var init = function() {
	var HospId = gHospId;
	
	DICm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '��ʼ��',
			field: 'Icon',
			width: 100,
			align: 'center',
			allowExport: false,
			formatter: function(value, row, index) {
				var Type = 'aaaa';
				var str = '<div class="icon-init col-icon" title="��ʼ��" href="#" onclick="Init(' + index + ')"></div>';
				return str;
			}
		}, {
			title: '��������',
			field: 'Type',
			width: 150,
			hidden: true
		}, {
			title: '��������',
			field: 'Name',
			width: 150
		}, {
			title: '����',
			field: 'Description',
			width: 500
		}, {
			title: '��������',
			field: 'Date',
			width: 150
		}, {
			title: '����ʱ��',
			field: 'Time',
			width: 150
		}, {
			title: '������',
			field: 'User',
			width: 150
		}
	]];
	
	DIGrid = $UI.datagrid('#DIGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DataInit',
			QueryName: 'Query',
			query2JsonStrict: 1
		},
		columns: DICm,
		checkField: 'Type',
		onClickRow: function(index, row) {
			DIGrid.commonClickRow(index, row);
		}
	});
	Query();
};
$(init);

function Query() {
	var Params = '';
	DIGrid.load({
		ClassName: 'web.DHCSTMHUI.DataInit',
		QueryName: 'Query',
		query2JsonStrict: 1,
		Params: Params
	});
}

function Init(index) {
	var Row = DIGrid.getRows()[index];
	if (isEmpty(Row)) {
		$UI.msg('alert', '��ѡ��Ҫ��ʼ������������!');
		return;
	}
	var Params = JSON.stringify(addSessionParams({ Type: Row.Type, InitFlag: 'Y' }));
	$.cm({
		ClassName: 'web.DHCSTMHUI.DataInit',
		MethodName: 'jsInit',
		Params: Params
	}, function(jsonData) {
		hideMask();
		if (jsonData.success == 0) {
			$UI.msg('success', jsonData.msg);
			Query();
		} else {
			$UI.msg('error', jsonData.msg);
		}
	});
}