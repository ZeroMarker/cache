//ɾ������
delFun = function(node){
	if(node!=null){
		if(node.attributes.id=="roo"){
			Ext.Msg.show({title:'��ʾ',msg:'���ڵ㲻��ɾ��!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return false;
		}else{
			var end = node.attributes.LastStage;
			//if(end==1){
				//��ȡ��¼��ID
				var rowid = node.attributes.id;
				var parent = node.attributes.parent;
				function handler(id){
					if(id=="yes"){
						Ext.Ajax.request({
							url:'../csp/dhc.bonus.bonussubitemexe.csp?action=del&rowid='+rowid,
							waitMsg:'ɾ����...',
							failure: function(result, request){
								Ext.Msg.show({title:'����',msg:'������������!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Ajax.request({
										url:'../csp/dhc.bonus.bonussuitemexe.csp?action=findfather&parent='+parent,
										waitMsg:'ɾ����...',
										failure: function(result, request){
											Ext.Msg.show({title:'��ʾ',msg:'�Ѿ�ɾ���ɹ�,����ˢ������ʧ��,��Ӱ������',width:300,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
										},
										success: function(result, request){
											var jsonData = Ext.util.JSON.decode( result.responseText );
											if (jsonData.success=='true') {
												Ext.Msg.show({title:'��ʾ',msg:'ɾ���ɹ�!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
												if(jsonData.info=='true'){
													jsonData.info="roo";
													Ext.Msg.show({title:'��ʾ',msg:'ɾ���ɹ�!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
													Ext.getCmp('detailReport').getNodeById(jsonData.info).reload();
													
												}
												Ext.getCmp('detailReport').getNodeById(jsonData.info).reload();
											}
										},
										scope: this
									});
								}else {
									
									if(jsonData.info=='false'){
										Ext.Msg.show({title:'��ʾ',msg:'�ü�¼�´����ӽڵ�,����ɾ��!',width:300,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									}
				
									if(jsonData.info=='true'){
										Ext.Msg.show({title:'��ʾ',msg:'ɾ���ɹ�!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										jsonData.info="roo";
										Ext.getCmp('detailReport').getNodeById(jsonData.info).reload();
									}
								}
							},
							scope: this
						});
					}else{
						return false;
					}
				}
				Ext.MessageBox.confirm('��ʾ','ȷʵҪɾ����?',handler);
			//}else{
				//Ext.Msg.show({title:'��ʾ',msg:'��ĩ�˲���ɾ��!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			//}
		}
	}else{
		Ext.Msg.show({title:'����',msg:'��ѡ���¼��',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	}
};
