editFun = function(dataStore,grid,pagingTool) {
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	
	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		myRowid = rowObj[0].get("rowid"); 
	}
	
	var orderField = new Ext.form.NumberField({
		id: 'orderField',
		fieldLabel: '���',
		allowDecimals:false,
		allowBlank: false,
		name: 'order',
		emptyText: '���...',
		anchor: '95%'
	});
	
	var codeField = new Ext.form.TextField({
		id: 'codeField',
		fieldLabel: '����',
		allowBlank: false,
		emptyText: '������...',
		name: 'code',
		anchor: '95%'
	});
	
	var nameField = new Ext.form.TextField({
		id: 'nameField',
		fieldLabel: '����',
		allowBlank: false,
		emptyText: '�������...',
		name: 'name',
		anchor: '95%'
	});
	
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '��ע',
		allowBlank: true,
		name: 'remark',
		emptyText: '��ע����...',
		anchor: '95%'
	});
	
	var unitField = new Ext.form.TextField({
		id: 'unitField',
		fieldLabel: '��λ',
		allowBlank: true,
		name: 'unit',
		emptyText: '��λ...',
		anchor: '95%'
	});
	
	var activeField = new Ext.form.Checkbox({
		id: 'activeFlag',
		labelSeparator: '��Ч:',
		allowBlank: false,
		checked: (rowObj[0].data['active'])=='Y'?true:false
	});
	
	
	
	// create form panel
	var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 40,
    items: [
    		orderField,
			codeField,
            nameField,
			unitField,
			remarkField,
            activeField
		]        
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
		});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '�޸�������',
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
			var unit = unitField.getValue();
      		var active = (activeField.getValue()==true)?'Y':'N';
      		
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
							url: AllDataItemsUrl+'?action=edit&id='+myRowid+'&order='+order+'&code='+code+'&name='+name+'&unit='+unit+'&remark='+remarkField.getValue()+'&active='+active,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {				
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
									window.close();
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