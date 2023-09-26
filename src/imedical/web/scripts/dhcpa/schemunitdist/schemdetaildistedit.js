editSchemDetailDistFun = function(dataStore,grid,pagingTool) {
	//alert(grid);
	var centergrid = Ext.getCmp('SchemDetailDistGrid1');
	var rowObj = centergrid.getSelectionModel().getSelections();
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

	var baseField = new Ext.form.TextField({
		id: 'baseField',
		fieldLabel: '���׼ֵ',
		//allowBlank: false,
		emptyText: '���׼ֵ...',
		name: 'baseValue',
		anchor: '90%'
	});

	var trageField = new Ext.form.TextField({
		id: 'trageField',
		fieldLabel: '��Ŀ��ֵ',
		//allowBlank: false,
		emptyText: '��Ŀ��ֵ...',
		name: 'trageValue',
		anchor: '90%'
	});

	var bestField = new Ext.form.TextField({
		id: 'bestField',
		fieldLabel: '�����ֵ',
		//allowBlank: false,
		emptyText: '�����ֵ...',
		name: 'bestValue',
		anchor: '90%'
	});

	var baseupField = new Ext.form.TextField({
		id: 'baseupField',
		fieldLabel: '���׼ֵ����',
		//allowBlank: false,
		emptyText: '���׼ֵ����...',
		name: 'baseup',
		anchor: '90%'
	});
	
	var trageupField = new Ext.form.TextField({
		id: 'trageupField',
		fieldLabel: '��Ŀ��ֵ����',
		//allowBlank: false,
		emptyText: '��Ŀ��ֵ����...',
		name: 'trageup',
		anchor: '90%'
	});

	if((extremum.getValue()=='H')||(extremum.getValue()=='L')){

	// create form panel
	var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			baseField,
            trageField,
			bestField
		]
	});
}
else{
   var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			baseField,
            trageField,
			bestField,
            baseupField,
			trageupField
		]
	});
}
	formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			baseField.setValue(rowObj[0].get("baseValue"));
			trageField.setValue(rowObj[0].get("trageValue"));
			bestField.setValue(rowObj[0].get("bestValue"));
			baseupField.setValue(rowObj[0].get("baseup"));
			trageupField.setValue(rowObj[0].get("trageup"));
		});
  
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '���ò���ֵ',
    width: 400,
    height:400,
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
      		var base=baseField.getValue();
            var trage=trageField.getValue();
			var best=bestField.getValue();
            
			var base=base.trim();
            var trage=trage.trim();
			var best=best.trim();
           
			var data = base+"^"+trage+"^"+best;
			
			if(extremum.getValue()=='M'){
			var baseup=baseupField.getValue();
			var trageup=trageupField.getValue();
           
			
			var baseup=baseup.trim();
            var trageup=trageup.trim();
		
			var data = data+"^"+baseup+"^"+trageup;
			}
     	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: 'dhc.pa.schemunitdistexe.csp?action=edit&data='+data+'&rowid='+myRowid,
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
							       Ext.Msg.show({title:'��ʾ',msg:'���óɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								    dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
									window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyRecData') message='���������Ϊ��!';
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