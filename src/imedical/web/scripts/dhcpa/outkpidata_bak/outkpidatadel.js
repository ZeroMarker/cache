delFun = function(dataStore,grid,pagingTool) {
    // get the selected items
    if((cycleField.getValue()=="")||(cycleField.getValue().length==0))
	{
		
		Ext.Msg.show({title:'注意',msg:'请选择年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}
	else if((periodTypeField.getValue()=="")||(periodTypeField.getValue().length==0))
	{
		
		Ext.Msg.show({title:'注意',msg:'请选择期间类型!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}
	else if((periodField.getValue()=="")||(periodField.getValue().length==0))
	{
		
		Ext.Msg.show({title:'注意',msg:'请选择期间!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}
	else
    {
    	Ext.MessageBox.confirm('提示',
    	    '确定要删除选定的行?',
    	    function(btn) {
	    	     if(btn == 'yes')
		         {
					          Ext.Ajax.request({
					              url: OutKPIDataUrl+'?action=del&CycleDr='+cycleField.getValue()+'&frequency='+periodTypeField.getValue()+'&period='+periodField.getValue(),
												waitMsg:'删除中...',
						            failure: function(result, request) {
						            		Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
												success: function(result, request) {
														var jsonData = Ext.util.JSON.decode( result.responseText );
						                if (jsonData.success=='true') {
						                		 Ext.MessageBox.alert('提示', '删除完成');
											    			dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
									    			}
									    			else {
									    					var message = "SQLErr: " + jsonData.info;
									    					Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									    			}
												},
					               scope: this
					          });
			    }
		    }
		);
    }
};