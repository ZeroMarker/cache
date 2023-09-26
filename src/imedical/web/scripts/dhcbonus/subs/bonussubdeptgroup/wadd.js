wAddFun = function() {

	var codeField = new Ext.form.TextField({
		name:'code',
		fieldLabel: '���������',
		allowBlank: false,
		emptyText: '����',
		anchor: '100%'
	});
	
	var nameField = new Ext.form.TextField({
		name:'name',
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
		name:'type',
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

	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 70,
		items: [
			codeField,
			nameField,
			wTypeCombo
		]
	});
	
	var addWin = new Ext.Window({
		title: '����',
		width: 300,
		height: 160,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons:[{
			text: '����',
			handler: function() {
				if (formPanel.form.isValid()) {
					tmpData=codeField.getValue().trim()+"^"+nameField.getValue().trim()+"^"+wTypeCombo.getValue();
					Ext.Ajax.request({
						url: wUrl+'?action=wadd&data='+tmpData,
						waitMsg:'������...',
						failure: function(result, request) {
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'ע��',msg:'�����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								wDs.load({
									params:{start:0, limit:wPagingToolbar.pageSize},
									callback:function(r,o,s){
										wSM.selectFirstRow();
										cDs.load({params:{start:0, limit:0}});
									}
								});
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
			handler: function(){addWin.close();}
		}]
	});
	
	addWin.show();
};