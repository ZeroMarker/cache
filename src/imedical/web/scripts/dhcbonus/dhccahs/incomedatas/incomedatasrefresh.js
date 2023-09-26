var refresh = function(dataStore,grid,pagingTool,monthDr,ruleDr) {
 	var loadMask = new Ext.LoadMask(document.body, {msg : '正在向服务器发送请求...'});
	 var rowObj = grid.getSelections();
     var len = rowObj.length;
    if(len > 0)
    {
    	Ext.MessageBox.confirm('提示', 
    	'确定要刷新选定的行?', 
    	 function(btn) 
    	   {
	    	 if(btn == 'yes')
		       {	
			//var loadMask = new Ext.LoadMask(document.body, {msg : '正在向服务器发送请求...'});
				 for(var i = 0; i < len; i++)
				   {      
					loadMask.show();		
					 Ext.Ajax.request
					 ({
					   url: 'dhc.ca.incomedatasexe.csp?action=refresh&monthDr='+monthDr+'&ruleDr='+ruleDr+'&id='+rowObj[i].get("rowid"),
					   waitMsg:'刷新中...',
					   failure: function(result, request) { loadMask.hide();Ext.Msg.show({title:'提示',msg:'请检查网络连接!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});},
					   success: function(result, request) 
					   {
						loadMask.hide();
					    var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') 
						  { 
						    if (i==len-1)	
						    Ext.Msg.show({title:'提示',msg:'刷新成功!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							dataStore.load({params:{start:pagingTool.cursor,limit:pagingTool.pageSize,monthDr:monthDr}});
						   }
						else 
						   {
							 var message = "SQLErr: " + jsonData.info;
							 Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
 	//var loadMask = new Ext.LoadMask(document.body, {msg : '正在向服务器发送请求...'});
        Ext.MessageBox.confirm('提示',
    	    '确定要刷新当月数据么?',
    	    function(btn) {
    	        if (btn == 'yes') {

			loadMask.show();	
    	               Ext.Ajax.request({
    	               url: 'dhc.ca.incomedatasexe.csp?action=refresh&monthDr='+monthDr+'&ruleDr='+ruleDr+'&id='+"",
    	                waitMsg: '刷新中...',
    	                failure: function(result, request) {
	    	                loadMask.hide();
    	                    Ext.Msg.show({ title: '提示', msg: result, buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
    	                },
    	                success: function(result, request) {
	    	                loadMask.hide();
    	                    var jsonData = Ext.util.JSON.decode(result.responseText);
    	                    if (jsonData.success == 'true') {
								var message=jsonData.info
								Ext.Msg.show({ title: '提示', msg: message, buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
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
	
