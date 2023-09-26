addAAccCycleFun = function(dataStore,grid,pagingTool) {

	var codeField = new Ext.form.TextField({
		id: 'codeField',
		fieldLabel: '代码',
		allowBlank: false,
		emptyText: '添加代码...',
		anchor: '90%'
	});

	var nameField = new Ext.form.TextField({
		id: 'nameField',
		fieldLabel: '名称',
		allowBlank: false,
		emptyText: '添加名称...',
		anchor: '90%'
	}); 

	
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '备注',
		allowBlank: true,
		emptyText:'添加备注...',
		anchor: '90%'
	});

	remarkField.on('check', function(o, v){
		if(v==true)	inFlagField.setValue(false);
	});

	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			codeField,
            nameField,
			remarkField
		]
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '添加年度',
    width: 380,
    height:220,
    minWidth: 380,
    minHeight: 220,
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
      		var code = codeField.getValue();
      		var name = nameField.getValue();
			var remark = remarkField.getValue();
		
			
      		code = code.trim();
      		name = name.trim();
			remark = remark.trim();    		
        	var data = code+'^'+name+'^'+remark;
			if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: AAccCycleUrl+'?action=add&data='+data,
							failure: function(result, request) {
								Ext.Msg.show({title:'提示',msg:'错误',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'提示',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
									window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyRecData') message='数据为空!';
									if(jsonData.info=='RepCode') message='代码不能重复!';
									if(jsonData.info=='RepName') message='名称不能重复!';
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