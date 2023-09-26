EditFun = function(dataStore,grid,pagingTool) {
	Ext.QuickTips.init();
  // pre-define fields in the form
	var rowObj = grid.getSelections();
	var len = rowObj.length;

	var rowid = "";

	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	rowid=rowObj[0].get("id");
	var codeField = new Ext.form.TextField({
		id:'codeField',
		fieldLabel: '����',
		selectOnFocus:true,
		allowBlank: false,
		name:'code',
		emptyText:'����...',
		anchor: '90%'
	});
	
	var nameField = new Ext.form.TextField({
		id:'nameField',
		fieldLabel: '����',
		selectOnFocus:true,
		allowBlank: false,
		name:'name',
		emptyText:'����...',
		anchor: '90%'
	});
	
	var remarkField = new Ext.form.TextField({
		id:'remarkField',
		fieldLabel: '��ע',
		selectOnFocus:true,
		name:'remark',
		allowBlank: true,
		emptyText:'��ע...',
		anchor: '90%'
	});
	
	var orderField = new Ext.form.NumberField({
		id:'orderField',
		fieldLabel: '˳��',
		selectOnFocus:true,
		allowBlank: false,
		name:'order',
		emptyText:'˳��...',
		anchor: '90%'
	});
	
	var endFlag = new Ext.form.Checkbox({
		id: 'endFlag',
		labelSeparator: 'ĩ��:',
		allowBlank: false,
		checked: (rowObj[0].data['end'])=='Y'?true:false
	});
	
	var activeFlag = new Ext.form.Checkbox({
		id: 'activeFlag',
		labelSeparator: '��Ч:',
		allowBlank: false,
		checked: (rowObj[0].data['active'])=='Y'?true:false
	});
	// create form panel
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 80,
		items: [
			codeField,
			nameField,
			orderField,
			remarkField,
			endFlag,
			activeFlag
		]
	});
    formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(rowObj[0]);
	});
  
	var window = new Ext.Window({
		title: '�޸Ĳ��ŷֲ�',
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
			handler: function() {
				// check form value
				if (formPanel.form.isValid()) {
					var code=codeField.getValue().trim();
					var name=nameField.getValue().trim();
					var remark=remarkField.getValue().trim();
					var active=(activeFlag.getValue()==true)?'Y':'N';
					var end=(endFlag.getValue()==true)?'Y':'N';
					if(code==""){
						Ext.Msg.show({title:'����',msg:'���벻��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					else if(name==""){
						Ext.Msg.show({title:'����',msg:'���Ʋ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					  //prompt('',deptLevelSetsUrl+'?action=edit&code='+code+'&name='+name+'&remark='+remark+'&active='+active+'&end='+end+'&id='+rowid+'&order='+orderField.getValue())
							Ext.Ajax.request({
								url: deptLevelSetsUrl+'?action=edit&code='+code+'&name='+name+'&remark='+remark+'&active='+active+'&end='+end+'&id='+rowid+'&order='+orderField.getValue(),
								waitMsg:'������...',
								failure: function(result, request) {
									Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										Ext.getCmp('detailReport').getNodeById(repdr).reload();
										//dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize,id:repdr}});
										window.close();
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