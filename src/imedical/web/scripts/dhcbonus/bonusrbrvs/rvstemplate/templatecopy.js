
templateCopytFun = function(){
	
	
	var rowObj = templateMain.getSelectionModel().getSelections();
	var len = rowObj.length;
	var tmpRowid = "";
	
	if (len < 1) {
		Ext.Msg.show({
					title : '注意',
					msg : '请选择需要复制的数据!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return;
	} else {
		
		tmpRowid = rowObj[0].get("rowid");
	}
					       
	Ext.Ajax.request({
						url : TemplateUrl + '?action=copy&data=' + tmpSelectedTemplate,
								
						waitMsg : '保存中...',
						failure : function(result, request) {
							Ext.Msg.show({
										title : '错误',
										msg : '请检查网络连接!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						},
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
											title : '注意',
											msg : '操作成功!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO
										});
								TemplateDs.load({
											params : {
												start : 0,
												limit : TemplatePagingToolbar.pageSize
											}
										});
								
								
								
							} else {
								var tmpmsg = '';
								if (jsonData.info == '1') {
									tmpmsg = '编码重复!';
								}
								Ext.Msg.show({
											title : '错误',
											msg : tmpmsg,
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							} 
						}
						
					});
	
	
	
	
	
	
};


