fundel = function() {

		//���岢��ʼ���ж���
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ��������! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
			//alert(rowid);
		}
		function handler(id){
			if(id=="yes"){
			
				  Ext.each(rowObj, function(record) {
				  if (Ext.isEmpty(record.get("rowid"))) {
				  itemGrid.getStore().remove(record);
				  return;}
					Ext.Ajax.request({
						url:'../csp/herp.acct.acctcashflowitemmainexe.csp?action=del&rowid='+rowid+'&acctbookid='+acctbookid,
						waitMsg:'ɾ����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
								//detailGrid.load({params:{start:0, limit:20,checkmainid:rowid}});
							}else{
								//Ext.Msg.show({title:'����',msg:'ɾ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								var message="";
								if(jsonData.info=='msg') message='ɾ��ʧ�ܣ�����Ŀ�����Ӽ���Ŀ�� ';
								Ext.Msg.show({title:'��ʾ',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							}
						},
						scope: this
					});
				});
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪɾ��������¼��? ',handler);
}


