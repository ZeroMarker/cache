//�˺�������ǰ��̨����
function request(actions,data){
Ext.Ajax.request({
		//url: StratagemTabUrl+'?action=check&data='+data,
		url: StratagemTabUrl+'?action='+actions+'&data='+data,
		waitMsg : '������...',
		failure : function(result, request) {
			Ext.Msg.show({
						title : '����',
						msg : '������������!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
				},
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
					
					Ext.Msg.show({
								    title : 'ע��',
									msg : '�ɹ�!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
											});
					} 
					else {
					        flag = jsonData.info;
							if (flag=="RepCode")
							{
							Ext.Msg.show({
											title : '����',
											msg : '�������ظ���',
										    buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
											});
							}
							else
							{
							Ext.Msg.show({
											title : '����',
											msg : '����',
										    buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
											});
							}
										
					}
										
		},
	scope : this
  });
return;
}
