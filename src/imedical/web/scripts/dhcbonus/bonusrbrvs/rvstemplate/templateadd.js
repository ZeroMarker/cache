templateAddFun = function() {
	
	var checkAdd=function(formPanel){
	var tmpWrongName=''
	for(i=0;i<formPanel.items.length;i++) {
		//alert(i);
		if(!formPanel.items.items[i].isValid()){
			if(tmpWrongName==''){
				tmpWrongName=formPanel.items.items[i].fieldLabel;
			}else{
				//tmpWrongName=tmpWrongName+','+formPanel.items.items[i].fieldLabel;
			}
		}
	}
	return tmpWrongName
}
	
	var codeField = new Ext.form.TextField({
		id: 'codeField',
		name:'code',
		fieldLabel: 'ģ�����',
		allowBlank: false,
		emptyText: '����',		
		anchor: '95%'
	});
	
	var nameField = new Ext.form.TextField({
		id: 'nameField',
		name:'name',
		fieldLabel: 'ģ������',
		allowBlank: false,
		emptyText: '����',
		anchor: '95%'
	});
	
	var minuteRateField = new Ext.form.TextField({
		id: 'minuteRateField',
		name:'minuteRate',
		fieldLabel: '��ʱȨ��',
		allowBlank: false,
		emptyText: '����������',
		anchor: '95%',
		regex:/^(-?\d+)(\.\d+)?$/      
	});
	/*
	var minuteRateField = new Ext.form.NumberField({
		id: 'minuteRateField',
		name:'minuteRate',
		fieldLabel: '��ʱȨ��',
		allowBlank: false,
		emptyText: '����',
		nanText :'��������Ч������',
		anchor: '100%'
	});
	*/
	
	var riskRateField = new Ext.form.TextField({
		id: 'riskRateField',
		name:'riskRate',
		fieldLabel: '����Ȩ��',
		allowBlank: false,
		emptyText: '����������',
		anchor: '95%',
		regex:/^(-?\d+)(\.\d+)?$/

	});
	
	var difficultyRateField = new Ext.form.TextField({
		id: 'difficultyRateField',
		name:'difficultyRate',
		fieldLabel: '�Ѷ�Ȩ��',
		allowBlank: false,
		emptyText: '����������',
		anchor: '95%',
		regex:/^(-?\d+)(\.\d+)?$/     
	});
	
	var costRateField = new Ext.form.TextField({
		id: 'costRateField',
		name:'costRate',
		fieldLabel: '����Ȩ��',
		allowBlank: false,
		emptyText: '����������',
		anchor: '95%',
		regex:/^(-?\d+)(\.\d+)?$/
	});
	
	var tempDescField = new Ext.form.TextField({
		id: 'tempDescField',
		name:'tempDesc',
		fieldLabel: 'ģ��˵��',
		allowBlank: true,
		emptyText: '˵��',
		anchor: '95%'
	});

	
	codeField.setValue('');
	nameField.setValue('');
	minuteRateField.setValue('');
	riskRateField.setValue('');
	difficultyRateField.setValue('');
	costRateField.setValue('');
	tempDescField.setValue('');
	
	//��ʼ�����
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
	
	
	var addWin = new Ext.Window({
		title: '���',
		width: 360,
		height: 310,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons:[{
			text:'����',
			handler: function(){
				if (formPanel.form.isValid()){
					var tmpCreateUser=session['LOGON.USERCODE'];
					var tmpcreateDate=new Date();
					tmpcreateDate=tmpcreateDate.format('Y-m-d');
					//tmpData��Ӧ���е��ֶ�
					tmpData=codeField.getValue().trim()+"^"+nameField.getValue().trim()+"^"+minuteRateField.getValue().trim()+"^"+riskRateField.getValue().trim()+"^"+difficultyRateField.getValue().trim()+"^"+costRateField.getValue().trim()+"^"+tempDescField.getValue().trim()+"^"+tmpCreateUser+"^"+tmpcreateDate;
					//tmpData=codeField.getValue().trim()+"^"+nameField.getValue().trim()+"^"+minuteRateField.getValue()+"^"+riskRateField.getValue().trim()+"^"+difficultyRateField.getValue().trim()+"^"+costRateField.getValue().trim()+"^"+tempDescField.getValue().trim()+"^"+tmpCreateUser+"^"+tmpcreateDate;
					//tmpData=codeField.getValue().trim()+"^"+nameField.getValue().trim()+"^"+minuteRateField.getValue().trim()+"^"+riskRateField.getValue().trim()+"^"+difficultyRateField.getValue().trim()+"^"+costRateField.getValue().trim()+"^"+tempDescField.getValue().trim()+"^"+tmpCreateUser+"^";
					Ext.Ajax.request({
						url: TemplateUrl+'?action=templateadd&data='+tmpData,
						waitMsg:'������...',
						failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'�����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									TemplateDs.load({
										params:{start:0, limit:TemplatePagingToolbar.pageSize},
										callback:function(r,o,s){
											new Ext.grid.RowSelectionModel({singleSelect:true}).selectFirstRow();
										}
									});
								}else{
									var tmpmsg='';
									if(jsonData.info=='1'){
										tmpmsg='�����ظ�!';
									}
									Ext.Msg.show({title:'����',msg:tmpmsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
					}
					else{
						var tmpWrongName=checkAdd(formPanel);
						Ext.Msg.show({title:'����', msg:tmpWrongName+'����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
			}
		},
		{
			text: 'ȡ��',
			handler: function(){addWin.close();}
		}
		]
			
	});

	addWin.show();
	
	};