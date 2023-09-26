delMethodsFun = function(dataStore,grid,pagingTool,parRef,deptSetDr,layerDr) {
    // get the selected items
    var rowObj = grid.getSelections();
    var len = rowObj.length;
    if(len > 0)
    {
    	Ext.MessageBox.confirm('��ʾ', 
    	    'ȷ��Ҫɾ��ѡ������?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {	
				        for(var i = 0; i < len; i++){     		
					          Ext.Ajax.request({
					              url: costDistSetsUrl+'?action=delMethod&id='+rowObj[i].get("rowid"),
												waitMsg:'ɾ����...',
						            failure: function(result, request) {
						            		Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
												success: function(result, request) {
														var jsonData = Ext.util.JSON.decode( result.responseText );
						                if (jsonData.success=='true') { 
						                		if (i==len-1) Ext.MessageBox.alert('��ʾ', 'ɾ�����');
											    			dataStore.load({params:{start:0, limit:pagingTool.pageSize,id:parRef,layerDr:layerDr}});
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
		    } 
		);	
    }
    else
    {
    	Ext.Msg.show({title:'����',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
    }       

};