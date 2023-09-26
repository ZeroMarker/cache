delFun = function(dataStore,grid,pagingTool,monthDr) {
    // get the selected items
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
					              url: vouchDatasUrl+'?action=del&id='+rowObj[i].get("rowid"),
												waitMsg:'ɾ����...',
						            failure: function(result, request) {
						            		Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
												success: function(result, request) {
														var jsonData = Ext.util.JSON.decode( result.responseText );
						                if (jsonData.success=='true') { 
						                		if (i==len-1) Ext.MessageBox.alert('��ʾ', 'ɾ�����');
											    			dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize,monthDr:monthDr}});
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
    	 if (monthDr == "") {
            Ext.Msg.show({ title: '����', msg: '��ѡ�������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
            return;
        }
        Ext.MessageBox.confirm('��ʾ',
    	    'ȷ��Ҫɾ����������ô?',
    	    function(btn) {
    	        if (btn == 'yes') {

    	            Ext.Ajax.request({
    	                url: vouchDatasUrl + '?action=delall&monthDr=' + monthDr,
    	                waitMsg: 'ɾ����...',
    	                failure: function(result, request) {
    	                    Ext.Msg.show({ title: '����', msg: '������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
    	                },
    	                success: function(result, request) {
    	                    var jsonData = Ext.util.JSON.decode(result.responseText);
    	                    if (jsonData.success == 'true') {
								Ext.MessageBox.alert('��ʾ', 'ɾ�����');
    	                        dataStore.load({ params: { start: pagingTool.cursor, limit: pagingTool.pageSize, monthDr: monthDr} });
    	                    }
    	                    else {
    	                        var message = "SQLErr: " + jsonData.info;
    	                        Ext.Msg.show({ title: '����', msg: message, buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
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
    	Ext.MessageBox.confirm('��ʾ', 
    	    'ȷ��Ҫɾ��ѡ������?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {	
				        for(var i = 0; i < len; i++){     		
					          Ext.Ajax.request({
					              url: vouchDatasUrl+'?action=del&id='+rowObj[i].get("rowid"),
												waitMsg:'ɾ����...',
						            failure: function(result, request) {
						            		Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
												success: function(result, request) {
														var jsonData = Ext.util.JSON.decode( result.responseText );
						                if (jsonData.success=='true') { 
						                		if (i==len-1) Ext.MessageBox.alert('��ʾ', 'ɾ�����');
											    			dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
									    			}
									    			else {
									    					var message =  jsonData.info;
									    					Ext.Msg.show({title:'��ʾ',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
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
            Ext.Msg.show({ title: '����', msg: '��ѡ�������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
            return;
        }
        Ext.MessageBox.confirm('��ʾ',
    	    'ȷ��Ҫɾ����������ô?',
    	    function(btn) {
    	        if (btn == 'yes') {

    	            Ext.Ajax.request({
    	                url: vouchDatasUrl + '?action=delload1&monthDr=' + monthDr,
    	                waitMsg: 'ɾ����...',
    	                failure: function(result, request) {
    	                    Ext.Msg.show({ title: '����', msg: '������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
    	                },
    	                success: function(result, request) {
    	                    var jsonData = Ext.util.JSON.decode(result.responseText);
    	                    if (jsonData.success == 'true') {
							     var message=jsonData.info
								 Ext.Msg.show({ title: '��ʾ', msg: message, buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
    	                        dataStore.load({ params: { start: pagingTool.cursor, limit: pagingTool.pageSize, monthDr: monthDr} });
    	                    }
    	                    else {
    	                        var message = jsonData.info;
    	                        Ext.Msg.show({ title: '��ʾ', msg: message, buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
    	                    }
    	                },
    	                scope: this
    	            });

    	        }
    	    }
		);
    }       

};