addFun = function(dataStore,grid,pagingTool) {
	Ext.QuickTips.init();

	var orderField = new Ext.form.NumberField({
		id:'orderField',
    fieldLabel: '权限顺序',
    allowBlank: false,
    emptyText:'权限顺序...',
    anchor: '95%'
	});
	
	var nameField = new Ext.form.TextField({
		id:'nameField',
    fieldLabel: '权限名称',
    allowBlank: false,
    emptyText:'权限名称...',
    anchor: '95%'
	});

	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 60,
    items: [
    	orderField,
      nameField
		]
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '添加权限',
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
      	var order = orderField.getValue();
      	var name = nameField.getValue();
				order = order.trim();
				name = name.trim();
				
        if (formPanel.form.isValid()) {
					Ext.Ajax.request({
						url: mainUrl+'?action=add&parRef='+roleSelecter.getValue()+'&name='+name+'&order='+order,
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
								var message="SQLErr: "+jsonData.info;
								if(jsonData.info=='RepOrder') message='输入的顺序已经存在!';
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