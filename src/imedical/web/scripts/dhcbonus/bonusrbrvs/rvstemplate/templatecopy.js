
templateCopytFun = function(){
	
	
	var rowObj = templateMain.getSelectionModel().getSelections();
	var len = rowObj.length;
	var tmpRowid = "";
	
	if (len < 1) {
		Ext.Msg.show({
					title : 'ע��',
					msg : '��ѡ����Ҫ���Ƶ�����!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return;
	} else {
		
		tmpRowid = rowObj[0].get("rowid");
	}
					       
	Ext.Ajax.request({
						url : TemplateUrl + '?action=copy&data=' + tmpSelectedTemplate,
								
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
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
											title : 'ע��',
											msg : '�����ɹ�!',
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
									tmpmsg = '�����ظ�!';
								}
								Ext.Msg.show({
											title : '����',
											msg : tmpmsg,
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							} 
						}
						
					});
	
	
	
	
	
	
};


