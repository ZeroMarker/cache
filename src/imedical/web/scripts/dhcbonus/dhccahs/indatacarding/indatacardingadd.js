addLocsFun = function(dataStore,grid,pagingTool) {
	Ext.QuickTips.init();

	var priorityField = new Ext.form.NumberField({
		id: 'priorityField',
		fieldLabel: '优先级',
		allowDecimals:false,
		allowBlank: false,
		emptyText: '优先级...',
		anchor: '90%'
	});
	
	var codeField = new Ext.form.TextField({
		id: 'codeField',
		fieldLabel: '代码',
		allowBlank: false,
		emptyText: '代码...',
		anchor: '90%'
	});

	var nameField = new Ext.form.TextField({
		id: 'nameField',
		fieldLabel: '名称',
		allowBlank: false,
		emptyText: '名称...',
		anchor: '90%'
	});
	
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '备注',
		allowBlank: false,
		emptyText: '备注...',
		anchor: '90%'
	});
	
	
	
	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			priorityField,
			codeField,
			nameField,
			remarkField
		]
	});
    
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '添加收入数据梳理',
    width: 350,
    height:250,
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
			var priority = priorityField.getValue();
			var remark=remarkField.getValue();
      		code = code.trim();
      		name = name.trim();
      		//priority = priority.trim();
      		if(priority=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'优先级为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
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
							url: busdingUrl+'?action=addCarding&code='+code+'&name='+name+'&priority='+priority+'&remark='+remark,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								//alert("1")
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
									inDataCardRuleDs.load({params:{start:0, limit:0}});
									//window.close();
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
						Ext.Msg.show({title:'错误', msg:'请将必填项填写完整后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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