detailEditFun = function(){
	var rowObj = detailMain.getSelectionModel().getSelections();
	var len = rowObj.length;
	var tmpRowid = "";
	
	if (len < 1) {
		Ext.Msg.show({
					title : '注意',
					msg : '请选择需要修改的数据!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return;
	} else {
		tmpRowid = rowObj[0].get("rowid");
	}
	/*
	useMinuteField.setValue('');
	workRiskField.setValue('');
	techDifficultyField.setValue('');
	workCostField.setValue('');
	makeRateField.setValue('');
	execRateField.setValue('');

	tmpData=rowObj[0].get("rvsTemplateMainID")+"^"
					       +rowObj[0].get("BonusSubItemID")+"^"
					       +useMinuteField.getValue().trim()+"^"
					       +workRiskField.getValue().trim()+"^"
					       +techDifficultyField.getValue().trim()+"^"
					       +workCostField.getValue().trim()+"^"
					       +makeRateField.getValue().trim()+"^"
					       +execRateField.getValue().trim();
		*/			    

   tmpData=rowObj[0].get("rvsTemplateMainID")+"^"
					       +rowObj[0].get("BonusSubItemID")+"^"
					       +rowObj[0].get("useMinuteValue")+"^"
					       +rowObj[0].get("workRiskValue")+"^"
					       +rowObj[0].get("techDifficultyValue")+"^"
					       +rowObj[0].get("workCostValue")+"^"
					       +rowObj[0].get("makeRate")+"^"
					       +rowObj[0].get("execRate");
 
   Ext.Ajax.request({
			    
						url : DetailUrl + '?action=detailedit&data=' + tmpData,
								
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
								DetailDs.load({
											params : {
												start : 0,
												limit : DetailPagingToolbar.pageSize
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
						},
						scope : this
					});
};




////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
/*
detailEditFun = function(){
		
		var mr=DetailDs.getModifiedRecords();
		var data = ""
		//var rowDelim=xRowDelim();
		for(i=0;i<mr.length;i++){
			var rvsTemplateMainID = mr[i].data["rvsTemplateMainID"];
			var BonusSubItemID = mr[i].data["BonusSubItemID"];
			var useMinuteValue = mr[i].data["useMinuteValue"];
			var workRiskValue = mr[i].data["workRiskValue"];
			var techDifficultyValue = mr[i].data["techDifficultyValue"];
			var workCostValue = mr[i].data["workCostValue"];
			var makeRate = mr[i].data["makeRate"];
			var execRate = mr[i].data["execRate"];
			if((useMinuteValue!="")&&(workRiskValue!="")&&(techDifficultyValue!="")&&(workCostValue!="")&&(makeRate!="")&&(execRate!=""))
			{
				var tmpData = mr[i].data["rowid"]+"^"+rvsTemplateMainID+"^"+BonusSubItemID+"^"+useMinuteValue+"^"+workRiskValue+"^"+techDifficultyValue+"^"+workCostValue+"^"+makeRate+"^"+execRate;
				if(data==""){
					data = tmpData;
				}else{
					data = data + tmpData;
				}
			}
		}
		
		
		
		Ext.Ajax.request({
						url : DetailUrl + '?action=detailedit&data=' + tmpData,
								
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
								DetailDs.load({
											params : {
												start : 0,
												limit : DetailPagingToolbar.pageSize
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
						},
						scope : this
					});
		
	
	
};
*/