addDeptFun = function(dataStore,grid,pagingTool,parRef) {
	
	var unitDr=units.getValue();
	
	var deptDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
	});
	var dept = new Ext.form.ComboBox({
		id: 'dept',
		fieldLabel: '����',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: deptDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ����...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	deptDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=dept&searchValue='+Ext.getCmp('dept').getRawValue()+'&unitDr='+unitDr,method:'POST'});
	});
	
	var rateField = new Ext.form.NumberField({
		id: 'rateField',
		fieldLabel: '����',
		value:100,
		allowBlank: false,
		emptyText: '������ռ����...',
		anchor: '90%'
	});
	//----------------------------------
	Ext.Ajax.request({
		url: UnitPersonsUrl+'?action=checkOwn&parRef='+parRef,
		waitMsg:'������...',
		failure: function(result, request) {
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			var percent=jsonData.info;
			if (jsonData.success=='true') {
				ownField.disable(); 
			}else{
				ownField.setValue(true);
			}						
		},
		scope: this
	});
	//----------------------------------
	var ownField = new Ext.form.Checkbox({
		id: 'ownField',
		labelSeparator: '��������:',
		allowBlank: false,
		checked: false
	});
	
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 60,
		items: [
			dept,
			rateField,
			ownField
			
		]        
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '��ӵ�λ��Ա����',
    width: 400,
    height:200,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
    	text: '����', 
		handler: function() {
			var own = (ownField.getValue()==true)?'Y':'N';
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: encodeURI(UnitPersonsUrl+'?action=adddept&parRef='+parRef+'&dept='+dept.getValue()+'&rate='+rateField.getValue()+'&userId='+userId+'&own='+own),
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		//Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize,parRef:parRef}});
									ownField.disable(); 
									ownField.setValue(false);
									//___________________________________________________
									Ext.Ajax.request({
										url: UnitPersonsUrl+'?action=percent&id='+parRef,
										waitMsg:'������...',
										failure: function(result, request) {
											Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
										},
										success: function(result, request) {
											var jsonData = Ext.util.JSON.decode( result.responseText );
											var percent=jsonData.info;
											if (jsonData.success=='true') {
												if(percent!=100){
													Ext.Msg.show({title:'ע��',msg:'������Ϊ100%�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
												}
												
											}
											else
											{
												var message = "";
												message = "SQLErr: " + jsonData.info;
												if(jsonData.info=='RepDept') message='����Ĳ����Ѿ�����!';
												Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
											}
										},
									scope: this
									});
									//___________________________________________________
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='RepDept') message='����Ĵ����Ѿ�����!';
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