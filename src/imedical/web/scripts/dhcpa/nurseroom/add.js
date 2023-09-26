addFun = function() {

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


  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			codeField,
            nameField
		
		]
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '添加病区',
    width: 400,
    height:250,
    minWidth: 400,
    minHeight: 250,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
    	text: '保存',
		handler: function() {
      		
      		var code = codeField.getValue();
      		var name = nameField.getValue();

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
							url: '../csp/dhc.pa.nurseroomexe.csp?action=add&code='+code+'&name='+name,
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load();
									window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									
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