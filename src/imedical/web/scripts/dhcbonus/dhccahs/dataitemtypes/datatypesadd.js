addFun = function(dataStore,grid,pagingTool) {
	
	var orderField = new Ext.form.NumberField({
		id: 'orderField',
		fieldLabel: '���',
		allowDecimals:false,
		allowBlank: false,
		emptyText: '���...',
		anchor: '95%'
	});
	
	
	var codeField = new Ext.form.TextField({
		id: 'codeField',
		fieldLabel: '����',
		allowBlank: false,
		emptyText: '������...',
		anchor: '95%'
	});

	var nameField = new Ext.form.TextField({
		id: 'nameField',
		fieldLabel: '����',
		allowBlank: false,
		emptyText: '�������...',
		anchor: '95%'
	});
	
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '��ע',
		allowBlank: true,
		emptyText: '��ע����...',
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
  	title: '����������',
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
			
			var order = orderField.getValue();
      		var code = codeField.getValue();
      		var name = nameField.getValue();

      		code = code.trim();
      		name = name.trim();
      		
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
							url: DataItemTypesUrl+'?action=add&order='+order+'&code='+code+'&name='+name+'&remark='+remarkField.getValue(),
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
									//window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyCode') message='����Ĵ���Ϊ��!';
									if(jsonData.info=='EmptyName') message='���������Ϊ��!';
									if(jsonData.info=='EmptyOrder') message='��������Ϊ��!';
									if(jsonData.info=='RepCode') message='����Ĵ����Ѿ�����!';
									if(jsonData.info=='RepName') message='����������Ѿ�����!';
									if(jsonData.info=='RepOrder') message='���������Ѿ�����!';
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