delFun = function(dataStore,grid,pagingTool) {
    // get the selected items
   var rowObj = grid.getSelections();
   var len = rowObj.length;
   if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
    {
    	    myRowid = rowObj[0].get("rowid");
			Ext.MessageBox.confirm('��ʾ',
    	    'ȷ��Ҫɾ��ѡ������?',
    	    function(btn) {
	    	     if(btn == 'yes')
		         {
					          Ext.Ajax.request({
					              url: InterLocUrl+'?action=del&rowid='+myRowid,
												waitMsg:'ɾ����...',
						            failure: function(result, request) {
						            		Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
												success: function(result, request) {
														var jsonData = Ext.util.JSON.decode( result.responseText );
						                if (jsonData.success=='true') {
						                		 Ext.MessageBox.alert('��ʾ', 'ɾ�����');
											    			dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
									    			}
									    			else {
									    					var message = "SQLErr: " + jsonData.info;
									    					Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									    			}
												},
					               scope: this
					          });
			    }
		    }
		);
    }
};