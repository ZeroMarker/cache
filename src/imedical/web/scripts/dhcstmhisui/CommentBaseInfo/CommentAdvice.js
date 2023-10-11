// 名称:高值点评建议维护
// 编写日期:2019-10-15
var init = function() {
	$UI.linkbutton('#ReloadBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		CommentAdviceGrid.load({
			ClassName: 'web.DHCSTMHUI.CommentAdvice',
			QueryName: 'SelectAll',
			query2JsonStrict: 1
		});
	}
	$UI.linkbutton('#AddBT', {
		onClick: function() {
			CommentAdviceGrid.commonAddRow();
		}
	});

	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var Rows = CommentAdviceGrid.getChangesData();
			if (Rows === false) {	// 未完成编辑或明细为空
				return;
			}
			if (isEmpty(Rows)) {
				$UI.msg('alert', '没有需要保存的内容!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.CommentAdvice',
				MethodName: 'Save',
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					CommentAdviceGrid.commonReload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$('#DeleteBT').on('click', function() {
		CommentAdviceGrid.commonDeleteRow();
	});
	
	var CommentAdviceCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '建议代码',
			field: 'Code',
			width: 300,
			fitColumns: true,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '建议描述',
			field: 'Description',
			width: 300,
			fitColumns: true,
			editor: { type: 'validatebox', options: { required: true }}
		}
	]];
	
	var CommentAdviceGrid = $UI.datagrid('#CommentAdviceList', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.CommentAdvice',
			QueryName: 'SelectAll',
			query2JsonStrict: 1
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.CommentAdvice',
			MethodName: 'Delete'
		},
		columns: CommentAdviceCm,
		toolbar: '#CommentAdviceTB',
		sortName: 'RowId',
		sortOrder: 'Desc',
		onClickRow: function(index, row) {
			CommentAdviceGrid.commonClickRow(index, row);
		}
	});
	Query();
};
$(init);