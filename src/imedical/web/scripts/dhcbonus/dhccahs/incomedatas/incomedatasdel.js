delFun = function(dataStore,grid,pagingTool) {
    // get the selected items
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
					              url: incomeDatasUrl+'?action=del&id='+rowObj[i].get("rowid"),
												waitMsg:'删除中...',
						            failure: function(result, request) {
						            		Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
												success: function(result, request) {
														var jsonData = Ext.util.JSON.decode( result.responseText );
						                if (jsonData.success=='true') { 
						                		if (i==len-1) Ext.MessageBox.alert('提示', '删除完成');
											    			dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize, monthDr:monthDr}});
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
		    } 
		);	
    }
    else
    {
    	//Ext.Msg.show({title:'错误',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
    	if(monthDr=="")
			{
				Ext.Msg.show({title:'注意',msg:'请选择月份后再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
				Ext.MessageBox.confirm('提示', 
					'确定要删除此月的数据?', 
					function(btn) {
						if(btn == 'yes'){
							//--------------------------------------
							Ext.Ajax.request({
								url: incomeDatasUrl+'?action=delMonth&monthDr='+monthDr,
								waitMsg:'保存中...',
								failure: function(result, request) {
									Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										dataStore.setDefaultSort('rowid', 'desc');
										dataStore.load({params:{start:0, limit:pagingTool.pageSize, monthDr:monthDr}});
										//window.close();
									}
									else
									{
										var message = "";
										message = "SQLErr: " + jsonData.info;
										Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									}
								},
							scope: this
							});
							//--------------------------------------
						}
					}
				)
    }       

};
delRemarkFun = function(dataStore,grid,pagingTool) {
    // get the selected items
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
					              url: incomeDatasUrl+'?action=delRemark&remark='+rowObj[i].get("remark"),
												waitMsg:'删除中...',
						            failure: function(result, request) {
						            		Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
												success: function(result, request) {
														var jsonData = Ext.util.JSON.decode( result.responseText );
						                if (jsonData.success=='true') { 
						                		if (i==len-1) Ext.MessageBox.alert('提示', '删除完成');
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
		    } 
		);	
    }
    else
    {
    	Ext.Msg.show({title:'错误',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
    }       

};