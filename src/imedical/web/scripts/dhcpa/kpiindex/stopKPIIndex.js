//ɾ������
stopFun = function(node){
	if(node!=null){
		if(node.attributes.id=="roo"){
			Ext.Msg.show({title:'��ʾ',msg:'���ڵ㲻��ͣ��!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
			return false;
		}else{
			var end = node.attributes.isStop;
			if(end=="N"){
				//��ȡ��¼��ID
				var rowid = node.attributes.id;
				var parent = node.attributes.parent;
				function handler(id){
					if(id=="yes"){
						Ext.Ajax.request({
							url:'../csp/dhc.pa.kpiindexexe.csp?action=stopKPI&rowid='+rowid,
							waitMsg:'������...',
							failure: function(result, request){
								Ext.Msg.show({title:'����',msg:'������������!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'��ʾ',msg:'ͣ�óɹ�!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									if(jsonData.info==0){
										jsonData.info="roo";
									}
									Ext.getCmp('detailReport').getNodeById(jsonData.info).reload();
								}else if(jsonData.info=='childNode'){
										Ext.Msg.show({title:'��ʾ',msg:'�ü�¼�´���δͣ���ӽڵ�,������Ϊͣ��!',width:300,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}
							},
							scope: this
						});
					}else{
						return false;
					}
				}
				Ext.MessageBox.confirm('��ʾ','ȷʵҪͣ�ø�ָ����?',handler);
			}else{
				Ext.Msg.show({title:'��ʾ',msg:'��ָ���Ѿ�ͣ��!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
		}
	}else{
		Ext.Msg.show({title:'����',msg:'��ѡ���¼��',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	}
};
