EditFun = function(dataStore,grid,pagingTool) {
	Ext.QuickTips.init();
  // pre-define fields in the form
	var rowObj = grid.getSelections();
	var len = rowObj.length;

	var rowid = "";

	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	rowid=rowObj[0].get("id");
	var codeField = new Ext.form.TextField({
		id:'codeField',
		fieldLabel: '代码',
		selectOnFocus:true,
		allowBlank: false,
		name:'code',
		emptyText:'代码...',
		anchor: '90%'
	});
	
	var nameField = new Ext.form.TextField({
		id:'nameField',
		fieldLabel: '名称',
		selectOnFocus:true,
		allowBlank: false,
		name:'name',
		emptyText:'名称...',
		anchor: '90%'
	});
	
	var remarkField = new Ext.form.TextField({
		id:'remarkField',
		fieldLabel: '备注',
		selectOnFocus:true,
		name:'remark',
		allowBlank: true,
		emptyText:'备注...',
		anchor: '90%'
	});
	
	var orderField = new Ext.form.NumberField({
		id:'orderField',
		fieldLabel: '顺序',
		selectOnFocus:true,
		allowBlank: false,
		name:'order',
		emptyText:'顺序...',
		anchor: '90%'
	});
	
	var endFlag = new Ext.form.Checkbox({
		id: 'endFlag',
		labelSeparator: '末端:',
		allowBlank: false,
		checked: (rowObj[0].data['end'])=='Y'?true:false
	});
	
	var activeFlag = new Ext.form.Checkbox({
		id: 'activeFlag',
		labelSeparator: '有效:',
		allowBlank: false,
		checked: (rowObj[0].data['active'])=='Y'?true:false
	});
	// create form panel
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 80,
		items: [
			codeField,
			nameField,
			orderField,
			remarkField,
			endFlag,
			activeFlag
		]
	});
    formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(rowObj[0]);
	});
  
	var window = new Ext.Window({
		title: '修改部门分层',
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
			handler: function() {
				// check form value
				if (formPanel.form.isValid()) {
					var code=codeField.getValue().trim();
					var name=nameField.getValue().trim();
					var remark=remarkField.getValue().trim();
					var active=(activeFlag.getValue()==true)?'Y':'N';
					var end=(endFlag.getValue()==true)?'Y':'N';
					if(code==""){
						Ext.Msg.show({title:'错误',msg:'代码不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					else if(name==""){
						Ext.Msg.show({title:'错误',msg:'名称不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					  //prompt('',deptLevelSetsUrl+'?action=edit&code='+code+'&name='+name+'&remark='+remark+'&active='+active+'&end='+end+'&id='+rowid+'&order='+orderField.getValue())
							Ext.Ajax.request({
								url: deptLevelSetsUrl+'?action=edit&code='+code+'&name='+name+'&remark='+remark+'&active='+active+'&end='+end+'&id='+rowid+'&order='+orderField.getValue(),
								waitMsg:'保存中...',
								failure: function(result, request) {
									Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										Ext.getCmp('detailReport').getNodeById(repdr).reload();
										//dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize,id:repdr}});
										window.close();
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