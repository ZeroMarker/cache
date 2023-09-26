delFun = function(dataStore,grid,pagingTool,monthDr) {
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
					              url: vouchDatasUrl+'?action=del&id='+rowObj[i].get("rowid"),
												waitMsg:'删除中...',
						            failure: function(result, request) {
						            		Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
												success: function(result, request) {
														var jsonData = Ext.util.JSON.decode( result.responseText );
						                if (jsonData.success=='true') { 
						                		if (i==len-1) Ext.MessageBox.alert('提示', '删除完成');
											    			dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize,monthDr:monthDr}});
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
    	 if (monthDr == "") {
            Ext.Msg.show({ title: '错误', msg: '请选择核算区间再试!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
            return;
        }
        Ext.MessageBox.confirm('提示',
    	    '确定要删除当月数据么?',
    	    function(btn) {
    	        if (btn == 'yes') {

    	            Ext.Ajax.request({
    	                url: vouchDatasUrl + '?action=delall&monthDr=' + monthDr,
    	                waitMsg: '删除中...',
    	                failure: function(result, request) {
    	                    Ext.Msg.show({ title: '错误', msg: '请检查网络连接!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
    	                },
    	                success: function(result, request) {
    	                    var jsonData = Ext.util.JSON.decode(result.responseText);
    	                    if (jsonData.success == 'true') {
								Ext.MessageBox.alert('提示', '删除完成');
    	                        dataStore.load({ params: { start: pagingTool.cursor, limit: pagingTool.pageSize, monthDr: monthDr} });
    	                    }
    	                    else {
    	                        var message = "SQLErr: " + jsonData.info;
    	                        Ext.Msg.show({ title: '错误', msg: message, buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
    	                    }
    	                },
    	                scope: this
    	            });

    	        }
    	    }
		);
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
					              url: vouchDatasUrl+'?action=del&id='+rowObj[i].get("rowid"),
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
									    					var message =  jsonData.info;
									    					Ext.Msg.show({title:'提示',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
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
    	 if (monthDr == "") {
            Ext.Msg.show({ title: '错误', msg: '请选择核算区间再试!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
            return;
        }
        Ext.MessageBox.confirm('提示',
    	    '确定要删除当月数据么?',
    	    function(btn) {
    	        if (btn == 'yes') {

    	            Ext.Ajax.request({
    	                url: vouchDatasUrl + '?action=delload1&monthDr=' + monthDr,
    	                waitMsg: '删除中...',
    	                failure: function(result, request) {
    	                    Ext.Msg.show({ title: '错误', msg: '请检查网络连接!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
    	                },
    	                success: function(result, request) {
    	                    var jsonData = Ext.util.JSON.decode(result.responseText);
    	                    if (jsonData.success == 'true') {
							     var message=jsonData.info
								 Ext.Msg.show({ title: '提示', msg: message, buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
    	                        dataStore.load({ params: { start: pagingTool.cursor, limit: pagingTool.pageSize, monthDr: monthDr} });
    	                    }
    	                    else {
    	                        var message = jsonData.info;
    	                        Ext.Msg.show({ title: '提示', msg: message, buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
    	                    }
    	                },
    	                scope: this
    	            });

    	        }
    	    }
		);
    }       

};