

srmtemplatedownloadAddFun = function() {

	var YearDsAdd = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});


	YearDsAdd.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:projUrl+'?action=Year&str='+encodeURIComponent(Ext.getCmp('YearFieldAdd').getRawValue()),method:'POST'});
	});

	var YearFieldAdd = new Ext.form.ComboBox({
		id: 'YearFieldAdd',
		fieldLabel: '���',
		width:180,
		listWidth : 200,
		allowBlank : false, 
		store:YearDsAdd,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		anchor: '95%',
		//emptyText:'��ѡ��ʼʱ��...',
		name: 'YearFieldAdd',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
	
	var SysNoDrDsAdd = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});


	SysNoDrDsAdd.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:projUrl+'?action=SysNoDr&str='+encodeURIComponent(Ext.getCmp('SysNoDrFieldAdd').getRawValue()),method:'POST'});
	});

	var SysNoDrFieldAdd = new Ext.form.ComboBox({
		id: 'SysNoDrFieldAdd',
		fieldLabel: 'ģ������ģ���',
		width:180,
		listWidth : 250,
		allowBlank : false, 
		store:SysNoDrDsAdd,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		anchor: '95%',
		//emptyText:'��ѡ��ʼʱ��...',
		name: 'SysNoDrFieldAdd',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});	
	var uTypeField = new Ext.form.TextField({
		id: 'uTypeField',
		fieldLabel: 'ģ������',
		width:200,
		allowBlank: false,
		listWidth : 260,
		triggerAction: 'all',
		emptyText:'',
		name: 'uTypeField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	var DescFieldAdd = new Ext.form.TextArea({
		id : 'DescFieldAdd',
		width : 160,
		height : 90,
		anchor: '95%',
		fieldLabel : 'ģ��˵��',
		allowBlank :true,
		selectOnFocus:'true',
		emptyText : '����дģ��˵������'
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
								  
                   YearFieldAdd, 
                   SysNoDrFieldAdd,
				   uTypeField,
                   DescFieldAdd
                                 
								]	 
							}
						]
					}
				]
				
				
							
	var formPanel = new Ext.form.FormPanel({
			//baseCls : 'x-plain',
			labelWidth : 90,
			frame: true,
			items: colItems
			//items : [uCodeField,uNameField,uTypeField,uSexField,uBirthDayField,uIDNumField,uTitleDrField,uPhoneField,uEMailField,uDegreeField,uCompDRField,uMonographNumField,uPaperNumField,uPatentNumField,uInvInCustomStanNumField,uTrainNumField,uHoldTrainNumField,uInTrainingNumField]
		});
	
	var addWin = new Ext.Window({
		    
			title : '���',
			width : 400,
			height : 350,
			layout : 'fit',
			plain : true,
			modal : true,
			bodyStyle : 'padding:5px;',
			buttonAlign : 'center',
			items : formPanel,
			buttons : [{		 
				text : '����',
				handler : function() {
					if (formPanel.form.isValid()) {
					var yearadd     = YearFieldAdd.getValue();
					var sysnodradd  = SysNoDrFieldAdd.getValue();
					var descadd     = DescFieldAdd.getValue();
					var type = uTypeField.getValue();

				Ext.Ajax.request({
					url:'herp.srm.templatedownloadexe.csp?action=add&year='+encodeURIComponent(yearadd)
					+'&sysnodr='+encodeURIComponent(sysnodradd)+'&desc='+encodeURIComponent(descadd)+'&type='+encodeURIComponent(type),
					waitMsg:'������...',
					failure: function(result, request){		
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							itemGridDs.load({params:{start:0, limit:25}});
						}
						else
						{	var message="�ظ����";
							/*
							if(jsonData.info=='RepCode') message="����ظ���";
							if(jsonData.info=='RepName') message="�����ظ���";
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
				text : 'ȡ��',
				handler : function() {
					addWin.close();
				}
			}]
		});
		addWin.show();
	};