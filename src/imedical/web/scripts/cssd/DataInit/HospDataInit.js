var DIGrid;
var init = function() {
	var HospitalBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetHosp&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = DIGrid.getRows();
				var row = rows[DIGrid.editIndex];
				row.HospDesc = record.Description;
			},
			onShowPanel: function() {
				var rows = DIGrid.getRows();
				var RowItem = rows[DIGrid.editIndex];
				var TableName = RowItem.TableName;
				if (!isEmpty(TableName)) {
					$(this).combobox('clear');
					var url = $URL + '?ClassName=web.CSSDHUI.HospMap&QueryName=GetDefHosp&ResultSetType=array&TableName=' + TableName;
				}
				$(this).combobox('reload', url);
			}
		}
	};
	
	var DICm = [[
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
			title: '医院名称',
			field: 'HospId',
			width: 200,
			formatter: CommonFormatter(HospitalBox, 'HospId', 'HospDesc'),
			editor: HospitalBox
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
		}, {
			title: 'TableName',
			field: 'TableName',
			hidden: true
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
	var Params = JSON.stringify(addSessionParams({ InitFlag: 'N' }));
	DIGrid.load({
		ClassName: 'web.CSSDHUI.DataInit',
		QueryName: 'Query',
		Params: Params
	});
}

function Init(index) {
	DIGrid.endEditing();
	var Row = DIGrid.getRows()[index];
	if (isEmpty(Row)) {
		$UI.msg('alert', '请选择要初始化的数据类型!');
		return;
	}
	var Params = JSON.stringify(addSessionParams({ Type: Row.Type, InitFlag: 'N', BDPHospital: Row.HospId }));
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