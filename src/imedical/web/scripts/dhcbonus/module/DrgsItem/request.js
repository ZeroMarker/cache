//此函数用于前后台交互
function request(actions,data){
Ext.Ajax.request({
		//url: StratagemTabUrl+'?action=check&data='+data,
		url: StratagemTabUrl+'?action='+actions+'&data='+data,
		waitMsg : '处理中...',
		failure : function(result, request) {
			Ext.Msg.show({
						title : '错误',
						msg : '请检查网络连接!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
				},
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
					
					Ext.Msg.show({
								    title : '注意',
									msg : '成功!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
											});
					} 
					else {
					        flag = jsonData.info;
							if (flag=="RepCode")
							{
							Ext.Msg.show({
											title : '错误',
											msg : '数据有重复！',
										    buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
											});
							}
							else
							{
							Ext.Msg.show({
											title : '错误',
											msg : '错误！',
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
