//��еά������js
var init = function() {
	var UseFlagData = [{ "RowId":"Y", "Description":"ʹ��"},{ "RowId":"N", "Description":"ͣ��"}]
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
			//$UI.msg('alert','û����Ҫ�������Ϣ!');
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
			//$UI.msg('alert','û��ѡ�е���Ϣ!')
			return;
		}
		$.messager.confirm("������ʾ","��ȷ��Ҫִ��ɾ��������",function(data){
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
			title: '����',
			field: 'Description',
			width:250,
			fitColumns:true,
			editor:{type:'validatebox',options:{required:true}}
		}, {
			title: '���',
			field: 'Spec',
			width:100,
			fitColumns:true,
			editor:{type:'validatebox',options:{required:false}}
		}, {
			title: '�۸�',
			align:'right',
			field: 'Price',
			width:100,
			fitColumns:true,
			editor:{type:'numberbox',options:{required:false}}
		}, {
			title: '�Ƿ����',
			align:'center',
			field: 'UseFlag',
			width:150,
			fitColumns:true,
			formatter: CommonFormatter(UseFlagCombox,'UseFlag','UseFlagDesc'),
			editor:UseFlagCombox
		}, {
			title: '��ע',
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