//提交至科研处
submitFun = function()
{	
	var rowObj = EthicResultGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1)
	{
		Ext.Msg.show({title:'提示',msg:'请选择需要提交的审核结果!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		var allotRowid = rowObj[0].get("rowid");

		Ext.Ajax.request
		({
			url:  projUrl+'?action=sub&rowid='+allotRowid,
			waitMsg:'保存中...',
			failure: function(result, request)
			{			
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request)
			{				
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true')
				{								
					Ext.Msg.show({title:'注意',msg:'提交成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					itemGrid.load({params:{start:0,limit:25}});
				}
				else
				{
					var message = "";
					message = jsonData.info;
					Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			},
			scope: this
		});	
	}	
};