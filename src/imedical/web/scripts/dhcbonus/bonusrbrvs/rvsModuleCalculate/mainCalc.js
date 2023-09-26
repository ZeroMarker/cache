
mainCalcFun = function(){
	
	var rowObj = ModuleCalTab.getSelectionModel().getSelections();
	var len = rowObj.length;
	var tmpRowid = "";
	
	if (len < 1) {
		Ext.Msg.show({
					title : 'ע��',
					msg : '��ѡ����Ҫ���������!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return;
	} else {
		tmpRowid = rowObj[0].get("rowid");
	}
	
	tmpData=rowObj[0].get("rvsTemplateMainID")+"^"+rowObj[0].get("operateDate")+"^"+rowObj[0].get("rowid");
	//alert(tmpData)
					       
	Ext.Ajax.request({
						url : ModuleCalTabUrl + '?action=mainCalc&data=' + tmpData,
								
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
								ModuleCalTabDs.load({
											params : {
												start : 0,
												limit : ModuleCalTabPagingToolbar.pageSize
											}
										});
								
								
								
							}else {
								var tmpmsg = '';
								if (jsonData.info == '1') {
									tmpmsg = '�����ظ�!';
								}else if(jsonData.info == '100'){
									tmpmsg = '��������Ϊ��';
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


