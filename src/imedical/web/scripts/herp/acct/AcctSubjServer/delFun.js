delFun = function() {
	var rowObj = itemGrid.getSelectionModel().getSelections();
	
    var len = rowObj.length;
   
     if(len == 1){
    	Ext.MessageBox.confirm('��ʾ', 
    	    'ȷ��Ҫɾ��ѡ������?', 
    	    function(btn) {
	    	if(btn == 'yes'){	
				var rowid=rowObj[0].get("rowid");	
				Ext.Ajax.request({
				  url:'herp.acct.acctsubjserverexe.csp?action=isfathercode&rowid='+rowid,
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') { 
						var data = jsonData.info;
						if(data==0){			
						Ext.Ajax.request({
						url:'herp.acct.acctsubjserverexe.csp?action=delsj&rowid='+rowid,
						waitMsg:'ɾ����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
								CheckitemGrid.load({params:{start:0,limit:25}});
							}else{
								Ext.Msg.show({title:'����',msg:'�ÿ�Ŀ������,ɾ��ʧ��!  ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});			                
					} else if(data==1){
						Ext.MessageBox.confirm('��ʾ', '�����ӿ�Ŀ��ȷ��Ҫɾ��ѡ������?', 
    	    			function(btn){
						if(btn == 'yes'){	
							Ext.Ajax.request({
							url:'herp.acct.acctsubjserverexe.csp?action=delsj&rowid='+rowid,
							waitMsg:'ɾ����...',
							failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
								CheckitemGrid.load({params:{start:0,limit:25}});
								}else{
									Ext.Msg.show({title:'����',msg:'�ÿ�Ŀ������,ɾ��ʧ��!  ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
							});
						}
						});
						}
						}
					},
					scope: this
				});
			    }
		    });	
    }else if(len<1)
    {
    	Ext.Msg.show({title:'����',msg:'��ѡ����Ҫɾ��������! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
    }else if(len>1){
	    Ext.MessageBox.confirm('��ʾ', 
    	    'ȷ��Ҫɾ��ѡ������?', 
    	function(btn) {
		if(btn == 'yes'){
			for(var i = 0; i < len; i++){   
			var rowid=rowObj[i].get("rowid");
			Ext.Ajax.request({
				url:'herp.acct.acctsubjserverexe.csp?action=delsj&rowid='+rowid,
				waitMsg:'ɾ����...',
				failure: function(result, request){
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
						CheckitemGrid.load({params:{start:0,limit:25}});
					}else{
						Ext.Msg.show({title:'����',msg:'�ÿ�Ŀ������,ɾ��ʧ��! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				},
				scope: this
			});	
			}
		}
		});
		
	}

}


