addFun = function(dataStore,grid,pagingTool) {
	Ext.QuickTips.init();

	var orderField = new Ext.form.NumberField({
		id:'orderField',
    fieldLabel: 'Ȩ��˳��',
    allowBlank: false,
    emptyText:'Ȩ��˳��...',
    anchor: '95%'
	});
	
	var nameField = new Ext.form.TextField({
		id:'nameField',
    fieldLabel: 'Ȩ������',
    allowBlank: false,
    emptyText:'Ȩ������...',
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
  	title: '���Ȩ��',
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
      	var order = orderField.getValue();
      	var name = nameField.getValue();
				order = order.trim();
				name = name.trim();
				
        if (formPanel.form.isValid()) {
					Ext.Ajax.request({
						url: mainUrl+'?action=add&parRef='+roleSelecter.getValue()+'&name='+name+'&order='+order,
						waitMsg:'������...',
						failure: function(result, request) {
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
					  	if (jsonData.success=='true') {
					  		Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
							}
							else
							{
								var message="SQLErr: "+jsonData.info;
								if(jsonData.info=='RepOrder') message='�����˳���Ѿ�����!';
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