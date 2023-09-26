delMeasDevDeptsFun = function(dataStore,grid,pagingTool,parRef) {

    var measDevDeptsUrl = 'dhc.ca.measdevdeptsexe.csp';
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
					              url: measDevDeptsUrl+'?action=del&id='+rowObj[i].get("rowId"),
												waitMsg:'ɾ����...',
						            failure: function(result, request) {
						            		Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
												success: function(result, request) {
														var jsonData = Ext.util.JSON.decode( result.responseText );
						                if (jsonData.success=='true') { 
						                		if (i==len-1) Ext.MessageBox.alert('��ʾ', 'ɾ�����');
											    			dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
											    			
											    			Ext.Ajax.request({
																		url: measDevDeptsUrl+'?action=percent&id='+parRef,
																		waitMsg:'������...',
																		failure: function(result, request) {
																			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
																		},
																		success: function(result, request) {
																			var jsonData = Ext.util.JSON.decode( result.responseText );
																			var percent=jsonData.info;
																			if (jsonData.success=='true') {
																				if(percent!=100){
																					Ext.Msg.show({title:'ע��',msg:'������Ϊ100%�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
																				}
																				
																			}
	
																		},
																	scope: this
																	});
											    			
									    			}
									    			else {
									    					var message = "SQLErr: " + jsonData.info;
									    					if(jsonData.info=='RepDept') message='����Ĳ����Ѿ�����!';
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