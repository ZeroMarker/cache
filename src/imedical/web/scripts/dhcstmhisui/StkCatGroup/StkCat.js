//������ά��
//zhangxiao 20180503
var init = function() {
	$('#AddBT').on('click',function(){
		StkCatGrid.commonAddRow();
	})
	$('#SaveBT').on('click',function(){
		var Rows = StkCatGrid.getChangesData();
		if (Rows === false){	//δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Rows)){	//��ϸ����
			$UI.msg("alert", "û����Ҫ�������ϸ!");
			return;
		}
		MainObj=JSON.stringify(addSessionParams({}))
		$.cm({
			ClassName: 'web.DHCSTMHUI.StkCat',
			MethodName: 'Save',
			Main: MainObj,
			Params: JSON.stringify(Rows)
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				StkCatGrid.reload();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		})
	})
	$('#DeleteBT').on('click', function(){
		var Rows=StkCatGrid.getSelectedData();
		$.cm({
			ClassName: 'web.DHCSTMHUI.StkCat',
			MethodName: 'Delete',
			Params: JSON.stringify(Rows)
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				StkCatGrid.reload();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	});
	var StkCatCm = [[{
		title: 'RowId',
		field: 'RowId',
		hidden: true
	},{
		title: '����',
		field: 'Code',
		width: 100,
		editor: {type:'validatebox',options:{required:true}}
	},{
		title: '����',
		field: 'Description',
		width: 150,
		editor: {type:'validatebox',options:{required:true}}
	},{
		title: '���ʴ���ǰ׺',
		field: 'Prefix',
		width:100,
		editor: {type:'validatebox'}
	}
	]]
	var StkCatGrid = $UI.datagrid('#StkCatList',{
		lazy:false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.StkCat',
			QueryName: 'SelectAll',
			Params: JSON.stringify(addSessionParams({}))
		},
		columns: StkCatCm,
		toolbar:'#StkCatTB',
		sortName: "RowId",
		sortOrder: 'Desc',
		onClickCell: function(index, filed ,value){
			var Row=StkCatGrid.getRows()[index]
			StkCatGrid.commonClickCell(index,filed)
		} 
	})
	
}
$(init);