editLocsFun = function(dataStore,grid,pagingTool) {
	Ext.QuickTips.init();
  // pre-define fields in the form
	var selectedRow = grid.getSelections();
	if (selectedRow.length < 1){
		Ext.MessageBox.show({title: '提示',msg: '请选择一条数据！',buttons: Ext.MessageBox.OK,icon: Ext.MessageBox.INFO});
		return;
	}
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '备注',
		allowBlank: false,
		name:'remark',
		emptyText: '备注...',
		anchor: '90%'
	});
	
	var priorityField = new Ext.form.NumberField({
		id: 'priorityField',
		fieldLabel: '优先级',
		allowDecimals:false,
		name:'priority',
		allowBlank: false,
		emptyText: '优先级...',
		anchor: '90%'
	});
	
	var codeField = new Ext.form.TextField({
		id: 'codeField',
		fieldLabel: '代码',
		allowBlank: false,
		name:'code',
		emptyText: '类别代码...',
		anchor: '90%'
	});

	var nameField = new Ext.form.TextField({
		id: 'nameField',
		fieldLabel: '名称',
		name:'name',
		allowBlank: false,
		emptyText: '类别名称...',
		anchor: '90%'
	});
	var activeField = new Ext.form.Checkbox({
		id: 'activeField',
		labelSeparator: '有效:',
    	allowBlank: false,
    	//name:'active',
		checked: (selectedRow[0].data['active'])=='Y'?true:false
	});
	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			priorityField,
			codeField,
			nameField,
			remarkField,
			activeField
		]
	});
	formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(selectedRow[0]);
	});
    
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '修改收入数据梳理',
    width: 400,
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
		id:'saveButton',
    	text: '保存', 
      handler: function() {
			var code = codeField.getValue();
      		var name = nameField.getValue();
			var priority=priorityField.getValue();
			var remark=remarkField.getValue();
			var active = (activeField.getValue()==true)?'Y':'N';
      		code = code.trim();
      		name = name.trim();
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
							url: busdingUrl+'?action=editCarding&code='+code+'&name='+name+'&priority='+priority+'&remark='+remark+'&id='+selectedRow[0].get("rowid")+'&active='+active,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
									inDataCardRuleDs.load({params:{start:0, limit:0}});
									window.close();
								}
								else
								{
									var message="";
									if(jsonData.info=='EmptyCode') message='输入的代码为空!';
									if(jsonData.info=='EmptyName') message='输入的名称为空!';
									if(jsonData.info=='RepCode') message='输入的代码已经存在!';
									if(jsonData.info=='RepName') message='输入的名称已经存在!';
									if(jsonData.info=='RepPriority') message='输入的优先级已经存在!';
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