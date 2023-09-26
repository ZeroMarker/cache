AddFun = function(dataStore,grid,pagingTool) {
	Ext.QuickTips.init();
 
	if(repdr == "")
	{
		Ext.Msg.show({title:'错误',msg:'请选择分类!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		return;
	}
	if(leaf == "true")
	{
		Ext.Msg.show({title:'错误',msg:'所选节点为单元,不能进行此操作!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		return;
	}
	var codeField = new Ext.form.TextField({
		id:'codeField',
		fieldLabel: '代码',
		selectOnFocus:true,
		allowBlank: false,
		emptyText:'代码...',
		anchor: '90%'
	});
	
	var nameField = new Ext.form.TextField({
		id:'nameField',
		fieldLabel: '名称',
		selectOnFocus:true,
		allowBlank: false,
		emptyText:'名称...',
		anchor: '90%'
	});
	
	var remarkField = new Ext.form.TextField({
		id:'remarkField',
		fieldLabel: '备注',
		selectOnFocus:true,
		allowBlank: true,
		emptyText:'备注...',
		anchor: '90%'
	});
	
	var orderField = new Ext.form.NumberField({
		id:'orderField',
		fieldLabel: '顺序',
		selectOnFocus:true,
		allowBlank: false,
		emptyText:'顺序...',
		anchor: '90%'
	});
	
	var activeFlag = new Ext.form.Checkbox({
		id: 'activeFlag',
		labelSeparator: '末端标志:',
		allowBlank: false
	});
	
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 80,
		items: [
				codeField,
				nameField,
				orderField,
				remarkField,
				activeFlag
			]
	});
    
	var window = new Ext.Window({
		title: '添加单元分层',
		width: 400,
		height:250,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			text: '保存', 
			id:"saveButton",
			handler: function() {
				// check form value
				if (formPanel.form.isValid()) {
					var code=codeField.getValue().trim();
					var name=nameField.getValue().trim();
					var remark=remarkField.getValue().trim();
					var active=(activeFlag.getValue()==true)?'Y':'N';
					if(code==""){
						Ext.Msg.show({title:'错误',msg:'代码不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					else if(name==""){
						Ext.Msg.show({title:'错误',msg:'名称不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
						Ext.Ajax.request({
							url: deptLevelSetsUrl+'?action=add&code='+code+'&name='+name+'&remark='+remark+'&active='+active+'&id='+repdr+'&order='+orderField.getValue(),
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									Ext.getCmp('detailReport').getNodeById(repdr).reload();
									dataStore.load({params:{start:0, limit:pagingTool.pageSize,id:repdr}});
									//window.close();
								}
								else
								{
									var message="";
									if(jsonData.info=='RepCode') message='输入的代码已经存在!';
									if(jsonData.info=='RepName') message='输入的名称已经存在!';
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