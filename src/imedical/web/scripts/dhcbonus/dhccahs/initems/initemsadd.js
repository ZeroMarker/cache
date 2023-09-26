addFun = function(dataStore,grid,pagingTool,inItemSetId) {
	Ext.QuickTips.init();

	var itemTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','order','code','name','shortcut','remark','active'])
	});
	var itemType = new Ext.form.ComboBox({
		id: 'itemType',
		fieldLabel: '数据项类别',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		//autoWidth:true,
		store: itemTypeDs,
		valueField: 'rowid',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择数据项类别...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	
	itemTypeDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.datalevelsetsexe.csp?action=listdatatype&searchvalue='+Ext.getCmp('itemType').getRawValue()+'&searchfield=shortcut',method:'POST'});
		//zjw 20160828	模糊查询
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
	
	//zjw 20160828	模糊查询
		itemsDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.initemsexe.csp?action=listdataitems&itemtype='+itemType.getValue()+'&searchValue='+Ext.getCmp('items').getRawValue()+'&searchField=shortcut',method:'GET'});
	});

	//
	
	var items = new Ext.form.ComboBox({
		id: 'items',
		fieldLabel: '核算项目',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		autoWidth:true,
		store: itemsDs,
		valueField: 'itemDr',
		displayField: 'itemShortCut',
		triggerAction: 'all',
		emptyText:'选择项目...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	var orderField = new Ext.form.TextField({
		id:'orderField',
    fieldLabel: '顺序',
    autoWidth:true,
    allowBlank: false,
    emptyText:'项目顺序...',
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
		    title: '特定项目',
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
  	title: '添加核算项目',
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
    	text: '保存', 
		handler: function() {
      
		if(formPanel.getComponent('allItems').collapsed==true){
      		//var dataType = itemType.getValue();
      		if(formPanel.getComponent('itemTypes').getComponent('itemType').getValue()!=""){
      			Ext.Ajax.request({
							url: inItemsUrl+'?action=addAll&itemtype='+formPanel.getComponent('itemTypes').getComponent('itemType').getValue()+'&inItemSetId='+inItemSetId,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
								}
								else
								{
									var message="SQLErr: "+jsonData.info;
									if(jsonData.info=='RepOrder') message='输入的顺序已经存在!';
									if(jsonData.info=='RepItem') message='输入的核算项目已经存在!';
								  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
      			/*Ext.Ajax.request({
							url: inItemsUrl+'?action=addAll&itemtype='+formPanel.getComponent('itemTypes').getComponent('itemType').getValue()+'&inItemSetId='+inItemSetId,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
								}
								else
								{
								  Ext.Msg.show({title:'错误',msg:'服务器错误',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});*/
      		}else{
						Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}      		
			}else{
      	
      		var order = orderField.getValue();
      		
      		order = order.trim();
        	if (formPanel.form.isValid()) {
				Ext.Ajax.request({
					url: inItemsUrl+'?action=add&items='+items.getValue()+'&order='+order+'&inItemSetId='+inItemSetId,
					waitMsg:'保存中...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
						  	Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
						}
						else
						{
							var message="SQLErr: "+jsonData.info;
							if(jsonData.info=='RepOrder') message='输入的顺序已经存在!';
							if(jsonData.info=='RepItem') message='输入的核算项目已经存在!';
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});		
        	}
        	else{
				Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}                 	
 	   	}}},
    	{
    		text: '取消',
			handler: function(){window.close();}
      }]
    });

    window.show();
};