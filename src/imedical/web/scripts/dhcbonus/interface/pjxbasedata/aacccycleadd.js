addAAccCycleFun = function(dataStore,grid,pagingTool) {

	var codeField = new Ext.form.TextField({
		id: 'codeField',
		fieldLabel: '����',
		allowBlank: false,
		emptyText: '��Ӵ���...',
		anchor: '90%'
	});

	var nameField = new Ext.form.TextField({
		id: 'nameField',
		fieldLabel: '����',
		allowBlank: false,
		emptyText: '�������...',
		anchor: '90%'
	}); 

	
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '��ע',
		allowBlank: true,
		emptyText:'��ӱ�ע...',
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
  	title: '������',
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
    	text: '����',
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
								Ext.Msg.show({title:'��ʾ',msg:'����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'��ʾ',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
									window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyRecData') message='����Ϊ��!';
									if(jsonData.info=='RepCode') message='���벻���ظ�!';
									if(jsonData.info=='RepName') message='���Ʋ����ظ�!';
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