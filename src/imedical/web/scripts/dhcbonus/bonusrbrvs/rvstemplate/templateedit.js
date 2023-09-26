templateEditFun = function(){
	var rowObj = templateMain.getSelectionModel().getSelections();
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
	
	var codeField = new Ext.form.TextField({
		id: 'codeField',
		name:'code',
		fieldLabel: '模板编码',
		allowBlank: false,
		emptyText: '必填',
		anchor: '95%'
	});
	
	var nameField = new Ext.form.TextField({
		id: 'nameField',
		name:'name',
		fieldLabel: '模板名称',
		allowBlank: false,
		emptyText: '必填',
		anchor: '95%'
	});
	
	var minuteRateField = new Ext.form.TextField({
		id: 'minuteRateField',
		name:'minuteRate',
		fieldLabel: '用时权重',
		allowBlank: false,
		emptyText: '请输入数字',
		anchor: '95%',
		regex:/^(-?\d+)(\.\d+)?$/
	});
	
	var riskRateField = new Ext.form.TextField({
		id: 'riskRateField',
		name:'riskRate',
		fieldLabel: '风险权重',
		allowBlank: false,
		emptyText: '请输入数字',
		anchor: '95%',
		regex:/^(-?\d+)(\.\d+)?$/
	});
	
	var difficultyRateField = new Ext.form.TextField({
		id: 'difficultyRateField',
		name:'difficultyRate',
		fieldLabel: '难度权重',
		allowBlank: false,
		emptyText: '请输入数字',
		anchor: '95%',
		regex:/^(-?\d+)(\.\d+)?$/
	});
	
	var costRateField = new Ext.form.TextField({
		id: 'costRateField',
		name:'costRate',
		fieldLabel: '消耗权重',
		allowBlank: false,
		emptyText: '请输入数字',
		anchor: '95%',
		regex:/^(-?\d+)(\.\d+)?$/
	});
	
	var tempDescField = new Ext.form.TextField({
		id: 'tempDescField',
		name:'tempDesc',
		fieldLabel: '模板说明',
		allowBlank: true,
		emptyText: '说明',
		anchor: '95%'
	});
	
	
	//初始化面板
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 70,
		items: [
			codeField,
			nameField,
			minuteRateField,
			riskRateField,
			difficultyRateField,
			costRateField,
			tempDescField
		]
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
				this.getForm().loadRecord(rowObj[0]);
				costRateField.setValue(rowObj[0].get('workCostRate'));
				difficultyRateField.setValue(rowObj[0].get('techDifficultyRate'));
				riskRateField.setValue(rowObj[0].get('workRiskRate'));
				minuteRateField.setValue(rowObj[0].get('useMinuteRate'));
				nameField.setValue(rowObj[0].get('templateName'));
				codeField.setValue(rowObj[0].get('templateCode'));
			});
	
	
	var editWin = new Ext.Window({
		title : '修改',
		width : 360,
		height : 310,
		layout : 'fit',
		plain : true,
		modal : true,
		bodyStyle : 'padding:5px;',
		buttonAlign : 'center',
		items : formPanel,
		buttons:[{
			id : 'saveButton',
			text : '保存',
			handler : function() {
				if (formPanel.form.isValid()){
					var tmpCreateUser=session['LOGON.USERCODE'];
					var tmpcreateDate=new Date();
					tmpcreateDate=tmpcreateDate.format('Y-m-d');
					tmpData=codeField.getValue().trim()+"^"
					       +nameField.getValue().trim()+"^"
					       +minuteRateField.getValue().trim()+"^"
					       +riskRateField.getValue().trim()+"^"
					       +difficultyRateField.getValue().trim()+"^"
					       +costRateField.getValue().trim()+"^"
					       +tempDescField.getValue().trim()+"^"
					       +tmpCreateUser+"^"
					       +tmpcreateDate;
					       
					       
					       Ext.Ajax.request({
						   url : TemplateUrl + '?action=templateedit&data=' + tmpData
								+ '&rowid=' + tmpRowid,
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
								editWin.close();
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
					
					
					}else {
					Ext.Msg.show({
								title : '错误',
								msg : '请修正页面提示的错误!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				     }
				}
			
			},{
			text : '取消',
			handler : function() {
				editWin.close();
			}
		   }
		]
		 
		
	});
	
   editWin.show();
	
};