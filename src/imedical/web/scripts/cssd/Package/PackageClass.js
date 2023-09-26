var init = function() {
	var NotUseFlagData = [{ "RowId":"Y", "Description":"��"},{ "RowId":"N", "Description":"��"}]
	var NotUseFlagCombox = {
		type: 'combobox',
		options: {
			data: NotUseFlagData,
			valueField: 'RowId',
			textField: 'Description'
		}
	}
	
	var BusinessFlagData = [{ "RowId":"W", "Description":"������е"},{ "RowId":"N", "Description":"�ھ�"}]
	var BusinessCombox = {
		type: 'combobox',
		options: {
			data: BusinessFlagData,
			valueField: 'RowId',
			textField: 'Description'
		}
	}
	
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
			ClassName: 'web.CSSDHUI.PackageInfo.PackageClass',
			MethodName: 'Save',
			Params: JSON.stringify(Rows)
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				GridList.reload();
			}else {
				$UI.msg("error", jsonData.msg);
			}
		});
	});
	$('#DeleteBT').on('click', function(){
		GridList.commonDeleteRow();
		var Rows = $('#GridList').datagrid('getSelected');
		if(!isEmpty(Rows)&&!isEmpty(Rows.RowId)){
			$UI.msg('alert','��ά����������������ֻ��ͣ��,����ɾ��');
			}
		//if(!isEmpty(Rows)){
		//	MainRowId = Rows.RowId;
		//}
		if(isEmpty(MainRowId)&&!isEmpty(Rows)){
			GridList.commonDeleteRow();
			var MainRowId = $('#GridList').datagrid('getSelected');
			return false;
		}
		if (isEmpty(MainRowId)) {
			$UI.msg('alert','��ѡ��Ҫɾ��������!');
		 	return false;
		}
		$.messager.confirm("������ʾ","��ȷ��Ҫִ��ɾ��������",function(data){	
			if(data){
				$.cm({
					ClassName: 'web.CSSDHUI.PackageInfo.PackageClass',
					MethodName: 'Delete',
					rowId: Rows.RowId
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						GridList.reload();
					}else{
						$UI.msg('error',jsonData.msg)
					}
				});
			}
		});
	});
	var OptypeCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '����',
			field: 'Code',
			width:100,
			fitColumns:true,
			editor:{type:'validatebox',options:{required:true}}
		}, {
			title: '����',
			field: 'Description',
			width:150,
			fitColumns:true,
			editor:{type:'validatebox',options:{required:true}}
		}, {
			title: '��ʶ',
			field: 'BusinessProcess',
			width:150,
			fitColumns:true,
			formatter: CommonFormatter(BusinessCombox, 'BusinessFlag', 'BusinessFlagDesc'),
			editor: BusinessCombox
		},{
			title: '�Ƿ�����',
			align:'center',
			field: 'NotUseFlag',
			width:100,
			formatter: CommonFormatter(NotUseFlagCombox, 'NotUseFlag', 'NotUseFlagDesc'),
			editor: NotUseFlagCombox
		}
	]];
	var GridList = $UI.datagrid('#GridList', {
		url: $URL,
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.PackageClass',
			QueryName: 'SelectAll'				
		},
		columns: OptypeCm,
		toolbar: "#OptypeTB",
		pagination:false,
		lazy:false,
		onClickCell: function(index, filed ,value){
			var Row=GridList.getRows()[index]
			GridList.commonClickCell(index,filed)
		} 
	})	
}
$(init);