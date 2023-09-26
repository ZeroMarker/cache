AddFun = function(dataStore,grid,pagingTool) {
	Ext.QuickTips.init();
 
	if(repdr == "")
	{
		Ext.Msg.show({title:'����',msg:'��ѡ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		return;
	}
	if(leaf == "true")
	{
		Ext.Msg.show({title:'����',msg:'��ѡ�ڵ�Ϊ��Ԫ,���ܽ��д˲���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		return;
	}
	var codeField = new Ext.form.TextField({
		id:'codeField',
		fieldLabel: '����',
		selectOnFocus:true,
		allowBlank: false,
		emptyText:'����...',
		anchor: '90%'
	});
	
	var nameField = new Ext.form.TextField({
		id:'nameField',
		fieldLabel: '����',
		selectOnFocus:true,
		allowBlank: false,
		emptyText:'����...',
		anchor: '90%'
	});
	
	var remarkField = new Ext.form.TextField({
		id:'remarkField',
		fieldLabel: '��ע',
		selectOnFocus:true,
		allowBlank: true,
		emptyText:'��ע...',
		anchor: '90%'
	});
	
	var orderField = new Ext.form.NumberField({
		id:'orderField',
		fieldLabel: '˳��',
		selectOnFocus:true,
		allowBlank: false,
		emptyText:'˳��...',
		anchor: '90%'
	});
	
	var activeFlag = new Ext.form.Checkbox({
		id: 'activeFlag',
		labelSeparator: 'ĩ�˱�־:',
		allowBlank: false
	});
	
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 80,
		items: [
				codeField,
				nameField,
				orderField,
				remarkField,
				activeFlag
			]
	});
    
	var window = new Ext.Window({
		title: '��ӵ�Ԫ�ֲ�',
		width: 400,
		height:250,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			text: '����', 
			id:"saveButton",
			handler: function() {
				// check form value
				if (formPanel.form.isValid()) {
					var code=codeField.getValue().trim();
					var name=nameField.getValue().trim();
					var remark=remarkField.getValue().trim();
					var active=(activeFlag.getValue()==true)?'Y':'N';
					if(code==""){
						Ext.Msg.show({title:'����',msg:'���벻��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					else if(name==""){
						Ext.Msg.show({title:'����',msg:'���Ʋ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
						Ext.Ajax.request({
							url: deptLevelSetsUrl+'?action=add&code='+code+'&name='+name+'&remark='+remark+'&active='+active+'&id='+repdr+'&order='+orderField.getValue(),
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									Ext.getCmp('detailReport').getNodeById(repdr).reload();
									dataStore.load({params:{start:0, limit:pagingTool.pageSize,id:repdr}});
									//window.close();
								}
								else
								{
									var message="";
									if(jsonData.info=='RepCode') message='����Ĵ����Ѿ�����!';
									if(jsonData.info=='RepName') message='����������Ѿ�����!';
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