editFun = function(dataStore,grid,pagingTool,parRef) {

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
		name:'order',
		allowDecimals:false,
		allowBlank: false,
		emptyText: '序号...',
		anchor: '90%'
	});
	var codeField = new Ext.form.TextField({
		id: 'codeField',
		fieldLabel: '代码',
		name:'outPersonCode',
		allowBlank: false,
		emptyText: '接口人员代码...',
		anchor: '90%'
	});
	var nameField = new Ext.form.TextField({
		id: 'nameField',
		fieldLabel: '名称',
		name:'outPersonName',
		allowBlank: false,
		emptyText: '接口人员名称...',
		anchor: '90%'
	});
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '备注',
		name:'remark',
		allowBlank: true,
		emptyText: '接口人员备注...',
		anchor: '90%'
	});
	var formStore = new Ext.data.SimpleStore({//定义组合框中显示的数据源
		fields: ['type','rowid'],
		data : [['住院','I'],['门诊','O'],['体检','E'],['无','']]
	});
	var formComm = new Ext.form.ComboBox({
		id: 'formComm',
		fieldLabel: '病人类型',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: formStore,
		valueField: 'rowid',
		displayField: 'type',
		triggerAction: 'all',
		emptyText:'病人类型...',
		mode: 'local',
		name:'patType',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
		// create form panel
		var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 80,
		items: [	
			orderField,
			codeField,
			nameField,
			//formComm,
			remarkField
		]
	});

		formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
		});

		// define window and show it in desktop
		var window = new Ext.Window({
			title: '修改接口人员',
			width: 370,
			height:300,
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
			      			Ext.Msg.show({title:'错误',msg:'代码为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			      			return;
			      		};
			      		if(name=="")
			      		{
			      			Ext.Msg.show({title:'错误',msg:'名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			      			return;
			      		};
					if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: outDeptsUrl+'?action=editOutDept&inDeptId='+parRef+'&id='+rowId+'&code='+code+'&name='+name+'&remark='+remark+'&inDeptSetsId='+inDeptSetsId+'&order='+orderField.getValue()+'&patType='+formComm.getValue(),
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
										var message="";
										message = "该人员已经在"+jsonData.info+"添加";
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