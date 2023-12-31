delFun = function(dataStore,grid) {
    var rowObj = grid.getSelectionModel().getSelections();
    var len = rowObj.length;
    if(len > 0)
    {
    	Ext.MessageBox.confirm('提示', 
    	    '确定要删除选定的行?', 
    	    function(btn) {
	    	    if(btn == 'yes'){	
				    for(var i = 0; i < len; i++){     		
					    Ext.Ajax.request({
					        url:'dhc.cs.baseexe.csp?action=delacctsysbusitype&rowid='+rowObj[i].get("rowid"),
							waitMsg:'删除中...',
						    failure: function(result, request) {
						    		Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						        if (jsonData.success=='true') { 
						        	if (i==len-1) Ext.MessageBox.alert('提示', '删除完成');
									dataStore.load();
							    }else{
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
    }else{
    	Ext.Msg.show({title:'错误',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
    }       
};