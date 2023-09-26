addRitemsFun = function(dataStore,grid,pagingTool,parRef) {
	Ext.QuickTips.init();
	var mainUrl = 'dhc.ca.ritemsexe.csp';	
	var trigger = new Ext.form.TriggerField({
		allowBlank:false,
		fieldLabel:'��Ŀ����',
		emptyText:'ѡ����Ŀ...'
	});
	
	var itemDr = '';

	var selectWindow = function(){
		
		var itemTypeDs = new Ext.data.Store({
			autoLoad: true,
			proxy: '',
			reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'},['shortcut','rowid'])
		});
		
		itemTypeDs.on(
			'beforeload',
			function(ds, o){
				ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.ritemsexe.csp?action=listItemType&searchField=shortcut&searchValue='+Ext.getCmp('itemTypeSelecter').getRawValue(), method:'GET'});
			}
		);
	  
		var itemTypeSelecter = new Ext.form.ComboBox({
			id:'itemTypeSelecter',
			fieldLabel:'��Ŀ����',
			store: itemTypeDs,
			valueField:'rowid',
			displayField:'shortcut',
			typeAhead:true,
			pageSize:10,
			minChars:1,
			width:150,
			listWidth:250,
			triggerAction:'all',
			emptyText:'ѡ����Ŀ...',
			allowBlank: false,
			selectOnFocus: true,
			forceSelection: true
		});
		
		itemTypeSelecter.on(
			"select",
			function(cmb,rec,id ){
				//itemDs.proxy = new Ext.data.HttpProxy({url:'dhc.ca.ritemsexe.csp?action=listItem&searchField=shortcut&searchValue='+Ext.getCmp('itemSelecter').getRawValue()+'&dataTypeDr='+Ext.getCmp('itemTypeSelecter').getValue(), method:'GET'});
				//itemDs.load({params:{start:0, limit:pagingTool.pageSize}});
				itemSelecter.setValue('');
			}
		);
		
		var itemDs = new Ext.data.Store({
			autoLoad: true,
			proxy: '',
			reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'},['itemShortCut','rowid','itemDr'])
		});
		
		itemDs.on(
			'beforeload',
			function(ds, o){
				ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.ritemsexe.csp?action=listItem&searchField=itemShortCut&searchValue='+Ext.getCmp('itemSelecter').getRawValue()+'&dataTypeDr='+Ext.getCmp('itemTypeSelecter').getValue(), method:'GET'});
			}
		);
	  
		var itemSelecter = new Ext.form.ComboBox({
			id:'itemSelecter',
			fieldLabel:'��Ŀ����',
			store: itemDs,
			valueField:'itemDr',
			displayField:'itemShortCut',
			typeAhead:true,
			pageSize:10,
			minChars:1,
			width:150,
			listWidth:250,
			triggerAction:'all',
			emptyText:'ѡ����Ŀ...',
			allowBlank: false,
			selectOnFocus: true,
			forceSelection: true
		});
			
		var formPanel = new Ext.form.FormPanel({
  		baseCls: 'x-plain',
  	  labelWidth: 60,
  	  items: [
				itemTypeSelecter,
  	    itemSelecter
			]
		});
		
		var window = new Ext.Window({
  		title: '�����Ŀ',
  	  width: 300,
  	  height:200,
  	  layout: 'fit',
  	  plain:true,
  	  modal:true,
  	  bodyStyle:'padding:5px;',
  	  buttonAlign:'center',
  	  items: formPanel,
  	  buttons: [{
  	  	text: 'ȷ��',
  	    handler: function() {
  	    	itemDr = itemSelecter.getValue();
  	    	trigger.setValue(Ext.get('itemSelecter').getValue());
  	    	window.close();
  	    }
  	  },
  	  {
				text: 'ȡ��',
  	    handler: function(){
  	    	window.close();
  	    }
  	  }]
		});
		window.show();
	};

	trigger.onTriggerClick = selectWindow;
	
	var orderField = new Ext.form.NumberField({
		id:'orderField',
    fieldLabel: '��Ŀ˳��',
    allowBlank: false,
    emptyText:'��Ŀ˳��...',
    anchor: '95%'
	});

	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 60,
    items: [
    	orderField,
      trigger
		]
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '��ӿ�����Ŀ',
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
				
        if (formPanel.form.isValid()) {
					Ext.Ajax.request({
						url: mainUrl+'?action=add&parRef='+parRef+'&itemDr='+itemDr+'&order='+order,
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
								if(jsonData.info=='RepItem') message='�������Ŀ�Ѿ�����!';
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