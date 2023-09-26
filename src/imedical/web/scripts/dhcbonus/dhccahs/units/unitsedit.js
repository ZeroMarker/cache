editFun = function(dataStore,grid,pagingTool) {
	
	Ext.QuickTips.init();
  // pre-define fields in the form

	var rowObj = grid.getSelections();
	var len = rowObj.length;
	
	var unitsDr = "";
	var unitTypeDr = "";
	
	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		unitsDr = rowObj[0].get("rowId");
		unitTypeDr = rowObj[0].get("unitTypeDr");
	}

	var codeField = new Ext.form.TextField({
		id:'codeField',
    fieldLabel: '代码',
    allowBlank: false,
    emptyText:'单位代码...',
    name:'code',
    anchor: '95%'
	});

	var nameField = new Ext.form.TextField({
		id:'nameField',
    fieldLabel: '名称',
    allowBlank: false,
    emptyText:'单位名称...',
    name:'name',
    anchor: '95%'
	});
	
	var addressField = new Ext.form.TextField({
		id:'addressField',
    fieldLabel: '地址',
    allowBlank: true,
    emptyText:'单位地址...',
    name:'address',
    anchor: '95%'
	});
	
	var phoneField = new Ext.form.TextField({
		id:'phoneField',
    fieldLabel: '电话',
    allowBlank: true,
    emptyText:'单位电话...',
    name:'phone',
    anchor: '95%'
	});
		
	var contactField = new Ext.form.TextField({
		id:'contactField',
    fieldLabel: '联系人',
    allowBlank: true,
    emptyText:'单位联系人...',
    name:'contact',
    anchor: '95%'
	});

	var remarkField = new Ext.form.TextField({
		id:'remarkField',
    fieldLabel: '备注',
    allowBlank: true,
    emptyText:'单位备注...',
    name:'remark',
    anchor: '95%'
	});
	
	var activeField = new Ext.form.Checkbox({
		id: 'activeField',
		labelSeparator: '有效:',
    allowBlank: false,
    //name:'active',
		checked: (rowObj[0].data['active'])=='Y'?true:false
	});
	
	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 60,
    items: [
    				codeField,
            nameField,
            addressField,
            phoneField,
            contactField,
            remarkField,
            activeField
		]
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
		});
    
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '修改单位',
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
      		var phone  = phoneField.getValue();
      		var contact  = contactField.getValue();
          var remark  = remarkField.getValue();
      		var active = (activeField.getValue()==true)?'Y':'N';
      		//alert(active);
      		code = code.trim();
      		name = name.trim();
      		address = address.trim();
      		phone = phone.trim();
      		contact = contact.trim();
      		remark = remark.trim();
      		
      		if(unitTypeDr=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'单位类别未知!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(code=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'代码为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(name=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'名称为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: unitsUrl+'?action=edit&unitTypeDr='+unitTypeDr+'&id='+unitsDr+'&code='+code+'&name='+name+'&address='+address+'&phone='+phone+'&remark='+remark+'&contact='+contact+'&active='+active,
							//alert("asdffas");
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