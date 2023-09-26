addFun = function(dataStore,grid,pagingTool,parRef) {
	if(parRef=="")
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ��ӿڲ����׺������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return;
	}
	var orderField = new Ext.form.NumberField({
		id: 'orderField',
		fieldLabel: '˳��',
		allowDecimals:false,
		allowBlank: false,
		emptyText: '˳��...',
		anchor: '90%'
	});
	var codeField = new Ext.form.TextField({
		id: 'codeField',
		fieldLabel: '���Ŵ���',
		allowBlank: false,
		emptyText: '�ӿڲ��Ŵ���...',
		anchor: '90%'
	});
	var nameField = new Ext.form.TextField({
		id: 'nameField',
		fieldLabel: '��������',
		allowBlank: false,
		emptyText: '�ӿڲ�������...',
		anchor: '90%'
	});
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '��ע',
		allowBlank: true,
		emptyText: '�ӿڲ��ű�ע...',
		anchor: '90%'
	});

	var formStore = new Ext.data.SimpleStore({//������Ͽ�����ʾ������Դ
		fields: ['type','rowid'],
		data : [['סԺ','I'],['����','O'],['���','H'],['��','']]
	});
	var formComm = new Ext.form.ComboBox({
		id: 'formComm',
		fieldLabel: '��������',
		anchor: '90%',
		listWidth : 260,
		allowBlank: true,
		store: formStore,
		valueField: 'rowid',
		displayField: 'type',
		triggerAction: 'all',
		emptyText:'��������...',
		mode: 'local',
		name:'Flag',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	
	// create form panel
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 75,
		items: [
			orderField,
			codeField,
			nameField,
			formComm,
			remarkField
		]
	});

	// define window and show it in desktop
	var window = new Ext.Window({
		title: '��ӽӿڲ���',
		width: 350,
		height: 300,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			id:'saveButton',
			text: '����',
			handler: function() {
				var code = codeField.getValue();
		      		var name = nameField.getValue();
		      		var remark = remarkField.getValue();
		      		code = code.trim();
		      		name = name.trim();
					remark=remark.trim();
		      		if(code=="")
		      		{
		      			Ext.Msg.show({title:'����',msg:'���Ŵ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		      			return;
		      		};
		      		if(name=="")
		      		{
		      			Ext.Msg.show({title:'����',msg:'��������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		      			return;
		      		};
		      		
				if (formPanel.form.isValid()) {
					Ext.Ajax.request({
						url: encodeURI(outDeptsUrl+'?action=addOutDept&inDeptId='+parRef+'&code='+code+'&name='+name+'&remark='+remark+'&inDeptSetsId='+inDeptSetsId+'&order='+orderField.getValue()+'&patType='+formComm.getValue()),
						waitMsg:'������...',
						failure: function(result, request) {
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
							}
							else
								{
									var message = "";
									if(jsonData.info == 'RepCode')
									{
										message = '����Ĳ��Ŵ����Ѿ�����!';
									}
									else if(jsonData.info == 'RepName')
										{
											message = '����Ĳ��������Ѿ�����!';
										}
										else message = "�ÿ����Ѿ���"+jsonData.info+"���";
											Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
										}
									},
									scope: this
								});
							}
							else{
								Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ�����ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						}
					},
					{
						text: 'ȡ��',
						handler: function(){window.close();}
					}]
				});
				window.show();
			};
			