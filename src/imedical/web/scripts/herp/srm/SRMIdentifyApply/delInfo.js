// JavaScript Document
////////////////////ɾ������///////////////////
delFun = function() {
    var rowObj = itemGrid.getSelectionModel().getSelections();     // get the selected items
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
					              url: projUrl+'?action=del&rowid='+rowObj[i].get("rowid"),
												waitMsg:'ɾ����...',
						            failure: function(result, request) {
						            		Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
												success: function(result, request) {
														var jsonData = Ext.util.JSON.decode( result.responseText );
						                if (jsonData.success=='true') { 
						                		Ext.MessageBox.alert('��ʾ', 'ɾ�����');
											    			itemGrid.load({params:{start:0, limit:25,usercode:usercode}});
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