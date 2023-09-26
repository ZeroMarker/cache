delMeasDevDeptsFun = function(dataStore,grid,pagingTool,parRef) {

    var measDevDeptsUrl = 'dhc.ca.measdevdeptsexe.csp';
    var rowObj = grid.getSelections();
    var len = rowObj.length;
    if(len > 0)
    {
    	Ext.MessageBox.confirm('提示', 
    	    '确定要删除选定的行?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {	
				        for(var i = 0; i < len; i++){     		
					          Ext.Ajax.request({
					              url: measDevDeptsUrl+'?action=del&id='+rowObj[i].get("rowId"),
												waitMsg:'删除中...',
						            failure: function(result, request) {
						            		Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
												success: function(result, request) {
														var jsonData = Ext.util.JSON.decode( result.responseText );
						                if (jsonData.success=='true') { 
						                		if (i==len-1) Ext.MessageBox.alert('提示', '删除完成');
											    			dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
											    			
											    			Ext.Ajax.request({
																		url: measDevDeptsUrl+'?action=percent&id='+parRef,
																		waitMsg:'保存中...',
																		failure: function(result, request) {
																			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
																		},
																		success: function(result, request) {
																			var jsonData = Ext.util.JSON.decode( result.responseText );
																			var percent=jsonData.info;
																			if (jsonData.success=='true') {
																				if(percent!=100){
																					Ext.Msg.show({title:'注意',msg:'比例不为100%请调整!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
																				}
																				
																			}
	
																		},
																	scope: this
																	});
											    			
									    			}
									    			else {
									    					var message = "SQLErr: " + jsonData.info;
									    					if(jsonData.info=='RepDept') message='输入的部门已经存在!';
									    						Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
    	Ext.Msg.show({title:'错误',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
    }       

};