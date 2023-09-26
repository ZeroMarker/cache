editOutFun = function(dataStore,grid,pagingTool) {
	
	Ext.QuickTips.init();
  // pre-define fields in the form

	var rowObj = grid.getSelections();
	var len = rowObj.length;
	
	var rowId = "";
	var parRef = "";
	var itemVal = "";
	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		rowId = rowObj[0].get("rowId");
		parRef = rowObj[0].get("parRef");
		itemVal = rowObj[0].get("itemDr");
		
	}

	var itemTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','shortcut','remark','order','active'])
	});
	var itemType = new Ext.form.ComboBox({
		id: 'itemType',
		fieldLabel: '���������',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: itemTypeDs,
		valueField: 'rowid',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ�����������...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: false
	});
	
	itemTypeDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.datalevelsetsexe.csp?action=listitemtype&searchvalue='+Ext.getCmp('itemType').getRawValue()+'&searchfield=shortcut',method:'POST'});
	});

	itemType.on("select",function(cmb,rec,id ){
		//alert("asdf");
		items.setRawValue("");
		items.setValue("");
		itemsDs.proxy=new Ext.data.HttpProxy({url:'dhc.ca.initemsexe.csp?action=listdataitems&itemtype='+itemType.getValue(),method:'GET'});
		itemsDs.load({params:{start:0, limit:cmb.pageSize}});
	});

	var itemsDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','itemDr','itemShortCut'])
	});
	
		
	itemsDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.initemsexe.csp?action=listdataitemstoo&itemtype='+itemType.getValue()+'&searchValue='+Ext.getCmp('items').getRawValue()+'&searchField=shortcut',method:'GET'});
	});
	
	var items = new Ext.form.ComboBox({
		id: 'items',
		fieldLabel: '������',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: itemsDs,
		valueField: 'itemDr',
		displayField: 'itemShortCut',
		triggerAction: 'all',
		emptyText:'ѡ��������...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: false
	});

	var orderField = new Ext.form.NumberField({
		id:'orderField',
    fieldLabel: '��Ŀ˳��',
    allowBlank: false,
    emptyText:'��Ŀ˳��...',
    name:'order',
    anchor: '95%'
	});
	
	var remarkField = new Ext.form.TextField({
		id:'remarkField',
    fieldLabel: '��Ŀ��ע',
    allowBlank: true,
    emptyText:'��Ŀ��ע...',
    name:'remark',
    anchor: '95%'
	});
/*
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 60,
    items: [
    	itemType,
			items,
    	orderField
		]
	});
	*/
	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 70,
    items: [
    	itemType,
			items,
    	orderField,
    	remarkField
		]
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
		});
    
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '�޸Ľӿ�������',
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
      		 //order = order.trim();
      		var remark = remarkField.getValue();     		
      		 //remark = remark.trim();
      		if(items.getValue()!=''){
      			itemVal = items.getValue();
      		}
        	//if (formPanel.form.isValid()) {
        	if (order!='') {
						Ext.Ajax.request({
							url: inItemsUrl+'?action=editout&rowid='+rowId+'&parRef='+parRef+'&order='+order+'&itemDr='+itemVal+'&remark='+remark,
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
									var message="SQLErr: "+jsonData.info;
									if(jsonData.info=='RepOrder') message='�������Ŀ˳���Ѿ�����!';
									if(jsonData.info=='RepItem') message='������������Ѿ�����!';
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