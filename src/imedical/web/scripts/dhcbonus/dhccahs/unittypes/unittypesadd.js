addFun = function(dataStore,grid,pagingTool) {

	var codeField = new Ext.form.TextField({
		id:'codeField',
    fieldLabel: '����',
    allowBlank: false,
    emptyText:'��λ������...',
    anchor: '95%'
	});

	var nameField = new Ext.form.TextField({
		id:'nameField',
    fieldLabel: '����',
    allowBlank: false,
    emptyText:'��λ�������...',
    anchor: '95%'
	});
	
		var remarkField = new Ext.form.TextField({
		id:'remarkField',
    fieldLabel: '��ע',
    allowBlank: true,
    emptyText:'��λ���ע...',
    anchor: '95%'
	});
	
	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 40,
    items: [
    				codeField,
            nameField,
            remarkField
		]
	});
    
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '���ӵ�λ�����Ϣ',
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
    	text: '����', 
      handler: function() {
      		// check form value
      		var code = codeField.getValue();
      		var name = nameField.getValue();
      		var remark = remarkField.getValue();
      		
      		code = code.trim();
      		name = name.trim();
      		remark = remark.trim();
      		
      		if(code=="")
      		{
      			Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(name=="")
      		{
      			Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: unittypesUrl+'?action=add&code='+code+'&name='+name+'&remark='+remark,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'���ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
									//window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='RepCode') message='����Ĵ����Ѿ�����!';
									if(jsonData.info=='RepName') message='����������Ѿ�����!';
								  Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
        	}
        	else{
						Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ�����ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}             
	    	}
    	},
    	{
				text: 'ȡ��',
        handler: function(){window.close();}
      }]
    });

    window.show();
};