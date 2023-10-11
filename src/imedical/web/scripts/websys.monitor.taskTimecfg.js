// websys.monitor.taskTimecfg.js
var taskDatagrid = "#taskDatagrid";
function init() {
	datagrid();
}
var editIndex = undefined;
function endEditing() {
	if (editIndex == undefined) { return true }
	if ($(taskDatagrid).datagrid('validateRow', editIndex)) {
		if ($(taskDatagrid).datagrid('validateRow', editIndex)) {
			var ed = $(taskDatagrid).datagrid('getEditor', { index: editIndex, field: 'ExpectedTime' });
			var value = $(ed.target).numberbox('getValue');
			$(taskDatagrid).datagrid('getRows')[editIndex]['ExpectedTime'] = value;
			$(taskDatagrid).datagrid('endEdit', editIndex);
			editIndex = undefined;
		}
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}
function onClickRow(index) {
	if (editIndex != index) {
		if (endEditing()) {
			$(taskDatagrid).datagrid('selectRow', index)
				.datagrid('beginEdit', index);
			editIndex = index;
		} else {
			$(taskDatagrid).datagrid('selectRow', editIndex);
		}
	}
}
var datagrid = function () {
	$(taskDatagrid).datagrid({
		queryParams: {
			ClassName: "websys.MonitorTaskTimeCfg",
			QueryName: "Find",
			ServerDr: serverId
		},
		url: $URL,
		iconCls: 'icon-edit',
		onClickRow: onClickRow,
		// title:serverId + " ��������ʱ������",
		idField: 'ContentId',
		//height:500,
		fit: true,
		// singleSelect:false,
		pageNumber: 1,
		rownumbers: true,
		pagination: true,
		striped: true,
		columns: [[
			{ field: 'TaskId', title: '', hidden: true }
			, { field: 'TaskName', title: '��������', width: 200 }
			, { field: 'TaskDesc', title: '��������', width: 400 }
			, { field: 'ExpectedTime', title: 'Ԥ������ʱ��/��', width: 150, editor: { type: 'numberbox' } }
			, { field: 'ServerDr', title: '', hidden: true }
			, { field: 'Id', title: '', hidden: true }
		]],
		buttons: [{
			iconCls: 'icon-save',
			text: "����",
			handler: function () {
				alert('search');
			}
		}],
		toolbar: [
			{
				id: 'SaveBtn',
				iconCls: 'icon-save',
				text: "����",
				handler: function () {
					var rows = $(taskDatagrid).datagrid('getRows');
					if (rows.length < 1) {
						$.messager.popover({
							msg: 'û�����ݱ��棡',
							type: 'info'
						});
						return;
					}
					endEditing();
					var arr = [];
					for (var i = 0; i < rows.length; i++) {
						var obj = {};
						obj.Id = rows[i].Id;
						obj.ExpectedTime = rows[i].ExpectedTime;
						arr.push(obj);
					}
					var json = {};
					json.data = arr;
					//alert(JSON.stringify(json));
					var json = JSON.stringify(json);
					$q({
						ClassName: "websys.MonitorTaskTimeCfg",
						MethodName: "Save",
						json: json
					}, function (Data) {
						if (Data.success == 1) {
							$.messager.popover({ msg: Data.msg, type: 'success' });
						} else {
							$.messager.popover({ msg: Data.msg, type: 'error' });
						}
					});
				}
			}

		]
	});
}

$(init);