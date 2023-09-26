addFun = function(dataStore,grid,pagingTool) {

		var orderField = new Ext.form.TextField({
		id:'orderField',
    fieldLabel: '顺序',
    allowBlank: false,
    emptyText:'接口项目套顺序...',
    anchor: '95%'
	});
	
	var codeField = new Ext.form.TextField({
		id:'codeField',
    fieldLabel: '代码',
    allowBlank: false,
    emptyText:'接口项目套代码...',
    anchor: '95%'
	});

	var nameField = new Ext.form.TextField({
		id:'nameField',
    fieldLabel: '名称',
    allowBlank: false,
    emptyText:'接口项目套名称...',
    anchor: '95%'
	});
	
		var remarkField = new Ext.form.TextField({
		id:'remarkField',
    fieldLabel: '备注',
    allowBlank: true,
    emptyText:'接口项目套备注...',
    anchor: '95%'
	});
	
	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 40,
    items: [
    				orderField,
    				codeField,
            nameField,
            remarkField
		]
	});
    
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '添加接口项目套信息',
    width: 400,
    height:300,
    minWidth: 400,
    minHeight: 300,
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
      		var order = orderField.getValue();
      		var code = codeField.getValue();
      		var name = nameField.getValue();
      		var remark = remarkField.getValue();
      		order = order.trim();
      		code = code.trim();
      		name = name.trim();
      		remark = remark.trim();
      		
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
							url: initemsetsUrl+'?action=add&order='+order+'&code='+code+'&name='+name+'&remark='+remark,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
									//window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='RepOrder') message='输入的顺序已经存在!';
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