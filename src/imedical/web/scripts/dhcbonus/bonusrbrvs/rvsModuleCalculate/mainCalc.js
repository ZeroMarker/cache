
mainCalcFun = function(){
	
	var rowObj = ModuleCalTab.getSelectionModel().getSelections();
	var len = rowObj.length;
	var tmpRowid = "";
	
	if (len < 1) {
		Ext.Msg.show({
					title : '注意',
					msg : '请选择需要测算的数据!',
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
								ModuleCalTabDs.load({
											params : {
												start : 0,
												limit : ModuleCalTabPagingToolbar.pageSize
											}
										});
								
								
								
							}else {
								var tmpmsg = '';
								if (jsonData.info == '1') {
									tmpmsg = '编码重复!';
								}else if(jsonData.info == '100'){
									tmpmsg = '测算数据为空';
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


