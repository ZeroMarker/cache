//ɾ������
delSchemDetailFun = function(node){
	if(node!=null){
		if(node.attributes.parent=="0"){
			Ext.Msg.show({title:'��ʾ',msg:'���ڵ㲻��ɾ��!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return false;
		}else{
			var end = node.attributes.isEnd;
				//��ȡ��¼��ID
				var rowid = node.attributes.detailid;
				var parent = node.attributes.parent;
				function handler(id){
					if(id=="yes"){
						Ext.Ajax.request({
							url:'../csp/dhc.pa.schemexe.csp?action=schemdetaildel&rowid='+rowid,
							waitMsg:'ɾ����...',
							failure: function(result, request){
								Ext.Msg.show({title:'����',msg:'������������!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Ajax.request({
										url:'../csp/dhc.pa.kpiindexexe.csp?action=findfather&parent='+parent,
										waitMsg:'ɾ����...',
										failure: function(result, request){
											Ext.Msg.show({title:'��ʾ',msg:'�Ѿ�ɾ���ɹ�,����ˢ������ʧ��,��Ӱ������',width:300,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
										},
										success: function(result, request){
											var jsonData = Ext.util.JSON.decode( result.responseText );
											if (jsonData.success=='true') {
												Ext.Msg.show({title:'��ʾ',msg:'ɾ���ɹ�!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
												if(jsonData.info==0){
													jsonData.info="roo";
												}
												Ext.getCmp('detailReport').getNodeById(jsonData.info).reload();
											}
										},
										scope: this
									});
								}else {
									if(jsonData.info=='childNode'){
										Ext.Msg.show({title:'��ʾ',msg:'�ü�¼�´����ӽڵ�,����ɾ��!',width:300,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
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
			
		}
	}else{
		Ext.Msg.show({title:'����',msg:'��ѡ���¼��',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	}
};
