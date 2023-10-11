﻿var DIGrid;
var init = function() {
	var HospId = gHospId;
	DICm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '初始化',
			field: 'Icon',
			width: 100,
			align: 'center',
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '<div class="col-icon icon-init" href="#" title="初始化" onclick="Init(' + index + ')"></div>';
				return str;
			}
		}, {
			title: '数据类型',
			field: 'Type',
			width: 150,
			hidden: true
		}, {
			title: '数据类型',
			field: 'Name',
			width: 150
		}, {
			title: '描述',
			field: 'Description',
			width: 490,
			showTip: true,
			tipWidth: 490
		}, {
			title: '操作日期',
			field: 'Date',
			width: 150
		}, {
			title: '操作时间',
			field: 'Time',
			width: 150
		}, {
			title: '操作人',
			field: 'User',
			width: 150
		}
	]];
	DIGrid = $UI.datagrid('#DIGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.DataInit',
			QueryName: 'Query'
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
	var Params = JSON.stringify(addSessionParams({ InitFlag: 'Y' }));
	DIGrid.load({
		ClassName: 'web.CSSDHUI.DataInit',
		QueryName: 'Query',
		Params: Params
	});
}

function Init(index) {
	var Row = DIGrid.getRows()[index];
	if (isEmpty(Row)) {
		$UI.msg('alert', '请选择要初始化的数据类型!');
		return;
	}
	var Params = JSON.stringify(addSessionParams({ Type: Row.Type, InitFlag: 'Y' }));
	showMask();
	$.cm({
		ClassName: 'web.CSSDHUI.DataInit',
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