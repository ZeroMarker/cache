

srmyearnewAddFun = function() {
	
	var uCodeFieldAdd = new Ext.form.TextField({
		id: 'uCodeFieldAdd',
		fieldLabel: '��ȱ���',
		width:200,
		//allowBlank: false,
		listWidth : 260,
		//regex:/[0-9]/,
		//regexText:"��ȱ���ֻ��Ϊ����",
		triggerAction: 'all',
		emptyText:'',
		name: 'uCodeFieldAdd',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var uNameFieldAdd = new Ext.form.TextField({
		id: 'uNameFieldAdd',
		fieldLabel: '�������',
		width:200,
		//allowBlank: true,
		listWidth : 200,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uNameFieldAdd',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});

	var uStrDateFieldAdd = new Ext.form.DateField({
		id: 'uStrDateFieldAdd',
		fieldLabel: '��ʼ����',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'uStrDateFieldAdd',
		//format:"Y-m-d",
		//value:"Y-m-d",
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	
	var uEndDateFieldAdd = new Ext.form.DateField({
		id: 'uEndDateFieldADD',
		fieldLabel: '��������',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'uEndDateFieldADD',
		//format:"Y-m-d",
		//value:"Y-m-d",
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	
	
	var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '1',
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
								uCodeFieldAdd,
								uNameFieldAdd,
                                uStrDateFieldAdd,
								uEndDateFieldAdd 
								]	 
							}]
					}
				]			
	var formPanel = new Ext.form.FormPanel({
			//baseCls : 'x-plain',
			labelWidth : 100,   //����panel��fieldLabel���
			frame: true,
			items: colItems
			//items : [uCodeField,uNameField,uTypeField,uSexField,uBirthDayField,uIDNumField,uTitleDrField,uPhoneField,uEMailField,uDegreeField,uCompDRField,uMonographNumField,uPaperNumField,uPatentNumField,uInvInCustomStanNumField,uTrainNumField,uHoldTrainNumField,uInTrainingNumField]
		});
	
	var addWin = new Ext.Window({
		    
			title : '���������Ϣ',
			iconCls: 'edit_add',
			width : 380,
			height : 230,
			layout : 'fit',//���ҳ�汳���ĸ߶�
			plain : true,
			modal : true,
			bodyStyle : 'padding:5px;',//���ҳ����ڱ߾�
			buttonAlign : 'center',//���ҳ���ȷ����ť��ȡ����ť��λ��
			items : formPanel,
			buttons : [{		 
				text : '����',
				iconCls : 'save',
				handler : function() {
					if (formPanel.form.isValid()) {
					var codeadd = uCodeFieldAdd.getValue();
					var nameadd = uNameFieldAdd.getValue();
					var strdataadd = uStrDateFieldAdd.getRawValue();
                    var enddataadd = uEndDateFieldAdd.getRawValue();

				    if (strdataadd!=="")
				    {
					 //strdataadd=strdataadd.format ('Y-m-d');
				    }

				    if (enddataadd!=="")
				    {
					 //enddataadd=enddataadd.format ('Y-m-d');
				    }
					if(codeadd=="")
					{
						Ext.Msg.show({title:'����',msg:'��ȱ��벻��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					};
					
					if(codeadd!=""){
					   if (!/[0-9]/.test(codeadd)){Ext.Msg.show({title:'����',msg:'��ȱ���ֻ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
					};
					
					if(codeadd!=""){
					   if (!/^\d{0,4}$/.test(codeadd)){Ext.Msg.show({title:'����',msg:'��ȱ���ֻ������λ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
					};
				
					if(nameadd=="")
					{
						Ext.Msg.show({title:'����',msg:'������Ʋ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					};
					
				Ext.Ajax.request({
					url:'herp.srm.yearexe.csp?action=add&Code='+encodeURIComponent(codeadd)
					+'&Name='+encodeURIComponent(nameadd)+'&StrDate='+encodeURIComponent(strdataadd)+'&EndDate='+encodeURIComponent(enddataadd),
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
							if(jsonData.info=='RepCode') message="��ȱ���ظ���";
							if(jsonData.info=='RepName') message="��������ظ���";
							if(jsonData.info=='RepDate') message="����Ŀ�ʼʱ�䲻�ܴ��ڽ���ʱ�䣡";
							
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