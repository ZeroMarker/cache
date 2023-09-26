delFun = function(dataStore,grid) {
    var rowObj = grid.getSelectionModel().getSelections();
    var len = rowObj.length;
    if(len > 0)
    {
    	Ext.MessageBox.confirm('��ʾ', 
    	    'ȷ��Ҫɾ��ѡ������?', 
    	    function(btn) {
	    	    if(btn == 'yes'){	
				    for(var i = 0; i < len; i++){     		
					    Ext.Ajax.request({
					        url:'dhc.cs.baseexe.csp?action=delacctyearperiod&rowid='+rowObj[i].get("rowid"),
							waitMsg:'ɾ����...',
						    failure: function(result, request) {
						    		Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						        if (jsonData.success=='true') { 
						        	if (i==len-1) Ext.MessageBox.alert('��ʾ', 'ɾ�����');
									dataStore.load();
							    }else{
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
    }else{
    	Ext.Msg.show({title:'����',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
    }       
};