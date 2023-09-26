addFun = function(dataStore,grid,pagingTool,parRef) {
	if(parRef=="")
	{
		Ext.Msg.show({title:'注意',msg:'请选择接口部门套后再添加!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return;
	}
	var orderField = new Ext.form.NumberField({
		id: 'orderField',
		fieldLabel: '顺序',
		allowDecimals:false,
		allowBlank: false,
		emptyText: '顺序...',
		anchor: '90%'
	});
	var codeField = new Ext.form.TextField({
		id: 'codeField',
		fieldLabel: '部门代码',
		allowBlank: false,
		emptyText: '接口部门代码...',
		anchor: '90%'
	});
	var nameField = new Ext.form.TextField({
		id: 'nameField',
		fieldLabel: '部门名称',
		allowBlank: false,
		emptyText: '接口部门名称...',
		anchor: '90%'
	});
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '备注',
		allowBlank: true,
		emptyText: '接口部门备注...',
		anchor: '90%'
	});

	var formStore = new Ext.data.SimpleStore({//定义组合框中显示的数据源
		fields: ['type','rowid'],
		data : [['住院','I'],['门诊','O'],['体检','H'],['无','']]
	});
	var formComm = new Ext.form.ComboBox({
		id: 'formComm',
		fieldLabel: '病人类型',
		anchor: '90%',
		listWidth : 260,
		allowBlank: true,
		store: formStore,
		valueField: 'rowid',
		displayField: 'type',
		triggerAction: 'all',
		emptyText:'病人类型...',
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
		title: '添加接口部门',
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
			text: '保存',
			handler: function() {
				var code = codeField.getValue();
		      		var name = nameField.getValue();
		      		var remark = remarkField.getValue();
		      		code = code.trim();
		      		name = name.trim();
					remark=remark.trim();
		      		if(code=="")
		      		{
		      			Ext.Msg.show({title:'错误',msg:'部门代码为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		      			return;
		      		};
		      		if(name=="")
		      		{
		      			Ext.Msg.show({title:'错误',msg:'部门名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		      			return;
		      		};
		      		
				if (formPanel.form.isValid()) {
					Ext.Ajax.request({
						url: encodeURI(outDeptsUrl+'?action=addOutDept&inDeptId='+parRef+'&code='+code+'&name='+name+'&remark='+remark+'&inDeptSetsId='+inDeptSetsId+'&order='+orderField.getValue()+'&patType='+formComm.getValue()),
						waitMsg:'保存中...',
						failure: function(result, request) {
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
							}
							else
								{
									var message = "";
									if(jsonData.info == 'RepCode')
									{
										message = '输入的部门代码已经存在!';
									}
									else if(jsonData.info == 'RepName')
										{
											message = '输入的部门名称已经存在!';
										}
										else message = "该科室已经在"+jsonData.info+"添加";
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
			