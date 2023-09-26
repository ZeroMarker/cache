delFun = function(dataStore,grid,pagingTool) {
    // get the selected items
   var rowObj = grid.getSelections();
   var len = rowObj.length;
   if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
    {
    	    myRowid = rowObj[0].get("rowid");
			Ext.MessageBox.confirm('提示',
    	    '确定要删除选定的行?',
    	    function(btn) {
	    	     if(btn == 'yes')
		         {
					          Ext.Ajax.request({
					              url: InterLocUrl+'?action=del&rowid='+myRowid,
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