//ɾ������
delFun = function(node){
	if(node!=null){
		if(node.attributes.id=="roo"){
			Ext.Msg.show({title:'��ʾ',msg:'���ڵ㲻��ɾ��!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
			return false;
		}else{
			var end = node.attributes.isend;
			if(end=="Y"){
				//��ȡ��¼��ID
				var rowid = node.attributes.id;
				var parent = node.attributes.parent;
				
				function handler(id){
					if(id=="yes"){
						Ext.Ajax.request({
							url:'../csp/dhc.pa.selfmaintainexe.csp?action=del&rowid='+rowid,
							waitMsg:'ɾ����...',
							failure: function(result, request){
								Ext.Msg.show({title:'����',msg:'������������!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
										Ext.Msg.show({title:'��ʾ',msg:'ɾ���ɹ�!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										Ext.getCmp('detailReport').root.reload();
								}
							},
							scope: this
						});
					}else{
						return false;
					}
				}
				Ext.MessageBox.confirm('��ʾ','ȷʵҪɾ����?',handler);
				
			}else{
						Ext.Ajax.request({
										url:'../csp/dhc.pa.selfmaintainexe.csp?action=findchildren&rowid='+node.attributes.id,
										waitMsg:'ɾ����...',
										failure: function(result, request){
											Ext.Msg.show({title:'��ʾ',msg:'�Ѿ�ɾ���ɹ�,����ˢ������ʧ��,��Ӱ������',width:300,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
										},
										success: function(result, request){
											var jsonData = Ext.util.JSON.decode( result.responseText );											
											if (jsonData.success=='true') {												
											function callback(id){
													if(id=="yes"){
													Ext.Ajax.request({
														url:'../csp/dhc.pa.selfmaintainexe.csp?action=del&rowid='+node.attributes.id,
														waitMsg:'ɾ����...',
														failure: function(result, request){
															Ext.Msg.show({title:'����',msg:'������������!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
														},
														success: function(result, request){
														var jsonData = Ext.util.JSON.decode( result.responseText );
														if (jsonData.success=='true') {
															Ext.Msg.show({title:'��ʾ',msg:'ɾ���ɹ�!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
															Ext.getCmp('detailReport').root.reload();
														}
														},
														scope: this
													});
													}else{
														return false;
													}
											}
											Ext.MessageBox.confirm('��ʾ','ȷʵҪɾ����?',callback);
											}else{											
												Ext.Msg.show({title:'��ʾ',msg:'�ü�¼�´����ӽڵ�,����ɾ��!',width:300,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});											
											}											
										},
										scope: this
										});
			}
		}
	}else{
		Ext.Msg.show({title:'����',msg:'��ѡ���¼��',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	}
};
