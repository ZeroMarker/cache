var refresh = function(dataStore,grid,pagingTool,monthDr,ruleDr) {
 	var loadMask = new Ext.LoadMask(document.body, {msg : '�������������������...'});
	 var rowObj = grid.getSelections();
     var len = rowObj.length;
    if(len > 0)
    {
    	Ext.MessageBox.confirm('��ʾ', 
    	'ȷ��Ҫˢ��ѡ������?', 
    	 function(btn) 
    	   {
	    	 if(btn == 'yes')
		       {	
			//var loadMask = new Ext.LoadMask(document.body, {msg : '�������������������...'});
				 for(var i = 0; i < len; i++)
				   {      
					loadMask.show();		
					 Ext.Ajax.request
					 ({
					   url: 'dhc.ca.incomedatasexe.csp?action=refresh&monthDr='+monthDr+'&ruleDr='+ruleDr+'&id='+rowObj[i].get("rowid"),
					   waitMsg:'ˢ����...',
					   failure: function(result, request) { loadMask.hide();Ext.Msg.show({title:'��ʾ',msg:'������������!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});},
					   success: function(result, request) 
					   {
						loadMask.hide();
					    var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') 
						  { 
						    if (i==len-1)	
						    Ext.Msg.show({title:'��ʾ',msg:'ˢ�³ɹ�!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							dataStore.load({params:{start:pagingTool.cursor,limit:pagingTool.pageSize,monthDr:monthDr}});
						   }
						else 
						   {
							 var message = "SQLErr: " + jsonData.info;
							 Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
 	//var loadMask = new Ext.LoadMask(document.body, {msg : '�������������������...'});
        Ext.MessageBox.confirm('��ʾ',
    	    'ȷ��Ҫˢ�µ�������ô?',
    	    function(btn) {
    	        if (btn == 'yes') {

			loadMask.show();	
    	               Ext.Ajax.request({
    	               url: 'dhc.ca.incomedatasexe.csp?action=refresh&monthDr='+monthDr+'&ruleDr='+ruleDr+'&id='+"",
    	                waitMsg: 'ˢ����...',
    	                failure: function(result, request) {
	    	                loadMask.hide();
    	                    Ext.Msg.show({ title: '��ʾ', msg: result, buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
    	                },
    	                success: function(result, request) {
	    	                loadMask.hide();
    	                    var jsonData = Ext.util.JSON.decode(result.responseText);
    	                    if (jsonData.success == 'true') {
								var message=jsonData.info
								Ext.Msg.show({ title: '��ʾ', msg: message, buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
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
	
