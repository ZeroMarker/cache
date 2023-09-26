//器械维护界面js
var init = function() {
	var UseFlagData = [{ "RowId":"Y", "Description":"使用"},{ "RowId":"N", "Description":"停用"}]
	var UseFlagCombox = {
		type: 'combobox',
		options: {
			data: UseFlagData,
			valueField: 'RowId',
			textField: 'Description'
		}
	} 
	$UI.linkbutton('#SearchBT',{ 
		onClick:function(){
			var Params = JSON.stringify($UI.loopBlock('PackageItemTB'));
			GridList.load({
				ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
				QueryName: 'SelectAll',
				Params: Params
			});
		}
	});
	$UI.linkbutton('#ClearBT',{ 
		onClick:function(){
			$UI.clearBlock('PackageItemTB');
			$UI.clear(GridList);
		}
	});
	$('#AddBT').on('click', function(){
		GridList.commonAddRow();
	});
	$('#SaveBT').on('click', function(){
		var Rows=GridList.getChangesData();
		if(isEmpty(Rows)){
			//$UI.msg('alert','没有需要保存的信息!');
			return;
		}
		$.cm({
			ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
			MethodName: 'Save',
			Params: JSON.stringify(Rows)
		},function(jsonData){
			$UI.msg('success',jsonData.msg);
			if(jsonData.success==0){
				GridList.reload();
			}else{
				$UI.msg('error',jsonData.msg);
			 }
		});
	});
	$UI.linkbutton('#DeleteBT',{ 
		onClick:function (){
			GridList.commonDeleteRow();
			Delete();
		}
	});
	
	function Delete(){
		var Rows=GridList.getSelectedData()
		if(isEmpty(Rows)){
			//$UI.msg('alert','没有选中的信息!')
			return;
		}
		$.messager.confirm("操作提示","您确定要执行删除操作吗？",function(data){
			if(data){
				$.cm({
					ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
					MethodName: 'DeleteItem',
					Params: JSON.stringify(Rows)
					},function(jsonData){
						if(jsonData.success==0){
							$UI.msg('success',jsonData.msg);
							GridList.reload()
						}else{
						 	$UI.msg('error',jsonData.msg);
						}
					});
			}
		});
	}
	
	var Cm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '名称',
			field: 'Description',
			width:250,
			fitColumns:true,
			editor:{type:'validatebox',options:{required:true}}
		}, {
			title: '规格',
			field: 'Spec',
			width:100,
			fitColumns:true,
			editor:{type:'validatebox',options:{required:false}}
		}, {
			title: '价格',
			align:'right',
			field: 'Price',
			width:100,
			fitColumns:true,
			editor:{type:'numberbox',options:{required:false}}
		}, {
			title: '是否可用',
			align:'center',
			field: 'UseFlag',
			width:150,
			fitColumns:true,
			formatter: CommonFormatter(UseFlagCombox,'UseFlag','UseFlagDesc'),
			editor:UseFlagCombox
		}, {
			title: '备注',
			field: 'Remarks',
			width:250,
			fitColumns:true,
			editor:{type:'validatebox'}
		}
	]];

	var GridList = $UI.datagrid('#GridList', {
		url: $URL,
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
			QueryName: 'SelectAll'				
		},
		//deleteRowParams: {
			//ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
			//MethodName: 'DeleteItem'
		//},
		columns: Cm,
		toolbar: "#PackageItemTB",
		//sortName: "Description",
		lazy:false,
		onClickCell: function(index, filed ,value){
			var Row=GridList.getRows()[index]
			GridList.commonClickCell(index,filed)
		} 
	})	
}
$(init);