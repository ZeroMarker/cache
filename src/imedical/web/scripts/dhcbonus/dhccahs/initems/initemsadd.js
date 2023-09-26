addFun = function(dataStore,grid,pagingTool,inItemSetId) {
	Ext.QuickTips.init();

	var itemTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','order','code','name','shortcut','remark','active'])
	});
	var itemType = new Ext.form.ComboBox({
		id: 'itemType',
		fieldLabel: '���������',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		//autoWidth:true,
		store: itemTypeDs,
		valueField: 'rowid',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ�����������...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	
	itemTypeDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.datalevelsetsexe.csp?action=listdatatype&searchvalue='+Ext.getCmp('itemType').getRawValue()+'&searchfield=shortcut',method:'POST'});
		//zjw 20160828	ģ����ѯ
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
	
	//zjw 20160828	ģ����ѯ
		itemsDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.initemsexe.csp?action=listdataitems&itemtype='+itemType.getValue()+'&searchValue='+Ext.getCmp('items').getRawValue()+'&searchField=shortcut',method:'GET'});
	});

	//
	
	var items = new Ext.form.ComboBox({
		id: 'items',
		fieldLabel: '������Ŀ',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		autoWidth:true,
		store: itemsDs,
		valueField: 'itemDr',
		displayField: 'itemShortCut',
		triggerAction: 'all',
		emptyText:'ѡ����Ŀ...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	var orderField = new Ext.form.TextField({
		id:'orderField',
    fieldLabel: '˳��',
    autoWidth:true,
    allowBlank: false,
    emptyText:'��Ŀ˳��...',
    anchor: '90%'
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
	var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
		  labelWidth: 75,
		  layout: 'anchor',
		  items: [{
		  	id:'itemTypes',
		    xtype:'fieldset',
        autoHeight:true,
        defaults: {width: 210},
        defaultType: 'textfield',
        items :[
             itemType
		    ]
		  },{
		  	id:'allItems',
		    xtype:'fieldset',
		    checkboxToggle:true,
		    collapsed:true,
		    title: '�ض���Ŀ',
        autoHeight:true,
        defaults: {width: 210},
        //defaultType: 'textfield',
        items :[
            items,
  			  	orderField
		    ]}
		  ]
		});

  var window = new Ext.Window({
  	title: '��Ӻ�����Ŀ',
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
      
		if(formPanel.getComponent('allItems').collapsed==true){
      		//var dataType = itemType.getValue();
      		if(formPanel.getComponent('itemTypes').getComponent('itemType').getValue()!=""){
      			Ext.Ajax.request({
							url: inItemsUrl+'?action=addAll&itemtype='+formPanel.getComponent('itemTypes').getComponent('itemType').getValue()+'&inItemSetId='+inItemSetId,
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
									if(jsonData.info=='RepItem') message='����ĺ�����Ŀ�Ѿ�����!';
								  Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
      			/*Ext.Ajax.request({
							url: inItemsUrl+'?action=addAll&itemtype='+formPanel.getComponent('itemTypes').getComponent('itemType').getValue()+'&inItemSetId='+inItemSetId,
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
								  Ext.Msg.show({title:'����',msg:'����������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});*/
      		}else{
						Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ�����ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}      		
			}else{
      	
      		var order = orderField.getValue();
      		
      		order = order.trim();
        	if (formPanel.form.isValid()) {
				Ext.Ajax.request({
					url: inItemsUrl+'?action=add&items='+items.getValue()+'&order='+order+'&inItemSetId='+inItemSetId,
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
							if(jsonData.info=='RepItem') message='����ĺ�����Ŀ�Ѿ�����!';
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});		
        	}
        	else{
				Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ�����ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}                 	
 	   	}}},
    	{
    		text: 'ȡ��',
			handler: function(){window.close();}
      }]
    });

    window.show();
};