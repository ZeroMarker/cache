

SystemInfoAddFun = function() {


	var uTextField = new Ext.form.TextField({
		id: 'uTextField',
		fieldLabel: '��Ŀ',
		width:200,
		allowBlank: false,
		listWidth : 260,
		triggerAction: 'all',
		emptyText:'',
		name: 'uTextField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	var uMessageField = new Ext.form.TextArea({
		id: 'uMessageField',
		fieldLabel: '����',
		width:200,
		allowBlank: false,
		//listWidth : 260,
		triggerAction: 'all',
		name: 'uMessageField',
		grow: true,
        growMin:60,//��ʾ�ĸ߶�
        growMax:100//������ʾ�߶�
	});
	
/////////////////////�Ƿ��и���/////////////////////////////
    var aIsAttachmentField = new Ext.form.Checkbox({
                        id:'aIsAttachmentField',
						name:'aIsAttachmentField',
						fieldLabel : '�Ƿ��и���'
    });
	/**
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
								  // RecordTypeField,
                                  uTextField, 
                                  uMessageField,  
                                  aIsAttachmentField
								]	 
							}]
					}
				]			
	**/
	var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 50,
			frame: true,
			//items: colItems
			items : [uTextField,uMessageField,aIsAttachmentField]
		});
	
	var addWin = new Ext.Window({
		    
			title : '���ϵͳ��Ϣ',
			width : 300,
			height : 200,
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
					var systeminfotitle = uTextField.getValue();
					var systeminfomessage = uMessageField.getValue();
					var subuser = session['LOGON.USERID'];
					
					var IsValid = "";
			        if (Ext.getCmp('aIsAttachmentField').checked) {IsValid="1";}
			        else { IsValid="0";}
				//rowid, year, sysnodr, title, message, subuser, subdate, IsRead, IsAttachment
				Ext.Ajax.request({
					url:HomePageUrl+'?action=add&title='+encodeURIComponent(systeminfotitle)
					+'&message='+encodeURIComponent(systeminfomessage)+'&subuser='+subuser+'&IsAttachment='+encodeURIComponent(IsValid),
					waitMsg:'������...',
					failure: function(result, request){		
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							SystemMessageDs.load({params:{start:0, limit:25}});
						}
						else
						{	var message="�ظ����aaa";
						    if(jsonData.info=='RecordExist') message="��¼�ظ�";
							if(jsonData.info=='RepCode') message="����ظ���";
							if(jsonData.info=='RepID') message="���֤�����ظ���";
							
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
