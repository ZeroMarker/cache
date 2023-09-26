// ����:��ֵ��������ά��
// ��д����:2019-10-15

var init = function() {
	$UI.linkbutton('#SearchBT', {
		onClick: function(){
			CommentAdviceGrid.load({
				ClassName: 'web.DHCSTMHUI.CommentAdvice',
				QueryName: 'SelectAll'
			});
		}
	});
	$UI.linkbutton('#AddBT', {
		onClick: function(){
			CommentAdviceGrid.commonAddRow();
		}
	});

	$UI.linkbutton('#SaveBT', {
		onClick: function(){
			var Rows=CommentAdviceGrid.getChangesData();
			if(isEmpty(Rows)){
					$UI.msg('alert', 'û����Ҫ���������!');
					return;
				}
			$.cm({
				ClassName: 'web.DHCSTMHUI.CommentAdvice',
				MethodName: 'Save',
				Params: JSON.stringify(Rows)
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					CommentAdviceGrid.commonReload();
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});
	$('#DeleteBT').on('click', function(){
		var Rows=CommentAdviceGrid.getSelectedData();
		$.cm({
			ClassName: 'web.DHCSTMHUI.CommentAdvice',
			MethodName: 'Delete',
			Params: JSON.stringify(Rows)
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				CommentAdviceGrid.commonReload();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	});
	
	var CommentAdviceCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '�������',
			field: 'Code',
			width:300,
			fitColumns:true,
			editor:{type:'validatebox',options:{required:true}}
		}, {
			title: '��������',
			field: 'Description',
			width:300,
			fitColumns:true,
			editor:{type:'validatebox',options:{required:true}}
		}
	]];
	
	var CommentAdviceGrid = $UI.datagrid('#CommentAdviceList', {
		lazy:false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.CommentAdvice',
			QueryName: 'SelectAll'				
		},
		columns: CommentAdviceCm,
		toolbar: '#CommentAdviceTB',
		sortName: 'RowId',  
		sortOrder: 'Desc',
		onClickCell: function(index, filed ,value){
			CommentAdviceGrid.commonClickCell(index,filed)
		}
	})
	
	
}
$(init);