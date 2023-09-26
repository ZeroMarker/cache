addMethodsFun = function(dataStore,grid,pagingTool,parRef,deptSetDr,layerDr) {
	
	if(layerDr=="")
	{
		Ext.Msg.show({title:'����',msg:'��ѡ��ֲ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		return;
	};

	var priorityField = new Ext.form.NumberField({
		id: 'priorityField',
		fieldLabel: '���ȼ�',
		allowDecimals:false,
		allowBlank: false,
		emptyText: '���ȼ�...',
		anchor: '90%'
	});
	
	
	var codeField = new Ext.form.TextField({
		id: 'codeField',
		fieldLabel: '����',
		allowBlank: false,
		emptyText: '����...',
		anchor: '90%'
	});

	var nameField = new Ext.form.TextField({
		id: 'nameField',
		fieldLabel: '����',
		allowBlank: false,
		emptyText: '����...',
		anchor: '90%'
	});
	
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '��ע',
		allowBlank: true,
		emptyText: '��ע...',
		anchor: '90%'
	});
	/**
	var deptSetDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['id','code','name','desc','remark','leaf','end','active','parent','uiProvider','order','recCost','hospDr','hospName','locDr'])
	});
	var deptSet = new Ext.form.ComboBox({
		id: 'deptSet',
		fieldLabel: '���ŷֲ���',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: deptSetDs,
		valueField: 'id',
		displayField: 'desc',
		triggerAction: 'all',
		emptyText:'���ŷֲ���...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	deptSetDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.costdistsetsexe.csp?action=listsub&id='+deptSetDr+'&searchField=desc&active=Y&searchValue='+Ext.getCmp('deptSet').getRawValue(),method:'GET'});
	});
	*/
	var itemsDs = new Ext.data.Store({
		autoLoad: true,
		proxy:"",                                                        
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','typeDr','typeName','typeShortCut','order','itemDr','itemCode','itemName','itemShortCut'])
	});

	itemsDs.on('beforeload',function(ds, o){           
		ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.dataitemcorresexe.csp?action=list&searchField=itemShortCut&searchValue='+Ext.getCmp('items').getRawValue()+'&dataTypeDr='+costId, method:'GET'});
	});

	var items = new Ext.form.ComboBox({
		id:'items',
		fieldLabel:'����ɱ���',
		store: itemsDs,
		valueField:'itemDr',
		displayField:'itemShortCut',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		anchor: '90%',
		listWidth:250,
		triggerAction:'all',
		emptyText:'ѡ������ɱ���...',
		allowBlank: true,
		selectOnFocus: true,
		forceSelection: true 
	});
	
	var paramDs = new Ext.data.Store({
		autoLoad: true,
		proxy:"",                                             
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','active'])
	});

	paramDs.on('beforeload',function(ds, o){           
		ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.accperiodexe.csp?action=list&searchField=shortcut&searchValue='+Ext.getCmp('params').getRawValue()+'&active=Y', method:'GET'});
	});

	var params = new Ext.form.ComboBox({
		id:'params',
		fieldLabel:'��������',
		store: paramDs,
		valueField:'rowId',
		displayField:'shortcut',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		anchor: '90%',
		listWidth:250,
		triggerAction:'all',
		emptyText:'ѡ���������...',
		allowBlank: false,
		selectOnFocus: true,
		forceSelection: true 
	});
	
	var ioFlagField = new Ext.form.Checkbox({
		id: 'ioFlagField',
		labelSeparator: '��֧���:',
		allowBlank: false
	});
	
	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			priorityField,
			//deptSet,
			codeField,
            nameField,
			items,
			params,
			ioFlagField
			
		]        
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '��̯�������',
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
			
			var priority = priorityField.getValue();
      		var code = codeField.getValue();
      		var name = nameField.getValue();
			//var layerDr= deptSet.getValue();
			var itemDr= items.getValue();
			var param= params.getValue();
			var ioFlag = (ioFlagField.getValue()==true)?'Y':'N';
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
							url: costDistSetsUrl+'?action=addMethod&priority='+priority+'&code='+code+'&name='+name+'&layerDr='+layerDr+'&deptSet='+deptSetDr+'&itemDr='+itemDr+'&param='+param+'&id='+parRef+'&ioFlag='+ioFlag,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									costDistSetsDs.setDefaultSort('rowid', 'desc');
									dataStore.load({params:{start:0, limit:pagingTool.pageSize,id:parRef,layerDr:layerDr}});
									//window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyCode') message='����Ϊ��!';
									if(jsonData.info=='EmptyName') message='����Ϊ��!';
									if(jsonData.info=='EmptyOrder') message='���Ϊ��!';
									if(jsonData.info=='RepCode') message='�����Ѿ�����!';
									if(jsonData.info=='RepName') message='�����Ѿ�����!';
									if(jsonData.info=='RepPriority') message='���ȼ��Ѿ�����!';
								  Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
        	}
        	else{
				Ext.Msg.show({title:'����', msg:'��ѡ�����ݺ��ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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