editInterLocFun = function(dataStore,grid,pagingTool) {
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
    
	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	if(interLocSetField.getValue()==""){
	   Ext.Msg.show({title:'��ʾ',msg:'��ѡ��ӿ���',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	   return false;
	}
	else
	{
		myRowid = rowObj[0].get("rowid");
	}
    var jxUnitDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut'])
	});

	jxUnitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:InterLocUrl+'?action=getjxunit',method:'POST'})
	});

	var jxUnitField = new Ext.form.ComboBox({
		id: 'jxUnitField',
		fieldLabel:'���˵�Ԫ',
		allowBlank: false,
		store: jxUnitDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'',
		valueNotFoundText:rowObj[0].get('jxUnitName'),
		//name: 'jxUnitField',
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
		emptyText: '����...',
		name: 'code',
		anchor: '90%'
	});

	var nameField = new Ext.form.TextField({
		id: 'nameField',
		fieldLabel: '����',
		allowBlank: false,
		emptyText: '����...',
		name: 'name',
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
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'ѡ��������...',
		valueNotFoundText:rowObj[0].get('patType'),
		mode: 'local', //����ģʽ
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	
    var remarkField = new Ext.form.TextField({
            id: 'remarkField',
            fieldLabel: '����',
            emptyText: '����...',
            name: 'desc',
            anchor: '90%'
        });


	var tieOffField = new Ext.form.Checkbox({
		id: 'tieOffField',
		fieldLabel:'��Ч��־',
		disabled:false,
		allowBlank: false,
		checked: (rowObj[0].data['active']) == 'Y' ? true : false
        
	});



	var flagPanel = new Ext.Panel({
			layout: 'column',
			border: false,
			//labelWidth: 80,
			baseCls: 'x-plain',
			defaults: {
				border: false,
				layout: 'form',
				baseCls: 'x-plain',
				//labelSeparator: ':',
				columnWidth: .3
			},
			items: [
				
				{
					items: tieOffField
				}
			]
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
			remarkField,
            flagPanel
			
		]
	});
	formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			jxUnitField.setValue(rowObj[0].get("jxUnitDr"));
			orderField.setValue(rowObj[0].get("order"));
			//patTypeField.setValue(rowObj[0].get("Type"));
			remarkField.setValue(rowObj[0].get("remark"));
		});
  
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '�޸ĺ��㵥Ԫ',
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
      		var jxUnit = Ext.getCmp('jxUnitField').getValue();
			var order = orderField.getValue();
      		var code = codeField.getValue();
      		var name = nameField.getValue();
			var remark = remarkField.getValue();
		    //var patType = patTypeField.getValue();
			var tieOff = (tieOffField.getValue()==true)?'Y':'N';
			
      		code = code.trim();
      		name = name.trim();
			remark = remark.trim();   
            jxUnit = jxUnit.trim();
			order = order.trim();
			//patType = patType.trim();
    
			var data = code+'^'+name+'^'+order+'^'+jxUnit+'^'+interLocSetField.getValue()+'^'+remark+'^'+tieOff;
            //alert(data);
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
//            if(tieOffField.getValue()==true)
//      		{
////      			codeField.disable();
////                nameField.disable();
////			    startDate.disable();
////			    endDate.disable();
////			    remarkField.disable();
//                Ext.Msg.show({title:'ע��',msg:'�����ʣ������޸�����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
//      			return;
//      		};
			
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: InterLocUrl+'?action=edit&data='+data+'&rowid='+myRowid,
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
									if(jsonData.info=='EmptyRecData') message='���������Ϊ��!';
									if(jsonData.info=='RepCode') message='����Ĵ����Ѿ�����!';
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