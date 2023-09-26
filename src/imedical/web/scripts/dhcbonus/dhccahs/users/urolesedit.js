rolesEditFun = function(dataStore,grid,pagingTool,parRef) {

	var rowObj = grid.getSelections();
	var len = rowObj.length;

	var rowId = "";

	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		rowId = rowObj[0].get("rowid");
	}
	var orderField = new Ext.form.NumberField({
		id: 'orderField',
		fieldLabel: '���',
		allowDecimals:false,
		allowBlank: false,
		name: 'order',
		emptyText: '���...',
		anchor: '90%'
	});
	var rolesDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
	});
	var roles = new Ext.form.ComboBox({
		id: 'roles',
		fieldLabel: '��ɫ',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: rolesDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		valueNotFoundText: rowObj[0].get("roleName"),
		triggerAction: 'all',
		emptyText:'ѡ���ɫ...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	rolesDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.usersexe.csp?action=roleList&searchValue='+Ext.getCmp('roles').getRawValue(),method:'GET'});
	});
		// create form panel
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 80,
		//layout: 'anchor',
		items: [
			orderField,
			roles
		]
	});

		formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			roles.setValue(rowObj[0].get("roleDr"));
		});

		// define window and show it in desktop
		var window = new Ext.Window({
			title: '�޸Ľ�ɫ',
			width: 370,
			height:200,
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
						Ext.Ajax.request({
							url: rolesUrl+'?action=roleEdit&id='+rowId+'&userDr='+parRef+'&order='+orderField.getValue()+'&roleDr='+roles.getValue(),
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
									window.close();
								}
								else
									{
										var message = "";
										if(jsonData.info=='EmptyRole') message='����Ľ�ɫΪ��!';
										else if(jsonData.info=='EmptyOrder') message='��������Ϊ��!';
										else if(jsonData.info=='RepRole') message='����Ľ�ɫ�Ѿ�����!';
										else if(jsonData.info=='RepOrder') message='���������Ѿ�����!';
										else message = jsonData.info;
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