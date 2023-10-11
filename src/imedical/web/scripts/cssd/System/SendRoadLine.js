// 下收下送线路维护
var init = function() {
	function Query() {
		$UI.clear(SendMainLineGrid);
		$UI.clear(LocGrid);
		var Params = JSON.stringify(addSessionParams($UI.loopBlock('LineTB')));
		SendMainLineGrid.load({
			ClassName: 'web.CSSDHUI.System.SendRoadLine',
			QueryName: 'SelectAll',
			Params: Params,
			rows: 999
		});
	}

	var SupLocParams = JSON.stringify(addSessionParams({ Type: 'SupLoc', BDPHospital: gHospId }));
	var SupLocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SupLocParams,
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect: function(record) {
				var rows = SendMainLineGrid.getRows();
				var row = rows[SendMainLineGrid.editIndex];
				row.SupLocDesc = record.Description;
			}
		}
	};
	var LineUserParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	var LineUserCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array&Params=' + LineUserParams,
			valueField: 'RowId',
			textField: 'Description',
			required: false,
			onSelect: function(record) {
				var rows = SendMainLineGrid.getRows();
				var row = rows[SendMainLineGrid.editIndex];
				row.LineUserName = record.Description;
			}
		}
	};

	var SendLineGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 10,
			hidden: true
		}, {
			title: '供应室',
			field: 'SupLocId',
			formatter: CommonFormatter(SupLocCombox, 'SupLocId', 'SupLocDesc'),
			editor: SupLocCombox,
			width: 200
		}, {
			title: '线路编号',
			align: 'center',
			field: 'LineCode',
			width: 100,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '线路描述',
			field: 'LineDesc',
			width: 150,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '负责人',
			field: 'LineUserId',
			width: 200,
			formatter: CommonFormatter(LineUserCombox, 'LineUserId', 'LineUserName'),
			editor: LineUserCombox
		}
	]];
	var SendMainLineGrid = $UI.datagrid('#SendLineGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.SendRoadLine',
			QueryName: 'SelectAll'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.System.SendRoadLine',
			MethodName: 'jsDelete'
		},
		saveDataFn: function() {
			var Rows = SendMainLineGrid.getChangesData();
			if (isEmpty(Rows)) {
				return;
			}
			if (Rows === false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.System.SendRoadLine',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				$UI.msg('success', jsonData.msg);
				if (jsonData.success === 0) {
					SendMainLineGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		columns: SendLineGridCm,
		showAddSaveDelItems: true,
		fitColumns: true,
		pagination: false,
		remoteSort: false,
		checkField: 'SupLocId',
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#SendLineGrid').datagrid('selectRow', 0);
			}
		},
		onClickRow: function(index, row) {
			SendMainLineGrid.commonClickRow(index, row);
		},
		onSelect: function(index, rowData) {
			var RoadLineId = rowData.RowId;
			if (!isEmpty(RoadLineId)) {
				LocGrid.load({
					ClassName: 'web.CSSDHUI.System.SendRoadLine',
					QueryName: 'SelectLineItm',
					RoadLineId: RoadLineId,
					rows: 999
				});
				TimeGrid.load({
					ClassName: 'web.CSSDHUI.System.SendRoadLine',
					QueryName: 'SelectLineTime',
					RoadLineId: RoadLineId,
					rows: 999
				});
			}
		},
		afterDelFn: function() {
			LocGrid.reload();
			TimeGrid.reload();
		}
	});

	var LocParams = JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: gHospId }));
	var LocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect: function(record) {
				var rows = LocGrid.getRows();
				var row = rows[LocGrid.editIndex];
				row.LocDesc = record.Description;
			}
		}
	};

	var LocGridCm = [[
		{
			field: 'ck',
			checkbox: true,
			width: 50
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 60,
			hidden: true
		}, {
			title: '科室代码',
			field: 'LocCode',
			width: 200
		}, {
			title: '科室描述',
			field: 'LocId',
			width: 200,
			formatter: CommonFormatter(LocCombox, 'LocId', 'LocDesc'),
			editor: LocCombox
		}
	]];
	var LocGrid = $UI.datagrid('#LocGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.SendRoadLine',
			QueryName: 'SelectLineItm'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.System.SendRoadLine',
			MethodName: 'jsDeleteItm'
		},
		showAddSaveDelItems: true,
		columns: LocGridCm,
		fitColumns: true,
		singleSelect: false,
		pagination: false,
		remoteSort: false,
		checkField: 'LocId',
		sortName: 'RowId',
		sortOrder: 'asc',
		saveDataFn: function() {
			var Rows = LocGrid.getChangesData();
			if (isEmpty(Rows)) {
				return;
			}
			if (Rows === false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			var RoadLineObj = SendMainLineGrid.getSelected();
			var RoadLineId = RoadLineObj.RowId;
			$.cm({
				ClassName: 'web.CSSDHUI.System.SendRoadLine',
				MethodName: 'jsSaveItm',
				RoadLineId: RoadLineId,
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					LocGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		beforeAddFn: function() {
			var rowMain = $('#SendLineGrid').datagrid('getSelected');
			if (isEmpty(rowMain)) {
				$UI.msg('alert', '请选择线路维护!');
				return false;
			}
		},
		onCheck: function(index, row) {
			LocGrid.commonClickRow(index, row);
		},
		onClickCell: function(index, field, value) {
			var Row = LocGrid.getRows()[index];
			if (!isEmpty(Row.RowId) && field === 'LocId') {
				return false;
			}
			LocGrid.commonClickCell(index, field);
		}
	});

	var TimeGridCm = [[
		{
			field: 'ck',
			checkbox: true,
			width: 50
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '开始时间',
			field: 'StartTime',
			width: 100,
			editor: {
				type: 'timespinner',
				options: {
					required: true,
					showSeconds: false
				}
			}
		}, {
			title: '结束时间',
			field: 'EndTime',
			width: 100,
			editor: {
				type: 'timespinner',
				options: {
					required: true,
					showSeconds: false
				}
			}
		}
	]];

	var TimeGrid = $UI.datagrid('#TimeGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.SendRoadLine',
			QueryName: 'SelectLineTime'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.System.SendRoadLine',
			MethodName: 'jsDeleteLineTime'
		},
		showAddSaveDelItems: true,
		columns: TimeGridCm,
		fitColumns: true,
		singleSelect: false,
		pagination: false,
		remoteSort: false,
		saveDataFn: function() {
			var Rows = TimeGrid.getChangesData();
			if (isEmpty(Rows)) {
				return;
			}
			if (Rows === false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			for (var i = 0; i < Rows.length; i++) {
				if (Rows[i]['StartTime'] >= Rows[i]['EndTime']) {
					$UI.msg('alert', '结束时间需大于开始时间!');
					TimeGrid.commonClickRow(i, Rows[i]);
					return;
				}
			}
			var RoadLineObj = SendMainLineGrid.getSelected();
			var RoadLineId = RoadLineObj.RowId;
			$.cm({
				ClassName: 'web.CSSDHUI.System.SendRoadLine',
				MethodName: 'jsSaveLineTime',
				RoadLineId: RoadLineId,
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					TimeGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		beforeAddFn: function() {
			var rowMain = $('#SendLineGrid').datagrid('getSelected');
			if (isEmpty(rowMain)) {
				$UI.msg('alert', '请选择线路维护!');
				return false;
			}
		},
		onCheck: function(index, row) {
			TimeGrid.commonClickRow(index, row);
		}
	});
	Query();
};
$(init);