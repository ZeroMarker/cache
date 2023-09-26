delFun = function(dataStore,grid,pagingTool) {
    // get the selected items
    var rowObj = grid.getSelections();
    var len = rowObj.length;
    if(len > 0)
    {
    	Ext.MessageBox.confirm('提示', '确定要删除选定的行?', 
    	    function(btn) 
    	    {
	    	     if(btn == 'yes')
		         {	
				        for(var i = 0; i < len; i++)
				        {     
				        	  //--------------
				        	  var active=rowObj[i].get("active");
				        	  if(active=="Y"){
					        	  	Ext.MessageBox.confirm('提示', '<span style="color:blue;">选定用户为有效用户</span>,确定要删除?', 
    	    						function(btn) {
	    	    					 	if(btn == 'yes'){
		    	    					 //alert(i) --1
		    	    					 Ext.Ajax.request({
			    	    					 
						          url: usersUrl+'?action=del&id='+rowObj[i-1].get("rowid"),
						          waitMsg:'删除中...',
						          failure: function(result, request){
							          Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							      },
							      success: function(result, request) {
								      var jsonData = Ext.util.JSON.decode( result.responseText );
								      if (jsonData.success=='true') { 
								      		if (i==len){ Ext.MessageBox.alert('提示', '删除完成');
								      		dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});}
								      }
								      else {
									      	var message = "SQLErr: " + jsonData.info;
									      	Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									  }
								  },
					              scope: this
					          });
		    	    					 //-----
		    	    					};
	    	    					});
					          } //-------------
					          else{
						          //alert(i) --0
					          Ext.Ajax.request({
						          url: usersUrl+'?action=del&id='+rowObj[i].get("rowid"),
						          waitMsg:'删除中...',
						          failure: function(result, request){
							          Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							      },
							      success: function(result, request) {
								      var jsonData = Ext.util.JSON.decode( result.responseText );
								      if (jsonData.success=='true') { 
								      		if (i==len) {Ext.MessageBox.alert('提示', '删除完成');
								      		dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});}
								      }
								      else {
									      	var message = "SQLErr: " + jsonData.info;
									      	Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									  }
								  },
					              scope: this
					          });
					          }//--xinjia
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