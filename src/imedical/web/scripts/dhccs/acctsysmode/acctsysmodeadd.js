addFun = function(dataStore,grid) {
	Ext.QuickTips.init();

	var codeField = new Ext.form.TextField({
		id:'codeField',
		fieldLabel: 'ģ����',
		allowBlank: false,
		anchor: '95%'
	});

	var nameField = new Ext.form.TextField({
		id:'nameField',
		fieldLabel: 'ģ������',
		allowBlank: false,
		anchor: '95%'
	});
		
	var isAutoVouchField = new Ext.form.Checkbox({
		id:'isAutoVouchField',
		fieldLabel: '�Ƿ��Զ�����ƾ֤',
		allowBlank: false,
		anchor: '95%'
	});

	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 70,
		items: [
    		codeField,
            nameField,
            isAutoVouchField
		]
	});

	var window = new Ext.Window({
		title: '���',
		width: 300,
		height:200,
		minWidth: 300,
		minHeight: 200,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			text: '����', 
			handler: function() {
			
				var	code = codeField.getValue();
				var	name = nameField.getValue();
				var	isAutoVouch = (isAutoVouchField.getValue()==true)?'1':'0';
				
				code = code.trim();
				name = name.trim();
				isAutoVouch = isAutoVouch.trim();
				
				if (formPanel.form.isValid()) {
					Ext.Ajax.request({
						url: 'dhc.cs.baseexe.csp?action=addacctsysmode&code='+code+'&name='+name+'&isAutoVouch='+isAutoVouch,
						waitMsg:'������...',
						failure: function(result, request) {
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								dataStore.load();
							}
							else
							{
								var message="SQLErr: "+jsonData.info;
								Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}else{
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