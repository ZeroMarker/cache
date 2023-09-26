editFun = function(dataStore,grid) {
	
	Ext.QuickTips.init();

	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var rowid = "";
	
	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		rowid = rowObj[0].get("rowid");
	}

	var compCodeField = new Ext.form.TextField({
		id:'compCodeField',
		fieldLabel: '��λ����',
		name:'compCode',
		allowBlank: false,
		anchor: '95%'
	});

	var copyCodeField = new Ext.form.TextField({
		id:'copyCodeField',
		fieldLabel: '���ױ���',
		name:'copyCode',
		allowBlank: false,
		anchor: '95%'
	});
	
	var noteField = new Ext.form.TextField({
		id:'noteField',
		fieldLabel: '˵��',
		name:'note',
		allowBlank: true,
		anchor: '95%'
	});

	var subjTypeCodeField = new Ext.form.TextField({
		id:'subjTypeCodeField',
		fieldLabel: '��Ŀ������',
		name:'subjTypeCode',
		allowBlank: false,
		anchor: '95%'
	});

	var subjTypeNameField = new Ext.form.TextField({
		id:'subjTypeNameField',
		fieldLabel: '��Ŀ�������',
		name:'subjTypeName',
		allowBlank: false,
		anchor: '95%'
	});

	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 80,
		items: [
    		compCodeField,
            copyCodeField,
            noteField,
            subjTypeCodeField,
            subjTypeNameField
		]
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
		});
    
	var window = new Ext.Window({
		title: '�޸�',
		width: 300,
		height:210,
		minWidth: 300,
		minHeight: 210,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			text: '����', 
			handler: function() {
				
				var	compCode = compCodeField.getValue();
				var	copyCode = copyCodeField.getValue();
				var	note = noteField.getValue();
				var	subjTypeCode = subjTypeCodeField.getValue();
				var	subjTypeName = subjTypeNameField.getValue();

				compCode = compCode.trim();
				copyCode = copyCode.trim();
				note = note.trim();
				subjTypeCode =	subjTypeCode.trim();
				subjTypeName = subjTypeName.trim();
				
				if (formPanel.form.isValid()) {
					Ext.Ajax.request({
						url: 'dhc.cs.baseexe.csp?action=editacctsubjtype&rowid='+rowid+'&compCode='+compCode+'&copyCode='+copyCode+'&note='+note+'&subjTypeCode='+subjTypeCode+'&subjTypeName='+subjTypeName,
						waitMsg:'������...',
						failure: function(result, request) {
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								dataStore.load();
								window.close();
							}
							else
							{
								var message="SQLErr: "+jsonData.info;
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