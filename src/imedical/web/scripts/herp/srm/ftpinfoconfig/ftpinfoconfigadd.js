

srmftpinfoconfigAddFun = function() {

var aTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '�ϴ�����'],['2', '��������'], ['3', '���м�Ч����']]
	});		
		
var aTypeCombox = new Ext.form.ComboBox({
	                   id : 'aTypeCombox',
		           fieldLabel : '��������',
	                   width : 200,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : aTypeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true,
				   labelSeparator:''
						  });	
	var uFtpIPFieldAdd = new Ext.form.TextField({
		id: 'uFtpIPFieldAdd',
		fieldLabel: 'IP',
		width:200,
		allowBlank: false,
		listWidth : 260,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uFtpIPFieldAdd',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var uFtpUserFieldAdd = new Ext.form.TextField({
		id: 'uFtpUserFieldAdd',
		fieldLabel: '�û���',
		width:200,
		allowBlank: true,
		listWidth : 200,
		triggerAction: 'all',
		////emptyText:'',
		name: 'uFtpUserFieldAdd',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});

	var uFtpPassWordFieldAdd = new Ext.form.TextField({
		id: 'uFtpPassWordFieldAdd',
		fieldLabel: '����',
		width:200,
		allowBlank: true,
		inputType: 'password',
		listWidth : 200,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uFtpPassWordFieldAdd',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''

	});
	var uFtpDescFieldAdd = new Ext.form.TextField({
		id: 'uFtpDescFieldAdd',
		fieldLabel: '����',
		width:200,
		allowBlank: true,
		listWidth : 260,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uFtpDescFieldAdd',
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
							columnWidth: '.8',
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
								aTypeCombox,
								uFtpIPFieldAdd,
								uFtpUserFieldAdd,
								uFtpPassWordFieldAdd,
								uFtpDescFieldAdd
								]	 
							}, {
								xtype: 'fieldset',
								autoHeight: true,
								items: [
									{
										xtype : 'displayfield',
										value : '',
										columnWidth : .1
									}
								    
								     
																
								]
							 }]
					}
				]			
	var formPanel = new Ext.form.FormPanel({
			//baseCls : 'x-plain',
			labelWidth : 90,
			labelAlign:'right',
			frame: true,
			items: colItems
			//items : [uCodeField,uNameField,uTypeField,uSexField,uBirthDayField,uIDNumField,uTitleDrField,uPhoneField,uEMailField,uDegreeField,uCompDRField,uMonographNumField,uPaperNumField,uPatentNumField,uInvInCustomStanNumField,uTrainNumField,uHoldTrainNumField,uInTrainingNumField]
		});
	
	var addWin = new Ext.Window({
		    
			title : '����������Ϣ',
			iconCls: 'edit_add',
			width : 430,
			height : 300,
			layout : 'fit',//���ҳ�汳���ĸ߶�
			plain : true,
			modal : true,
			bodyStyle : 'padding:5px;',//���ҳ����ڱ߾�
			buttonAlign : 'center',//���ҳ���ȷ����ť��ȡ����ť��λ��
			items : formPanel,
			buttons : [{		 
				text : '����',
				iconCls: 'save',
				handler : function() {
					if (formPanel.form.isValid()) {
					var type = aTypeCombox.getValue();
					var ipadd = uFtpIPFieldAdd.getValue();
					var useradd = uFtpUserFieldAdd.getValue();
					var passwordadd = uFtpPassWordFieldAdd.getValue();
                    var srcadd = uFtpDescFieldAdd.getValue();

					

				Ext.Ajax.request({
					url:'herp.srm.ftpinfoconfigexe.csp?action=add&type='+encodeURIComponent(type)+'&ftpip='+encodeURIComponent(ipadd)
					+'&ftpuser='+encodeURIComponent(useradd)+'&ftppassword='+encodeURIComponent(passwordadd)+'&ftpdesc='+encodeURIComponent(srcadd),
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
						{	//var message="�ظ����";
							//if(jsonData.info=='RepCode') message="����ظ���";
							//if(jsonData.info=='RepName') message="�����ظ���";
							
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