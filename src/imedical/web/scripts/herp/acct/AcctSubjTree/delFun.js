delFun = function() {
	// var rowObj = itemGrid.getSelectionModel().getSelections();
    // var len = rowObj.length;
  if(tmpNode!=""){
		var selectrowid=tmpNode.attributes["rowid"];
    	Ext.MessageBox.confirm('��ʾ', 
    	    'ȷ��Ҫɾ��ѡ������?', 
    	    function(btn) {
	    	if(btn == 'yes'){
					//����ѡ���ж��Ƿ�Ϊ��ĩ����Ŀ
				var rowid=tmpNode.attributes["rowid"];
				Ext.Ajax.request({
				  url:'herp.acct.acctsubjserverexe.csp?action=isfathercode&rowid='+rowid,
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') { 
						var data = jsonData.info;
						//�����ĩ����Ŀ
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
								tmpNode.remove();
								// tmpNode.expand(false);
								CheckitemGrid.load({params:{start:0,limit:25}});
							}else{
								Ext.Msg.show({title:'����',msg:'�ÿ�Ŀ������,ɾ��ʧ��!  ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});	
					} else if(data==1){			//��ĩ��
						Ext.MessageBox.confirm('��ʾ', '�����ӿ�Ŀ,���"Yes"��ɾ�������ӿ�Ŀ�����ʹ��,,�Ƿ����?', 
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
									tmpNode.remove();
									tmpNode.expand(false);
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
    }else{
    	Ext.Msg.show({title:'����',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
    }

}


