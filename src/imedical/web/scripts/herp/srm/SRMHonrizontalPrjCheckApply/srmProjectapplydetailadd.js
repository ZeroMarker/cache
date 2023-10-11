srmProjectapplydetailAddFun = function() {
	
	var rowObj=DetailGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要添加的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{	
		var rowid      	   = rowObj[0].get("rowid");
		var PrjCN          = rowObj[0].get("PrjCN");
		var ResDestination = rowObj[0].get("ResDestination");
		var ResContent     = rowObj[0].get("ResContent");
		var ResCheck       = rowObj[0].get("ResCheck");
	}
	
	var ResDestination = new Ext.form.TextArea({
		id : 'ResDestination',
		width : 500,
		height : 120,
		anchor: '100%',
		fieldLabel : '研究目标',
		allowBlank :true,
		selectOnFocus:'true',
		emptyText : '请填写研究目标……'
	});
	var ResContent = new Ext.form.TextArea({
		id : 'ResContent',
		width : 500,
		height : 120,
		anchor: '100%',
		fieldLabel : '研究内容',
		allowBlank :true,
		selectOnFocus:'true',
		emptyText : '请填写研究内容……'
	});
	var ResCheck = new Ext.form.TextArea({
		id : 'ResCheck',
		width : 500,
		height : 120,
		anchor: '100%',
		fieldLabel : '考核指标',
		allowBlank :true,
		selectOnFocus:'true',
		emptyText : '请填写考核指标……'
	});
	
	
	
	var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '.9',
							bodyStyle:'padding:5px 5px 0',
							border: false
						},            
						items: [
							{
								xtype: 'fieldset',
								autoHeight: true,
								items: [
								{
										xtype : 'displayfield',
										value : '',
										columnWidth : .1
									}, 
                                     ResDestination,  
				                     ResContent,
				                     ResCheck
								]	 
							}]
					}
				]			
	var formPanel = new Ext.form.FormPanel({
			//baseCls : 'x-plain',
			labelWidth : 80,
			frame: true,
			items: colItems
			//items : [uCodeField,uNameField,uTypeField,uSexField,uBirthDayField,uIDNumField,uTitleDrField,uPhoneField,uEMailField,uDegreeField,uCompDRField,uMonographNumField,uPaperNumField,uPatentNumField,uInvInCustomStanNumField,uTrainNumField,uHoldTrainNumField,uInTrainingNumField]
		});

    formPanel.on('afterlayout', function(panel, layout) { 
                                                                                           
			this.getForm().loadRecord(rowObj[0]);
	
			ResDestination.setValue(rowObj[0].get("ResDestination"));
			ResContent.setValue(rowObj[0].get("ResContent"));	
			ResCheck.setValue(rowObj[0].get("ResCheck"));		
			                                                                    
    }); 	
	
	var addWin = new Ext.Window({
			title : '添加',
			width : 650,
			height : 550,
			layout : 'fit',
			plain : true,
			modal : true,
			bodyStyle : 'padding:5px;',
			buttonAlign : 'center',
			items : formPanel,		
			buttons : [{		 
				text : '保存',
				iconCls: 'save',
				handler : function() {
					if (formPanel.form.isValid()) {
					
					var rowObj = DetailGrid.getSelectionModel().getSelections();
					var rowid = rowObj[0].get("rowid");
					var PrjCN = rowObj[0].get("PrjCN");
					var destination = ResDestination.getValue();
					var content = ResContent.getValue();
			   		var check = ResCheck.getValue();

					
			   		
				Ext.Ajax.request({
					url:'herp.srm.srmprojcheckapplydetailexe.csp?action=edit&rowid='+encodeURIComponent(rowid)+'&PrjCN='+encodeURIComponent(PrjCN)
					+'&ResDestination='+encodeURIComponent(destination)
					+'&ResContent='+encodeURIComponent(content)+'&ResCheck='+encodeURIComponent(check),
					waitMsg:'保存中...',
					failure: function(result, request){		
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							DetailGrid.load({params:{start:0, limit:25}});
						}
						else
						{	var message="重复添加";
						/*
						    if(jsonData.info=='RecordExist') message="记录重复";
							if(jsonData.info=='RepCode') message="编号重复！";
							if(jsonData.info=='RepID') message="身份证号码重复！";
							if(jsonData.info=='RepBirthDay') message="生日不能大于当前日期！";
						*/	
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this			
				  });
				  addWin.close();
				} 
				}					
			},
			{
				text : '关闭',
				iconCls : 'cancel',
				handler : function() {
					addWin.close();
				}
			}]
		});
		addWin.show();
	};
