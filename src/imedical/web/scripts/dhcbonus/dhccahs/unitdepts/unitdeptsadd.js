addFun = function(dataStore,grid,pagingTool,unitDr) {
	Ext.QuickTips.init();
  // pre-define fields in the form

	var codeField = new Ext.form.TextField({
		id:'codeField',
    fieldLabel: '代码',
    allowBlank: false,
    emptyText:'单位部门代码...',
    anchor: '95%'
	});

	var nameField = new Ext.form.TextField({
		id:'nameField',
    fieldLabel: '名称',
    allowBlank: false,
    emptyText:'单位部门名称...',
    anchor: '95%'
	});
	
	var addressField = new Ext.form.TextField({
		id:'addressField',
    fieldLabel: '地址',
    allowBlank: true,
    emptyText:'单位部门地址...',
    anchor: '95%'
	});

	var remarkField = new Ext.form.TextField({
		id:'remarkField',
    fieldLabel: '备注',
    allowBlank: true,
    emptyText:'单位部门备注...',
    anchor: '95%'
	});
	
		var startField = new Ext.form.DateField({
		id: 'startField',
		fieldLabel: '启用时间',
		allowBlank: true,
		dateFormat: 'Y-m-d',
		anchor: '95%'
	});

	var stopField = new Ext.form.DateField({
		id: 'stopField',
		fieldLabel: '停用时间',
		allowBlank: true,
		dateFormat: 'Y-m-d',
		anchor: '95%'
	});
	
	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 60,
    items: [
    				codeField,
            nameField,
            addressField,
            remarkField,
            startField,
            stopField
		]
	});
    
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '添加单位部门',
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
      		var code = codeField.getValue();
      		var name = nameField.getValue();
      		var address = addressField.getValue();
          var remark  = remarkField.getValue();
      		var startTime = (startField.getValue()=='')?'':startField.getValue().format('Y-m-d');
      		var stop = (stopField.getValue()=='')?'':stopField.getValue().format('Y-m-d');
      	
      		code = code.trim();
      		name = name.trim();
      		address = address.trim();
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
							url: unitDeptsUrl+'?action=add&unitDr='+unitDr+'&code='+code+'&name='+name+'&address='+address+'&remark='+remark+'&startTime='+startTime+'&stop='+stop,
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