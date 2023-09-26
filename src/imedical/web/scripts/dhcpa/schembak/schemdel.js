delSchemFun = function(dataStore,grid,pagingTool){
    //���岢��ʼ���ж���
	var rowObj=grid.getSelectionModel().getSelections();
	//���岢��ʼ���ж��󳤶ȱ���
	var len = rowObj.length;
	//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		var myRowid = rowObj[0].get("rowid");
	}
	function handler(id){
		if(id=="yes"){
			Ext.Ajax.request({
				url: 'dhc.pa.schemexe.csp?action=del&rowid='+myRowid,
				waitMsg:'ɾ����...',
				failure: function(result, request){
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						dataStore.load({params:{start:0,limit:pagingTool.pageSize}});
					}else{
						Ext.Msg.show({title:'����',msg:'ɾ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				},
				scope: this
			});
		}else{
			return;
		}
	}
	Ext.MessageBox.confirm('��ʾ','ȷʵҪɾ��������¼��?',handler);
};