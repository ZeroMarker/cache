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
			if (Rows === false) {	// δ��ɱ༭����ϸΪ��
				return;
			}
			if (isEmpty(Rows)) {	// ��ϸ����
				$UI.msg('alert', 'û����Ҫ�������ϸ!');
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
				$UI.msg('alert', 'û����Ҫɾ������ϸ!');
				return;
			}
			$UI.confirm('ȷ��Ҫɾ����?', '', '', function() {
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
			title: '����',
			field: 'LocId',
			formatter: CommonFormatter(DepartmentCombox, 'LocId', 'LocDesc'),
			width: 200,
			editor: DepartmentCombox
		}, {
			title: 'HIS���Ҵ���',
			field: 'HISCode',
			width: 200,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: 'HIS��������',
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