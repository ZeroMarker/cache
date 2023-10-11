srmprojapplydetailEditFun = function() {
	
	var rowObj=DetailGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{	
		var rowid      		= rowObj[0].get("rowid");
		var detailrowid1    = rowObj[0].get("detailrowid1");
		var detailrowid2    = rowObj[0].get("detailrowid2");
		var prjcnedit       = rowObj[0].get("PrjCN");
		var destinationedit = rowObj[0].get("Destination");
		var contentedit     = rowObj[0].get("Content");
		var checkedit       = rowObj[0].get("PrjCheck");
	}
	
	var PrjCNEdit = new Ext.form.TextField({
		id: 'PrjCNEdit',
		fieldLabel: '��Ŀ��ͬ���',
		width:500,
		anchor: '100%',
		allowBlank: false,
		listWidth : 260,
		triggerAction: 'all',
		//emptyText:'',
		name: 'PrjCN',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''

	});
	
	var DestinationEdit = new Ext.form.TextArea({
		id : 'DestinationEdit',
		width : 500,
		height : 120,
		anchor: '100%',
		fieldLabel : '�о�Ŀ��',
		allowBlank :true,
		selectOnFocus:'true',
		labelSeparator:''

		//emptyText : '����д�о�Ŀ�ꡭ��'
	});
		var ContentEdit = new Ext.form.TextArea({
		id : 'ContentEdit',
		width : 500,
		height : 120,
		anchor: '100%',
		fieldLabel : '�о�����',
		allowBlank :true,
		selectOnFocus:'true',
		labelSeparator:''

		//emptyText : '����д�о����ݡ���'
	});
		var CheckEdit = new Ext.form.TextArea({
		id : 'CheckEdit',
		width : 500,
		height : 120,
		anchor: '100%',
		fieldLabel : '����ָ��',
		allowBlank :true,
		selectOnFocus:'true',
		labelSeparator:''

		//emptyText : '����д����ָ�ꡭ��'
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
                                     PrjCNEdit, 
                                     DestinationEdit,  
				                     ContentEdit,
				                     CheckEdit
								]	 
							}]
					}
				]			
	var formPanel = new Ext.form.FormPanel({
			//baseCls : 'x-plain',
			labelWidth : 80,
			labelAlign:'right',
			frame: true,
			items: colItems
			//items : [uCodeField,uNameField,uTypeField,uSexField,uBirthDayField,uIDNumField,uTitleDrField,uPhoneField,uEMailField,uDegreeField,uCompDRField,uMonographNumField,uPaperNumField,uPatentNumField,uInvInCustomStanNumField,uTrainNumField,uHoldTrainNumField,uInTrainingNumField]
		});		
	
    //�����أ���������Ƶ������޸�������Ƿ�������
    formPanel.on('afterlayout', function(panel, layout) { 
                                                                                           
			this.getForm().loadRecord(rowObj[0]);

			PrjCNEdit.setValue(rowObj[0].get("PrjCN"));		
			DestinationEdit.setValue(rowObj[0].get("Destination"));
			ContentEdit.setValue(rowObj[0].get("Content"));	
			CheckEdit.setValue(rowObj[0].get("Check"));		
			                                                                    
    }); 


	var editWin = new Ext.Window({
			title : '�޸���Ŀ�о���Ϣ',
			iconCls: 'pencil',
			width : 650,
			height : 550,
			layout : 'fit',
			plain : true,
			modal : true,
			bodyStyle : 'padding:5px;',
			buttonAlign : 'center',
			items : formPanel,		
			buttons : [{		 
				text : '����',iconCls: 'save',
				handler : function() {
					if (formPanel.form.isValid()) {
					
					var rowObj = DetailGrid.getSelectionModel().getSelections();
					var rowid = rowObj[0].get("rowid");
					
					
						
					var prjcn = PrjCNEdit.getValue();
					var destination = DestinationEdit.getValue();
					var content = ContentEdit.getValue();
			   		var check = CheckEdit.getValue();
			   		
					var prjcnlen=prjcn.length;
					var destinationlen=destination.length;
					var contentlen=content.length;
					var checklen=check.length;
					
					if(prjcnlen>20)
					{
						Ext.Msg.show({title:'����',msg:'��ͬ����������ܳ���20!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					if(destinationlen>60)
					{
						Ext.Msg.show({title:'����',msg:'�о�Ŀ���������ܳ���60!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					if(contentlen>60)
					{
						Ext.Msg.show({title:'����',msg:'�о������������ܳ���60!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					if(checklen>60)
					{
						Ext.Msg.show({title:'����',msg:'����ָ���������ܳ���60!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					
				Ext.Ajax.request({
					url:'herp.srm.srmprojapplydetailexe.csp?action=edit&rowid='+encodeURIComponent(rowid)
					+'&detailrowid1='+encodeURIComponent(detailrowid1)+'&detailrowid2='+encodeURIComponent(detailrowid2)
					+'&PrjCN='+encodeURIComponent(prjcn)+'&Destination='+encodeURIComponent(destination)
					+'&Content='+encodeURIComponent(content)+'&Check='+encodeURIComponent(check),
					waitMsg:'������...',
					failure: function(result, request){		
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							DetailGrid.load({params:{start:0, limit:25}});
							//itemGrid.load({	params:{start:0, limit:25,userdr:userdr}});
						}
						else
						{	var message=jsonData.info;
						
						    if(jsonData.info=='RepCode') message="��Ŀ��ͬ����ظ���";
						/*
							if(jsonData.info=='RepCode') message="����ظ���";
							if(jsonData.info=='RepID') message="���֤�����ظ���";
							if(jsonData.info=='RepBirthDay') message="���ղ��ܴ��ڵ�ǰ���ڣ�";
						*/	
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this			
				  });
				  editWin.close();
				} 
				}					
			},
			{
				text : '�ر�',iconCls : 'cancel',
				handler : function() {
					editWin.close();
				}
			}]
		});
		editWin.show();	
	
	
	
	
	
	
	
	
	};