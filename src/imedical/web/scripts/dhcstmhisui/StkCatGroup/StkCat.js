//库存分类维护
//zhangxiao 20180503
var init = function() {
	$('#AddBT').on('click',function(){
		StkCatGrid.commonAddRow();
	})
	$('#SaveBT').on('click',function(){
		var Rows = StkCatGrid.getChangesData();
		if (Rows === false){	//未完成编辑或明细为空
			return;
		}
		if (isEmpty(Rows)){	//明细不变
			$UI.msg("alert", "没有需要保存的明细!");
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
		title: '代码',
		field: 'Code',
		width: 100,
		editor: {type:'validatebox',options:{required:true}}
	},{
		title: '描述',
		field: 'Description',
		width: 150,
		editor: {type:'validatebox',options:{required:true}}
	},{
		title: '物资代码前缀',
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