delFun = function() {
 var userid   = session['LOGON.USERID'];	
 var rowObj = itemGrid.getSelectionModel().getSelections();     
    var len = rowObj.length;
    if(len > 0)
    {
    	Ext.MessageBox.confirm('��ʾ', 
    	    'ȷ��Ҫɾ��ѡ������?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {	
				        for(var i = 0; i < len; i++){   
				        	 var rowid=rowObj[i].get("rowid");
				        	 var data=rowid+"^"+userid;  		
				        	 alert(data);
					          Ext.Ajax.request({
					              url: 'herp.srm.srmapplypaperexe.csp?action=delete&rowid='+rowid+'&userdr='+userid,
												waitMsg:'ɾ����...',
						            failure: function(result, request) {
						            		Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
												success: function(result, request) {
														var jsonData = Ext.util.JSON.decode( result.responseText );
														alert(jsonData);
						                if (jsonData.success=='true') { 
						                		if (i==len-1)Ext.MessageBox.alert('��ʾ', 'ɾ�����');
											    			itemGrid.load({params:{start:0, limit:25}});
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


}


