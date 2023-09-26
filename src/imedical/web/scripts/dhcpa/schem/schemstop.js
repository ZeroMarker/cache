stopSchemFun=function(SchemDs,SchemGrid,SchemPagingToolbar,flag){

	
	var mess= flag=="stop"?"停用":"启用";
	var rowObj = SchemGrid.getSelectionModel().getSelections();
	console.log(rowObj);
	var len = rowObj.length;
	if(len<1){
		
		Ext.Msg.show({title:'注意',msg:'请选择要'+mess+'的数据！',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		var rowid=rowObj[0].get("rowid");
		Ext.MessageBox.confirm('提示','确实要'+mess+'该条记录吗?',function(btn){
			if(btn=="yes"){
				Ext.Ajax.request({
					url: 'dhc.pa.schemexe.csp?action=stopSchem&rowid='+rowid+'&flag='+flag,
					waitMsg:mess+'中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:mess+'成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							SchemDs.load({params:{start:0,limit:SchemPagingToolbar.pageSize}});
						}else{
							Ext.Msg.show({title:'错误',msg:mess+'失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}
		});	
	
	}
	
}