delFun = function(dataStore,grid,pagingTool) {
    // get the selected items
    if((cycleField.getValue()=="")||(cycleField.getValue().length==0))
	{
		
		Ext.Msg.show({title:'ע��',msg:'��ѡ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}
	else if((periodTypeField.getValue()=="")||(periodTypeField.getValue().length==0))
	{
		
		Ext.Msg.show({title:'ע��',msg:'��ѡ���ڼ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}
	else if((periodField.getValue()=="")||(periodField.getValue().length==0))
	{
		
		Ext.Msg.show({title:'ע��',msg:'��ѡ���ڼ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}
	else
    {
    	Ext.MessageBox.confirm('��ʾ',
    	    'ȷ��Ҫɾ��ѡ������?',
    	    function(btn) {
	    	     if(btn == 'yes')
		         {
					          Ext.Ajax.request({
					              url: OutKPIDataUrl+'?action=del&CycleDr='+cycleField.getValue()+'&frequency='+periodTypeField.getValue()+'&period='+periodField.getValue(),
												waitMsg:'ɾ����...',
						            failure: function(result, request) {
						            		Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
												success: function(result, request) {
														var jsonData = Ext.util.JSON.decode( result.responseText );
						                if (jsonData.success=='true') {
						                		 Ext.MessageBox.alert('��ʾ', 'ɾ�����');
											    			dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
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
		);
    }
};