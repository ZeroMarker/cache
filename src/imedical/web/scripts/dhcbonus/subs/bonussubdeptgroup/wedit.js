wEditFun = function() {

	var codeField = new Ext.form.TextField({
		id: 'codeField',
		name:'DeptGroupCode',
		fieldLabel: '���������',
		allowBlank: false,
		emptyText: '����',
		anchor: '100%'
	});
	
	var nameField = new Ext.form.TextField({
		id: 'nameField',
		name:'DeptGroupName',
		fieldLabel: '����������',
		allowBlank: false,
		emptyText: '����',
		anchor: '100%'
	});

	var wTypeSt = new Ext.data.ArrayStore({
		fields: ['rowid', 'name'],                
		data: 	[                                 
					['1',wType[1]],            
					['2',wType[2]],            
					['3',wType[3]]	
				]                                 
	});                                           

	var wTypeCombo = new Ext.form.ComboBox({
		fieldLabel:'���������',
		name:'DeptGroupType',
		store: wTypeSt,
		displayField:'name',
		valueField:'rowid',
		allowBlank: false,
		typeAhead: true,
		mode: 'local',
		forceSelection: true,
		triggerAction: 'all',
		emptyText:'��ѡ',
		selectOnFocus:true,
		anchor: '100%'
	});
	
	var rowObj = wMain.getSelectionModel().getSelections();
	var len = rowObj.length;
	var tmpRowid = "";
	
	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		tmpRowid = rowObj[0].get("BonusSubDeptGroupID");
	}
	
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 70,
		items: [
			codeField,
			nameField,
			wTypeCombo
		]
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(rowObj[0]);
	});

	var editWin = new Ext.Window({
		title: '�޸�',
		width: 300,
		height: 160,
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
				if (formPanel.form.isValid()) {
					tmpData=codeField.getValue().trim()+"^"+nameField.getValue().trim()+"^"+wTypeCombo.getValue();
					Ext.Ajax.request({
						url: wUrl+'?action=wedit&data='+tmpData+'&rowid='+tmpRowid,
						waitMsg:'������...',
						failure: function(result, request) {
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'ע��',msg:'�����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								wDs.load({params:{start:0, limit:wPagingToolbar.pageSize}});
								editWin.close();
							}else{
								var tmpmsg='';
								if(jsonData.info!='0'){
									tmpmsg='�����ظ�!';
								}
								Ext.Msg.show({title:'����',msg:tmpmsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}else{
					Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			}
		},
		{
			text: 'ȡ��',
			handler: function(){editWin.close();}
		}]
	});

	editWin.show();
};