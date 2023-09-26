stopSchemFun=function(SchemDs,SchemGrid,SchemPagingToolbar,flag){

	
	var mess= flag=="stop"?"ͣ��":"����";
	var rowObj = SchemGrid.getSelectionModel().getSelections();
	console.log(rowObj);
	var len = rowObj.length;
	if(len<1){
		
		Ext.Msg.show({title:'ע��',msg:'��ѡ��Ҫ'+mess+'�����ݣ�',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		var rowid=rowObj[0].get("rowid");
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ'+mess+'������¼��?',function(btn){
			if(btn=="yes"){
				Ext.Ajax.request({
					url: 'dhc.pa.schemexe.csp?action=stopSchem&rowid='+rowid+'&flag='+flag,
					waitMsg:mess+'��...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'ע��',msg:mess+'�ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							SchemDs.load({params:{start:0,limit:SchemPagingToolbar.pageSize}});
						}else{
							Ext.Msg.show({title:'����',msg:mess+'ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}
		});	
	
	}
	
}