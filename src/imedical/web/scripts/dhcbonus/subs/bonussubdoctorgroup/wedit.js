wEditFun = function() {

	var codeField = new Ext.form.TextField({
		id: 'codeField',
		name:'DoctorGroupCode',
		fieldLabel: '���������',
		allowBlank: false,
		emptyText: '����',
		anchor: '100%'
	});
	
	var nameField = new Ext.form.TextField({
		id: 'nameField',
		name:'DoctorGroupName',
		fieldLabel: '����������',
		allowBlank: false,
		emptyText: '����',
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
		tmpRowid = rowObj[0].get("BonusSubDoctorGroupID");
	}
	
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 70,
		items: [
			codeField,
			nameField
		]
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(rowObj[0]);
	});

	var editWin = new Ext.Window({
		title: '�޸�',
		width: 300,
		height: 130,
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
					tmpData=codeField.getValue().trim()+"^"+nameField.getValue().trim();
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