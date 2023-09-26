editFun = function(dataStore,grid,pagingTool) {
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	//alert(rowObj[0].get("remark"));
	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		myRowid = rowObj[0].get("rowId"); 
	}
	
	var orderField = new Ext.form.TextField({
		id: 'orderField',
    fieldLabel: '˳��',
    allowBlank: false,
    emptyText: '�ӿ���Ŀ��˳��...',
    name: 'order',
    anchor: '90%'
	});

	var codeField = new Ext.form.TextField({
		id: 'codeField',
    fieldLabel: '����',
    allowBlank: false,
    emptyText: '�ӿ���Ŀ�״���...',
    name: 'code',
    anchor: '90%'
	});
	
	var nameField = new Ext.form.TextField({
		id: 'nameField',
    fieldLabel: '����',
    allowBlank: false,
    emptyText: '�ӿ���Ŀ������...',
    name: 'name',
    anchor: '90%'
	});
	
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
    fieldLabel: '��ע',
    allowBlank: true,
    emptyText: '�ӿ���Ŀ�ױ�ע...',
    name: 'remark',
    anchor: '90%'
	});

	var activeField = new Ext.form.Checkbox({
		id: 'activeField',
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
            	remarkField,
            	activeField
		]
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);/////////////////////////////////
		});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '�޸Ľӿ���Ŀ����Ϣ',
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
      		var remark = remarkField.getValue();
      		var active = (activeField.getValue()==true)?'Y':'N';
      		order = order.trim();
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
							url: initemsetsUrl+'?action=edit&id='+myRowid+'&order='+order+'&code='+code+'&name='+name+'&remark='+remark+'&active='+active,
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
									if(jsonData.info=='RepOrder') message='�����˳���Ѿ�����!';
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