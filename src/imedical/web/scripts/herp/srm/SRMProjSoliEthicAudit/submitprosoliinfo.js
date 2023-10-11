//�ύ�����д�
submitFun = function()
{	
	var rowObj = EthicResultGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1)
	{
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�ύ����˽��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		var allotRowid = rowObj[0].get("rowid");

		Ext.Ajax.request
		({
			url:  projUrl+'?action=sub&rowid='+allotRowid,
			waitMsg:'������...',
			failure: function(result, request)
			{			
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request)
			{				
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true')
				{								
					Ext.Msg.show({title:'ע��',msg:'�ύ�ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					itemGrid.load({params:{start:0,limit:25}});
				}
				else
				{
					var message = "";
					message = jsonData.info;
					Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			},
			scope: this
		});	
	}	
};