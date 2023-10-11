srmProjectapplydetailAddFun = function() {
	
	var rowObj=DetailGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��ӵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
		fieldLabel : '�о�Ŀ��',
		allowBlank :true,
		selectOnFocus:'true',
		emptyText : '����д�о�Ŀ�ꡭ��'
	});
	var ResContent = new Ext.form.TextArea({
		id : 'ResContent',
		width : 500,
		height : 120,
		anchor: '100%',
		fieldLabel : '�о�����',
		allowBlank :true,
		selectOnFocus:'true',
		emptyText : '����д�о����ݡ���'
	});
	var ResCheck = new Ext.form.TextArea({
		id : 'ResCheck',
		width : 500,
		height : 120,
		anchor: '100%',
		fieldLabel : '����ָ��',
		allowBlank :true,
		selectOnFocus:'true',
		emptyText : '����д����ָ�ꡭ��'
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
			title : '���',
			width : 650,
			height : 550,
			layout : 'fit',
			plain : true,
			modal : true,
			bodyStyle : 'padding:5px;',
			buttonAlign : 'center',
			items : formPanel,		
			buttons : [{		 
				text : '����',
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
					waitMsg:'������...',
					failure: function(result, request){		
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							DetailGrid.load({params:{start:0, limit:25}});
						}
						else
						{	var message="�ظ����";
						/*
						    if(jsonData.info=='RecordExist') message="��¼�ظ�";
							if(jsonData.info=='RepCode') message="����ظ���";
							if(jsonData.info=='RepID') message="���֤�����ظ���";
							if(jsonData.info=='RepBirthDay') message="���ղ��ܴ��ڵ�ǰ���ڣ�";
						*/	
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this			
				  });
				  addWin.close();
				} 
				}					
			},
			{
				text : '�ر�',
				iconCls : 'cancel',
				handler : function() {
					addWin.close();
				}
			}]
		});
		addWin.show();
	};
