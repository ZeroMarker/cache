addInterLocFun = function(dataStore,grid,pagingTool) {

	if(interLocSetField.getValue()==""){
	   Ext.Msg.show({title:'��ʾ',msg:'��ѡ��ӿ���',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	   return false;
	}
	var jxUnitDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut'])
	});

	jxUnitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:InterLocUrl+'?action=getjxunit&str='+Ext.getCmp('jxUnitField').getRawValue(),method:'POST'})
	});

	var jxUnitField = new Ext.form.ComboBox({
		id: 'jxUnitField',
		fieldLabel:'���㵥Ԫ',
		allowBlank: false,
		store: jxUnitDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'',
		name: 'jxUnitField',
		minChars: 1,
		pageSize: 10,
		anchor: '90%',
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
	
	var orderField = new Ext.form.TextField({
		id: 'orderField',
		fieldLabel: '˳���',
		allowBlank: false,
		emptyText: '',
		anchor: '90%'
	});
	var codeField = new Ext.form.TextField({
		id: 'codeField',
		fieldLabel: '����',
		allowBlank: false,
		emptyText: '',
		anchor: '90%'
	});

	var nameField = new Ext.form.TextField({
		id: 'nameField',
		fieldLabel: '����',
		allowBlank: false,
		emptyText: '',
		anchor: '90%'
	}); 

	var patTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['I','סԺ'],['O','����'],['E','����']]
	});
	var patTypeField = new Ext.form.ComboBox({
		id: 'patTypeField',
		fieldLabel: '��������',
		selectOnFocus: true,
		allowBlank: false,
		store: patTypeStore,
		anchor: '90%',
		value:'', //Ĭ��ֵ
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'',
		mode: 'local', //����ģʽ
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '��ע',
		allowBlank: true,
		emptyText:'',
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
			jxUnitField,
			orderField,
			codeField,
            nameField,
			//patTypeField,
			remarkField
		]
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '��ӽӿڵ�Ԫ',
    width: 380,
    height:320,
    minWidth: 380,
    minHeight: 320,
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
			var jxUnit = jxUnitField.getValue();
			var order = orderField.getValue();
      		var code = codeField.getValue();
      		var name = nameField.getValue();
			var remark = remarkField.getValue();
		    //var patType = patTypeField.getValue();
			
      		code = code.trim();
      		name = name.trim();
			remark = remark.trim();   
            jxUnit = jxUnit.trim();
			order = order.trim();
			//patType = patType.trim();
        	var data = code+'^'+name+'^'+order+'^'+jxUnit+'^'+interLocSetField.getValue()+'^'+remark;
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
							url: InterLocUrl+'?action=add&data='+data,
							failure: function(result, request) {
								Ext.Msg.show({title:'��ʾ',msg:'����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'��ʾ',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
									//window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyRecData') message='����Ϊ��!';
									if(jsonData.info=='RepCode') message='���벻���ظ�!';
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