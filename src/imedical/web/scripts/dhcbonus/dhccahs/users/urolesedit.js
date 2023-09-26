rolesEditFun = function(dataStore,grid,pagingTool,parRef) {

	var rowObj = grid.getSelections();
	var len = rowObj.length;

	var rowId = "";

	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		rowId = rowObj[0].get("rowid");
	}
	var orderField = new Ext.form.NumberField({
		id: 'orderField',
		fieldLabel: '序号',
		allowDecimals:false,
		allowBlank: false,
		name: 'order',
		emptyText: '序号...',
		anchor: '90%'
	});
	var rolesDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
	});
	var roles = new Ext.form.ComboBox({
		id: 'roles',
		fieldLabel: '角色',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: rolesDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		valueNotFoundText: rowObj[0].get("roleName"),
		triggerAction: 'all',
		emptyText:'选择角色...',
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
			title: '修改角色',
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
				text: '保存',
				handler: function() {
					if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: rolesUrl+'?action=roleEdit&id='+rowId+'&userDr='+parRef+'&order='+orderField.getValue()+'&roleDr='+roles.getValue(),
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
									window.close();
								}
								else
									{
										var message = "";
										if(jsonData.info=='EmptyRole') message='输入的角色为空!';
										else if(jsonData.info=='EmptyOrder') message='输入的序号为空!';
										else if(jsonData.info=='RepRole') message='输入的角色已经存在!';
										else if(jsonData.info=='RepOrder') message='输入的序号已经存在!';
										else message = jsonData.info;
										Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									}
								},
								scope: this
							});
						}
						else{
							Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					}
				},
				{
					text: '取消',
					handler: function(){window.close();}
				}]
			});

			window.show();
		};