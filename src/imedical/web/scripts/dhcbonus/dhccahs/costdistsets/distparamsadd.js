addDistParamsFun = function(dataStore,grid,pagingTool,parRef,layerDr,deptLevelSetsDr,ioFlag) {
	
	var type="";
	var itemsDs = new Ext.data.Store({
		autoLoad: true,
		proxy:"",                                                        
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','typeDr','typeName','typeShortCut','order','itemDr','itemCode','itemName','itemShortCut'])
	});

	itemsDs.on('beforeload',function(ds, o){           
		ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.costdistsetsexe.csp?action=listItems&searchField=itemShortCut&searchValue='+Ext.getCmp('items').getRawValue()+'&id='+itemType.getValue()+'&parRef='+parRef+'&type='+type, method:'GET'});
	});

	var items = new Ext.form.ComboBox({
		id:'items',
		fieldLabel:'��̯����',
		store: itemsDs,
		valueField:'itemDr',
		displayField:'itemShortCut',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		anchor: '90%',
		listWidth:250,
		triggerAction:'all',
		emptyText:'ѡ���̯����...',
		allowBlank: false,
		selectOnFocus: true,
		forceSelection: true 
	});
	
	var itemTypeStore = "";
	if(ioFlag=="Y"){
		itemTypeStore=new Ext.data.SimpleStore({//�ɱ���̯�׳ɱ���̯�׾�Դ
			fields: ['type','rowid'],
			data : [['����',incomeId]]
		});
	}else{
		itemTypeStore=new Ext.data.SimpleStore({//�ɱ���̯�׳ɱ���̯�׾�Դ
			fields: ['type','rowid'],
			data : [['�ɱ�',costId],['����',incomeId],['����',paramId]]
		});
	}
	
	var itemType = new Ext.form.ComboBox({
		id: 'itemType',
		fieldLabel: '��̯��������',
		anchor: '90%',
		listWidth : 260,
		//hidden:true,
		allowBlank: false,
		store: itemTypeStore,
		valueField: 'rowid',
		displayField: 'type',
		triggerAction: 'all',
		emptyText:'��̯��������...',
		mode: 'local',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	var rightField = new Ext.form.NumberField({
		id: 'rightField',
		fieldLabel: 'Ȩ��',
		allowDecimals:true,
		allowBlank: false,
		emptyText: 'Ȩ��...',
		anchor: '90%'
	});
	itemType.on('select', function(combo,record,index){
		var tmpCombo=combo.getValue();
		if(tmpCombo==costId){type="cost";}
		if(tmpCombo==incomeId){type="income";}
		if(tmpCombo==paramId){type="param";}
		items.setValue("");
		items.setRawValue("");
		itemsDs.proxy = new Ext.data.HttpProxy({url:'dhc.ca.costdistsetsexe.csp?action=listItems&searchField=itemShortCut&searchValue='+Ext.getCmp('items').getRawValue()+'&id='+combo.getValue()+'&parRef='+parRef+'&type='+type, method:'GET'});
		itemsDs.load({params:{start:0, limit:combo.pageSize}});
		
	});	
	
	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			itemType,
			items,
			rightField
		]        
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '��̯�������',
    width: 400,
    height:200,
    minWidth: 400,
    minHeight: 200,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
    	text: '����', 
		handler: function() {
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: costDistSetsUrl+'?action=addDistParams&id='+parRef+'&itemDr='+items.getValue()+'&type='+type+'&rate='+rightField.getValue(),
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									items.setValue("");
									items.setRawValue("");
									itemsDs.load({params:{start:0, limit:items.pageSize}});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize,id:parRef,type:type}});
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