var init = function() {
	var DepartmentParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	var DepartmentCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params=' + DepartmentParams,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = DepartmentGrid.getRows();
				var row = rows[DepartmentGrid.editIndex];
				row.LocDesc = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var Params = JSON.stringify($UI.loopBlock('DepartmentTB'));
		DepartmentGrid.load({
			ClassName: 'web.DHCSTMHUI.DepartmentCompare',
			QueryName: 'SelectAll',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	$UI.linkbutton('#AddBT', {
		onClick: function() {
			DepartmentGrid.commonAddRow();
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var Rows = DepartmentGrid.getChangesData();
			if (Rows === false) {	// 未完成编辑或明细为空
				return;
			}
			if (isEmpty(Rows)) {	// 明细不变
				$UI.msg('alert', '没有需要保存的明细!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DepartmentCompare',
				MethodName: 'Save',
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					DepartmentGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#DeleteBT', {
		onClick: function() {
			var Rows = DepartmentGrid.getSelections();
			if (Rows.length == 0) {
				$UI.msg('alert', '没有需要删除的明细!');
				return;
			}
			$UI.confirm('确定要删除吗?', '', '', function() {
				$.cm({
					ClassName: 'web.DHCSTMHUI.DepartmentCompare',
					MethodName: 'Delete',
					Params: JSON.stringify(Rows)
				}, function(jsonData) {
					if (jsonData.success === 0) {
						$UI.msg('success', jsonData.msg);
						DepartmentGrid.reload();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			});
		}
	});
	
	var DepartmentCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '名称',
			field: 'LocId',
			formatter: CommonFormatter(DepartmentCombox, 'LocId', 'LocDesc'),
			width: 200,
			editor: DepartmentCombox
		}, {
			title: 'HIS科室代码',
			field: 'HISCode',
			width: 200,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: 'HIS科室名称',
			field: 'HISDesc',
			width: 300,
			editor: { type: 'validatebox', options: { required: true }}
		}
	]];
	
	var DepartmentGrid = $UI.datagrid('#Department', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DepartmentCompare',
			QueryName: 'SelectAll',
			query2JsonStrict: 1
		},
		columns: DepartmentCm,
		toolbar: '#DepartmentTB',
		sortName: 'RowId',
		sortOrder: 'Desc',
		onClickRow: function(index, row) {
			DepartmentGrid.commonClickRow(index, row);
		}
	});
	
	Query();
};
$(init);