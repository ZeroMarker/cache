delFun = function(dataStore,grid,pagingTool) {
    // get the selected items
    var rowObj = grid.getSelections();
    var len = rowObj.length;
    if(len > 0)
    {
    	Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ��ѡ������?', 
    	    function(btn) 
    	    {
	    	     if(btn == 'yes')
		         {	
				        for(var i = 0; i < len; i++)
				        {     
				        	  //--------------
				        	  var active=rowObj[i].get("active");
				        	  if(active=="Y"){
					        	  	Ext.MessageBox.confirm('��ʾ', '<span style="color:blue;">ѡ���û�Ϊ��Ч�û�</span>,ȷ��Ҫɾ��?', 
    	    						function(btn) {
	    	    					 	if(btn == 'yes'){
		    	    					 //alert(i) --1
		    	    					 Ext.Ajax.request({
			    	    					 
						          url: usersUrl+'?action=del&id='+rowObj[i-1].get("rowid"),
						          waitMsg:'ɾ����...',
						          failure: function(result, request){
							          Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							      },
							      success: function(result, request) {
								      var jsonData = Ext.util.JSON.decode( result.responseText );
								      if (jsonData.success=='true') { 
								      		if (i==len){ Ext.MessageBox.alert('��ʾ', 'ɾ�����');
								      		dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});}
								      }
								      else {
									      	var message = "SQLErr: " + jsonData.info;
									      	Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
						          waitMsg:'ɾ����...',
						          failure: function(result, request){
							          Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							      },
							      success: function(result, request) {
								      var jsonData = Ext.util.JSON.decode( result.responseText );
								      if (jsonData.success=='true') { 
								      		if (i==len) {Ext.MessageBox.alert('��ʾ', 'ɾ�����');
								      		dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});}
								      }
								      else {
									      	var message = "SQLErr: " + jsonData.info;
									      	Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
    	Ext.Msg.show({title:'����',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
    }       

};